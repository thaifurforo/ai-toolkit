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

### 2. Modo de tracking

"Como você quer controlar o projeto e as entregas?"

- `github-auto-release` — **recomendado**: GitHub Issues + Project v2 + Milestones temáticas; PRs para `main` usam `release:patch`, `release:minor` ou `release:major` e o workflow publica GitHub Releases automaticamente.
- `local-markdown` — documentos markdown persistidos no repositório, em `.milestone/` ou no caminho configurado em `delivery_docs.path`.
- `github-legacy` — padrão com GitHub Issues + Project + Milestones, onde a milestone pode representar uma versão planejada.
- Outra (digitar livremente)

> Se o usuário não souber ou não responder, usar `github-auto-release` quando houver repositório GitHub; caso contrário, usar `local-markdown`.

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

Perguntar apenas para `local-markdown` ou quando o projeto quiser fallback markdown:

"Onde armazenar os arquivos de documentação de entrega?" (padrão: `.milestone/`)

### 5. Detalhes do GitHub

Perguntar apenas para `github-auto-release` ou `github-legacy`:

"Owner e nome do repositório? (ex: org/repo — inferível do git remote se omitido)"

Se houver Project v2, perguntar também:

"Nome ou URL do GitHub Project?"

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
  mode: github-auto-release # github-auto-release | github-legacy | local-markdown
  # Compatibilidade com configs antigas: tool pode ser github, local etc.
  tool: github-auto-release
  repository: org/repo
  project: "[nome do project]"
  project_url: "https://github.com/users/org/projects/1"
  release_labels:
    patch: release:patch
    minor: release:minor
    major: release:major

hierarchy:
  level1: epic        # agrupamento de alto nível (ex: milestone, project, sprint)
  level2: user-story  # unidade de entrega (ex: story, feature, item)
  level3: task        # unidade de implementação (ex: subtask, ticket, card)

delivery_docs:
  path: .milestone    # usado por local-markdown e fallback markdown

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
| `project_tracking.mode` | modo de persistência e release |
| `hierarchy.level1` | "epic" (padrão) |
| `hierarchy.level2` | "user-story" / "US" (padrão) |
| `hierarchy.level3` | "task" / "T-XX" (padrão) |
| `delivery_docs.path` | pasta de docs em `local-markdown` ou fallback |
| `skills.*` | se `true`: invocar skill; se `false`: usar `references/12-fallback-skills.md` |

> **Regra:** O config é a fonte de verdade para comportamento do pipeline. Se for ambíguo, perguntar ao usuário e atualizar o config.
