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

[delivery_docs.path]/        ← docs de entrega quando `project_tracking.tool: local` ou fallback (padrão: .milestones/)
Ferramenta de rastreamento   ← issues/cards/epics/stories conforme project_tracking.tool
```

**Regra:** `AGENTS.md` é a tabela de roteamento (≤100 linhas) — aponta para `.catalog/` e para os itens de rastreamento.

## Tipo A — Docs de Entrega (atualizar quando forem a fonte ativa)

Após cada [level2] concluída, atualizar estes arquivos quando `project_tracking.tool: local` ou quando uma ferramenta externa caiu para fallback markdown:
- `[delivery_docs.path]/[level1-nome]/[level2-XX]/changelog.md` — o que mudou, por quê, impacto
- `[delivery_docs.path]/[level1-nome]/[level2-XX]/tech-spec.md` — marcar tasks completas, atualizar status para ✅
- `[delivery_docs.path]/[level1-nome]/[level1].md` — marcar [level2] completa

Fechar entrega conforme `project_tracking.tool` — ver `references/11-project-tracking.md`. Não duplique docs locais se GitHub/Jira/Linear/Azure DevOps é a fonte de verdade ativa e conectada.

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
| `release_management.strategy: github-auto-release` | Label `release:*` no PR e release notes geradas pelo workflow |
| `release_management.strategy: github-legacy` | Milestone versionada apenas se configurada; release notes conforme convenção |
| `release_management.strategy: release-please` | Conventional Commits → geração automática de `CHANGELOG.md` e Release |
| `release_management.strategy: manual-changelog` | Manter `CHANGELOG.md` ou changelog de entrega manual |
| `release_management.strategy: none` | Não criar changelog/release formal |

> **Regra:** Nunca escrever changelog versionado manualmente se `release_management.strategy` delega isso a `github-auto-release` ou `release-please`. Ver `harness-engineering/references/13-release-management.md`.

## Saída Esperada

**Sempre:** entrega fechada conforme `project_tracking.tool`; `[delivery_docs.path]/` atualizado apenas se for fonte ativa ou fallback.

**Se aplicável:** `.catalog/` atualizado + `AGENTS.md` atualizado se houve mudança estrutural

## Próximo Passo → `harness-cicd`

(ou voltar para `harness-implementation` para a próxima US do milestone)

---

**Template completo de prompt:** Ver `./prompt.md`
