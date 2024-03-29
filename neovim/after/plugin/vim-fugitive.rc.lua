-- vim.g.fugitive_gitlab_domains = {'https://gitlab.mycompany.com', ''}

vim.keymap.set('n', '<Leader>go', '<cmd>.GBrowse<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>gc', '<cmd>.GBrowse!<cr>', { noremap = true, silent = true })
vim.keymap.set('v', '<Leader>go', ':GBrowse<cr>', { noremap = true })
vim.keymap.set('v', '<Leader>gc', ':GBrowse!<cr>', { noremap = true })
vim.api.nvim_create_user_command('Browse', [[silent execute "!open " .. shellescape(<q-args>,1)]], { nargs = 1 })

-- vim.g.fugitive_gitlab_domains = {'', ''} -- put the private gitlab domains in ~/.config/nvim/init.thismachine.lua
