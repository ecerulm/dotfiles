vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 5
vim.opt.background = 'dark'
vim.opt.showbreak='↪ '
vim.opt.listchars={
  tab = '→ ',
  eol = '↲',
  nbsp = '␣',
  trail = '•',
  extends = '⟩',
  precedes = '⟨',
}


-- vim.cmd[[highlight Whitespace gui=reverse guifg=#dc322f guibg=none guisp=none]]
vim.cmd[[match ExtraWhitespace /\s\+$/]]
vim.cmd[[highlight ExtraWhitespace ctermbg=red guibg=red]]
