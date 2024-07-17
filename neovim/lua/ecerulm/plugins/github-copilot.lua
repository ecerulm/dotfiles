return {
	-- https://github.com/github/copilot.vim/blob/release/doc/copilot.txt
	"github/copilot.vim",
	enabled = THISMACHINESETTINGS["copilot_enabled"], -- THIS IS DISABLED
	lazy = false,
	config = function()
		vim.keymap.set("i", "<M-l>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
		})
		vim.g.copilot_no_tab_map = true
	end,
}
