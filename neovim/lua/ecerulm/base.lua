-- https://www.youtube.com/watch?v=ajmK0ZNcM4Q

vim.g.loaded_python3_provider = 0 -- Disable python3 support
vim.g.loaded_ruby_provider = 0 -- Disable ruby support
vim.g.loaded_node_provider = 0 -- Disable node support
vim.g.loaded_perl_provider = 0 -- Disable perl support

vim.opt.encoding = 'utf-8' -- Unicode,  fileencodings  set automatically to ucs-bom,utf-8,default,latin1

vim.wo.number = true
vim.opt.title = true
vim.opt.autoindent = true -- this may conflict with nvim-treesitter indentexpr thing, disable nvim-treesitter indent
vim.opt.smartindent = true -- this may conflic with nvim-treesitter indentexpr thing, disable nvim-treesitter indent
vim.opt.autoread = true
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
vim.opt.wrap = false
vim.opt.backspace = 'start,eol,indent'
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.smartcase = true -- ignore case if regex in lowercase, othewise case sensitive
vim.opt.grepprg='rg --vimgrep --no-heading --smart-case' -- see Practical Vim Chapter 18
vim.opt.list = false
vim.opt.splitright = true

if vim.fn.exists("&messagesopt") == 1 then -- NVIM 0.10.2 does NOT have this option
vim.opt.messagesopt='wait:2000,history:50' -- :h 'messagesopt' -- the default is 'hit-enter;history:500'
end

-- undercurl (it doesn't work on iTerm2
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
-- undercurl finish

-- Check if file has changed outside of vim
vim.api.nvim_create_autocmd({"FocusGained","BufEnter","VimResume","CursorHold"}, {
  pattern = '*',
  command = 'checktime'
})

-- Autosave when leaving focus
-- vim.api.nvim_create_autocmd("FocusLost,WinLeave", {
--   pattern = '*',
--   command = 'w'
-- })


-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = 'set nopaste'
})

-- Add asterisk in block comments
-- vim.opt.formatoptions:append { 'r' }

-- Prevent vim from adding comment leader on pressing enter in insert mode or 'o' in normalmode
vim.opt.formatoptions:remove{'c','r','o'} -- this will be overwritten by system ftplugin/java.vim for example

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

vim.opt.mouse = ''

vim.opt.cursorcolumn = true -- :set cursorcolumn

vim.opt.colorcolumn = "80"  -- :set colorcolumn , see hl-ColorColumn
-- we can't have this here because it gets overwritten latter
-- vim.cmd([[
--   highlight CursorColumn guibg=#200000 ctermbg=LightGreen
--   highlight ColorColumn guibg='#200000' ctermbg=LightGreen
-- ]])

-- vim.cmd("colorscheme gruvbox")
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.winblend = 0 --  enable pseudo transparency on floating windows. :help 'winblend'
vim.opt.wildoptions = 'pum' -- Display the completion matches using the popup menu :help 'wildoptions'
vim.opt.pumblend = 5 -- pseudo transparency on popup menu :help 'pumblend'
-- vim.opt.background = 'dark'
vim.opt.showbreak='↪ '
vim.opt.listchars={
  tab = '→ ',
  eol = '↲',
  nbsp = '␣',
  trail = '•',
  extends = '⟩',
  precedes = '⟨',
}


vim.opt.tags={'./tags', 'tags'}
