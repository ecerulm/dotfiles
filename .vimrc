" This is Ruben Laguna's .vimrc file
" vim: ts=2 sts=2 sw=2 foldmethod=marker foldlevel=0 foldcolumn=3 expandtab :

source ~/.vim/vundle.vim
runtime! ftplugin/man.vim

" vim :options {{{

"  1 important {{{
set nocompatible               " be iMproved
set pastetoggle=<f4>
"  1 important }}}
"  2 moving around, searching and patterns {{{
set ignorecase " make searches case-sensitive only if they contain upper case characters
set smartcase  " override the ignorecase option if searching for uppercase chars
"  2 moving around, searching and patterns }}}
"  3 tags {{{
set tags+=~/.vim/systags
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
hi ColorColumn ctermbg=lightgrey
" set spell " could be annoying when editing code
set spelllang=en_us

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
if has('gui_running')
  set background=light
else
  set background=dark
end

" if &term == "xterm-256color" || $COLORTERM == "gnome-terminal"
"   set t_Co=256 " 256 Colors
" endif
set t_ut= " http://sunaku.github.io/vim-256color-bce.html bce background color erase
colorscheme molokai

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
"  }}}
" 13 selecting text {{{
" system clipboard {{{
" http://vimcasts.org/episodes/accessing-the-system-clipboard-from-vim/
" http://ilessendata.blogspot.se/2012/05/vim-using-system-clipboard.html
if has('unnamedplus') 
  " autoselect copy visual selection to "* (no need to yank)
  " autoselectplus copy VISUAL selection to "+ (no need to yank)
  " unnamed  will use "* as target for yank, delete, etc
  " unnamedplus will use "+ as target for yank, delete, etc
  " set clipboard=autoselect,unnamed
  set clipboard=autoselectplus,unnamedplus
endif
" }}} system clipboard
" }}} 13 selecting text
" 14 editing text {{{
set showmatch                  " show the matching paren or bracket
set complete+=k~/.vim/keywords.txt  " Add extra completions
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
" let mapleader=","
" }}} 18 mapping
" 19 reading and writing files {{{
set modeline
set modelines=5
" store temporary files in central spot
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.
set autoread  " automatically reload files modified outside of vim
" }}} 19 reading and writing files 
" 20 the swap file {{{
" }}}
" 21 command line editing {{{
set history=10000

" use emacs-style tab completion when selecting files, etc
" set wildmode=list:longest
" make tab completion for files/buffers act like zsh
set wildmode=full

set undofile
set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.
" }}} 21 command line editing
" 22 executing external commands {{{
set shell=/bin/bash
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
augroup vimrcEx " Put them in a group so we delete them easily
  " Clear all autocmd in the group {{{2
  autocmd!

  " Use textwidth 72 for all text files {{{2
  autocmd FileType text,rst setlocal textwidth=72
  
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
  :au BufNewFile setup.py r ~/.vim/skeleton.setup.py

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

  " unite_settings for unite buffers {{{2
  autocmd FileType unite call s:unite_settings() " apply setting to unite buffers
  " hook after plugin are loaded {{{2
  au VimEnter * call ConfigAfterPluginLoaded()
augroup END


