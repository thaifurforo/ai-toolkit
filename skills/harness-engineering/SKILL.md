---
name: harness-engineering
description: >
  Pipeline completo de desenvolvimento de software com IA — PRD → Arquitetura → Tasks → Código → Review → Testes → Docs → CI/CD → Iteração.
  Baseado nas práticas de Harness Engineering da Anthropic, OpenAI e Thoughtworks/Martin Fowler:
  guias (feedforward) + sensores (feedback) que se auto-corrigem antes de chegar ao humano.
  Ative quando o usuário mencionar "criar PRD", "planejar feature", "iniciar projeto", "especificar",
  "arquitetura", "quebrar em tasks", "implementar", "code review", "gerar testes", "documentar",
  "CI/CD", "analisar feedback", "por onde começo", "como organizo o projeto com IA",
  "quero construir um app", "vamos iniciar", "quero desenvolver", ou qualquer combinação dessas ações.
  Combine com skills disponíveis (tlc-spec-driven, superpowers, context7) para máxima efetividade — verificar disponibilidade via `harness.config.yaml`.
---

# Harness Engineering

> "O gargalo nunca foi a capacidade do agente de escrever código — foi a falta de estrutura, ferramentas e mecanismos de feedback ao seu redor."
> — OpenAI Engineering Blog, 2026

Pipeline de desenvolvimento com IA que transforma uma ideia em software confiável, combinando **guias (feedforward)** e **sensores (feedback)** que permitem autocorreção antes de chegar ao humano.

---

## Modelo mental: Guias + Sensores

**Guias (feedforward — antes de agir):**
- O agente tem o contexto certo? (PRD, arquitetura, convenções)
- As restrições estão codificadas? (linters, tipos, estrutura de camadas)
- A documentação existe como sistema de record? (.catalog/, AGENTS.md)

**Sensores (feedback — após agir):**
- Computacionais: testes, linters, type check, análise estrutural (rápidos, determinísticos)
- Inferenciais: code review por IA, "LLM como juiz" (mais lentos, semânticos)

**Regra:** sensores computacionais rodam a cada commit. Sensores inferenciais rodam antes do PR e no pipeline.

---

## Sistema de IDs — fio de rastreabilidade

```
RF-01 (PRD) → US-01 (story) → CA-01 (critério) → T-01 (task) → teste que verifica CA-01
```

Nunca crie tasks sem RF. Nunca feche task sem gate verificado. Nunca abra PR sem CA validados.

---

## Documentação viva

```
AGENTS.md (≤100 linhas — tabela de roteamento)
  ↓ aponta para:
.catalog/                    ← fonte de verdade técnica (versionada no repositório)
[delivery_docs.path]/        ← documentação de entregas por [level1] (padrão: .milestones/)
Ferramenta de rastreamento   ← [level1] > [level2] > tasks (conforme project_tracking.tool)
Changelog                    ← release-please (se disponível) ou CHANGELOG.md manual
.handoffs/ (sessão)          ← handoffs inter-sessão apenas (temporário)
```

**Regra de ouro:** decisão técnica permanente → `.catalog/`. Planejamento e entregas → ferramenta de rastreamento + `[delivery_docs.path]/`.

**Templates canônicos** para `[delivery_docs.path]/`: `references/10-documentacao-entregas.md`  
**Como persistir por ferramenta:** `references/11-project-tracking.md`

---

## Pipeline de 9 etapas

Para cada etapa, invoque a skill correspondente:

