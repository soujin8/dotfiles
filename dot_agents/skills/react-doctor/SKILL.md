---
name: react-doctor
description: Scan a React codebase for security, performance, correctness, and architecture issues using the react-doctor CLI, and report a 0-100 health score with actionable diagnostics. Use after making React changes (finishing a feature, fixing a bug, or before review) to catch regressions early, and re-run after fixes to confirm the score improved.
version: 1.0.0
---

# React Doctor

Run `react-doctor` after touching React code to catch security, performance, correctness, and architecture issues before they land.

## Usage

Scan only what changed (fast, preferred after edits):

```bash
npx -y react-doctor@latest --scope changed --base main --verbose
```

Full scan of the project:

```bash
npx -y react-doctor@latest . --verbose
```

Machine-readable output (use when you need to parse results programmatically):

```bash
npx -y react-doctor@latest --json
```

Drill into a specific finding:

```bash
npx -y react-doctor@latest why <file>:<line>
```

## What to check

- Read the score and every diagnostic category shown (Security, Performance, Correctness, Architecture — filter with `--category <name>` if the output is noisy).
- Treat `error`-severity findings as blocking; fix these first.
- Use `why <file>:<line>` on anything unclear before changing code, so the fix addresses the actual rule rather than guessing.
- Do not silence findings with inline disables to raise the score; fix the underlying issue.

## Workflow

1. Run the scan (`--scope changed --base main` after edits, or a full scan for a broader review).
2. Fix `error`-severity issues first, then `warning`-severity ones.
3. Re-run the same command and confirm the score improved and previously reported issues are gone.
4. Report: the before/after score, and for each fixed issue — file:line, rule, and what changed.