""""""""""""""""""""""""""""""""""""""""

" }}}1 CUSTOM AUTOCOMMANDS
" MISC KEY MAPPINGS{{{1
" Copy to system clipboard {{{2 
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
  nnoremap <silent> <cr> :nohlsearch\|:redraw!<cr>
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
" nnoremap <space> za

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
" <C-j> or ;; Finish line with semicolon ; {{{2
imap <C-j> <End>;<cr>
nnoremap ;; m`A;<Esc>``
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
" nnoremap n nzMzvzz
" CamelCaseMotion {{{2
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
" Tagbar <f8>
nnoremap <f8> :TagbarToggle<CR>
" }}}1 MISC KEY MAPS
" Pymode {{{1
let g:Pymode_lint_on_fly             = 1
let g:pymode_lint                    = 1
let g:pymode_lint_checkers           = [ 'pep8'] " :h 'g:pymode_lint_checkers'
let g:pymode_lint_cwindow            = 0  " Don't autoopen quickfix window
let g:pymode_lint_message            = 1
let g:pymode_lint_on_write           = 1
let g:pymode_lint_unmodified         = 1
let g:pymode_rope_autoimport         = 1
let g:pymode_rope_autoimport_modules = ['os', 'shutil', 'datetime']
let g:pymode_rope_complete_on_dot    = 0
let g:pymode_rope_completion         = 1
let g:pymode_rope_completion_bind    = '<C-Space>'
let g:pymode_folding                 = 1
let g:pymode_motion                  = 1
let g:pymode_run                     = 0
let g:pymode_doc                     = 1
let g:pymode_doc_bind                = 'K'
" }}}1 Pymode
" vim-cycle plugin configuration {{{
let g:cycle_no_mappings = 1
nmap  -     <Plug>CycleNext

" }}} vim-cycle plugin configuration
" Easy Align plugin configuration {{{
    " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
    vmap <Enter> <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
    " nmap <Leader>a <Plug>(EasyAlign)
" }}} Easy Align pluign configuration
" vim airline configuration {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 0
" }}} vim airline configuration
" EasyMotion configuration {{{
" http://code.tutsplus.com/tutorials/vim-essential-plugin-easymotion--net-19223
" :h easymotion-default-mappings
"map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion the mappings are the typical w,f,b,e, etc but preceded by <Leader><Leader>
" }}} EasyMotion configuration
" :H to open help in current window {{{
command! -nargs=1 -complete=help H :tabnew | :set buftype=help | :h <args>
" }}} :H to open help in current window
" unite.vim mappings {{{

let g:unite_source_history_yank_enable = 1
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --smart-case'
let g:unite_source_grep_recursive_opt = ''
" Using ag as recursive command.
let g:unite_source_rec_async_command =
          \ 'ag --follow --nocolor --nogroup --hidden -g ""'
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <C-p> :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
" nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
" nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<cr>
nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline -start-insert -auto-preview outline<cr>
nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=tag     -start-insert tag<cr>
nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
nnoremap <leader>e :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>
nnoremap <leader>g :<C-u>Unite -no-split -buffer-name=ag  grep:.<cr>
nnoremap <silent> <leader>o  :<C-u>Unite outline<CR>

" Custom mappings for the unite buffer
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <buffer> <C-r>   <Plug>(unite_redraw)
endfunction
" }}} unite.vim mappings
" jk to get of insert mode {{{
inoremap jk <Esc>
" jk to get of insert mode }}}
" Easy edit vimrc {{{
nnoremap <leader>ev :tabedit $MYVIMRC<cr>
nnoremap <leader>sv :so $MYVIMRC<cr>
" }}}
" tagbar <f8> {{{
nnoremap <f8> :TagbarToggle<cr>
" }}} tagbar <f8>
" Uppercase in insert mode with <C-u> {{{
" this mapping is useful for typing constants
" just type lowercase and at the end press <c-u>
inoremap <C-u> <Esc>viw~ea
" }}}
" <CR to break undo sequence {{{
" <c-]> i_CTRL-] Trigger abbreviation without inserting a character
" <C-G>u i_CTRL-G_u break undo sequence
inoremap <CR> <C-]><C-G>u<CR>
" }}}
" gitgutter {{{
" let g:gitgutter_sign_added = 'xx'
" let g:gitgutter_sign_modified = 'yy'
" let g:gitgutter_sign_removed = 'zz'
" let g:gitgutter_sign_modified_removed = 'ww'

" }}}
" vim-tabber {{{
set tabline=%!tabber#TabLine()
let g:tabber_wrap_when_shifting = 1
" }}}
" Learn vimscript the hard way {{{1
" }}}1 Learn vimscript the hard way
function! AddCurrentWordToKeywords()
  let currentWord = expand("<cword>")
  let keywordsFile = expand("~/.vim/keywords.txt")
  call writefile(readfile(keywordsFile)+[ currentWord ],keywordsFile)
endfunction
command AddToKeywords call AddCurrentWordToKeywords()

" Neocomplete {{{
source ~/.vim/neocomplete.vim
" }}}

" Configuration to run after all plugins are loaded {{{ 
function! ConfigAfterPluginLoaded()
  " vim-cycle groups {{{
  call AddCycleGroup('python', ['True', 'False'])
  call AddCycleGroup('python', ['if', 'while'])
  call AddCycleGroup('python', ['==', '!=', '<=', '>='])
  call AddCycleGroup('python', ['assertEqual', 'assertNotEqual'])
  call AddCycleGroup('python', ['assertTrue', 'assertFalse'])
  call AddCycleGroup('python', ['assertIs', 'assertIsNot'])
  call AddCycleGroup('python', ['assertIsNone', 'assertIsNotNone'])
  call AddCycleGroup('python', ['assertIn', 'assertNotIn'])
  call AddCycleGroup('python', ['assertIsInstance', 'assertNotIsInstance'])
  call AddCycleGroup('python', ['assert_has_calls', 'assert_any_call', 'assert_called_with', 'assert_called_once_with'])
  call AddCycleGroup('python', ['called', 'call_count'])
  call AddCycleGroup('python', ['return_value', 'side_effect'])
  call AddCycleGroup('python', ['call_args', 'call_args_list'])
  call AddCycleGroup('python', ['method_calls', 'mock_calls'])
  " }}} vim-cycle groups
  " Uppercase in insert mode with <C-u> {{{
  inoremap <C-u> <Esc>viw~ea
  " }}}
  " abolish {{{
  :Abolish iwth with
  :Abolish teh the
  :Abolish usmt must 
  :Abolish configuraito{n,ns} configuratio{}
  :Abolish itś it's
  :Abolish thatś that's
  :Abolish bojec{t,ts} objec{}
  :Abolish aslo also
  :Abolish simpel simple
  :Abolish virutal virtual
  " }}}
endfunction
" }}} Configuration to run after all plugins are loaded
