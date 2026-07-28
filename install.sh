#!/bin/bash
set -e

export DOTFILES="${HOME}/dotfiles"
BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Skip backup if symlinks already point to our dotfiles
if [ -L ~/.zshrc ] && [ "$(readlink ~/.zshrc)" = "${DOTFILES}/.zshrc" ]; then
  echo "Symlinks already set up, skipping backup."
# Create backup directory if any existing dotfiles found
elif [ -f ~/.zshrc ] || [ -f ~/.gitconfig ] || [ -f ~/.gitconfig-work ] || [ -f ~/.gitconfig-personal ] || [ -f ~/.gitconfig-anonymous ] || [ -f ~/.vimrc ] || [ -f ~/.tmux.conf ]; then
  echo "📦 Backing up existing dotfiles to ${BACKUP_DIR}"
  mkdir -p "${BACKUP_DIR}"

  [ -f ~/.zshrc ] && cp ~/.zshrc "${BACKUP_DIR}/.zshrc"
  [ -f ~/.gitconfig ] && cp ~/.gitconfig "${BACKUP_DIR}/.gitconfig"
  [ -f ~/.gitconfig-work ] && cp ~/.gitconfig-work "${BACKUP_DIR}/.gitconfig-work"
  [ -f ~/.gitconfig-personal ] && cp ~/.gitconfig-personal "${BACKUP_DIR}/.gitconfig-personal"
  [ -f ~/.gitconfig-anonymous ] && cp ~/.gitconfig-anonymous "${BACKUP_DIR}/.gitconfig-anonymous"
  [ -f ~/.vimrc ] && cp ~/.vimrc "${BACKUP_DIR}/.vimrc"
  [ -f ~/.tmux.conf ] && cp ~/.tmux.conf "${BACKUP_DIR}/.tmux.conf"

  echo "✅ Backup complete!"
fi

# Create .zshrc from example if it doesn't exist
if [ ! -f "${DOTFILES}/.zshrc" ]; then
  echo "📝 Creating .zshrc from example..."
  cp "${DOTFILES}/.zshrc.example" "${DOTFILES}/.zshrc"
fi

# Symlink dotfiles
echo "🔗 Creating symlinks..."
ln -fsv "${DOTFILES}/.zshrc" ~/.
ln -fsv "${DOTFILES}/config/git/.gitconfig" ~/.
ln -fsv "${DOTFILES}/config/git/.gitconfig-work" ~/.
ln -fsv "${DOTFILES}/config/git/.gitconfig-personal" ~/.
ln -fsv "${DOTFILES}/config/git/.gitconfig-anonymous" ~/.
ln -fsv "${DOTFILES}/.vimrc" ~/.
ln -fsv "${DOTFILES}/.tmux.conf" ~/.

# Git custom subcommands
echo "🔧 Setting up git subcommands..."
mkdir -p ~/bin
ln -fsv "${DOTFILES}/scripts/git-bare-clone" ~/bin/git-bare-clone
ln -fsv "${DOTFILES}/scripts/git-bare-init" ~/bin/git-bare-init

# Homebrew
echo "🍺 Setting up Homebrew..."
if ! command -v brew &> /dev/null; then
  echo "  Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # A fresh install isn't on PATH yet — load it for the rest of this script
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [ -x /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"
else
  echo "  Homebrew already installed ($(brew --version | head -1))"
fi

# Tap third-party repos up front. `brew bundle` buffers output per entry, so a
# tap trust prompt fired from inside it looks like a hang with no way to answer.
echo "🔑 Adding third-party taps..."
brew tap snyk/tap

echo "📦 Installing Brewfile packages..."
if ! brew bundle --file="${DOTFILES}/Brewfile"; then
  echo "⚠️  Some Brewfile entries failed — VS Code extensions are the usual culprit."
  echo "   Re-run to see per-entry output: brew bundle --file=\"${DOTFILES}/Brewfile\" --verbose"
fi

# Claude Code
echo "🤖 Setting up Claude Code..."
mkdir -p ~/.claude
ln -fsv "${DOTFILES}/config/claude/CLAUDE.md" ~/.claude/CLAUDE.md
if ! command -v claude &> /dev/null; then
  echo "  Installing Claude Code CLI..."
  curl -fsSL https://cli.anthropic.com/install.sh | sh
else
  echo "  Claude Code CLI already installed ($(claude --version 2>/dev/null))"
fi

# Install Vim plugins
echo "🔌 Installing Vim plugins..."
vim -es -u "${DOTFILES}/.vimrc" -i NONE -c "PlugInstall --sync" -c "qa" 2>/dev/null || true

echo "✨ Installation complete!"
