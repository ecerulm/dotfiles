vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/snacks.nvim",
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

-- Snacks.nvim / pickers / telescope
require("snacks").setup({
	gitbrowse = {
		remote_patterns = {
			{ "^(https?://.*)%.git$", "%1" },
			{ "^git@github%-ecerulm:(.+)%.git$", "https://github.com/%1" }, -- %- escapes the `-` as it has special meaning in a regex
			{ "^git@(.+):(.+)%.git$", "https://%1/%2" },
			{ "^git@(.+):(.+)$", "https://%1/%2" },
			{ "^git@(.+)/(.+)$", "https://%1/%2" },
			{ "^org%-%d+@(.+):(.+)%.git$", "https://%1/%2" },
			{ "^ssh://git@(.*)$", "https://%1" },
			{ "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
			{ "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
			{ "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
			{ "^https://%w*@(.*)", "https://%1" },
			{ "^git@(.*)", "https://%1" },
			{ ":%d+", "" },
			{ "%.git$", "" },
		},
	},
	picker = {},
})

-- Keymaps
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set({ "n", "v" }, "<leader>gB", function()
	Snacks.gitbrowse()
end, { desc = "Git Browse" })

-- vim.keymap.set({ "n", "v" }, "<leader>gb", function()
-- 	Snacks.git.blame_line()
-- end, { desc = "Git Blame" })

-- snacks.nvim pickers
vim.keymap.set("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function()
	Snacks.picker.git_files()
end, { desc = "Find Git tracked files in the whole repo" })
vim.keymap.set("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fp", function()
	Snacks.picker.projects({
		finder = "recent_projects",
		dev = {
			"~/git/personal",
			"~/git/work",
		},
		max_depth = 3,
		patterns = { ".git", "Makefile", "pyproject.toml", ".test" },
		recent = false, --  include project directories of recent files
	})
end, { desc = "Recent projects" })

-- textobject / text objects / text-objects / motions
vim.keymap.set({ "o", "v" }, "ae", ":<C-u>normal! m'ggVG<cr>", { noremap = true, silent = true }) -- "o" is the operator pending mode :help omap-info, :help mapmode-o

-- global options
vim.opt.clipboard = "unnamedplus" -- paste from system clipboard
vim.opt.foldlevel = 3 -- zi disable folding, za toggle fold on current line, zc close fold, zR open recursive, zM close recursive, zv reveal cursor

--
