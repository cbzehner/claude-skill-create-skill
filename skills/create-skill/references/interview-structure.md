# Interview Structure

## Step 1: Understand with Examples

### Skill Type Classification

Determines hardening approach later (see [techniques.md](techniques.md)):

```
Q: What type of skill is this?
  1. Discipline (enforces a practice — TDD, review, verification)
  2. Process (guides multi-step workflows — brainstorming, planning, deployment)
  3. Technique (teaches patterns/recipes — code generation, analysis)
  4. Reference (provides information — API docs, templates, specs)
  5. Always-on (runs every session — runbooks, session state)
```

### Core Questions

- What does this skill do? (1 sentence)
- When should it trigger? (specific scenarios, natural phrasings a user would say)
- When should it NOT trigger? (near-misses — adjacent tasks that seem similar but aren't)
- Who uses it? (personal, team, public)

### Walk Through 3 Concrete Examples

```
Q: In example 1, what's the first thing you do?
  1. Read a file
  2. Run a command
  3. Ask the user something
  4. Search the codebase
```

- "Describe example 1 step by step"
- "Now a different scenario (example 2)"
- "What's an edge case? (example 3)"

Extract common patterns and variations. Look for repeated work across examples — if all three involve the same helper logic, that's a signal to bundle a script.

## Step 2: Plan Reusable Contents

### External Tool Check

```
Q: Does this skill need external tools?
  1. No, just built-in tools
  2. Yes, CLI tools (specify which)
  3. Yes, APIs (specify which)
  4. Not sure yet
```

### Questions

- What tools does it need? (Read, Write, Bash, Task, etc.)
- External dependencies? (CLIs, APIs)
- What's deterministic vs needs LLM judgment? (deterministic operations -> bundle as scripts in `scripts/`)
- What must it NEVER do? (hard constraints — but explain why, not just the rule)
- Does it need dynamic context at invocation time? (current branch, project state, etc.)
- Does it bundle supporting files? (scripts -> `scripts/`, reference docs -> `references/`, templates -> `assets/`)

### Effort Assessment

```
Q: How much reasoning effort does this skill need?
  1. Low — simple, procedural steps
  2. High — complex orchestration, judgment calls
  3. Max — deep analysis, architecture decisions
```

### Resource Guidelines

- `scripts/` — deterministic, reusable code the agent executes (saves tokens vs regenerating)
- `references/` — documentation the agent reads while working (inner prompts, specs, examples)
- `assets/` — templates and files used in outputs (not loaded into context automatically)
