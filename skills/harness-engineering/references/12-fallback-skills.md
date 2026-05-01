# Referência 12 — Fallback de Skills Externas

Conteúdo essencial das skills externas referenciadas pelo harness-engineering.
**Use apenas quando a skill NÃO estiver disponível no ambiente.**

> Créditos: conteúdo adaptado das skills originais de seus respectivos autores.
> Quando a skill estiver instalada, sempre prefira invocar a skill original.

---

## Como Usar

Para cada skill referenciada nas etapas do pipeline:

```
1. Verificar se a skill está disponível (checar `skills.*: true` em harness.config.yaml)
2. Se disponível → invocar a skill diretamente
3. Se não disponível → seguir o fallback neste arquivo
```

---

## tlc-spec-driven

**Usado em:** Etapas 01–04, 09 — execução especificada, commits atômicos, gates de verificação.

**Princípio:** Auto-dimensionar profundidade pela complexidade. Sempre saber o QUE antes de fazer.

**Fluxo adaptado:**

| Escopo | Specify | Design | Tasks | Execute |
|--------|---------|--------|-------|---------|
| Pequeno (≤3 arquivos) | Quick mode — ir direto para código | — | — | — |
| Médio | Spec breve | Pular | Implícito | Implementar + verificar |
| Grande | Spec completa com IDs | Arquitetura | Breakdown completo | Implementar + verificar por task |

**Regras:**
- Specify e Execute são sempre obrigatórios
- Design é opcional quando não há decisões arquiteturais novas
- Tasks é opcional quando há ≤3 passos óbvios
- **Quick mode:** para bug fixes e tweaks simples — descrever → implementar → verificar → commit

**Commits atômicos:** uma task concluída = um commit. Mensagem: Conventional Commits.

**Gate de verificação:** antes de marcar task como concluída, executar o gate definido (`npm test`, `curl`, etc.) e confirmar saída.

---

## context7

**Usado em:** Etapas 02, 04 — antes de usar qualquer biblioteca externa.

**Princípio:** Buscar documentação atual em vez de depender de conhecimento de treinamento.

**Processo:**

1. **Resolver ID da biblioteca:**
   - Chamar `resolve-library-id` com o nome da biblioteca e a query do usuário
   - Escolher o match mais próximo (benchmark score mais alto)

2. **Buscar documentação:**
   - Chamar `query-docs` com o `libraryId` e a query específica
   - Se resposta insatisfatória: repetir com `researchMode: true`

3. **Usar a documentação:**
   - Basear a implementação no que foi retornado (versão atual)
   - Citar a versão quando relevante

**Fallback sem context7:**
- Verificar documentação oficial online via web search
- Checar `AGENTS.md` e `.catalog/` por padrões já usados no projeto
- Sinalizar com `// UNCERTAIN: API não verificada via context7 — confirmar docs`

---

## brainstorming

**Usado em:** Etapas 01, 02, 09 — quando o escopo ainda não está definido.

**Princípio:** Divergir antes de convergir. Nunca comprometer com a primeira solução.

**Processo:**

1. **Divergir — explorar múltiplos frames:**
   - "Qual problema estamos REALMENTE resolvendo?"
   - "Quem tem esse problema e em que contexto?"
   - "Quais são 3 abordagens radicalmente diferentes?"
   - "O que acontece se não resolvermos isso?"

2. **Questionar premissas:**
   - "Essa é a forma certa de enquadrar o problema?"
   - "Existe uma solução mais simples que ignoramos?"
   - "Quais suposições estamos fazendo sem questionar?"

3. **Convergir — definir escopo claro:**
   - Selecionar abordagem com melhor custo/benefício
   - Documentar as alternativas descartadas e por quê
   - Produzir: problema claramente formulado + escopo delimitado

**Critério de saída:** escopo suficientemente claro para iniciar a etapa seguinte (PRD, Arquitetura, ou nova US).

---

## dispatching-parallel-agents

**Usado em:** Etapas 03, 04 — tasks independentes que podem rodar em paralelo.

**Princípio:** Um agente por domínio de problema independente. Contextos isolados.

**Quando usar:**
- 2+ tasks sem dependência entre si
- Cada task pode ser entendida sem contexto das outras
- Não há estado compartilhado que causaria conflito

**Quando NÃO usar:**
- Tasks relacionadas (resolver uma pode resolver outra)
- Tasks que editam os mesmos arquivos
- Ainda não sabe o que está quebrado (investigar primeiro)

**Processo:**

1. Identificar domínios independentes
2. Para cada agente, construir prompt com:
   - **Escopo específico:** uma task ou arquivo
   - **Objetivo claro:** critério de conclusão
   - **Restrições:** o que NÃO deve ser alterado
   - **Output esperado:** resumo do que foi feito
