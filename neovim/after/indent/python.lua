vim.opt_local.autoindent = false -- autoindent noautoindent
vim.opt_local.smartindent = false -- smartindent nosmartindent
vim.opt_local.cindent = false -- cindent nocindent
vim.opt_local.indentexpr = ""

-- vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
-- vim.opt_local.indentexpr = "python#GetIndent(v:lnum)" -- bring back the default python indent
-- vim.opt_local.indentexpr = ""
vim.treesitter.start()
