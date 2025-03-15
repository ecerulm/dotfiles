return {
  'nvim-telescope/telescope-ui-select.nvim',
  enabled=true,
  lazy = false,
  config = function()
		require("telescope").load_extension("ui-select")
  end,
	dependencies = { "nvim-telescope/telescope.nvim" },
}
