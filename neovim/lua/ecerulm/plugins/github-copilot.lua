-- local enabled = THISMACHINESETTINGS.github_copilot_enabled and not THISMACHINESETTINGS.zbirenbaum_copilot_enabled

return {
	-- https://github.com/github/copilot.vim/blob/release/doc/copilot.txt
	"github/copilot.vim",
	enabled = true,
	cond = true,
	lazy = false,
  event = "BufWinEnter",
  init = function()
    vim.g.copilot_no_maps = true -- no keymaps , because we want copilot just a a source for blink.cmp
    vim.g.copilot_no_tab_map = true -- both nvim-cmp and copilot.vim have a key-mapping fallback , we need to disable one
  end,
	config = function()
		-- vim.keymap.set("i", "<M-l>", 'copilot#Accept("\\<CR>")', {
		-- 	expr = true,
		-- 	replace_keycodes = false,
		-- })
		-- vim.g.copilot_no_tab_map = true

    -- for blink.cmp + blink-copilot
    -- Block the normal Copilot suggestions
    vim.keymap.set('i','<Plug>vimrc:copilot-dummy-map', 'copilot#Accept("<Tab>")', {expr=true} )
    -- From :h copilot#Accept()
    -- vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
    --       expr = true,
    --       replace_keycodes = false
    -- })
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_create_augroup("github_copilot", { clear = true })
    vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
      group = "github_copilot",
      callback = function(args)
        vim.fn["copilot#On" .. args.event]()
      end,
    })
    vim.fn["copilot#OnFileType"]()
	end,
}


-- {

--   "github/copilot.vim",
--   cmd = "Copilot",
--   event = "BufWinEnter",
--   init = function()
--     vim.g.copilot_no_maps = true
--   end,
--   config = function()
--     -- Block the normal Copilot suggestions
--     vim.api.nvim_create_augroup("github_copilot", { clear = true })
--     vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
--       group = "github_copilot",
--       callback = function(args)
--         vim.fn["copilot#On" .. args.event]()
--       end,
--     })
--     vim.fn["copilot#OnFileType"]()
--   end,
-- },
-- {
--   "saghen/blink.cmp",
--   dependencies = { "fang2hou/blink-copilot" },
--   opts = {
--     sources = {
--       default = { "copilot" },
--       providers = {
--         copilot = {
--           name = "copilot",
--           module = "blink-copilot",
--           score_offset = 100,
--           async = true,
--         },
--       },
--     },
--   },
-- }
