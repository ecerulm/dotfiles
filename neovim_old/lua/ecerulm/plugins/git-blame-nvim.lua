-- Git Blame
-- :GitBlameToggle

-- This functionality is already provided by snacks.nvim
-- see https://github.com/folke/snacks.nvim/blob/main/docs/git.md
-- Snacks.git.blame_line()
return {
	-- https://github.com/f-person/git-blame.nvim
	--
	"f-person/git-blame.nvim",
	enabled = true,
	lazy = false,
	-- event = 'VeryLazy',
	opts = {
		enabled = false,     -- disable by default, enabled only on keymap
		date_format = "%m/%d/%y %H:%M:%S", -- more concise date format
	},
}
