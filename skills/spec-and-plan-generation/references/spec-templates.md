# Spec Templates

Quick reference templates for different track types.

## Feature Spec Template

```markdown
# Specification: [Feature Name]

## Overview
[2-3 paragraphs: What is this feature? Why is it needed? Who will use it?]

## Functional Requirements
- Must [requirement 1]
- Must [requirement 2]
- Should [optional requirement]

## Non-Functional Requirements
- Performance: [metric]
- Security: [requirement]
- Scalability: [requirement]

## Acceptance Criteria
- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]

## Out of Scope
- [What this does NOT include]
```

## Bug Spec Template

```markdown
# Specification: Fix [Bug Name]

## Overview
[Description of the bug and its impact]

## Current Behavior
[What currently happens - the incorrect behavior]

## Expected Behavior
[What should happen - the correct behavior]

## Reproduction Steps
1. [Step 1]
2. [Step 2]
3. [Observe incorrect behavior]

## Acceptance Criteria
- [ ] Bug no longer occurs
- [ ] Existing functionality intact
- [ ] Tests added to prevent regression
```

## Chore Spec Template

```markdown
# Specification: [Chore Name]

## Overview
[What needs to be improved/refactored and why]

## Current State
[Description of current implementation]

## Desired State
[Description of target implementation]

## Scope
- [Area 1 to be changed]
- [Area 2 to be changed]

## Acceptance Criteria
- [ ] [Success criterion 1]
- [ ] [Success criterion 2]

## Out of Scope
- [What will NOT be changed]
```
