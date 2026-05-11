# Referência 11 — Gestão de Projetos (Project Tracking)

Como persistir os outputs de cada etapa do pipeline, dependendo de `project_tracking.mode` em `harness.config.yaml`.

---

## Verificar Config

Ler `project_tracking.mode` antes de qualquer etapa que produza output rastreável.

Modos suportados:

- `local-markdown`
- `github-legacy`
- `github-auto-release` recomendado

Se o config antigo tiver apenas `project_tracking.tool`, inferir:

- `tool: local` → `local-markdown`
- `tool: github` → perguntar se o projeto usa `github-legacy` ou `github-auto-release`; se houver workflow com labels `release:*`, usar `github-auto-release`.

---

## Verificar Conectividade

Para modos GitHub, verificar nesta ordem: **CLI nativo → MCP → API direta**.  
Se nenhuma opção funcionar, usar fallback markdown em `delivery_docs.path` e informar o usuário como conectar na próxima sessão.

### GitHub

1. **CLI:** `gh auth status` → se OK, usar `gh` para criar issues, milestones, labels e PRs.
2. **MCP:** tentar invocar ferramenta MCP de GitHub, se disponível.
3. **API:** verificar `GITHUB_TOKEN` no ambiente → usar chamadas REST/GraphQL diretas.
4. **Fallback:** nenhuma opção → usar `local-markdown` temporário.

---

## Modo `local-markdown`

Use quando o usuário quer controlar o projeto por documentos markdown no repositório.

| Output da etapa | Localização |
|-----------------|-------------|
| PRD | `[delivery_docs.path]/[level1-nome]/prd.md` |
| Solução técnica | `[delivery_docs.path]/[level1-nome]/tech-solution.md` |
| Level1 overview | `[delivery_docs.path]/[level1-nome]/[level1].md` |
| Level2 docs | `[delivery_docs.path]/[level1-nome]/[level2-XX-nome]/user-story.md` |
| Tasks | Checklist em `tech-spec.md` da level2 |
| Changelog | `[delivery_docs.path]/[level1-nome]/[level2-XX-nome]/changelog.md` |

Padrão de pasta: `.milestone/`, salvo configuração diferente em `delivery_docs.path`.

---

## Modo `github-legacy`

Use quando o projeto segue o padrão antigo de GitHub Project + Milestones, com milestones podendo representar versões planejadas.

| Output da etapa | Ação |
|-----------------|------|
| Level1 | Criar GitHub Milestone; pode ter nome versionado se o projeto escolher esse padrão |
| Level2 | Criar Issue com label `user-story` vinculada à Milestone |
| Tasks | Checklist no corpo da Issue da user story ou issues de task vinculadas |
| Progresso | GitHub Projects board atualizado |
| Fechar entrega | `Closes #N` no corpo do PR |
| Changelog/Release | Seguir convenção do projeto: release manual, release-please ou changelog local |

Não use milestone versionada neste modo se o projeto disser que milestones são temáticas.

---

## Modo `github-auto-release` recomendado

Use quando o projeto publica releases automaticamente após merge em `main`.

| Output da etapa | Ação |
|-----------------|------|
| Level1 | Criar/usar GitHub Milestone temática de roadmap, sem obrigação de número de versão |
| Level2 | Criar Issue de User Story vinculada à Milestone temática |
| Tasks | Criar issues `T-XX` ou checklist vinculado à US, conforme convenção do projeto |
| Progresso | GitHub Projects v2 atualizado |
| PR | Fechar pelo menos uma issue com `Closes #N`, `Fixes #N` ou `Resolves #N` |
| Impacto de release | Aplicar exatamente uma label: `release:patch`, `release:minor` ou `release:major` |
| Release | Workflow pós-merge calcula a próxima versão SemVer e publica GitHub Release |

### Classificação recomendada das labels

- `release:patch`: documentação, bug fix, testes, infraestrutura sem breaking change e tasks que implementam parte de uma user story.
- `release:minor`: PR ou task que finaliza uma user story ou entrega uma capacidade funcional compatível.
- `release:major`: PR ou task que finaliza uma épica/MVP ou qualquer breaking change.

O PR é a fonte de verdade do impacto de versão. Issues podem receber a label depois por sincronização do workflow, mas a decisão fica no PR.

---

## Rastreabilidade Mínima (qualquer modo)

Independente da ferramenta, o fio de rastreabilidade deve existir:

```
RF-01 (PRD) → [level2]-01 (story) → CA-01 (critério) → T-01 (task) → teste que verifica CA-01
```

Nunca crie tasks sem RF. Nunca feche task sem gate verificado.

---

## Changelog / Release Notes

- `local-markdown`: manter `changelog.md` no repositório.
- `github-legacy`: seguir a convenção explícita do projeto.
- `github-auto-release`: não escrever changelog versionado manual se o workflow já gera GitHub Release; ajustar labels e descrição do PR para alimentar release notes.
