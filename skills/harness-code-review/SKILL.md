---
name: harness-code-review
description: Use when reviewing code before opening a PR, or when processing PR review feedback. Triggers on "revisar", "code review", "review do PR", "blockers do review". This is an inferential sensor — run after all computational sensors (lint, type check, tests) pass.
---

# Harness: Code Review (Stage 05)

**Persona:** Engenheiro sênior especialista em qualidade.

## Integrations

- **`requesting-code-review`** skill — prepares the PR description and triggers the review
- **`receiving-code-review`** skill — processes feedback and tracks resolution
- **TLC:** equivalent to `verify work`

> **Run computational sensors first.** If lint, type check or structural tests are still failing, fix those before running this inferential review.

## Severity Scale

| Symbol | Level | Action |
|--------|-------|--------|
| 🔴 | Blocker | Must fix before merge |
| 🟠 | Major | Must fix before merge |
| 🟡 | Minor | Fix or document decision |
| 🟢 | Praise | Acknowledge good work (≥1 required) |

## 6 Review Dimensions

1. **Corretude** — all CAs met? Correct behavior in edge cases?
2. **Segurança** — input validation, exposed secrets, auth, SQL injection?
3. **Tratamento de erros** — edge cases covered, informative messages?
4. **Testabilidade** — tests cover all CAs? Failure cases tested?
5. **Manutenibilidade** — readable, no duplication, follows project patterns?
6. **Performance** — N+1 queries, memory leaks, blocking calls?

## Copilot PR Review (additional mandatory source)

When a PR is open, GitHub Copilot posts review comments on diff lines. **These must be processed before Stage 05 is complete:**

1. Use `github-mcp-server-pull_request_read` with `method: get_review_comments`
2. For each Copilot comment: classify severity → fix Blockers/Majors → document Minor decisions
3. Verify resolved threads (`isResolved: true`)
4. Iterate until no Blocker/Major is open

> **Rule:** Never mark Stage 05 complete with open Blocker/Major Copilot threads on the PR.

## Mandatory PR Description Format

Every agent-created PR must include:
1. **Resumo** — what is delivered and why
2. **O que foi implementado** — detailed list by area (backend/frontend/infra/tests)
3. **User Stories / Critérios de aceite atendidos** — traceable IDs with ✅ status
4. **Como testar — Engenheiro** — technical steps (build, tests, endpoints)
5. **Como testar — QA** — functional steps in browser
6. **Evidências** — test output, screenshots, curl responses
7. **Checklist** — computational sensors run, no secrets exposed, arch tests OK

**PR size:** ideal 300–600 lines of functional code (excluding auto-generated). Max ~1000 lines.

> **🚫 ABSOLUTE RESTRICTION — agent NEVER merges any PR.**
> Merge is exclusively the human's responsibility. No exceptions.

## Expected Output

Prioritized findings list with location, impact, and remediation. Ready to post on PR.

## Next Step → `harness-testing`

Fix all 🔴 and 🟠. Then ensure full CA coverage.

---

**Full prompt template:** See `./prompt.md`
