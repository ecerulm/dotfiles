" This is Ruben Laguna's .vimrc file
" vim: ts=2 sts=2 sw=2 foldmethod=marker foldcolumn=3 expandtab

" Pathogen {{{1
" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []
" or alternatively rename the plugin dir from name to name~
"call add(g:pathogen_disabled, 'rainbow_parentheses')
"call add(g:pathogen_disabled, 'csscolor')

call pathogen#infect()
"call pathogen#helptags() " enable this line to autoregenerate the help. To generate the helptags manually use :Helptags

""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION{{{1
"""""""""""""""""""""""""""""""""""""""" 
set nocompatible               " be iMproved
set hidden                     " allow unsaved background buffers
set history=10000
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set laststatus=2
set showmatch                  " show the matching paren or bracket
set hlsearch 
set incsearch
set ignorecase smartcase       " make searches case-sensitive only if they contain upper case characters
set cursorline                 " highlight current line
set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set showtabline=2              " show always the editor tabs
set winwidth=79
set shell=bash
set colorcolumn=+1 " highlight the column after the textwidth http://stackoverflow.com/questions/1919028/how-to-show-vertical-line-to-wrap-the-line-in-vim
"set listchars=tab:▸\ ,eol:$

" Highlight unwanted spaces {{{2
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" http://www.bestofvim.com/tip/trailing-whitespace/
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" match ExtraWhitespace '\s\+$'


" Prevent vim from clobbering the scrollback buffer. {{{2
" See http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=                "
set scrolloff=3                " keep more context when scrolling off the end of a buffer
" store temporary files in central spot {{{2
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.
"}}}
" backspace in insert mode can delete newlines, etc
set backspace=indent,eol,start
set showcmd                    " display incomplete commands

" system clipboard {{{2
if has('unnamedplus') " http://ilessendata.blogspot.se/2012/05/vim-using-system-clipboard.html
  set clipboard=unnamed,unnamedplus
else
  set clipboard=unnamed
endif
"}}}
syntax on                      " enable syntax highlighting
" Enable filetype detection {{{1
" Use the default filetype settings, so that mail gets 'tw' set to 72
" 'cindent'is on in C files, etc. 
" Also load indent files, to automatically do language-dependent indenting
" filetype plugin indent on
filetype on
filetype indent on
filetype plugin on
" use emacs-style tab completion when selecting files, etc
" set wildmode=list:longest
" make tab completion for files/buffers act like zsh
set wildmenu
set wildmode=full

let mapleader=","
set pastetoggle=<f4>


""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS{{{1
""""""""""""""""""""""""""""""""""""""""

augroup vimrcEx " Put them in a group so we delete them easily
  " Clear all autocmd in the group {{{2
  autocmd!

  " Load tabular.vim patterns {{{2
  autocmd VimEnter * call CustomTabularPatterns()

  " Use textwidth 72 for all text files {{{2
  autocmd FileType text setlocal textwidth=72
  
  " Jump to Last cursor position unless its invalid or in an event handler  {{{2
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal g`\"" |
     \ endif
 
  " Indent p tags {{{2 
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Leave the return key alone when in command line windows, {{{2
  " since its used to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()

  "ctags {{{2
  " autocmd BufWritePost * call system("ctags -R")

  "Rainbow parentheses {{{2
   au FileType c,cpp,objc,objcpp call rainbow#load()
augroup END


""""""""""""""""""""""""""""""""""""""""
" COLOR{{{1
""""""""""""""""""""""""""""""""""""""""
:set t_Co=256 " 256 Colors
":set background=dark
":color grb256
:colorscheme molokai
" :colorscheme blackboard


""""""""""""""""""""""""""""""""""""""""
" STATUSLINE{{{1
""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)%{fugitive#statusline()}	" filename filetype git
" :set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%o,%c,%l/%L\ %P


""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS{{{1
""""""""""""""""""""""""""""""""""""""""
" Copy to system clipboard 
map <leader>y "*y 

" Move around splits with <c-hjkl>{{{2
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
" Insert a hashrocket with <c-l>{{{2
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode{{{2
imap <c-c> <esc>
" Clear the search buffer when hitting return{{{2
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
" Delete / remove trailing whitespace{{{2
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
nnoremap <silent> <Leader>rts :call TrimWhiteSpace()<CR>

call MapCR()
nnoremap <leader><leader> <c-^> " Go back to buffer from vim help 
" Indent {{{2
" indent in visual mode{{{3
vmap > >gv
vmap < <gv
vmap <Tab> >gv
vmap <S-Tab> <gv
vmap <D-[> <gv
vmap <D-]> >gv
" indent in normal mode {{{3
nmap <D-[> <<
nmap <D-]> >>

" ctags mappings{{{2
nnoremap <f5> :!ctags -R<CR>

""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY{{{1
" Indent if we're at the beginning of a line. Else, do completion
""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE{{{1
""""""""""""""""""""""""""""""""""""""""
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>


""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE{{{1
""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%


""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE{{{1
""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>


""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET{{{1
""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " : exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()<cr>
:map <leader>p :PromoteToLet<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPS TO JUMP TO SPECIFIC COMMAND-T TARGETS AND FILES{{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>gr :topleft :split config/routes.rb<cr>
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . _ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
map <leader>gR :call ShowRoutes()<cr>
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets/sass<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>gt :CommandTFlush<cr>\|:CommandTTag<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE{{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS{{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Md5 COMMAND{{{1
" Show the MD5 of the current buffer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -range Md5 :echo system('echo '.shellescape(join(getline(<line1>, <line2>), '\n')) . '| md5')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OpenChangedFiles COMMAND{{{1
" Open a split for each dirty file in git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" InsertTime COMMAND{{{1
" Insert the current time
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C-p and C-n behave exactly as up and down arrows {{{1
" in the command history. Which will filter
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <C-n> <Up>
cnoremap <C-p> <Down>

":source $VIMRUNTIME/macros/matchit.vim

" Folding {{{1
set foldcolumn=3
nnoremap <space> za

" Text bubbling {{{1
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

"Visually select the text that was last edited/pasted
nmap gV `[v`]

" Tabular.vim {{{1
function! CustomTabularPatterns() 
  if exists('g:tabular_loaded')
    AddTabularPattern defines /\(\/\/.*\)\@<! \+/l0
  endif
endfunction
:nohlsearch

" Gundo {{{1
nnoremap <F5> :GundoToggle<CR>

