---
name: create-skill
description: Create reusable agent skills through structured interview. Use when
  formalizing a workflow, making a skill, slash command, or automating a process.
argument-hint: "[workflow description]"
allowed-tools: AskUserQuestion, Write, Read, Edit, Bash, Glob, Grep
---

# /create-skill

Build skills through interview, not scaffolding.

## When to Use

- Formalizing a repeatable workflow into a reusable skill
- User says "make a skill", "slash command", "automate this"
- Turning a conversation's workflow into something reproducible
- Building a new capability for Claude Code

## When NOT to Use

- **One-off scripts**: If the user just needs a bash script or utility, write it directly — don't wrap it in a skill
- **Configuration changes**: Use `/update-config` for hooks, permissions, env vars, settings.json changes
- **Editing an existing skill**: Read and edit the skill directly — don't re-run the full interview
- **Documentation**: If the user wants docs, write docs — skills are executable workflows, not reference material

## What to Skip

- **README.md**: SKILL.md is the readme
- **CHANGELOG.md**: Use git history
- **LICENSE**: Inherit from parent
- **Separate config files**: Use YAML frontmatter
- **Heavy frameworks**: Skills are markdown + optional scripts, not applications

## Philosophy

- **Interview-driven**: Questions reveal requirements better than templates
- **Capture, don't invent**: Check if the current conversation already contains a workflow worth capturing — extract steps, tools used, and corrections before asking fresh questions
- **3 examples minimum**: Specificity before abstraction
- **Explain the why**: Instructions that explain reasoning outperform rigid MUSTs. The agent is smart — give it context to make judgment calls, not just rules to follow
- **Progressive disclosure**: Keep SKILL.md lean, split heavy content to reference files
- **Lean over rigid**: Remove instructions that aren't pulling their weight. If test runs show the agent ignoring a section, cut it rather than adding enforcement

## Workflow

Guide the user through 6 steps using AskUserQuestion. Use multiple choice where possible. Ask one question at a time. Go deep.

**Before starting**: Check if the current conversation already contains a workflow the user wants to capture. If so, extract the tools used, the sequence of steps, corrections the user made, and input/output formats observed. Present this as a starting point — the user fills gaps and confirms.

---

### Step 1: Understand with Examples

Gather concrete use cases to clarify what the skill does and when it fires. Use the interview questions from [references/interview-structure.md](references/interview-structure.md) — skill type classification, core questions, and 3 concrete example walkthroughs.

---

### Step 2: Plan Reusable Contents

Identify which bundled resources the skill needs beyond SKILL.md. Use the tool check, planning questions, and effort assessment from [references/interview-structure.md](references/interview-structure.md).

---

### Step 3: Init

Create the initial SKILL.md from interview answers. Use the template, description writing guidelines, and instruction language rules from [references/skill-template.md](references/skill-template.md).

Write the initial SKILL.md to `~/.claude/skills/{skill-name}/SKILL.md`.

---

### Step 4: Edit

Refine the skill with edge cases, failure modes, and hardening. Use the completeness questions, validation questions, and hardening guidance from [references/validation-checklist.md](references/validation-checklist.md).

See [references/techniques.md](references/techniques.md) for the full hardening guide.

Update the SKILL.md with refinements from this step.

---

### Step 5: Package

Validate the skill meets quality standards before declaring it ready. Run all checks from [references/validation-checklist.md](references/validation-checklist.md) and report results to the user using the validation table format.

Fix any failures before proceeding. Warnings are advisory.

---

### Step 6: Iterate

Test and refine based on real usage. Follow the testing protocol in [references/validation-checklist.md](references/validation-checklist.md) — including additional discipline/process skill steps if applicable.

## Output Location

Write to the target skill directory's `SKILL.md` (for example `~/.claude/skills/{skill-name}/SKILL.md`).

Only create reference files if content exceeds 300 lines or has distinct reference material.
