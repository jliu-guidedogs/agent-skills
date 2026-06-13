# agent-skills

Personal agent skills for Cursor, Claude Code, and Codex. Install once, use across projects.

## Layout

```text
agent-skills/
├── docs/authoring.md
├── scripts/
│   ├── install-personal.sh      # macOS / Linux
│   └── install-personal.bat     # Windows
├── templates/skill-template/
└── skills/
    ├── thought-companion/          # orchestrator
    ├── brainstorm-diverge-converge/
    ├── socratic/
    ├── decision-helper/
    ├── idea-evaluator/
    ├── grill-me/
    ├── deep-understanding/
    ├── handoff/
    └── graphify/                   # optional
```

Each skill is one folder with a required `SKILL.md`.

## Install

### Personal (all projects)

Install the **core thinking stack** (8 skills):

**macOS / Linux:**

```bash
./scripts/install-personal.sh
```

**Windows (Command Prompt or PowerShell):**

```bat
scripts\install-personal.bat
```

This links skills into three personal skill directories:

| Path | Agent |
|------|-------|
| `~/.cursor/skills` | Cursor |
| `~/.claude/skills` | Claude Code |
| `~/.agents/skills` | Codex and other shared-agent harnesses |

On Windows, `%USERPROFILE%` replaces `~`.

Include optional skills (e.g. `graphify`):

```bash
./scripts/install-personal.sh --with-optional
```

```bat
scripts\install-personal.bat --with-optional
```

On Windows, the batch script uses directory junctions when possible (no admin required). If linking fails, enable **Developer Mode** (Settings → System → For developers) or run the script as Administrator.

Restart Cursor, Claude Code, or start a new agent session after installing.

### Manual symlink

```bash
ln -sf ~/workspace/agent-skills/skills/thought-companion ~/.cursor/skills/thought-companion
ln -sf ~/workspace/agent-skills/skills/thought-companion ~/.claude/skills/thought-companion
ln -sf ~/workspace/agent-skills/skills/thought-companion ~/.agents/skills/thought-companion
```

Repeat for each skill, or use the install script above.

### Project-scoped

Copy or symlink into a repo:

```bash
mkdir -p .cursor/skills
ln -sf ~/workspace/agent-skills/skills/thought-companion .cursor/skills/thought-companion
```

## Core thinking stack

| Skill | Purpose |
|-------|---------|
| `thought-companion` | Orchestrates structured thinking sessions (explore, challenge, decide, record) |
| `brainstorm-diverge-converge` | Generate options, cluster themes, narrow choices |
| `socratic` | Probe assumptions through layered questioning |
| `decision-helper` | Compare options with decision frameworks |
| `idea-evaluator` | Stress-test ideas and plans objectively |
| `grill-me` | Interview through a design decision tree, one question at a time |
| `deep-understanding` | Teach a topic incrementally with comprehension checks |
| `handoff` | Compact a session into a handoff doc for the next agent |

Start with `/thought-companion` or attach `thought-companion` manually. It reads the other skills as needed.

## Optional

| Skill | Purpose | Extra setup |
|-------|---------|-------------|
| `graphify` | Build knowledge graphs from documents and code | `pip install graphifyy` (see skill for CLI usage) |

Not installed by default. Use `--with-optional` with `install-personal.sh` or `install-personal.bat` when you want it.

## Add a new skill

1. Copy `templates/skill-template/` to `skills/<skill-name>/`
2. Edit `SKILL.md` frontmatter (`name`, `description`, `disable-model-invocation`)
3. Keep `SKILL.md` under 500 lines; move detail to `reference.md`
4. Update this README skills list

## Conventions

See [docs/authoring.md](docs/authoring.md).
