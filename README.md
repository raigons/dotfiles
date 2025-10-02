# Dotfiles

A clean and modular dotfiles configuration for macOS development, optimized for Elixir, Docker, and PostgreSQL workflows.

## Features

- **Zsh Configuration** - Spaceship prompt theme with custom configurations
- **Vim Setup** - Vundle-based plugin management with NERDTree and syntax highlighting
- **Tmux Configuration** - Vim-style navigation and custom key bindings
- **Modular Aliases** - Organized by domain (Docker, Elixir, PostgreSQL, General)
- **PATH Deduplication** - Automatic cleanup of redundant PATH entries
- **Git Configuration** - Ready-to-use Git settings

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# Run the installation script
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The installation script will:
- Backup your existing dotfiles to `~/.dotfiles_backup_TIMESTAMP`
- Create `.zshrc` from the example template
- Symlink all configuration files to your home directory

## Structure

```
dotfiles/
├── .zshrc              # Main Zsh configuration
├── .zshrc.example      # Template for fresh installations
├── .vimrc              # Vim configuration
├── .tmux.conf          # Tmux configuration
├── install.sh          # Installation script
├── config/
│   └── git/
│       └── .gitconfig  # Git configuration
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

- [Aliases Reference](docs/ALIASES.md) - Complete guide to all available aliases
- [Vim Configuration](docs/VIM.md) - Vim setup and plugin details
- [Tmux Configuration](docs/TMUX.md) - Tmux key bindings and customizations

## Key Configurations

### Zsh

- **Theme**: Spaceship with custom prompt order (time, user, dir, git, exec_time)
- **Plugins**: git, zsh-nvm, zsh-completions, fast-syntax-highlighting
- **PATH Management**: Automatic deduplication of PATH entries

### Vim

- **Plugin Manager**: Vundle
- **Theme**: Dracula
- **Key Plugins**: NERDTree, vim-fugitive, vim-javascript

### Tmux

- **Prefix**: Default (`Ctrl+b`)
- **Color Support**: 256-color terminal
- **Navigation**: Vim-style (`hjkl`) and Alt-arrow keys

## Customization

To customize your setup:

1. Edit `.zshrc` for shell configuration
2. Modify files in `system/` to add/change aliases
3. Update `.vimrc` for Vim plugins and settings
4. Adjust `.tmux.conf` for Tmux preferences

## Recent Updates

- Added PATH deduplication to remove redundant entries
- Synchronized `.zshrc.example` with latest improvements
- Refactored dotfiles configuration and fixed critical bugs
- Enhanced alias organization

## Contributing

Feel free to fork and customize for your own use!

## License

MIT
