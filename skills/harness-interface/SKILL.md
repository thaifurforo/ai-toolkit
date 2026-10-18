---
name: harness-interface
description: >
  Use quando for definir interface, design system, logo, UX/UI ou identidade visual de um
  projeto com superfície de UI. Ativado por "interface", "design system", "logo", "UX",
  "UI", "identidade visual", "mockup", "wireframe", "concept art". Invocar depois de
  harness-architecture e antes de harness-tasks. Pular para CLI, lib, API-only ou jobs
  sem UI. Se decisões de UX alterarem contratos, revisitar harness-architecture antes
  de seguir para tasks.
---

# Harness: Interface e Design System (Etapa 03)

**Persona:** Designer de produto / design systems com rigor de engenharia de contratos.

## Integrações

> Verificar disponibilidade antes de usar (consultar `harness.config.yaml`).
> Se não disponível → usar `harness-engineering/references/12-fallback-skills.md`.

- **`brainstorming`** *(se disponível)* — se a direção visual ainda está nebulosa; *fallback: `12-fallback-skills.md § brainstorming`*
- Ferramentas de geração de imagem do harness (`GenerateImage` / companion visual) — **gerar** logo, concept art, referências e mockups; não apenas descrever em texto
- **`mermaid-studio`** *(se disponível)* — fluxos de navegação / mapa de telas

## Quando Usar

Ativadores: "interface", "design system", "logo", "UX", "UI", "identidade visual", "mockup", "wireframe"

**Pule esta etapa** quando o projeto **não** tiver superfície de UI (CLI, biblioteca, API-only, job/batch, worker) → vá direto para `harness-tasks`.

**Requer:** PRD + arquitetura (`.catalog/architecture.md` / tech-solution) como entrada.

## O Que Produzir

1. **Identidade visual** — marca, tom, direção de logo (e variantes se aplicável)
2. **Design system** — tokens (cor, tipografia, espaçamento, radius, elevação); componentes base
3. **UX das telas/fluxos** principais do PRD — layout, hierarquia, navegação
4. **Estados** empty / loading / error por tela crítica
5. **Acessibilidade mínima** — contraste, foco, labels, redução de movimento quando relevante
6. **Assets visuais** (gerar arquivos, não só texto):
   - logo e variantes
   - imagens de referência / moodboard
   - concept art
   - ícones de marca quando fizer sentido
7. **Mockups / wireframes** das telas principais (estáticos ou links) para validar UX **antes** do breakdown de tasks
8. **Impactos em arquitetura/contratos** — lista explícita (ver gate abaixo)

## Gate: Interface → Arquitetura

Antes de avançar para `harness-tasks`, verifique:

| Impacto | Sim? |
|---------|------|
| Contratos de API / payloads mudaram por causa do UX? | |
| Novas rotas, deep links ou navegação alteram boundaries? | |
| Estado cliente vs servidor redistribuído? | |
| Auth, permissões ou fluxos multi-step mudam o backend? | |
| Boundaries UI ↔ Runtime / SSR-CSR / ownership de módulos mudaram? | |
| Componentes compartilhados viram pacote/módulo novo? | |

**Se qualquer item for sim:**
1. Listar o impacto no contrato/arquitetura
2. Invocar de novo `harness-architecture` (atualizar `.catalog/architecture.md`, contratos, ADRs)
3. Obter aprovação do usuário nessa revisão
4. Retomar esta skill se ainda houver gaps de interface
5. **Só então** seguir para `harness-tasks`

**Não** decompor tasks com contratos desatualizados.

## Saída Esperada

- `.catalog/interface.md` — decisões de UX/UI, fluxos, estados, a11y, impactos de contrato
- `.catalog/design-system.md` *(opcional se o design system for grande)* — tokens e componentes
- `.catalog/assets/interface/` — logo, concept art, referências, mockups; **cada asset linkado** em `interface.md`
- Tracking atualizado conforme `project_tracking.tool` quando aplicável — ver `harness-engineering/references/11-project-tracking.md`
- Para `project_tracking.tool: local`: `interface.md` (e refs a assets) em `[delivery_docs.path]/[level1-nome]/`

## Próximo Passo

- Se o gate de arquitetura disparou → `harness-architecture` (revisão), depois retomar se necessário
- Caso contrário → `harness-tasks` com PRD + arquitetura **atualizada** + interface/assets como contexto

---

**Template completo de prompt:** Ver `./prompt.md`
