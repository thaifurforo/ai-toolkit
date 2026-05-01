---
name: harness-iteration
description: Use quando for analisar feedback de produção para planejar o próximo ciclo de desenvolvimento. Ativado por "analisar feedback", "próximo ciclo", "o que melhorar", "retrospectiva", "dados de uso". Esta etapa fecha o steering loop e reinicia o pipeline.
---

# Harness: Iteração com Feedback (Etapa 09)

**Persona:** Product analyst + tech lead.

## Integrações

> Verificar disponibilidade antes de usar (consultar `harness.config.yaml`).
> Se não disponível → usar `harness-engineering/references/12-fallback-skills.md`.

- **`brainstorming`** *(se disponível)* — para gerar hipóteses a partir dos dados; *fallback: `12-fallback-skills.md § brainstorming`*
- **`tlc-spec-driven`** *(se disponível)* — esta etapa reinicia `SPECIFY` → alimenta `harness-prd` ou `harness-tasks`

## Princípio Central: Steering Loop (padrão Fowler)

> **Se um problema aconteceu duas vezes, codifique a solução no harness.**
> Nunca deixe o mesmo erro acontecer uma terceira vez sem ter virado uma regra ou sensor.

Tanto erros de produção quanto erros do agente durante o desenvolvimento alimentam melhorias do harness.

## O Que Analisar

- Feedback qualitativo (tickets de suporte, NPS, entrevistas com usuários)
- Dados quantitativos (funis, analytics, eventos, heatmaps)
- Erros de produção (logs, taxas de erro, falhas mais frequentes)
- Erros do agente durante o desenvolvimento (o que deu errado repetidamente no pipeline?)
- Retrospectiva da equipe

## O Que Produzir

### 1. Top 5 Padrões de Feedback
Por padrão: título, frequência, evidências, tipo (Bug/UX/Feature request/Performance/Confusão de produto), impacto estimado.

### 2. Gap de Métricas vs. PRD Original
Tabela: Métrica | Meta | Real | Gap | Hipótese de causa raiz

### 3. Backlog Priorizado (top 5)
Por item: tipo, impacto no usuário, estimativa de esforço, hipótese, próximo passo (Quick fix / Nova US / Spike / Novo PRD).

### 4. Steering Loop — Melhorias do Harness
Para cada problema recorrente:
```
Problema recorrente: [descrição]
Ocorreu quantas vezes: [N]
Tipo de controle necessário:
  [ ] Guia (feedforward) — agente precisa de mais contexto antes de agir
  [ ] Sensor computacional — linter/teste/structural check
  [ ] Sensor inferencial — code review por IA com critério específico
  [ ] Documentação — algo que deveria estar em AGENTS.md ou .catalog/

Ação concreta:
  - Adicionar regra em AGENTS.md: "[regra]"
  - Criar/atualizar linter: "[regra com remediação inline]"
  - Adicionar teste estrutural: "[o que verificar]"
  - Atualizar .catalog/: "[o que documentar]"
```

### 5. Decisão de Rota

| Decisão | Quando | Próximo passo |
|---------|--------|---------------|
| 🔁 Iterar | Feature no caminho certo, ajustes incrementais | → `harness-tasks` com backlog priorizado |
| 🔄 Pivotar | Hipótese errada, precisa repensar | → `harness-prd` com aprendizados como contexto |
| ✅ Consolidar | Feature estável | → atualizar `.catalog/concerns.md` + próxima feature |

Se iterar ou pivotar: produzir uma **atualização de mini-PRD** com problema revisado, stories novas/alteradas, métricas revisadas.

## Saída Esperada

Padrões de feedback + gap de métricas + backlog + melhorias do harness + decisão de rota + mini-PRD se necessário.

## Reinício do Ciclo

🔁 Iterar → `harness-tasks`
🔄 Pivotar → `harness-prd`
✅ Consolidar → `.catalog/concerns.md` atualizado + próxima feature

---

**Template completo de prompt:** Ver `./prompt.md`
