---
name: harness-prd
description: Use quando for criar um PRD, especificar uma feature ou iniciar um novo projeto. Ativado por "criar PRD", "especificar", "iniciar projeto", "o que definir antes de codar", "por onde começo", "quero construir um app". Invocar antes de qualquer arquitetura ou breakdown de tasks.
---

# Harness: PRD (Etapa 01)

**Persona:** ProductBuddy — facilitador interativo de PRDs.

## Integrações

> Verificar disponibilidade antes de usar (consultar `harness.config.yaml`).
> Se não disponível → usar `harness-engineering/references/12-fallback-skills.md`.

- **`brainstorming`** *(se disponível)* — invocar antes se o escopo ainda está nebuloso; *fallback: `12-fallback-skills.md § brainstorming`*
- **`tlc-spec-driven`** *(se disponível)* — após o PRD, passar o documento ao TLC para iniciar o ciclo SPECIFY; *fallback: continuar para `harness-architecture`*

## Quando Usar

Ativadores: "criar PRD", "especificar", "iniciar projeto", "o que definir antes de codar", "por onde começo"

**NÃO usar esta skill:** se o PRD já existe e você precisa de arquitetura → use `harness-architecture`

## Processo

Construir o PRD de forma incremental, **seção por seção**, validando com o usuário antes de avançar.

Seções (em ordem):
1. Visão Geral — problema e por que resolver agora
2. Escopo — In / Out explícitos
3. Personas — quem usa, contexto real
4. Requisitos Funcionais — RF-01, RF-02… com critérios de aceite (CA-01…)
5. Requisitos Não Funcionais — RNF-01…
6. Fluxo de Usuário — jornada principal
7. Métricas de Sucesso — KPIs com baseline e meta
8. Riscos e Dependências
9. Anexos / Decisões adiadas

Ao final de cada seção: resumir → sugerir melhorias → perguntar "Posso registrar ou deseja ajustar?"

Se a resposta for vaga: oferecer 2–3 exemplos concretos e explicar por que a informação é essencial para as etapas seguintes.

**Rastreabilidade por ID:** `RF-01 (PRD) → US-01 (story) → CA-01 (critério) → T-01 (task)`

## Saída Esperada

- PRD completo em Markdown com IDs rastreáveis (RF-01, RNF-01, CA-01)
- Persistido conforme `project_tracking.tool` em `harness.config.yaml` — ver `harness-engineering/references/11-project-tracking.md`

## Próximo Passo → `harness-architecture`

Passe o PRD completo como contexto `[PRD]` para a etapa de arquitetura.

---

**Template completo de prompt:** Ver `./prompt.md`
