# Vim Configuration

Comprehensive guide to the Vim setup in this dotfiles configuration.

## Overview

This configuration uses **Vundle** as the plugin manager and the **Dracula** color scheme. It's optimized for web development with JavaScript support and file tree navigation.

## Quick Reference

- **Plugin Manager**: Vundle
- **Color Scheme**: Dracula
- **Line Numbers**: Enabled (relative + absolute)
- **Tab Width**: 2 spaces
- **File Tree**: NERDTree (auto-opens on startup)

## Installation

### First-Time Setup

1. Install Vundle:
   ```bash
   git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
   ```

2. Install plugins:
   ```bash
   vim +PluginInstall +qall
   ```

### Updating Plugins

```bash
vim +PluginUpdate +qall
```

## Key Settings

### Display

```vim
set number          " Show line numbers
set relativenumber  " Show relative line numbers
```

**Why relative numbers?** Makes it easier to use motion commands like `5j` (move down 5 lines).

### Indentation

```vim
set tabstop=2       " Tabs appear as 2 spaces
```

All tabs are displayed as 2 spaces, suitable for JavaScript, HTML, CSS, and most web development.

### Compatibility

```vim
set nocompatible    " Disable Vi compatibility mode
```

Ensures Vim uses modern features instead of being constrained by Vi behavior.

## Plugins

### Core Plugins

#### [Vundle](https://github.com/VundleVim/Vundle.vim)
**Plugin manager** - Handles installation and updates of all other plugins.

---

#### [NERDTree](https://github.com/preservim/nerdtree)
**File tree explorer** - Visual directory tree in a sidebar.

**Key Binding:**
- `Ctrl+n` - Toggle NERDTree sidebar

**Auto-start:** NERDTree opens automatically when you launch Vim.

**Ignored Files:**
- `.DS_Store` (macOS metadata)
- `.git` directory

**Usage:**
```
j/k       - Navigate up/down
Enter     - Open file/directory
s         - Open file in vertical split
i         - Open file in horizontal split
m         - Show filesystem menu (create, delete, move files)
q         - Close NERDTree
?         - Toggle help
```

---

#### [vim-fugitive](https://github.com/tpope/vim-fugitive)
**Git integration** - Run Git commands from within Vim.

**Common Commands:**
```vim
:Git status       " Show git status
:Git commit       " Commit changes
:Git push         " Push to remote
:Git blame        " Show git blame
:Gdiff            " View git diff in split
```

---

#### [Command-T](https://github.com/wincent/command-t)
**Fuzzy file finder** - Quickly open files by typing partial names.

---

#### [Sparkup](https://github.com/rstacruz/sparkup)
**HTML shorthand expander** - Write HTML faster with CSS-like syntax.

**Example:**
```
Type:  div.container>ul>li*3
Press: Ctrl+e

Result:
<div class="container">
  <ul>
    <li></li>
    <li></li>
    <li></li>
  </ul>
</div>
```

---

#### [xml.vim](https://github.com/othree/xml.vim)
**XML syntax highlighting** - Enhanced XML/HTML editing.

---

#### [vim-javascript](https://github.com/pangloss/vim-javascript)
**JavaScript syntax** - Improved JavaScript syntax highlighting and indentation.

---

#### [Dracula Theme](https://github.com/dracula/vim)
**Color scheme** - Dark theme with vibrant colors, easy on the eyes.

## Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+n` | Toggle NERDTree file explorer |

## Vundle Commands

Run these commands from within Vim (start with `:`):

| Command | Description |
|---------|-------------|
| `:PluginList` | List all configured plugins |
| `:PluginInstall` | Install plugins (append `!` to update) |
| `:PluginUpdate` | Update all plugins |
| `:PluginSearch foo` | Search for plugin named "foo" |
| `:PluginClean` | Remove unused plugins (append `!` to auto-approve) |

## Adding New Plugins

1. Edit `.vimrc` and add the plugin between `vundle#begin()` and `vundle#end()`:

   ```vim
   call vundle#begin()

   " ... existing plugins ...

   " Add your new plugin here
   Plugin 'author/plugin-name'

   call vundle#end()
   ```

2. Reload `.vimrc` and install:
   ```vim
   :source ~/.vimrc
   :PluginInstall
   ```

### Plugin Format Examples

```vim
" GitHub repository
Plugin 'tpope/vim-surround'

" Plugin from vim-scripts.org
Plugin 'L9'

" Git repository (non-GitHub)
Plugin 'git://git.wincent.com/command-t.git'

" Local plugin
Plugin 'file:///path/to/plugin'

" Plugin in subdirectory
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Renamed plugin (avoid naming conflicts)
Plugin 'ascenator/L9', {'name': 'newL9'}
```

## Recommended Additional Plugins

Consider adding these popular plugins:

- **[vim-airline](https://github.com/vim-airline/vim-airline)** - Enhanced status bar
- **[vim-surround](https://github.com/tpope/vim-surround)** - Easily add/change/delete surrounding quotes/brackets
- **[fzf.vim](https://github.com/junegunn/fzf.vim)** - Fuzzy finder integration
- **[vim-commentary](https://github.com/tpope/vim-commentary)** - Easy code commenting
- **[ale](https://github.com/dense-analysis/ale)** - Asynchronous linting

## Troubleshooting

### Plugin Not Working

1. Verify plugin is in `.vimrc` between `vundle#begin()` and `vundle#end()`
2. Install/update plugins:
   ```vim
   :PluginInstall
   ```
3. Restart Vim

### NERDTree Not Opening

Check the configuration line:
```vim
autocmd VimEnter * NERDTree
```

To disable auto-start, comment it out:
```vim
" autocmd VimEnter * NERDTree
```

### Dracula Theme Not Loading

1. Ensure Dracula plugin is installed:
   ```vim
   :PluginInstall
   ```

2. Verify these lines are present:
   ```vim
   syntax on
   colorscheme dracula
   ```

3. Check if your terminal supports 256 colors

### Command-T Issues

Command-T requires compilation. If it doesn't work:

```bash
cd ~/.vim/bundle/command-t
rake make
```

## Configuration File Location

```
~/.vimrc  →  Symlinks to  →  ~/dotfiles/.vimrc
```

Any changes to `~/dotfiles/.vimrc` will immediately affect your Vim setup.

## Learning Resources

- [Vim Cheat Sheet](https://vim.rtorr.com/)
- [Vundle Documentation](https://github.com/VundleVim/Vundle.vim)
- [NERDTree Tutorial](https://github.com/preservim/nerdtree/blob/master/doc/NERDTree.txt)
- [Interactive Vim Tutorial](https://www.openvim.com/)

## Tips

1. **Use relative line numbers**: Jump to any visible line with `{count}j` or `{count}k`
2. **NERDTree filesystem menu**: Press `m` in NERDTree to create/delete/move files
3. **Split editing**: Open files in splits with `:split` (horizontal) or `:vsplit` (vertical)
4. **Git integration**: Use `:Git` for all git commands without leaving Vim
