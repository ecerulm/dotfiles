local status, telescope = pcall(require, 'telescope')
if (not status) then return end

local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require 'telescope'.extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ['q'] = actions.close
      }
    }
  },
  extensions = {
    file_browser = {
      theme = 'dropdown',
      -- disable netrw and use telescope-file-browser instead
      hijack_netrw = true,
      mappings = {
        ['i'] = {
          ['C-w'] = function() vim.cmd('normal vbd') end,
        },
        ['n'] = {
          ['N'] = fb_actions.create,
          ['h'] = fb_actions.goto_parent_dir,
          ['/'] = function() vim.cmd('startinsert') end
        }
      }
    }
  }
}

telescope.load_extension('file_browser')

local opts = { noremap = true, silent = true }

vim.keymap.set('n', ';f', '<cmd>lua require("telescope.builtin").find_files({ no_ignore = false, hidden = true})<cr>',
  opts)
vim.keymap.set('n', ';r', '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
vim.keymap.set('n', '\\\\', '<cmd>lua require("telescope.builtin").buffers()<cr>', opts)
vim.keymap.set('n', ';t', '<cmd>lua require("telescope.builtin").help_tags()<cr>', opts)
vim.keymap.set('n', ';;', '<cmd>lua require("telescope.builtin").resume()<cr>', opts)
vim.keymap.set('n', ';e', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', opts)
vim.keymap.set('n', ';m', builtin.marks, opts)


vim.keymap.set('n', 'sf',
  '<cmd>lua require("telescope").extensions.file_browser.file_browser({ path = "%:p:h", cwd = telescope_buffer_dir(), respect_git_ignore=false, hidden=true, grouped = true, previewer = false, initial_mode = "normal", layout_config = {height = 40 }})<cr>'
  , opts)
vim.keymap.set('n', ';s',
  '<cmd>lua require("telescope.builtin").git_status{on_complete = {function() vim.cmd"stopinsert" end }}<cr>', opts)

vim.keymap.set('n', ';x', '<cmd>lua require("telescope-tabs").list_tabs()<cr>', opts)
