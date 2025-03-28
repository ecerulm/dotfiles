function file_exists(name)
	local f = io.open(name, "r")
	return f ~= nil
end


THISMACHINESETTINGS = {
	github_copilot_enabled = false, -- enables github/copilot
	zbirenbaum_copilot_enabled = false, -- enables zbirenbaum/copilot
	codeium_vim_enabled = false,
	codeium_nvim_enabled = false,
	colorscheme = "tokyonight-night", -- darker
}

local function source_file_if_exists(file_path)
	local file = io.open(file_path, "r")
	if file then
		io.close(file)
		dofile(file_path)
	end
end

source_file_if_exists(vim.fn.stdpath("config") .. "/init.thismachine.lua")

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
--- Initialize lazy with dynamic loading of anything in the plugins directory

require("lazy").setup("ecerulm.plugins", {
	-- https://github.com/folke/lazy.nvim
	dev = {
		path = "~/git",
	},
	change_detection = {
		enabled = true, -- automatically check for config file changes and reload the ui
		notify = true, -- turn off notifications whenever plugin changes are made
	},
})

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
require("ecerulm.keymaps")
require("ecerulm.skeletons")
require("ecerulm.harpoon2") -- configure telescope.nvim if it's loaded
require("ecerulm.rename").setup()
require("ecerulm.commands")

if vim.fn.has("macunix") then
	require("ecerulm.macos")
end

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

vim.filetype.add({
	extension = {
		tf = "terraform",
	},
})
