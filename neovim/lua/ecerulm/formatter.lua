local status, formatter = pcall(require, "formatter")
if not status then
	return
end

-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		lua = require("formatter.filetypes.lua").stylua,
		json = require("formatter.filetypes.json").jq,
		terraform = require("formatter.filetypes.terraform").terraformfmt, -- https://github.com/mhartington/formatter.nvim/blob/master/lua/formatter/filetypes/terraform.lua
		python = require("formatter.filetypes.python").black, -- https://github.com/mhartington/formatter.nvim/blob/91651e6afaf6f73b0ffb8b433c06cd4e06f90403/lua/formatter/filetypes/python.lua#L34-L40
		ruby = require("formatter.filetypes.ruby").rubocop,

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
