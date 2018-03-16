" This is Ruben Laguna's .vimrc file
" vim: ts=2 sts=2 sw=2 foldmethod=marker foldlevel=0 foldcolumn=3 expandtab :


" this file works for both vim and neovim

" if !has('nvim')
"   " set ttymouse=xterm2
"   source ~/.vim/vundle.vim
" endif

" Plugin Manager (vim-plug) , moving the vundle.vim configuration to vim-plug
" Plugins are at the end of this file


" About <Plug> see :h <PLug> and :h <SID> and :h usign-<Plug>


set nocompatible               " be iMproved
set pastetoggle=<f4>
set ignorecase " make searches case-sensitive only if they contain upper case characters
set smartcase  " override the ignorecase option if searching for uppercase chars
set infercase  " for insert mode completion
set tags+=~/.vim/systags
set cmdheight=2
set numberwidth=5
set scrolloff=3                " keep more context when scrolling off the end of a buffer
set sidescroll=1
set nowrap
set breakindent
set breakindentopt=sbr
let &showbreak="\u21aa "
set hlsearch
set cursorline                 " highlight current line
set cursorcolumn                 " highlight current column
set colorcolumn=+1 " highlight the column after the textwidth http://stackoverflow.com/questions/1919028/how-to-show-vertical-line-to-wrap-the-line-in-vim
hi ColorColumn ctermbg=lightgrey

" I think we can delete this line. I cannot find man.vim  must be an old thing
" runtime! ftplugin/man.vim " search for ftplugin/man.vim in the runtimepath and execute it

" set t_ti= t_te=                " :help norestorescreen See http://www.shallowsky.com/linux/noaltscreen.html
" set listchars=tab:▸\ ,eol:$

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

let g:rehash256 = 1
let g:molokai_original = 1
" colorscheme molokai
" colorscheme gruvbox

" }}} COLOR


set hidden                     " allow unsaved background buffers
set winwidth=79

" switching between buffers {{{
" for quickfix commands, and I suspect that Ctrl-P is also affected
" useopen, jump to first open window that already has that buffer
set switchbuf=useopen
" switching between buffers }}}

set showtabline=2              " show always the editor tabs


" system clipboard {{{
" http://vimcasts.org/episodes/accessing-the-system-clipboard-from-vim/
" http://ilessendata.blogspot.se/2012/05/vim-using-system-clipboard.html
if has('clipboard')
  set clipboard=unnamed " copy to the system clipboard

  if has('unnamedplus') "  Only available if +X11 is enabled so make sure to compile with X11 support
    " autoselect copy visual selection to "* (no need to yank)
    " autoselectplus copy VISUAL selection to "+ (no need to yank)
    " unnamed  will use "* as target for yank, delete, etc
    " unnamedplus will use "+ as target for yank, delete, etc
    " set clipboard=autoselect,unnamed
    " set clipboard=autoselectplus,unnamedplus
    set clipboard+=unnamedplus
  endif
endif
" }}} system clipboard

set showmatch                  " show the matching paren or bracket
set complete+=k~/.vim/keywords.txt  " Add extra completions


" 15 tabs and indenting {{{
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
" }}} tabs and indenting

" folding {{{
set foldcolumn=3
set foldlevelstart=1
set foldnestmax=1
"  }}}


let mapleader=","


set modeline
set modelines=5


set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.
set autoread  " automatically reload files modified outside of vim

set history=10000


" make tab completion for files/buffers act like zsh
set wildmode=full
set wildignore=*.o,*.obj,*.pyc " stuff to ignore when tab completing
set wildignore+=.git
set wildignore+=__pycache__

" set wildmode=list:longest use emacs-style tab completion when selecting files, etc

set undofile
set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp,.

set shell=/bin/bash


set exrc " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files

set ttyfast
set lazyredraw
set diffopt+=vertical




