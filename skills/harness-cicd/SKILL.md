---
name: harness-cicd
description: Use quando for configurar pipelines de CI/CD, automatizar sensores ou criar quality gates contínuos. Ativado por "CI/CD", "pipeline", "deploy", "monitoramento", "configurar sensores". Esta etapa codifica todos os sensores computacionais e inferenciais em workflows automatizados.
---

# Harness: CI/CD e Sensores Contínuos (Etapa 08)

**Persona:** Engenheiro de DevOps / Platform Engineering.

## Princípio Central: Shift-Left

Quanto mais cedo um sensor detecta um problema, mais barato é corrigir:
```
Custo de correção:
  pre-commit < pre-push < CI por PR < pós-merge < produção
```

## Arquitetura de Sensores (5 Camadas)

```
Camada 1 — Pré-commit (segundos):  lint + type-check + testes unitários
Camada 2 — Pré-push (minutos):     testes de integração + análise estrutural
Camada 3 — CI por PR (minutos):    todas acima + security scan + build + AI review
Camada 4 — CI pós-merge:           todas acima + mutation testing + arch review completo
Camada 5 — Agendado (semanal):     código morto + docs obsoletas + audit de deps + PR de GC
```

## Gates do Pipeline de CI (por PR)

```yaml
gates:
  - lint          # falha rápida — antes de tudo
  - type-check    # idem
  - unit-tests    # com relatório de cobertura
  - integration   # com testcontainers ou DB em memória
  - structural    # dependency-cruiser / ArchUnit (violações de camada)
  - security      # npm audit / trivy
  - build         # artefato compilável
  - review-agent  # sensor inferencial (code review por IA)
```

**Mensagens de erro do linter devem incluir instruções de remediação inline.** Não apenas a violação — também como corrigir.

## Estratégia de Deploy

| Evento | Ambiente | Ação |
|--------|----------|------|
| PR apontando para `main` | nonprd (staging) | Deploy automático |
| Push para `main` | produção | Deploy após aprovação manual |
| Deploy com falha | qualquer | Rollback automático + alerta |

## Sensor de Garbage Collection (padrão OpenAI)

Workflow agendado semanalmente que:
- Escaneia código morto, testes redundantes, documentação obsoleta
- Abre PRs de limpeza automaticamente
- Mantém a dívida técnica como "pagamentos contínuos pequenos" em vez de grandes recessões

## Endpoint de Healthcheck

```typescript
// GET /health
{
  status: "ok",
  version: "1.2.0",
  uptime: 3600,
  dependencies: { database: "ok" }
}
```

Alertas: taxa de erro >1% por 5min → alerta; P95 latência >[threshold]ms → alerta; deploy com falha → rollback.

## Saída Esperada

Workflows de CI/CD + Dockerfile (multi-stage) + env vars documentadas + healthcheck + sensor de GC agendado.

## Próximo Passo → Deploy → Monitorar → `harness-iteration`

---

**Template completo de prompt:** Ver `./prompt.md`
