-- DiSABLEd. This is not useful anymore
-- You install the lsp servers with mason (not mason-lspconfig)
-- you enable the lsp servers in nvim-lspconfig

return {
	-- https://github.com/williamboman/mason-lspconfig.nvim
	"williamboman/mason-lspconfig.nvim",
	enabled = false,
	lazy = false,
	dependencies = {
		"williamboman/mason.nvim",
	},
	opts = {
		ensure_installed = { -- LSP servers
			"jsonls", -- :LspInstall jsonls
			"clangd", -- :LspInstall clangd
			"lua_ls",
			"ansiblels",
			"pyright",
			"pylsp", -- python-lsp-server
		},
		automatic_installation = false,
	},
}
