-- Highlighting: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#highlighting
vim.treesitter.start()

-- Folds: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#folds
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldmethod = "expr"

-- Indentation: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#indentation
vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- Formatting / :h 'formatoptions' / :h fo-table
vim.opt_local.formatoptions:remove({ "c", "r", "o" })
-- :h fo-c, the c means autowrap comments using 'textwidth'
-- :h fo-r, automatically insert the current comment leader after hitting <enter> in insert mode
-- :h fo-o, automatically insert the current comment leader after using o or O
