---
description: "Scaffolds project and sets up the Conductor environment"
argument-hint: ""
allowed-tools: ["Read", "Write", "Bash", "Glob", "Grep", "AskUserQuestion", "Edit"]
---

# Setup Command

Initialize the Conductor environment for a project, creating context files and establishing the development workflow.

## System Directive

You are executing the Conductor setup command. Your function is to guide the user through project initialization, creating all necessary context files (product, tech stack, workflow, styleguides) and preparing for track-based development.

**CRITICAL**: Validate success of every tool call. If any fails, halt and await instructions.

## Resume Check

Before starting, check for `conductor/setup_state.json`:
- **If exists**: Read it and resume from `last_successful_step`
  - "product_guide" → Resume at Section 2.2
  - "product_guidelines" → Resume at Section 2.3
  - "tech_stack" → Resume at Section 2.4
  - "code_styleguides" → Resume at Section 2.5
  - "workflow" → Resume at Section 3.0
  - "initial_track_generated" → Announce setup complete, halt
- **If not exists**: This is new setup, proceed to Section 1.0

## 1.0 Pre-Initialization Overview

Present overview to user:
```
Welcome to Conductor. I will guide you through:
1. Project Discovery: Analyze current directory (new or existing project)
2. Product Definition: Define product vision, guidelines, and tech stack
3. Configuration: Select code styleguides and customize workflow
4. Track Generation: Define initial track and generate plan

Let's get started!
```

## 1.1 Project Inception

### Detect Project Maturity

Classify as **Brownfield** (existing) or **Greenfield** (new):

**Brownfield Indicators** (if ANY exist, classify as Brownfield):
- Version control: `.git`, `.svn`, `.hg` directories exist
- Dirty repository: `git status --porcelain` returns output
- Dependency manifests: `package.json`, `pom.xml`, `requirements.txt`, `go.mod` exist
- Source directories: `src/`, `app/`, `lib/` with code files exist

**Greenfield**: ONLY if NONE of above exist AND directory is empty or has only README.md

### Execute Workflow Based on Maturity

**If Brownfield**:
1. Announce existing project detected
2. If uncommitted changes exist, warn user to commit/stash first
3. **Brownfield Analysis Protocol**:
   - Check for `.gitignore` and `.geminiignore`, respect ignore patterns
   - List relevant files: `git ls-files --exclude-standard -co`
   - Prioritize: README.md, package.json, pom.xml, requirements.txt, go.mod
   - For files >1MB, read only first/last 20 lines
   - Extract: programming language, frameworks, database drivers
   - Infer: architecture type (monorepo, microservices, MVC)
   - Infer: project goal from README or manifest description
4. Proceed to Section 2.1

**If Greenfield**:
1. Announce new project detected
2. Create basic directory structure if needed
3. Proceed to Section 2.1

### Save State
```bash
mkdir -p conductor
echo '{"last_successful_step": "project_inception"}' > conductor/setup_state.json
```

## 2.0 Phase 1: Streamlined Project Setup

### 2.1 Generate Product Guide

1. **For Brownfield**: Use analysis to pre-populate questions
2. **For Greenfield**: Ask from scratch

Use AskUserQuestion to gather:
- **Product Vision**: What problem does this solve? Who are the users?
- **Core Features**: What are the main capabilities?
- **Success Metrics**: How do you measure success?

Present 2-3 options per question, include "Type your own answer"

3. **Draft product.md** with sections:
   - Overview
   - Target Users
   - Core Features
   - Product Goals
   - Success Metrics

4. **User Confirmation**: Show draft, get approval or revisions

5. **Write File**: `conductor/product.md`

6. **Save State**:
```bash
echo '{"last_successful_step": "product_guide"}' > conductor/setup_state.json
```

### 2.2 Generate Product Guidelines

Use AskUserQuestion to gather:
- **Brand Voice**: Professional, casual, technical?
- **Design Principles**: Minimalist, feature-rich, accessible?
- **User Experience**: Priorities and constraints

1. **Draft product-guidelines.md** with sections:
   - Brand Voice
   - Design Principles
   - UX Guidelines
   - Content Guidelines

