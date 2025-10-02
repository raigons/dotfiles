# Tmux Configuration

Comprehensive guide to the Tmux setup in this dotfiles configuration.

## Overview

This configuration provides a Vim-friendly Tmux setup with intuitive key bindings, a custom color scheme, and enhanced productivity features.

## Quick Reference

- **Prefix Key**: `Ctrl+b` (default)
- **Terminal Support**: 256-color
- **Navigation**: Vim-style (`hjkl`) + Alt-arrows (no prefix needed)
- **Split Panes**: `|` for vertical, `-` for horizontal
- **Color Scheme**: Custom purple/gray theme

## Key Bindings

### Pane Splitting

| Key | Action |
|-----|--------|
| `Prefix` + `\|` | Split pane vertically (side-by-side) |
| `Prefix` + `-` | Split pane horizontally (top-bottom) |

**Note:** Default bindings (`"` and `%`) are disabled.

### Pane Navigation

#### With Prefix (Vim-style)

| Key | Action |
|-----|--------|
| `Prefix` + `h` | Move to left pane |
| `Prefix` + `j` | Move to bottom pane |
| `Prefix` + `k` | Move to top pane |
| `Prefix` + `l` | Move to right pane |

#### Without Prefix (Arrow keys)

| Key | Action |
|-----|--------|
| `Alt+Left` | Move to left pane |
| `Alt+Right` | Move to right pane |
| `Alt+Up` | Move to top pane |
| `Alt+Down` | Move to bottom pane |

**Tip:** Arrow key navigation doesn't require the prefix, making it faster for quick pane switching.

### Utility Commands

| Key | Action |
|-----|--------|
| `Prefix` + `r` | Reload Tmux configuration |
| `Ctrl+k` | Clear pane history (no prefix needed) |

## Color Scheme

### Custom Palette

The configuration uses a custom purple/gray color scheme:

- **Background**: Dark gray (`colour236`)
- **Foreground**: Dark purple (`colour61`)
- **Active Window**: White on dark purple
- **Inactive Window**: Yellow on dark gray
- **Highlights**: Light purple, yellow, white

### Status Bar

- **Position**: Bottom of screen
- **Update Interval**: 2 seconds
- **Window List Alignment**: Center
- **Left Status Length**: 400 characters
- **Right Status Length**: 90 characters

## Configuration Details

### Display Settings

```tmux
set -g default-terminal "screen-256color"
```

Enables 256-color support for rich color schemes and syntax highlighting.

### Performance

```tmux
set -g history-limit 5000
```

Scrollback buffer stores up to 5,000 lines of history.

### Window Management

```tmux
setw -g window-status-format ' #I #W '
```

Window tabs show: `[index] [name]`

Example: ` 1 zsh `, ` 2 vim `, ` 3 server `

## Common Workflows

### Creating a Development Layout

1. Start Tmux:
   ```bash
   tmux
   ```

2. Split vertically for code and terminal:
   ```
   Prefix + |
   ```

3. Split the right pane horizontally for logs:
   ```
   Alt+Right (move to right pane)
   Prefix + -
   ```

4. Navigate between panes:
   ```
   Alt+Left/Right/Up/Down
   ```

Result:
```
┌─────────────┬─────────────┐
│             │             │
│             │   Terminal  │
│    Editor   │             │
│             ├─────────────┤
│             │             │
│             │    Logs     │
└─────────────┴─────────────┘
```

### Quick Tips

1. **Reload config after changes:**
   ```
   Prefix + r
   ```
   You'll see: "Config reloaded..."

2. **Clear pane history:**
   ```
   Ctrl+k
   ```
   (No prefix needed!)

3. **Detach from session:**
   ```
   Prefix + d
   ```

4. **List sessions:**
   ```bash
   tmux ls
   ```

5. **Attach to session:**
   ```bash
   tmux attach -t [session-name]
   ```

## Customization

### Changing the Prefix Key

To change from `Ctrl+b` to `Ctrl+a` (popular alternative), add to `.tmux.conf`:

