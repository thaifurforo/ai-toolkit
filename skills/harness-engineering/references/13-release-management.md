# Referência 13 — Release Management

Como versionar releases, changelogs e release notes conforme `release_management.strategy` em `harness.config.yaml`.

Gestão de projeto é separada. Use `references/11-project-tracking.md` para decidir onde persistir PRD, user stories, tasks e status.

---

## Verificar Config

Ler `release_management.strategy` antes de escrever changelog, aplicar label de release, criar milestone versionada ou preparar PR para `main`.

Estratégias suportadas:

- `github-auto-release`
- `github-legacy`
- `release-please`
- `manual-changelog`
- `none`

Se encontrar config antigo com `project_tracking.mode`, migrar mentalmente:

| `project_tracking.mode` antigo | `project_tracking.tool` | `release_management.strategy` |
|---------------------------------|-------------------------|--------------------------------|
| `github-auto-release` | `github` | `github-auto-release` |
| `github-legacy` | `github` | `github-legacy` |
| `local-markdown` | `local` | `manual-changelog` |

---

## Presets Integrados

### `github-auto-release`

Atalho recomendado quando o projeto usa GitHub para tracking e release automática:

```yaml
project_tracking:
  tool: github
  github:
    milestone_policy: thematic
release_management:
  strategy: github-auto-release
  version_source: pr-label
```

Também pode ser usado com `project_tracking.tool: jira`, `linear`, `azuredevops` ou `local` quando o repositório publica releases pelo GitHub.

Regras:

- PR para `main` deve fechar pelo menos uma issue/work item com closing keyword ou referência equivalente.
- PR deve conter exatamente uma label de impacto: `release:patch`, `release:minor` ou `release:major` por padrão.
- Workflow pós-merge calcula a próxima SemVer e publica GitHub Release.
- Não escrever changelog versionado manual se o workflow já gera release notes.

Classificação recomendada:

- `release:patch`: bug fix, documentação, testes, infraestrutura sem breaking change.
- `release:minor`: capacidade funcional compatível ou user story concluída.
- `release:major`: breaking change, MVP/épico finalizado ou mudança incompatível.

### `github-legacy`

Atalho para projetos que usam milestones do GitHub como planejamento de versão.

Regras:

- Milestones podem representar versões quando `project_tracking.github.milestone_policy: versioned`.
- Issues e PRs devem referenciar a milestone planejada.
- Release notes podem ser geradas a partir das issues fechadas ou mantidas manualmente conforme convenção do projeto.

Não aplicar milestones versionadas quando o projeto declarou milestones temáticas.

---

## Outras Estratégias

### `release-please`

Use quando Conventional Commits alimentam changelog e release automática.

Regras:

- Mensagens de commit devem seguir Conventional Commits.
- Não editar changelog versionado manualmente se Release Please já gerencia o arquivo.
- PRs devem explicar CAs atendidos e evidências; o versionamento vem dos commits.

### `manual-changelog`

Use quando não há automação confiável de release.

Regras:

- Atualizar `CHANGELOG.md` ou `[delivery_docs.path]/.../changelog.md`, conforme configuração.
- Seguir uma estrutura consistente: Added, Changed, Fixed, Removed, Breaking.
- Registrar impacto de versão manualmente quando houver tag/release.

### `none`

Use quando o projeto ainda não publica releases formais.

Regras:

- Não criar labels ou milestones de versão.
- Manter apenas rastreabilidade de entrega no tracking configurado.
- Se o usuário pedir release posteriormente, executar o wizard de release e atualizar `release_management.strategy`.

---

## Cenários de Pressão para Testar a Skill

Use estes cenários ao validar mudanças nesta skill:

1. Projeto usa Jira para trabalho e GitHub Actions para release. O agente deve criar Epics/Stories no Jira e ainda aplicar label `release:*` no PR GitHub.
2. Projeto usa GitHub Projects com milestones temáticas. O agente não deve transformar milestones em versões salvo `milestone_policy: versioned`.
3. Projeto usa `release-please`. O agente não deve escrever changelog versionado manualmente, mesmo se também houver `delivery_docs.path`.
4. Nenhuma ferramenta externa conecta. O agente deve cair para markdown em `delivery_docs.path` sem perder RF → US → CA → T.
