# Aliases Reference

Complete reference for all shell aliases available in this dotfiles configuration.

## Table of Contents

- [Docker Aliases](#docker-aliases)
- [Elixir/Phoenix Aliases](#elixirphoenix-aliases)
- [PostgreSQL Aliases](#postgresql-aliases)
- [General Aliases](#general-aliases)

---

## Docker Aliases

Docker-related shortcuts for image and container management.

**Source:** `system/.docker-aliases`

### `drmi`

Remove Docker image by ID or name.

```bash
drmi <image_id_or_name>
```

**Example:**
```bash
drmi my-app:latest
drmi abc123def456
```

### `drmi_none`

Remove all images tagged as `<none>` (dangling images).

```bash
drmi_none
```

This alias finds all images with `<none>` tag and force-removes them. Useful for cleaning up after builds.

**Warning:** This uses `--force` flag and will remove images without confirmation.

---

## Elixir/Phoenix Aliases

Shortcuts for common Elixir, Mix, and Phoenix Framework commands.

**Source:** `system/.elixir-aliases`

### General

#### `e_cmd`

Start an interactive Elixir shell with your Mix project loaded.

```bash
e_cmd
```

Equivalent to: `iex -S mix`

### Database/Ecto Migrations

#### `e_create_migration`

Generate a new Ecto migration file.

```bash
e_create_migration <migration_name>
```

**Example:**
```bash
e_create_migration add_users_table
```

Equivalent to: `mix ecto.gen.migration`

#### `e_migrate`

Run all pending Ecto migrations.

```bash
e_migrate
```

Equivalent to: `mix ecto.migrate`

#### `e_recreate_db`

Drop and recreate the database (development).

```bash
e_recreate_db
```

Equivalent to: `mix ecto.drop && mix ecto.create`

**Warning:** This will delete all data in your development database.

#### `e_reconfigure_db`

Drop, recreate, and migrate the database (development).

```bash
e_reconfigure_db
```

Equivalent to: `mix ecto.drop && mix ecto.create && mix ecto.migrate`

**Warning:** This will delete all data in your development database.

#### `e_reconfigure_test_db`

Drop, recreate, and migrate the test database.

```bash
e_reconfigure_test_db
```

Equivalent to: `MIX_ENV=test mix ecto.drop && MIX_ENV=test mix ecto.create && MIX_ENV=test mix ecto.migrate`

**Warning:** This will delete all data in your test database.

### Phoenix Server

#### `e_phx_s`

Start the Phoenix server.

```bash
e_phx_s
```

Equivalent to: `mix phx.server`

#### `e_phx_debug`

Start the Phoenix server with an interactive IEx console.

```bash
e_phx_debug
```

Equivalent to: `iex -S mix phx.server`

Useful for debugging and inspecting application state while the server is running.

### Erlang/OTP

#### `erlang_version`

Display the current Erlang/OTP version.

```bash
erlang_version
```

Equivalent to: `erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell`

---

## PostgreSQL Aliases

PostgreSQL database management shortcuts using Homebrew services.

**Source:** `system/.postgres-aliases`

**Note:** These aliases are configured for PostgreSQL 15 via Homebrew. Adjust version numbers if needed.

### `connect_psql`

Connect to the local PostgreSQL database as user `ramongoncalves`.

```bash
connect_psql
```

Equivalent to: `psql postgres -U ramongoncalves`

### `pg_start`

Start the PostgreSQL service.

```bash
pg_start
```

Equivalent to: `brew services start postgresql@15`

### `pg_stop`

Stop the PostgreSQL service.

```bash
pg_stop
```

Equivalent to: `brew services stop postgresql@15`

### `pg_restart`

Restart the PostgreSQL service.

```bash
pg_restart
```

Equivalent to: `brew services restart postgresql@15`

### `pg_status`

Check the PostgreSQL service status.

```bash
pg_status
```

Equivalent to: `brew services info postgresql@15`

Shows whether the service is running, stopped, or errored.

---

## General Aliases

Miscellaneous productivity shortcuts.

**Source:** `system/.general-aliases`

### `privateff`

Open Firefox in private browsing mode.

```bash
privateff
```

Equivalent to: `open -a Firefox --args -private-window`

Opens a new Firefox window in private/incognito mode.

---

## Adding Custom Aliases

To add your own aliases:

1. Edit the appropriate file in `system/`:
   - `.docker-aliases` - Docker-related
   - `.elixir-aliases` - Elixir/Phoenix-related
   - `.postgres-aliases` - PostgreSQL-related
   - `.general-aliases` - Everything else

2. Reload your shell or source the file:
   ```bash
   source ~/.zshrc
   ```

### Example

Add to `system/.general-aliases`:

```bash
alias myalias="echo 'Hello World'"
```

Then reload:
```bash
source ~/.zshrc
myalias  # Output: Hello World
```

---

## Troubleshooting

### Aliases Not Working

If aliases aren't available after installation:

1. Check that `.zshrc` sources the alias loader:
   ```bash
   grep "source.*\.alias" ~/.zshrc
   ```

2. Verify the `SYSTEM` environment variable:
   ```bash
   echo $SYSTEM
   # Should output: /Users/yourusername/dotfiles/system
   ```

3. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

### List All Active Aliases

To see all currently loaded aliases:

```bash
alias
```

To search for specific aliases:

```bash
alias | grep docker
```
