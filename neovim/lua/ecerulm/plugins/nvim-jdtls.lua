return {
	-- https://github.com/mfussenegger/nvim-jdtls
	"mfussenegger/nvim-jdtls", -- Eclipse JDT language server , Java language server
	enabled = true,
	cond = true,
	lazy = false,
	dependencies = {
		{ "neovim/nvim-lspconfig" },
	},
	config = function()
		-- local jdtls = require("jdtls")
		-- local on_attach = function(client, bufnr)
		-- 	if client.server_capabilities.documentSymbolProvider then
		-- 		jdtls.setup_dap()
		-- 	end
		-- end
		-- require("lspconfig").jdtls.setup({
		-- 	on_attach = on_attach,
		-- })
	end,
}
