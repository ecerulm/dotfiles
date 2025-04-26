-- Display LSP-based breadcrumbs
return {
	-- https://github.com/utilyre/barbecue.nvim
	-- nvim-navic does not alter the status line or winbar by itself
	-- you need barbecue or nvim-navbuddy to display the breadcrumbs
	"utilyre/barbecue.nvim",
	enabled = true,
	lazy = false,
	name = "barbecue",
	version = "*",
	dependencies = {
		-- https://github.com/SmiteshP/nvim-navic
		"SmiteshP/nvim-navic",
		-- https://github.com/nvim-tree/nvim-web-devicons
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
	opts = {                 -- lazy.nvim will call require("barbecue").setup(opts)
		-- configurations go here
		theme = THISMACHINESETTINGS.colorscheme
	},
}
