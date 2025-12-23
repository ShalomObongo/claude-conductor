---
description: "Executes tasks from the current track's implementation plan"
argument-hint: "[track_id]"
allowed-tools: ["Read", "Write", "Bash", "Glob", "Grep", "Edit", "AskUserQuestion", "TodoWrite", "Task", "LSP"]
---

# Implement Command

Execute tasks from a Conductor track's implementation plan, following the defined workflow methodology and updating progress.

## System Directive

You are executing the Conductor implement command. Your function is to:
1. Load track context (spec, plan, workflow)
2. Work through tasks phase by phase
3. Follow workflow methodology (e.g., TDD)
4. Update plan.md with progress
5. Verify completion at phase boundaries

**CRITICAL**: Validate success of every tool call. If any fails, halt and await instructions.

## Setup Check

Verify Conductor environment:

1. **Check Required Files**:
   - `conductor/tracks.md`
   - `conductor/workflow.md`
   - `conductor/tech-stack.md`

2. **Handle Missing Files**: If ANY missing, halt and inform:
   > "Conductor is not set up. Please run `/claude-conductor:setup`."

## Track Selection

### If Track ID Provided

1. Parse `{{args}}` for track ID
2. Verify track exists: `conductor/tracks/<track_id>/`
3. If not found, halt and inform user

### If No Track ID

1. Read `conductor/tracks.md`
2. Find tracks with status "in-progress" or "pending"
3. Use AskUserQuestion to let user select:
   - Question: "Which track would you like to implement?"
   - Options: List of available tracks
   - Include: "Cancel"

## Load Track Context

Read and understand:
1. `conductor/tracks/<track_id>/spec.md` - Requirements
2. `conductor/tracks/<track_id>/plan.md` - Implementation plan
3. `conductor/workflow.md` - Development methodology
4. `conductor/tech-stack.md` - Technical constraints
5. `conductor/product.md` - Product context

## Initialize Progress Tracking

Use TodoWrite to mirror plan.md structure:
1. Parse plan.md for phases, tasks, sub-tasks
2. Create todos matching the hierarchy
3. Set status based on plan markers:
   - `[ ]` → pending
   - `[~]` → in_progress
   - `[x]` → completed

## Implementation Loop

### Phase-Level Execution

For each phase in the plan:

1. **Announce Phase Start**:
   ```
   🚀 Starting Phase: <Phase Name>
   Tasks in this phase: <N>
   ```

2. **Execute Phase Tasks**: For each task in the phase:
   - Mark task as in_progress in TodoWrite
   - Follow workflow methodology (see Workflow Execution section)
   - Update plan.md: Change `[ ]` to `[~]` when starting
   - Implement the task
   - Update plan.md: Change `[~]` to `[x]` when complete
   - Mark task as completed in TodoWrite

3. **Phase Completion Verification**:
   - Run automated checks (tests, build, lint)
   - Present results to user
   - Use AskUserQuestion:
     - Question: "Phase '<Phase Name>' is complete. Verification results: [summary]. Ready to proceed?"
     - Options:
       - "Yes, proceed to next phase"
       - "No, let me review/fix issues"
   - If "No", halt and await instructions
   - If "Yes", continue to next phase

4. **Update Phase Status**: Mark phase as complete in plan.md

## Workflow Execution

Follow methodology from workflow.md. Common patterns:

### TDD Workflow

For each task requiring code:
1. **Write Test**: Create failing test
2. **Run Test**: Verify it fails
3. **Implement**: Write minimal code to pass
4. **Run Test**: Verify it passes
5. **Refactor**: Improve code quality
6. **Run Test**: Verify still passes

### Standard Workflow

For each task:
1. **Implement**: Write the code/make the change
2. **Test**: Verify it works
3. **Review**: Check code quality

### Commit Strategy

Follow commit strategy from workflow.md:
- **Conventional Commits**: Use format: `type(scope): description`
- **Per Task**: Commit after each task completion
- **Per Phase**: Commit after each phase completion

## Plan Updates

### Update plan.md

After each task/phase completion:
1. Read current plan.md
2. Update status markers:
   - `[ ]` → `[~]` (when starting)
   - `[~]` → `[x]` (when complete)
3. Write updated plan.md
4. Commit changes:
   ```bash
   git add conductor/tracks/<track_id>/plan.md
   git commit -m "conductor(plan): Update <task/phase> status"
   ```

### Update tracks.md

After phase completion:
1. Read conductor/tracks.md
2. Update track status if needed
3. Write updated tracks.md

## Automated Verification

Run checks based on workflow.md:

### Test Execution
```bash
npm test  # or pytest, go test, etc.
```

### Build Verification
```bash
npm run build  # or equivalent
```

### Linting
```bash
npm run lint  # or equivalent
```

### Type Checking
```bash
npx tsc --noEmit  # or equivalent
```

Present results to user with pass/fail status.

## Track Completion

When all phases complete:

1. **Update Track Status**:
   - Update metadata.json: `"status": "completed"`
   - Update tracks.md: Move track to "## Completed Tracks"

2. **Sync Context Files**: If track introduced new patterns or conventions, ask user:
   - "Should I update product.md, tech-stack.md, or workflow.md based on this work?"
   - If yes, guide user through updates

3. **Announce Completion**:
   ```
   ✅ Track Implementation Complete!

   Track: <track_id> - <title>
   Phases completed: <N>
   Tasks completed: <N>
   Commits created: <N>

   Next steps:
   - Review changes: git log
   - Create PR: gh pr create
   - Start new track: /claude-conductor:newTrack
   - Check status: /claude-conductor:status
   ```

## Error Handling

### Task Failures

If task implementation fails:
1. Mark task as blocked in plan.md: `[!]`
2. Update TodoWrite status
3. Inform user with error details
4. Ask: "How would you like to proceed?"
   - "Retry this task"
   - "Skip and continue"
   - "Halt implementation"

### Test Failures

If tests fail during verification:
1. Present test output
2. Ask user: "Tests failed. How to proceed?"
   - "Fix issues now"
   - "Mark phase as needs-review"
   - "Continue anyway (not recommended)"

### Build Failures

If build fails:
1. Present build output
2. Halt implementation
3. Inform: "Build failed. Please fix issues before continuing."

## Tips

- Use TodoWrite to track progress throughout
- Follow workflow methodology strictly
- Commit frequently (per task or phase)
- Run automated checks at phase boundaries
- Keep user informed of progress
- Handle errors gracefully
- Update plan.md in real-time
- Reference spec.md for requirements
- Reference tech-stack.md for technical decisions
