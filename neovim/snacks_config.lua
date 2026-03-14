local modname = ... -- the three dots are varargs
local M = {} -- you use M in this module
_G[modname] = M -- adds M to the globals with name modname

function M.setup()
	-- Snacks.nvim / pickers / telescope
	require("snacks").setup({
		gitbrowse = {
			remote_patterns = {
				{ "^(https?://.*)%.git$", "%1" },
				{ "^git@github%-ecerulm:(.+)%.git$", "https://github.com/%1" }, -- %- escapes the `-` as it has special meaning in a regex
				{ "^git@(.+):(.+)%.git$", "https://%1/%2" },
				{ "^git@(.+):(.+)$", "https://%1/%2" },
				{ "^git@(.+)/(.+)$", "https://%1/%2" },
				{ "^org%-%d+@(.+):(.+)%.git$", "https://%1/%2" },
				{ "^ssh://git@(.*)$", "https://%1" },
				{ "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
				{ "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
				{ "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
				{ "^https://%w*@(.*)", "https://%1" },
				{ "^git@(.*)", "https://%1" },
				{ ":%d+", "" },
				{ "%.git$", "" },
			},
		},
		picker = {},
	})

	-- copy github remote link / copy remote url
	vim.keymap.set({ "n", "v" }, "<leader>gc", function()
		Snacks.gitbrowse({
			notify = true,
			open = function(url)
				-- vim.fn.setreg("*", url) -- PRIMARY selection :h quotestar
				vim.fn.setreg("+", url) -- CLIPBOARD selection :h quoteplus
			end,
		})
	end, { desc = "Git Browse" })

	vim.keymap.set({ "n", "v" }, "<leader>gB", function()
		Snacks.gitbrowse()
	end, { desc = "Git Browse" })

	-- vim.keymap.set({ "n", "v" }, "<leader>gb", function()
	-- 	Snacks.git.blame_line()
	-- end, { desc = "Git Blame" })

	-- snacks.nvim pickers
	vim.keymap.set("n", "<leader>fb", function()
		Snacks.picker.buffers()
	end, { desc = "Find buffers" })
	vim.keymap.set("n", "<leader>ff", function()
		Snacks.picker.files()
	end, { desc = "Find files" })
	vim.keymap.set("n", "<leader>fg", function()
		Snacks.picker.git_files()
	end, { desc = "Find Git tracked files in the whole repo" })
	vim.keymap.set("n", "<leader>fr", function()
		Snacks.picker.recent()
	end, { desc = "Recent files" })
	vim.keymap.set("n", "<leader>fp", function()
		Snacks.picker.projects({
			finder = "recent_projects",
			dev = {
				"~/git/personal",
				"~/git/work",
			},
			max_depth = 3,
			patterns = { ".git", "Makefile", "pyproject.toml", ".test" },
			recent = false, --  include project directories of recent files
		})
	end, { desc = "Recent projects" })

	--
	-- snacks.nvim git pickers
	--
	vim.keymap.set("n", "<leader>gb", function()
		Snacks.picker.git_branches()
	end, { desc = "Git Branches" })

	vim.keymap.set("n", "<leader>gl", function()
		Snacks.picker.git_log()
	end, { desc = "Git Log" })

	vim.keymap.set("n", "<leader>gL", function()
		Snacks.picker.git_log_line()
	end, { desc = "Git Log Line, show commits that affect this line" })

	vim.keymap.set("n", "<leader>gs", function()
		Snacks.picker.git_status()
	end, { desc = "Git status" })

	vim.keymap.set("n", "<leader>gS", function()
		Snacks.picker.git_stash()
	end, { desc = "Git stash" })

	vim.keymap.set("n", "<leader>gd", function()
		Snacks.picker.git_diff()
	end, { desc = "Git diff (hunks)" })

	vim.keymap.set("n", "<leader>gf", function()
		Snacks.picker.git_log_file()
	end, { desc = "Git Log file, show commits that affects this file" })

	vim.keymap.set("n", "<leader>gf", function()
		Snacks.picker.git_log_file()
	end, { desc = "Git Log file, show commits that affects this file" })

	vim.keymap.set("n", "<leader>gg", function()
		Snacks.picker.lazygit()
	end, { desc = "Lazygit UI" })

	-- snacks.nvim search pickers

	vim.keymap.set("n", "<leader>sd", function()
		Snacks.picker.diagnostics()
	end, { desc = "Search diagnostics" })

	vim.keymap.set("n", "<leader>sD", function()
		Snacks.picker.diagnostics_buffer()
	end, { desc = "Search diagnostics in this buffer" })

	vim.keymap.set("n", "<leader>sh", function()
		Snacks.picker.help()
	end, { desc = "Search help pages" })

	vim.keymap.set("n", "<leader>sk", function()
		Snacks.picker.keymaps()
	end, { desc = "Search vim keymaps / keyboards shortcut" })

	-- snacks.nvim other keymaps
	vim.keymap.set("n", "<leader>cR", function()
		Snacks.rename.rename_file()
	end, { desc = "Rename file" })

	vim.keymap.set("n", "<leader>.", function()
		Snacks.scratch()
	end, { desc = "Toggle Scratch buffer" })

	vim.keymap.set("n", "<leader>n", function()
		Snacks.notifier.show_history()
	end, { desc = "Show notification history / error messages" })
	vim.keymap.set("n", "<leader>un", function()
		Snacks.notifier.hide()
	end, { desc = "Dismiss all notifications / error messages" })

	-- snacks.nvim grep / search inside files

	vim.keymap.set("n", "<leader>/", function()
		Snacks.picker.grep()
	end, { desc = "Grep in all files" })
	vim.keymap.set("n", "<leader>sg", function()
		Snacks.picker.grep()
	end, { desc = "Grep in all files" })
	vim.keymap.set("n", "<leader>sb", function()
		Snacks.picker.lines()
	end, { desc = "Grep in this buffer" })
	vim.keymap.set("n", "<leader>sB", function()
		Snacks.picker.grep_buffers()
	end, { desc = "Grep in all open buffers" })
	vim.keymap.set({ "n", "x" }, "<leader>sw", function()
		Snacks.picker.grep_word()
	end, { desc = "Visual selection or word" })

	-- toggle options like with vim-unimpaired
	Snacks.toggle.option("list", { name = "List" }):map("yol")
	Snacks.toggle.option("number", { name = "Line Numbers" }):map("yon")
	Snacks.toggle.option("relativenumber", { name = "Relative Line Numbers" }):map("yor")
	Snacks.toggle.option("hlsearch", { name = "Highlight search" }):map("yoh")
	Snacks.toggle.option("wrap", { name = "wrap line" }):map("yow")
	Snacks.toggle.diagnostics():map("<leader>ud") -- keymap to enable disable diagnostics

	Snacks.toggle.treesitter():map("<leader>uT") -- keymap to enable disable treesitter
end

return M
