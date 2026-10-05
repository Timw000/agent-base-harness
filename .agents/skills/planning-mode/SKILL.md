---
name: planning-mode
description: Use only when the user explicitly asks to plan first (for example "/plan", "plan this", "let's plan first") or includes this file in a prompt. Produces a system-aware, execution-ready plan as a handoff to another agent. Never implements the plan; the only permitted write is the plan file in `plans/`.
---

# Planning Mode

## Overview

Plan the work; do not perform it. Turn the request into a system-aware, execution-ready plan that another agent can implement without rediscovering the approach. Treat every requested change as a system change, not an isolated patch, and find the smallest implementation that stays coherent with the architecture, lifecycle, and future evolution of the system.

Briefly announce, in the user's language, that the task will be planned and handed off.

<HARD-GATE>
No implementation or execution happens in this skill.

Allowed:
- Read-only exploration: read files, search paths, symbols, text, diagnostics, tests, and existing patterns.
- Asking the user clarifying questions.
- Creating or updating the plan file in `plans/` (and creating `plans/` if it does not exist).
- Describing commands, tests, migrations, or steps that the implementing agent should run later.

Forbidden:
- Writing implementation code or modifying any file other than the plan file.
- Creating final deliverables, making state-changing tool calls, or performing irreversible actions.
- Running commands, scripts, Git operations, formatters, or generators that change state.
- Delegating to another agent to obtain write access or perform implementation.
- Silently starting parts of the requested work "while planning."

If an action would require writing anywhere else, do not perform it; record it as a step in the plan.
</HARD-GATE>

## Planning Doctrine

- **Think broadly, implement narrowly.** Analyze the surrounding system before deciding where the change belongs.
- **Every change has system implications.** Consider data flow, state ownership, interfaces, lifecycle, failure modes, and future extension.
- **Prefer authoritative, derivable designs.** If state or control flow can be derived from existing events, persisted state, shared protocols, or abstractions, prefer that over inventing new transient state.
- **Choose the smallest coherent solution.** Do not default to the smallest local patch if it distorts the architecture or adds hidden follow-on complexity.
- **Expand scope only when it simplifies the system.** Widen the change only when a local fix would create duplicated state, fragile coupling, or lifecycle mismatches.
- **Do not gold-plate.** Keep scope tied to the user's goal.

## Choose Planning Depth

Classify the task first. Scale the ceremony, not the gate. When uncertain, choose the deeper level.

- **Lightweight** — small, well-bounded, reversible. Compact plan of 1–3 tasks; skip sections that add nothing.
- **Standard** — several files, tools, or deliverables. Map dependencies and affected areas; break work into independently verifiable tasks.
- **Deep** — architectural, cross-system, risky, or ambiguous. Identify assumptions, failure modes, and rollback needs; compare approaches when a decision materially affects the result; add checkpoints before irreversible actions.

## Workflow

### 1. Understand the outcome

Extract the user's actual goal, required deliverables, constraints, success criteria, sequencing requirements, and what is explicitly out of scope. Do not confuse the requested method with the underlying goal. Preserve explicit user constraints exactly.

### 2. Explore

Explore before designing or asking questions.

- Read relevant files and understand existing patterns, architecture, and conventions.
- Trace the end-to-end flow, not just the local change point.
- Identify the source of truth, state ownership, subsystem boundaries, and invariants.
- Identify the lifecycle: trigger, processing, intermediate states, completion, side effects, failure, retry, and cleanup where applicable.
- Search for similar features and prior art.
- Inspect relevant tests and verification patterns.

### 3. Clarify

Ask only questions that would materially change the plan and cannot be answered from the codebase or existing context. If the task can be planned safely with a stated assumption, state the assumption instead of blocking. Separate known facts from assumptions.

### 4. Design

Consider both the most direct and the most system-coherent implementation. Choose the direct one only when it introduces no architectural distortion, duplicated state, fragile coupling, or lifecycle mismatch.

Before converging, answer:

1. What part of the system is actually changing?
2. What is the source of truth before and after?
3. What new state, transitions, or invariants are introduced?
4. What components, flows, or interfaces depend on this decision?
5. Does this duplicate logic or state anywhere?
6. Is there a more system-coherent place to implement this?
7. What is the smallest solution that keeps the system coherent?

