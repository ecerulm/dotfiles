vim.opt_local.autoindent = true
vim.opt_local.smartindent = true
-- vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.opt_local.indentexpr = "python#GetIndent(v:lnum)" -- bring back the default python indent
-- vim.opt_local.indentexpr = ""
vim.treesitter.start()
