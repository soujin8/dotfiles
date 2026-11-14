---
name: difit-review
description: Review a specific diff (branch, commit, or GitHub PR) and show the findings as comments inside difit, the local diff viewer. Explicit opt-in only — use when the user explicitly names difit, asks to open or annotate the review in the difit viewer, or invokes this skill by name. For ordinary requests to review code, diffs, commits, branches, or pull requests, review normally and respond in the conversation without launching difit.
---

# Difit Review

## When to Use This Skill

difit opens an external browser UI and starts a long-running local server, so launching it must be explicit opt-in:

- Use this skill only when the user explicitly names difit, asks to open, show, or annotate the review in the difit viewer, or invokes this skill by name.
- Do NOT use it for ordinary review requests such as "review these changes", "use the reviewer agent", "find problems in this diff", or "review this PR/commit/branch". Perform those reviews normally and report the findings in your response.
- When a request is ambiguous, prefer the non-difit review path.

## Overview

This skill launches a requested git diff in a viewer that is easy for humans to read. At the same time, the agent can attach arbitrary comments via the `--comment` option.
This comment mechanism is well suited for code review findings and code explanations.
Before running commands, choose `<difit-command>` using the following rule:

- If `command -v difit` succeeds, use `difit`.
- Otherwise, use `npx difit`.
- If falling back to `npx difit` would require network access in a sandboxed environment without network permission, request escalated permissions and user approval before running it.

## Steps

The final command typically looks like this:

```bash
<difit-command> <target> [compare-with] \
  --comment '{"type":"thread","filePath":"src/foobar.ts","position":{"side":"old","line":102},"body":"line 1\nline 2"}' \
  --comment '{"type":"thread","filePath":"src/example.ts","position":{"side":"new","line":{"start":36,"end":39}},"body":"Range comment for L36-L39"}'
```

The detailed procedure is as follows.

1. Identify the target diff and review its contents.

- Inspect the diff specified by the user. This may be a local git revision, a GitHub URL, a patch file, or something similar.
- Understand the diff normally, inspect surrounding code when needed, and think through the response required by the user's request, whether that is review findings, explanations, or something else.
- For PR reviews, inspect the PR locally and keep the review result limited to difit output. Do not post comments back to remote GitHub.

2. Attach the prepared comments and launch difit — or reuse a running server.

- **Reuse before launch**
  - Keep at most one live difit server per Git root and review target. Reuse the running server and tab for the requested target, including ones the user started.
  - Check `<difit-command> --version` and `<difit-command> comment --help`. If help lists `add` and `get`, use a read-only `comment get --port <port> --format json` to check server support, then add findings with `<difit-command> comment add --port <port> '<json>'` and read them back. The ordinary diff launcher help (`[commit-ish] [compare-with]`) means the subcommands are unavailable, as in difit 4.0.4.
  - If the CLI or server lacks support, explain the mismatch briefly and add the comments on the verified diff lines in the existing tab. Verify they appear. `--comment` imports at startup, so keep the running session and its existing comments intact.
  - For a new server that will handle repeat reviews, use `--keep-alive` or, if listed in `--help`, `--background`.
- **difit launch options**
  - Use `<difit-command> <target> [compare-with]` to specify the target diff.
  - For uncommitted changes use `<difit-command> .`, for working tree changes use `<difit-command> working`, and for staged changes use `<difit-command> staged`.
  - For stdin input, use a form such as `diff -u file1.txt file2.txt | <difit-command>`.
- **Comment arguments**
  - Use `type: "thread"` for each comment.
  - Write comment bodies in the language the user is using.
  - Use `position.side: "new"` for lines that exist on the target side of the diff.
  - Use `position.side: "old"` for lines that exist only on the deleted side.
  - Use range comments for issues that span multiple lines.
  - Never copy secrets, tokens, passwords, API keys, private keys, or other credential-like material from the diff into `--comment` bodies or any command-line arguments.
- **Additional argument for files not yet added to git**
  - For uncommitted changes, if you decide files not yet added to git should also appear in the diff, add `--include-untracked`.

3. Share the difit URL and finish the response.
   - If there were no comments to attach, explicitly say so.
   - No manual verification of the launched difit page is required.