" CUSTOM AUTOCMDS{{{1
augroup vimrcEx " Put them in a group so we delete them easily
  " Clear all autocmd in the group
  autocmd!

  autocmd BufReadPost pom.xml set filetype=xml.pom
  autocmd BufReadPost build.gradle,setting.gradle set filetype=groovy.gradle
  autocmd BufReadPost *Spec.groovy set filetype=groovy.spock
  autocmd FileType text,rst setlocal textwidth=72
  autocmd BufReadPost .Rprofile set filetype=r
  " autoformat XML on save
  autocmd FileType xml exe ":silent %!xmllint  --format --recover - 2>/dev/null"

  " Jump to Last cursor position unless its invalid or in an event handler
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

  " Nvim-R add rtags
  au FileType r set tags+=rtags,~/.cache/Nvim-R/Rtags,~/.cache/Nvim-R/RsrcTags

  " New file templates {{{2
  au BufNewFile Makefile r ~/.vim/skeleton.Makefile
  au BufNewFile setup.py r ~/.vim/skeleton.setup.py
  au BufNewFile tox.ini r ~/.vim/skeleton.tox.ini
  au BufNewFile config.py r ~/.vim/skeleton.config.py
  au BufNewFile ansible.cfg r ~/.vim/skeleton.ansible.cfg
  au BufNewFile docker-compose.yml r ~/.vim/skeleton.docker-compose.yml
  au BufNewFile build.gradle r ~/.vim/skeleton.gradle.build
  au BufNewFile pom.xml r ~/.vim/skeleton.pom.xml
  au BufNewFile pom.xml set filetype=pom
  au BufNewFile stack.yaml r ~/.vim/skeleton.stack.yaml
  " au BufNewFile stack.yaml set filetype=haskellstack

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
  " autopep8 <f3> {{{2
  autocmd FileType python map <buffer> <F3> :call Autopep8()<CR>

  " autogenerate tags files (for vim help files after saving them)
  autocmd BufWritePost ~/.vim/doc/* :helptags ~/.vim/doc

  " hook after plugin are loaded {{{2
  au VimEnter * call ConfigAfterPluginLoaded()
  " au VimEnter :cd %:p:h

  " Disable syntax highlighting for big files {{{2
  autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif
  " autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | syntax sync clear | endif
augroup END


""""""""""""""""""""""""""""""""""""""""

" }}}1 CUSTOM AUTOCOMMANDS


" MISC KEY MAPPINGS{{{1
" Copy to system clipboard {{{2
map <leader>y "*y

" format xml
map @@x %!xmllint --format --recover -<CR>


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
" <C-j> or ;; Finish line with semicolon ; {{{2
" <C-j> conflicts with UltiSnips <c-j> I need to find a new mapping for this
" maybe <c-;>  although I think that mapping is not possible for some reason
" imap <C-j> <End>;<cr>
nnoremap ;; m`A;<Esc>``
" m` : marks the current position
" A; : adds ; at the end of the line
" `` : return to position
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
" Tagbar <f8> {{{2
nnoremap <f8> :TagbarToggle<CR>
" w!! Write file as root (sudo tee trick) {{{2
" command mode mapping, throw away the stdout
cmap w!! w !sudo tee >/dev/null %
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
" vim airline configuration {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 0
" }}} vim airline configuration
" :H to open help in current window {{{
command! -nargs=1 -complete=help H :tabnew | :set buftype=help | :h <args>
" }}} :H to open help in current window
" unite.vim mappings {{{
" unitemappings

let g:unite_source_history_yank_enable = 1
" TODO: change from ag to rg --files, or sift --targets, (or any of the alternatives ripgrep,
" sift, ack, ucg, pt,
" let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --smart-case'
let g:unite_source_grep_recursive_opt = ''
" Using ag as recursive command.
" let g:unite_source_rec_async_command =
"           \ 'ag --follow --nocolor --nogroup --hidden -g ""'
" Using ag as recursive command.
" let g:unite_source_rec_async_command =
" \ ['ag', '--follow', '--nocolor', '--nogroup',
" \  '--hidden', '-g', '']

let g:unite_source_rec_async_command = ['rg','--files']

" Custom mappings for the unite buffer type, run when a FileType unite is
" opened
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
let updatetime=250
let g:gitgutter_map_keys = 0 " don't add any mappings
nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk
nmap <Leader>ha <Plug>GitGutterStageHunk
nmap <Leader>hr <Plug>GitGutterUndoHunk

" }}}
" Learn vimscript the hard way {{{1
" }}}1 Learn vimscript the hard way
" disable Q no Ex mode {{{1
nnoremap Q <nop>
" }}}1
" Add keywords to keywords dictionary {{{1
function! AddCurrentWordToKeywords()
  let currentWord = expand("<cword>")
  let keywordsFile = expand("~/.vim/keywords.txt")
  call writefile(readfile(keywordsFile)+[ currentWord ],keywordsFile)
endfunction
command AddToKeywords call AddCurrentWordToKeywords()
" Add keywords to keywords dictionary }}}1
" Set dictionary {{{1
set dictionary+=/usr/share/dict/words
" Set dictionary }}}1
" vim-better-whitespace {{{1
let g:better_whitespace_filetypes_blacklist=['unite']
" vim-better-whitespace }}}1
" Test command -> Etest (projectionist) {{{1
" you need a vim-projectionist file with some files of type: test
" %:t just the filename (without the path)
" :r removes the extension al well
" "tests/*.c": {
"   "alternate": "src/{}.c",
"   "type": "test"
" }
command Test execute 'Etest '.expand("%:t:r")
" Test command -> Etest (projectionist) }}}1
" Neocomplete {{{
source ~/.vim/neocomplete.vim
" }}}
" Save with :W {{{
command! W :
" Save with :W }}}
" vim-test {{{
let test#strategy = "dispatch"
let test#python#runner = 'nose'

" vim-test }}}
" Autopep8 disable the <F8> mapping since it's taken by the the ToggleBar {{{
let no_autopep8_maps=1
" Autopep8 }}}
" Work in UTF-8 {{{
set encoding=utf-8
set fileencoding=utf-8
" Work in UTF-8 }}}
" tslime.vim for clojure development {{{
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1

vmap <C-c><C-c> <Plug>SendSelectionToTmux

" <C-c><C-c> sends the paragraph (selected with vip) to the other pane in
" the current window
nmap <C-c><C-c> <Plug>NormalModeSendToTmux

" To send your own commands to the other pane use
" :nmap ,t :Tmux textthatwillbesenttootherpane<CR>

" tslime.vim }}}
" vim-slime for clojure development {{{
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"
let g:slime_default_config = {"socket_name": "default", "target_pane": ":.2"}
let g:slime_dont_ask_default = 1
" Send to pane number 2 in this window. SlimeConfif of C-c v  to change it
" C-c C-c sends the actual like to the tmux pane
"
" vim-slime }}}
" gx configuration {{{
:let g:netrw_browsex_viewer= "xdg-open"
" Use whole "words" when opening URLs.
" This avoids cutting off parameters (after '?') and anchors (after '#').
" See http://vi.stackexchange.com/q/2801/1631
let g:netrw_gx="<cWORD>"
" gx configuration }}}
" GIFL google i'm feeling lucky URL grabber {{{
let g:LuckyOutputFormat='markdown'
" GIFL google i'm feeling lucky URL grabber }}}
let g:GetLatestVimScripts_allowautoinstall = 1
" UltiSnips configuration {{{
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" let g:UltiSnipsJumpForwardTrigger="<nop>"
" let g:UltiSnipsJumpBackwardTrigger="<nop>"
" UltiSnips configuration }}}
" YouCompleteMe configuration {{{
let g:ycm_server_keep_logfiles = 1
let g:ycm_use_ultisnips_completer = 1
" YouCompleteMe configuration }}}
" Nvim-R {{{
" nvimr
" from :help Nvim-R-Tmux
let R_in_buffer = 0 " :help R_in_buffer . If you do not want to run R in
                    " Neovim built in terminal emulator. R will start in an
                    " external emulator and tmux will be used to send commands
                    " to R
let R_applescript = 0
let R_tmux_split = 1
let R_nvim_wd = 1 " R working directory same as vim working directory, don't try to match buffer dir "

command RStart let oldft=&ft | set ft=r | exe 'set ft='.oldft | normal <LocalLeader>rf
command Rtags :!Rscript -e 'rtags(path="./", recursive=TRUE, ofile="RTAGS")' -e 'etags2ctags("RTAGS", "rtags")' -e 'unlink("RTAGS")'


" Nvim-R }}}
" vim-bookmarks {{{
" mm - Add / remove a bookmark
" mi - Add / remove / edit an annotation at the current line
" ma - Show all bookmarks
" mc - Clear bookmarks in current buffer only
" mx - Clear bookmarks in all buvffers



" vim-bookmarks }}}
" command :Cheatsheet with the the ecerulm personal notes  about vim usage {{{
:command Cheatsheet :helptags ~/.vim/doc | :help Cheatsheet
:command EditCheatsheet :helptags ~/.vim/doc | :edit ~/.vim/doc/cheatsheet.txt
" command to enable :help Cheatsheet }}}
" Vim-go settings vimgo {{{1

" See :help CheatsheetGo
" see :help go-settings

" autowrite so that the buffers gets saved automatically at :GoBuild
set autowrite
" map <C-n> :cnext<CR>
" map <C-p> :cprevious<CR>
" nnoremap <leader>a :cclose<CR>

" if you don't want vim-go to use location-list instead of quickfix
" let g:go_list_type = "quickfix"

let g:go_test_timeout = '10s'
let g:go_fmt_command = "goimports"

" if you don't want the errors from goimports to pop on the quickfix list
" see :help 'g:go_fmt_fail_silently', don't show a location list if the
" build fail (only when is run as part of the autoformat on save)
let g:go_fmt_fail_silently = 1


" let g:go_snippet_case_type = "camelcase"
" let g:go_snippet_case_type = "snakecase"

" if you don't like that the text-objects af and if  include the function doc
" let g:go_textobj_include_function_doc = 0

" syntax highlight can slow down vim
" let g:go_highlight_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_generate_tags = 1

" see  :help 'g:go_jump_to_error' when we do <leader>b, <leader>t, etc
let g:go_jump_to_error = 1


" should vaf include the documentation of function or not
let g:go_textobj_include_function_doc = 1

let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

" Since metalinter is fast you want to run it on save
" but it's distracting
let g:go_metalinter_autosave = 0
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_deadline = "5s"

" the Go to definiton commands gd / CTRL-] use guru by default
" it can be slow  change g:go_def_mode to use godef tool instead of guru
" let g:go_def_mode = 'godef'

" To control what is shown by :GoDecls and :GoDeclsDir
" let g:go_decls_includes = "func,type"
" let g:go_decls_includes = "func"

" g:go_auto_type_info will show info about id in the status line on the
" CursorHold event , controlled by 'updatetime'
" let g:go_auto_type_info = 1
" set updatetime=100

" let g:go_auto_sameids = 1


" A lot of commands :GoCallees, etc depend on guru and sometimes they know to
" now the scope see :help :GoGuruScope
" let g:go_guru_scope = ["github.com/fatih/vim-go-tutorial"]
" let g:go_guru_scope = ["..."]
" let g:go_guru_scope = ["github.com/...", "golang.org/x/tools"]
" let g:go_guru_scope = ["encoding/...", "-encoding/xml"]
" let g:go_guru_tags = "mycustomtag"


" Vim-go settings vimgo }}}1
" Miscellaneous {{{1

" so that CTRL-A in mormal mode doesn't treat numbers with a leading zero as
" octal
set nrformats-=octal

" Miscellaneous }}}1

" vim-syntastic settings {{{1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" vim-syntastic settings }}}1

" Scala  {{{1
augroup scalaEx " Put them in a group so we delete them easily
  " Clear all autocmd in the group
  autocmd!
  " autocmd BufWritePost *.scala silent :EnTypeCheck
augroup END
" let $BROWSER = '~/bin/vim-browser %s'
" nnoremap <localleader>t :EnType<CR>
"  $ export BROWSER="firefox %s"
"  :help ensime.txt
"  :help ensime-build-tools
" Scala  }}}1
" {{{1 Neomake
let g:neomake_maven_maker= {
      \ 'exe': 'mvn',
      \ 'args': ['install'],
      \ 'errorformat': '[%tRROR]\ %f:[%l\,%c]\ %m,%-G%.%#',
      \ }

" [ERROR] /Users/.../github/.../App.java:[22,26] cannot find symbol

let g:neomake_open_list = 0
" let g:neomake_open_list = 2 " a value of 2 will preserve the cursors position when the location-list or quickfix window is opened.
" let g:neomake_logfile = '/Users/rl186056/neomake.log'
" 1}}}

" Configuration to run after all plugins are loaded {{{
function! ConfigAfterPluginLoaded()
  " This function is called after all plugins are loaded
  " put here anything that runs commands defined by plugins
  " put here changes that depends on functions defined in plugins
  " so that you can check if the function exists before using it
  " in statusline, etc. That way the configuration won't break if runs on
  " a machine that has not installed the plugins
  "

  "{{{1 set colorscheme 
  colorscheme gruvbox
  "1}}}
  " vim-cycle groups {{{
  if exists("*AddCycleGroup")
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
    call AddCycleGroup('python', ['start', 'stop'])
    call AddCycleGroup('c', ['EXIT_FAILURE', 'EXIT_SUCCESS'])
  endif
  " }}} vim-cycle groups

  " Uppercase with <c-u> {{{
  " Should this be here it looks like it could be run before plugins
  inoremap <C-u> <Esc>viW~Ea
  nnoremap <c-u> g~iWE
  " }}}


  " abolish types  {{{
  if exists(":Abolish")
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
    :Abolish lable label
  endif
  " }}}

  " vim-tabber {{{
  if exists("*tabber#TabLine")
    set tabline=%!tabber#TabLine()
    let g:tabber_wrap_when_shifting = 1
  endif
  " }}}
  " STATUSLINE fugitive {{{
  if exists("*fugitive#statusline")
    set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)%{fugitive#statusline()}	" filename filetype git
  endif
  " :set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%o,%c,%l/%L\ %P
  " }}} STATUSLINE
  " vim-cycle plugin configuration {{{
  let g:cycle_no_mappings = 1
  nmap  -     <Plug>CycleNext
  " }}} vim-cycle plugin configuration

  " Easy Align plugin configuration {{{
  if exists("g:loaded_easy_align_plugin")
    " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
    vmap <Enter> <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
    " nmap <Leader>a <Plug>(EasyAlign)
  endif
  " }}} Easy Align pluign configuration

  " EasyMotion configuration {{{
  " http://code.tutsplus.com/tutorials/vim-essential-plugin-easymotion--net-19223
  " :h easymotion-default-mappings
  if exists("g:EasyMotion_loaded")
    "map <Leader>l <Plug>(easymotion-lineforward)
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
    map <Leader>h <Plug>(easymotion-linebackward)

    let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion the mappings are the typical w,f,b,e, etc but preceded by <Leader><Leader>
  endif

" }}} EasyMotion configuration
  " unite configuration {{{
  if exists("unite#filters#matcher_default#use")
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
  endif

  if exists(":Unite")
    nnoremap <C-p> :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
    " We already have <C-p>  no need for <leader>t nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
    " nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<cr>
    nnoremap <leader>mru :<C-u>Unite -no-split -buffer-name=mru   file_mru<cr>j
    nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline -start-insert -auto-preview outline<cr>
    nnoremap <leader>ut :<C-u>Unite -no-split -buffer-name=tag     -start-insert tag<cr>
    nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
    nnoremap <leader>e :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>
    nnoremap <leader>g :<C-u>Unite -no-split -buffer-name=ag      grep:.<cr>
    " nnoremap <silent> <leader>o  :<C-u>Unite                      outline<CR>
    nnoremap <leader>l :<C-u>Unite -no-split                      resume<cr>
  endif
  " unite configuration }}}
  " Denite {{{
  if exists(":Denite")
    " echomsg "Denite is ON"
    " Change file_rec command.
    call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git', ''])

   " Ripgrep command on grep source
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
    call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')

    nnoremap <C-p> :<C-u>Denite file_rec<cr>
    nnoremap <leader>g :<C-u>Denite -no-split -buffer-name=ag grep<cr>

    " what is the Denite command to see all open buffers
    nnoremap <leader>o :<C-u>Denite buffer<cr>
  endif
  " Denite }}}
 
" CamelCaseMotion {{{
" vim-scripts/camelcasemotion
" :help sunmap
" :help mapmode-s
" TODO: check if CameCaseMotion is loaded before doing this
if exists('g:loaded_camelcasemotion')
  map <silent> w <Plug>CamelCaseMotion_w
  map <silent> b <Plug>CamelCaseMotion_b
  map <silent> e <Plug>CamelCaseMotion_e
  " the sunmap remove the w,b,e motions from the SELECT MODE
  sunmap w
  sunmap b
  sunmap e
endif
" }}}
"
" {{{1 Neomake automake :h neomake-automake

  " call neomake#configure#automake({
  " \ 'TextChanged': {},
  " \ 'InsertLeave': {},
  " \ 'BufWritePost': {'delay': 0},
  " \ 'BufWinEnter': {},
  " \ }, 500)
" 1}}}

endfunction
" }}} Configuration to run after all plugins are loaded
"

fun! FixPost() "{{{
  " :help :silent
  " :help :s_flags
  :silent! %s/\\\*/*/g
  :silent! %s/\\_/_/g
  :silent! %s/\\\[/[/g
  :silent! %s/\\]/]/g
  :silent! %s/\\#/#/g
  :silent! %s/&lt;/</g
  :silent! %s/&gt;/>/g
  :silent! %s/\\\\/\\/g
