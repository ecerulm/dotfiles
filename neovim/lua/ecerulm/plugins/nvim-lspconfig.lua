-- LSP Support
return {
	-- LSP Configuration
	-- https://github.com/neovim/nvim-lspconfig
	"neovim/nvim-lspconfig",
	enabled = true,
	cond = true,
	lazy = false,
	-- event = "VeryLazy",
	dependencies = {
		-- Useful status updates for LSP
		-- https://github.com/j-hui/fidget.nvim
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		-- vim.lsp.enable("pyright")
		vim.lsp.enable("pylsp")
	end,
}
