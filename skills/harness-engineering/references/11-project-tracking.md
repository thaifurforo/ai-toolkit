# Referência 11 — Gestão de Projetos (Project Tracking)

Como persistir os outputs de cada etapa do pipeline, dependendo da ferramenta configurada em `harness.config.yaml`.

---

## Verificar Config

Ler `project_tracking.tool` em `harness.config.yaml` antes de qualquer etapa que produza output rastreável.

Se o config não existir, ou a ferramenta configurada não tiver conectividade verificada → usar **fallback markdown** (seção `local` abaixo).

---

## Verificar Conectividade

Antes de usar qualquer ferramenta externa, verificar na ordem: **CLI nativo → MCP → API direta**.  
Se nenhuma opção funcionar → usar fallback markdown e informar o usuário como conectar na próxima sessão.

> **Regra:** Nunca bloquear o pipeline por falta de conectividade. Fazer fallback para markdown e seguir em frente.

### GitHub

1. **CLI:** `gh auth status` → se OK, usar `gh` para criar issues, milestones etc.
2. **MCP:** tentar invocar `github-mcp-server-list_issues` → se funcionar, usar tools MCP
3. **API:** verificar var `GITHUB_TOKEN` no ambiente → usar chamadas REST diretas
4. **Fallback:** nenhuma opção → usar seção `local` abaixo

Se não conectar, orientar o usuário:
- CLI: `gh auth login`
- MCP: instalar `github-mcp-server` e configurar `GITHUB_TOKEN`
- API: exportar `GITHUB_TOKEN=ghp_...`

### Jira

1. **CLI:** `acli --version` → se OK, usar Atlassian CLI
2. **MCP:** tentar invocar tool Atlassian MCP → se funcionar, usar
3. **API:** verificar `ATLASSIAN_API_TOKEN` + `JIRA_URL` + `JIRA_EMAIL`
4. **Fallback:** nenhuma opção → usar seção `local` abaixo

Se não conectar, orientar:
- CLI: instalar [Atlassian CLI](https://acli.atlassian.com) e configurar credenciais
- API: definir `ATLASSIAN_API_TOKEN`, `JIRA_URL`, `JIRA_EMAIL` no ambiente

### Linear

1. **CLI:** `linear --version` → se OK, usar CLI Linear
2. **MCP:** tentar invocar tool Linear MCP → se funcionar, usar
3. **API:** verificar `LINEAR_API_KEY`
4. **Fallback:** nenhuma opção → usar seção `local` abaixo

### Azure DevOps

1. **CLI:** `az devops --version` → se OK, usar `az devops`
2. **MCP:** tentar invocar tool Azure DevOps MCP → se funcionar, usar
3. **API:** verificar `AZURE_DEVOPS_TOKEN`
4. **Fallback:** nenhuma opção → usar seção `local` abaixo

---

## Por Ferramenta

### `github` — GitHub Issues + Milestones + Projects

| Output da etapa | Ação |
|-----------------|------|
| PRD (Etapa 01) | Criar Issue com label `documentation` + `prd` vinculada ao Milestone |
| Solução técnica (Etapa 02) | Criar Issue com label `documentation` + `architecture` vinculada ao Milestone |
| Level1 (milestone) | Criar GitHub Milestone |
| Level2 (user story) | Criar Issue com label `user-story` vinculada ao Milestone |
| Tasks (T-XX) | Checklist no corpo da Issue da user story |
| Progresso | GitHub Projects board atualizado |
| Fechar entrega | `Closes #N` no corpo do PR — GitHub fecha automaticamente no merge |
| Changelog/Release | Conventional Commits + `release-please` (se instalado); senão: `CHANGELOG.md` manual |

**Comandos úteis (gh CLI):**
```bash
gh milestone create "[nome]" --due-date "YYYY-MM-DD"
gh issue create --title "[título]" --label "user-story" --milestone "[nome]"
```

---

### `jira` — Jira Board

| Output da etapa | Ação |
|-----------------|------|
| PRD (Etapa 01) | Criar página no Confluence ou documento anexo à Epic |
| Level1 (epic) | Criar Epic no projeto configurado |
| Level2 (story) | Criar Story vinculada à Epic |
| Tasks (subtasks) | Criar Sub-tasks vinculadas à Story |
| Progresso | Mover cards no board conforme status |
| Fechar entrega | Transicionar issues para "Done" após merge |

**Configuração necessária em `harness.config.yaml`:**
```yaml
project_tracking:
  tool: jira
  board_id: "PROJ-123"
  project_key: "PROJ"
```

---

### `linear` — Linear

| Output da etapa | Ação |
|-----------------|------|
| Level1 (cycle/project) | Criar Cycle ou Project no team configurado |
| Level2 (issue/feature) | Criar Issue no Cycle |
| Tasks | Sub-issues ou checklist na Issue |
| Progresso | Atualizar status das Issues |

**Configuração necessária:**
```yaml
project_tracking:
  tool: linear
  team_id: "team-slug"
```

---

### `azuredevops` — Azure DevOps Boards

| Output da etapa | Ação |
|-----------------|------|
| Level1 (epic) | Criar Epic |
| Level2 (user story) | Criar User Story vinculada à Epic |
| Tasks | Criar Tasks vinculadas à User Story |
| Progresso | Atualizar estado dos work items |

---

### `local` — Fallback Markdown (sem ferramenta externa)

Fallback padrão quando nenhuma ferramenta estiver configurada ou conectada. Toda rastreabilidade via arquivos no repositório:

| Output da etapa | Localização |
|-----------------|-------------|
| PRD | `[delivery_docs.path]/[level1-nome]/prd.md` |
| Solução técnica | `[delivery_docs.path]/[level1-nome]/tech-solution.md` |
| Level1 overview | `[delivery_docs.path]/[level1-nome]/[level1].md` |
| Level2 docs | `[delivery_docs.path]/[level1-nome]/[level2-XX-nome]/[level2].md` |
| Tasks | Checklist em `tech-spec.md` da level2 |
| Changelog | `[delivery_docs.path]/[level1-nome]/[level2-XX-nome]/changelog.md` |

Templates canônicos: `references/10-documentacao-entregas.md`

---

## Rastreabilidade Mínima (qualquer ferramenta)

Independente da ferramenta, o fio de rastreabilidade deve existir:

```
RF-01 (PRD) → [level2]-01 (story) → CA-01 (critério) → T-01 (task) → teste que verifica CA-01
```

Nunca crie tasks sem RF. Nunca feche task sem gate verificado.

---

## Changelog / Release Notes

| Ferramenta | Abordagem |
|------------|-----------|
| `release-please` disponível | Conventional Commits → geração automática |
| Sem `release-please` | Manter `CHANGELOG.md` manual seguindo [Keep a Changelog](https://keepachangelog.com) |
| Jira/Linear/ADO | Usar o changelog nativo da ferramenta + `CHANGELOG.md` no repo |

> **Regra:** Nunca escrever changelog manualmente se `release-please` estiver configurado.
