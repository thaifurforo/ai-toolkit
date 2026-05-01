---
name: harness-documentation
description: Use quando for atualizar documentação após concluir uma user story ou feature. Ativado por "documentar", "README", "doc da API", "atualizar catalog", "atualizar AGENTS.md". Sempre executar após harness-testing para fechar o loop de entrega.
---

# Harness: Documentação (Etapa 07)

**Persona:** Technical writer.

## Duas Camadas — Responsabilidades Distintas

```
.catalog/                    ← fonte de verdade técnica (versionada no repositório)
  architecture.md, conventions.md, concerns.md, features.md, stack.md...

[delivery_docs.path]/        ← documentação de entregas (padrão: .milestones/)
Ferramenta de rastreamento   ← issues/cards/epics/stories conforme project_tracking.tool
```

**Regra:** `AGENTS.md` é a tabela de roteamento (≤100 linhas) — aponta para `.catalog/` e para os itens de rastreamento.

## Tipo A — Docs de Entrega (atualizar sempre)

Após cada [level2] concluída:
- `[delivery_docs.path]/[level1-nome]/[level2-XX]/changelog.md` — o que mudou, por quê, impacto
- `[delivery_docs.path]/[level1-nome]/[level2-XX]/tech-spec.md` — marcar tasks completas, atualizar status para ✅
- `[delivery_docs.path]/[level1-nome]/[level1].md` — marcar [level2] completa

Fechar entrega conforme `project_tracking.tool` — ver `references/11-project-tracking.md`.

## Tipo B — Docs de Contexto (atualizar APENAS se algo mudou)

Atualizar somente quando a US introduziu algo novo:

| Arquivo | Quando atualizar |
|---------|-----------------|
| `.catalog/features.md` | Nova funcionalidade implementada |
| `.catalog/architecture.md` | Novo ADR, mudança de camada, padrão estrutural |
| `.catalog/conventions.md` | Novo padrão de código emergiu |
| `.catalog/concerns.md` | Nova dívida técnica ou risco |
| `.catalog/stack.md` | Nova dependência ou configuração |

> **Jamais delete ADRs** — são a memória histórica do projeto.

## Changelog e Release Notes

| Situação | Abordagem |
|----------|-----------|
| `release-please` disponível | Conventional Commits → geração automática de `CHANGELOG.md` e Release |
| Sem `release-please` | Manter `CHANGELOG.md` manual seguindo [Keep a Changelog](https://keepachangelog.com) |
| Ferramenta nativa (Jira/Linear/ADO) | Usar changelog nativo da ferramenta + `CHANGELOG.md` no repo |

> **Regra:** Nunca escrever changelog manualmente se `release-please` estiver configurado.

## Saída Esperada

**Sempre:** `[delivery_docs.path]/` atualizado + entrega fechada conforme `project_tracking.tool`

**Se aplicável:** `.catalog/` atualizado + `AGENTS.md` atualizado se houve mudança estrutural

## Próximo Passo → `harness-cicd`

(ou voltar para `harness-implementation` para a próxima US do milestone)

---

**Template completo de prompt:** Ver `./prompt.md`
