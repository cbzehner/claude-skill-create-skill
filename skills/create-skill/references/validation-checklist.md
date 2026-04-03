# Validation Checklist

## Step 4: Edit — Refinement Questions

### Completeness

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

### Validation Questions (define success before testing)

- "Give me 3 test prompts that SHOULD trigger this skill"
- "Give me 2 prompts that should NOT trigger it"
- "For the first test prompt, what does good output look like?"

Guide the user toward **realistic** test prompts — concrete, with file paths, personal context, casual phrasing, maybe typos. Not abstract ("format this data") but specific ("ok so I have this CSV in ~/Downloads called q4-sales.xlsx and I need to...").

Anti-trigger prompts should be **near-misses**: queries that share keywords with the skill but actually need something different.

### Hardening (based on skill type from Step 1)

For discipline and process skills, also ask:
- "What corners would an agent cut if it were in a rush?" -> seeds the anti-rationalization table
- "What does failure look like if the skill is ignored?" -> defines what baseline testing should catch

See [techniques.md](techniques.md) for the full hardening guide. Apply techniques matched to the skill type:
- Discipline skills: full stack (anti-rationalization, pressure testing, persuasion, hard gates)
- Process skills: recommended (anti-rationalization, pressure testing, sequential gates)
- Technique/Reference/Always-on: light validation only

## Step 5: Package — Quality Checks

Run these checks and report results to user:

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

### Report Format

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

## Step 6: Iterate — Testing Protocol

1. **Review description against test prompts** — would the Step 4 trigger prompts activate this skill based on the description alone? If not, the description needs more trigger words
2. **Test immediately** — invoke the skill on the first test prompt
3. **Verify anti-triggers** — confirm near-miss prompts don't activate it
4. **Read the transcript** — did the agent follow the skill or drift? If it ignored a section, that section needs rewriting (explain the why) or cutting (it wasn't pulling its weight)
5. Optionally: `/magi "review this skill for clarity and completeness"`

### For Discipline/Process Skills (additional steps)

6. **Baseline test** — run the scenario without the skill loaded. Note every shortcut, skip, or rationalization. If the agent already does the right thing without the skill, the skill isn't needed
7. **Populate anti-rationalization table** — from baseline observations, add each excuse and counter to the skill
8. **Pressure test** — combine 3+ pressures (time + sunk cost + authority) in a test prompt. If the agent shortcuts under pressure, tighten the gates or add to the rationalization table
9. **Define measurable criteria** — 3-6 binary pass/fail questions for the skill's output. This makes the skill autoresearch-ready for future optimization
