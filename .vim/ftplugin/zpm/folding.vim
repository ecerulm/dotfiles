function! ZpmFolds()
  let thisline = getline(v:lnum)
  if match(thisline, "^[Signal") >= 0
    return ">2"
  elseif match(thisline, "^[") >= 0
    return ">1"
  else
    return "="
  endif
endfunction
setlocal foldmethod=expr
setlocal foldexpr=ZpmFolds()


function! ZpmFoldText()
  let foldsize = (v:foldend - v:foldstart)
  return getline(v:foldstart).' ('.foldsize.' lines) (level '.v:foldlevel.')'
endfunction
setlocal foldtext=ZpmFoldText()
