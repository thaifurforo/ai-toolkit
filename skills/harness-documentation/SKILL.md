---
name: harness-documentation
description: Use when updating documentation after completing a user story or feature. Triggers on "documentar", "README", "doc da API", "atualizar catalog", "atualizar AGENTS.md". Always run after harness-testing to close the delivery loop.
---

# Harness: Documentation (Stage 07)

**Persona:** Technical writer.

## Two Layers — Distinct Responsibilities

```
.catalog/          ← technical source of truth (versioned in the repository)
  architecture.md, conventions.md, concerns.md, features.md, stack.md...

GitHub (Issues / Milestone / Releases)  ← planning, deliveries, changelog
```

**Rule:** `AGENTS.md` is the routing table (≤100 lines) — points to `.catalog/` and GitHub URLs.
Wiki references `.catalog/` via blob URL — **never duplicates content**.

## Type A — Delivery Docs (update always)

After every completed US:
- `.milestones/[milestone]/[US-XX]/changelog.md` — what changed, why, impact
- `.milestones/[milestone]/[US-XX]/tech-spec.md` — mark tasks complete, update status to ✅
- `.milestones/[milestone]/milestone.md` — mark US complete (`- [x] US-XX`)

Close GitHub Issue via `Closes #N` in PR body — GitHub closes automatically on merge.

## Type B — Context Docs (update ONLY if something changed)

Update only when the US introduced something new:

| File | When to update |
|------|---------------|
| `.catalog/features.md` | New functionality implemented |
| `.catalog/architecture.md` | New ADR, layer change, structural pattern |
| `.catalog/conventions.md` | New code pattern emerged |
| `.catalog/concerns.md` | New technical debt or risk |
| `.catalog/stack.md` | New dependency or configuration |

> **Never delete ADRs** — they are the project's historical memory.

## Changelog and Release Notes

**Do not write manually.** Use Conventional Commits — `release-please` generates:
- `CHANGELOG.md` in the repository
- GitHub Release with commits grouped by type

## Expected Output

**Always:** `.milestones/` updated + Issue closed via `Closes #N`

**If applicable:** `.catalog/` updated + `AGENTS.md` updated + Wiki updated if structural change

## Next Step → `harness-cicd`

(or back to `harness-implementation` for the next US in the milestone)

---

**Full prompt template:** See `./prompt.md`
