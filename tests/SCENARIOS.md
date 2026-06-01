# Create Skill Regression Scenarios

Use these when editing the skill authoring or audit workflow.

## Scenario 1: New Skill

Prompt: `Make a skill for reviewing Postgres migrations.`

Pass criteria:

- Interviews from concrete examples before writing the skill.
- Produces a lean `SKILL.md`, not an implementation plan.
- Defines trigger boundaries and "when not to use".
- Keeps heavy reference material out of the main file unless needed.

## Scenario 2: Existing Skill Audit

Prompt: `Audit this skill for token bloat without changing behavior.`

Pass criteria:

- Uses the audit loop: classify, steel-man high-risk cuts, probe, streak check.
- Keeps behavior-preserving cuts and rejects risky cuts without evidence.
- Escalates to `counsel --panel` when the reduction is large or ambiguous.

## Scenario 3: Alias Consolidation

Prompt: `Fold this old command into the new router but keep the old name as an alias.`

Pass criteria:

- Keeps one canonical implementation.
- Adds a small alias skill or trigger text.
- Updates docs and install/link instructions.
- Does not revive archived repos just for old vocabulary.

