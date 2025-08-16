  setlocal ai sw=2 sts=2 et
  setlocal foldmethod=syntax
  setlocal textwidth=72
  let b:ruby_space_errors=1
  compiler ruby
  map ,t :w\|:make %<cr>
