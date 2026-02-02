return {
	-- https://github.com/nvim-telescope/telescope-dap.nvim
	"nvim-telescope/telescope-dap.nvim",
	enabled = false,
	lazy = false,
	config = function(_, opts)
		require("telescope").load_extension("dap")
	end,
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap",
		"nvim-treesitter/nvim-treesitter",
	},
}
