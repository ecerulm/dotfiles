" This is Ruben Laguna's .vimrc file
" vim: ts=2 sts=2 sw=2 foldmethod=marker foldlevel=0 foldcolumn=3 expandtab :

" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" My Plugins {{{
" Plugin 'compactcode/alternate.vim'
" Plugin 'compactcode/open.vim'
" Plugin 'scrooloose/nerdtree'
" Plugin 'tpope/vim-obsession' " Autosave Session.vim
" Plugin 'tpope/vim-projectionist' " alternate files, 
" Plugin 'tpope/vim-repeat' " Make command repeatble
" Plugin 'tpope/vim-sleuth'      " No need to set indenting, ts, etc per ftype
Plugin 'SirVer/ultisnips'  " snippet manager like SnipMate
" Plugin 'Shougo/unite.vim'
Plugin 'alfredodeza/pytest.vim'
Plugin 'godlygeek/tabular' " align text 
Plugin 'kana/vim-textobj-fold'
Plugin 'kana/vim-textobj-user' " helper to create your own textobj
Plugin 'kien/ctrlp.vim'
Plugin 'klen/python-mode'
Plugin 'mileszs/ack.vim'
Plugin 'oblitum/rainbow'   " rainbow parens
Plugin 'sjl/gundo.vim'
Plugin 'tommcdo/vim-exchange' " exchange regions of txt
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-commentary'  " comment code
Plugin 'tpope/vim-fugitive'    " git interface
Plugin 'tpope/vim-git'         " syntax for gitcommit, gitconfig, etc
Plugin 'tpope/vim-speeddating' " Increment dates with <C-a> <C-x>
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-ruby/vim-ruby'
Plugin 'argtextobj.vim'
Plugin 'camelcasemotion'
" }}} MyPlugins

" Plugin Examples {{{
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
" }}} Plugin Examples

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help {{{
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" }}} Brief help
" }}} Vundle

" vim :options {{{

"  1 important {{{
set nocompatible               " be iMproved
set pastetoggle=<f4>
"  1 important }}}
"  2 moving around, searching and patterns {{{
set incsearch
set ignorecase " make searches case-sensitive only if they contain upper case characters
set smartcase
"  2 moving around, searching and patterns }}}
"  3 tags {{{
"  3 tags }}}
"  4 displaying text {{{
set cmdheight=2
set numberwidth=5
"set listchars=tab:▸\ ,eol:$
" No restore screen on vim exit {{{
set t_ti= t_te=                " :help norestorescreen See http://www.shallowsky.com/linux/noaltscreen.html
"  No retsore screen on vim exit }}}
" Prevent vim from clobbering the scrollback buffer. {{{
set scrolloff=3                " keep more context when scrolling off the end of a buffer
" Prevent vim from clobbering the scrollback buffer. }}}
"  4 displaying text }}}
"  5 syntax, highlighting and spelling {{{
set hlsearch 
set cursorline                 " highlight current line
set colorcolumn=+1 " highlight the column after the textwidth http://stackoverflow.com/questions/1919028/how-to-show-vertical-line-to-wrap-the-line-in-vim
" set spell " could be annoying when editing code
set spelllang=en_us
syntax on                      " enable syntax highlighting

" Enable filetype detection {{{
" Use the default filetype settings, so that mail gets 'tw' set to 72
" 'cindent'is on in C files, etc. 
" Also load indent files, to automatically do language-dependent indenting
" filetype plugin indent on
filetype on
filetype indent on
filetype plugin on
" }}} Enable filetype detection
" COLOR{{{
if &term == "xterm-256color"  
  :set t_Co=256 " 256 Colors
  :colorscheme molokai
endif
  ":set background=dark
  ":color grb256
  " :colorscheme blackboard
" }}} COLOR
" }}} 5 syntax, highlighting and spelling
"  6 multiple windows {{{
set hidden                     " allow unsaved background buffers
set winwidth=79
" switching between buffers {{{
" for quickfix commands, and I suspect that Ctrl-P is also affected
" useopen, jump to first open window that already has that buffer
set switchbuf=useopen 
" switching between buffers }}}
" STATUSLINE{{{
set laststatus=2 " status always visible
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)%{fugitive#statusline()}	" filename filetype git
" :set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%o,%c,%l/%L\ %P
" }}} STATUSLINE
" }}} 6 multiple windows
"  7 multiple tab pages {{{
set showtabline=2              " show always the editor tabs
"  }}}
"  8 terminal {{{
"  }}}
"  9 using the mouse {{{
"  }}}
" 10 GUI {{{
"  }}}
" 11 printing {{{
"  }}}
" 12 messages and info {{{
set showcmd                    " display incomplete commands
"  }}}
" 13 selecting text {{{
" system clipboard {{{
if has('macunix')
  set clipboard=unnamedplus,unnamed
elseif has('autoselectplus') " http://ilessendata.blogspot.se/2012/05/vim-using-system-clipboard.html
  "set clipboard=unnamed,unnamedplus
  set clipboard=autoselectplus,autoselect
endif
" }}} system clipboard
" }}} 13 selecting text
" 14 editing text {{{
set showmatch                  " show the matching paren or bracket
set backspace=indent,eol,start " :help 'backspace' allow backspacing over autoindent, over line breaks (join lines) and over the start of insert

" }}} 15 editing text
" 15 tabs and indenting {{{
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
" }}} 15 tabs and indenting
" 16 folding {{{
set foldcolumn=3
set foldlevelstart=1
"  }}}
" 17 diff mode {{{
"  }}}
" 18 mapping {{{
let mapleader=","
" }}} 18 mapping
" 19 reading and writing files {{{
set modeline
set modelines=5
" store temporary files in central spot
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.
" }}} 19 reading and writing files 
" 20 the swap file {{{
" }}}
" 21 command line editing {{{
set history=10000
" use emacs-style tab completion when selecting files, etc
" set wildmode=list:longest
" make tab completion for files/buffers act like zsh
set wildmenu
set wildmode=full
" }}} 21 command line editing
" 22 executing external commands {{{
set shell=bash
"  }}}
" 23 running make and jumping to errors {{{
"  }}}
" 24 language specific {{{
"  }}}
" 25 multi-byte characters {{{
"  }}}
" 26 various {{{
" Load per project .vimrc
set exrc " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files
" }}} 26 various

" }}} vim :options

" CUSTOM AUTOCMDS{{{1
""""""""""""""""""""""""""""""""""""""""

augroup vimrcEx " Put them in a group so we delete them easily
  " Clear all autocmd in the group {{{2
  autocmd!

  " Load tabular.vim patterns {{{2
  " afer all vim startup
  autocmd VimEnter * call CustomTabularPatterns()

  " Use textwidth 72 for all text files {{{2
  autocmd FileType text setlocal textwidth=72
  
  " Jump to Last cursor position unless its invalid or in an event handler  {{{2
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal g`\"" |
     \ endif
 
  " Indent p tags {{{2 
  "autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Leave the return key alone when in command line windows, {{{2
  " since its used to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()

  "ctags {{{2
  " autocmd BufWritePost * call system("ctags -R")

  " New file templates {{{2
  :au BufNewFile Makefile r ~/.vim/skeleton.Makefile

  "Rainbow parentheses {{{2
   au FileType c,cpp,objc,objcpp,ruby,python call rainbow#load()

  "fugitive autoclose //1 //2 //3{{{2
  autocmd BufReadPost fugitive://* set bufhidden=delete
  " cursor in right position in git COMMIT_EDITMSG{{{2
  autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0,1,1,0])

  "Unfold on open {{{2
  " Not clear what is the right autocmd event to use BufRead BufWinEnter
  " autocmd BufWinEnter * normal zR "It doesn work
  " autocmd BufWinEnter * silent! :%foldopen! "Complains about fold not found
  " autocmd BufRead * silent! :%foldopen! "Complains about fold not found
  " autocmd BufReadPost * set foldlevel=99
augroup END


""""""""""""""""""""""""""""""""""""""""

" }}}1 CUSTOM AUTOCOMMANDS
" MISC KEY MAPS{{{1
" Copy to system clipboard 
map <leader>y "*y 

" Move around splits with <c-hjkl>{{{2
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
" Insert a hashrocket with <c-l>{{{2
inoremap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode{{{2
" the double <esc> avoid waiting timeoutlen ms (in case there is a Esc
" mapping)
imap <c-c> <esc><esc>
" Clear the search buffer when hitting return{{{2
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
" Delete / remove trailing whitespace{{{2
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
nnoremap <silent> <Leader>rts :call TrimWhiteSpace()<CR>

" Indent {{{2
" indent in visual mode{{{3
vmap > >gv
vmap < <gv
vmap <Tab> >gv
vmap <S-Tab> <gv
" <D-...> are Macintosh Command Key mappings see :help keycodes
vmap <D-[> <gv
vmap <D-]> >gv
" indent in normal mode {{{3
nmap <D-[> <<
nmap <D-]> >>

" ctags mappings{{{2
nnoremap <unique> <f5> :!ctags -R<CR>

" gp to select last pasted text using the same visual mode {{{2
"Visually select the text that was last edited/pasted
" nnoremap gp '[v']
" nmap gV `[v`]
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

""""""""""""""""""""""""""""""""""""""""
" disable arrow keys use hjkl {{{2
""""""""""""""""""""""""""""""""""""""""
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>
" }}}2 disable arrow keys use hjkl
" open files in directory of current file{{{2
""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
" }}}2 open files in directory of current file
" InsertTime COMMAND and mappings <F5>{{{2
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>
function! s:Timestr()
  return '%F %T %Z'
endfunction

"nnoremap <F5> i<C-R>=strftime(<SID>Timestr())<cr><esc>
" inoremap <unique> <F5> <C-R>=strftime(<SID>Timestr())<cr>
iab <expr> dts strftime(<SID>Timestr())
" }}}2 InsertTime COMMAND and mappings <F5>
" C-p and C-n for command history{{{2
" C-p and C-n behave exactly as up and down arrows
" in the command history. Which will filter
cnoremap <C-n> <Up>
cnoremap <C-p> <Down>
" }}}2  C-p and C-n for command history
" Folding {{{2
" toggle open/close fold with <space>
nnoremap <space> za

" Refocus folds 
nnoremap ,z zMzvzz
" }}}2 Folding
" Text bubbling <C-Up> <C-Down> {{{2
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv
" }}}2 Text bubbling
" Gundo {{{2
nnoremap  <unique> <f6> :GundoToggle<CR>

"OmniCompletion{{{2
"<C-Space> is misinterpreted by the terminal as <C-@> :help CTRL-@
"inoremap <C-Space> <C-x><C-o>
"inoremap <C-@> <C-Space>
inoremap <leader>, <C-X><C-O>
" <C-j> Finish line with semicolon ; {{{2
imap <C-j> <End>;<cr>
" Find Alternates <Leader>a {{{2
" Uses the alternate.vim and open.vim plugins 
" Finds the test alternates
" map <C-^> :Open(alternate#FindAlternate())<cr>
map <Leader>a :Open(alternate#FindAlternate())<cr>
" Pytest <Leader>f and <Leader>p {{{2
nnoremap <unique><silent><Leader>f <Esc>:Pytest file<cr>
nnoremap <unique><silent><Leader>p <Esc>:Pytest project verbose<cr>

" Autoclose{{{2
nmap <unique> <Leader>x <Plug>ToggleAutoCloseMappings
let g:autoclose_on = 0 " disabled by default 
" Autocenter after search {{{2
nnoremap n nzz
" CamelCaseMotion {{{2
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
" }}}1 MISC KEY MAPS
" Tabular.vim {{{1
" help tabular
function! CustomTabularPatterns() 
  if exists('g:tabular_loaded')
    AddTabularPattern defines /\(\/\/.*\)\@<! \+/l0
  endif
endfunction
:nohlsearch
" }}}1 Tabular.vim
" Pymode {{{1
let g:Pymode_lint_on_fly = 1
let g:pymode_lint = 1
let g:pymode_lint_cwindow = 0
let g:pymode_lint_message = 1
let g:pymode_lint_on_write = 1
let g:pymode_lint_unmodified = 1
let g:pymode_rope_autoimport = 1
let g:pymode_rope_autoimport_modules = ['os', 'shutil', 'datetime']
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion = 1
let g:pymode_rope_completion_bind = '<C-Space>'
" }}}1 Pymode
" Learn vimscript the hard way {{{1
" this mapping is useful for typing constants
" just type lowercase and at the end press <c-u>
inoremap <c-u> <Esc>viwUea
nnoremap <c-u> gUiw
" }}}1 Learn vimscript the hard way
