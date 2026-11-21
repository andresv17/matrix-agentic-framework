#!/usr/bin/env node
/**
 * Claude Code Stop hook for the Logos channel.
 * Ensures Morpheus never ends a turn silently without writing to logos.json
 * and launching `python3 scripts/logos.py wait --for morpheus` with run_in_background: true.
 */
import { execSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

let input = {};
try {
  if (!process.stdin.isTTY) {
    const raw = readFileSync(0, 'utf8').trim();
    if (raw) input = JSON.parse(raw);
  }
} catch {
  process.exit(0);
}

// Prevent infinite retry loops if a previous Stop hook already triggered once.
if (input.stop_hook_active) {
  process.exit(0);
}

const cwd = input.cwd || process.cwd();
const logosPath = join(cwd, 'logos.json');
if (!existsSync(logosPath)) {
  process.exit(0);
}

let logos;
try {
  logos = JSON.parse(readFileSync(logosPath, 'utf8'));
} catch {
  process.exit(0);
}

const estado = String(logos.estado || '').toUpperCase();
if (!['IN_PROGRESS', 'EN_PROGRESO'].includes(estado)) {
  process.exit(0);
}

const turno = String(logos.turno || '').toLowerCase();
const lastMsg = String(input.last_assistant_message || '');
const plainMsg = lastMsg.replace(/[*_`]/g, '');

// Only enforce this guard in sessions where Morpheus is the active role.
const fromMatch = lastMsg.match(/FROM:\s*([^\n]+)/i);
if (fromMatch && !/morpheus/i.test(fromMatch[1])) {
  process.exit(0);
}
if (input.transcript_path && existsSync(input.transcript_path)) {
  try {
    const transcript = readFileSync(input.transcript_path, 'utf8');
    if (!/skills[\\/]morpheus/i.test(transcript)) {
      process.exit(0);
    }
  } catch {
    // If transcript cannot be read, fall back to FROM check above
  }
}

const block = (reason) => {
  process.stdout.write(JSON.stringify({ decision: 'block', reason }));
  process.exit(0);
};

// Case 1: Morpheus yielded turn to Neo/Source, but forgot to launch `wait --for morpheus` in background.
if (['neo', 'source', 'gemini'].includes(turno)) {
  let waiterAlive = false;
  try {
    const out = execSync('pgrep -f "logos\\.py wait --for morpheus"', {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
    }).trim();
    waiterAlive = Boolean(out);
  } catch {
    waiterAlive = false;
  }

  if (!waiterAlive) {
    block(
      'Logos channel is active (turno=' +
        turno +
        ', estado=' +
        estado +
        '), but `python3 scripts/logos.py wait --for morpheus --timeout 1800` is NOT running in background. ' +
        'Run `python3 scripts/logos.py wait --for morpheus --timeout 1800` in a separate Bash tool call with `run_in_background: true` (never use `&`), ' +
        'append the `┌─ Note ─┐` wait banner, and then end your turn.'
    );
  }

  const isTerminalNotice = /^\[(TIMEOUT|LOGOS STOPPED)\]/m.test(lastMsg);
  const noteIdx = plainMsg.indexOf('┌─ Note');
  const nextStepIdx = plainMsg.search(/RECOMMENDED NEXT STEP:/i);
  const hasBanner = noteIdx !== -1;
  const hasEnvelope =
    /FROM:\s*Morpheus/i.test(plainMsg) &&
    /TO:\s*Neo/i.test(plainMsg) &&
    nextStepIdx !== -1;
  const bannerIsLast = hasBanner && hasEnvelope && nextStepIdx < noteIdx;

  if (!isTerminalNotice && (!hasBanner || !hasEnvelope || !bannerIsLast)) {
    block(
      'You yielded the Logos turn to `' +
        turno +
        '` and started the background wait, but your reply must include the complete `FROM: Morpheus / TO: Neo / STATUS: / DETAILS: / RECOMMENDED NEXT STEP:` block FIRST, followed by the `┌─ Note ─┐` wait banner at the very bottom (after `RECOMMENDED NEXT STEP:`). ' +
        'Re-output the full block with the `┌─ Note ─┐` banner strictly at the end, then end your turn.'
    );
  }
  process.exit(0);
}

// Case 2: Turn is still morpheus while Logos is IN_PROGRESS.
// Morpheus may only end a turn in turno=morpheus if it is waiting on a background Agent subagent.
if (['morpheus', 'claude'].includes(turno)) {
  if (/STATUS:\s*(Blocked|Validation Required)/i.test(plainMsg)) {
    block(
      'Logos channel is active (estado=' +
        estado +
        ') and your message reports `STATUS: Blocked` or `STATUS: Validation Required`, but `logos.json` still has `turno=morpheus`. ' +
        'Write your consolidated report with `python3 scripts/logos.py write --turno neo --emisor morpheus --mensaje "..."`, ' +
        'then launch `python3 scripts/logos.py wait --for morpheus --timeout 1800` in a separate Bash tool call with `run_in_background: true`, ' +
        'and close with the `┌─ Note ─┐` wait banner.'
    );
  }

  let waitingOnSubagent = /waiting for \d+ background agent/i.test(plainMsg);
  if (!waitingOnSubagent && input.transcript_path && existsSync(input.transcript_path)) {
    try {
      const lines = readFileSync(input.transcript_path, 'utf8').trim().split('\n');
      // Inspect current turn (lines since previous assistant end_turn)
      for (let i = lines.length - 1; i >= 0 && i >= lines.length - 40; i--) {
        const line = lines[i];
        if (line.includes('Async agent launched successfully') || line.includes('"name":"Agent"')) {
          waitingOnSubagent = true;
          break;
        }
        if (i < lines.length - 2 && line.includes('"stop_reason":"end_turn"')) {
          break;
        }
      }
    } catch {
      // Ignore transcript read errors
    }
  }

  if (!waitingOnSubagent) {
    block(
      'Logos channel is active (estado=' +
        estado +
        ', turno=morpheus), and you ended your turn without launching a background Agent and without yielding the turn to Neo. ' +
        'Do NOT stop idle: either dispatch the next crew subagent now, or write your report to Logos (`python3 scripts/logos.py write --turno neo ...`) + start `logos.py wait --for morpheus` in background.'
    );
  }
}

process.exit(0);
