# Prompt 05 — Code Review (Sensor Inferencial)

## Fase TLC: EXECUTE → verify work
## Superpowers: `requesting-code-review` (preparar PR) + `receiving-code-review` (processar feedback)

---

## Contexto de uso

Este é um **sensor inferencial** — semântico, mais caro, não determinístico.
Execute antes do PR. No pipeline de CI, re-execute com escopo mais amplo (arquitetura global, padrões cross-feature).

Sensores **computacionais** (lint, type check, testes estruturais) já devem ter rodado antes deste.
Se algum computacional ainda estiver falhando, resolva antes de executar este review.

---

## Prompt

```
Você é um engenheiro de software sênior especialista em code review, segurança e qualidade.
Revise o código abaixo com olhar crítico e construtivo. Seu objetivo é encontrar problemas
antes que cheguem à produção — não elogiar o trabalho.

---
## CONTEXTO

**User Story:** US-[N] — [descrição]

**Critérios de aceite:**
- CA-01: [critério]
- CA-02: [critério]

**Padrão de camadas do projeto:**
[ex: Types → Config → Repository → Service → Runtime → UI]
[Cole as regras de dependência da arquitetura]

**Convenções:**
- Linguagem: [ex: TypeScript strict]
- Framework: [ex: NestJS]
- Cobertura mínima: [X]%
- Outras regras relevantes do AGENTS.md
---

## CÓDIGO A REVISAR

```diff
[Cole aqui o diff completo do PR ou os arquivos alterados]
```

---
## DIMENSÕES DE AVALIAÇÃO

Revise em 6 dimensões. Classifique cada achado:

🔴 **Blocker** — impede o merge
- Bug que quebra funcionalidade
- Falha de segurança (injection, auth, exposição de dados)
- Quebra de contrato de API
- Violação do padrão de camadas (se linter não pegou)

🟠 **Major** — deve resolver antes do merge
- Má prática que acumulará dívida
- Performance crítica (N+1, blocking call)
- Teste ausente para CA crítico
- Duplicação significativa

🟡 **Minor** — sugestão de melhoria
- Legibilidade, nomenclatura
- Otimização não crítica
- Estilo fora do padrão (mas não crítico)

🟢 **Praise** — reconheça o que foi bem feito
(pelo menos 1 obrigatório — equilibra o feedback)

### Dimensões:

1. **Corretude** — todos os CAs atendidos? Comportamento correto nos edge cases?
2. **Segurança** — input validation, exposição de dados sensíveis, auth, SQL injection?
3. **Tratamento de erros** — edge cases cobertos, mensagens informativas, propagação correta?
4. **Testabilidade** — testes cobrem todos os CAs? Casos de falha testados? Mocks corretos?
5. **Manutenibilidade** — legível, sem duplicação, segue padrões do projeto?
6. **Performance** — N+1 queries, memory leaks, chamadas bloqueantes desnecessárias?

---
## FORMATO DE SAÍDA

```markdown
## Resumo do review
[2–3 linhas: avaliação geral, contagem de 🔴/🟠/🟡/🟢]

---
## Achados

### 🔴 [Blocker] [Título curto]
**Arquivo:** src/[caminho]:[linha]
**Problema:** [descrição clara]
**Impacto:** [o que acontece se não corrigir]
**Remediação:**
```[linguagem]
// código corrigido
```

### 🟠 [Major] [Título curto]
...

### 🟡 [Minor] [Título curto]
...

### 🟢 [Praise]
[O que foi bem feito e por quê]

---
## Checklist de aprovação
- [ ] Todos os 🔴 resolvidos
- [ ] Todos os 🟠 resolvidos (ou justificados com DEBT comment)
- [ ] CA-01 verificado no código
- [ ] CA-02 verificado no código
- [ ] Testes passando (gate confirmado)
- [ ] Padrão de camadas respeitado
```

---
## SENSOR NO PIPELINE (escopo ampliado)

Para o review no CI (pós-integração), adicione estas dimensões:

- **Consistência arquitetural**: este código é consistente com features similares já implementadas?
- **Drift de padrão**: alguma convenção nova emergiu que não está no AGENTS.md?
- **Dívida técnica**: algum DEBT comment introduzido deve ser registrado em .catalog/concerns.md?
```

---
## Saída esperada
Lista priorizada de achados com localização, impacto e remediação. Pronto para colar no PR.

## Próximo passo → Prompt 06 (Testes)
Resolva 🔴 e 🟠. Depois garanta cobertura completa dos CAs.

---

## Política de PRs e Merge

### 🚫 Regra absoluta: agente NUNCA faz merge de qualquer PR

O merge de qualquer PR é **exclusivamente uma ação humana**. Sem exceções.

O agente pode:
- Criar branches, commitar, pushar
- Abrir PRs com descrições completas
- Executar code review e postar comentários
- Resolver threads, corrigir blockers
- Rodar CI e corrigir falhas

O agente **não pode**:
- Aprovar PRs
- Fazer merge de PRs
- Fechar PRs definitivamente

---

### Formato obrigatório de descrição de PR

Todo PR criado ou preparado por agente deve usar o seguinte template:

```markdown
## Resumo

[1-2 parágrafos: o que esta PR entrega e por que é necessária]

## O que foi implementado

### Backend
- [lista de mudanças]

### Frontend
- [lista de mudanças]

### Testes
- [tipos de testes adicionados, contagem]

### Infraestrutura / Docs
- [mudanças em CI, docker, docs]

## Critérios de aceite atendidos

- ✅ CA-01: [descrição]
- ✅ CA-02: [descrição]

## Como testar — Engenheiro

1. `cd backend && dotnet build` → deve compilar sem erros
2. `dotnet test` → todos os testes devem passar
3. Inicie o servidor: `cd backend/src/TravellersHelper.Web && dotnet run`
4. Teste endpoint X: `curl -X POST http://localhost:5032/api/...`

## Como testar — QA

1. Abra o browser em http://localhost:5173
2. Navegue até [página]
3. Execute ação [X]
4. Verifique que [comportamento esperado]

## Evidências

### Testes passando
```
dotnet test
Test run for... 
X passed, 0 failed
```

### Endpoints respondendo
```bash
curl -X GET http://localhost:5032/health
{"status":"ok","version":"1.0.0"}
```

## Checklist

- [ ] `dotnet build --warnaserror` sem warnings
- [ ] `dotnet test` passando (N testes)
- [ ] `npm test` passando (N testes)
- [ ] Arch tests sem violações de camada
- [ ] Nenhum secret exposto
- [ ] Code review por agente executado (blockers/majors resolvidos)
```

---

### Tamanho de PR

| Tamanho | Linhas de código funcional | Status |
|---------|--------------------------|--------|
| Ideal   | 300–600                  | ✅ Fácil de revisar |
| Aceitável | 600–1000               | ⚠️ Revisar em sessões |
| Grande  | >1000                    | 🔴 Dividir antes do review |

> Código auto-gerado (migrations, OpenAPI schema) não conta para o limite.
> Um PR = um contexto coeso de review. Não misturar features não relacionadas.

---

### Processo padrão de review com agente

1. Agente abre PR com descrição completa (usando template acima)
2. CI executa sensores computacionais (lint, tests, arch tests)
3. Agente executa `superpowers:code-reviewer` e posta resultado no PR como comentário
4. Agente endereça blockers 🔴 e majors 🟠 encontrados
5. Agente resolve threads após correções
6. **Humano faz o review final e executa o merge** — nunca o agente

