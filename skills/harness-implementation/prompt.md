# Prompt 04 — Implementação (Loop Principal)

> **Context7 ([context7.com](https://context7.com), opcional)**
> Busca documentação atualizada de bibliotecas diretamente na fonte. Acionar **obrigatoriamente** antes de usar qualquer lib externa.
> Sem ele, consulte a documentação oficial da lib e verifique breaking changes na versão em uso antes de escrever código.

> **Skills Superpowers ([github.com/obra/superpowers](https://github.com/obra/superpowers), opcionais)**
> Skills especializadas instaláveis em `~/.claude/skills/` (Claude Code) ou `~/.agents/skills/` (demais agentes).
> - `executing-plans` — executa o plano de tasks com controle de progresso, uma por vez, com commit por task
> - `test-driven-development` — garante que o teste é escrito antes do código em cada implementação
> - `systematic-debugging` — ativar quando travar: protocolo de investigação por hipóteses antes de alterar código
> - `verification-before-completion` — checklist obrigatório antes de marcar qualquer task como concluída
> Sem elas, siga o sprint contract e os gates definidos no prompt abaixo.

> **Integração com `tlc-spec-driven` (Tech Leads Club, opcional)**
> A skill [`tlc-spec-driven`](https://agent-skills.techleads.club) organiza o desenvolvimento em três fases: **SPECIFY → DESIGN → EXECUTE**.
> Esta etapa corresponde à fase **EXECUTE** — uma task por vez, com commits atômicos e gates de verificação gerenciados pelo TLC.
> Sem a skill instalada, use o prompt abaixo e siga o sprint contract manualmente.

---

## Prompt

```
Você é um engenheiro de software sênior. Implemente a task abaixo seguindo
rigorosamente a arquitetura, as convenções do projeto e as práticas de Harness Engineering.

---
## CONTEXTO DO PROJETO

**AGENTS.md:**
[Cole o conteúdo de AGENTS.md — é o mapa do projeto]

**PRD (seções relevantes):**
[Requisitos funcionais da US, personas, critérios de aceite]

**Arquitetura:**
[Stack, padrão de camadas, estrutura de pastas, padrões definidos]

**Convenções:**
- Linguagem: [ex: TypeScript strict]
- Framework: [ex: NestJS / FastAPI]
- Commits: Conventional Commits
- Linting: [ferramenta + regras de camada]
- Testes: [framework], cobertura mínima [X]%
---

## TASK A IMPLEMENTAR

**ID:** T-[N]
**User Story:** US-[N]
**Descrição:** [descrição]
**Camada:** [ex: Service — conforme arquitetura]
**Where:** [arquivo/módulo]
**Done when:** [condição objetiva]
**Gate:** [comando verificável]
**Depends:** [T-XX ou nenhuma]
**Reuses:** [componente existente ou nada]

---
## GIT: CRIAÇÃO DE BRANCH

Antes de qualquer código, crie a branch correta:

```bash
# Sem dependência → base em develop
git checkout develop && git pull
git checkout -b feature/T-[N]-descricao

# Com Depends: T-YY → base na branch da dependência
git checkout feature/T-YY
git checkout -b feature/T-[N]-descricao
```

O PR desta task deve apontar para a mesma branch usada como base acima.
Só aponte para `develop`/`main` quando a dependência já tiver sido mesclada
(nesse caso, faça `git rebase develop` antes de abrir o PR).

**Worktree (recomendado para agents):** se este agent executa em paralelo com outro, use um worktree dedicado para esta task em vez do working tree principal — evita conflitos de estado entre agents simultâneos:

```bash
git worktree add ../projeto-T-[N] feature/T-[N]-descricao
cd ../projeto-T-[N]
# trabalhe aqui; ao concluir:
cd ../projeto-principal
git worktree remove ../projeto-T-[N]
```

Use `using-git-worktrees` do Superpowers se disponível.

---

## PRÉ-IMPLEMENTAÇÃO: VERIFICAÇÃO DE CONTEXTO

Antes de escrever qualquer código, siga esta cadeia:

1. **Codebase** — existe padrão similar implementado? Se sim, siga-o.
2. **`.catalog/`** e **AGENTS.md** — convenções relevantes para esta camada?
3. **Context7** — para cada lib externa que vai usar:
   ```
   resolve_library_id("[nome da lib]") → get_library_docs("[id]", topic="[tópico]")
   ```
   Nunca assuma APIs de memória. Se não encontrou na cadeia, sinalize como `// UNCERTAIN:`.
4. **Web search** — apenas se Context7 não cobrir.

---
## SPRINT CONTRACT (negocie antes de codar)

Antes de implementar, proponha:

```
Vou implementar: [o que será construído]
Arquivos afetados: [lista]
Sucesso verificado por: [como testar CA-01, CA-02...]
Gate: [comando]
Fora do escopo desta task: [o que não será feito]
```

Aguarde validação antes de avançar para o código.

---
## O QUE PRODUZIR

### 1. Código completo

```[linguagem]
// Arquivo: src/[caminho]/[arquivo]
```

### 2. Testes unitários (TDD — escreva antes ou junto)

Use `test-driven-development` do Superpowers se disponível.

```[linguagem]
// Arquivo: src/[caminho]/[arquivo].spec.ts
// Estrutura: Arrange → Act → Assert
// Nomes: should [comportamento] when [condição]
```

### 3. Commit (Conventional Commits)

```
tipo(escopo): descrição curta

[corpo explicando o porquê — não o quê]

Closes: T-[N], CA-01, CA-02
```

### 4. Checklist de conclusão

```
- [ ] Gate executado: `[cmd]` → resultado: [output esperado]
- [ ] CA-01 verificado: [como]
- [ ] CA-02 verificado: [como]
- [ ] Camada de arquitetura respeitada (linter passou)
- [ ] Nenhuma API de lib inventada (Context7 consultado)
- [ ] `.milestones/` atualizado (task marcada como concluída)
```

---
## SINALIZAÇÕES OBRIGATÓRIAS

```typescript
// TODO: clarificar com PM — [dúvida sobre requisito]
// RISK: [risco técnico identificado]
// DEBT: [dívida técnica intencional — aceita porque: razão]
// UNCERTAIN: [API não verificada via Context7 — confirmar]
```

---
## GESTÃO DE CONTEXTO

Se perceber que o contexto está acima de ~40% da janela:
1. Pause antes de iniciar a próxima task
2. Escreva `.handoffs/handoff-T-[N].md`:
   ```json
   {
     "task_atual": "T-XX",
     "status": "em andamento / concluída",
     "proximo": "T-XX",
     "decisoes": ["decisão tomada 1", "decisão tomada 2"],
     "pendencias": ["item pendente"],
     "arquivos_alterados": ["src/..."]
   }
   ```
3. Sinalize: "Contexto alto — escrevi handoff em .handoffs/. Reinicie e leia o handoff antes de continuar."

---
## REGRAS

- Use apenas o que está na arquitetura definida e verificado via Context7
- Não implemente além do escopo desta task (YAGNI)
- Se linter falhar, leia a mensagem de remediação inline antes de tentar corrigir
- Trate todos os edge cases dos critérios de aceite
- Use `systematic-debugging` do Superpowers se a task travar por >2 tentativas
```

---
## Saída esperada
Código + testes + commit message + checklist de conclusão + .milestones/ atualizado.

## Próximo passo → Prompt 05 (Code Review)
Antes de abrir o PR. Acione `requesting-code-review` do Superpowers.