endfunction "}}}

command! FixPost call FixPost()

" Macros @ {{{1
" @b will fix a octopress post into a hugo post, it deletes layout add date
" and add aliases
let @b = "jddodate: =expand('%:t')[0:9]jkjyypciwaliasesjkf/i- jk:w"
" Macros @ }}}1


" Plugins {{{
" This plugins are loaded for both vim and neovim

" remember all plugins are loaded after .vimrc is complete not before
" vim-plug
call plug#begin('~/.vim/plugged')

  " Tim Pope plugins
  Plug 'tpope/vim-obsession' " Autosave Session.vim
  Plug 'tpope/vim-repeat'       " Make command repeatble
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-commentary'   " comment code gcc
  Plug 'tpope/vim-fugitive'     " git interface
  Plug 'tpope/vim-git'          " syntax for gitcommit, gitconfig, etc
  Plug 'tpope/vim-speeddating'  " Increment dates with <C-a> <C-x>
  Plug 'tpope/vim-surround'     " viwS)
    " https://github.com/tpope/vim-surround
    " Manipulate bracket pairs and tags
    " cs + '"[]{}()<>t + X  <-- change surrounding pairs
    " ds" <-- delete surrounding pairs
    " ysiw + '"[]{}()<>t + X<-- surround word with X
    " yss + '"[]{}()<>t + X<-- surround entire line with X
    "
    " advanced examples:
    " take: ({ Hello } world!)
    " do: ds{ds)
    " get: Hello World!
    "
    " take: <em>Hello</em> world!
    " do: V + S<p class="red">
    " get:
    "<p class="red">
    "<em>Hello</em> world!
    "</p>

  Plug 'tpope/vim-unimpaired'   " con, cor, col ]b, ]l, ]q
  Plug 'tpope/vim-sleuth'      " No need to set indenting, ts, etc per ftype
  " Plug 'tpope/vim-salve'         " autoconnect fireplace.vim to the REPL
  Plug 'tpope/vim-projectionist' " alternate files,
  " Plug 'tpope/vim-dispatch'      " run test asynch
  " Plug 'tpope/vim-fireplace'     " REPL
  " Plug 'tpope/vim-classpath'
  " Plug 'tpope/vim-sexp-mappings-for-regular-people'

  " Plug 'compactcode/alternate.vim'
  " Plug 'compactcode/open.vim'
  " Plug 'scrooloose/nerdtree'
  " Plug 'Shougo/unite.vim'
  " Plug 'Shougo/unite-outline'
  " Plug 'tsukkee/unite-tag'
  " Plug 'Shougo/neocomplete'     " required by unite-tag , needs vim if_lua
  Plug 'Shougo/denite.nvim'  " like unite.vim but for vim8 / neovim
  " Plug 'Shougo/vimproc.vim'
  " Plug 'Shougo/neomru.vim'
  " Plug 'Shougo/neocomplcache'
  Plug 'SirVer/ultisnips'       " snippet manager like SnipMate :h UltiSnips
  " Plug 'alfredodeza/pytest.vim' " :h pytest
  " Plug 'alfredodeza/coveragepy.vim'
  Plug 'godlygeek/tabular'      " align text
  " Plug 'kien/ctrlp.vim'         " file fuzzy search
  " Plug 'klen/python-mode'       " :h python-mode
  " Plug 'lambdalisue/nose.vim'   " :compiler nose (depends on pip install nose_machine2
  " Plug 'mileszs/ack.vim'        " :h ack
  Plug 'oblitum/rainbow'        " rainbow parens
  " Plug 'sjl/gundo.vim'          " <f6> show undo tree
  Plug 'tommcdo/vim-exchange'   " exchange regions of txt cxiw X
  " Plug 'janko-m/vim-test'
  " Plug 'vim-ruby/vim-ruby'
  Plug 'vim-scripts/camelcasemotion'        " w stops at _ and CamelCase
  " Plug 'Townk/vim-autoclose'    " Auto close parens, brackets
  " Plug 'bronson/vim-trailing-whitespace' " trailing whitespace highlighed in red and :FixWhitespace
  Plug 'ntpeters/vim-better-whitespace' " tailing whitespace highlighted :StripWhitespace
  " Plug 'jgdavey/tslime.vim'
  " Plug 'mutewinter/GIFL' " Google I'm feeling Lucky URL Grabber <Leader>gifliw
  "
  Plug 'neomake/neomake'

  " toggle.vim / cycle.vim / switch.vim
  " I decided cycle because switch is harder to configure although it's not
  " limited to single word
  Plug 'zef/vim-cycle'

  Plug 'junegunn/vim-easy-align'  " :h easy-align
  " https://github.com/junegunn/vim-easy-align
  " Easily align large blocks of code using various delimiters.
  " vipga      <Space>, =, :, ., |, &,            , and ,.
  " gaip       <Space>, =, :, ., |, &,            , and ,.
  "
  " <Space>    Around 1st whitespaces             :'<,'>EasyAlign\
  " 2<Space>   Around 2nd whitespaces             :'<,'>EasyAlign2\
  " -<Space>   Around the last whitespaces        :'<,'>EasyAlign-\
  " -2<Space>  Around the 2nd to last whitespaces :'<,'>EasyAlign-2\
  " :          Around 1st colon (key: value)      :'<,'>EasyAlign:
  " <Right>:   Around 1st colon (key              : value)    :'<,'>EasyAlign:>l1
  " =          Around 1st operators with =        :'<,'>EasyAlign=
  " 3=         Around 3rd operators with =        :'<,'>EasyAlign3=
  " *=         Around all operators with =        :'<,'>EasyAlign*=
  " **=        Left-right alternating around =    :'<,'>EasyAlign**=
  " <Enter>=   Right alignment around 1st =       :'<,'>EasyAlign!=
  " <Enter>**= Rightleft alternating around =     :'<,'>EasyAlign!**=




  " Plug 'bling/vim-airline' " uses powerline symbols
  Plug 'airblade/vim-gitgutter'
  " Plug 'easymotion/vim-easymotion'
  " Plug 'majutsushi/tagbar'      " ctags outline browser
  Plug 'fweep/vim-tabber'       " tab renaming
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'vim-scripts/DrawIt'
  Plug 'chrisbra/NrrwRgn'
  Plug 'vim-scripts/visincr'
   " visincr plugin facilitates making a olumn of increasing or decreasing
   " numbers, dates or daynames, select a column with visual-block C-v
   " :I , :II, :IYMD
  " Plug 'guns/vim-sexp'
  Plug 'danro/rename.vim'
  Plug 'mhinz/vim-sayonara'
  Plug 'mtth/scratch.vim' " :Scratch and gs in normal and visual mode
  " Plug 'MattesGroeger/vim-bookmarks'
  " Plug 'Valloric/YouCompleteMe'
  Plug 'nelstrom/vim-visual-star-search' " select in visual press * to search



  " Plug 'svermeulen/vim-easyclip'
  " " https://github.com/svermeulen/vim-easyclip
  " " Separate cut and delete
  " " d deletes and m 'moves'
  " " + shared clipboard between multiple instances.

  " Plug 'mbbill/undotree'
  " " https://github.com/mbbill/undotree
  " " :UndotreeToggle or <F5>
  " " easier controls to get back to parts of the undo tree
  " " where u and ctrl+r are not enough in some sittuations.

  " Plugs for python py2 py3 development
  " Plug 'ecerulm/vim-nose' "  :compiler nose
  " Plug 'nvie/vim-flake8' " <F7> for running flake8, pep8
  " Plug 'tell-k/vim-autopep8' " <F8> for running autopep8
  " Plug 'lambdalisue/vim-pyenv'

  " Plugs for Clojure development
  " Plug 'jpalardy/vim-slime'      " send text to tmux pane


  " Plugs for Golang development
  " Plug 'fatih/vim-go'

  " Plugs for R development
  " Plug 'jalvesaq/Nvim-R'

  " Plugins for scala
  " Plug 'ensime/ensime-vim' " external ensime server provides completions, etc
  " Plug 'derekwyatt/vim-scala' " Sort scala imports :help vim-scala

  " Syntastic plugin for syntax checkers (for scala)
  " Plug 'vim-syntastic/syntastic'


  " textobj
  Plug 'kana/vim-textobj-fold'  " az and iz
  Plug 'kana/vim-textobj-user'  " library for vim-textobj-*
  Plug 'kana/vim-textobj-function' " vaf, vif, daf, dif, yaf
  Plug 'kana/vim-textobj-indent' " ai, ii aI aI
  Plug 'kana/vim-textobj-entire' " ae, ie
  Plug 'lucapette/vim-textobj-underscore'
  Plug 'vim-scripts/argtextobj.vim'         " daa to delete arguments
  Plug 'kana/vim-textobj-syntax' " yiy yay
  Plug 'AndrewRadev/splitjoin.vim'

  " color themes
  Plug 'altercation/vim-colors-solarized'
  Plug 'rainux/vim-desert-warm-256'
  Plug 'tomasr/molokai'
  Plug 'sjl/badwolf'
  Plug 'morhetz/gruvbox'


call plug#end()
" Plugins }}}
