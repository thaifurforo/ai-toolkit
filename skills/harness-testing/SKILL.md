---
name: harness-testing
description: Use when generating or auditing automated tests for a feature or task. Triggers on "gerar testes", "cobertura", "testar", "testes automatizados". This stage produces the computational sensors of the harness.
---

# Harness: Testing (Stage 06)

**Persona:** QA Engineer.

## Integrations

- **`test-driven-development`** skill — write tests first (invoke during implementation too)
- **`verification-before-completion`** skill before marking the stage done
- **`finishing-a-development-branch`** skill after this stage — finalizes the branch for PR

## Shift-Left Placement

```
pre-commit:  unit tests (fast, deterministic)
pre-push:    integration tests
CI (per PR): integration + structural + contract
CI weekly:   mutation testing
```

## Test Types to Generate

### 1. Unit Tests (pre-commit)
- Each function/method in isolation, mocked dependencies
- Per CA: happy path + expected failure + boundary case

Structure:
```
describe('[Module]', () => {
  describe('CA-01: [criterion]', () => {
    it('should [behavior] when [condition]', ...)
    it('should [failure] when [invalid condition]', ...)
    it('should [edge case] when [boundary value]', ...)
  });
});
```

### 2. Integration Tests (CI per PR)
- Full flow: controller → service → repository
- In-memory DB or testcontainers

### 3. API Contract Tests (CI per PR)
- Correct status codes per scenario
- Response shape (mandatory fields, types)
- Behavior with invalid input

### 4. Structural Tests (CI per PR) ⭐ most important for harnessability

Verify that layers only depend in the allowed direction. Configure per violation:
- Automatically detected
- Error message includes inline remediation instruction
- CI blocks on violation

## CA Coverage Matrix

| CA | ✅ Happy path | ❌ Expected failure | ⚠️ Boundary |
|----|--------------|---------------------|-------------|
| CA-01 | | | |
| CA-02 | | | |

## Test Rules

- Names: `should [behavior] when [condition]` — no vague names
- Structure: Arrange → Act → Assert (blank line between)
- Test observable behaviors, not internal implementation
- Mocks reset between tests (`beforeEach`)
- No `any` in TypeScript tests
- Tests must not depend on execution order

## Expected Output

Complete test suite + structural tests configured + CA traceability + all gates verified.

## Next Step → `harness-documentation`

Then: invoke `finishing-a-development-branch` → open PR → documentation update.

---

**Full prompt template:** See `./prompt.md`
