local modname = ... -- the three dots are varargs
local M = {} -- you use M in this module
_G[modname] = M -- adds M to the globals with name modname

function M.setup()
	-- test
	vim.pack.add({

		"https://github.com/nvim-mini/mini.nvim",
		--  mini.completion, mini.align
	})
	require("mini.icons").setup()
	-- require("mini.git").setup() -- 2026-03-14 disabled because you are trying gitsigns.nvim
	vim.g.minigit_disable = true

	require("mini.trailspace").setup()
	vim.api.nvim_create_user_command("TrimTrailingWhitespace", function(args) -- adds :TrimTrailingWhitespace command
		MiniTrailspace.trim()
	end, {})

	require("mini.align").setup() -- gAiP :h MiniAlign-modifiers-builtin and :h MiniAlign-examples.
	require("mini.comment").setup() --  gc, gcc
	-- require("mini.ai").setup() -- balanced textobjects
	require("mini.move").setup() -- Alt + hjkl

	-- mini.operators
	-- the mini.operators gx overrides the gx that you used for open url link under cursor
	-- replace with gr, grr (gr conflict with grn for rename)  / you changed the prefix from gr to cr
	-- exchange text regions gx / sort gs / multiply gm / swap text
	require("mini.operators").setup({
		replace = { prefix = "cr" },
		--exchange text regions
		exchange = {
			prefix = "cx", -- same as vim-exchange
			reindent_linewise = true,
		},
	})

	-- mini.operators / :h MiniSnippets-examples
	-- trigger<c-j>
	-- next tabstop <c-l>
	-- prev tabstop <c-h>
	local gen_loader = require("mini.snippets").gen_loader
	require("mini.snippets").setup({
		snippets = {
			-- Load custom file with global snippets first
			gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),

			-- Load snippets based on current language by reading files from
			-- "snippets/" subdirectories from 'runtimepath' directories.
			gen_loader.from_lang(),
		},
	})

	require("mini.splitjoin").setup() -- gS :h MiniSplitjoin
	require("mini.surround").setup() -- replaces nvim-surround / saw" / sd" / sr"'
	require("mini.bracketed").setup({
		comment = { suffix = "" }, -- no ]c, [c because we are using those for navigating to next change / next hunk
	}) -- b] , b[
	require("mini.files").setup({}) -- :lua MiniFiles.open()

	vim.keymap.set("n", "-", function()
		local buf_name = vim.api.nvim_buf_get_name(0)
		local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
		MiniFiles.open(path)
		MiniFiles.reveal_cwd()
	end, { desc = "Open Mini Files", unique = true })

	require("mini.statusline").setup({})
	require("mini.diff").setup() -- https://github.com/nvim-mini/mini.diff, :h MiniDiff-overview / [h prev hunk / ]h next hunk

	vim.keymap.set("n", "<leader>d", function()
		MiniDiff.toggle_overlay()
	end, { desc = "Toggle the mini.diff overlay", unique = true })

	require("mini.basics").setup({
		mappings = {
			basic = true,
			option_toggle_prefix = [[yo]], -- we are getting this from snacks.nvim also
		},
	}) -- prefix \w -> toggle wrap, this will change <leader> to <space>
	vim.g.mapleader = "\\" -- restore \ as <leader>, nvim.basics rewrites it with " " (space)
	vim.opt.mouse = ""
	vim.keymap.set("n", "<leader>m", function()
		vim.opt.mouse = (vim.opt.mouse == "" and "a" or "")
	end, { desc = "Toggle mouse", unique = true })

	require("mini.completion").setup({
		delay = { completion = 1000, info = 1000, signature = 1000 },
	})

	-- local align_blame = function(au_data)
	-- 	if au_data.data.git_subcommand ~= "blame" then
	-- 		return
	-- 	end
	--
	-- 	-- Align blame output with source
	-- 	local win_src = au_data.data.win_source
	-- 	vim.wo.wrap = false
	-- 	vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
	-- 	vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
	--
	-- 	-- Bind both windows so that they scroll together
	-- 	vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
	-- end
	-- local au_opts = { pattern = "MiniGitCommandSplit", callback = align_blame }
	-- vim.api.nvim_create_autocmd("User", au_opts)
end

return M
