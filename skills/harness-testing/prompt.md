# Prompt 06 — Testes Automatizados (Sensores Computacionais)

## Superpowers: `test-driven-development`, `verification-before-completion`
## Após aprovação: acione `finishing-a-development-branch`

> **Integração com `tlc-spec-driven` (Tech Leads Club, opcional)**
> A skill [`tlc-spec-driven`](https://agent-skills.techleads.club) organiza o desenvolvimento em três fases: **SPECIFY → DESIGN → EXECUTE**.
> Esta etapa corresponde ao gate **EXECUTE → UAT / verify work**: sensores computacionais que bloqueiam o merge se falharem.
> Sem a skill instalada, use o prompt abaixo e rode os testes manualmente antes de abrir o PR.

---

## Contexto de uso

Testes são **sensores computacionais** — determinísticos, baratos, rodam a cada commit.
São o mecanismo mais confiável de feedback no harness.

**Shift-left obrigatório:**
- Unitários → pré-commit (pre-commit hook)
- Integração → pré-push ou CI por PR
- Estruturais → CI por PR
- Mutation → pipeline semanal

---

## Prompt

```
Você é um QA Engineer especialista em testes automatizados e design de harness de qualidade.

Com base no código implementado, na user story e nos critérios de aceite, escreva
uma suíte de testes completa que sirva como sensor confiável para esta feature.

---
## CONTEXTO

**User Story:** US-[N]
Como [persona], quero [ação], para que [benefício].

**Critérios de aceite:**
- CA-01: [critério]
- CA-02: [critério]
- CA-03: [critério]

**Stack de testes:**
- Framework: [ex: Jest / Pytest / Vitest]
- HTTP mocking: [ex: MSW / nock / httpx]
- DB: [ex: testcontainers / in-memory / mocks]
- Análise estrutural: [ex: dependency-cruiser / ArchUnit]
- Cobertura mínima: [X]% de branches

**Padrão de camadas:**
[Types → Config → Repository → Service → Runtime → UI]
---

## CÓDIGO A TESTAR

```[linguagem]
[Cole aqui o código implementado]
```

---
## TIPOS DE TESTE A GERAR

### 1. Testes unitários (pré-commit)
- Teste cada função/método isolado
- Mocks para dependências externas
- Por CA: happy path + falha esperada + caso limite

Estrutura obrigatória:
```[linguagem]
describe('[Módulo/Função]', () => {
  beforeEach(() => { /* reset mocks */ });

  describe('CA-01: [critério]', () => {
    it('should [comportamento] when [condição]', async () => {
      // Arrange
      // Act
      // Assert
    });

    it('should [falha esperada] when [condição inválida]', async () => {});
    it('should [caso limite] when [valor limite]', async () => {});
  });
});
```

### 2. Testes de integração (CI por PR)
- Fluxo completo: controller → service → repository
- DB em memória ou testcontainers
- Verifica persistência e efeitos colaterais

### 3. Testes de contrato de API (CI por PR)
- Status codes corretos por cenário
- Shape do response (campos obrigatórios, tipos)
- Comportamento com input inválido

### 4. Testes estruturais (CI por PR)

**Este é o sensor computacional mais importante para harnessability.**

```javascript
// dependency-cruiser: verifica que camadas só dependem na direção correta
// Exemplo de regra:
{
  "forbidden": [{
    "name": "no-ui-to-service-direct",
    "from": { "path": "src/ui" },
    "to": { "path": "src/service" },
    "severity": "error",
    "comment": "UI deve passar por Runtime. Linter error → fix: importe via src/runtime"
  }]
}
```

Configure para cada violação de camada:
- Detecta automaticamente
- Mensagem de erro inclui instrução de remediação inline
- Bloqueia CI se houver violação

### 5. Casos de borda obrigatórios por CA

| CA | ✅ Happy path | ❌ Falha esperada | ⚠️ Caso limite |
|----|--------------|-------------------|----------------|
| CA-01 | | | |
| CA-02 | | | |
| CA-03 | | | |

---
## REGRAS

- Nomes: `should [comportamento] when [condição]` — sem nomes vagos
- Estrutura: Arrange → Act → Assert (sempre separados por linha em branco)
- Teste comportamentos observáveis, não implementação interna
- Mocks resetados entre testes (beforeEach/afterEach)
- Nenhum `any` em TypeScript nos testes
- Testes não devem depender de ordem de execução

---
## VERIFICAÇÃO FINAL (verification-before-completion)

Antes de marcar como concluído, verifique:

```bash
# Unitários
npm test -- --coverage

# Integração
npm run test:integration

# Estrutural
npx dependency-cruiser src --validate .dependency-cruiser.js

# Todos os gates das tasks
[gate-T-01] && [gate-T-02] && ...
```

---
## SAÍDA ESPERADA

```markdown
## Cobertura estimada
- Unitários: [N] testes → [X]% de branches
- Integração: [N] testes
- Contrato API: [N] testes
- Estruturais: [N] regras configuradas

## Rastreabilidade por CA
- CA-01: [N] testes cobrindo ✅❌⚠️
- CA-02: [N] testes cobrindo ✅❌⚠️
- CA-03: [N] testes cobrindo ✅❌⚠️
```
```

---
## Saída esperada
Suíte completa + testes estruturais configurados + rastreabilidade por CA + gates verificados.

## Próximo passo
Acione `finishing-a-development-branch` do Superpowers → PR → Prompt 07 (Docs).
