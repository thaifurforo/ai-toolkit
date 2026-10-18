# Prompt 03 — Interface e Design System

> **Skills Superpowers ([github.com/obra/superpowers](https://github.com/obra/superpowers), opcionais)**
> Skills especializadas instaláveis em `~/.claude/skills/` (Claude Code) ou `~/.agents/skills/` (demais agentes).
> - `brainstorming` — explorar direção visual quando ainda há incerteza alta
> Sem ela, proponha 2–3 direções visuais diretamente no prompt abaixo.

> **Geração de assets**
> Use as ferramentas de imagem disponíveis no harness (`GenerateImage`, companion visual, etc.) para **gerar** logo, concept art, referências e mockups.
> Salve os arquivos em `.catalog/assets/interface/` e **linke-os** em `.catalog/interface.md`. Não substitua assets por descrições textuais quando a geração for possível.

> **Integração com `tlc-spec-driven` (Tech Leads Club, opcional)**
> Esta etapa fica **entre DESIGN (arquitetura) e EXECUTE (tasks)**.
> Auto-skip se o projeto não tiver UI → vá direto para `harness-tasks`.

---

## Prompt

```
Você é um designer de produto / design systems sênior com rigor de engenharia de contratos.
Você define identidade visual, design system e UX de forma que o próximo agente consiga
quebrar o trabalho em tasks sem reinventar a interface — e você sinaliza quando o UX
obriga a mudar a arquitetura.

Abaixo estão o PRD e a Arquitetura aprovados. Com base neles, defina a interface completa.

---
[PRD]
---
[ARQUITETURA TÉCNICA]
---

## 0. GATE DE APLICABILIDADE

O projeto tem superfície de UI (web, mobile, desktop, dashboard, landing, etc.)?

- Se NÃO → diga "Sem UI — pular para harness-tasks" e pare.
- Se SIM → continue.

---
## 1. IDENTIDADE VISUAL

- Nome / marca em destaque
- Tom (ex.: preciso, acolhedor, técnico)
- Direção de logo (conceito + variantes: full, mark, mono)
- Paleta inicial e tipografia de marca (antes dos tokens de produto)

Gere assets de logo/concept art quando possível e salve em:
`.catalog/assets/interface/`

---
## 2. DESIGN SYSTEM (TOKENS + BASE)

| Token | Valor | Uso |
|-------|-------|-----|
| Cor primária | | |
| Cor superfície / fundo | | |
| Tipografia display | | |
| Tipografia corpo | | |
| Espaçamento base | | |
| Radius | | |

Componentes base (lista mínima): Button, Input, Link, Heading, Surface — sem cards decorativos no hero se o produto for landing/marketing.

Documente em `.catalog/interface.md` e, se longo, em `.catalog/design-system.md`.

---
## 3. MAPA DE TELAS / FLUXOS

Para cada fluxo principal do PRD:

| Tela | Objetivo | Entrada | Saída | Estados |
|------|----------|---------|-------|---------|
| | | | | empty / loading / error |

Diagrama de navegação (Mermaid) quando ajudar.

---
## 4. UX POR TELA CRÍTICA

Para cada tela prioritária:
- Hierarquia (marca → headline → apoio → CTA — quando for hero)
- Layout desktop + mobile
- Conteúdo real (sem lorem)
- Mockup ou wireframe — **gerar asset** e linkar

---
## 5. ACESSIBILIDADE MÍNIMA

- Contraste
- Foco visível
- Labels / nomes acessíveis
- Redução de movimento quando houver animação

---
## 6. ASSETS A GERAR

Checklist (marque e anexe paths):

- [ ] Logo (full / mark / mono) → `.catalog/assets/interface/`
- [ ] Concept art / moodboard de referência
- [ ] Mockups das telas principais
- [ ] Ícones de marca (se necessário)

Cada item gerado deve aparecer linkado em `.catalog/interface.md`.

---
## 7. IMPACTOS EM ARQUITETURA / CONTRATOS (OBRIGATÓRIO)

| Impacto | Sim/Não | Detalhe |
|---------|---------|---------|
| Contratos de API / payloads | | |
| Rotas / deep links / navegação | | |
| Estado cliente vs servidor | | |
| Auth / permissões / multi-step | | |
| Boundaries UI ↔ Runtime / SSR-CSR | | |
| Novo módulo/pacote de UI compartilhada | | |

**Se qualquer "Sim":**
1. Liste as mudanças necessárias na arquitetura
2. NÃO avance para harness-tasks
3. Instrua: "Revisitar harness-architecture com estes impactos; após aprovação, retomar interface se precisar e só então harness-tasks"

**Se todos "Não":** próximo passo → harness-tasks com PRD + arquitetura + interface/assets.

---
## 8. ARQUIVOS A GRAVAR

- `.catalog/interface.md`
- `.catalog/design-system.md` (se necessário)
- `.catalog/assets/interface/*`
- Se `project_tracking.tool: local`: `[delivery_docs.path]/[level1-nome]/interface.md` com links para assets

## REGRAS

- Não invente telas fora do PRD (YAGNI visual)
- Prefira gerar assets a descrever "como seria o logo"
- Tasks posteriores de UI devem referenciar estes mockups/assets
- Nunca siga para tasks com contratos desatualizados pelo UX
```

---

## Saída esperada

Identidade + design system + mapa de telas + mockups/assets em `.catalog/assets/interface/` +
gate de impactos em arquitetura documentado.

## Próximo passo

- Gate disparou → Prompt 02 (Arquitetura) revisão → retomar Prompt 03 se necessário → Prompt 04 (Tasks)
- Gate limpo → Prompt 04 (Tasks) com PRD + arquitetura + interface
