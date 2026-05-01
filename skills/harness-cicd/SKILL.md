---
name: harness-cicd
description: Use when configuring CI/CD pipelines, automating sensors, or setting up continuous quality gates. Triggers on "CI/CD", "pipeline", "deploy", "monitoramento", "configurar sensores". This stage codifies all computational and inferential sensors into automated workflows.
---

# Harness: CI/CD & Continuous Sensors (Stage 08)

**Persona:** Engenheiro de DevOps / Platform Engineering.

## Core Principle: Shift-Left

The earlier a sensor detects a problem, the cheaper the fix:
```
Custo de correção:
  pre-commit < pre-push < CI por PR < pós-merge < produção
```

## Sensor Architecture (5 Layers)

```
Layer 1 — Pre-commit (seconds):  lint + type-check + unit tests
Layer 2 — Pre-push (minutes):    integration tests + structural analysis
Layer 3 — CI per PR (minutes):   all above + security scan + build + AI review
Layer 4 — Post-merge CI:         all above + mutation testing + full arch review
Layer 5 — Scheduled (weekly):    dead code + stale docs + dependency audit + GC PR
```

## CI Pipeline Gates (per PR)

```yaml
gates:
  - lint          # fails fast — before everything
  - type-check    # ditto
  - unit-tests    # with coverage report
  - integration   # with testcontainers or in-memory DB
  - structural    # dependency-cruiser / ArchUnit (layer violations)
  - security      # npm audit / trivy
  - build         # compilable artifact
  - review-agent  # inferential sensor (AI code review)
```

**Linter error messages must include inline remediation instructions.** Not just the violation — also how to fix it.

## Deploy Strategy

| Event | Environment | Action |
|-------|-------------|--------|
| PR targeting `main` | nonprd (staging) | Automatic deploy |
| Push to `main` | production | Deploy after manual approval |
| Deploy failed | any | Automatic rollback + alert |

## Garbage Collection Sensor (OpenAI pattern)

Weekly scheduled workflow that:
- Scans dead code, redundant tests, stale documentation
- Automatically opens cleanup PRs
- Keeps technical debt as "small continuous payments" instead of large recessions

## Healthcheck Endpoint

```typescript
// GET /health
{
  status: "ok",
  version: "1.2.0",
  uptime: 3600,
  dependencies: { database: "ok" }
}
```

Alerts: error rate >1% for 5min → alert; P95 latency >[threshold]ms → alert; deploy failed → rollback.

## Expected Output

CI/CD workflows + Dockerfile (multi-stage) + env vars documented + healthcheck + GC scheduled sensor.

## Next Step → Deploy → Monitor → `harness-iteration`

---

**Full prompt template:** See `./prompt.md`
