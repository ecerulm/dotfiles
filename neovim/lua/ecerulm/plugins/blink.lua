-- For Lua development
return { -- optional blink completion source for require statements and module annotations
	-- https://github.com/Saghen/blink.cmp
	-- https://cmp.saghen.dev/
	-- completion plugin for LSPs, cmdline, signature help, and snippets
	"saghen/blink.cmp",
	version = "1.*",
	enabled = true,
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
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
			},
		},
    keymap = {
      -- https://cmp.saghen.dev/configuration/keymap#presets
      preset = 'default',
      -- <C-space> show the autocompletion menu
      -- <C-y> accept the completion
    },
	},
}
