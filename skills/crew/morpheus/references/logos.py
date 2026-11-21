#!/usr/bin/env python3
"""
scripts/logos.py — Logos Inter-Agent Communication Channel (The Source <-> Morpheus)
Provides atomic read/write and passive polling on logos.json so both agents can
collaborate autonomously across separate runtimes without race conditions.

Features:
- Atomic writes (no truncated files or race conditions).
- Structured message preservation (FROM: / TO: / STATUS:).
- Cumulative history and iteration circuit-breaker.
- Virtual 'directiva' field that bypasses intermediate pause/wait notices.
"""

import argparse
import json
import os
import sys
import time
from datetime import datetime

DEFAULT_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "logos.json"))

DEFAULT_INITIAL_DATA = {
    "version": "1.0",
    "turno": "morpheus",
    "iteracion_actual": 0,
    "max_iteraciones": 10,
    "estado": "IN_PROGRESS",
    "requiere_firma_neo": False,
    "objetivo": "Autonomous work session",
    "ultimo_emisor": "neo",
    "mensaje": "FROM: Neo (Sovereign Level 2 Authority)\nTO: Morpheus (Captain of the Crew & Tech Lead)\nSTATUS: In Progress\nDETAILS:\n- Wake up session in the active project and report current task queue status.\nRECOMMENDED NEXT STEP: Morpheus reports status and yields turn on Logos to Neo.",
    "historial": [],
}

STATE_ALIASES = {
    "EN_PROGRESO": "IN_PROGRESS",
    "COMPLETADO": "COMPLETED",
    "PAUSA_NEO": "PAUSE_NEO",
    "BLOQUEADO": "BLOCKED",
    "APAGADO": "OFF",
}


