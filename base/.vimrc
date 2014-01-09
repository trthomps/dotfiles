set nowrap
set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set showmatch
set incsearch
set ignorecase
set smartcase
set ruler
set mouse=a
set hidden
set backspace=2
set showcmd

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

execute pathogen#infect()
filetype plugin indent on

syntax on
set background=dark
let g:solarized_termcolors = 256
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized
let g:Powerline_theme='short'
let g:Powerline_colorscheme='solarized256_dark'

let mapleader = ","
map <Leader>n :NERDTreeToggle<CR>

if exists('+colorcolumn')
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

set term=screen-256color
set term=xterm-256color
map <ESC>[8~    <End>
map <ESC>[7~    <Home>
imap <ESC>[8~    <End>  
imap <ESC>[7~    <Home>
