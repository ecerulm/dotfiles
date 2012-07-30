set nocompatible               " be iMproved
call pathogen#infect()
filetype plugin indent on

syntax enable
set laststatus=2
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%o,%c,%l/%L\ %P
set background=dark
let g:solarized_termcolors=256
"colorscheme solarized
"colorscheme vividchalk
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
compiler ruby         " Enable compiler support for ruby
let mapleader = ","
nnoremap <leader><leader> <c-^>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=5
set winminheight=5
set winheight=999


" Open files with <leader>f
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
" Open files, limited to the directory of the current file, with <leader>gf
" This requires the %% mapping found below.
map <leader>gf :CommandTFlush<cr>\|:CommandT %%<cr>

map <leader>gg :topleft 100 :split Gemfile<cr>

" Indent in visual mode
vmap > >gv 
vmap < <gv
vmap <Tab> >gv
vmap <S-Tab> <gv

" Tab for autocompletion in insert mode
imap <Tab> <C-N>
imap <S-Tab> <C-P>

set hlsearch 
set incsearch
set number

set wildmode=list:longest
set scrolloff=3

autocmd FileType ruby setlocal foldmethod=syntax foldcolumn=1 shiftwidth=2 tabstop=2 softtabstop=2 expandtab

nnoremap ; :
cabbr <expr> %% expand('%:p:h')
