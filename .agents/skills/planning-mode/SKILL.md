---
name: task-planning
description: Use only when the user explicitly asks to plan first or includes this file in a promot. Plan non-trivial work before executing it. Apply before writing code, modifying files, creating artifacts, making state-changing tool calls, or otherwise carrying out the work.
---

# Task Planning

## Overview

Plan the work before performing it. Turn the request into an execution-ready sequence with clear scope, dependencies, outputs, and verification so the execution phase does not have to rediscover the approach.

Briefly announce, in the user's language, that the task will be planned before execution.

<HARD-GATE>
Do not begin implementation or execution until the plan is complete and has passed the self-review in this skill.

Before the gate is cleared, do not:
- write implementation code,
- modify project or user files,
- create final deliverables,
- make state-changing tool calls,
- perform irreversible actions,
- silently start parts of the requested work "while planning."

Read-only exploration needed to understand the task is allowed and encouraged.
</HARD-GATE>

## Choose Planning Depth

Classify the task before writing the plan. Scale the ceremony, not the planning gate.

### Lightweight
Use for a small, well-bounded, reversible task with few dependencies.
- Write a compact plan of roughly 3-6 steps.
- State the intended result and the verification method.
- Avoid unnecessary architecture or process discussion.

### Standard
Use for multi-step work involving several files, tools, sources, or deliverables.
- Map dependencies and affected areas.
- Break work into independently verifiable tasks.
- Include expected outputs and checks for each task.

### Deep
Use for architectural, cross-system, high-impact, expensive, risky, or highly ambiguous work.
- Inspect relevant context before committing to an approach.
- Identify assumptions, constraints, dependencies, failure modes, and rollback or recovery needs.
- Compare approaches when a design decision materially affects the result.
- Add explicit checkpoints before irreversible or consequential actions.

When uncertain between two levels, use the deeper level. If hidden complexity appears during execution, stop execution, update the plan, re-run self-review, then continue.

## Planning Workflow

Follow these steps in order.

### 1. Understand the requested outcome

Extract:
- the user's actual goal,
- required deliverables,
- constraints and preferences,
- success criteria,
- deadlines or sequencing requirements,
- actions that are explicitly out of scope.

Do not confuse the requested method with the underlying goal. Preserve explicit user constraints exactly.

### 2. Inspect available context

Before asking questions, inspect the context that can answer them:
- relevant files and folders,
- existing code or documents,
- prior conversation context,
- connected systems or read-only tool data,
- conventions already established by the project.

Follow existing patterns unless the task specifically requires changing them.

Ask a clarifying question only when a missing answer would materially change the plan and cannot be resolved from available context. If the task can be planned safely with a stated assumption, state the assumption instead of blocking progress.

### 3. Identify dependencies and uncertainty

List the things execution depends on, including:
- prerequisite information,
- files, systems, or tools,
- decisions that affect later steps,
- external dependencies,
- permissions or approvals,
- ordering constraints.

Separate known facts from assumptions. Do not hide uncertainty inside a confident-looking plan.

### 4. Map the work surface

Identify what will be touched before defining tasks.

For software work, map:
- files to create or modify,
- interfaces or data contracts,
- tests,
- configuration,
- documentation.

For research or analysis, map:
- questions to answer,
- sources or datasets to inspect,
- evidence required,
- synthesis method,
- output format.

For documents or creative artifacts, map:
- audience and purpose,
- source material,
- structure,
- artifact(s) to create,
- quality checks.

For tool or operational workflows, map:
- tools or systems involved,
- read actions versus write actions,
- state changes,
- validation and recovery steps.

### 5. Decompose into execution tasks

Make each task a coherent unit that produces a meaningful, independently checkable result.

A good task boundary lets a reviewer reasonably approve one task while rejecting or revising the next. Fold trivial setup into the task that needs it; do not create ceremony-only tasks.

Order tasks by dependency. Do not schedule a task before the information or output it consumes exists.

### 6. Make every task executable

For every task, specify:
- **Objective:** what this task accomplishes.
- **Inputs:** what it needs from the user, context, or earlier tasks.
- **Actions:** the concrete steps to perform.
- **Output:** the artifact, state, or decision produced.
- **Verification:** how to confirm the task succeeded.
- **Dependencies:** earlier tasks or external conditions it relies on, when relevant.

Use exact paths, commands, tool names, query targets, schemas, or acceptance criteria when they are known and useful.

For implementation-heavy work, make individual actions small enough to execute and verify without re-planning. Prefer a cycle such as:
1. establish or reproduce the current state,
2. make the smallest intended change,
3. run the focused verification,
4. fix failures,
5. run broader verification before moving on.

### 7. Define completion criteria

