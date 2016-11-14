" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required
set shell=/bin/bash           " required for Vundle PluginInstall

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
Plugin 'tpope/vim-obsession' " Autosave Session.vim
" Plugin 'tpope/vim-sleuth'      " No need to set indenting, ts, etc per ftype
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/unite-outline'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'tsukkee/unite-tag'
Plugin 'Shougo/neocomplcache'
Plugin 'Shougo/neocomplete'     " required by unite-tag , needs vim if_lua
Plugin 'tpope/vim-repeat'       " Make command repeatble
Plugin 'tpope/vim-sensible'
Plugin 'SirVer/ultisnips'       " snippet manager like SnipMate :h UltiSnips
Plugin 'alfredodeza/pytest.vim' " :h pytest
Plugin 'alfredodeza/coveragepy.vim'
Plugin 'godlygeek/tabular'      " align text
" Plugin 'kien/ctrlp.vim'         " file fuzzy search
" Plugin 'klen/python-mode'       " :h python-mode
" Plugin 'lambdalisue/nose.vim'   " :compiler nose (depends on pip install nose_machine2
Plugin 'mileszs/ack.vim'        " :h ack
Plugin 'oblitum/rainbow'        " rainbow parens
Plugin 'sjl/gundo.vim'          " <f6> show undo tree
Plugin 'tommcdo/vim-exchange'   " exchange regions of txt cxiw X
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-commentary'   " comment code
Plugin 'tpope/vim-fugitive'     " git interface
Plugin 'tpope/vim-git'          " syntax for gitcommit, gitconfig, etc
Plugin 'tpope/vim-speeddating'  " Increment dates with <C-a> <C-x>
Plugin 'tpope/vim-surround'     " viwS)
Plugin 'tpope/vim-unimpaired'   " con, cor, col ]b, ]l, ]q
Plugin 'janko-m/vim-test'
Plugin 'vim-ruby/vim-ruby'
Plugin 'camelcasemotion'        " w stops at _ and CamelCase
Plugin 'Townk/vim-autoclose'    " Auto close parens, brackets
" Plugin 'bronson/vim-trailing-whitespace' " trailing whitespace highlighed in red and :FixWhitespace
Plugin 'ntpeters/vim-better-whitespace' " tailing whitespace highlighted :StripWhitespace
Plugin 'jgdavey/tslime.vim'
" Plugin 'mutewinter/GIFL' " Google I'm feeling Lucky URL Grabber <Leader>gifliw

" toggle.vim / cycle.vim / switch.vim
" I decided cycle because switch is harder to configure although it's not
" limited to single word
Plugin 'zef/vim-cycle'

Plugin 'junegunn/vim-easy-align'  " :h easy-align
" Plugin 'bling/vim-airline' " uses powerline symbols
Plugin 'airblade/vim-gitgutter'
Plugin 'easymotion/vim-easymotion'
Plugin 'majutsushi/tagbar'      " ctags outline browser
Plugin 'fweep/vim-tabber'       " tab renaming
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'vim-scripts/DrawIt'
Plugin 'chrisbra/NrrwRgn'
Plugin 'visincr'
Plugin 'guns/vim-sexp'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
Plugin 'danro/rename.vim'
Plugin 'mhinz/vim-sayonara'
Plugin 'tpope/vim-classpath'
Plugin 'mtth/scratch.vim'
Plugin 'MattesGroeger/vim-bookmarks'
Plugin 'Valloric/YouCompleteMe'

" Plugins for python py2 py3 development
Plugin 'ecerulm/vim-nose' "  :compiler nose
Plugin 'nvie/vim-flake8' " <F7> for running flake8, pep8
Plugin 'tell-k/vim-autopep8' " <F8> for running autopep8
" Plugin 'lambdalisue/vim-pyenv'

" Plugins for Clojure development
Plugin 'tpope/vim-salve'         " autoconnect fireplace.vim to the REPL
Plugin 'tpope/vim-projectionist' " alternate files,
Plugin 'tpope/vim-dispatch'   " run test asynch
Plugin 'tpope/vim-fireplace'  " REPL

" textobj
Plugin 'kana/vim-textobj-fold'  " az and iz
Plugin 'kana/vim-textobj-user'  " library for vim-textobj-*
Plugin 'kana/vim-textobj-function' " vaf, vif, daf, dif, yaf
Plugin 'kana/vim-textobj-indent' " ai, ii aI aI
Plugin 'kana/vim-textobj-entire' " ae, ie
Plugin 'lucapette/vim-textobj-underscore'
Plugin 'argtextobj.vim'         " daa to delete arguments
Plugin 'kana/vim-textobj-syntax.git' " yiy yay

" color themes
Plugin 'altercation/vim-colors-solarized'
Plugin 'rainux/vim-desert-warm-256'
Plugin 'tomasr/molokai'
Plugin 'sjl/badwolf'

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
