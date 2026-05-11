# Referência 11 — Gestão de Projetos (Project Tracking)

Como persistir os outputs de cada etapa do pipeline conforme `project_tracking.tool` em `harness.config.yaml`.

Tracking de projeto e versionamento de release são decisões separadas. Use esta referência para PRD, agrupamentos, user stories, tasks, status e rastreabilidade. Use `references/13-release-management.md` para changelog, labels de release, SemVer e publicação.

---

## Verificar Config

Ler `project_tracking.tool` antes de qualquer etapa que produza output rastreável.

Ferramentas suportadas:

- `github`
- `jira`
- `linear`
- `azuredevops`
- `local`

Se encontrar config antigo com `project_tracking.mode`, migrar mentalmente:

| `project_tracking.mode` antigo | `project_tracking.tool` | `release_management.strategy` |
|---------------------------------|-------------------------|--------------------------------|
| `github-auto-release` | `github` | `github-auto-release` |
| `github-legacy` | `github` | `github-legacy` |
| `local-markdown` | `local` | `manual-changelog` |

---

## Verificar Conectividade

Antes de usar ferramenta externa, verificar na ordem: **CLI nativo → MCP → API direta**.
Se nenhuma opção funcionar, usar fallback markdown em `delivery_docs.path` e informar o usuário como conectar na próxima sessão.

> Nunca bloqueie o pipeline por falta de conectividade. Preserve rastreabilidade em markdown e deixe claro que o fallback é temporário.

### GitHub

1. **CLI:** `gh auth status` → se OK, usar `gh` para issues, milestones, labels, Projects e PRs.
2. **MCP:** tentar ferramenta MCP de GitHub, se disponível.
3. **API:** verificar `GITHUB_TOKEN` → usar REST/GraphQL.
4. **Fallback:** usar `project_tracking.tool: local` temporário.

Config relevante:

```yaml
project_tracking:
  tool: github
  github:
    repository: org/repo
    project_url: https://github.com/orgs/org/projects/1
    milestone_policy: thematic # thematic | versioned | none
```

### Jira

1. **CLI:** `acli --version` → se OK, usar Atlassian CLI.
2. **MCP:** tentar ferramenta Atlassian/Jira MCP, se disponível.
3. **API:** verificar `ATLASSIAN_API_TOKEN`, `JIRA_URL` e `JIRA_EMAIL`.
4. **Fallback:** usar markdown em `delivery_docs.path`.

Config relevante:

```yaml
project_tracking:
  tool: jira
  jira:
    url: https://example.atlassian.net
    project_key: PROJ
    board_id: "123"
```

### Linear

1. **CLI:** `linear --version` → se OK, usar Linear CLI.
2. **MCP:** tentar ferramenta Linear MCP, se disponível.
3. **API:** verificar `LINEAR_API_KEY`.
4. **Fallback:** usar markdown em `delivery_docs.path`.

Config relevante:

```yaml
project_tracking:
  tool: linear
  linear:
    team_id: team-slug
```

### Azure DevOps

1. **CLI:** `az devops --version` → se OK, usar `az devops`.
2. **MCP:** tentar ferramenta Azure DevOps MCP, se disponível.
3. **API:** verificar `AZURE_DEVOPS_TOKEN`.
4. **Fallback:** usar markdown em `delivery_docs.path`.

Config relevante:

```yaml
project_tracking:
  tool: azuredevops
  azuredevops:
    organization: org
    project: project-name
```

---

## Por Ferramenta

### `github` — GitHub Issues + Projects

| Output da etapa | Ação |
|-----------------|------|
| PRD | Criar Issue ou Discussion com label `documentation` + `prd`, vinculada ao agrupamento configurado |
| Solução técnica | Criar Issue com label `documentation` + `architecture` ou seção na issue de PRD |
| Level1 | Criar/usar Milestone quando `milestone_policy` não for `none`; caso contrário, usar Project field/label |
| Level2 | Criar Issue com label `user-story` vinculada ao Level1 |
| Tasks | Checklist na Issue da user story ou issues `T-XX`, conforme convenção do projeto |
| Progresso | Atualizar GitHub Projects v2 |
| Fechar entrega | Usar `Closes #N`, `Fixes #N` ou `Resolves #N` no PR |

Milestone versionada só é padrão quando `project_tracking.github.milestone_policy: versioned` ou quando `release_management.strategy: github-legacy`.

### `jira` — Jira Board

| Output da etapa | Ação |
|-----------------|------|
| PRD | Criar página/documento vinculado à Epic ou issue de documentação |
| Level1 | Criar Epic no projeto configurado |
| Level2 | Criar Story vinculada à Epic |
| Tasks | Criar Sub-tasks vinculadas à Story |
| Progresso | Atualizar status no board |
| Fechar entrega | Transicionar issues para Done após merge/verificação |

Release pode continuar em GitHub, release-please ou changelog manual; não mude para GitHub tracking só porque release usa GitHub.

### `linear` — Linear

| Output da etapa | Ação |
|-----------------|------|
| PRD | Criar documento do projeto ou issue de documentação |
| Level1 | Criar Project ou Cycle no team configurado |
| Level2 | Criar Issue vinculada ao Project/Cycle |
| Tasks | Criar sub-issues ou checklist na Issue |
| Progresso | Atualizar status das Issues |
| Fechar entrega | Fechar issues após merge/verificação |

Release é independente; labels de release no PR GitHub podem coexistir com Linear como fonte de trabalho.

### `azuredevops` — Azure DevOps Boards

| Output da etapa | Ação |
|-----------------|------|
| PRD | Criar wiki/documento ou work item de documentação |
| Level1 | Criar Epic |
| Level2 | Criar User Story vinculada à Epic |
| Tasks | Criar Tasks vinculadas à User Story |
| Progresso | Atualizar estado dos work items |
| Fechar entrega | Transicionar work items após merge/verificação |

### `local` — Markdown no Repositório

Use quando o usuário quer controlar o projeto por documentos markdown no repositório ou quando uma ferramenta externa não está conectada.

| Output da etapa | Localização |
|-----------------|-------------|
| PRD | `[delivery_docs.path]/[level1-nome]/prd.md` |
| Solução técnica | `[delivery_docs.path]/[level1-nome]/tech-solution.md` |
| Level1 overview | `[delivery_docs.path]/[level1-nome]/[level1].md` |
| Level2 docs | `[delivery_docs.path]/[level1-nome]/[level2-XX-nome]/user-story.md` |
| Tasks | Checklist em `tech-spec.md` da level2 |
| Changelog de entrega | `[delivery_docs.path]/[level1-nome]/[level2-XX-nome]/changelog.md` se `release_management.strategy: manual-changelog` |

Padrão de pasta: `.milestones/`, salvo configuração diferente em `delivery_docs.path`.

---

## Rastreabilidade Mínima

Independente da ferramenta, o fio de rastreabilidade deve existir:

```
RF-01 (PRD) → [level2]-01 (story) → CA-01 (critério) → T-01 (task) → teste que verifica CA-01
```

Nunca crie tasks sem RF. Nunca feche task sem gate verificado. Nunca troque a ferramenta de tracking para acomodar uma estratégia de release.
