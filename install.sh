export DOTFILES="${HOME}/dotfiles"

cp .zshrc.example .zshrc

ln -fsv ${DOTFILES}/.zshrc ~/.
ln -fsv ${DOTFILES}/config/git/.gitconfig ~/.
ln -fsv ${DOTFILES}/.vimrc ~/.
ln -fsv ${DOTFILES}/.tmux.conf ~/.
