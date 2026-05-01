# 🧰 ai-toolkit

> Ferramentas, skills e prompts para desenvolvimento de software com IA — construídos para uso real em projetos de produção.

[![Skills](https://img.shields.io/badge/skills-agentskills.io-blue)](https://agentskills.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/thaifurforo/ai-toolkit/pulls)

---

## O que é este repositório

Repositório público onde centralizo as ferramentas de IA que crio e uso no dia a dia como engenheira de software. O foco é **tornar o desenvolvimento com agentes de IA mais confiável, estruturado e reproduzível** — não apenas mais rápido.

Cada ferramenta aqui nasceu de um problema real: como garantir que um agente de IA produza software que realmente funcione em produção, com arquitetura limpa, testes, documentação e processo de entrega rastreável?

---

## 📁 Conteúdo

### [`skills/`](./skills/) — AI Agent Skills

Skills no padrão [agentskills.io](https://agentskills.io), compatíveis com Claude Code, GitHub Copilot CLI, Codex e outros agentes.

#### 🏗️ harness-engineering — Pipeline completo de desenvolvimento

Pipeline de 9 etapas baseado nas práticas de **Harness Engineering** da Anthropic, OpenAI e Thoughtworks/Martin Fowler. Transforma uma ideia em software confiável combinando **guias (feedforward)** e **sensores (feedback)** que permitem autocorreção antes de chegar ao humano.

```
harness-engineering (orquestrador)
│
├── harness-prd            → PRD interativo com ProductBuddy
├── harness-architecture   → Arquitetura técnica + harnessability map
├── harness-tasks          → Breakdown de tasks com rastreabilidade RF → US → CA → T
├── harness-implementation → Implementação com TDD + sprint contract + Context7
├── harness-code-review    → Code review como sensor inferencial (6 dimensões)
├── harness-testing        → Testes unitários, integração, contrato e estruturais
├── harness-documentation  → Documentação como sistema de record (.catalog/)
├── harness-cicd           → CI/CD shift-left + garbage collection automático
└── harness-iteration      → Steering loop: feedback de produção → melhorias do harness
```

**Por que é diferente?** A maioria dos prompts de IA foca em "escrever código mais rápido". Este pipeline foca em **estrutura ao redor do agente**: linters com remediação inline, sensores computacionais em cada commit, rastreabilidade de requisitos até os testes, e um loop de melhoria contínua do próprio harness.

**Como usar:**
```bash
# Claude Code
cp -r skills/harness-* ~/.claude/skills/

# Codex / GitHub Copilot CLI / Gemini CLI / Cursor
cp -r skills/harness-* ~/.agents/skills/
```

---

## 💡 Filosofia

> *"O gargalo nunca foi a capacidade do agente de escrever código — foi a falta de estrutura, ferramentas e mecanismos de feedback ao seu redor."*
> — OpenAI Engineering Blog, 2026

Acredito que o maior ganho com IA no desenvolvimento não vem de substituir o engenheiro, mas de **amplificar boas práticas de engenharia** com automação inteligente. As ferramentas aqui refletem isso:

- **Guias (feedforward):** contexto certo antes de agir — PRD, arquitetura, convenções codificadas
- **Sensores (feedback):** detecção automática de problemas — testes, linters, type check, code review por IA
- **Rastreabilidade:** `RF-01 → US-01 → CA-01 → T-01 → teste` — nada cai entre as rachaduras
- **Steering loop:** cada erro recorrente vira uma regra no harness — o sistema melhora a cada ciclo

---

## 🛠️ Stack de referência

As skills e ferramentas são projetadas para funcionar com qualquer stack, mas o autor usa principalmente:

`TypeScript · .NET/C# · React · PostgreSQL · GitHub Actions · Docker · Google Cloud Run`

---

## 📖 Fontes e inspirações

- [Harness Engineering — Martin Fowler + Böckeler](https://martinfowler.com/articles/harness-engineering.html)
- [Harness Engineering — OpenAI Engineering Blog](https://openai.com/index/harness-engineering/)
- [Harness Design for Long-Running Apps — Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- [Superpowers — Agentic skills framework](https://github.com/obra/superpowers)
- [agentskills.io — Skill specification](https://agentskills.io/specification)

---

## 🤝 Contribuições

Este é um repositório pessoal, mas PRs com melhorias, correções ou novas skills são bem-vindos. Abra uma issue descrevendo o que você quer adicionar antes de implementar.

---

## 👤 Autora

**Thainara Furforo** — Engenheira de Software com foco em backend (.NET/C#, TypeScript) e arquitetura de sistemas.

[![GitHub](https://img.shields.io/badge/GitHub-thaifurforo-181717?logo=github)](https://github.com/thaifurforo)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-thaifurforo-0A66C2?logo=linkedin)](https://linkedin.com/in/thaifurforo)

---

<sub>MIT License · Feito com ☕ e muito `git commit`</sub>
