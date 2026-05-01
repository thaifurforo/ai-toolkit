---
name: harness-architecture
description: Use quando for projetar arquitetura técnica de uma feature ou projeto. Ativado por "arquitetura", "stack", "design técnico", "padrão de camadas". Requer PRD como entrada. Auto-skip para features pequenas — ir direto para harness-tasks.
---

# Harness: Arquitetura (Etapa 02)

**Persona:** Arquiteto de software sênior.

## Integrações

> Verificar disponibilidade antes de usar (consultar `harness.config.yaml`).
> Se não disponível → usar `harness-engineering/references/12-fallback-skills.md`.

- **`context7-mcp`** *(se disponível)* — ANTES de recomendar qualquer biblioteca externa: `resolve_library_id` → `get_library_docs`; *fallback: busca web*
- **`brainstorming`** *(se disponível)* — se ainda há alta incerteza técnica; *fallback: `12-fallback-skills.md § brainstorming`*
- **`tlc-spec-driven`** *(se disponível)* — auto-skip para features pequenas — ir direto ao `harness-tasks`

## Quando Usar

Ativadores: "arquitetura", "stack", "design técnico", "padrão de camadas"

**Pule esta etapa** para features simples (1–2 tasks óbvias) → vá direto para `harness-tasks`.

## Padrão de Camadas Obrigatório (padrão OpenAI)

Defina a ordem de dependência e imponha mecanicamente:
```
Types → Config → Repository → Service → Runtime → UI
```
Dependências fluem apenas para frente. Violações → linter bloqueia + mensagem de remediação inline.

## O Que Produzir

1. Tabela de stack (Camada | Tecnologia | Justificativa | RNF atendido)
2. Diagrama de componentes Mermaid — delegar ao `mermaid-studio` se instalado
3. Modelo de dados — entidades, atributos, relacionamentos
4. Contratos de API por fluxo do PRD
5. Diagramas de sequência para fluxos críticos
6. ADRs — contexto, alternativas, trade-offs, consequências
7. Riscos técnicos (Alto/Médio/Baixo) + mitigação
8. **Mapa de harnessability:**
   - Linguagem fortemente tipada? (sensor computacional natural)
   - Limites de módulo claros? (fitness functions possíveis)
   - Framework que abstrai detalhes?
   - Se não: sinalizar riscos e propor estrutura que melhore a harnessability

## Saída Esperada

- `.catalog/` atualizado (`architecture.md`, `stack.md`, `domain.md`)
- `AGENTS.md` criado/atualizado
- Tech Solution persistida conforme `project_tracking.tool` — ver `references/11-project-tracking.md`

## Próximo Passo → `harness-tasks`

Use PRD + arquitetura como contexto.

---

**Template completo de prompt:** Ver `./prompt.md`
