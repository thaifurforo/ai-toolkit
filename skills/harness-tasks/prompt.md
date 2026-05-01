# Prompt 03 — Breakdown de Tasks

## Fase TLC: TASKS (auto-skip para 1–2 tasks óbvias)
## Superpowers: acione `writing-plans` para persistir em `.milestones/`
## Superpowers: identifique tasks paralelas → `dispatching-parallel-agents`

---

## Prompt

```
Você é um tech lead sênior especialista em planejamento ágil e decomposição de trabalho técnico.

Abaixo estão o PRD e a Arquitetura aprovados. Com base neles, crie o breakdown completo.

---
[PRD]
---
[ARQUITETURA TÉCNICA]
---

## 1. USER STORIES

```
ID: US-[N]
Requisito PRD: RF-[N]

Como [persona], quero [ação], para que [benefício].

CA-01: [critério mensurável e verificável]
CA-02: [critério mensurável e verificável]

Estimativa: P / M / G / XG
Dependências: US-XX ou "nenhuma"
```

---
## 2. TASKS TÉCNICAS POR STORY

```
T-[N] | US-[N] | [Descrição da task]
Where:     [arquivo/módulo a criar ou alterar — camada da arquitetura]
Done when: [condição objetiva de conclusão]
Gate:      [comando verificável: npm test / curl / npx dep-cruiser / etc.]
Depends:   [T-XX ou nenhuma]
Reuses:    [componente existente ou nada]
Parallel:  [sim/não — se sim, pode rodar com dispatching-parallel-agents]
```

---
## 4. MAPA DE DEPENDÊNCIAS

Represente as dependências entre tasks:

```mermaid
graph LR
  T01 --> T02
  T01 --> T03
  T02 --> T04
  T03 --> T04
```

**Regra de branch derivada do mapa de dependências:**

Cada task = uma branch `feature/T-XX-descricao`. A base da branch segue o mapa acima:

| Situação | Base da branch | PR aponta para |
|---|---|---|
| T-XX sem dependência | `develop` (ou `main`) | `develop` |
| T-XX com `Depends: T-YY` | `feature/T-YY` | `feature/T-YY` |
| T-YY foi mesclada em develop | `develop` (rebase) | `develop` |

**Comandos git por caso:**

```bash
# T-XX sem dependência
git checkout develop
git checkout -b feature/T-XX-descricao

# T-XX depende de T-YY (T-YY ainda não foi mesclada)
git checkout feature/T-YY
git checkout -b feature/T-XX-descricao

# T-YY foi mesclada; rebase de T-XX antes do PR final
git checkout feature/T-XX-descricao
git rebase develop
```

> **Atenção para tasks paralelas:** tasks marcadas `Parallel: sim` que não têm dependência entre si partem da mesma base (`develop`). Use `using-git-worktrees` do Superpowers para trabalhar nelas simultaneamente sem conflito de working tree.

**Worktrees para agents:** quando múltiplos agents ou subagentes executam tasks em paralelo, cada agent deve operar em um worktree separado para evitar conflitos de estado no working tree. Isso vale tanto para tasks independentes quanto para tasks encadeadas onde o agent da dependência ainda não concluiu:

```bash
# Criar worktree para cada task paralela
git worktree add ../projeto-T-04 feature/T-04-descricao
git worktree add ../projeto-T-05 feature/T-05-descricao

# Agent 1 opera em ../projeto-T-04
# Agent 2 opera em ../projeto-T-05 — sem conflito de working tree

# Limpar após merge
git worktree remove ../projeto-T-04
git worktree remove ../projeto-T-05
```

Use `using-git-worktrees` do Superpowers para o fluxo detalhado de setup.

---
## 5. ROADMAP DE EXECUÇÃO

Agrupe tasks por sprint respeitando dependências.
Marque tasks paralelas explicitamente:

```
Sprint 1 (fundação):
  Sequencial: T-01, T-02, T-03

Sprint 2 (core):
  Paralelo: T-04 ∥ T-05 ∥ T-06  ← usar dispatching-parallel-agents
  Após paralelo: T-07

Sprint 3 (entrega):
  Sequencial: T-08, T-09

Sprint 4 (polish):
  T-10 (review, testes, docs)
```

---
## 6. MILESTONE.MD (.milestones/[nome]/milestone.md)

> **Nota:** `prd.md` e `tech-solution.md` já foram gerados nas Etapas 01 e 02 respectivamente.
> Esta seção cria apenas o `milestone.md` (visão geral + USs + mapa de deps) e os arquivos por US.
> Não regere `prd.md` nem `tech-solution.md` nesta etapa — apenas referencie-os no milestone.md.

Gere o arquivo de milestone antes de iniciar qualquer implementação:

```markdown
# Milestone: [Nome] — [Versão/Identificador]

