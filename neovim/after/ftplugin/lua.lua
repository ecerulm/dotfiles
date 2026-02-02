vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldmethod = "expr"
vim.treesitter.start()
vim.opt_local.formatoptions:remove({ "c", "r", "o" })
