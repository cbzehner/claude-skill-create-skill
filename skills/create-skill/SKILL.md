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

Gather concrete use cases to clarify what the skill does and when it fires.

**Skill type** (determines hardening later — see [references/techniques.md](references/techniques.md)):

```
Q: What type of skill is this?
  1. Discipline (enforces a practice — TDD, review, verification)
  2. Process (guides multi-step workflows — brainstorming, planning, deployment)
  3. Technique (teaches patterns/recipes — code generation, analysis)
  4. Reference (provides information — API docs, templates, specs)
  5. Always-on (runs every session — runbooks, session state)
```

**Core questions:**
- What does this skill do? (1 sentence)
- When should it trigger? (specific scenarios, natural phrasings a user would say)
- When should it NOT trigger? (near-misses — adjacent tasks that seem similar but aren't)
- Who uses it? (personal, team, public)

**Walk through 3 concrete examples:**

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

---

### Step 2: Plan Reusable Contents

Identify which bundled resources the skill needs beyond SKILL.md.

```
Q: Does this skill need external tools?
  1. No, just built-in tools
  2. Yes, CLI tools (specify which)
  3. Yes, APIs (specify which)
  4. Not sure yet
```

**Ask:**
- What tools does it need? (Read, Write, Bash, Task, etc.)
- External dependencies? (CLIs, APIs)
- What's deterministic vs needs LLM judgment? (deterministic operations → bundle as scripts in `scripts/`)
- What must it NEVER do? (hard constraints — but explain why, not just the rule)
- Does it need dynamic context at invocation time? (current branch, project state, etc.)
- Does it bundle supporting files? (scripts → `scripts/`, reference docs → `references/`, templates → `assets/`)

```
Q: How much reasoning effort does this skill need?
  1. Low — simple, procedural steps
  2. High — complex orchestration, judgment calls
  3. Max — deep analysis, architecture decisions
```

**Resource guidelines:**
- `scripts/` — deterministic, reusable code the agent executes (saves tokens vs regenerating)
- `references/` — documentation the agent reads while working (inner prompts, specs, examples)
- `assets/` — templates and files used in outputs (not loaded into context automatically)

---

### Step 3: Init

Create the initial SKILL.md from interview answers.

**Description writing** (most important field — the host agent uses it alone to decide whether to load):
- Write in third person ("Processes files..." not "I can help...")
- Include trigger words matching how users naturally phrase requests
- State WHAT it does AND WHEN to use it
- Be deliberately "pushy" — agents tend to under-trigger. Add phrases like "Use this whenever the user mentions X, even if they don't explicitly ask for it"
- Under 200 characters, but prioritize trigger coverage over brevity

**Instruction language:**
- Use imperative commands, not questions ("Extract the data" not "Can you extract?")
- Explain the why behind instructions rather than piling on rigid MUSTs
- Be concrete ("Use UTF-8 encoding") not abstract ("Use appropriate encoding")
- Number workflow steps explicitly
- Include 3-5 input/output examples for non-obvious behavior

**Template:**

```yaml
---
name: skill-name
description: [third-person, trigger-word-rich, WHAT + WHEN, deliberately pushy, under 200 chars]
argument-hint: "[expected arguments]"
allowed-tools: [tools identified in Step 2]
# effort: high          # uncomment for complex orchestration/reasoning tasks
# disable-model-invocation: true  # uncomment for skills with side effects
---

# /skill-name

[One sentence: what this skill does]

## When to Use

- [Trigger condition 1 from Step 1]
- [Trigger condition 2]

## When NOT to Use

- [Near-miss anti-pattern 1 from Step 1 — explain WHY it's a near-miss]
- [Near-miss anti-pattern 2]

## What to Skip

- [Thing this skill should NOT include or do — with reason]
- [Common over-engineering temptation to avoid]

## Workflow

### Step 1: [From Step 1 examples]
[Imperative instructions with reasoning — explain WHY, not just WHAT]

### Step 2: [...]
[...]

## Examples

[3-5 concrete input/output pairs from Step 1]

## Error Handling

[From Step 2 completeness questions — what to do when things fail]
```

**Dynamic context** — if Step 2 identified runtime state needs, use shell injection:

```markdown
Current branch: !`git branch --show-current`
Changed files: !`git diff --name-only`
```

**Bundled files** — if Step 2 identified supporting files:

```markdown
See [reference.md](references/reference.md) for details.
Run: ./scripts/validate.sh
```

Bundle scripts when the agent would otherwise regenerate the same helper every invocation. Scripts execute without loading code into context — big token savings.

Target: under 5000 words in SKILL.md. Under 300 lines is ideal. Split to reference files early.

Write the initial SKILL.md to `~/.claude/skills/{skill-name}/SKILL.md`.

---

### Step 4: Edit

Refine the skill with edge cases, failure modes, and hardening.

**Completeness questions:**

```
Q: If the skill fails, what should happen?
  1. Stop and show error
  2. Ask user how to proceed
  3. Try alternative approach
  4. Fail silently (non-critical)
```

- What if [likely failure] happens?
- Should this persist state or be ephemeral?
- Should the host agent auto-invoke this, or manual-only? (side effects = manual-only)

**Validation questions (define success before testing):**
- "Give me 3 test prompts that SHOULD trigger this skill"
- "Give me 2 prompts that should NOT trigger it"
- "For the first test prompt, what does good output look like?"

Guide the user toward **realistic** test prompts — concrete, with file paths, personal context, casual phrasing, maybe typos. Not abstract ("format this data") but specific ("ok so I have this CSV in ~/Downloads called q4-sales.xlsx and I need to...").

Anti-trigger prompts should be **near-misses**: queries that share keywords with the skill but actually need something different.

**Hardening (based on skill type from Step 1):**

For discipline and process skills, also ask:
- "What corners would an agent cut if it were in a rush?" → seeds the anti-rationalization table
- "What does failure look like if the skill is ignored?" → defines what baseline testing should catch

See [references/techniques.md](references/techniques.md) for the full hardening guide. Apply techniques matched to the skill type:
- Discipline skills: full stack (anti-rationalization, pressure testing, persuasion, hard gates)
- Process skills: recommended (anti-rationalization, pressure testing, sequential gates)
- Technique/Reference/Always-on: light validation only

Update the SKILL.md with refinements from this step.

---

### Step 5: Package

Validate the skill meets quality standards before declaring it ready.

**Run these checks (report results to user):**

1. **Frontmatter completeness** — verify all required fields present:
   - `name` (required, must match directory name)
   - `description` (required, under 200 chars, third-person, includes trigger words)
   - `allowed-tools` (required, must list every tool the skill body references)
   - `argument-hint` (recommended if skill takes arguments)

2. **Description quality** — the description must:
   - Be under 200 characters
   - State WHAT the skill does AND WHEN to use it
   - Use third person
   - Include natural trigger phrases

3. **Word count** — SKILL.md must be under 5000 words. If over, extract content to `references/` files.

4. **Rejection criteria** — verify both sections exist:
   - "When NOT to Use" with at least 2 near-miss anti-patterns
   - "What to Skip" with at least 1 exclusion

5. **Resource references resolve** — every `[text](path)` link in SKILL.md must point to a file that exists. Check with Glob.

6. **Allowed-tools match actual usage** — scan SKILL.md body for tool references (Read, Write, Bash, Edit, Glob, Grep, Task, AskUserQuestion, Agent, Skill, etc.). Every tool mentioned must appear in `allowed-tools`. Flag tools in frontmatter that aren't referenced in the body.

7. **No forbidden patterns:**
   - No "I can help..." or first-person descriptions
   - No empty sections (every ## heading must have content)
   - No TODO/FIXME/placeholder text

**Report format:**

```
## Validation Results

| Check                    | Status | Notes                    |
|--------------------------|--------|--------------------------|
| Frontmatter complete     | PASS   |                          |
| Description quality      | PASS   | 142 chars, third-person  |
| Word count               | PASS   | 1,847 / 5,000            |
| Rejection criteria       | PASS   | 3 anti-patterns, 2 skips |
| References resolve       | PASS   | 2/2 links valid          |
| Allowed-tools match      | WARN   | Bash used but not listed |
| No forbidden patterns    | PASS   |                          |
```

Fix any failures before proceeding. Warnings are advisory.

---

### Step 6: Iterate

Test and refine based on real usage.

1. **Review description against test prompts** — would the Step 4 trigger prompts activate this skill based on the description alone? If not, the description needs more trigger words
2. **Test immediately** — invoke the skill on the first test prompt
3. **Verify anti-triggers** — confirm near-miss prompts don't activate it
4. **Read the transcript** — did the agent follow the skill or drift? If it ignored a section, that section needs rewriting (explain the why) or cutting (it wasn't pulling its weight)
5. Optionally: `/magi "review this skill for clarity and completeness"`

**For discipline/process skills (additional steps):**

6. **Baseline test** — run the scenario without the skill loaded. Note every shortcut, skip, or rationalization. If the agent already does the right thing without the skill, the skill isn't needed
7. **Populate anti-rationalization table** — from baseline observations, add each excuse and counter to the skill
8. **Pressure test** — combine 3+ pressures (time + sunk cost + authority) in a test prompt. If the agent shortcuts under pressure, tighten the gates or add to the rationalization table
9. **Define measurable criteria** — 3-6 binary pass/fail questions for the skill's output. This makes the skill autoresearch-ready for future optimization

## Output Location

Write to the target skill directory's `SKILL.md` (for example `~/.claude/skills/{skill-name}/SKILL.md`).

Only create reference files if content exceeds 300 lines or has distinct reference material.
