# Skills

Reusable AI agent skills following the [agentskills.io](https://agentskills.io) specification.

## harness-engineering (pipeline)

Orchestrator skill + 9 sub-skills covering the full AI-driven development pipeline:

| Skill | Stage |
|-------|-------|
| [harness-engineering](./harness-engineering/) | Orchestrator — pipeline overview, mental model, flows |
| [harness-prd](./harness-prd/) | 01 — PRD with ProductBuddy |
| [harness-architecture](./harness-architecture/) | 02 — Technical architecture |
| [harness-tasks](./harness-tasks/) | 03 — Task breakdown |
| [harness-implementation](./harness-implementation/) | 04 — Implementation loop |
| [harness-code-review](./harness-code-review/) | 05 — Code review (inferential sensor) |
| [harness-testing](./harness-testing/) | 06 — Automated tests (computational sensor) |
| [harness-documentation](./harness-documentation/) | 07 — Documentation |
| [harness-cicd](./harness-cicd/) | 08 — CI/CD and continuous sensors |
| [harness-iteration](./harness-iteration/) | 09 — Iteration with feedback |

Each sub-skill contains:
- `SKILL.md` — overview, persona, integrations, process summary, expected output
- `prompt.md` — full prompt template (heavy reference)

### Usage

Install with your agent skill manager or copy to `~/.agents/skills/` (Codex) / `~/.claude/skills/` (Claude Code).

Each skill is self-contained and can be invoked independently.
