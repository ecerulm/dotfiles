return {
	"folke/tokyonight.nvim",
	enabled = true,
	-- cond = THISMACHINESETTINGS.colorscheme == "tokyonight",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				-- ns_id 0 means highlight group globally
				-- vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = "Purple" }) -- ns_id 0 means globally
				vim.api.nvim_set_hl(0, "@lsp.mod.readonly", { italic = true, bold = true })
				-- vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = "Yellow" })
				vim.api.nvim_set_hl(0, "@lsp.mod.deprecated", { strikethrough = true })
				-- vim.api.nvim_set_hl(0, "@lsp.typemod.function.async", { fg = "Blue" })
			end,
		})

		vim.cmd([[colorscheme tokyonight]])
	end,
}
