# Referência 00 — Setup do Projeto (Etapa 00)

Executado automaticamente na **primeira invocação** do harness-engineering em um projeto sem configuração.

---

## Quando Executar

Verificar nesta ordem:

1. `harness.config.yaml` existe na raiz do projeto?
2. `AGENTS.md` tem seção `## Harness Config`?

**Existe →** ler config e continuar para a etapa solicitada.  
**Não existe →** executar wizard abaixo, criar `harness.config.yaml`, depois continuar.

---

## Wizard de Setup

Perguntar ao usuário, uma pergunta por vez. Ao final, criar `harness.config.yaml`.

### 1. Nome do projeto

"Como se chama este projeto?"

### 2. Ferramenta de gestão de projeto

"Onde você quer controlar projeto, entregas e tarefas?"

- `github` — GitHub Issues + Projects + Milestones
- `jira` — Jira Board + Epics/Stories/Subtasks
- `linear` — Linear Teams + Projects/Cycles/Issues
- `azuredevops` — Azure DevOps Boards
- `local` — documentos markdown persistidos no repositório
- Outra (digitar livremente)

> Se o usuário não souber ou não responder, usar `github` quando houver repositório GitHub conectado; caso contrário, usar `local`.

### 3. Estratégia de release/versionamento

"Como você quer versionar releases e changelog?"

- `github-auto-release` — PRs para `main` usam exatamente uma label `release:patch`, `release:minor` ou `release:major`; workflow publica GitHub Releases automaticamente.
- `github-legacy` — milestones do GitHub podem representar versões planejadas.
- `release-please` — Conventional Commits alimentam changelog e release automática.
- `manual-changelog` — manter `CHANGELOG.md` ou `changelog.md` manualmente.
- `none` — sem versionamento formal nesta fase.

> Se o usuário escolher `github-auto-release` ou `github-legacy`, isso não obriga `project_tracking.tool: github`. GitHub pode ser usado só para release enquanto o trabalho fica em Jira, Linear, Azure DevOps ou markdown local.

### 4. Hierarquia de trabalho

"Qual é a estrutura de agrupamento do seu projeto? (Enter para usar o padrão)"

Padrão adotado se não houver resposta: **`epic > user-story > task`**

Outras opções comuns:
- `project > feature > task` (orientado a produto)
- `sprint > story > subtask` (Scrum puro)
- `milestone > story > task`

Ou digitar livremente. A skill usará os termos configurados em todos os templates.

> Se o usuário não responder ou der Enter sem digitar → usar `epic > user-story > task` e seguir em frente.

### 5. Localização dos docs de entrega

Perguntar apenas para `project_tracking.tool: local` ou quando o projeto quiser fallback markdown:

"Onde armazenar os arquivos de documentação de entrega?" (padrão: `.milestones/`)

### 6. Detalhes da ferramenta de tracking

Perguntar conforme `project_tracking.tool`:

- GitHub: "Owner/repo e nome ou URL do GitHub Project? (inferível do git remote se omitido)"
- Jira: "URL do Jira, Project Key e Board ID?"
- Linear: "Team ID ou slug do time?"
- Azure DevOps: "Organização e projeto?"

### 7. Detalhes de release

Perguntar conforme `release_management.strategy`:

- `github-auto-release`: "Owner/repo para publicar GitHub Release? Labels são `release:patch`, `release:minor`, `release:major` ou outros nomes?"
- `github-legacy`: "Milestones são versionadas, temáticas ou inexistentes?"
- `release-please`: "Release Please já está configurado no repositório?"
- `manual-changelog`: "Changelog principal fica em `CHANGELOG.md` ou nos docs de entrega?"

### 8. Skills disponíveis

Verificar automaticamente tentando invocar cada skill. Perguntar confirmação:

"As seguintes skills parecem estar disponíveis. Confirma? [lista detectada]"

---

## Arquivo Gerado

```yaml
# harness.config.yaml
# Gerado pelo setup wizard do harness-engineering.
# Edite conforme necessário. Releia a cada sessão.

project:
  name: "[nome do projeto]"

project_tracking:
  tool: github              # github | jira | linear | azuredevops | local
  source_of_truth: external # external | markdown
  github:
    repository: org/repo
    project_url: "https://github.com/orgs/org/projects/1"
    milestone_policy: thematic # thematic | versioned | none
  jira:
    url: "https://example.atlassian.net"
    project_key: "PROJ"
    board_id: "123"
  linear:
    team_id: "team-slug"
  azuredevops:
    organization: "org"
    project: "project-name"

release_management:
  strategy: github-auto-release # github-auto-release | github-legacy | release-please | manual-changelog | none
  repository: org/repo
  version_source: pr-label      # pr-label | milestone | conventional-commits | manual
  labels:
    patch: release:patch
    minor: release:minor
    major: release:major

hierarchy:
  level1: epic        # agrupamento de alto nível (ex: milestone, project, sprint)
  level2: user-story  # unidade de entrega (ex: story, feature, item)
  level3: task        # unidade de implementação (ex: subtask, ticket, card)

delivery_docs:
  path: .milestones   # usado por project_tracking.tool: local e fallback markdown

skills:
  tlc_spec_driven: false
  context7: false
  superpowers: false
  mermaid_studio: false
```

---

## Leitura do Config em Sessões Subsequentes

Na **abertura de cada sessão**, ler `harness.config.yaml` e mapear as variáveis:

| Variável do config | Substitui nos templates |
|--------------------|------------------------|
| `project_tracking.tool` | ferramenta de persistência do trabalho |
| `release_management.strategy` | estratégia de versionamento e changelog |
| `hierarchy.level1` | "epic" (padrão) |
| `hierarchy.level2` | "user-story" / "US" (padrão) |
| `hierarchy.level3` | "task" / "T-XX" (padrão) |
| `delivery_docs.path` | pasta de docs em `project_tracking.tool: local` ou fallback |
| `skills.*` | se `true`: invocar skill; se `false`: usar `references/12-fallback-skills.md` |

## Compatibilidade com Configs Antigas

Se encontrar `project_tracking.mode`, migrar mentalmente antes de executar:

| Campo antigo | Novo tracking | Novo release |
|--------------|---------------|--------------|
| `github-auto-release` | `project_tracking.tool: github` | `release_management.strategy: github-auto-release` |
| `github-legacy` | `project_tracking.tool: github` | `release_management.strategy: github-legacy` |
| `local-markdown` | `project_tracking.tool: local` | `release_management.strategy: manual-changelog` |

> **Regra:** O config é a fonte de verdade para comportamento do pipeline. Se for ambíguo, perguntar ao usuário e atualizar o config.
