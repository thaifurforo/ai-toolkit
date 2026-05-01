---
name: harness-architecture
description: Use when designing technical architecture for a feature or project. Triggers on "arquitetura", "stack", "design técnico", "padrão de camadas". Requires PRD as input. Auto-skip for small features — go directly to harness-tasks.
---

# Harness: Architecture (Stage 02)

**Persona:** Arquiteto de software sênior.

## Integrations

- **Context7:** Use before recommending any external library — `resolve_library_id` → `get_library_docs`
- **`brainstorming`** skill if there is still high technical uncertainty
- **TLC:** auto-skip for small features — go directly to `harness-tasks`

## When to Use

Triggers: "arquitetura", "stack", "design técnico", "padrão de camadas"

**Skip this stage** for simple features (1–2 obvious tasks) → go to `harness-tasks` directly.

## Mandatory Layer Pattern (OpenAI pattern)

Define dependency order and enforce mechanically:
```
Types → Config → Repository → Service → Runtime → UI
```
Dependencies flow forward only. Violations → linter blocks + inline remediation message.

## What to Produce

1. Stack table (Layer | Tech | Justification | RNF addressed)
2. Mermaid component diagram — delegate to `mermaid-studio` if installed
3. Data model — entities, attributes, relationships
4. API contracts per PRD flow
5. Sequence diagrams for critical flows
6. ADRs — context, alternatives, trade-offs, consequences
7. Technical risks (Alto/Médio/Baixo) + mitigation
8. **Harnessability map:**
   - Strongly typed language? (natural computational sensor)
   - Clear module boundaries? (fitness functions possible)
   - Framework that abstracts details?
   - If not: flag risks and propose structure that improves harnessability

## Expected Output

- `.catalog/` updated (`architecture.md`, `stack.md`, `domain.md`)
- `AGENTS.md` created/updated
- Tech Solution as GitHub Issue (label `documentation`) linked to Milestone
- GitHub Wiki page referencing `.catalog/` via blob URL

## Next Step → `harness-tasks`

Use PRD + architecture as context.

---

**Full prompt template:** See `./prompt.md`
