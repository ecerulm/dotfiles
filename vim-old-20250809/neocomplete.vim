" Disable AutoComplPop
let g:acp_enableAtStartup = 0
" Use neocomplete
let g:neocomplete#enable_at_startup = 0
" Use smartcase
let g:neocomplete#enable_smart_case = 1
"Set minium syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary
let g:neocomplete#sources#dictionary#dictionaries = {
   \ 'default' : '',
   \ 'config' : $HOME.'/.vim/autotools.dict.txt',
   \ 'c' : $HOME.'/.vim/keywords.txt'
 \ }

" Define keyword
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

if exists('*neocomplete#undo_completion')
  " Plugin key-mappings
  " complete_common_string helps if the candidates share a long prefix
  inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr><C-l> neocomplete#complete_common_string() 

  " Recommended key-mappings
  " <CR>: close popup and save indent
  " inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  " function! s:my_cr_function()
  "   return neocomplete#close_popup() . "\<CR>"
  "   " For no inserting <CR> key.
  "   "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  " endfunction
  " <TAB>: completion
  " inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y> neocomplete#close_popup()
  inoremap <expr><C-e> neocomplete#close_popup()
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
endif


