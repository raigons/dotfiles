# Global Preferences

## Git Commits
- Never add `Co-Authored-By` or "Generated with Claude Code" lines to commit messages.
- Follow conventional commits format: `feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `chore:`.
- Keep commit messages clean and professional.
- **Never commit on main unless the user explicitly tells you to.** When working on a branch in a different worktree, never make changes or commits on main. Always stay in the worktree folder/branch you're working in.

## Development Workflow

### TDD
- Always write tests first, then implementation.
- Exception: when certifying existing behavior (understanding existing code), tests can come after.
- All tests must pass before marking work complete.
- Test edge cases and error conditions.
- Name tests descriptively.
- Before changing a function signature or behavior, check **all callers** in both `lib/` and `test/`, verify their test coverage, and run those tests green before making changes.

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

Follow the [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide) as the baseline. Key rules and project-specific additions:

### General
- Use pattern matching over conditionals — prefer multi-clause functions over `cond`/`if` inside `case`
- Never nest `if` inside `case` — restructure with `cond` or pattern matching
- Never use `unless` with `else` — rewrite with `if` positive case first
- Don't add defensive guards for cases that can't happen (e.g., checking `is_list` on a field that's always a list)
- When handling atom vs string keys, use separate function clauses with pattern matching
- Use `true` as the default clause in `cond`, not `:else`
- Add `@moduledoc`, `@doc`, and `@spec` to all public functions
- Context modules are the public API — don't call Repo directly outside contexts
- Database IDs are binary UUIDs (`:binary_id`)
- Use `__MODULE__` pseudo variable when a module refers to itself — avoid hardcoding the module name

### Pipes
- No single pipes — `x |> foo()` should be `foo(x)`
- Bare variables start pipe chains — `String.trim(x) |> downcase()` → `x |> String.trim() |> downcase()`
- Use parentheses for one-arity functions in pipes — `x |> String.downcase()` not `x |> String.downcase`

### Error Handling
- Lowercase error messages when raising exceptions, no trailing punctuation — `raise ArgumentError, "this is not valid"`

### Testing
- ExUnit assertion order: expression left, expected right — `assert actual_function(1) == true`
- Exception: pattern matches go the other way — `assert {:ok, expected} = actual_function(3)`

### Module Directive Ordering
Follow the [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide#module-attribute-ordering) ordering for module directives. Strict order, blank line between each group, alphabetical within groups:

```elixir
defmodule MyModule do
  @moduledoc "..."

  @behaviour SomeBehaviour

  use GenServer

  import Foo
  import Bar

  require Logger

  alias My.Module.A
  alias My.Module.B

  @module_attribute :value

  defstruct [:field]

  @type t() :: %__MODULE__{}

  @callback some_function(term) :: :ok

  # ... functions ...
end
```

## User Preferences
- User likes interactive domain exploration — don't rush into schema design
- Start with the "kernel" (contexts as internal API), callable from IEx
- Web/API exposure comes after domain is solid
- User works iteratively: scaffold → discuss → refine

## Git Worktrees

User uses the **bare repo + sibling worktree** pattern for all projects:

```
project/
├── .bare/        # bare repo
├── main/         # worktree → main branch
├── feature-x/    # worktree → feature branch
└── hotfix/       # worktree → another branch
```

**Rules for Claude Code:**
- **Do NOT use the `EnterWorktree` tool.** It creates worktrees inside `.claude/worktrees/`, which breaks the sibling convention and can leave the session stuck on a deleted path.
- To create a new worktree, use Bash: `cd <project-root> && git worktree add <name> -b <branch-name>` (creates `project/<name>/` as sibling to `main/`).
- To work in a different worktree, the user will start a new session from that directory.
- Worktrees are peers — same level, same visibility. Never nest them inside hidden directories.

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
