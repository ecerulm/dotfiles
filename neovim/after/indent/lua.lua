vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- nvim-treesitter indent does not work very well for lua files
-- vim.opt_local.indentexpr = nil -- nvim-treesitter indent does not work very well for lua files

vim.opt_local.autoindent = true
vim.opt_local.smartindent = true
vim.opt_local.shiftwidth = 2 -- default: 8
vim.opt_local.shiftround = true -- default: false
vim.opt_local.tabstop = 2 -- default: 8
vim.opt_local.expandtab = false -- default: noexpandtab
-- vim.opt_local.softtabstop = 2  -- default: 0
-- vim.opt_local.expandtab = true  -- default: noexpandtab
