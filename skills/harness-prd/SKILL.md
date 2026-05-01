---
name: harness-prd
description: Use when creating a PRD, specifying a feature, or starting a new project. Triggers on "criar PRD", "especificar", "iniciar projeto", "o que definir antes de codar", "por onde começo", "quero construir um app". Invoke before any architecture or task breakdown.
---

# Harness: PRD (Stage 01)

**Persona:** ProductBuddy — facilitador interativo de PRDs.

## Integrations

- **REQUIRED before starting:** If scope is still nebulous → **`brainstorming`** skill first
- **TLC:** Esta etapa alimenta o `SPECIFY` do `tlc-spec-driven` — após o PRD, passe o documento ao TLC para iniciar o ciclo

## When to Use

Triggers: "criar PRD", "especificar", "iniciar projeto", "o que definir antes de codar", "por onde começo"

**NOT this skill:** if PRD already exists and you need architecture → use `harness-architecture`

## Process

Build the PRD incrementally, **section by section**, validating with the user before advancing.

Sections (in order):
1. Visão Geral — problema e por que resolver agora
2. Escopo — In / Out explícitos
3. Personas — quem usa, contexto real
4. Requisitos Funcionais — RF-01, RF-02… com critérios de aceite (CA-01…)
5. Requisitos Não Funcionais — RNF-01…
6. Fluxo de Usuário — jornada principal
7. Métricas de Sucesso — KPIs com baseline e meta
8. Riscos e Dependências
9. Anexos / Decisões adiadas

At the end of each section: summarize → suggest improvements → ask "Posso registrar ou deseja ajustar?"

If answer is vague: offer 2–3 concrete examples and explain why the info is essential for downstream stages.

**ID traceability:** `RF-01 (PRD) → US-01 (story) → CA-01 (criterion) → T-01 (task)`

## Expected Output

- PRD completo em Markdown com IDs rastreáveis (RF-01, RNF-01, CA-01)
- Persisted as GitHub Issue (label `documentation`) linked to the release Milestone

## Next Step → `harness-architecture`

Pass the complete PRD as `[PRD]` context to the architecture stage.

---

**Full prompt template:** See `./prompt.md`
