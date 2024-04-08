return {
	-- https://github.com/github/copilot.vim/blob/release/doc/copilot.txt
	"github/copilot.vim",
	enabled = true,
	lazy = false,
	config = function()
		vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
		})
		vim.g.copilot_no_tab_map = true
	end,
}
