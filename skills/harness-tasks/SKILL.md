---
name: harness-tasks
description: Use when breaking down a PRD and architecture into user stories and technical tasks. Triggers on "quebrar em tasks", "planejar tasks", "breakdown", "sprint". Requires PRD + architecture as input.
---

# Harness: Task Breakdown (Stage 03)

**Persona:** Tech lead especialista em planejamento ágil.

## Integrations

- **`writing-plans`** skill to structure and persist the plan
- **`dispatching-parallel-agents`** skill for independent parallel tasks
- **`using-git-worktrees`** when multiple agents run in parallel
- **TLC:** auto-skip for 1–2 obvious tasks

## User Story Format

```
ID: US-[N]  |  Requisito: RF-[N]
Como [persona], quero [ação], para que [benefício].
CA-01: [critério mensurável]
Estimativa: P/M/G/XG  |  Deps: US-XX ou nenhuma
```

## Technical Task Format (TLC-compatible)

```
T-[N] | US-[N] | [Descrição]
Where:     [arquivo/módulo]
Done when: [condição objetiva]
Gate:      [comando: npm test / curl / etc.]
Depends:   [T-XX ou nenhuma]
Reuses:    [componente existente ou nada]
Parallel:  [sim/não]
```

## Dependency → Branch Rule

| Situação | Base da branch | PR aponta para |
|---|---|---|
| T-XX sem dependência | `develop` | `develop` |
| T-XX com `Depends: T-YY` | `feature/T-YY` | `feature/T-YY` |
| T-YY foi mesclada em develop | `develop` (rebase) | `develop` |

## Estimates

P = hours | M = 1–2 days | G = 3–5 days | XG = >5 days (break it down)

## Expected Output

- GitHub Milestone for the release/feature-set
- Each User Story → GitHub Issue (label `user-story`) linked to Milestone
- Technical tasks (T-XX) → checklist in the Issue body
- GitHub Projects board updated
- `.milestones/[name]/milestone.md` + one folder per US with `user-story.md`, `tech-spec.md`, `changelog.md`

## Next Step → `harness-implementation`

One task at a time. Context: PRD (relevant sections) + architecture + AGENTS.md.

---

**Full prompt template:** See `./prompt.md`
