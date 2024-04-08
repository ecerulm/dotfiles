-- Add, Change, Delete Surrounding Chars (["''"])
return {
	-- https://github.com/kylechui/nvim-surround
	-- it's like tpope/vim-surround but using Lua instead of Vimscript
	-- also supports treesitter nodes
	-- ysiw)  surround word with ()
	--
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	opts = {},
}
