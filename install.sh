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

# Install Vim plugins
echo "🔌 Installing Vim plugins..."
vim -es -u "${DOTFILES}/.vimrc" -i NONE -c "PlugInstall --sync" -c "qa" 2>/dev/null || true

echo "✨ Installation complete!"
