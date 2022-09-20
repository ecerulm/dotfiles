-- https://www.youtube.com/watch?v=ajmK0ZNcM4Q
vim.cmd('autocmd!')

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.wo.number = true
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = 'bash'
vim.opt.backupskip = '/tmp/*,/private/tmp/*'
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.backspace = 'start,eol,indent'
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }

-- undercurl (it doesn't work on iTerm2
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
-- undercurl finish

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = 'set nopaste'
})

-- Add asterisk in block comments
vim.opt.formatoptions:append { 'r' }

-- :h restore-cursor
-- :h last-position-jump
vim.api.nvim_create_autocmd("BufWinEnter", { -- BufReadPost won't work because for zz we need the window
  pattern = { "*" },
  callback = function()
    -- vim.api.nvim_exec('silent! normal! g`"zz', false)
    for _, value in ipairs({ 'commit', 'rebase' }) do
      if vim.regex(value):match_str(vim.bo.filetype) then return end
    end
    -- check that the position is still valid, line > 1 and less than max line in buffer
    local targetline = vim.fn.line([['"]])
    if targetline > 1 or targetline <= vim.fn.line('$') then
      vim.api.nvim_exec('silent! normal! g`"zvzz', false) -- zv to open fold, zz to center
    end
  end
})

vim.api.nvim_create_user_command('Shell',
  [[silent! !tmux send-keys -t "${SHELL_TMUX_PANE}" c-u <q-args> enter]], { nargs = "*" })
