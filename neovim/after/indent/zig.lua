vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true

-- Indentation: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#indentation
vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
