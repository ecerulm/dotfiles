-- https://github.com/tom-anders/telescope-vim-bookmarks.nvim

return {
	"tom-anders/telescope-vim-bookmarks.nvim",
  enabled = false,
  lazy = false,
	config = function()
    require('telescope').load_extension('vim_bookmarks')
  end,
	dependencies = {
    'nvim-telescope/telescope.nvim',
    'MattesGroeger/vim-bookmarks',
  },
}
