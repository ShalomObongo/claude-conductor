---
description: "Creates a new track (feature/bug) with spec and plan generation"
argument-hint: "[track description]"
allowed-tools: ["Read", "Write", "Bash", "AskUserQuestion", "Edit"]
---

# NewTrack Command

Create a new Conductor track (feature, bug, or chore) with interactive specification and implementation plan generation.

## System Directive

You are executing the Conductor newTrack command. Your function is to guide the user through creating a detailed specification and hierarchical implementation plan for a new unit of work.

**CRITICAL**: Validate success of every tool call. If any fails, halt and await instructions.

## Setup Check

Verify Conductor environment is set up:

1. **Check Required Files**: Verify these exist:
   - `conductor/tech-stack.md`
   - `conductor/workflow.md`
   - `conductor/product.md`

2. **Handle Missing Files**: If ANY missing, halt and inform:
   > "Conductor is not set up. Please run `/claude-conductor:setup` to initialize the environment."

## Track Initialization

### Step 1: Get Track Description

1. **If `{{args}}` contains description**: Use it
2. **If `{{args}}` is empty**: Ask user:
   > "Please provide a brief description of the track (feature, bug fix, chore, etc.)."

### Step 2: Determine Track Type

Analyze description to classify as:
- **Feature**: New functionality or capability
- **Bug**: Fix for existing issue
- **Chore**: Maintenance, refactoring, or technical debt
- **Other**: Specify type

Do NOT ask user to classify - infer from description.

### Step 3: Load Project Context

Read and understand:
- `conductor/product.md`
- `conductor/tech-stack.md`
- `conductor/workflow.md`

## Interactive Specification Generation

### Questioning Strategy

Use AskUserQuestion to gather requirements. Present 2-3 options per question, always include "Type your own answer".

**Question Types**:
- **Additive** (multiple answers): Add "(Select all that apply)" - for brainstorming scope
- **Exclusive Choice** (single answer): No "(Select all that apply)" - for singular decisions

**For Features** (3-5 questions):
- What specific functionality should this provide?
- Who will use this feature and how?
- What are the inputs and outputs?
- How should it integrate with existing features?
- What are the acceptance criteria?

**For Bugs** (2-3 questions):
- What is the current behavior?
- What is the expected behavior?
- How can this be reproduced?

**For Chores** (2-3 questions):
- What needs to be improved or refactored?
- What is the scope of changes?
- What are the success criteria?

### Draft Specification

Create `spec.md` with sections:
- **Overview**: High-level description
- **Functional Requirements**: What it must do
- **Non-Functional Requirements**: Performance, security, etc. (if applicable)
- **Acceptance Criteria**: Definition of done
- **Out of Scope**: What this does NOT include

### User Confirmation

Present drafted spec to user:
> "I've drafted the specification for this track. Please review:"
>
> ```markdown
> [Drafted spec.md content]
> ```
>
> "Does this accurately capture the requirements? Please suggest changes or confirm."

Await feedback and revise until confirmed.

## Interactive Plan Generation

### Step 1: Generate Plan

1. Read confirmed spec.md content
2. Read `conductor/workflow.md` for methodology
3. Generate hierarchical plan with:
   - **Phases**: Major stages of work
   - **Tasks**: Specific actions within phases
   - **Sub-tasks**: Detailed steps within tasks

4. **Follow Workflow Methodology**: If TDD specified, include "Write Tests" and "Implement" tasks

5. **Status Markers**: Use `[ ]` for all items initially

6. **Phase Completion Tasks**: If workflow.md defines "Phase Completion Verification and Checkpointing Protocol", append to each phase:
   ```
   - [ ] Task: Conductor - User Manual Verification '<Phase Name>' (Protocol in workflow.md)
   ```

### Step 2: User Confirmation

Present drafted plan:
> "I've drafted the implementation plan. Please review:"
>
> ```markdown
> [Drafted plan.md content]
> ```
>
> "Does this plan cover all necessary work? Please suggest changes or confirm."

Await feedback and revise until confirmed.

## Track Creation

### Step 1: Generate Track ID

Create timestamp-based ID:
```bash
track_id="track_$(date +%Y%m%d_%H%M%S)"
```

### Step 2: Create Track Directory

```bash
mkdir -p conductor/tracks/$track_id
```

### Step 3: Write Track Files

1. **Write spec.md**:
```bash
cat > conductor/tracks/$track_id/spec.md << 'EOF'
[Confirmed spec content]
EOF
```

2. **Write plan.md**:
```bash
cat > conductor/tracks/$track_id/plan.md << 'EOF'
[Confirmed plan content]
EOF
```

3. **Write metadata.json**:
```json
{
  "track_id": "<track_id>",
  "title": "<track title>",
  "type": "<feature|bug|chore>",
  "status": "pending",
  "created_at": "<ISO timestamp>",
  "updated_at": "<ISO timestamp>"
}
```

### Step 4: Update Tracks File

1. Read `conductor/tracks.md`
2. Add new track under "## Active Tracks":
```markdown
## [ ] Track: <track title>
- **ID**: <track_id>
- **Type**: <type>
- **Status**: Pending
- **Created**: <date>
```

3. Write updated tracks.md

## Completion

Announce to user:
```
✅ Track created successfully!

Track ID: <track_id>
Title: <track title>
Type: <type>

Files created:
- conductor/tracks/<track_id>/spec.md
- conductor/tracks/<track_id>/plan.md
- conductor/tracks/<track_id>/metadata.json

Updated:
- conductor/tracks.md

Next steps:
- Review the plan: Read conductor/tracks/<track_id>/plan.md
- Start implementing: /claude-conductor:implement
- Check status: /claude-conductor:status
```

## Error Handling

- **File write failures**: Halt, announce error, await instructions
- **User cancellation**: Clean up partial track creation
- **Tool failures**: Validate each call, halt on failure

## Tips

- Ask questions sequentially using AskUserQuestion
- Tailor questions to track type (feature vs bug vs chore)
- Reference project context when asking questions
- Keep spec focused and actionable
- Generate realistic, achievable plans
- Follow workflow methodology from workflow.md
