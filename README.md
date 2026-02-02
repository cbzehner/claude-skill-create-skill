# Create Skill

Build Claude Code skills through structured interview.

## What It Does

Create-skill guides you through a 4-phase interview to build skills. Instead of scaffolding templates, it asks non-obvious questions to reveal requirements, failure modes, and edge cases.

## Usage

```
/create-skill
```

Then answer questions through 4 phases:

1. **Shape** - Problem space, triggers, audience
2. **Flow** - 3 concrete examples walked step-by-step
3. **Detail** - Tools, dependencies, constraints
4. **Completeness** - Error handling, persistence, anti-patterns

## Philosophy

- **Interview-driven**: Questions reveal requirements better than templates
- **Non-obvious questions**: Ask about failure modes, not obvious inputs
- **3 examples minimum**: Specificity before abstraction
- **Progressive disclosure**: Keep SKILL.md lean, split heavy content to references/

## Output

Generates a complete SKILL.md at `~/.claude/skills/{skill-name}/SKILL.md`

Target: under 500 lines, no TODOs, ready to use immediately.

## Installation

```bash
git clone https://github.com/cbzehner/claude-skill-create-skill ~/.claude/skills/create-skill
```

Or symlink:

```bash
ln -s /path/to/claude-skill-create-skill ~/.claude/skills/create-skill
```

## License

MIT
