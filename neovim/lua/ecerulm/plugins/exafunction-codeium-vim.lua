return {
  -- https://github.com/Exafunction/codeium.vim
	"Exafunction/codeium.vim", -- beware codedium.vim and codeium.nvim are different
	enabled = THISMACHINESETTINGS.codeium_vim_enabled,
	lazy = false,
	dependencies = {
	},


	init = function()
		vim.g.codeium_log_file = "~/codeium.log"
		vim.g.codeium_log_level = "DEBUG"
	end,

	config = function()
		 -- ACCEPT
		 vim.keymap.set("i", "<M-l>", function()
		 	return vim.fn["codeium#Accept"]()
		 end, { expr = true, silent = true })

		 -- NEXT SUGGESTION Alt-]
		 vim.keymap.set("i", "<M-]>", function()
		 	return vim.fn["codeium#CycleCompletions"](1)
		 end, { expr = true, silent = true })

		 -- PREVIOUS SUGGESTION Alt-[
		 vim.keymap.set("i", "<M-[>", function()
		 	return vim.fn["codeium#CycleCompletions"](-1)
		 end, { expr = true, silent = true })

		 -- CANCEL C-[ / Escape
		 vim.keymap.set("i", "<C-[>", function()
		 	return vim.fn["codeium#Clear"]()
		 end, { expr = true, silent = true })

	end,
}