2. **User Confirmation**: Show draft, get approval

3. **Write File**: `conductor/product-guidelines.md`

4. **Save State**:
```bash
echo '{"last_successful_step": "product_guidelines"}' > conductor/setup_state.json
```

### 2.3 Define Technology Stack

1. **For Brownfield**: Pre-populate from analysis
2. **For Greenfield**: Ask user

Use AskUserQuestion to gather:
- **Primary Language**: JavaScript, Python, Go, Java, etc.
- **Frontend Framework**: React, Vue, Angular, none
- **Backend Framework**: Express, Django, Spring, etc.
- **Database**: PostgreSQL, MySQL, MongoDB, etc.
- **Architecture**: Monolith, microservices, serverless

1. **Draft tech-stack.md** with sections:
   - Programming Languages
   - Frontend Stack
   - Backend Stack
   - Database & Storage
   - Architecture
   - Development Tools

2. **User Confirmation**: Show draft, get approval

3. **Write File**: `conductor/tech-stack.md`

4. **Save State**:
```bash
echo '{"last_successful_step": "tech_stack"}' > conductor/setup_state.json
```

### 2.4 Select Code Styleguides

1. Based on tech stack, identify relevant languages
2. Copy appropriate styleguides from plugin templates:
```bash
mkdir -p conductor/code_styleguides
cp templates/code_styleguides/general.md conductor/code_styleguides/
cp templates/code_styleguides/<language>.md conductor/code_styleguides/
```

3. Inform user which styleguides were added

4. **Save State**:
```bash
echo '{"last_successful_step": "code_styleguides"}' > conductor/setup_state.json
```

### 2.5 Define Project Workflow

1. Copy workflow template:
```bash
cp templates/workflow.md conductor/workflow.md
```

2. Use AskUserQuestion to customize:
   - **Development Methodology**: TDD, BDD, standard
   - **Commit Strategy**: Conventional commits, descriptive, etc.
   - **Testing Requirements**: Unit, integration, E2E
   - **Code Review**: Required, optional, pair programming

3. **Edit workflow.md** based on responses

4. **User Confirmation**: Show customized workflow, get approval

5. **Save State**:
```bash
echo '{"last_successful_step": "workflow"}' > conductor/setup_state.json
```

## 3.0 Phase 2: Initial Track Generation

### 3.1 Create Tracks File

1. **Write File**: `conductor/tracks.md`
```markdown
# Conductor Tracks

This file tracks all features, bugs, and chores for the project.

## Active Tracks

## Completed Tracks

## Archived Tracks
```

### 3.2 Prompt for Initial Track

Use AskUserQuestion:
- Question: "Would you like to create your first track now?"
- Options:
  - "Yes, create a track now"
  - "No, I'll create tracks later with /claude-conductor:newTrack"

If yes, proceed to Section 3.3
If no, proceed to Section 3.4

### 3.3 Generate Initial Track

1. Ask user: "What is your first feature or task?"
2. Capture description
3. Run the newTrack workflow (simplified inline version):
   - Create track directory with timestamp ID
   - Generate basic spec.md
   - Generate basic plan.md
   - Update tracks.md

4. **Save State**:
```bash
echo '{"last_successful_step": "initial_track_generated"}' > conductor/setup_state.json
```

### 3.4 Complete Setup

1. Remove state file:
```bash
rm conductor/setup_state.json
```

2. Announce completion:
```
✅ Conductor setup complete!

Created files:
- conductor/product.md
- conductor/product-guidelines.md
- conductor/tech-stack.md
- conductor/workflow.md
- conductor/code_styleguides/
- conductor/tracks.md

Next steps:
- Create a track: /claude-conductor:newTrack
- View status: /claude-conductor:status
- Start implementing: /claude-conductor:implement
```

## Error Handling

- **File write failures**: Halt, announce error, await instructions
- **User cancellation**: Save state at last successful step
- **Tool failures**: Validate each call, halt on failure

## Tips

- Use AskUserQuestion for all interactive choices
- Present 2-3 options plus "Type your own answer"
- Save state after each major section
- For brownfield projects, pre-populate based on analysis
- Keep user informed of progress throughout
