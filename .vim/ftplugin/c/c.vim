if !exists('b:RubenCSettings')
  let b:c_space_errors=1 " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  setlocal textwidth=72
  setlocal foldmethod=indent " foldmethod syntax is super slow
  setlocal foldnestmax=1
  setlocal foldlevel=0
  setlocal equalprg=indent\ -nut

  inoremap <buffer> <C-l> ->
  inoremap /* /*  */<Esc>hhi
  func! RubenCSettings_Format()
    let l:winview = winsaveview()
    :%!indent
    call winrestview(l:winview)
  endf
  command -buffer Format call RubenCSettings_Format() 
  let b:RubenCSettings=1
endif
