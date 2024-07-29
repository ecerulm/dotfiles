-- Code Tree Support / Syntax Highlighting
return {
	-- https://github.com/nvim-treesitter/nvim-treesitter
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	cond = true,
	lazy = false,
	event = "VeryLazy",
	dependencies = {
		-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	build = ":TSUpdate",
	opts = {
		highlight = {
			enable = true,
			disable = {},
		},
		-- treesitter indentation is EXPERIMENTAL
		-- setting indent.enable will change indentexpr=nvim_treesitter#indent()
		-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#indentation
		indent = { enable = false },
		auto_install = false,
		sync_install = false,
		ignore_install = {},
		ensure_installed = {
			"java",
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"tsx",
			"toml",
			"fish",
			"php",
			"json",
			"jsonnet",
			"yaml",
			"swift",
			"css",
			"html",
			"lua",
			"hcl",
			"python",
			"go",
			"terraform",
		},
		autotag = {
			enable = true,
		},
		playground = {
			enable = true,
			disable = {},
			updatetime = 25,
			persist_queries = false,
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
		textobjects = {
			select = {
				enable = true,

				lookahead = true,

				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["ia"] = "@parameter.inner",
					["aa"] = "@parameter.outer",
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
				include_surrounding_whitespace = true,
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},
		incremental_selection = {
			enable = false, -- this conflic with neovim LSP grn, gra, grr, TODO find new mappings /keymaps
			keymaps = {
				-- init_selection = "gnn", -- these conflict with neovim LSP grn , gra, grr
				-- node_incremental = "grn",
				-- scope_incremental = "grc",
				-- node_decremental = "grm",
			},
		},
	},
	config = function(_, opts)
		local configs = require("nvim-treesitter.configs")
		configs.setup(opts)
	end,
}
