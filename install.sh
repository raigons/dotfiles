export DOTFILES="${HOME}/dotfiles"

cp ${DOTFILES}/.zshrc.example $DOTFILES/.zshrc

ln -fsv ${DOTFILES}/.zshrc ~/.
ln -fsv ${DOTFILES}/config/git/.gitconfig ~/.
ln -fsv ${DOTFILES}/.vimrc ~/.
ln -fsv ${DOTFILES}/.tmux.conf ~/.
