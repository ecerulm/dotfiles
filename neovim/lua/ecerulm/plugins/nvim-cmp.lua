-- Auto-completion / Snippets
return {
	-- https://github.com/hrsh7th/nvim-cmp
	"hrsh7th/nvim-cmp",
	enabled = true,
	lazy = false,
	event = "InsertEnter",
	dependencies = {
		-- Snippet engine & associated nvim-cmp source
		-- https://github.com/L3MON4D3/LuaSnip
		"L3MON4D3/LuaSnip",
		-- https://github.com/saadparwaiz1/cmp_luasnip
		"saadparwaiz1/cmp_luasnip",

		-- LSP completion capabilities
		-- https://github.com/hrsh7th/cmp-nvim-lsp
		"hrsh7th/cmp-nvim-lsp",

		-- Additional user-friendly snippets
		-- https://github.com/rafamadriz/friendly-snippets
		"rafamadriz/friendly-snippets",
		-- https://github.com/hrsh7th/cmp-buffer
		"hrsh7th/cmp-buffer",
		-- https://github.com/hrsh7th/cmp-path
		"hrsh7th/cmp-path",
		-- https://github.com/hrsh7th/cmp-cmdline
		"hrsh7th/cmp-cmdline",
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local lspkind_cmp_format = lspkind.cmp_format({})
		require("luasnip.loaders.from_vscode").lazy_load()
		luasnip.config.setup({})

		local has_words_before = function()
			if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
				return false
			end
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
		end

		cmp.setup({
			experimental = {
				-- ghost_text={
				--   hl_group="Nontext",
				-- },
				ghost_text = true,
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = {
				autocomplete = false, -- manually trigger the completion with <C-Space>
				-- autocomplete = {
				--   cmp.TriggerEvent.InsertEnter,
				--   cmp.TriggerEvent.TextChanged,
				-- },
				completeopt = "menu,menuone,noinsert",
				-- completeopt = "menu,menuone,noinsert",
				-- :h 'completeopt'
				-- 	- menu / nomenu
				--   - Use a popup menu to show the possible completions. The menu is only shown when there is more than one match and sufficient colors arer available. :h ins-completion-menu
				-- - menuone
				--   - Use the popup menu also when ther is only one match . useful when there is additional information about the match  e.g.  what file it comes from
				-- - longest
				-- - preview
				--   - Show extra information about the currently selected compltion in the preview window
				--   - Only works in combination with menu or menuone
				-- - noinsert
				--   - Do not insert any text for a match until the user select a match from the menu. Only works in combination with menu or menuone
				--   - No effect if longest is present
				-- - noselect
				--   - Do not select a match in the menu, force the user to select one from the menu.
				--   - Only works in combination with menu or menuone

				-- - popup
				--   - Show extra information about the currently select completion in a popup window.
				--   - Only work in combination with menu or menuone
				--   - Overrides preview
			},
			mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4), -- scroll backward
				["<C-f>"] = cmp.mapping.scroll_docs(4), -- scroll forward
				["<C-Space>"] = cmp.mapping.complete({
					config = {
						sources = {
							{ name = "codeium" },
						},
					},
				}), -- show completion suggestions
				["<Tab>"] = cmp.mapping.complete({}), -- show completion suggestions
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				-- Tab through suggestions or when a snippet is active, tab to the next argument
				-- ['<Tab>'] = cmp.mapping(function(fallback)
				--   if cmp.visible() then
				--     cmp.select_next_item()
				--   elseif luasnip.expand_or_locally_jumpable() then
				--     luasnip.expand_or_jump()
				--   else
				--     fallback()
				--   end
				-- end, { 'i', 's' }),
				-- ["<Tab>"] = vim.schedule_wrap(function(fallback)
				-- 	if cmp.visible() and has_words_before() then
				-- 		cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				-- 	elseif luasnip.expand_or_jumpable() then
				-- 		luasnip.expand_or_jump()
				-- 	else
				-- 		fallback()
				-- 	end
				-- end),
				-- Tab backwards through suggestions or when a snippet is active, tab to the next argument
				-- ["<S-Tab>"] = cmp.mapping(function(fallback)
				-- 	if cmp.visible() then
				-- 		cmp.select_prev_item()
				-- 	elseif luasnip.locally_jumpable(-1) then
				-- 		luasnip.jump(-1)
				-- 	else
				-- 		fallback()
				-- 	end
				-- end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp", group_index = 20, max_item_count = 5 }, -- lsp
				{ name = "luasnip", group_index = 1, max_item_count = 5 }, -- snippets
				{ name = "buffer", group_index = 10, max_item_count = 5 }, -- text within current buffer
				{ name = "path", group_index = 10, max_item_count = 5 }, -- file system paths
				{ name = "copilot", group_index = 10, max_item_count = 5 }, -- from zbirenbaum/copilot-cmp
				{ name = "codeium", group_index = 30, max_item_count = 5 }, -- from Exafunction/codeium.nvim
			}),
			window = {
				-- Add borders to completions popups
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			formatting = {
				format = function(entry, vim_item)
					vim_item.menu = entry.source.name -- show the source name in the popup
					return lspkind_cmp_format(entry, vim_item)
				end,
				-- format = lspkind.cmp_format({}),
				-- 	format = lspkind.cmp_format({
				-- 		mode = "symbol",
				-- 		maxwidth = 80,
				-- 		ellipsis_char = "...",
				-- 		show_labelDetails = true,
				-- 		before = function(entry, vim_item)
				-- 			return vim_item
				-- 		end,
				-- 	}),
			},
		})
	end,
}
