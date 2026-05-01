---
name: harness-implementation
description: Use quando for implementar uma task técnica do breakdown. Ativado por "implementar", "código", "implement T-XX", "executar task". Uma task por invocação. Requer PRD (seções relevantes) + arquitetura + AGENTS.md como contexto.
---

# Harness: Implementação (Etapa 04)

**Persona:** Engenheiro de software sênior.

## Integrações

> Verificar disponibilidade antes de usar (consultar `harness.config.yaml`).
> Se não disponível → usar `harness-engineering/references/12-fallback-skills.md`.

- **`executing-plans`** *(se disponível)* — gerenciar execução task a task; *fallback: `12-fallback-skills.md § executing-plans`*
- **`test-driven-development`** *(se disponível)* — escrever testes antes ou junto; *fallback: `12-fallback-skills.md § test-driven-development`*
- **`systematic-debugging`** *(se disponível)* — se a task bloquear por >2 tentativas; *fallback: `12-fallback-skills.md § systematic-debugging`*
- **`verification-before-completion`** *(se disponível)* — antes de marcar task concluída; *fallback: `12-fallback-skills.md § verification-before-completion`*
- **`using-git-worktrees`** *(se disponível)* — para trabalho paralelo em tasks independentes; *fallback: branches sequenciais*
- **`context7-mcp`** *(se disponível)* — OBRIGATÓRIO antes de usar qualquer biblioteca externa: `resolve_library_id` → `get_library_docs`; *fallback: busca web*
- **`tlc-spec-driven`** *(se disponível)* — use trigger `implement` — TLC gerencia commits atômicos e verificação

## Antes de Qualquer Código

> ⚠️ **Crie a branch da task primeiro:**
> ```bash
> # Sem dependência → base em develop
> git checkout develop && git pull
> git checkout -b feature/T-[N]-descricao
>
> # Com Depends: T-YY → base na branch da dependência
> git checkout feature/T-YY
> git checkout -b feature/T-[N]-descricao
> ```
> Uma task = uma branch. Nunca faça commit de uma task na branch de outra task.

## Cadeia de Verificação de Contexto

Antes de escrever qualquer código:
1. Codebase — existe padrão similar implementado? Se sim, siga-o.
2. `AGENTS.md` e `.catalog/` — convenções relevantes para esta camada?
3. Context7: `resolve_library_id` → `get_library_docs` para cada lib externa
4. Busca web — apenas se Context7 não cobrir

## Sprint Contract (padrão Anthropic)

Antes de codar, proponha:
```
Vou implementar: [o que será construído]
Arquivos afetados: [lista]
Sucesso verificado por: [como testar CA-01, CA-02...]
Gate: [comando]
Fora do escopo desta task: [o que NÃO será feito]
```
Aguarde validação antes de avançar para o código.

## O Que Produzir

1. Código completo
2. Testes unitários (TDD — escrever antes ou junto)
3. Mensagem de commit (Conventional Commits)
4. Checklist de conclusão: done when + gate executado

## Anotações Obrigatórias

```typescript
// TODO: clarificar com PM — [dúvida sobre requisito]
// RISK: [risco técnico identificado]
// DEBT: [dívida técnica intencional — aceita porque: razão]
// UNCERTAIN: [API não verificada via Context7 — confirmar]
```

## Gestão de Contexto

Se o contexto ultrapassar ~40% da janela: escrever handoff em `.handoffs/handoff-T-[N].md` (formato JSON) e reiniciar.

## Saída Esperada

Código + testes + mensagem de commit + checklist de conclusão + `.milestones/` atualizado.

## Próximo Passo → `harness-code-review`

Antes de abrir o PR. Usar `requesting-code-review` do Superpowers.

---

**Template completo de prompt:** Ver `./prompt.md`
