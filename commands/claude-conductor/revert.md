---
description: "Git-aware revert of Conductor tracks, phases, or tasks"
argument-hint: "[track_id|phase|task]"
allowed-tools: ["Read", "Bash", "Glob", "AskUserQuestion", "Edit"]
---

# Revert Command

Revert logical units of work tracked by Conductor (tracks, phases, tasks) by analyzing Git history and reverting associated commits.

## System Directive

You are executing the Conductor revert command. Your function is to guide the user through reverting work by:
1. Identifying what to revert (interactive or argument-based)
2. Finding all associated Git commits
3. Presenting a clear execution plan
4. Executing the revert with verification

**CRITICAL**: User confirmation is required at multiple checkpoints. If denied, halt immediately.

## Prerequisites Check

Before proceeding:

1. **Verify Tracks File**: Check if `conductor/tracks.md` exists and is not empty
   - If missing or empty, halt and inform:
     > "Conductor is not set up or tracks.md is corrupted. Please run `/claude-conductor:setup` or restore the file."

2. **Verify Git Repository**: Ensure the project is a Git repository
   - Run: `git rev-parse --git-dir`
   - If fails, halt and inform: "This is not a Git repository. Revert requires Git."

## Phase 1: Interactive Target Selection

### Step 1: Determine User Intent

Check if user provided a target as argument (e.g., `{{args}}`):
- **If argument provided**: Proceed to Direct Confirmation Path
- **If no argument**: Proceed to Guided Selection Path

### Direct Confirmation Path

1. Parse the argument to identify track ID, phase, or task
2. Read `conductor/tracks.md` and relevant `plan.md` files to find the target
3. Use AskUserQuestion to confirm:
   - Question: "You asked to revert [Track/Phase/Task]: '[Description]'. Is this correct?"
   - Options:
     - "Yes, revert this item"
     - "No, let me choose a different item"
4. If confirmed, set as `target_intent` and proceed to Phase 2
5. If denied, proceed to Guided Selection Path

### Guided Selection Path

1. **Identify Revert Candidates**:
   - Read `conductor/tracks.md`
   - List all track directories: `ls -1 conductor/tracks/`
   - For each track, read `plan.md`
   - Find items marked as in-progress: `[~]`
   - If no in-progress items, find 5 most recently completed: `[x]`

2. **Present Hierarchical Menu** using AskUserQuestion:
   - Question: "Which item would you like to revert?"
   - Options (grouped by track):
     - "[Track ID] - [Phase Name] (Phase)"
     - "[Track ID] - [Task Name] (Task)"
     - "[Track ID] - Entire Track"
     - "Let me specify a different item"
   - Use multiSelect: false

3. **Process Selection**:
   - If user selects an item, set as `target_intent` and proceed to Phase 2
   - If "specify different", ask clarifying questions to identify target

4. **Halt on Failure**: If no items found, announce and halt

## Phase 2: Git Reconciliation & Verification

### Step 1: Identify Implementation Commits

1. Read the target's `plan.md` file
2. Extract commit SHAs mentioned in completed tasks
3. For each SHA, verify it exists in Git:
   ```bash
   git cat-file -t <sha> 2>/dev/null
   ```
4. **Handle Ghost Commits** (rewritten history):
   - If SHA not found, search for similar commit message:
     ```bash
     git log --all --grep="<message>" --format="%H %s"
     ```
   - Use AskUserQuestion to confirm replacement SHA

### Step 2: Identify Plan-Update Commits

For each implementation commit, find the corresponding plan update:
```bash
git log --all --grep="conductor.*plan" --since="<commit_date>" -- conductor/tracks/*/plan.md
```

### Step 3: Identify Track Creation Commit (Track Revert Only)

If reverting entire track:
```bash
git log --all -- conductor/tracks.md | grep -B5 "Track: <track_title>"
```

### Step 4: Compile Final List

1. Combine all SHAs: implementation + plan updates + track creation (if applicable)
2. Sort in reverse chronological order (most recent first)
3. Check for merge commits and warn user
4. Remove duplicates

## Phase 3: Final Execution Plan Confirmation

### Present Summary

Display to user:
```
I have analyzed your request. Here is the revert plan:

Target: Revert [Track/Phase/Task] '[Description]'
Commits to Revert: [N]
  - <sha1> ('[commit message]')
  - <sha2> ('[commit message]')
  ...

Action: I will run `git revert` on these commits in reverse chronological order.

⚠️  Warnings:
  [Any merge commits or potential conflicts]
```

### Final Confirmation

Use AskUserQuestion:
- Question: "Do you want to proceed with this revert?"
- Options:
  - "Yes, proceed with revert"
  - "No, cancel the revert"
- If yes, proceed to Phase 4
- If no, halt and await instructions

## Phase 4: Execution & Verification

### Step 1: Execute Reverts

For each commit in the final list (reverse chronological order):
```bash
git revert --no-edit <sha>
```

### Step 2: Handle Conflicts

If revert fails due to conflict:
1. Halt execution
2. Inform user:
   ```
   ⚠️  Merge conflict detected while reverting <sha>

   Please resolve the conflict manually:
   1. Run: git status
   2. Edit conflicted files
   3. Run: git add <files>
   4. Run: git revert --continue

   Or abort: git revert --abort
   ```
3. Await user instructions

### Step 3: Verify Plan State

1. Read the relevant `plan.md` file(s)
2. Check if reverted items are correctly marked as pending `[ ]`
3. If not, use Edit tool to fix the status markers
4. Commit the correction:
   ```bash
   git add conductor/tracks/*/plan.md
   git commit -m "conductor(plan): Sync plan state after revert"
   ```

### Step 4: Announce Completion

Inform user:
```
✅ Revert completed successfully

Reverted: [Track/Phase/Task] '[Description]'
Commits reverted: [N]
Plan state: Synchronized

You can now continue working or run `/claude-conductor:status` to see updated progress.
```

## Error Handling

- **Tool call failures**: Halt immediately, announce failure, await instructions
- **Git errors**: Display full error message, provide resolution steps
- **File read errors**: Note the failure, continue with available data if possible
- **User cancellation**: Respect at any checkpoint, halt gracefully

## Tips

- Always work in reverse chronological order when reverting
- Verify each commit exists before adding to revert list
- Handle non-linear Git histories (rebases, squashes)
- Keep user informed at each phase
- Provide clear instructions for manual conflict resolution
