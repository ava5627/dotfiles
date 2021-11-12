set nocompatible
filetype on
filetype plugin on
filetype indent on

call plug#begin('~/.vim/plugged')

Plug 'chrisbra/Colorizer'

call plug#end()

syntax on

set number

set incsearch
set showmode
set showmatch
set hlsearch
set history=200

set backspace=indent,eol,start

set ignorecase
set smartcase

set autoindent

set nostartofline
set ruler

set showcmd

set wildmenu
set wildmode=list:longest

set laststatus=2

let g:colorizer_auto_color = 1

inoremap jj <esc>

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
