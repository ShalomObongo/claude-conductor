---
description: "Displays current progress of Conductor tracks with rich formatted output"
argument-hint: ""
allowed-tools: ["Read", "Bash", "Glob"]
---

# Status Command

Display a comprehensive status overview of the Conductor project, including all tracks, phases, tasks, and progress metrics.

## System Directive

You are executing the Conductor status command. Your function is to read the conductor directory structure, parse track and plan files, and present a rich formatted status overview with progress indicators.

## Prerequisites Check

Before proceeding, verify the Conductor environment is set up:

1. **Check Required Files**: Verify these files exist:
   - `conductor/tracks.md`
   - `conductor/tech-stack.md`
   - `conductor/workflow.md`
   - `conductor/product.md`

2. **Handle Missing Files**:
   - If ANY required files are missing, halt and inform the user:
     > "Conductor is not set up. Please run `/claude-conductor:setup` to initialize the environment."
   - Do NOT proceed to status overview.

3. **Verify Tracks File**:
   - If `conductor/tracks.md` exists but is empty, halt and inform:
     > "The tracks file is empty or corrupted. Please run `/claude-conductor:setup` or restore conductor/tracks.md."

## Status Overview Protocol

### Step 1: Read Project Data

1. Read `conductor/tracks.md` to get the master track list
2. List all track directories: `ls -1 conductor/tracks/`
3. For each track directory, read:
   - `conductor/tracks/<track_id>/metadata.json`
   - `conductor/tracks/<track_id>/plan.md`

### Step 2: Parse and Analyze

Parse the content to extract:

1. **Track Information**:
   - Track ID, title, type (feature/bug/chore)
   - Track status (pending/in-progress/completed/blocked)

2. **Phase and Task Breakdown**:
   - Total phases per track
   - Tasks per phase with status markers: `[ ]` (pending), `[x]` (completed), `[~]` (in-progress)
   - Calculate completion percentages

3. **Current Work**:
   - Identify current in-progress phase and task
   - Identify next pending task
   - Identify any blockers

### Step 3: Present Rich Formatted Output

Generate a status report with this structure:

```
╔══════════════════════════════════════════════════════════════╗
║              CONDUCTOR PROJECT STATUS                        ║
╚══════════════════════════════════════════════════════════════╝

📅 Report Generated: [Current timestamp]
🎯 Project Status: [On Track / Behind Schedule / Blocked]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 OVERALL PROGRESS

Total Tracks: [N]
├─ ✅ Completed: [N]
├─ 🔄 In Progress: [N]
├─ ⏸️  Pending: [N]
└─ 🚫 Blocked: [N]

Overall Completion: [XX%] [████████░░░░░░░░░░░░] [completed/total tasks]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 ACTIVE TRACKS

[For each in-progress track:]

Track: [track_id] - [Track Title]
Type: [Feature/Bug/Chore]
Progress: [XX%] [████████░░░░░░░░░░░░] [completed/total tasks]

Current Phase: [Phase Name]
├─ Current Task: [Task description]
└─ Next Task: [Next pending task]

[If blockers exist:]
⚠️  Blockers:
   • [Blocker description]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 ALL TRACKS SUMMARY

[Table format:]
| ID | Title | Type | Status | Progress |
|----|-------|------|--------|----------|
| [id] | [title] | [type] | [status] | [XX%] |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 NEXT ACTIONS

[List next 3-5 pending tasks across all tracks]
1. [Track ID] - [Task description]
2. [Track ID] - [Task description]
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Progress Bar Generation

Use this formula for progress bars (20 characters wide):
- Calculate: `filled = floor((completed / total) * 20)`
- Generate: `"█" * filled + "░" * (20 - filled)`

## Status Classification

Determine project status based on:
- **On Track**: Active progress, no blockers, tasks being completed
- **Behind Schedule**: Many pending tasks, little recent progress
- **Blocked**: One or more tracks have explicit blockers

## Error Handling

If any file read fails:
1. Note the failure in the output
2. Continue with available data
3. Mark affected tracks as "Unknown Status"

## Tips

- Use emoji indicators for visual clarity
- Keep the output concise but informative
- Highlight blockers prominently
- Show the most relevant information first (active work)
- Include timestamp for tracking progress over time
