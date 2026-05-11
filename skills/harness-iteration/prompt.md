# Prompt 09 — Iteração com Feedback (Steering Loop)

> **Skills Superpowers ([github.com/obra/superpowers](https://github.com/obra/superpowers), opcionais)**
> Skills especializadas instaláveis em `~/.claude/skills/` (Claude Code) ou `~/.agents/skills/` (demais agentes).
> - `brainstorming` — geração estruturada de hipóteses a partir dos dados de produção antes de decidir o próximo ciclo
> Sem ela, liste as hipóteses manualmente e priorize por impacto × esforço no prompt abaixo.

## Princípio: cada problema recorrente vira um guia ou sensor novo no harness

> **Integração com `tlc-spec-driven` (Tech Leads Club, opcional)**
> A skill [`tlc-spec-driven`](https://agent-skills.techleads.club) organiza o desenvolvimento em três fases: **SPECIFY → DESIGN → EXECUTE**.
> Esta etapa corresponde ao **reinício do ciclo em SPECIFY**: o feedback de produção alimenta um novo PRD ou refinamento de escopo.
> Sem a skill instalada, registre as melhorias identificadas no `harness.config.yaml` ou em um novo PRD.

---

## Contexto de uso

Este é o **steering loop** — o humano ajusta o harness a partir do que aprendeu em produção.
A saída deste prompt alimenta o próximo ciclo de development.

Regra de ouro: **se um problema aconteceu duas vezes, codifique a solução no harness.**
Nunca deixe o mesmo erro acontecer uma terceira vez sem ter virado uma regra ou sensor.

---

## Prompt

```
Você é um product analyst e tech lead com experiência em análise de feedback
e melhoria contínua de sistemas de desenvolvimento.

Analise os dados abaixo e produza insumos acionáveis para o próximo ciclo.

---
## CONTEXTO DA FEATURE

**Feature:** [nome]
**Lançamento:** [data]
**Período de análise:** [período]
**Versão:** [v1.X.0]

**Métricas de sucesso do PRD:**
| Métrica | Baseline | Meta | Resultado |
|---------|----------|------|-----------|
| [KPI] | X | Y | Z |

---
## DADOS DE FEEDBACK

**Qualitativos:**
[tickets de suporte, NPS, entrevistas, comentários de usuários]

**Quantitativos:**
[funil de uso, analytics, eventos, heatmaps]

**Erros de produção:**
[logs, Sentry — erros mais frequentes com contagem]

**Erros do agente durante o desenvolvimento:**
[o que deu errado no pipeline? o que o agente fez de errado repetidamente?]

**Retrospectiva da equipe:**
[o que funcionou, o que não funcionou, dívida técnica observada]
---

## O QUE PRODUZIR

### 1. Padrões de feedback (top 5)

Para cada padrão:
```
Padrão #[N]: [título]
Frequência: [contagem / % de usuários afetados]
Evidências: [2–3 citações ou dados]
Tipo: Bug | UX | Feature request | Performance | Confusão de produto
Impacto estimado: Alto / Médio / Baixo
```

### 2. Gap de métricas e hipóteses

| Métrica | Meta | Real | Gap | Hipótese de causa raiz |
|---------|------|------|-----|------------------------|

### 3. Backlog priorizado (top 5)

```
#[N] — [Título]
Tipo: Bug fix | UX | Nova feature | Débito técnico | Melhoria de harness
Impacto no usuário: Alto/Médio/Baixo
Esforço: P/M/G/XG
Hipótese: [por que isso vai mover a métrica X]
Próximo passo: Quick fix → T-XX | Nova US → US-XX | Spike | Novo PRD
```

### 4. STEERING LOOP — melhorias do harness

Esta seção é única nesta etapa. Para cada problema recorrente identificado
(tanto em produção quanto durante o desenvolvimento com o agente):

```
Problema recorrente: [descrição]
Ocorreu quantas vezes: [N]
Tipo de controle necessário:
  [ ] Guia (feedforward) — agente precisa de mais contexto antes de agir
  [ ] Sensor computacional — linter/teste/structural check
  [ ] Sensor inferencial — code review por IA com critério específico
  [ ] Documentação — algo que deveria estar em AGENTS.md ou .catalog/

Ação concreta:
  - [ ] Adicionar regra em AGENTS.md: "[regra]"
  - [ ] Criar/atualizar linter: "[regra de linting com remediação inline]"
  - [ ] Adicionar teste estrutural: "[o que verificar]"
  - [ ] Atualizar .catalog/: "[o que documentar]"
  - [ ] Novo sensor no CI: "[quando rodar, o que detectar]"
```

### 5. Decisão de rota

Baseado nos dados, recomende:

**🔁 Iterar** — feature no caminho certo, ajustes incrementais
- Volta ao Prompt 03 com backlog priorizado como novas tasks
- Atualiza o tracking configurado com novo agrupamento/backlog priorizado

**🔄 Pivotar** — hipótese errada, precisa repensar escopo
- Volta ao Prompt 01 com aprendizados como contexto do novo PRD
- Documente o que foi descartado e por quê (ADR de produto)

**✅ Consolidar** — feature estável
- Foco em escala, observabilidade e próxima feature
- Documente lições aprendidas em .catalog/concerns.md

### 6. Mini-PRD de atualização (se Iterar ou Pivotar)

```markdown
## Atualização v[X.Y] — [data]

### Problema revisado
[o que aprendemos que muda o problema original]

### User Stories novas/alteradas
US-[N+1]: [nova story com CA]

### Métricas revisadas
| Métrica | Meta anterior | Nova meta | Razão |
|---------|--------------|-----------|-------|

### O que NÃO mudamos e por quê
[explicação — evita regressão de produto]
```

---
## REGRAS

- Baseie conclusões nos dados fornecidos — nunca invente padrões
- Separe claramente evidência de hipótese
- Se dados insuficientes: sinalize quais métricas coletar antes de decidir
- Erros do agente são tão importantes quanto feedback de usuário — ambos viram melhorias de harness
- A seção de Steering Loop é obrigatória — é o que diferencia um time que evolui de um que repete os mesmos erros
```

---
## Saída esperada
Análise de padrões + gap de métricas + backlog + melhorias de harness (steering loop) +
decisão de rota + mini-PRD se necessário.

## Próximo passo
🔁 Iterar → Prompt 03 (Tasks)
🔄 Pivotar → Prompt 01 (PRD)
✅ Consolidar → .catalog/concerns.md atualizado + próxima feature
