# Skills

Skills de agentes de IA no padrão [agentskills.io](https://agentskills.io) — compatíveis com Claude Code, GitHub Copilot CLI, Codex, Gemini CLI, Cursor e outros agentes.

---

## 🏗️ harness-engineering — Pipeline completo de desenvolvimento com IA

> *"O gargalo nunca foi a capacidade do agente de escrever código — foi a falta de estrutura, ferramentas e mecanismos de feedback ao seu redor."*
> — OpenAI Engineering Blog, 2026

Pipeline de 9 etapas baseado nas práticas de **Harness Engineering** da Anthropic, OpenAI e Thoughtworks/Martin Fowler. Transforma uma ideia em software confiável combinando **guias (feedforward)** e **sensores (feedback)** que permitem autocorreção antes de chegar ao humano.

### Estrutura

```
harness-engineering/       ← orquestrador: mental model, tabela de etapas, fluxos
├── harness-prd/            ← 01. PRD com ProductBuddy (SPECIFY)
├── harness-architecture/   ← 02. Arquitetura técnica + harnessability map (DESIGN)
├── harness-tasks/          ← 03. Breakdown de tasks + dependency map (TASKS)
├── harness-implementation/ ← 04. Implementação com TDD + sprint contract (EXECUTE)
├── harness-code-review/    ← 05. Code review como sensor inferencial (VERIFY)
├── harness-testing/        ← 06. Testes automatizados como sensores computacionais
├── harness-documentation/  ← 07. Documentação como sistema de record
├── harness-cicd/           ← 08. CI/CD com shift-left + garbage collection sensor
└── harness-iteration/      ← 09. Steering loop: feedback → melhorias do harness
```

Cada sub-skill contém:
- `SKILL.md` — visão geral, persona, integrações, processo resumido, output esperado
- `prompt.md` — template completo de prompt (referência pesada, 100+ linhas)

### Skills em detalhe

| Skill | Etapa | O que faz |
|-------|-------|-----------|
| [harness-engineering](./harness-engineering/) | Orquestrador | Mental model, tabela de etapas, fluxos de invocação — delega para sub-skills |
| [harness-prd](./harness-prd/) | 01 · SPECIFY | PRD interativo com ProductBuddy: visão, personas, RFs, NFRs, restrições |
| [harness-architecture](./harness-architecture/) | 02 · DESIGN | Arquitetura técnica + harnessability map: onde o agente vai precisar de guias/sensores |
| [harness-tasks](./harness-tasks/) | 03 · TASKS | Breakdown de tasks com rastreabilidade RF → US → CA → T + dependency map |
| [harness-implementation](./harness-implementation/) | 04 · EXECUTE | TDD + sprint contract + Context7 — agente nunca escreve código sem teste primeiro |
| [harness-code-review](./harness-code-review/) | 05 · VERIFY | Code review em 6 dimensões como sensor inferencial antes do PR |
| [harness-testing](./harness-testing/) | 06 · TEST | Testes unitários, integração, contrato e estruturais como sensores computacionais |
| [harness-documentation](./harness-documentation/) | 07 · DOCUMENT | Documentação em `.catalog/` como sistema de record rastreável |
| [harness-cicd](./harness-cicd/) | 08 · SHIP | CI/CD shift-left: sensors automáticos + garbage collection de código morto |
| [harness-iteration](./harness-iteration/) | 09 · ITERATE | Steering loop: feedback de produção → melhorias do harness |

### O conceito central: Guias + Sensores

| Tipo | Quando atua | Exemplos |
|------|-------------|---------|
| **Guias (feedforward)** | Antes de agir | PRD, arquitetura, AGENTS.md, linters com remediação inline |
| **Sensores computacionais** | A cada commit | Testes, type check, análise estrutural de camadas |
| **Sensores inferenciais** | Antes do PR / no CI | Code review por IA, mutation testing |

### Design: orquestrador slim (padrão superpowers)

A skill `harness-engineering` **delega** para sub-skills em vez de concentrar todo o conhecimento inline — igual ao padrão `executing-plans` do [superpowers](https://github.com/obra/superpowers). Cada sub-skill pode ser invocada de forma independente, sem precisar rodar o pipeline completo.

### Instalação

```bash
# Claude Code
cp -r skills/harness-* ~/.claude/skills/

# Codex / GitHub Copilot CLI / Gemini CLI / Cursor
cp -r skills/harness-* ~/.agents/skills/
```

Ou instale via seu gerenciador de skills de agente.

### Fontes

- [Fowler/Böckeler — Harness Engineering for Coding Agent Users](https://martinfowler.com/articles/harness-engineering.html)
- [OpenAI — Harness Engineering: Leveraging Codex in an Agent-First World](https://openai.com/index/harness-engineering/)
- [Anthropic — Harness Design for Long-Running Application Development](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- [Superpowers — Agentic skills framework](https://github.com/obra/superpowers)
- [agentskills.io — Skill specification](https://agentskills.io/specification)
