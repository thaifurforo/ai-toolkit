# Prompt 08 — CI/CD, Sensores e Garbage Collection

## Objetivo: codificar todos os sensores computacionais e inferenciais no pipeline

> **Integração com `tlc-spec-driven` (Tech Leads Club, opcional)**
> A skill [`tlc-spec-driven`](https://agent-skills.techleads.club) organiza o desenvolvimento em três fases: **SPECIFY → DESIGN → EXECUTE**.
> Esta etapa corresponde à fase **EXECUTE (infra)**: automação dos sensores no pipeline de CI/CD.
> Sem a skill instalada, use o prompt abaixo para configurar os gates manualmente no workflow.

---

## Contexto de uso

O pipeline de CI/CD não é só entrega — é o **sistema de sensores** do harness.
Cada gate é um sensor que detecta problemas antes que cheguem à produção.

**Princípio shift-left:** quanto mais cedo o sensor detecta, mais barato é corrigir.

```
Custo de correção:
  pre-commit < pre-push < CI por PR < pós-merge < produção
```

---

## Prompt

```
Você é um engenheiro de DevOps / Platform Engineering especialista em CI/CD,
observabilidade e harness engineering.

Configure o pipeline completo de CI/CD com todos os sensores computacionais e inferenciais,
respeitando o princípio de shift-left: sensores baratos o mais cedo possível.

---
## CONTEXTO

**Stack:**
- Linguagem: [ex: TypeScript]
- Framework: [ex: NestJS / FastAPI]
- Banco: [ex: PostgreSQL]
- Deploy: [ex: AWS ECS / Vercel / Railway]
- Repositório: [ex: GitHub / GitLab]

**Padrão de camadas:**
[Types → Config → Repository → Service → Runtime → UI]

**RNFs relevantes:**
[Disponibilidade, latência, etc. do PRD]
---

## ARQUITETURA DE SENSORES

### Camada 1 — Pre-commit (local, segundos)

```bash
# .husky/pre-commit ou equivalente
npm run lint          # feedback rápido — falha antes de tudo
npm run type-check    # erro de tipo não chega ao repo
npm test -- --testPathPattern="unit"  # apenas unitários
```

Configure mensagens de erro de linter com remediação inline:
```javascript
// .eslintrc ou dependency-cruiser:
// NÃO: "Importação proibida"
// SIM: "UI não pode importar de Service diretamente. Fix: importe via Runtime (src/runtime/index.ts)"
```

### Camada 2 — Pre-push (local, minutos)

```bash
# .husky/pre-push
npm run test:integration
npx dependency-cruiser src --validate .dependency-cruiser.js
```

### Camada 3 — CI por PR (pipeline, minutos)

```yaml
# .github/workflows/ci.yml
name: CI

on: [pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - run: npm ci

      # Sensores computacionais (rápidos, determinísticos)
      - name: Lint
        run: npm run lint

      - name: Type check
        run: npm run type-check

      - name: Unit tests + coverage
        run: npm test -- --coverage --coverageThreshold='{"global":{"branches":80}}'

      - name: Integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/test

      - name: Structural analysis (layer violations)
        run: npx dependency-cruiser src --validate .dependency-cruiser.js

      - name: Security scan
        run: npm audit --audit-level=high

      - name: Build
        run: npm run build

      # Sensor inferencial (mais caro, semântico)
      - name: AI Code Review
        run: |
          # Execute review inferencial via script ou CLI
          # Ex: claude-review --diff ${{ github.sha }} --config .review-config.yml

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
```

### Camada 4 — CI pós-merge (pipeline, mais longo)

```yaml
# .github/workflows/ci-post-merge.yml
name: Post-merge Quality

on:
  push:
    branches: [main, develop]

jobs:
  deep-quality:
    steps:
      # Repete todos os gates do PR
      # Adiciona sensores mais caros:

      - name: Mutation testing
        run: npx stryker run
        # Mutation testing valida qualidade dos testes, não só cobertura

      - name: Architecture review (inferencial amplo)
        run: |
          # Review com contexto da base completa
          # Verifica consistência cross-feature

      - name: Update quality grade
        run: |
          # Gera relatório e atualiza .catalog/concerns.md automaticamente
```

### Camada 5 — Sensores contínuos (agendados)

```yaml
# .github/workflows/continuous-health.yml
name: Continuous Health Check

on:
  schedule:
    - cron: '0 9 * * 1'  # Segunda-feira, 9h

jobs:
  garbage-collection:
    steps:
      - name: Dead code detection
        run: npx ts-prune  # ou equivalente

      - name: Stale documentation check
        run: |
          # Verifica cross-links em .catalog/
          # Compara AGENTS.md com estrutura real do projeto

      - name: Dependency audit
        run: npm audit

      - name: Architecture drift detection
        run: |
          # Escaneia violações de padrão acumuladas
          # Abre PR de cleanup automaticamente se encontrar

      - name: Auto-cleanup PR
        uses: peter-evans/create-pull-request@v5
        with:
          title: 'chore: harness garbage collection [auto]'
          body: |
            PRs gerados automaticamente pelo sensor contínuo.
            Revise em <1 minuto. Merge se OK.
          branch: 'chore/gc-auto'
```

---
## PIPELINE DE DEPLOY

### Staging (automático)

```yaml
# .github/workflows/deploy-staging.yml
on:
  push:
    branches: [develop]

jobs:
  deploy-staging:
    needs: [quality]  # só deploya se CI passou
    steps:
      - name: Build image
        run: docker build -t $IMAGE:$SHA .

      - name: Deploy
        run: [comando de deploy]

      - name: Smoke test
        run: |
          curl -f https://staging.app/health
          npm run test:smoke -- --env=staging

      - name: Rollback on failure
        if: failure()
        run: [rollback command]
```

### Production (aprovação manual)

```yaml
# .github/workflows/deploy-production.yml
on:
  push:
    branches: [main]

jobs:
  deploy-production:
    needs: [quality]
    environment:
      name: production
      url: https://app.production.com
    # environment com reviewers = aprovação manual obrigatória
    steps:
      - [mesmos passos do staging + smoke test de produção]
```

---
## DOCKERFILE (multi-stage)

```dockerfile
# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage (sem devDependencies)
FROM node:20-alpine AS production
WORKDIR /app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/dist ./dist
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/health || exit 1
CMD ["node", "dist/main"]
```

---
## VARIÁVEIS DE AMBIENTE

| Variável | Descrição | Obrigatória | Exemplo |
|----------|-----------|-------------|---------|
| DATABASE_URL | URL de conexão | sim | postgresql://... |
| [outras] | | | |

**Regra:** nunca hardcode. Secrets no CI/CD secrets manager. Env vars documentadas em `.env.example`.

---
## HEALTHCHECK E MONITORAMENTO

```typescript
// GET /health
{
  status: "ok",
  version: "1.2.0",
  uptime: 3600,
  dependencies: {
    database: "ok",
    cache: "ok"
  }
}
```

Alertas críticos:
- Taxa de erro >1% por 5min → PagerDuty/Slack
- P95 latência >[threshold]ms → alerta
- Deploy falhou → rollback automático + alerta imediato
- Sensor de GC semanal encontrou drift → issue aberta automaticamente
```

---
## Saída esperada
Workflows CI/CD + Dockerfile + env vars + healthcheck + sensor de GC agendado.

## Próximo passo → Deploy → Monitorar → Prompt 09 (Iteração)
