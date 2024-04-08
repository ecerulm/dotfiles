return {
	"LukasPietzschmann/telescope-tabs",
	enabled = true,
	lazy = false,
	config = function()
		require("telescope").load_extension("telescope-tabs")
		require("telescope-tabs").setup({
			-- Your custom config :^)
		})
	end,
	dependencies = { "nvim-telescope/telescope.nvim" },
}