End the plan with concrete conditions for "done." Include the checks that matter for the task, such as:
- tests pass,
- output renders correctly,
- required sections exist,
- source claims are supported,
- state changes are confirmed,
- no unintended files or records changed,
- final artifact is available at the intended location.

### 8. Run self-review

Review the complete plan before execution. Fix issues inline.

Check:
1. **Goal coverage** — Does every requested outcome map to at least one task?
2. **Ordering** — Are dependencies satisfied before they are consumed?
3. **Specificity** — Could an executor follow each step without inventing missing details?
4. **Verification** — Does each meaningful task have a success check?
5. **Consistency** — Do names, paths, interfaces, formats, and assumptions stay consistent across tasks?
6. **Scope** — Does the plan avoid unrelated improvements and unnecessary work?
7. **Risk** — Are irreversible or consequential actions identified and gated appropriately?
8. **Placeholder scan** — Remove vague placeholders and deferred thinking.

Do not merely report self-review problems. Correct the plan before continuing.

## Plan Output Format

Use this structure by default. Compress it for Lightweight tasks and expand it for Deep tasks.

```markdown
# [Task Name] Plan

**Goal:** [One sentence describing the desired end state]

**Planning depth:** [Lightweight | Standard | Deep]

**Success criteria:**
- [Observable condition]
- [Observable condition]

**Constraints / assumptions:**
- [Constraint or explicit assumption]

**Work surface:**
- [Files, systems, sources, artifacts, or components affected]

## Task 1: [Outcome-oriented name]

**Objective:** [What this task accomplishes]
**Inputs:** [Required context or prior outputs]
**Dependencies:** [None or exact dependency]

- [ ] [Concrete action]
- [ ] [Concrete action]
- [ ] [Verification action]

**Output:** [Expected result]
**Verification:** [Exact success check]

## Task 2: [Outcome-oriented name]
...

## Final verification
- [ ] [End-to-end check]
- [ ] [Quality / regression / completeness check]
```

## No Placeholders

Do not write plan steps that merely postpone thinking. Treat these as planning failures:
- "TBD", "TODO", "figure this out later",
- "implement the feature" without describing the implementation path,
- "add validation" without stating what must be validated,
- "handle edge cases" without naming the relevant cases,
- "write tests" without defining what behavior must be tested,
- "check everything works" without an observable verification,
- "similar to the previous task" when later execution depends on exact details,
- references to files, functions, fields, tools, or artifacts that the plan never defines.

Replace vague language with the actual decision, action, or acceptance criterion whenever the necessary context is available.

## Save the Plan

After the plan passes self-review, save it as a Markdown file named `{taskName}-{dateTime}.md` before presenting it or starting execution. Use a short, lowercase kebab-case slug for `taskName` and the local timestamp in `YYYYMMDD-HHmmss` format for `dateTime` (for example, `add-db-status-20261003-143000.md`). Save the file in the project root, or in the current working directory if there is no project. The saved file must contain the complete, self-reviewed plan, including its task checkboxes and final verification.

## Execution Gate

After the plan has been saved:

- If the user asked only for a plan, stop after presenting the plan.
- If the user explicitly asked to approve the plan before execution, present the plan and wait for approval.
- If the next action is irreversible, destructive, externally consequential, or requires a user decision that cannot safely be inferred, present the relevant checkpoint and wait for the required confirmation.
- Otherwise, state that the plan is complete and begin executing it in order.

During execution:
- Follow the plan rather than improvising silently.
- Mark or report meaningful progress as tasks complete when useful.
- If reality invalidates the plan, stop at the affected point, revise the remaining plan, self-review the revision, and then resume.
- Do not preserve a bad plan merely for consistency.

## Red Flags

| Temptation | Correct behavior |
|---|---|
| "This is simple; I can just start." | Use a shorter plan, not no plan. |
| "I'll do the first step while I think." | Planning and execution are separate phases. Finish the plan first. |
| "The user gave a detailed prompt, so planning is unnecessary." | Convert the detail into an explicit execution sequence and verification criteria. |
| "I need to ask several questions before looking at context." | Inspect available context first; ask only questions that remain material. |
| "The plan says what to do, so verification is obvious." | State how success will be checked. |
| "I discovered extra work, but I'm nearly done." | Stop, update the plan, self-review, then continue. |
| "A vague step gives the executor flexibility." | Preserve flexibility in approach, not ambiguity in required outcomes. |

## Planning Principles

- Prefer the smallest plan that is still safe and execution-ready.
- Be explicit about dependencies, outputs, and verification.
- Keep scope tied to the user's goal.
- Follow existing project conventions when working in an established environment.
- Prefer reversible steps before irreversible ones.
- Make hidden assumptions visible.
- Separate exploration, planning, execution, and verification.
- Plan enough to reduce rework; do not turn planning into the work itself.