Status: in-progress
Criado: [YYYY-MM-DD]
Branch: `feature/[nome]` → `develop`
PRD: .milestones/[nome]/prd.md
Tech Solution: .milestones/[nome]/tech-solution.md

---

## User Stories

- [ ] US-01: [Nome] (T-01, T-02, T-03)
- [ ] US-02: [Nome] (T-04, T-05)
- [ ] US-03: [Nome] (T-06, T-07)

## Mapa de Dependências

```mermaid
graph TD
    T01[T-01 ...] --> T02[T-02 ...]
    T01 --> T03[T-03 ...]
    T02 --> T04[T-04 ...]
```
```

---
## 7. ARQUIVOS DE USER STORY (para cada US)

Crie um diretório `.milestones/[nome]/[US-XX-nome]/` por US e gere os três arquivos abaixo.

### user-story.md

```markdown
# [US-01] — [Título da User Story]

**Milestone:** [nome do milestone]
**Status:** ⏳ Pendente

## História

Como [persona],
quero [ação/funcionalidade],
para que [benefício/objetivo].

## Critérios de Aceite

- **CA-01:** [descrição]
- **CA-02:** [descrição]

## Fora do escopo
O que explicitamente não será coberto por essa US.

## Referências
- Milestone: `../milestone.md`
- Spec técnica: `./tech-spec.md`
```

### tech-spec.md

```markdown
# Spec Técnica — [US-01] [Título]

**Milestone:** [nome do milestone]
**Status:** ⏳ Pendente

## Contexto
Breve descrição técnica do que precisa ser construído para atender essa US.

## Solução

### Fluxo
[passos ou diagrama mermaid]

### Decisões técnicas

| Decisão | Alternativas consideradas | Motivo da escolha |
|---------|--------------------------|-------------------|
| | | |

## Tarefas

### T-01 — [Nome da Tarefa]
**Descrição:** O que deve ser implementado.
**Critérios de aceite relacionados:** CA-01, CA-02
**Where:** [arquivo/módulo]
**Done when:** [condição objetiva]
**Gate:** [comando verificável]

---

### T-02 — [Nome da Tarefa]
**Descrição:** O que deve ser implementado.
**Critérios de aceite relacionados:** CA-03
**Where:** [arquivo/módulo]
**Done when:** [condição objetiva]
**Gate:** [comando verificável]

---

## Impactos
- Partes do sistema afetadas
- Breaking changes?
- O que no `.catalog/` precisa ser atualizado após essa US?

## Referências
- User story: `./user-story.md`
- `.catalog/[arquivo-relevante].md`
```

### changelog.md

```markdown
# Changelog — US-01 - [Nome da User Story]

## [YYYY-MM-DD] — Início da entrega
Entrega iniciada com base em `user-story.md` e `tech-spec.md`.
```

---
## 6. PERSISTÊNCIA NO GITHUB

**Não use `.milestones/` como repositório de tasks — use GitHub Issues.**

Após gerar o breakdown, crie:

1. **GitHub Milestone** (um por release/feature-set):
   - Título: `v1.x — [nome da feature]`
   - Estado: Open (fecha automaticamente quando todas as Issues fecham)

2. **Issue de Tech Solution** (label: `documentation`, vinculada ao Milestone):
   - Body: decisões técnicas do breakdown, ADRs provisórios, riscos

3. **Uma Issue por User Story** (label: `user-story`, vinculada ao Milestone):
   - Body: story, CAs, tasks técnicas (T-XX) como checklist
   - `Closes #N` no PR que implementar a story fecha a Issue automaticamente

4. **GitHub Projects board** (se existir): adicione as Issues para visibilidade de progresso

**`.handoffs/`** → apenas para handoffs de sessão em andamento (temporário).

---
## REGRAS

- Toda task deve ter Done when objetivo — sem ambiguidade
- Toda task mapeia para um RF do PRD via sua US
- XG (>5 dias) → considere quebrar em tasks menores
- Tasks sem dependência entre si → marque Parallel: sim
- GitHub Issues substituem `.milestones/` como rastreabilidade permanente

## ESTIMATIVAS
P = horas | M = 1–2 dias | G = 3–5 dias | XG = >5 dias

---
## Saída esperada
Stories + tasks com rastreabilidade, estimativas e gates — persistidos como GitHub Issues vinculadas ao Milestone.

## Próximo passo → Prompt 04 (Código)
Use uma task por vez. Contexto: PRD + Arquitetura + AGENTS.md.

