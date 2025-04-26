local enabled = THISMACHINESETTINGS.github_copilot_enabled and not THISMACHINESETTINGS.zbirenbaum_copilot_enabled

return {
	-- https://github.com/github/copilot.vim/blob/release/doc/copilot.txt
	"github/copilot.vim",
	enabled = true,
	cond = enabled,
	lazy = false,
	config = function()
		vim.keymap.set("i", "<M-l>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
		})
		vim.g.copilot_no_tab_map = true
	end,
}
