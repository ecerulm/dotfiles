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
	change_detection = {
		enabled = true, -- automatically check for config file changes and reload the ui
		notify = false, -- turn off notifications whenever plugin changes are made
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
require("ecerulm.filetypes")
require("ecerulm.harpoon2") -- configure telescope.nvim if it's loaded

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

