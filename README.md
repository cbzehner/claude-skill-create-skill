> **Moved:** this skill now lives in [cbzehner/skills](https://github.com/cbzehner/skills) under `skills/create-skill/`. This repo is archived and read-only.

# Create Skill

Create, update, and audit agent skills. It turns recurring workflows into lean `SKILL.md` files with good trigger text, useful boundaries, and enough validation to know the skill will load.

## Use It For

- Making a new reusable agent workflow
- Tightening skill descriptions and trigger behavior
- Auditing a bloated skill without changing its intent

## Install

Clone the repo and run the installer:

```bash
git clone https://github.com/cbzehner/skill-create-skill.git
cd skill-create-skill
./install.sh all
```

Install targets:

- `./install.sh claude` installs to `~/.claude/skills/create-skill`
- `./install.sh codex` installs to `~/.codex/skills/create-skill`
- `./install.sh agents` installs to `~/.agents/skills/create-skill`
- `./install.sh opencode` installs to `~/.config/opencode/skills/create-skill`
- `./install.sh all --copy` copies files instead of symlinking

Manual install works too: symlink or copy `skills/create-skill` into your agent's skills directory.

## Agent Support

This repo uses the plain `skills/create-skill/SKILL.md` layout. Claude Code and Codex also get small plugin manifests at `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json`.

Other agents can read the same `SKILL.md` file. If a host does not support a frontmatter field or tool name, ignore that field and follow the workflow text.

## Layout

```text
.claude-plugin/plugin.json
.codex-plugin/plugin.json
install.sh
skills/create-skill/SKILL.md
README.md
LICENSE
```

## Public Notes

These repos are public. Keep private repo names, secrets, customer data, raw logs, cookies, and absolute filesystem paths out of examples.

## License

MIT