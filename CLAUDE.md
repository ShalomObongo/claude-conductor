# Claude Conductor Context

This file provides Claude-specific context for the Conductor plugin.

## What is Conductor?

If a user mentions a "plan" or asks about the plan, and they have used the claude-conductor plugin in the current session, they are likely referring to one of these files:

- `conductor/tracks.md` - The master tracks file listing all features/bugs
- `conductor/tracks/<track_id>/plan.md` - A specific track's implementation plan
- `conductor/tracks/<track_id>/spec.md` - A specific track's specification

## Directory Structure

When Conductor is active in a project, it creates and manages this structure:

```
conductor/
├── product.md              # Product vision and goals
├── product-guidelines.md   # Brand and design guidelines
├── tech-stack.md          # Technology choices and architecture
├── workflow.md            # Development workflow methodology
├── code_styleguides/      # Language-specific style guides
├── tracks.md              # Master list of all tracks
└── tracks/
    └── <track_id>/
        ├── metadata.json  # Track metadata
        ├── spec.md        # Detailed requirements
        └── plan.md        # Implementation plan
```

## Context-Driven Development

Conductor implements a strict workflow: **Context → Spec & Plan → Implement**

1. **Context**: Project-level context (product, tech stack, workflow) is established once
2. **Spec & Plan**: Each track (feature/bug) gets a detailed spec and hierarchical plan
3. **Implement**: Follow the plan, update status, verify at phase boundaries

## When to Load Conductor Context

Before working on implementation tasks, always check if conductor context exists and load relevant files to understand:
- Project goals and constraints (product.md, tech-stack.md)
- Development workflow (workflow.md)
- Current track specifications and plans
