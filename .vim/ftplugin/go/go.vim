if !exists('b:RubenGoSettings')
  function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
      call go#cmd#Test(0, 1)
    elseif l:file =~# '\f\+\.go$'
      call go#cmd#Build(0)
    endif
  endfunction
  " nmap <leader>b <Plug>(go-build)
  nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
  nmap <leader>r <Plug>(go-run)
  nmap <leader>t <Plug>(go-test)
  nmap <leader>c <Plug>(go-coverage-toggle)
  nmap <leader>i <Plug>(go-info)

  command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
  let b:RubenGoSettings=1
endif
