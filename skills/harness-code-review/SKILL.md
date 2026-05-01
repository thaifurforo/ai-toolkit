---
name: harness-code-review
description: Use quando for revisar código antes de abrir um PR, ou ao processar feedback de review. Ativado por "revisar", "code review", "review do PR", "blockers do review". É um sensor inferencial — executar após todos os sensores computacionais (lint, type check, testes) passarem.
---

# Harness: Code Review (Etapa 05)

**Persona:** Engenheiro sênior especialista em qualidade.

## Integrações

> Verificar disponibilidade antes de usar (consultar `harness.config.yaml`).
> Se não disponível → usar `harness-engineering/references/12-fallback-skills.md`.

- **`requesting-code-review`** *(se disponível)* — prepara a descrição do PR e dispara a revisão; *fallback: `12-fallback-skills.md § requesting-code-review`*
- **`receiving-code-review`** *(se disponível)* — processa feedback e rastreia resolução; *fallback: `12-fallback-skills.md § receiving-code-review`*
- **`tlc-spec-driven`** *(se disponível)* — equivalente a `verify work`

> **Execute os sensores computacionais primeiro.** Se lint, type check ou testes estruturais ainda estiverem falhando, corrija-os antes de executar este review inferencial.

## Escala de Severidade

| Símbolo | Nível | Ação |
|---------|-------|------|
| 🔴 | Blocker | Deve corrigir antes do merge |
| 🟠 | Major | Deve corrigir antes do merge |
| 🟡 | Minor | Corrigir ou documentar a decisão |
| 🟢 | Praise | Reconhecer o que foi bem feito (≥1 obrigatório) |

## 6 Dimensões de Review

1. **Corretude** — todos os CAs atendidos? Comportamento correto nos edge cases?
2. **Segurança** — input validation, secrets expostos, auth, SQL injection?
3. **Tratamento de erros** — edge cases cobertos, mensagens informativas?
4. **Testabilidade** — testes cobrem todos os CAs? Casos de falha testados?
5. **Manutenibilidade** — legível, sem duplicação, segue padrões do projeto?
6. **Performance** — N+1 queries, memory leaks, chamadas bloqueantes?

## Copilot PR Review (se `project_tracking.tool: github`)

Quando um PR está aberto e a ferramenta configurada é GitHub, o GitHub Copilot pode postar comentários de revisão nas diff lines. **Se aplicável, processá-los antes da Etapa 05 estar completa:**

1. Buscar comentários de revisão na ordem de preferência:
   - **gh CLI:** `gh pr view <número> --comments` ou `gh api repos/{owner}/{repo}/pulls/{number}/comments`
   - **MCP:** `github-mcp-server-pull_request_read` com `method: get_review_comments`
   - **API REST:** `GET /repos/{owner}/{repo}/pulls/{number}/comments` com `GITHUB_TOKEN`
2. Para cada comentário do Copilot: classificar severidade → corrigir Blockers/Majors → documentar decisões Minor
3. Verificar threads resolvidos (`isResolved: true`)
4. Iterar até não haver Blocker/Major aberto

> **Regra:** Nunca marcar a Etapa 05 completa com threads Blocker/Major abertos no PR.

## Formato Obrigatório de Descrição de PR

Todo PR criado por agente deve incluir:
1. **Resumo** — o que é entregue e por quê
2. **O que foi implementado** — lista detalhada por área (backend/frontend/infra/testes)
3. **User Stories / Critérios de aceite atendidos** — IDs rastreáveis com status ✅
4. **Como testar — Engenheiro** — passos técnicos (build, testes, endpoints)
5. **Como testar — QA** — passos funcionais no browser
6. **Evidências** — saída dos testes, screenshots, respostas do curl
7. **Checklist** — sensores computacionais executados, sem secrets expostos, arch tests OK

**Tamanho de PR:** ideal 300–600 linhas de código funcional (excluindo código auto-gerado). Máximo ~1000 linhas.

> **🚫 RESTRIÇÃO ABSOLUTA — o agente NUNCA faz merge de qualquer PR.**
> Merge é exclusivamente responsabilidade do humano. Sem exceções.

## Saída Esperada

Lista priorizada de achados com localização, impacto e remediação. Pronto para postar no PR.

## Próximo Passo → `harness-testing`

Resolva todos os 🔴 e 🟠. Em seguida, garanta cobertura completa dos CAs.

---

**Template completo de prompt:** Ver `./prompt.md`
