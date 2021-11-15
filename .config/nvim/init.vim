set nocompatible
filetype on
filetype plugin on
filetype indent on

call plug#begin('~/.vim/plugged')

Plug 'chrisbra/Colorizer'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'dag/vim-fish'

call plug#end()

syntax on

set number

set incsearch
set showmode
set showmatch
set hlsearch
set history=200
set shiftwidth=4
set tabstop=4
set expandtab
set backspace=indent,eol,start

set ignorecase
set smartcase

set autoindent

set nostartofline
set ruler

inoremap jj <esc>
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

set showcmd
set termguicolors

set wildmenu
set wildmode=list:longest

set laststatus=2

let g:colorizer_auto_color = 1
lua << END
require'nvim-tree'.setup()
require'lualine'.setup{
    options = {theme = 'powerline'}
}
END