3. Despachar todos em paralelo (via Task tool)
4. Ao receber resultados: revisar cada resumo → verificar conflitos → integrar → rodar suite completa

---

## writing-plans

**Usado em:** Etapa 03 — criar plano de implementação antes de codar.

**Princípio:** O plano deve ser executável por alguém sem contexto do projeto.

**Estrutura do plano:**

```markdown
# [Feature] — Plano de Implementação

**Goal:** [uma frase]
**Architecture:** [2-3 frases sobre a abordagem]

## Task N: [Nome do Componente]

**Files:**
- Create: `caminho/exato/arquivo.ts`
- Modify: `caminho/existente.ts`

- [ ] Passo 1: Escrever o teste falhando
  [código completo do teste]
- [ ] Passo 2: Rodar e confirmar falha
  Comando: `npm test path/to/test.ts`
- [ ] Passo 3: Implementar código mínimo
  [código completo da implementação]
- [ ] Passo 4: Rodar e confirmar verde
- [ ] Passo 5: Commit
  `git commit -m "feat: [descrição]"`
```

**Regras:**
- Cada passo = uma ação (2–5 minutos)
- Código completo em cada passo de código — sem "TBD" ou "similar ao anterior"
- Caminhos de arquivo exatos
- Comandos com saída esperada
- DRY, YAGNI, TDD, commits frequentes

---

## executing-plans

**Usado em:** Etapa 04 — executar plano task a task.

**Processo:**

1. **Carregar e revisar o plano:**
   - Ler o arquivo de plano
   - Identificar questões ou lacunas antes de começar
   - Se houver problemas: levantar com o usuário antes de prosseguir

2. **Executar cada task:**
   - Marcar como `in_progress`
   - Seguir cada passo exatamente como descrito
   - Rodar verificações conforme especificado
   - Marcar como `done`

3. **Parar imediatamente quando:**
   - Bloqueio (dependência faltando, teste falha repetidamente, instrução ambígua)
   - Lacuna crítica no plano que impede início
   - Verificação falha repetidamente
   - Perguntar ao usuário em vez de adivinhar

**Regra:** Não forçar através de bloqueios. Parar e pedir ajuda.

---

## tdd (test-driven-development)

**Usado em:** Etapas 04, 06 — implementação e testes.

**Lei de Ferro:** `NENHUM CÓDIGO DE PRODUÇÃO SEM UM TESTE FALHANDO PRIMEIRO`

Escreveu código antes do teste? Delete. Recomece.

**Ciclo Red–Green–Refactor:**

```
RED    → Escrever um teste mínimo que falha pelo motivo certo
VERIFY → Rodar e confirmar que falha (não erro — falha)
GREEN  → Escrever código mínimo para passar o teste
VERIFY → Rodar e confirmar que passa; outros testes ainda verde
REFACTOR → Limpar sem adicionar comportamento; confirmar verde
REPEAT → Próximo teste
```

**Regras:**
- Teste falhou pelo motivo esperado? Sim → escrever código. Não → corrigir o teste.
- Código mínimo = o mais simples que passa o teste, nada mais
- Refactor nunca adiciona funcionalidade nova
- Se não consegue escrever o teste, o design está errado

**Red flags — parar e recomeçar:**
- Código antes do teste
- Teste passa imediatamente sem código
- Não consegue explicar por que o teste falhou
- "Vou testar depois"

---

## verification-before-completion

**Usado em:** Etapas 04, 05, 06 — antes de qualquer afirmação de conclusão.

**Princípio:** Evidência antes de afirmação. Sempre.

**Gate:**
```
ANTES de afirmar qualquer status de sucesso:
1. IDENTIFICAR: qual comando prova essa afirmação?
2. RODAR: executar o comando completo (novo, não cached)
3. LER: saída completa, exit code, contagem de falhas
4. VERIFICAR: saída confirma a afirmação?
   Se NÃO → reportar status real com evidência
   Se SIM → fazer a afirmação COM a evidência
5. SÓ ENTÃO → afirmar
```

**Red flags — parar:**
- "Should work now" / "Provavelmente passa"
- Expressar satisfação antes de verificar
- Prestes a fazer commit/PR sem rodar
- Confiando em resultado de execução anterior

---

## systematic-debugging

**Usado em:** Etapa 04 — quando uma task bloqueia após 2+ tentativas.

**Princípio:** Hipótese → evidência → causa raiz. Nunca corrigir sintoma.

