# Global Preferences

## Git Commits
- Never add `Co-Authored-By` or "Generated with Claude Code" lines to commit messages.
- Follow conventional commits format: `feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `chore:`.
- Keep commit messages clean and professional.

## Development Workflow

### TDD
- Always write tests first, then implementation.
- Exception: when certifying existing behavior (understanding existing code), tests can come after.
- All tests must pass before marking work complete.
- Test edge cases and error conditions.
- Name tests descriptively.

### Code Check Dance (pre-commit)
Run this sequence before committing on all Elixir projects:
1. `mix format`
2. `mix credo` (static analysis)
3. `mix dialyzer` (type checking)
4. `mix test`

### Testing Philosophy
- **Unit test**: tests one module in isolation
- **Integration test**: multiple real implementations interact
- **E2E test**: full pipeline
- Key distinction: DB access for module's own data = unit; calling another module with distinct responsibility = integration
- Use ExMachina for test factories
- Use Mox for mocking

## Elixir Code Style
- Use pattern matching over conditionals
- Add `@moduledoc`, `@doc`, and `@spec` to all public functions
- Context modules are the public API — don't call Repo directly outside contexts
- Database IDs are binary UUIDs (`:binary_id`)

## User Preferences
- User likes interactive domain exploration — don't rush into schema design
- Start with the "kernel" (contexts as internal API), callable from IEx
- Web/API exposure comes after domain is solid
- User works iteratively: scaffold → discuss → refine

## New Elixir Project from Scratch — Playbook

When user says "start a new elixir project from scratch" or similar, follow this sequence.

**Note:** These are defaults. When the user provides specifics (e.g. "REST API + RabbitMQ",
"LiveView app", "GraphQL microservice"), adapt accordingly — adjust Phoenix flags, add
relevant deps, scaffold the right modules, and skip the "keep flexible" steps that are
already decided. The playbook is a starting point, not a rigid script.

### 1. Git bare repo + worktree setup

User prefers bare repo + worktree pattern for all projects.
Custom subcommands available: `git bare-init` (local) and `git bare-clone` (remote).

```bash
cd <project-dir>
git bare-init   # creates .bare/ + .git pointer + main/ worktree
cd main/
```

Result: `<project>/main/` is the working directory, siblings for feature branches.

### 2. Check/install runtime versions

- Use latest stable Elixir + Erlang via asdf
- `asdf install erlang <latest>` (compiles from source, ~10 min — run in background)
- `asdf install elixir <latest>-otp-<version>`
- `mix local.hex --force && mix local.rebar --force` for new Elixir versions
- Install Phoenix generator if missing: `mix archive.install hex phx_new --force`

### 3. Create Phoenix project

Default flags (unless user specifies otherwise):
```bash
mix phx.new <app_name> --no-html --no-assets --no-mailer --no-dashboard --no-gettext --binary-id
```

- `--no-html --no-assets`: API-only mode (UI layer decided later)
- `--binary-id`: UUIDs for all schemas
- Other flags keep it lean — add features later as needed

Move project files to worktree root (avoid nested `main/<app_name>/`):
```bash
mv <app_name>/* . && mv <app_name>/.* . 2>/dev/null; rm -rf <app_name>
```

### 4. Frontend exposure — keep flexible

Don't decide frontend approach upfront. Phoenix contexts ARE the internal API. Options added later:
- REST API (Phoenix controllers)
- LiveView (phoenix_live_view dep)
- JS frontend Vue/React (REST API + separate project)
- GraphQL (Absinthe)
All sit on top of the same contexts — no architecture change needed.

### 5. Project configs

- `.tool-versions` — pin erlang + elixir versions
- `CLAUDE.md` at project root — conventions, commands, tech stack
- Start PostgreSQL if not running: `brew services start postgresql@15`

### 6. Verify

```bash
mix deps.get
mix ecto.create
mix test
mix format
```
