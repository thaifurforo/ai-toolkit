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

### 2. Ferramenta de gestão de tarefas

"Você usa alguma ferramenta de gestão de tarefas neste projeto?"

- `github` — GitHub Issues + Milestones + Projects
- `jira` — Jira Board + Sprints
- `linear` — Linear Teams + Cycles
- `azuredevops` — Azure DevOps Boards
- Outra (digitar livremente)
- Não uso / não sei

> Se o usuário não souber, não usar, ou não responder → usar markdown como fallback (sem perguntar mais).

### 3. Hierarquia de trabalho

"Qual é a estrutura de agrupamento do seu projeto? (Enter para usar o padrão)"

Padrão adotado se não houver resposta: **`epic > user-story > task`**

Outras opções comuns:
- `project > feature > task` (orientado a produto)
- `sprint > story > subtask` (Scrum puro)
- `milestone > story > task`

Ou digitar livremente. A skill usará os termos configurados em todos os templates.

> Se o usuário não responder ou der Enter sem digitar → usar `epic > user-story > task` e seguir em frente.

### 4. Localização dos docs de entrega

"Onde armazenar os arquivos de documentação de entrega?" (padrão: `.milestones/`)

### 5. Detalhes da ferramenta (se não local)

Se `github`: "Owner e nome do repositório? (ex: org/repo — inferível do git remote se omitido)"  
Se `jira`: "Board ID e Project Key? (ex: board_id: PROJ-123, project_key: PROJ)"  
Se `linear`: "Team ID ou slug do time?"

### 6. Skills disponíveis

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
  tool: local         # github | jira | linear | azuredevops | local
  # GitHub:
  #   owner: org/user
  #   repo: repo-name
  # Jira:
  #   board_id: "PROJ-123"
  #   project_key: "PROJ"
  # Linear:
  #   team_id: "team-slug"

hierarchy:
  level1: epic        # agrupamento de alto nível  (ex: milestone, project, sprint)
  level2: user-story  # unidade de entrega          (ex: story, feature, item)
  level3: task        # unidade de implementação    (ex: subtask, ticket, card)

delivery_docs:
  path: .milestones   # pasta onde ficam os docs de entrega no repositório

skills:
  tlc_spec_driven: false   # true se instalado e deseja usar
  context7: false          # true se context7-mcp está disponível
  superpowers: false       # true se superpowers marketplace está instalado
  mermaid_studio: false    # true se mermaid-studio está disponível
```

---

## Leitura do Config em Sessões Subsequentes

Na **abertura de cada sessão**, ler `harness.config.yaml` e mapear as variáveis:

| Variável do config | Substitui nos templates |
|--------------------|------------------------|
| `hierarchy.level1` | "epic" (padrão) |
| `hierarchy.level2` | "user-story" / "US" (padrão) |
| `hierarchy.level3` | "task" / "T-XX" (padrão) |
| `project_tracking.tool` | como persistir outputs de cada etapa |
| `skills.*` | se `true`: invocar skill; se `false`: usar `references/12-fallback-skills.md` |

> **Regra:** O config é a fonte de verdade para comportamento do pipeline. Se for ambíguo, perguntar ao usuário e atualizar o config.
