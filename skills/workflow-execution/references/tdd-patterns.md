# TDD Workflow Patterns

Quick reference for Test-Driven Development execution patterns.

## Red-Green-Refactor Cycle

### 1. Red (Write Failing Test)
```markdown
### [ ] Task: Add email validation
- [ ] Write test for valid email format
- [ ] Write test for invalid email format
- [ ] Run tests (expect 2 failures)
```

### 2. Green (Make It Pass)
```markdown
- [ ] Implement minimal validation logic
- [ ] Run tests (expect 2 passes)
```

### 3. Refactor (Improve Code)
```markdown
- [ ] Extract validation to helper function
- [ ] Add error messages
- [ ] Run tests (expect 2 passes)
```

## Task Structure for TDD

```markdown
### [ ] Task: [Feature Name]
- [ ] Sub-task: Write tests for [scenario 1]
- [ ] Sub-task: Write tests for [scenario 2]
- [ ] Sub-task: Run tests (expect failures)
- [ ] Sub-task: Implement [feature]
- [ ] Sub-task: Run tests (expect passes)
- [ ] Sub-task: Refactor for clarity
- [ ] Sub-task: Run tests (verify still passes)
```

## Common Test Types

**Unit Tests:**
- Test individual functions/methods
- Mock external dependencies
- Fast execution

**Integration Tests:**
- Test component interactions
- Use real dependencies
- Slower execution

**E2E Tests:**
- Test complete user flows
- Use real environment
- Slowest execution