def atomic_write(path, data):
    tmp_path = f"{path}.tmp.{os.getpid()}"
    with open(tmp_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.flush()
        os.fsync(f.fileno())
    os.replace(tmp_path, path)


def ensure_logos_exists(path):
    if not os.path.exists(path):
        atomic_write(path, DEFAULT_INITIAL_DATA)
        print(f"[logos] Auto-initialized logos.json at {path}")


def load_logos(path):
    ensure_logos_exists(path)
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except json.JSONDecodeError:
        return None


def cmd_init(args):
    data = {
        "version": "1.0",
        "turno": args.turno,
        "iteracion_actual": 0,
        "max_iteraciones": args.max_iter,
        "estado": "IN_PROGRESS",
        "requiere_firma_neo": False,
        "objetivo": args.objetivo,
        "ultimo_emisor": args.emisor,
        "mensaje": args.mensaje,
        "historial": [],
    }
    atomic_write(args.path, data)
    print(f"[logos] Channel initialized at {args.path}")
    print(f"[logos] Initial turn: {args.turno} | Max iterations: {args.max_iter}")


def _is_directive(msg):
    return (
        not msg.startswith("PAUSA_")
        and not msg.startswith("PAUSE_")
        and not msg.startswith("╔")
        and ("FROM:" in msg or "DE:" in msg)
    )


def cmd_read(args):
    data = load_logos(args.path)
    if not data:
        print(f"[logos] Error: {args.path} does not exist or is corrupted.", file=sys.stderr)
        sys.exit(1)
    if args.field:
        if args.field == "directiva":
            msg = data.get("mensaje", "")
            if _is_directive(msg):
                print(msg)
                return
            for h in reversed(data.get("historial", [])):
                m = h.get("mensaje", "")
                if _is_directive(m):
                    print(m)
                    return
            print(msg)
            return

        val = data.get(args.field)
        if isinstance(val, (dict, list)):
            print(json.dumps(val, indent=2, ensure_ascii=False))
        else:
            print(val)
    else:
        print(json.dumps(data, indent=2, ensure_ascii=False))


def cmd_write(args):
    data = load_logos(args.path)
    if not data:
        print(f"[logos] Error: {args.path} does not exist. Run 'init' first.", file=sys.stderr)
        sys.exit(1)

    previous_msg = data.get("mensaje", "")
    if previous_msg:
        historial = data.get("historial", [])
        last_hist = historial[-1].get("mensaje", "") if historial else ""
        is_duplicate = (previous_msg.strip() == last_hist.strip()) or (
            args.mensaje and args.mensaje.strip() == previous_msg.strip()
        )
        if not is_duplicate:
            historial.append({
                "timestamp": datetime.now().isoformat(),
                "iteracion": data.get("iteracion_actual", 0),
                "emisor": data.get("ultimo_emisor", "unknown"),
                "mensaje": previous_msg,
            })
            data["historial"] = historial

    if args.turno and args.turno != data.get("turno"):
        data["iteracion_actual"] = data.get("iteracion_actual", 0) + 1
        data["turno"] = args.turno
    if args.emisor:
        data["ultimo_emisor"] = args.emisor
    if args.mensaje is not None:
        data["mensaje"] = args.mensaje
    if args.estado:
        next_estado = STATE_ALIASES.get(args.estado, args.estado)
        if data.get("estado") == "PAUSE_TIMEOUT" and next_estado == "IN_PROGRESS" and str(args.emisor or "").lower() != "neo":
            print("[logos] Warning: channel is in 'PAUSE_TIMEOUT' (peer wait expired). Preserving PAUSE_TIMEOUT until Neo resumes.")
        else:
            data["estado"] = next_estado
    elif data.get("estado") == "PAUSE_TIMEOUT":
        if str(args.emisor or "").lower() == "neo":
            data["estado"] = "IN_PROGRESS"
        else:
            print("[logos] Warning: peer wait expired earlier (PAUSE_TIMEOUT). Do not launch wait; tell Neo to resume Source.")
    if args.requiere_firma is not None:
        data["requiere_firma_neo"] = args.requiere_firma

    if data.get("iteracion_actual", 0) >= data.get("max_iteraciones", 10):
        if data["estado"] in ("IN_PROGRESS", "EN_PROGRESO"):
            data["estado"] = "PAUSE_CIRCUIT_BREAKER"
            print(f"[logos] Max iterations ({data['max_iteraciones']}) reached. Pausing channel.")

    atomic_write(args.path, data)
    print(f"[logos] Turn updated to: {data['turno']} (Iteration {data['iteracion_actual']}/{data['max_iteraciones']})")
    print(f"[logos] Status: {data['estado']}")


def cmd_resume(args):
    data = load_logos(args.path)
    if not data:
        print(f"[logos] Error: {args.path} does not exist. Run 'init' first.", file=sys.stderr)
        sys.exit(1)
    prev = data.get("estado", "")
    data["estado"] = "IN_PROGRESS"
    if data.get("iteracion_actual", 0) >= data.get("max_iteraciones", 10):
        data["max_iteraciones"] = data.get("iteracion_actual", 0) + 20
    atomic_write(args.path, data)
    print(f"[logos] Resumed channel ({prev} -> IN_PROGRESS). Turn: {data.get('turno')} (Iteration {data.get('iteracion_actual')}/{data.get('max_iteraciones')})")


def cmd_wait(args):
    start = time.time()
    expected = args.esperar_a.lower()
    timeout = args.timeout
    interval = args.intervalo

    print(f"[logos] Waiting turn for '{expected}' (timeout: {timeout}s)...")
    while True:
        data = load_logos(args.path)
        if data:
            current_turn = str(data.get("turno", "")).lower()
            estado = data.get("estado", "")
            iter_curr = data.get("iteracion_actual", 0)
            max_iter = data.get("max_iteraciones", 10)

            morpheus_side = ["claude", "morpheus"]
            source_side = ["source", "gemini", "neo"]
            same_morpheus = expected in morpheus_side and current_turn in morpheus_side
            same_source = expected in source_side and current_turn in source_side
            if current_turn == expected or same_morpheus or same_source:
                print(f"[logos] Turn granted to '{expected}'! (Iteration {iter_curr}/{max_iter})")
                sys.exit(0)

            if estado in [
                "COMPLETED", "PAUSE_NEO", "PAUSE_CIRCUIT_BREAKER", "PAUSE_TIMEOUT", "OFF",
                "COMPLETADO", "PAUSA_NEO", "PAUSA_CIRCUIT_BREAKER", "APAGADO",
            ]:
                print(f"[LOGOS STOPPED] logos.json channel stopped with status: '{estado}'.")
                sys.exit(2)

            if iter_curr >= max_iter:
                print(f"[LOGOS STOPPED] Max iterations reached ({iter_curr}/{max_iter}). Stopping channel.")
                sys.exit(2)

        elapsed = time.time() - start
        if elapsed >= timeout:
            latest = load_logos(args.path)
            if latest and latest.get("estado") in ("IN_PROGRESS", "EN_PROGRESO"):
                latest["estado"] = "PAUSE_TIMEOUT"
                atomic_write(args.path, latest)
            print(
                f"[TIMEOUT] Wait timeout ({timeout}s) expired on logos.json waiting for '{expected}'. Channel marked 'PAUSE_TIMEOUT' so the peer stops cleanly.",
                file=sys.stderr,
            )
            sys.exit(1)

        time.sleep(interval)


def main():
    parser = argparse.ArgumentParser(description="Logos Inter-Agent Communication Channel")
    parser.add_argument("--path", default=DEFAULT_PATH, help=f"Path to logos.json (default: {DEFAULT_PATH})")
    subparsers = parser.add_subparsers(dest="subcmd", required=True)

    p_init = subparsers.add_parser("init", help="Initialize a new communication channel")
    p_init.add_argument("--turno", default="morpheus", choices=["claude", "morpheus", "gemini", "source", "neo"], help="Who holds the first turn")
    p_init.add_argument("--max-iter", type=int, default=10, help="Maximum allowed iterations")
    p_init.add_argument("--objetivo", required=True, help="Session objective")
    p_init.add_argument("--emisor", default="neo", help="Initial sender name")
    p_init.add_argument("--mensaje", default="", help="Initial message")

    p_read = subparsers.add_parser("read", help="Read current channel state")
    p_read.add_argument("--field", help="Specific field to extract (turno, mensaje, estado, directiva, etc.)")

    p_write = subparsers.add_parser("write", help="Update channel state")
    p_write.add_argument("--turno", choices=["claude", "morpheus", "gemini", "source", "neo"], help="Next turn holder")
    p_write.add_argument("--emisor", help="Sender character/agent name")
    p_write.add_argument("--mensaje", help="Message body")
    p_write.add_argument(
        "--estado",
        choices=[
            "IN_PROGRESS", "COMPLETED", "PAUSE_NEO", "PAUSE_TIMEOUT", "BLOCKED", "OFF",
            "EN_PROGRESO", "COMPLETADO", "PAUSA_NEO", "BLOQUEADO", "APAGADO",
        ],
        help="Cycle status",
    )
    p_write.add_argument("--requiere-firma", action=argparse.BooleanOptionalAction, default=None, help="Whether Neo signature is required")

    subparsers.add_parser("resume", help="Resume a paused/stopped channel back to IN_PROGRESS without altering turn or message")

    p_wait = subparsers.add_parser("wait", help="Passively wait for the specified turn")
    p_wait.add_argument("--for", dest="esperar_a", required=True, choices=["claude", "morpheus", "gemini", "source", "neo"], help="Turn to wait for")
    p_wait.add_argument("--timeout", type=int, default=1800, help="Max wait seconds (default: 1800s)")
    p_wait.add_argument("--intervalo", type=int, default=2, help="Polling interval in seconds (default: 2s)")

    args = parser.parse_args()
    if args.subcmd == "init":
        cmd_init(args)
    elif args.subcmd == "read":
        cmd_read(args)
    elif args.subcmd == "write":
        cmd_write(args)
    elif args.subcmd == "resume":
        cmd_resume(args)
    elif args.subcmd == "wait":
        cmd_wait(args)


if __name__ == "__main__":
    main()
