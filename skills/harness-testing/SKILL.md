---
name: harness-testing
description: Use quando for gerar ou auditar testes automatizados de uma feature ou task. Ativado por "gerar testes", "cobertura", "testar", "testes automatizados". Esta etapa produz os sensores computacionais do harness.
---

# Harness: Testes (Etapa 06)

**Persona:** QA Engineer.

## Integrações

> Verificar disponibilidade antes de usar (consultar `harness.config.yaml`).
> Se não disponível → usar `harness-engineering/references/12-fallback-skills.md`.

- **`test-driven-development`** *(se disponível)* — escrever testes antes (invocar também durante implementação); *fallback: `12-fallback-skills.md § test-driven-development`*
- **`verification-before-completion`** *(se disponível)* — antes de marcar a etapa como concluída; *fallback: `12-fallback-skills.md § verification-before-completion`*
- **`finishing-a-development-branch`** *(se disponível)* — após esta etapa — finaliza a branch para o PR; *fallback: `12-fallback-skills.md § finishing-a-development-branch`*

## Posicionamento Shift-Left

```
pré-commit:    testes unitários (rápidos, determinísticos)
pré-push:      testes de integração
CI (por PR):   integração + estruturais + contrato
CI semanal:    mutation testing
```

## Tipos de Teste a Gerar

### 1. Testes Unitários (pré-commit)
- Cada função/método em isolamento, dependências mockadas
- Por CA: happy path + falha esperada + caso limite

Estrutura:
```
describe('[Módulo]', () => {
  describe('CA-01: [critério]', () => {
    it('should [comportamento] when [condição]', ...)
    it('should [falha] when [condição inválida]', ...)
    it('should [caso limite] when [valor limite]', ...)
  });
});
```

### 2. Testes de Integração (CI por PR)
- Fluxo completo: controller → service → repository
- DB em memória ou testcontainers

### 3. Testes de Contrato de API (CI por PR)
- Status codes corretos por cenário
- Shape do response (campos obrigatórios, tipos)
- Comportamento com input inválido

### 4. Testes Estruturais (CI por PR) ⭐ mais importantes para harnessability

Verificar que as camadas dependem apenas na direção permitida. Configurar por violação:
- Detectado automaticamente
- Mensagem de erro inclui instrução de remediação inline
- CI bloqueia em caso de violação

## Matriz de Cobertura por CA

| CA | ✅ Happy path | ❌ Falha esperada | ⚠️ Caso limite |
|----|--------------|-------------------|----------------|
| CA-01 | | | |
| CA-02 | | | |

## Regras de Teste

- Nomes: `should [comportamento] when [condição]` — sem nomes vagos
- Estrutura: Arrange → Act → Assert (linha em branco entre cada parte)
- Teste comportamentos observáveis, não implementação interna
- Mocks resetados entre testes (`beforeEach`)
- Nenhum `any` em testes TypeScript
- Testes não devem depender de ordem de execução

## Saída Esperada

Suíte completa + testes estruturais configurados + rastreabilidade por CA + todos os gates verificados.

## Próximo Passo → `harness-documentation`

Em seguida: invocar `finishing-a-development-branch` → abrir PR → atualizar documentação.

---

**Template completo de prompt:** Ver `./prompt.md`
