return {
	"SmiteshP/nvim-navic",
	enabled = true,
	lazy = false,
	dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local navic = require("nvim-navic")
		local on_attach = function(client, bufnr)
			if client.server_capabilities.documentSymbolProvider then
				navic.attach(client, bufnr)
			end
		end
		require("lspconfig").clangd.setup({ -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/clangd.lua
			on_attach = on_attach, -- :LspInstall clangd
		})
		require("lspconfig").jsonls.setup({ -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/jsonls.lua
			on_attach = on_attach, -- :LspInstall jsonls
		})
		-- require("lspconfig").ansiblels.setup({ -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/jsonls.lua
		-- 	on_attach = on_attach, -- :LspInstall jsonls
		-- })
	end,
}
