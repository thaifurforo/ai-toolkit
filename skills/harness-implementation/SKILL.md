---
name: harness-implementation
description: Use when implementing a technical task from the breakdown. Triggers on "implementar", "código", "implement T-XX", "executar task". One task per invocation. Requires PRD (relevant sections) + architecture + AGENTS.md as context.
---

# Harness: Implementation (Stage 04)

**Persona:** Engenheiro de software sênior.

## Integrations

- **`executing-plans`** skill to manage task-by-task execution
- **`test-driven-development`** skill — write tests first or alongside
- **`systematic-debugging`** skill if the task blocks for >2 attempts
- **`verification-before-completion`** skill before marking any task done
- **`using-git-worktrees`** for parallel work on independent tasks
- **Context7:** MANDATORY before using any external library — `resolve_library_id` → `get_library_docs`
- **TLC:** use `implement` trigger — TLC manages atomic commits and verification

## Before Any Code

> ⚠️ **Create the task branch first:**
> ```bash
> # No dependency → base on develop
> git checkout develop && git pull
> git checkout -b feature/T-[N]-descricao
>
> # With Depends: T-YY → base on dependency branch
> git checkout feature/T-YY
> git checkout -b feature/T-[N]-descricao
> ```
> One task = one branch. Never commit a task into another task's branch.

## Context Verification Chain

Before writing any code:
1. Codebase — does a similar pattern already exist? If so, follow it.
2. `AGENTS.md` and `.catalog/` — relevant conventions for this layer?
3. Context7: `resolve_library_id` → `get_library_docs` for each external lib
4. Web search — only if Context7 doesn't cover it

## Sprint Contract (Anthropic pattern)

Before coding, propose:
```
Vou implementar: [what will be built]
Arquivos afetados: [list]
Sucesso verificado por: [how to test CA-01, CA-02...]
Gate: [command]
Fora do escopo desta task: [what will NOT be done]
```
Wait for validation before proceeding.

## What to Produce

1. Complete code
2. Unit tests (TDD — write before or alongside)
3. Commit message (Conventional Commits)
4. Completion checklist: done when + gate executed

## Mandatory Annotations

```typescript
// TODO: clarificar com PM — [question about requirement]
// RISK: [identified technical risk]
// DEBT: [intentional technical debt — accepted because: reason]
// UNCERTAIN: [unverified API — confirm via Context7]
```

## Context Management

If context exceeds ~40% of window: write handoff to `.handoffs/handoff-T-[N].md` (JSON format) and restart.

## Expected Output

Code + tests + commit message + completion checklist + `.milestones/` updated.

## Next Step → `harness-code-review`

Before opening the PR. Use `requesting-code-review` from Superpowers.

---

**Full prompt template:** See `./prompt.md`
