# Create Skill

Create, update, or audit agent skills and SKILL.md files. Use when the user wants to make a new /command or /skill, improve skill frontmatter or trigger pickup, benchmark whether a skill gets selected, formalize a repeating workflow into reusable agent automation, prune token bloat, or validate an existing skill. Produces skill definitions, not implementation plans.

## Skill

This repository packages one portable agent skill:

- `create-skill` - Create, update, or audit agent skills and SKILL.md files. Use when the user wants to make a new /command or /skill, improve skill frontmatter or trigger pickup, benchmark whether a skill gets selected, formalize a repeating workflow into reusable agent automation, prune token bloat, or validate an existing skill. Produces skill definitions, not implementation plans.

The canonical skill body lives at `skills/create-skill/SKILL.md`. Keep behavior changes there; keep this README focused on installation and packaging.

## Install

Clone the repository, then run the installer:

```bash
git clone https://github.com/cbzehner/skill-create-skill.git
cd skill-create-skill
./install.sh all
```

Install targets:

- `./install.sh claude` -> `~/.claude/skills/create-skill`
- `./install.sh codex` -> `~/.codex/skills/create-skill`
- `./install.sh agents` -> `~/.agents/skills/create-skill` for generic agent harnesses such as Pi/Hermes-style setups
- `./install.sh opencode` -> `~/.config/opencode/skills/create-skill`
- `./install.sh all --copy` copies files instead of symlinking

Manual installation is just a symlink or copy from `skills/create-skill` into your agent's skills directory.

## Compatibility

This repo uses the common `skills/<name>/SKILL.md` layout so agents that understand file-based skills can load it directly. Host-specific metadata is included where useful:

- Claude Code: `.claude-plugin/plugin.json` and direct `~/.claude/skills` install
- Codex CLI: `.codex-plugin/plugin.json` with `skills: "./skills/"` and direct `~/.codex/skills` install
- Other agents: direct install to the agent's skills directory; unsupported frontmatter fields can be ignored

Some skills mention optional host tools such as `Task`, `Agent`, `Skill`, MCP tools, or browser automation CLIs. On hosts that do not provide those tools, adapt to equivalent local capabilities and keep the same workflow intent.

## Public Safety

These repositories are public. Do not commit organization-specific instructions, private repository names, secrets, tokens, cookies, raw session logs, customer data, or machine-local paths. Use environment variables and generic paths in examples.

## Repository Layout

```text
.claude-plugin/plugin.json   # Claude plugin metadata
.codex-plugin/plugin.json    # Codex plugin metadata
install.sh                   # Symlink/copy installer for common agent skill dirs
skills/create-skill/SKILL.md
README.md
LICENSE
```

## License

MIT
