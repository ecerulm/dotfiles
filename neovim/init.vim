" use the vim usual runtimepath
" :h runtimepath is used for finding autoload, etc
" this doesn't include the .vim/bundle
" each directory in .vim/bundle needs to be added to the runtimepath
" this is what pathogen, vundle, vim-plug, etc do. They keep doing
" set runtimetime+=~/.vim/bundle/plugin1 for each folder
set runtimepath+=~/.vim,~/.vim/after

" :h packpath used to find packages, a package is a directory that containes
" one or more plugins, they are better than regular plugin directory because:
" they can contains multiple plugins that depend on each other
" a package can contain plguis that are automatically loaded on startup and
" ones that are only loaded when needed with :packadd
set packpath+=~/.vim

" Set the python interpreters to use
" these ones point to virtual environments where the pip install neovim
" has already been executed. See :h provider-python
for p in ['py27neovim', 'venv-py27-neovim']
  let fp = expand('~/.pyenv/versions/' . p . '/bin/python')
  if filereadable(fp)
    let g:python_host_prog  = fp
  endif
endfor
" let g:python_host_prog  = expand('~/.pyenv/versions/py27neovim/bin/python')
for p in ['py36neovim', 'venv-py36-neovim']
  let fp = expand('~/.pyenv/versions/' . p . '/bin/python')
  if filereadable(fp)
    let g:python3_host_prog = fp
  endif
endfor


" .vimrc works for both vim and neovim
source ~/.vimrc



