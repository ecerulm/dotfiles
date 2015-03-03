let b:c_space_errors=1 " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
setlocal textwidth=72
setlocal foldmethod=indent " foldmethod syntax is super slow

inoremap <buffer> <C-l> ->
inoremap ( ()<Esc>hi
inoremap { {<CR>}<Esc>O
inoremap /* /*  */<Esc>hhi
