-- vim.opt_local.autoindent = false
-- vim.opt_local.smartindent = false
vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.treesitter.start()
