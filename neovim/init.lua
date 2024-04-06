local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- local plugins = require("ecerulm.plugins")

---[[
local plugins = {
	{ "morhetz/gruvbox", lazy=false, },
	{ "lewis6991/gitsigns.nvim" },
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-rhubarb" },
	{ "shumphrey/fugitive-gitlab.vim" },
	{ 
    "nvim-treesitter/nvim-treesitter",
  },
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{
		"LukasPietzschmann/telescope-tabs",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope-tabs").setup({})
		end,
	},
	{ "mfussenegger/nvim-lint" },
	{ "tpope/vim-commentary" },
	{ "kylechui/nvim-surround" },
	{ "tommcdo/vim-exchange" },
	{ "dstein64/vim-startuptime" },
	{ "AndrewRadev/switch.vim" },
	{ "mhartington/formatter.nvim" },
	{ "github/copilot.vim" },
	{ "junegunn/vim-easy-align" },
	{ "tpope/vim-unimpaired" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "MattesGroeger/vim-bookmarks" },
	{ "tom-anders/telescope-vim-bookmarks.nvim" },
	{ "nvim-telescope/telescope-symbols.nvim" },
	{ "neovim/nvim-lspconfig" },

}
--]]

require("lazy").setup(plugins, {})

---[[
local manpath =
	{ -- we overwrite the system $MANPATH because sometime can contain too many path and it takes forever for apropos to give any output
		"/usr/share/man",
		"/usr/local/share/man",
		"/opt/homebrew/share/man",
	}
vim.env.MANPATH = table.concat(manpath, ":") -- let $MANPATH="/usr/share/man" -- :help vim.env

-- require("ecerulm.plugins")
require("ecerulm.base")
require("ecerulm.highlights")
require("ecerulm.maps")
require("ecerulm.skeletons")
require("ecerulm.filetypes")
require("ecerulm.linters")
require("ecerulm.mason")
require("ecerulm.lsp")
require("ecerulm.formatter") -- configure mhartington/formatter.nvim if it's loaded
require("ecerulm.treesitter") -- configure nvim-treesitter if it's loaded
require("ecerulm.harpoon2") -- configure telescope.nvim if it's loaded

require("ecerulm.telescope")
require("telescope").load_extension("vim_bookmarks")

if vim.fn.has("macunix") then
	require("ecerulm.macos")
end

-- local formatAutoGroup = vim.api.nvim_create_augroup("FormatAutoGroup", {clear = true})
-- vim.api.nvim_create_autocmd(
--   {"BufWritePost"}, -- events to react to
--   {
--     command = "FormatWrite",
--     group = formatAutoGroup,
--   }

-- )

-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
--   pattern = {"*.tf", "*.tfvars"},
--   callback = function()
--     vim.lsp.buf.format()
--   end,
-- })
--

local function source_file_if_exists(file_path)
	local file = io.open(file_path, "r")
	if file then
		io.close(file)
		dofile(file_path)
	end
end

source_file_if_exists(vim.fn.stdpath("config") .. "/init.thismachine.lua")

-- vim.g.fugitive_gitlab_domains = { "gitlab.com" }
-- vim.cmd("echom g:fugitive_gitlab_domains")
--]]
