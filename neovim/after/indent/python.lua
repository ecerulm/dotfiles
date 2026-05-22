vim.opt_local.autoindent = false -- autoindent noautoindent
vim.opt_local.smartindent = false -- smartindent nosmartindent

-- Indentation: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#indentation
vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
