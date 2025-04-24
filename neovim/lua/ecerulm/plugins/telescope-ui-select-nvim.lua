return {
	"nvim-telescope/telescope-ui-select.nvim",
	enabled = false,
	lazy = false,
	config = function()
		require("telescope").load_extension("ui-select")
	end,
	dependencies = { "nvim-telescope/telescope.nvim" },
}
