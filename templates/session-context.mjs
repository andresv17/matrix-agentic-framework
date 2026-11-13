#!/usr/bin/env node
/**
 * Hook ligero de memoria viva para sesiones de agentes (SessionStart / PreCompact).
 * Lee el estado real en disco y lo inyecta por stdout sin modificar archivos ni consumir APIs externas.
 */
import { execSync } from 'node:child_process';
import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';

const root = process.cwd();
const safeRun = (cmd) => {
  try {
    return execSync(cmd, { cwd: root, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
  } catch {
    return '(no disponible)';
  }
};

const findBusFile = () => {
  const dirs = ['.', 'claude', 'agent-logs', 'docs'];
  for (const d of dirs) {
    const fullDir = join(root, d);
    if (!existsSync(fullDir)) continue;
    try {
      const files = readdirSync(fullDir);
      const match = files.find(f => f.startsWith('registro-proceso') && f.endsWith('.md'));
      if (match) return join(d, match);
    } catch {}
  }
  return null;
};

const readTail = (relPath, maxLines) => {
  if (!relPath) return '';
  const full = join(root, relPath);
  if (!existsSync(full)) return '';
  const lines = readFileSync(full, 'utf8').trim().split('\n');
  return lines.slice(-maxLines).join('\n');
};

let hookEvent = 'SessionStart';
try {
  if (!process.stdin.isTTY) {
    const raw = readFileSync(0, 'utf8').trim();
    if (raw) hookEvent = JSON.parse(raw).hook_event_name ?? hookEvent;
  }
} catch {}

if (hookEvent === 'PreCompact') {
  console.log('[Matrix PreCompact] Contexto a punto de compactarse. Asegúrate de haber persistido el checkpoint actual en tu bitácora de rol y en el bus central de registro de proceso.');
  process.exit(0);
}

const branchStatus = safeRun('git status --short --branch');
const recentCommits = safeRun('git log -3 --oneline');
const envLessons = readTail('claude/entorno-y-lecciones.md', 40) || readTail('entorno-y-lecciones.md', 40);
const busPath = findBusFile();
const busTail = readTail(busPath, 15);

console.log('=== [Matrix Memoria Viva — SessionStart] ===');
console.log('--- Git ---\n' + branchStatus + '\nÚltimos commits:\n' + recentCommits);
if (envLessons) console.log('\n--- Entorno y Lecciones ---\n' + envLessons);
if (busTail) console.log(`\n--- Últimas entradas de ${busPath} ---\n` + busTail);
console.log('============================================');
