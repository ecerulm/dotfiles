return {
  -- https://github.com/zbirenbaum/copilot.lua
  -- Preferred over github/copilot.vim because
  -- it is more configurable, 
	"zbirenbaum/copilot.lua",

	enabled = true,
  cond = THISMACHINESETTINGS.zbirenbaum_copilot_enabled and not THISMACHINESETTINGS.github_copilot_enabled,
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

    local as_nvim_cmp = THISMACHINESETTINGS.zbirenbaum_copilot_as_nvim_cmp
    local suggestion_enabled = not as_nvim_cmp

		require("copilot").setup({
			suggestion = {
				enabled = suggestion_enabled,
				auto_trigger = true,

				-- default keymaps
				keymap = {
					accept = "<M-l>", -- defaut: "<M-l>" left alt + l
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-[>",
				},
			},
			panel = {
				enabled = suggestion_enabled,
        auto_refresh = false,
				keymap = {
					accept = "<CR>",
					jump_prev = "[[",
					jump_next = "]]",
					refresh = "gr",
					open = "<M-CR>", -- default: "<M-CR>" left alt + enter, only while on insert mode
				},
			},
		})
	end,
}
