-- Highlighting: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#highlighting
vim.treesitter.start()

-- Folds: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#folds
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldmethod = "expr"
