" set runtimepath+=~/.vim,~/.vim/after
" set packpath+=~/.vim
let g:python_host_prog  = expand('~/.pyenv/versions/py27neovim/bin/python')
let g:python3_host_prog = expand('~/.pyenv/versions/py36neovim/bin/python')


call plug#begin('~/.local/share/nvim/plugged')
Plug 'Shougo/denite.nvim'
Plug 'tpope/vim-abolish'
Plug 'tommcdo/vim-exchange'   " exchange regions of txt cxiw X
Plug 'ntpeters/vim-better-whitespace' " tailing whitespace highlighted :StripWhitespace
Plug 'zef/vim-cycle'
Plug 'jalvesaq/Nvim-R'
Plug 'fweep/vim-tabber'       " tab renaming


" Tim Pope
Plug 'tpope/vim-fugitive'     " git interface


" colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'rainux/vim-desert-warm-256'
Plug 'tomasr/molokai'
Plug 'sjl/badwolf'

call plug#end()



source ~/.vimrc
autocmd VimEnter * :call Plugins()

function Plugins()
  " This is called after all plugins are loaded
  " We cannot conditionally check for plugins until VimEnter
  if exists(":Denite")
    echomsg "Denite is ON"
    " Change file_rec command.
    call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git', ''])
    nnoremap <C-p> :<C-u>Denite file_rec<cr>
  endif

endfunction


