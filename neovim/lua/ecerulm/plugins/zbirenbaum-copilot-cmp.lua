return {
	--  nvim-cmp  source
	--  if you use zbirenbaum/copilot.lua as nvim-cmp source
	--  you need to disable the copilot.lua suggestions and panel
	"zbirenbaum/copilot-cmp",
	enabled = false,
	cond = (
		THISMACHINESETTINGS.zbirenbaum_copilot_enabled
		and THISMACHINESETTINGS.zbirenbaum_copilot_as_nvim_cmp
		and not THISMACHINESETTINGS.github_copilot_enabled
	),
	lazy = false,
	dependencies = {
		"zbirenbaum/copilot.lua",
	},
	config = function()
		require("copilot_cmp").setup({})
	end,
}
