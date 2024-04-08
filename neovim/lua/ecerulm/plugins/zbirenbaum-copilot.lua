return {
	"zbirenbaum/copilot.lua",
	-- lazy = true,
	enabled = true,
	lazy = false,
	cmd = "Copilot",
	event = "InsertEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		-- require("copilot").setup({
		--   panel = {
		--     auto_refresh = false,
		--     keymap = {
		--       accept = "<CR>",
		--       jump_prev = "[[",
		--       jump_next = "]]",
		--       refresh = "gr",
		--       open = "<M-CR>",
		--     },

		--   },
		--   suggestion = {
		--     auto_trigger = false,
		--     keymap = {
		--       accept = false,
		--       accept_word = "<M-Right>",
		--       accept_line = "<M-Down>",
		--       prev = "M-[",
		--       next = "M-]",
		--       dismiss = "<C-]>",
		--     },
		--   },
		-- })

		-- local suggestion = require("copilot.suggestion")
		-- vim.keymap.set("i", "<M-l>", function()
		--   if suggestion.is_visible() then
		--     suggestion.accept()
		--   else
		--     suggestion.next()
		--   end
		-- end, {desc = "[copilot] accepts or next suggestion"})
		require("copilot").setup({
			suggestion = { enabled = false },
			panel = { enabled = false },
		})
	end,
}
