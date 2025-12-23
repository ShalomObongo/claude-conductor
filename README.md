# Claude Conductor

**Measure twice, code once.**

Claude Conductor is a Claude Code plugin that enables **Context-Driven Development** - a methodology that ensures AI follows a strict protocol: Context → Spec & Plan → Implement.

## Overview

Conductor transforms Claude Code into a proactive project manager that maintains persistent project context and follows structured workflows for every feature and bug fix. Instead of just writing code, Conductor ensures a consistent, high-quality lifecycle for every task.

### Philosophy

By treating context as a managed artifact alongside your code, you transform your repository into a single source of truth that drives every AI interaction with deep, persistent project awareness.

## Features

- **Plan before you build**: Create specs and plans that guide implementation
- **Maintain context**: Ensure AI follows style guides, tech stack choices, and product goals
- **Iterate safely**: Review plans before code is written
- **Work as a team**: Set project-level context shared across your team
- **Build on existing projects**: Intelligent initialization for both new and existing codebases
- **Smart revert**: Git-aware revert that understands logical units of work (tracks, phases, tasks)

## Installation

Install the Claude Conductor plugin:

```bash
# Clone the repository
git clone https://github.com/ShalomObongo/claude-conductor.git
cd claude-conductor

# Link to Claude Code plugins directory
mkdir -p ~/.claude/plugins
ln -s "$(pwd)" ~/.claude/plugins/claude-conductor

# Or for project-specific installation
mkdir -p .claude-plugins
ln -s "$(pwd)" .claude-plugins/claude-conductor
```

## Quick Start

### 1. Set Up Your Project (Run Once)

Initialize Conductor in your project:

```bash
/claude-conductor:setup
```

This creates:
- `conductor/product.md` - Product vision and goals
- `conductor/product-guidelines.md` - Brand and design standards
- `conductor/tech-stack.md` - Technology choices
- `conductor/workflow.md` - Development methodology
- `conductor/code_styleguides/` - Language-specific style guides
- `conductor/tracks.md` - Master track list

### 2. Start a New Track

Create a feature or bug fix:

```bash
/claude-conductor:newTrack "Add user authentication"
```

Conductor will:
1. Ask clarifying questions about requirements
2. Generate a detailed specification (`spec.md`)
3. Create a hierarchical implementation plan (`plan.md`)
4. Update the tracks file

### 3. Implement the Track

Execute the plan:

```bash
/claude-conductor:implement
```

Conductor will:
1. Work through tasks phase by phase
2. Follow your defined workflow (e.g., TDD)
3. Update status in real-time
4. Verify completion at phase boundaries
5. Commit changes with proper messages

### 4. Check Progress

View project status:

```bash
/claude-conductor:status
```

Displays:
- Overall progress with visual indicators
- Active tracks and current tasks
- Completion percentages
- Next actions needed

### 5. Revert Work (If Needed)

Undo a feature or task:

```bash
/claude-conductor:revert
```

Intelligently reverts Git commits associated with tracks, phases, or tasks.

## Commands Reference

| Command | Description | Usage |
|---------|-------------|-------|
| `/claude-conductor:setup` | Initialize Conductor environment | Run once per project |
| `/claude-conductor:newTrack` | Create new track with spec and plan | `[description]` optional |
| `/claude-conductor:implement` | Execute tasks from plan | `[track_id]` optional |
| `/claude-conductor:status` | Display progress overview | No arguments |
| `/claude-conductor:revert` | Git-aware revert of work | Interactive selection |

## Directory Structure

Conductor creates and manages this structure:

```
conductor/
├── product.md              # Product vision, users, goals
├── product-guidelines.md   # Brand voice, design principles
├── tech-stack.md          # Languages, frameworks, architecture
├── workflow.md            # Development methodology (TDD, commits, testing)
├── code_styleguides/      # Language-specific style guides
├── tracks.md              # Master list of all tracks
└── tracks/
    └── track_YYYYMMDD_HHMMSS/
        ├── metadata.json  # Track metadata
        ├── spec.md        # Detailed requirements
        └── plan.md        # Implementation plan
```

## How It Works

### Context-Driven Development Workflow

**1. Context (One-Time Setup)**
- Define product vision and goals
- Specify tech stack and architecture
- Establish development workflow
- Select code style guides

**2. Spec & Plan (Per Track)**
- Interactive questioning to gather requirements
- Generate detailed specification
- Create hierarchical implementation plan
- Review and approve before coding

**3. Implement (Execution)**
- Follow the plan phase by phase
- Update status markers in real-time
- Run automated checks at phase boundaries
- Commit with conventional commit messages
- Verify completion before proceeding

