vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldmethod = "expr"
vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentrepr()"
vim.treesitter.start()
vim.opt_local.formatoptions:remove({ "c", "r", "o" })
