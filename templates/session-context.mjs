#!/usr/bin/env node
/**
 * Lightweight live memory hook for agent sessions (SessionStart / PreCompact).
 * Reads real disk state and injects it via stdout without modifying files or consuming external APIs.
 */
import { execSync } from 'node:child_process';
import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';

const root = process.cwd();
const safeRun = (cmd) => {
  try {
    return execSync(cmd, { cwd: root, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
  } catch {
    return '(not available)';
  }
};

const findBusFile = () => {
  const dirs = ['.', 'claude', 'agent-logs', 'docs'];
  for (const d of dirs) {
    const fullDir = join(root, d);
    if (!existsSync(fullDir)) continue;
    try {
      const files = readdirSync(fullDir);
      const match = files.find(f => (f.startsWith('registro-proceso') || f.startsWith('process-log')) && f.endsWith('.md'));
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
  console.log('[Matrix PreCompact] Context compaction imminent. Ensure your active checkpoint is persisted to your role log and central process log bus.');
  process.exit(0);
}

const branchStatus = safeRun('git status --short --branch');
const recentCommits = safeRun('git log -3 --oneline');
const envLessons = readTail('claude/environment-and-lessons.md', 40) ||
                   readTail('environment-and-lessons.md', 40) ||
                   readTail('claude/entorno-y-lecciones.md', 40) ||
                   readTail('entorno-y-lecciones.md', 40);
const busPath = findBusFile();
const busTail = readTail(busPath, 15);

console.log('=== [Matrix Live Memory — SessionStart] ===');
console.log('--- Git ---\n' + branchStatus + '\nRecent commits:\n' + recentCommits);
if (envLessons) console.log('\n--- Environment & Lessons ---\n' + envLessons);
if (busTail) console.log(`\n--- Latest entries from ${busPath} ---\n` + busTail);
console.log('============================================');
