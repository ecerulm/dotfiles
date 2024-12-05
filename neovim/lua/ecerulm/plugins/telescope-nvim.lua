-- Fuzzy finder
return {
	-- https://github.com/nvim-telescope/telescope.nvim
	"nvim-telescope/telescope.nvim",
	-- dev = vim.fn.isdirectory(vim.fn.expand("~/git/telescope.nvim")), -- if ~/git/telescope.nvim exists will use that
  -- dev = true,
	enabled = true,
	lazy = false,
	cmd = "Telescope",
	-- branch = "0.1.x",
	dependencies = {
		-- https://github.com/nvim-lua/plenary.nvim
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
	opts = {
		defaults = {
			layout_config = {
				vertical = {
					width = 0.75,
				},
			},
		},
	},
	config = function()
		local actions = require("telescope.actions")

		function telescope_buffer_dir()
			return vim.fn.expand("%:p:h")
		end

		local fb_actions = require("telescope").extensions.file_browser.actions
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = {
					"^jdt://",
					-- "^app/",
				},
				mappings = {
					n = {
						["q"] = actions.close,
					},
					i = {
						["<esc>"] = actions.close,
					},
				},
				-- :h telescope.defaults.path_display
				path_display = { "filename_first" },
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
				-- removed file_browser because you are using nvim-tree
				-- file_browser = {
				-- 	theme = "dropdown",
				-- 	-- disable netrw and use telescope-file-browser instead
				-- 	hijack_netrw = true,
				-- 	mappings = {
				-- 		["i"] = {
				-- 			["C-w"] = function()
				-- 				vim.cmd("normal vbd")
				-- 			end,
				-- 		},
				-- 		["n"] = {
				-- 			["N"] = fb_actions.create,
				-- 			["h"] = fb_actions.goto_parent_dir,
				-- 			["/"] = function()
				-- 				vim.cmd("startinsert")
				-- 			end,
				-- 		},
				-- 	},
				-- },
			},
		})
		-- require('telescope').load_extension("file_browser") -- removed because you are using nvim-tree
		require("telescope").load_extension("ui-select")
	end,
}
