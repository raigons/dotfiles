# Dotfiles

A clean and modular dotfiles configuration for macOS development, optimized for Elixir, Docker, and PostgreSQL workflows.

## Features

- **Zsh Configuration** - Spaceship prompt theme with custom configurations
- **Vim Setup** - vim-plug based plugin management with NERDTree and syntax highlighting
- **Tmux Configuration** - Vim-style navigation and custom key bindings
- **Modular Aliases** - Organized by domain (Docker, Elixir, PostgreSQL, General)
- **PATH Deduplication** - Automatic cleanup of redundant PATH entries
- **Multi-Profile Git Configuration** - Automatic git identity switching based on project directory (work, personal, anonymous)
- **Git Bare Clone & Init** - Custom `git bare-clone` and `git bare-init` subcommands for worktree-based workflows

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# Install Oh My Zsh (if not already installed)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Run the installation script
cd ~/dotfiles
chmod +x install.sh setup-dependencies.sh
./install.sh

# Install zsh plugins and themes
./setup-dependencies.sh

# Restart your terminal or reload configuration
source ~/.zshrc
```

The installation will:
- Backup your existing dotfiles to `~/.dotfiles_backup_TIMESTAMP` (skipped if symlinks already set up)
- Create `.zshrc` from the example template
- Symlink all configuration files to your home directory
- Install Vim plugins automatically via vim-plug
- Install required zsh plugins (zsh-nvm, zsh-completions)
- Install Spaceship prompt theme
- Install fast-syntax-highlighting

## Structure

```
dotfiles/
├── .zshrc              # Main Zsh configuration (gitignored, machine-specific)
├── .zshrc.example      # Template for fresh installations
├── .vimrc              # Vim configuration
├── .tmux.conf          # Tmux configuration
├── Brewfile            # Homebrew packages, casks, and VS Code extensions
├── install.sh          # Installation script
├── setup-dependencies.sh # Zsh plugin and theme installer
├── config/
│   └── git/
│       ├── .gitconfig              # Main git config with conditional includes
│       ├── .gitconfig-work         # Work profile
│       ├── .gitconfig-personal     # Personal profile
│       └── .gitconfig-anonymous    # Anonymous profile (assessments)
├── scripts/
│   ├── git-add-work-profile.sh     # Automated script to add new work profiles
│   ├── git-bare-clone              # Bare clone + worktree setup (git subcommand)
│   └── git-bare-init               # Bare init + worktree setup (git subcommand)
├── docs/
│   ├── GIT.md          # Git multi-profile setup guide
│   ├── ALIASES.md      # Complete alias reference
│   ├── VIM.md          # Vim configuration guide
│   └── TMUX.md         # Tmux configuration guide
└── system/
    ├── .alias                  # Alias loader
    ├── .docker-aliases         # Docker shortcuts
    ├── .elixir-aliases         # Elixir/Phoenix commands
    ├── .postgres-aliases       # PostgreSQL management
    └── .general-aliases        # General utilities
```

## Prerequisites

- macOS (tested on Darwin 24.6.0)
- [Oh My Zsh](https://ohmyz.sh/)
- [Spaceship Prompt](https://github.com/spaceship-prompt/spaceship-prompt)
- [Homebrew](https://brew.sh/)
- [asdf](https://asdf-vm.com/) (optional, for version management)
- [NVM](https://github.com/nvm-sh/nvm) (optional, for Node.js)

## Documentation

- [Git Configuration](docs/GIT.md) - Multi-profile git setup and how to add new work configurations
- [Aliases Reference](docs/ALIASES.md) - Complete guide to all available aliases
- [Vim Configuration](docs/VIM.md) - Vim setup and plugin details
- [Tmux Configuration](docs/TMUX.md) - Tmux key bindings and customizations

## Key Configurations

### Zsh

- **Theme**: Spaceship with custom prompt order (time, user, dir, git, exec_time)
- **Plugins**: git, zsh-nvm, zsh-completions, fast-syntax-highlighting
- **PATH Management**: Automatic deduplication of PATH entries

### Vim

- **Plugin Manager**: vim-plug (auto-installs on first run)
- **Theme**: Dracula
- **Key Plugins**: NERDTree, vim-fugitive, vim-javascript

### Tmux

- **Prefix**: Default (`Ctrl+b`)
- **Color Support**: tmux-256color with mouse support
- **Navigation**: Vim-style (`hjkl`) and Alt-arrow keys
- **Splits**: Preserve current working directory

### Git

- **Multi-Profile Support**: Automatically switches git identity based on project directory
- **Profiles**: Work, Personal, and Anonymous configurations
- **SSH Key Management**: Separate SSH keys for different contexts
- **Quick Setup**: Use `git-add-work` command to easily add new work profiles
- **Bare Clone**: Use `git bare-clone <url>` to set up repos with worktree-based workflow
- **Bare Init**: Use `git bare-init` to initialize local directories with worktree layout
- See [Git Configuration Guide](docs/GIT.md) for detailed setup and adding new profiles

## Customization

To customize your setup:

1. Edit `.zshrc` for shell configuration
2. Modify files in `system/` to add/change aliases
3. Update `.vimrc` for Vim plugins and settings
4. Adjust `.tmux.conf` for Tmux preferences

## Recent Updates

- Added `Brewfile` for reproducible machine setup via Homebrew
- Migrated Vim plugin manager from Vundle to vim-plug
- Improved tmux config: mouse support, zero escape-time, path-preserving splits
- Cleaned up `.zshrc`: removed boilerplate, fixed `fpath`/`compinit` ordering, portable paths
- Added default git identity, `pull.rebase=true`, and `init.defaultBranch=main`
- Made `install.sh` idempotent with error handling and auto Vim plugin install
- Modernized Docker aliases to use built-in `docker image prune`
- Added shell history configuration (10,000 entries)

## Contributing

Feel free to fork and customize for your own use!

## License

MIT
