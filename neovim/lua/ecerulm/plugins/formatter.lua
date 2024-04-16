return {
	"mhartington/formatter.nvim",
	enabled = true,
	lazy = false,
	cmd = "Format",
	config = function()
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
				python = {
					require("formatter.filetypes.python").black, -- https://github.com/mhartington/formatter.nvim/blob/91651e6afaf6f73b0ffb8b433c06cd4e06f90403/lua/formatter/filetypes/python.lua#L34-L40
					require("formatter.filetypes.python").isort,
				},
				ruby = require("formatter.filetypes.ruby").rubocop,
				go = {
					require("formatter.filetypes.go").gofmt,
					-- require("formatter.filetypes.go").goimports,
					-- require("formatter.filetypes.go").gofumpt,
					-- require("formatter.filetypes.go").golines,
				},

				-- Use the special "*" filetype for defining formatter configurations on
				-- any filetype
				["*"] = {
					-- "formatter.filetypes.any" defines default configurations for any
					-- filetype
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			},
		})
	end,
}
