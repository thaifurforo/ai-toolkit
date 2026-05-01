# Prompt 07 — Documentação Técnica

## Fase TLC: EXECUTE → validate
## Documentação é para agentes tanto quanto para humanos

---

## Contexto de uso

Documentação existe em duas camadas com responsabilidades distintas:

- **`.catalog/`** — fonte de verdade técnica. Atualizada *apenas quando* a US introduz algo novo: um ADR, padrão emergente, dívida técnica, feature em produção. Não atualize por atualize.
- **GitHub (Issues / Milestone / Releases)** — planejamento, entregas e changelog. Issues fecham via `Closes #N` no PR. Changelog gerado automaticamente por `release-please`.

**Regra:** `AGENTS.md` é a tabela de roteamento (≤100 linhas) — aponta para `.catalog/` e para URLs do GitHub. A Wiki referencia `.catalog/` via blob URL — nunca duplica conteúdo.

---

## Prompt

```
Você é um technical writer com experiência em documentação de sistemas.
Escreva para dois públicos: desenvolvedores humanos e agentes de IA que
iniciam uma nova sessão sem memória do que foi feito antes.

---
## CONTEXTO

**Milestone / US concluída:**
[ex: v1-mvp / US-02 — Autenticação JWT — GitHub Issue #12]

**PRD (seções relevantes):**
[Visão Geral, RFs atendidos, CAs]

**Arquitetura:**
[Stack, endpoints, modelo de dados, padrão de camadas]

**Código implementado:**
[Resumo dos módulos criados/alterados]

**Data:** [data]
---

## 1. FECHAMENTO DA ISSUE NO GITHUB

No body do PR que implementa a US, inclua:

```markdown
Closes #[ISSUE_NUMBER_US]
```

Isso fecha a Issue automaticamente ao mergear o PR, e fecha o Milestone quando todas as Issues estiverem fechadas.

**Não marque manualmente** — o GitHub faz isso via o `Closes` no PR.

---

## 2. DOCS DE CONTEXTO (atualizar só se algo mudou)

Revise cada arquivo abaixo e atualize **apenas** se a US introduziu algo novo.
Se nada mudou, não toque no arquivo.

### `.catalog/architecture.md`

Adicione novos ADRs se surgiram decisões de arquitetura durante a US.
**Jamais delete ADRs existentes — são memória histórica do projeto.**

### `.catalog/conventions.md`

Atualize se um novo padrão de código emergiu e foi adotado durante a US.

### `.catalog/concerns.md`

Adicione nova dívida técnica identificada ou novo risco conhecido.

```markdown
## Dívida técnica conhecida
- [item] — aceita porque: [razão] — revisar em: [quando]
```

### `.catalog/features.md`

Adicione a nova funcionalidade que entrou em produção com esta US.

### Outros arquivos `.catalog/`

Atualize `stack.md`, `structure.md`, `integrations.md` etc. apenas se
a US adicionou dependência nova, reorganizou pastas ou integrou novo serviço.

---

## 3. CHANGELOG E RELEASE NOTES

**Não escreva manualmente.** Use Conventional Commits — o `release-please` gera:
- `CHANGELOG.md` no repositório
- GitHub Release com notas agrupadas por tipo de commit

Tipos que geram release:
- `feat:` → minor bump
- `fix:`, `perf:` → patch bump
- `feat!:` / BREAKING CHANGE → major bump

---

## 4. ATUALIZAÇÃO DE AGENTS.MD (se necessário)

Atualize apenas se novos padrões, arquivos ou URLs emergiram.

```markdown
# [Nome do Projeto] — AGENTS.md

| Se você precisa entender... | Leia |
|-----------------------------|------|
| O que é o projeto | `.catalog/project.md` |
| Arquitetura, ADRs | `.catalog/architecture.md` |
| Milestone atual | [GitHub Milestone URL] |

## Quick start
[comandos essenciais]

