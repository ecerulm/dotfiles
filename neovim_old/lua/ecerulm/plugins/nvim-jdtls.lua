return {
	-- https://github.com/mfussenegger/nvim-jdtls
	"mfussenegger/nvim-jdtls", -- Eclipse JDT language server , Java language server
	enabled = true,
	cond = true,
	lazy = false,
	dependencies = {
		{ "neovim/nvim-lspconfig" },
	},
	config = function() end,
}
