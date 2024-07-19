return {
	-- https://github.com/Exafunction/codeium.vim?tab=readme-ov-file
	"Exafunction/codeium.nvim", -- beware there is Exafunction/codeium.vim and codeium.nvim they are different
	enabled = THISMACHINESETTINGS.codeium_nvim_enabled,
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	init = function()
		vim.g.codeium_log_file = "~/codeium.log"
		vim.g.codeium_log_level = "DEBUG"
	end,

	config = function()
    require("codeium").setup({
    })

		-- -- ACCEPT
		-- vim.keymap.set("i", "<M-l>", function()
		-- 	return vim.fn["codeium#Accept"]()
		-- end, { expr = true, silent = true })
		--
		-- -- NEXT SUGGESTION Alt-]
		-- vim.keymap.set("i", "<M-]>", function()
		-- 	return vim.fn["codeium#CycleCompletions"](1)
		-- end, { expr = true, silent = true })
		-- -- PREVIOUS SUGGESTION Alt-[
		-- vim.keymap.set("i", "<M-[>", function()
		-- 	return vim.fn["codeium#CycleCompletions"](-1)
		-- end, { expr = true, silent = true })
		--
		-- -- CANCEL C-[ / Escape
		-- vim.keymap.set("i", "<C-[>", function()
		-- 	return vim.fn["codeium#Clear"]()
		-- end, { expr = true, silent = true })
		--
	end,
}