**Processo:**
1. **Parar** de tentar soluções aleatórias
2. **Ler** a mensagem de erro completa (literalmente, sem interpretar)
3. **Formar hipótese** sobre causa raiz (não sobre solução)
4. **Isolar** o problema ao menor caso falhando reproduzível
5. **Verificar suposições** uma por uma:
   - Os inputs são o que você acha que são?
   - O ambiente está correto (versões, config)?
   - A lógica faz o que você acha que faz?
6. **Corrigir a causa**, não o sintoma
7. **Verificar** com o mesmo caso isolado

**Sinal de alerta:** se a mesma solução foi tentada >2 vezes, a hipótese está errada. Voltar ao passo 3.

---

## requesting-code-review

**Usado em:** Etapa 05 — antes de abrir PR.

**Processo:**
1. Obter SHAs do git: `BASE_SHA=$(git rev-parse HEAD~1)` e `HEAD_SHA=$(git rev-parse HEAD)`
2. Despachar subagente `code-reviewer` com:
   - O que foi implementado
   - O plano/requisitos (seções relevantes do PRD + CAs)
   - `BASE_SHA` e `HEAD_SHA`
   - Breve descrição
3. Receber feedback e agir:
   - Crítico/Blocker: corrigir antes de avançar
   - Importante: corrigir antes de avançar
   - Menor: corrigir ou documentar decisão

**Princípio:** Revisar cedo, revisar com frequência.

---

## receiving-code-review

**Usado em:** Etapa 05 — ao processar feedback de review.

**Princípio:** Verificação técnica, não performance. Evidência antes de implementar.

**Processo:**
```
1. LER feedback completo sem reagir
2. ENTENDER: reformular o requisito com as próprias palavras (ou perguntar)
3. VERIFICAR: checar contra a realidade do código
4. AVALIAR: faz sentido técnico para ESTE projeto?
5. RESPONDER: reconhecimento técnico ou refutação fundamentada
6. IMPLEMENTAR: um item por vez, testar cada
```

**Proibido:**
- "Você tem toda razão!" / "Ótimo ponto!" (performativo)
- "Vou implementar isso agora" (sem verificar)
- Implementar sem entender todos os itens

**Quando refutar:** sugestão quebra funcionalidade existente, revisor não tem contexto completo, viola YAGNI, tecnicamente incorreto para este stack.

---

## finishing-a-development-branch

**Usado em:** Após Etapa 06 — finalizar branch de feature.

**Processo:**
1. **Verificar testes:** rodar suite completa. Se falham → corrigir antes de continuar.
2. **Determinar branch base:** `git merge-base HEAD main` (ou master/develop)
3. **Apresentar opções:**
   ```
   Implementação completa. O que deseja fazer?
   1. Mergear localmente em [base-branch]
   2. Push e criar Pull Request
   3. Manter a branch como está
   4. Descartar o trabalho
   ```
4. **Executar a escolha:**
   - Opção 1: checkout base → pull → merge → verificar testes → deletar branch
   - Opção 2: `git push -u origin [branch]` → criar PR com resumo
   - Opção 3: reportar localização e encerrar
   - Opção 4: confirmar via texto "discard" → `git branch -D [branch]`

**Regra absoluta:** agente NUNCA mergeia PR. Merge é exclusivamente responsabilidade do humano.

---

## using-git-worktrees

**Usado em:** Etapas 03, 04 — trabalho isolado em branches paralelas.

**Princípio:** Workspace isolado por branch. Nunca misturar contextos.

**Processo:**
1. Verificar diretório: checar `.worktrees/` → `worktrees/` → perguntar ao usuário
2. Verificar que o diretório está no `.gitignore` (projeto-local): `git check-ignore -q .worktrees`
3. Se não estiver ignorado: adicionar ao `.gitignore` e commitar primeiro
4. Criar worktree: `git worktree add .worktrees/[nome-branch] -b [nome-branch]`
5. Rodar setup do projeto (npm install / pip install / etc.)
6. Verificar baseline: rodar testes para confirmar estado limpo
7. Reportar: `Worktree pronto em [caminho] — [N] testes passando`

**Limpeza após concluir:** `git worktree remove [caminho]`

---

## mermaid-studio

**Usado em:** Etapa 02 — criação e rendering de diagramas.

**Fallback sem mermaid-studio:**
- Usar blocos de código mermaid inline nas docs
- Exemplo:
  ````markdown
  ```mermaid
  sequenceDiagram
      participant A
      participant B
      A->>B: request
      B-->>A: response
  ```
  ````
- Ferramentas de preview: [mermaid.live](https://mermaid.live) para validação visual
- Avisar o usuário uma vez: "mermaid-studio não detectado — diagramas gerados como código inline"
