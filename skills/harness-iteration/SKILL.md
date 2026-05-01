---
name: harness-iteration
description: Use when analyzing production feedback to plan the next development cycle. Triggers on "analisar feedback", "próximo ciclo", "o que melhorar", "retrospectiva", "dados de uso". This closes the steering loop and restarts the pipeline.
---

# Harness: Iteration with Feedback (Stage 09)

**Persona:** Product analyst + tech lead.

## Integrations

- **`brainstorming`** skill to generate hypotheses from data
- **TLC:** this stage restarts `SPECIFY` → feeds into `harness-prd` or `harness-tasks`

## Core Principle: Steering Loop (Fowler pattern)

> **If a problem happened twice, codify the fix in the harness.**
> Never let the same error happen a third time without it becoming a rule or sensor.

Both production errors AND agent development errors feed into harness improvements.

## What to Analyze

- Qualitative feedback (support tickets, NPS, user interviews)
- Quantitative data (funnels, analytics, events, heatmaps)
- Production errors (logs, error rates, most frequent failures)
- Agent errors during development (what went wrong repeatedly in the pipeline?)
- Team retrospective

## What to Produce

### 1. Top 5 Feedback Patterns
Per pattern: title, frequency, evidence, type (Bug/UX/Feature request/Performance/Product confusion), estimated impact.

### 2. Metrics Gap vs. Original PRD
Table: Metric | Goal | Real | Gap | Root cause hypothesis

### 3. Prioritized Backlog (top 5)
Per item: type, user impact, effort estimate, hypothesis, next step (Quick fix / New US / Spike / New PRD).

### 4. Steering Loop — Harness Improvements
For each recurring problem:
```
Problema recorrente: [description]
Ocorreu quantas vezes: [N]
Tipo de controle necessário:
  [ ] Guia (feedforward) — agent needs more context before acting
  [ ] Sensor computacional — linter/test/structural check
  [ ] Sensor inferencial — AI code review with specific criterion
  [ ] Documentação — something that should be in AGENTS.md or .catalog/

Ação concreta:
  - Add rule to AGENTS.md: "[rule]"
  - Create/update linter: "[rule with inline remediation]"
  - Add structural test: "[what to verify]"
  - Update .catalog/: "[what to document]"
```

### 5. Route Decision

| Decision | When | Next step |
|----------|------|-----------|
| 🔁 Iterar | Feature on track, incremental adjustments | → `harness-tasks` with prioritized backlog |
| 🔄 Pivotar | Wrong hypothesis, need rethinking | → `harness-prd` with learnings as context |
| ✅ Consolidar | Stable feature | → update `.catalog/concerns.md` + next feature |

If iterating or pivoting: produce a **mini-PRD update** with revised problem, new/changed stories, revised metrics.

## Expected Output

Feedback patterns + metrics gap + backlog + harness improvements + route decision + mini-PRD if needed.

## Cycle Restart

🔁 Iterar → `harness-tasks`
🔄 Pivotar → `harness-prd`
✅ Consolidar → `.catalog/concerns.md` updated + next feature

---

**Full prompt template:** See `./prompt.md`
