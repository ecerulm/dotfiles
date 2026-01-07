vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/stevearc/conform.nvim",
})

-- nvim-lspconfig

-- lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
vim.lsp.enable("lua_ls")

-- nvim-treesitter , provides syntax highlighting groups, folding and indentation based on treesitter queries
-- https://github.com/nvim-treesitter/nvim-treesitter
require("nvim-treesitter").install({
	"lua",
	"c",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"gowork",
	"hcl",
	"terraform",
	"python",
	"vim",
	"vimdoc",
	"yaml",
	"toml",
	"json",
	"json5",
	"jsonnet",
	"zsh",
	"bash",
	"dart",
	"git_config",
	"gitignore",
}) -- languages to install https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md

-- format / formatting / formatter conform.nvim
require("conform").setup({
	formatters_by_ft = { -- :h conform-formaters for a list of formatters, :ConformInfo to see configured formatters
		-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
		lua = { "stylua" }, -- brew install stylua
		python = { "isort", "black" }, -- brew install isort black
		terraform = { "terraform_fmt" }, -- terraform fmt comes with terraform
		go = { "gofmt" }, -- go fmt comes with golang
	},
	format_on_save = {
		timeout_ms = 1500,
		lsp_format = "fallback",
	},
})
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()" -- enables gq , like gqae

-- Keymaps
vim.keymap.set("i", "jk", "<Esc>")

-- textobject / text objects / text-objects / motions
vim.keymap.set({ "o", "v" }, "ae", ":<C-u>normal! m'ggVG<cr>", { noremap = true, silent = true }) -- "o" is the operator pending mode :help omap-info, :help mapmode-o

-- global options
vim.opt.clipboard = "unnamedplus" -- paste from system clipboard
vim.opt.foldlevel = 3 -- zi disable folding, za toggle fold on current line, zc close fold, zR open recursive, zM close recursive, zv reveal cursor

--
