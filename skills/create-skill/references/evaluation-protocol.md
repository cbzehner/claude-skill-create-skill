# Skill Evaluation Protocol

Quantitative measurement of a skill's cost, routing, and behavior — without changing it. The audit (Step 7) changes a skill; evaluation measures one. Run it at Step 5 packaging, before and after an audit (so changes are eval-gated, not vibes-gated), or as a periodic health check.

Order checks by determinism: scripts first, probe panels second, LLM judging last and only for subjective qualities.

## Metrics

1. **Token profile** — `scripts/token-profile.sh <skill-dir>`. Reports tokens by load tier: frontmatter (always in the skill listing), SKILL.md (every invocation), references (on demand).
2. **Usage stats** — `scripts/usage-stats.sh <skill-name>`. Session counts and per-reference read rates from local transcripts. Approximate, but enough to compute expected load.
3. **Expected load** — `SKILL.md tokens + Σ(reference tokens × read rate)`. This is the number that matters: optimization priority follows expected load, not file size. A cut in a reference read in 2% of sessions is worth 2% of the same cut in SKILL.md. Conversely, references are cheap places to add depth.
4. **Trigger-selection F1** — probe panel below.
5. **Behavioral adherence** — binary criteria checks below.

## Probe Panel (trigger F1)

Probes live in `<skill-dir>/tests/probes.yaml` — superpowers-bench-compatible entries of `prompt`, `expected_skills`, optional `trigger_hint`. Minimum 6 should-trigger and 4 near-miss probes. Write them realistically: casual phrasing, concrete paths, no skill names — a probe that quotes the description tests nothing.

For each probe, spawn an independent subagent (Agent tool) given:
- a skill listing — the target skill's name + description verbatim, plus 10-15 plausible confuser skills with their real descriptions
- the probe prompt
- the instruction to pick the single skill it would invoke first (or none) and answer in JSON

The probe agent must not know which skill is under test, and probes must run as separate agents — a single agent grading all probes anchors on its earlier answers. Run the panel in parallel.

Score precision, recall, and F1 for the target skill, with per-probe routing in the report. Thresholds:

| F1 | Verdict |
|---|---|
| ≥ 0.9 | Healthy routing |
| 0.7 – 0.9 | Description needs trigger work — check which probes missed and what vocabulary they used |
| < 0.7 | Routing is broken; treat the description as the bug |

When changing a description, re-run the same panel before and after. Never compare across different probe sets, and never edit probe wording between runs — even an innocuous added sentence (e.g., cost framing) changes routing behavior and invalidates the comparison.

Selection is stochastic: before treating a single surprising result as signal, re-run that probe 3× on both the old and new description with identical wording. A probe that flips occasionally under both versions is borderline by design — note its false-positive rate in `probes.yaml` rather than chasing it with description changes.

## Adherence Checks

Define 3-6 binary pass/fail criteria from the skill's load-bearing behaviors — output paths, gates, question cadence, thresholds, escalation rules (see techniques.md, Technique 6). Pre-register them before running anything.

**Single variant** (health check): give a fresh subagent the SKILL.md text as its only instruction source plus a realistic invocation, and ask for its concrete execution plan. Score the criteria deterministically against the plan.

**Comparing variants** (after an audit): stage both versions under neutral names (`/tmp/skill-variant-A.md`, `-B.md`) so responders can't tell baseline from candidate. Run one responder per variant in parallel. Score deterministic criteria first — if all assertions are unambiguous, no judge is needed. Use an LLM judge only for subjective qualities, and then: pairwise with a rubric, run twice with positions swapped, disagreement counts as a tie, 3+ repeats. Position bias in pairwise judging is worst exactly when variants are close — the normal case for audit comparisons.

## External Tools (deeper passes, optional)

- **skill-cleaner** (agent-scripts) — library-wide description budget vs. the Codex 2% metadata cap, duplicate detection, unused-skill candidates.
- **superpowers-bench** — full-session selection benchmark across agents/models; `tests/probes.yaml` matches its task format, so probes written here can graduate to full-session runs.

## Report Format

```
## Evaluation: <skill-name> (<date>)

| Metric            | Value                       | Verdict |
|-------------------|-----------------------------|---------|
| Frontmatter       | 131 tokens                  | OK      |
| SKILL.md          | 1,563 tokens                | OK      |
| Expected load     | ~1,830 tokens/invocation    | OK      |
| Trigger F1        | 1.0 (6/6 trigger, 4/4 miss) | Healthy |
| Adherence         | 5/5 criteria                | Pass    |

Per-probe routing: <table or bullet list>
Notes: <anything surprising — misrouted probes, never-read references, drop-off patterns>
```

## Why These Measures

- Long/dense instruction sets measurably degrade compliance (context rot; instruction-density studies show primacy bias toward early rules) — hence per-tier token accounting and expected load.
- Skill selection happens on the description alone, so routing must be tested against the description in a realistic listing, not against the full body.
- LLM judges flip verdicts based on answer order; deterministic criteria and swap tests are the mitigation.
