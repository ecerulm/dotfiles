-- For Lua development
return { -- optional blink completion source for require statements and module annotations
	-- https://github.com/Saghen/blink.cmp
	-- https://cmp.saghen.dev/
	-- completion plugin for LSPs, cmdline, signature help, and snippets
	"saghen/blink.cmp",
	version = "1.*",
	enabled = true,
	dependencies = {
		"fang2hou/blink-copilot",
		"disrupted/blink-cmp-conventional-commits",
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
			-- add lazydev to your completion providers
			default = {
				"conventional_commits",
				"copilot",
				"lsp",
				"path",
				"snippets",
				"buffer",
			},

			per_filetype = {
				lua = { inherit_defaults = true, "lazydev" },
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
					enabled = function()
						return vim.bo.filetype == "gitcommit"
					end,
					---@module 'blink-cmp-conventional-commits'
					---@type blink-cmp-conventional-commits.Options
					opts = {}, -- none so far
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
