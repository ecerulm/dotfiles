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
		-- LSP Management
		-- https://github.com/williamboman/mason.nvim
		{ "williamboman/mason.nvim" },
		-- https://github.com/williamboman/mason-lspconfig.nvim
		{ "williamboman/mason-lspconfig.nvim" },

		-- Useful status updates for LSP
		-- https://github.com/j-hui/fidget.nvim
		{ "j-hui/fidget.nvim", opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		-- https://github.com/folke/neodev.nvim
		{ "folke/neodev.nvim" },
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			-- Install these LSPs automatically
			ensure_installed = {
				-- 'bashls', -- requires npm to be installed
				-- 'cssls', -- requires npm to be installed
				-- 'html', -- requires npm to be installed
				"lua_ls",
				-- 'jsonls', -- requires npm to be installed
				"lemminx",
				"marksman",
				"quick_lint_js",
				-- 'tsserver', -- requires npm to be installed
				-- 'yamlls', -- requires npm to be installed
				"rust_analyzer",
				"pyright", -- python LSP
				"pylsp", -- python LSP / python-lsp-server pylsp
				"terraformls",
				"jdtls", -- java language server LSP
				"gopls",
			},
		})

		local lspconfig = require("lspconfig")
		local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- now you approach is only start_or_attach from the ftpluing/xxx.lua
		-- delay as much as you can

		-- local lsp_attach = function(client, bufnr)
		-- if client.server_capabilities.documentSymbolProvider then
		-- require("navic").attach(client, bufnr)
		-- end
		-- 	-- Create your keybindings here...
		-- end

		-- Call setup on each LSP server
		-- require("mason-lspconfig").setup_handlers({
		-- 	function(server_name)
		-- 		lspconfig[server_name].setup({
		-- 			-- on_attach = lsp_attach,
		-- 			capabilities = lsp_capabilities,
		-- 		})
		-- 	end,
		-- })

		-- Lua LSP settings
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
				},
			},
		})

		-- Python LSP
		-- code formatting: no
		-- lsp_workspace_symbols: yes
		vim.lsp.config("pyright", {})
		vim.lsp.enable("pyright") -- pylsp does provide code formatting

		-- Python LSO - pylsp
		-- code formatting: yes
		-- symbols, go to definition: not very good
		-- no lsp_workspace_symbols only sumbols local file
		vim.lsp.config("pylsp", {
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = {
							ignore = { "W391" },
							maxLineLength = 100,
						},
					},
				},
			},
		})
		vim.lsp.enable("pylsp")


    -- DART
    -- dart comes LSP server dart language-server --protocol=lsp
    vim.lsp.enable('dartls')


		-- require("lspconfig").terraformls.setup({})
		-- require("lspconfig").gopls.setup({})
		-- require("lspconfig").metals.setup({}) -- use nvim-metals instead

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
		-- require("jdtls").jdtls.setup({}) -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/jdtls.lua you are using nvim-jdtls instead

		-- require("lspconfig").jdtls.setup({}) -- we moved the loading of to the ~/.config/nvim/ftplugin/java.lua

		-- Globally configure all LSP floating preview popups (like hover, signature help, etc)
		-- local open_floating_preview = vim.lsp.util.open_floating_preview
		-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		-- 	opts = opts or {}
		-- 	opts.border = opts.border or "rounded" -- Set border to rounded
		-- 	return open_floating_preview(contents, syntax, opts, ...)
		-- end
	end,
}