## Regras críticas
- [regra 1]
```

---

## 5. DOCUMENTAÇÃO DE API (quando aplicável)

Preferencialmente na **spec OpenAPI** do projeto (não em arquivo separado).
Se o projeto usa openapi-typescript: atualize a spec, não crie `api-docs.md`.

---

## 6. GITHUB WIKI (se mudanças estruturais)

Se a US trouxe mudança estrutural significativa (novo módulo, nova integração):
atualize a página `Home.md` da Wiki para refletir novos links para `.catalog/`.

A Wiki **nunca copia** conteúdo — apenas linka via blob URL:
```markdown
- **[Arquitetura](https://github.com/owner/repo/blob/main/.catalog/architecture.md)**
```

---
## REGRAS

- Linguagem direta — audiência inclui agentes de IA
- `.catalog/` é a fonte de verdade — Wiki e AGENTS.md apontam para lá
- Documente comportamentos observáveis, não implementação interna
- Linter deve validar cross-links em `.catalog/` após atualização
- Jamais delete ADRs — são memória histórica do projeto
- Changelog é gerado automaticamente — não escreva à mão
```

---
## Saída esperada

**Sempre:**
- Issue da US fechada via `Closes #N` no PR

**Se aplicável:**
- `.catalog/[arquivo].md` atualizado (architecture, conventions, concerns, features)
- `AGENTS.md` atualizado com novos links/padrões
- Wiki atualizada se mudança estrutural

## Próximo passo → Prompt 08 (CI/CD)


---

## Prompt

```
Você é um technical writer com experiência em documentação de APIs e sistemas.
Escreva para dois públicos: desenvolvedores humanos e agentes de IA que
iniciam uma nova sessão sem memória do que foi feito antes.

---
## CONTEXTO

**Milestone / US concluída:**
[ex: v1-mvp / US-02 — Autenticação JWT]

**PRD (seções relevantes):**
[Visão Geral, RFs atendidos, CAs]

**Arquitetura:**
[Stack, endpoints, modelo de dados, padrão de camadas]

**Código implementado:**
[Resumo dos módulos criados/alterados]

**Data:** [data]
---

## TIPO A — DOCS DE ENTREGA (atualizar sempre)

### 1. Changelog da US — `.milestones/[milestone]/[US-XX]/changelog.md`

Registre cada mudança relevante ocorrida durante a implementação da US.
Formato: data, o que mudou, por quê, impacto.

```markdown
## [YYYY-MM-DD] — [Título curto da mudança]
**O que mudou:** Descrição objetiva.
**Por quê:** Motivação — o que foi descoberto ou decidido.
**Impacto:** O que foi afetado (spec, arquitetura, escopo).
```

### 2. Tech spec da US — `.milestones/[milestone]/[US-XX]/tech-spec.md`

Marque cada task concluída. Atualize status no topo do arquivo para `✅ Concluída`.

### 3. Milestone — `.milestones/[milestone]/milestone.md`

Marque a US como concluída: `- [x] US-XX: [título]`.
Atualize o status do milestone se todas as USs foram concluídas.

---

## TIPO B — DOCS DE CONTEXTO (atualizar só se algo mudou)

Revise cada arquivo abaixo e atualize **apenas** se a US introduziu algo novo.
Se nada mudou, não toque no arquivo.

### 4. `.catalog/architecture.md`

Adicione novos ADRs se surgiram decisões de arquitetura durante a US.
Jamais delete ADRs existentes — são memória histórica do projeto.

### 5. `.catalog/conventions.md`

Atualize se um novo padrão de código emergiu e foi adotado durante a US.

### 6. `.catalog/concerns.md`

Adicione nova dívida técnica identificada ou novo risco conhecido.

```markdown
## Dívida técnica conhecida

- [item] — aceita porque: [razão] — revisar em: [quando]
```

### 7. `.catalog/features.md`

Adicione a nova funcionalidade que entrou em produção com esta US.

### 8. Outros arquivos `.catalog/`

Atualize `stack.md`, `structure.md`, `integrations.md` etc. apenas se
a US adicionou dependência nova, reorganizou pastas ou integrou novo serviço.

---

## TIPO C — DOCS TÉCNICAS (quando aplicável)

### 9. Atualização de AGENTS.md (mapa do projeto)

AGENTS.md deve ser um **mapa**, não um manual. ≤100 linhas.
Atualize apenas se novos padrões ou arquivos de referência emergiram.

```markdown
# [Nome do Projeto]

## Stack
- [lista concisa]

## Comandos essenciais
- `[cmd]` — [o que faz]

## Estrutura de docs
- .catalog/ — documentação de contexto do projeto
- .milestones/ — documentação de entregas por milestone
- .handoffs/ — handoffs entre sessões de agente

## Regras críticas
- [regra mais importante — 1 linha]
- [regra 2]

## Não faça
- [anti-pattern mais comum — 1 linha]
```

### 10. README de feature nova

Gerar apenas quando a US introduz uma feature que precisa de onboarding.

```markdown
## [Nome da feature]

**O que faz:** [1 parágrafo]

**Como usar:**
```[linguagem]
// exemplo pronto para copiar/colar
```

**Configuração necessária:**
| Variável | Descrição | Obrigatória | Default |
|----------|-----------|-------------|---------|

**Limitações conhecidas:**
- [limitação]
```

### 11. Documentação de API por endpoint

Gerar quando a US adiciona ou altera endpoints. Se o projeto usa OpenAPI/Swagger,
referencie o spec gerado em `.catalog/integrations.md` — não duplique o conteúdo.

```markdown
### [MÉTODO] /[path]

**Descrição:** [o que faz]
**Auth:** [tipo]

**Request:**
| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|

**Response 200:**
```json
{
  "campo": "tipo"
}
```

**Erros:**
| Código | Quando |
|--------|--------|
| 400 | input inválido |
| 401 | não autenticado |
| 404 | não encontrado |
```

---
## REGRAS

- Linguagem direta — audiência inclui agentes de IA
- Exemplos de código prontos para copiar/colar
- Documente comportamentos observáveis, não implementação interna
- Sinalize o que é beta ou sujeito a mudança
- Linter deve validar cross-links após atualização
- Jamais delete ADRs — são memória histórica do projeto
- Docs de entrega: sempre atualizar. Docs de contexto: só se mudou algo real.
```

---
## Saída esperada

**Sempre:**
- `.milestones/[US]/changelog.md` atualizado
- `.milestones/[US]/tech-spec.md` com tasks marcadas
- `.milestones/milestone.md` com US marcada

**Se aplicável:**
- `.catalog/[arquivo].md` atualizado (architecture, conventions, concerns, features)
- `AGENTS.md` atualizado
- README de feature + API docs

## Próximo passo → Prompt 08 (CI/CD)