### 5. Decompose into tasks

Make each task a coherent unit with an independently checkable result. A good boundary lets a reviewer approve one task while rejecting the next. Fold trivial setup into the task that needs it. Order tasks by dependency.

For each task, specify objective, inputs, dependencies, concrete actions, output, and verification. Use exact paths, commands, schemas, or acceptance criteria when known.

For implementation-heavy work, prefer the cycle: reproduce current state → make the smallest intended change → run focused verification → fix failures → run broader verification.

### 6. Self-review

Review the complete plan and fix issues inline — do not merely report them.

1. **Assumptions** — Re-read the critical files the design depends on and verify assumptions.
2. **Goal coverage** — Every requested outcome maps to at least one task, and the plan matches the user's intent.
3. **System impact** — Lifecycle, failure, and cleanup are covered; widened scope is justified by simpler system behavior.
4. **Ordering** — Dependencies are satisfied before they are consumed.
5. **Specificity** — An executor could follow each step without inventing missing details.
6. **Verification** — Every meaningful task has a success check.
7. **Consistency** — Names, paths, interfaces, and formats stay consistent across tasks.
8. **Risk** — Irreversible or consequential actions are identified and gated.
9. **No placeholders** — See below.

### No Placeholders

Treat these as planning failures and replace them with the actual decision, action, or acceptance criterion:

- "TBD", "TODO", "figure this out later"
- "implement the feature" without the implementation path
- "add validation" / "handle edge cases" / "write tests" without naming what
- "check everything works" without an observable check
- "similar to the previous task" when execution depends on exact details
- references to files, functions, or artifacts the plan never defines

## Plan Output Format

Compress for Lightweight, expand for Deep. Keep only the recommended approach, not every alternative considered.

```markdown
# Plan: <task title>

**Planning depth:** Lightweight | Standard | Deep
**Status:** Ready for review

## Summary
1–2 sentences on the task and the chosen approach.

## Success criteria
- <observable condition>

## Context
Key findings: existing patterns, relevant files, constraints, and assumptions.

## System Impact
Effects on source of truth, data flow, interfaces, lifecycle, and dependent parts of the system.

## Approach
The recommended design and why it is the smallest coherent solution.

## Changes
- `path/to/file` — what changes and why

## Task 1: <outcome-oriented name>
**Objective:** <what this accomplishes>
**Inputs / dependencies:** <required context or prior tasks>

- [ ] <concrete action>
- [ ] <verification action>

**Output:** <expected result>
**Verification:** <exact success check>

## Task 2: ...

## Final verification
- [ ] <end-to-end check>
- [ ] <regression / completeness check>
- [ ] No unintended files or records changed
```

## Save the Plan

After self-review, save the complete plan to `plans/{taskName}-{dateTime}.md` in the project root:

- `taskName`: short, lowercase kebab-case slug.
- `dateTime`: local timestamp in `YYYYMMDD-HHmmss` format.
- Example: `plans/add-db-status-20261003-143000.md`.

Create `plans/` if it does not exist. When revising a plan after user feedback, update the same file instead of creating a new one.

## Handoff — Never Implement

After saving:

1. Present the plan briefly and include the plan file path.
2. Stop. Do not start implementation.
3. User approval of the plan is not permission to implement. Implementation belongs to a separate agent or an explicit new request outside this skill.
4. If the user gives feedback, revise the same plan file and re-run self-review.

## Red Flags

| Temptation | Correct behavior |
|---|---|
| "This is simple; I can just start." | Use a shorter plan, not no plan — and still do not implement. |
| "I'll do the first step while I think." | Planning and execution are separate. This skill only plans. |
| "The user approved, so I can implement." | Approval ends planning. Hand off. |
| "I need to ask several questions first." | Explore context first; ask only what remains material. |
| "The smallest local patch is enough." | Check whether it distorts the system before choosing it. |
| "A vague step gives the executor flexibility." | Allow flexibility in approach, not ambiguity in outcomes. |