```tmux
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

### Adjusting Colors

Modify the color palette variables:

```tmux
black='colour16'
white='colour255'
gray='colour236'
yellow='colour215'
light_purple='colour141'
dark_purple='colour61'
```

Find available colors:
```bash
for i in {0..255}; do
  printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
done
```

### Mouse Support

To enable mouse support (scrolling, pane selection), add:

```tmux
set -g mouse on
```

**Note:** This may interfere with terminal text selection.

## Essential Tmux Commands

### Session Management

```bash
tmux new -s myproject          # Create named session
tmux ls                         # List sessions
tmux attach -t myproject       # Attach to session
tmux kill-session -t myproject # Kill session
```

### Window Management

| Key | Action |
|-----|--------|
| `Prefix` + `c` | Create new window |
| `Prefix` + `n` | Next window |
| `Prefix` + `p` | Previous window |
| `Prefix` + `0-9` | Switch to window 0-9 |
| `Prefix` + `,` | Rename current window |
| `Prefix` + `&` | Kill current window |

### Pane Management

| Key | Action |
|-----|--------|
| `Prefix` + `x` | Kill current pane |
| `Prefix` + `z` | Toggle pane zoom (fullscreen) |
| `Prefix` + `{` | Swap pane with previous |
| `Prefix` + `}` | Swap pane with next |
| `Prefix` + `Space` | Cycle through pane layouts |

### Copy Mode

| Key | Action |
|-----|--------|
| `Prefix` + `[` | Enter copy mode |
| `Space` | Start selection |
| `Enter` | Copy selection |
| `Prefix` + `]` | Paste |

**Tip:** Use Vim motions in copy mode (`h`, `j`, `k`, `l`, `w`, `b`, etc.)

## Troubleshooting

### Colors Not Displaying Correctly

1. Check terminal emulator supports 256 colors:
   ```bash
   echo $TERM
   # Should show: screen-256color (in tmux)
   ```

2. Force 256 color support in terminal preferences

3. Add to `.zshrc` or `.bashrc`:
   ```bash
   export TERM=xterm-256color
   ```

### Key Bindings Not Working

1. Verify Tmux is running:
   ```bash
   echo $TMUX
   # Should output a path if inside tmux
   ```

2. Reload configuration:
   ```
   Prefix + r
   ```

3. Check for conflicts:
   ```bash
   tmux list-keys | grep <your-binding>
   ```

### Prefix Key Not Responding

1. Make sure you're pressing the right prefix (`Ctrl+b` by default)
2. Check if another application is capturing the key
3. Try the prefix in a new Tmux window

## Configuration File Location

```
~/.tmux.conf  →  Symlinks to  →  ~/dotfiles/.tmux.conf
```

Any changes to `~/dotfiles/.tmux.conf` take effect after reloading with `Prefix + r`.

## Plugin Recommendations

Consider adding [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm) for these plugins:

- **[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)** - Save/restore sessions
- **[tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)** - Automatic session saving
- **[tmux-yank](https://github.com/tmux-plugins/tmux-yank)** - Better copy/paste
- **[tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)** - Sensible default options

## Learning Resources

- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [A Quick and Easy Guide to tmux](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)
- [Official Tmux Manual](https://man.openbsd.org/tmux.1)
- [Awesome Tmux](https://github.com/rothgar/awesome-tmux)

## Advanced Tips

1. **Synchronized Panes**: Type in all panes simultaneously
   ```
   :setw synchronize-panes on
   ```

2. **Save Pane Output**: Capture pane content to file
   ```
   Prefix + :
   capture-pane -S -
   save-buffer ~/output.txt
   ```

3. **Named Windows**: Organize multi-project workflows
   ```bash
   tmux new -s work
   # Prefix + , (rename to "editor")
   # Prefix + c (new window)
   # Prefix + , (rename to "server")
   ```

4. **Zoom Toggle**: Focus on one pane temporarily
   ```
   Prefix + z
   ```
