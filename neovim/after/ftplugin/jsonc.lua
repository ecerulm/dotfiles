vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldmethod = "expr"
-- Treesitter has no separate JSONC grammar; JSON5 covers its comments and
-- trailing commas without marking them as syntax errors.
vim.treesitter.start(0, "json5")

vim.b.miniai_disable = true
