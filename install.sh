#!/bin/bash
export DOTFILES="${HOME}/dotfiles"
BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Create backup directory if any existing dotfiles found
if [ -f ~/.zshrc ] || [ -f ~/.gitconfig ] || [ -f ~/.vimrc ] || [ -f ~/.tmux.conf ]; then
  echo "📦 Backing up existing dotfiles to ${BACKUP_DIR}"
  mkdir -p "${BACKUP_DIR}"

  [ -f ~/.zshrc ] && cp ~/.zshrc "${BACKUP_DIR}/.zshrc"
  [ -f ~/.gitconfig ] && cp ~/.gitconfig "${BACKUP_DIR}/.gitconfig"
  [ -f ~/.vimrc ] && cp ~/.vimrc "${BACKUP_DIR}/.vimrc"
  [ -f ~/.tmux.conf ] && cp ~/.tmux.conf "${BACKUP_DIR}/.tmux.conf"

  echo "✅ Backup complete!"
fi

# Create .zshrc from example if it doesn't exist
if [ ! -f ${DOTFILES}/.zshrc ]; then
  echo "📝 Creating .zshrc from example..."
  cp ${DOTFILES}/.zshrc.example ${DOTFILES}/.zshrc
fi

# Symlink dotfiles
echo "🔗 Creating symlinks..."
ln -fsv ${DOTFILES}/.zshrc ~/.
ln -fsv ${DOTFILES}/config/git/.gitconfig ~/.
ln -fsv ${DOTFILES}/.vimrc ~/.
ln -fsv ${DOTFILES}/.tmux.conf ~/.

echo "✨ Installation complete!"
