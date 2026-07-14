vim.opt_local.autoindent = false -- autoindent noautoindent
vim.opt_local.smartindent = false -- smartindent nosmartindent

-- Indentation: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#indentation
vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- $VIMRUNTIME/indent/python.vim sets indentkeys to include ":" and "<:>", which
-- re-indent the line via indentexpr on every colon typed -- even inside a string,
-- where the treesitter indentexpr sees a broken string node and resets indent to 0.
-- Drop the colon triggers so typing ":" in a string no longer clobbers the indent.
vim.opt_local.indentkeys:remove({ ":", "<:>" })
