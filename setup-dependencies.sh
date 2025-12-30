#!/bin/bash

# Setup script for installing zsh dependencies
# Run this after install.sh on a new machine

set -e

echo "🚀 Setting up zsh dependencies..."

# Check if oh-my-zsh is installed
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  echo "❌ Oh My Zsh is not installed. Please install it first:"
  echo "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
  exit 1
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"

# Install zsh-nvm plugin
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-nvm" ]; then
  echo "📦 Installing zsh-nvm plugin..."
  git clone https://github.com/lukechilds/zsh-nvm "${ZSH_CUSTOM}/plugins/zsh-nvm"
  echo "✅ zsh-nvm installed"
else
  echo "✓ zsh-nvm already installed"
fi

# Install zsh-completions plugin
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-completions" ]; then
  echo "📦 Installing zsh-completions plugin..."
  git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM}/plugins/zsh-completions"
  echo "✅ zsh-completions installed"
else
  echo "✓ zsh-completions already installed"
fi

# Install Spaceship prompt
if [ ! -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]; then
  echo "📦 Installing Spaceship prompt..."
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt" --depth=1
  ln -sf "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"
  echo "✅ Spaceship prompt installed"
else
  echo "✓ Spaceship prompt already installed"
  # Ensure symlink exists
  if [ ! -L "${ZSH_CUSTOM}/themes/spaceship.zsh-theme" ]; then
    ln -sf "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"
  fi
fi

# Install fast-syntax-highlighting (optional but referenced in .zshrc)
if [ ! -d "${ZSH_CUSTOM}/plugins/fsh" ]; then
  echo "📦 Installing fast-syntax-highlighting..."
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/fsh"
  echo "✅ fast-syntax-highlighting installed"
else
  echo "✓ fast-syntax-highlighting already installed"
fi

echo ""
echo "✨ All dependencies installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. If you see any errors, check that oh-my-zsh is properly installed"
echo ""
