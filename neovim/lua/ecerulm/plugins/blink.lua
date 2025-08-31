-- For Lua development
return { -- optional blink completion source for require statements and module annotations
	-- https://github.com/Saghen/blink.cmp
	-- https://cmp.saghen.dev/
	-- completion plugin for LSPs, cmdline, signature help, and snippets
	"saghen/blink.cmp",
	version = "1.*",
	enabled = true,
	dependencies = {
		-- https://cmp.saghen.dev/configuration/sources.html
		"fang2hou/blink-copilot",
		"disrupted/blink-cmp-conventional-commits",
		"Dynge/gitmoji.nvim", -- https://github.com/Dynge/gitmoji.nvim/
	},
	opts = {
		completion = {
			menu = {
				auto_show = false,
			},
			ghost_text = {
				enabled = true,
			},
		},
		sources = {
			-- https://cmp.saghen.dev/configuration/sources.html
			-- add lazydev to your completion providers
			default = {
				"copilot",
				"lsp",
				"path",
				"snippets",
				"buffer",
			},

			per_filetype = {
				lua = { inherit_defaults = true, "lazydev" },
				gitcommit = { inherti_defaults = true, "gitmoji", "conventional_commits" },
				jj = { inherti_defaults = true, "gitmoji", "conventional_commits" },
			},

			providers = {
				-- https://cmp.saghen.dev/configuration/sources.html#providers
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
				conventional_commits = {
					name = "Conventional Commits",
					module = "blink-cmp-conventional-commits",
					-- enabled = function()
					-- 	return vim.bo.filetype == "gitcommit"
					-- end,
					---@module 'blink-cmp-conventional-commits'
					---@type blink-cmp-conventional-commits.Options
					opts = {}, -- none so far
				},
				gitmoji = {
					name = "gitmoji",
					module = "gitmoji.blink",
					opts = { -- gitmoji config values goes here
						filetypes = { "gitcommit", "jj" },
					},
				},
			},
		},
		keymap = {
			-- https://cmp.saghen.dev/configuration/keymap#presets
			preset = "default",
			-- <C-space> show the autocompletion menu
			-- <C-y> accept the completion
		},
	},
}
