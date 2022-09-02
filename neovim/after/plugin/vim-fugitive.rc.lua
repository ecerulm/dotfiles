-- vim.g.fugitive_gitlab_domains = {'https://gitlab.mycompany.com', ''}

vim.keymap.set('n', '<Leader>go', '<cmd>.GBrowse<cr>', { noremap = true, silent = true })
vim.keymap.set('v', '<Leader>go', ':GBrowse<cr>', { noremap = true })
vim.api.nvim_create_user_command('Browse', [[silent execute "!open " .. fnameescape('<args>')]], { nargs = 1 })
