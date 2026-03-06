# Claude Code Configuration Guide

Claude Code is Anthropic's CLI for AI-assisted software development. This dotfiles setup manages the global `CLAUDE.md` instructions file and auto-installs the CLI.

## What's Included

### Global Instructions (`config/claude/CLAUDE.md`)

A `CLAUDE.md` file that gets symlinked to `~/.claude/CLAUDE.md`. Claude Code reads this file at the start of every session, across all projects. It contains:

- **Git Commits** — Conventional commits format, no co-authored-by lines
- **TDD Workflow** — Tests first, then implementation
- **Code Check Dance** — Pre-commit sequence: format, credo, dialyzer, test
- **Testing Philosophy** — Unit vs integration vs E2E definitions
- **Elixir Code Style** — Pattern matching, specs, context modules as public API
- **User Preferences** — Interactive domain exploration, iterative workflow
- **Git Worktrees** — Bare repo + sibling worktree convention (see below)
- **New Elixir Project Playbook** — Step-by-step for `phx.new` projects

### Settings (`.claude/settings.local.json`)

Pre-approved tool permissions so Claude Code doesn't prompt for common operations:
- `Bash(grep:*)`, `Bash(git add:*)`, `Bash(git commit:*)`, `Bash(git push:*)`

## Installation

Handled automatically by `install.sh`:

```bash
# Creates ~/.claude/ directory
mkdir -p ~/.claude

# Symlinks global instructions
ln -fsv ~/dotfiles/config/claude/CLAUDE.md ~/.claude/CLAUDE.md

# Installs Claude Code CLI if missing
curl -fsSL https://cli.anthropic.com/install.sh | sh
```

## Git Worktree Convention

Claude Code has a built-in `EnterWorktree` tool that creates worktrees inside `.claude/worktrees/`. This conflicts with the bare repo + sibling pattern used in this dotfiles setup.

The global `CLAUDE.md` instructs Claude Code to:
- **Never use `EnterWorktree`** — it creates worktrees in the wrong location
- Use `git worktree add <name> -b <branch-name>` from the project root instead
- Expect the user to start a new session from the target worktree directory

Expected layout:
```
project/
├── .bare/        # bare repo (via git bare-init or git bare-clone)
├── main/         # worktree -> main branch
├── feature-x/    # worktree -> feature branch
└── hotfix/       # worktree -> another branch
```

See [Git Configuration](GIT.md#bare-clone--init-with-worktrees) for the `git bare-clone` and `git bare-init` subcommands.

## Per-Project Instructions

In addition to the global `~/.claude/CLAUDE.md`, each project can have its own `CLAUDE.md` at the repo root. Claude Code merges both — global preferences apply everywhere, project-specific ones override or add to them.

Example project `CLAUDE.md`:
```markdown
# MyProject

## Tech Stack
- Elixir 1.19 / Phoenix 1.8 / PostgreSQL 15

## Commands
- `mix test` — run tests
- `mix precommit` — full check dance

## Conventions
- All money in centavos (integer)
- Binary UUIDs for all schemas
```

## Customization

Edit `~/dotfiles/config/claude/CLAUDE.md` to change global instructions. Changes take effect on the next Claude Code session (no restart needed — it reads the file fresh each time).

Common additions:
- Language-specific conventions (Ruby, TypeScript, etc.)
- Team workflow rules (PR format, branch naming)
- Tool preferences (package managers, test runners)
