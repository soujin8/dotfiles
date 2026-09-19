---
name: gh-test-review
description: Review test code in a specified GitHub pull request and report gaps from general testing practice. Use when asked to review PR tests, test coverage, missing test cases, brittle tests, fixtures, assertions, CI confidence, or whether a GitHub PR's tests adequately verify the changed behavior. Works with GitHub PR URLs, owner/repo PR numbers, local checked-out PR branches, or fetched PR diffs.
---

# GitHub PR Test Review

## Workflow

1. Identify the target PR from the user request. Use the GitHub app when available for PR metadata, changed files, comments, and diffs. Use `gh` or local git commands when the GitHub app lacks the needed context or the repository is already checked out.
2. Read the PR title, description, changed production code, changed test code, and any linked issue or review context that explains intended behavior.
3. Build a concise behavior map: list the user-visible or domain behaviors changed by the PR, then list which test files and cases claim to cover each behavior.
4. Read `references/test-review-checklist.md` before writing findings. Apply the checklist as a lens, not as a form to mechanically fill.
5. Prioritize actionable findings about the tests. Focus on missing cases, weak assertions, brittle setup, poor isolation, nondeterminism, unclear intent, excessive coupling, and CI confidence gaps.
6. Avoid reviewing unrelated production design unless it directly affects testability or test correctness.

## Review Standards

Treat test review findings like code review findings:

- Lead with issues ordered by severity.
- Include precise file and line references when possible.
- Explain the risk: what bug could pass or what maintenance failure the current test invites.
- Suggest concrete fixes or additions, naming the behavior, input, state, assertion, fixture, or test boundary to change.
- Prefer a small number of high-signal findings over a checklist dump.
- Say clearly when no material test issues are found, and mention any residual uncertainty such as unavailable CI logs or untested external integration behavior.

## Output Shape

Use this shape unless the user asks for another format:

```markdown
**Findings**
- [P1/P2/P3] Short issue title - file:line
  Why it matters, what scenario is missed or weak, and how to fix or add a test.

**Coverage Map**
- Changed behavior: covered by `test_name`; gap if any.

**Notes**
- Any assumptions, unavailable context, or tests not run.
```

Use severity as follows:

- `P1`: A likely regression, false confidence, or high-impact behavior is not tested.
- `P2`: Meaningful gap, brittle test, weak assertion, or missing edge case that could let bugs through.
- `P3`: Maintainability, readability, naming, fixture quality, or minor coverage improvement.

## GitHub Context

When the PR is remote, gather enough context before judging:

- PR metadata: title, body, labels, linked issues when visible.
- Changed filenames and patch.
- Full contents of touched test files when patches are too narrow to understand setup.
- Existing nearby tests that show project conventions.
- CI failures or skipped tests only when the user asks or when the PR test quality depends on them.

If only a diff is available, state that the review is diff-scoped.
