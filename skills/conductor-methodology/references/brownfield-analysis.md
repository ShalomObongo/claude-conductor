# Brownfield Project Analysis

This reference provides detailed patterns for analyzing existing projects during Conductor setup.

## Analysis Strategy

### 1. File Discovery

**Respect Ignore Files:**
```bash
# Check for ignore files
if [ -f .geminiignore ] || [ -f .gitignore ]; then
    # Use git ls-files to respect patterns
    git ls-files --exclude-standard -co
fi
```

**Prioritize Key Files:**
1. README.md - Project overview
2. package.json, pom.xml, requirements.txt, go.mod - Dependencies
3. Configuration files - Tech stack indicators
4. Source directories - Architecture patterns

### 2. Technology Detection

**Language Detection:**
- Check file extensions in src/ directories
- Analyze dependency manifests
- Look for build configuration files

**Framework Detection:**
- package.json: React, Vue, Angular, Express
- requirements.txt: Django, Flask, FastAPI
- go.mod: Gin, Echo, Fiber
- pom.xml: Spring, Quarkus

**Database Detection:**
- Look for database drivers in dependencies
- Check for migration directories
- Analyze connection configuration files

### 3. Architecture Inference

**Monorepo Indicators:**
- Multiple package.json files
- Workspace configuration (lerna.json, pnpm-workspace.yaml)
- packages/ or apps/ directories

**Microservices Indicators:**
- Multiple service directories
- Docker compose files
- API gateway configuration

**MVC Indicators:**
- models/, views/, controllers/ directories
- Separation of concerns in structure

## Pre-population Strategy

Use analysis results to pre-populate context files:

**tech-stack.md:**
- Languages: From file analysis
- Frameworks: From dependency analysis
- Database: From driver detection
- Architecture: From structure inference

**product.md:**
- Project goal: From README.md description
- Features: From README.md or package.json description

**workflow.md:**
- Testing: Check for test directories and scripts
- Linting: Check for linter configuration
- CI/CD: Check for .github/workflows or .gitlab-ci.yml

## Example Analysis Output

```
Detected: Brownfield Project
Language: TypeScript (95%), JavaScript (5%)
Frontend: React 18.2.0
Backend: Express 4.18.0
Database: PostgreSQL (pg driver detected)
Architecture: Monorepo (lerna detected)
Testing: Jest (jest.config.js found)
```

## Best Practices

1. **Read-only Analysis**: Never modify files during analysis
2. **Handle Large Files**: Use head/tail for files >1MB
3. **Respect Privacy**: Skip files with sensitive patterns
4. **Fast Scanning**: Limit depth and file count
5. **Clear Communication**: Show user what was detected
