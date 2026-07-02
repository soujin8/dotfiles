---
name: grill-with-docs
description: Interview the user relentlessly about a plan or design, cross-checking it against the project's existing domain model (CONTEXT.md, ADRs), and write updates to those files the moment a term or decision crystallises. Use when the user wants their plan stress-tested against the project's own language and documented decisions, not just against logic alone — e.g. "grill me against our domain model", "check this against our ADRs", or any grill-me request where CONTEXT.md or docs/adr/ already exist.
---

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

Unlike `grill-me`, this session also cross-checks the plan against the project's documented domain model and writes updates to it inline. If no such documentation exists or the project doesn't warrant one, use `grill-me` instead.

</what-to-do>

<supporting-info>

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files lazily — only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md the moment a term resolves

A term is "resolved" when the user picks a definition or a canonical name during the conversation — don't wait for the whole plan to finish. The instant that happens, stop and edit `CONTEXT.md` before moving to the next question. Never batch edits for later.

Read [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md) before your first edit to `CONTEXT.md` in a session — it defines the file's structure, the single-vs-multi-context layout, and the writing rules. Follow it exactly; don't improvise a different structure.

`CONTEXT.md` is a glossary only — never write implementation details, specs, or scratch notes into it.

### Offer ADRs sparingly, write them the same way

Read [ADR-FORMAT.md](./ADR-FORMAT.md) when a decision feels significant — it defines the three-part test for whether a decision qualifies, the file template, and the numbering scheme. Apply its test before offering an ADR; don't create one on a hunch.

Once the user confirms a decision qualifies, create the ADR file immediately, following the template and numbering rules in that file.

</supporting-info>

<when-to-stop>

End the session once every branch of the plan's decision tree has a resolved answer and no open question remains. Before ending, confirm: every new or changed term is reflected in `CONTEXT.md`, and every qualifying decision has an ADR file. Summarize what was decided and which files were updated.

</when-to-stop>
