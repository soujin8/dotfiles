---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

This is a pure interview: no documentation is created or updated during the session. If the user wants decisions captured in `CONTEXT.md` or an ADR, use the `grill-with-docs` skill instead.

## How to ask

Ask one or two questions at a time, then wait for a response before continuing. Never dump the whole decision tree at once.

Order questions by dependency: resolve the branch that other decisions depend on first. If the answer to a question would change depending on an earlier unresolved decision, ask the earlier one first.

For each question, state your own recommended answer and a short reason. Let the user override it.

If a question can be answered by exploring the codebase, explore it instead of asking.

## When to dig deeper

Treat these as signals to follow up before moving to the next branch:

- The answer is vague or hedged ("probably", "I guess", "something like that")
- The answer contradicts an earlier answer or something visible in the code
- The answer only covers the happy path and leaves an edge case, error case, or concurrency case unaddressed
- The answer introduces a new term or concept without defining its boundaries

When any of these occur, ask a narrower follow-up question before moving on. Do not let a fuzzy answer stand as "resolved."

## When to stop

End the session once every branch of the decision tree has a concrete, non-contradictory answer and no open follow-up remains. Do not keep inventing new branches once the plan is fully specified — stop when the marginal question stops changing the design.

## Wrapping up

When ending, summarize the session as a flat list of resolved decisions (one line each: decision + chosen answer). Call out explicitly anything left unresolved and why (e.g., needs input from someone else, blocked on an experiment).
