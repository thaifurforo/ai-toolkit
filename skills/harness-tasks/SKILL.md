---
name: harness-tasks
description: Use quando for decompor um PRD e arquitetura em user stories e tasks técnicas. Ativado por "quebrar em tasks", "planejar tasks", "breakdown", "sprint". Requer PRD + arquitetura como entrada.
---

# Harness: Breakdown de Tasks (Etapa 03)

**Persona:** Tech lead especialista em planejamento ágil.

## Integrações

> Verificar disponibilidade antes de usar (consultar `harness.config.yaml`).
> Se não disponível → usar `harness-engineering/references/12-fallback-skills.md`.

- **`writing-plans`** *(se disponível)* — estruturar e persistir o plano; *fallback: `12-fallback-skills.md § writing-plans`*
- **`dispatching-parallel-agents`** *(se disponível)* — para tasks independentes em paralelo; *fallback: `12-fallback-skills.md § dispatching-parallel-agents`*
- **`using-git-worktrees`** *(se disponível)* — quando múltiplos agentes rodam em paralelo; *fallback: branches sequenciais*
- **`tlc-spec-driven`** *(se disponível)* — auto-skip para 1–2 tasks óbvias

## Formato de User Story

```
ID: US-[N]  |  Requisito: RF-[N]
Como [persona], quero [ação], para que [benefício].
CA-01: [critério mensurável]
Estimativa: P/M/G/XG  |  Deps: US-XX ou nenhuma
```

## Formato de Task Técnica (compatível com TLC)

```
T-[N] | US-[N] | [Descrição]
Where:     [arquivo/módulo]
Done when: [condição objetiva]
Gate:      [comando: npm test / curl / etc.]
Depends:   [T-XX ou nenhuma]
Reuses:    [componente existente ou nada]
Parallel:  [sim/não]
```

## Regra de Branch por Dependência

| Situação | Base da branch | PR aponta para |
|---|---|---|
| T-XX sem dependência | `develop` | `develop` |
| T-XX com `Depends: T-YY` | `feature/T-YY` | `feature/T-YY` |
| T-YY foi mesclada em develop | `develop` (rebase) | `develop` |

## Estimativas

P = horas | M = 1–2 dias | G = 3–5 dias | XG = >5 dias (quebrar em tasks menores)

## Saída Esperada

- Hierarquia e rastreamento conforme `project_tracking.tool` — ver `harness-engineering/references/11-project-tracking.md`
- Documentação de entrega em `[delivery_docs.path]/` apenas quando `project_tracking.tool: local` ou fallback markdown

## Próximo Passo → `harness-implementation`

Uma task por vez. Contexto: PRD (seções relevantes) + arquitetura + AGENTS.md.

---

**Template completo de prompt:** Ver `./prompt.md`