| # | Etapa | Skill | Triggers |
|---|-------|-------|---------|
| 00 | Setup do Projeto | *(referência interna)* | primeira invocação sem `harness.config.yaml` |
| 01 | PRD | **`harness-prd`** | "criar PRD", "especificar", "iniciar projeto" |
| 02 | Arquitetura Técnica | **`harness-architecture`** | "arquitetura", "stack", "design técnico" |
| 03 | Breakdown de Tasks | **`harness-tasks`** | "quebrar em tasks", "planejar", "tasks" |
| 04 | Implementação | **`harness-implementation`** | "implementar", "código", "implement T-XX" |
| 05 | Code Review | **`harness-code-review`** | "revisar", "code review", "review do PR" |
| 06 | Testes | **`harness-testing`** | "gerar testes", "cobertura", "testar" |
| 07 | Documentação | **`harness-documentation`** | "documentar", "README", "atualizar catalog" |
| 08 | CI/CD | **`harness-cicd`** | "CI/CD", "pipeline", "deploy" |
| 09 | Iteração | **`harness-iteration`** | "analisar feedback", "próximo ciclo" |

Cada skill é **autossuficiente**: contém a persona, o processo detalhado e o prompt template em `./prompt.md`.

> **Etapa 00:** Se `harness.config.yaml` não existe → executar wizard em `references/00-setup-wizard.md` antes de prosseguir. Se existe → ler config e mapear variáveis antes de qualquer etapa.

---

## Skills complementares — verificar disponibilidade antes de cada etapa

> **Regra:** Verificar se a skill está disponível antes de invocar (consultar `harness.config.yaml`).
> Se não disponível → usar `references/12-fallback-skills.md` para o conteúdo equivalente.

### tlc-spec-driven *(se disponível — `skills.tlc_spec_driven: true`)*
- **Quando usar:** etapas 01 (SPECIFY), 02 (DESIGN), 03 (TASKS), 04–06 (EXECUTE)
- **Integração:** TLC fornece execução atômica com commits e critérios de verificação. Harness Engineering fornece os guias e sensores ao redor.
- **Fallback:** continuar o pipeline sem TLC — cada sub-skill define seus próprios gates

### context7-mcp *(se disponível — `skills.context7: true`)*
- **Quando usar:** sempre que o código usa uma biblioteca externa — antes de gerar qualquer implementação
- **Cadeia:** Codebase → .catalog/ + AGENTS.md → Context7 → Web search
- **Fallback:** `references/12-fallback-skills.md § context7`

### Superpowers *(se disponível — `skills.superpowers: true`)*

| Skill | Quando acionar | Fallback |
|-------|---------------|---------|
| `brainstorming` | Etapa 01/02 — escopo ainda indefinido | `12-fallback-skills.md § brainstorming` |
| `writing-plans` | Etapa 03 — criar o breakdown de tasks | `12-fallback-skills.md § writing-plans` |
| `executing-plans` | Etapa 04 — task por task | `12-fallback-skills.md § executing-plans` |
| `test-driven-development` | Etapa 04+06 | `12-fallback-skills.md § test-driven-development` |
| `requesting-code-review` | Etapa 05 — antes de abrir PR | `12-fallback-skills.md § requesting-code-review` |
| `receiving-code-review` | Etapa 05 — processar feedback | `12-fallback-skills.md § receiving-code-review` |
| `systematic-debugging` | Etapa 04 — quando uma task falha | `12-fallback-skills.md § systematic-debugging` |
| `verification-before-completion` | Etapa 04/05/06 | `12-fallback-skills.md § verification-before-completion` |
| `finishing-a-development-branch` | Após etapa 06 | `12-fallback-skills.md § finishing-a-development-branch` |
| `dispatching-parallel-agents` | Etapa 03/04 — tasks independentes | `12-fallback-skills.md § dispatching-parallel-agents` |
| `using-git-worktrees` | Etapa 04 — trabalho paralelo | *branches sequenciais* |

---

## Fluxos de uso

### Completo (feature nova — milestone com múltiplas USs)
```
01 PRD → 02 Arq → 03 Tasks + Docs de entrega →
  [por US, sequencial — nunca em paralelo]:
    04 Código → 05 Review → 06 Testes → 07 Docs
    ↓ PR aberto pelo agente
    ↓ humano revisa, aprova e mergea
    ↓ só então iniciar próxima US
→ 08 CI/CD → Deploy → 09 Iteração
```

