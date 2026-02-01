set nocompatible
set number
set relativenumber
set encoding=utf-8
set backspace=indent,eol,start

" Indentation: use 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Install vim-plug automatically if not present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'wincent/command-t'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'preservim/nerdtree'
Plug 'othree/xml.vim'
Plug 'pangloss/vim-javascript'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

filetype plugin indent on
syntax on
colorscheme dracula

let NERDTreeIgnore=['\.DS_Store$', '\.git$']
nnoremap <C-n> :NERDTreeToggle<CR>