### Track Lifecycle

```
Create Track → Generate Spec → Generate Plan → Implement → Verify → Complete
     ↓              ↓              ↓              ↓          ↓         ↓
  newTrack    Interactive    Hierarchical   implement   Automated   Update
              Questions      Phases/Tasks               + Manual    tracks.md
```

## Skills

Conductor includes three comprehensive skills that provide domain knowledge:

1. **conductor-methodology** - Core concepts, directory structure, file formats
2. **spec-and-plan-generation** - Interactive questioning patterns, spec/plan structure
3. **workflow-execution** - TDD/BDD workflows, status management, commit strategies

Skills are automatically loaded by commands when needed.

## Examples

### Creating a Feature

```bash
# Start a new feature
/claude-conductor:newTrack "Add dark mode toggle"

# Conductor asks questions:
# - What specific functionality should this provide?
# - Who will use this feature?
# - How should it integrate with existing features?
# - What are the acceptance criteria?

# Review generated spec and plan
# Approve and proceed

# Implement the feature
/claude-conductor:implement

# Conductor works through the plan:
# Phase 1: Backend API
#   ✓ Task: Add theme preference to user model
#   ✓ Task: Create theme toggle endpoint
#   ~ Task: Update user settings API
#
# Phase completion verification...
```

### Checking Status

```bash
/claude-conductor:status

# Output:
# ╔══════════════════════════════════════════════════════════════╗
# ║              CONDUCTOR PROJECT STATUS                        ║
# ╚══════════════════════════════════════════════════════════════╝
#
# 📅 Report Generated: 2024-12-23 14:30:00
# 🎯 Project Status: On Track
#
# 📊 OVERALL PROGRESS
# Total Tracks: 3
# ├─ ✅ Completed: 1
# ├─ 🔄 In Progress: 1
# └─ ⏸️  Pending: 1
#
# Overall Completion: 45% [█████████░░░░░░░░░░░] 15/33 tasks
```

## Workflow Methodologies

Conductor supports multiple development methodologies:

### Test-Driven Development (TDD)

Plans include test-first tasks:
```markdown
### [ ] Task: Add user validation
- [ ] Sub-task: Write validation tests
- [ ] Sub-task: Run tests (expect failure)
- [ ] Sub-task: Implement validation logic
- [ ] Sub-task: Run tests (expect pass)
- [ ] Sub-task: Refactor for clarity
```

### Standard Workflow

Plans follow implement-test-review:
```markdown
### [ ] Task: Add user validation
- [ ] Sub-task: Implement validation logic
- [ ] Sub-task: Test validation manually
- [ ] Sub-task: Review code quality
```

Workflow is defined in `conductor/workflow.md` and followed during implementation.

## Brownfield vs Greenfield

### Brownfield (Existing Projects)

Conductor analyzes your existing codebase:
- Detects languages and frameworks
- Infers architecture patterns
- Extracts project goals from README
- Pre-populates context files

### Greenfield (New Projects)

Conductor guides you through:
- Defining product vision
- Selecting tech stack
- Establishing workflow
- Creating initial structure

## Git Integration

Conductor is Git-aware:
- Tracks commit SHAs in plan.md
- Enables intelligent revert of logical units
- Handles non-linear history (rebases, squashes)
- Follows conventional commit format
- Commits plan updates separately

## Best Practices

1. **Run setup once** - Initialize Conductor at project start
2. **One track per feature/bug** - Keep tracks focused and atomic
3. **Review before implementing** - Approve specs and plans before coding
4. **Follow the plan** - Don't deviate without updating plan first
5. **Verify at phase boundaries** - Run tests and checks between phases
6. **Commit frequently** - Per task or phase, not at the end
7. **Update context** - Keep context files synchronized with reality

## Troubleshooting

**"Conductor is not set up"**
- Run `/claude-conductor:setup` to initialize

**"No tracks found"**
- Create a track with `/claude-conductor:newTrack`

**"Plan file not found"**
- Ensure track was created successfully
- Check `conductor/tracks/<track_id>/plan.md` exists

**Tests failing during phase verification**
- Fix issues before proceeding
- Conductor will halt until tests pass

## Contributing

Contributions welcome! This plugin is part of the Conductor project:
- GitHub: https://github.com/ShalomObongo/claude-conductor
- Issues: https://github.com/ShalomObongo/claude-conductor/issues

## License

Apache License 2.0 - see [LICENSE](LICENSE) file for details.

## Acknowledgments

Originally created as a Gemini CLI extension, now available for Claude Code. Special thanks to the community for feedback and contributions.

---

**Ready to start?** Run `/claude-conductor:setup` in your project!