### Rápido (bug fix / quick task)
```
TLC "quick fix" → 04 Código → gate → commit
```

### Paralelo (tasks independentes dentro de uma US)
```
03 Tasks → dispatching-parallel-agents → [04+05+06] × N tasks → 07 Docs → merge
```

> ⚠️ **Paralelismo só para tasks dentro de uma US — nunca para USs entre si.**

### Sequencial por US (obrigatório para milestones)

```
Para cada US do milestone (em ordem de dependência):
  1. 03 Docs criadas (user-story.md + tech-spec.md + changelog.md)
  2. 04 Código → 05 Review → 06 Testes → 07 Docs
  3. PR aberto pelo agente com descrição completa
  4. ⏸ PARAR — aguardar humano revisar, aprovar e mergear
  5. Só após merge confirmado → iniciar próxima US
```

### Release gate (merge develop → main)
```
05 Review ✅ → 06 Testes ✅ → 07 Docs ✅ → PR aberto → nonprd verificado → merge (humano)
```

> **🚫 RESTRIÇÃO ABSOLUTA:** O agente **NUNCA** faz merge de qualquer PR. Exclusivamente responsabilidade do usuário humano. Sem exceções.

---

## Princípios consolidados

1. **Harness antes de velocidade.** Defina restrições antes de liberar o agente.
2. **Computacional primeiro, inferencial sob demanda.** Testes, linters e type check rodam sempre. Code review por IA roda estrategicamente.
3. **Documentação como sistema de record.** Se não está em `.catalog/` ou no GitHub, não existe para o próximo agente.
4. **Linter com remediação inline.** A mensagem de erro deve ensinar como corrigir.
5. **Reset de contexto > compaction.** Acima de ~40% da janela, escreva handoff em JSON e reinicie.
6. **Steering loop contínuo.** Cada erro recorrente vira uma regra no harness.
7. **Topologia reduz variedade (Lei de Ashby).** Defina stack, padrão de camadas e estrutura de módulos antes de começar.

---

## PROJECT_CONTEXT.md — template

```markdown
# Contexto — [Nome]

## Stack
- Linguagem + versão:
- Framework backend:
- Framework frontend:
- Banco de dados:
- Deploy:
- Repositório:

## Camadas de dependência (ordem obrigatória)
Types → Config → Repository → Service → Runtime → UI

## Convenções
- Commits: Conventional Commits
- Linting: [ferramenta]
- Testes: [framework], cobertura mínima [X]%
- Branches: main / develop / feature/T-XX-descricao

## Skills instaladas
- [ ] tlc-spec-driven
- [ ] superpowers
- [ ] context7
- [ ] mermaid-studio

## Links
- Config: harness.config.yaml
- PRD: [delivery_docs.path]/[level1-nome]/prd.md
- Arquitetura: .catalog/architecture.md
- Riscos/Dívidas: .catalog/concerns.md
```

---

## Referências

| Arquivo | Conteúdo |
|---------|----------|
| `references/00-setup-wizard.md` | Wizard de setup: detecta config, faz perguntas, gera `harness.config.yaml` |
| `references/10-documentacao-entregas.md` | Templates canônicos: [level1].md, prd.md, tech-solution.md, user-story.md, tech-spec.md, changelog.md |
| `references/11-project-tracking.md` | Como persistir outputs por ferramenta; verificação de conectividade (CLI→MCP→API); fallback markdown |
| `references/12-fallback-skills.md` | Conteúdo condensado de 14 skills externas — usar quando a skill não estiver instalada |

---

## Fontes

- [Fowler/Böckeler — Harness Engineering for Coding Agent Users](https://martinfowler.com/articles/harness-engineering.html)
- [OpenAI — Harness Engineering: Leveraging Codex in an Agent-First World](https://openai.com/index/harness-engineering/)
- [Anthropic — Harness Design for Long-Running Application Development](https://www.anthropic.com/engineering/harness-design-long-running-apps)
