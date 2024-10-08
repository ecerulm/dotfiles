return {
	-- https://github.com/williamboman/mason-lspconfig.nvim
	"williamboman/mason-lspconfig.nvim",
	enabled = true,
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
		},
		automatic_installation = false,
	},
}
