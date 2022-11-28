local keymap = vim.keymap

-- Do not yank with x
-- keymap.set('n', 'x', '"_x') -- commented out because otherwise xp won't work

-- Increment / decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
-- keymap.set('n', '<C-a>', 'gg<S-v>G') -- conflicts with increment C-a

-- Save with root permission / does not work switch to suda.vim
-- https://github.com/neovim/neovim/issues/12103
-- vim.api.nvim_create_user_command('W', 'w !sudo tee %', {})

-- New tab
keymap.set('n', 'te', ':tabedit')

-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w')
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')

-- Switch between  windows/splits
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('n', 'sh', '<C-w>h')
keymap.set('n', 'sk', '<C-w>k')
keymap.set('n', 'sj', '<C-w>j')
keymap.set('n', 'sl', '<C-w>l')

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')
--keymap.set('n', 'sb', '<C-w>j20<C-w>_') -- switch to bottom split and set it's height  to 20

keymap.set('i', 'jk', '<Esc>') -- exit insert mode with jk

-- visual model indent
keymap.set('v', '>', '>gv')
keymap.set('v', '<', '<gv')
keymap.set('v', '<Tab>', '>gv')
keymap.set('v', '<S-Tab>', '<gv')


-- textobjects :help text-objects :help motion
keymap.set('x', 'ae', ':<c-u>normal! ggVG<cr>', { remap = false, silent = true }) -- visual mode "ae" entire file
keymap.set('o', 'ae', ':<c-u>normal Vae<cr>', { remap = true, silent = false }) -- ae entire file

-- keymap.set('n', '<Enter>', ':nohlsearch<cr>', {}) -- clear search results , do not remap <Enter> because <Enter> is used for other things like in :h cmdwink
keymap.set('n', '<c-l>', ':nohlsearch<cr><c-l>', { remap = false })

-- formatting a file
keymap.set('n', '<Leader>lf', ':lua vim.lsp.buf.formatting()<cr>', { remap = false, silent = true })

-- uppercase with <c-u>
keymap.set('i', '<C-u>', '<Esc>viW~Ea', { remap = false })
keymap.set('n', '<C-u>', 'g~iWE', { remap = false })

-- reselect last visual selection / last pasted text / last changed text
--
-- keymap.set('n', 'gz', function()
--   return '`[v`]'
-- end, { remap = false, expr = true })

keymap.set('n', 'gv', '`[v`]', { remap = false })


-- visual mode indent
keymap.set('v', '>', '>gv')
keymap.set('v', '<', '<gv')
keymap.set('v', '<Tab>', '>gv')
keymap.set('v', '<S-Tab>', '<gv')
keymap.set('v', '<D-]>', '>gv') -- D- is Cmd- in macOS
keymap.set('v', '<D-[>', '<gv') -- D- is Cmd- in macOS

-- normal mode ident
-- >> and << are builtin
keymap.set('n', '<D-[', '<<')
keymap.set('n', '<D-]', '>>')

-- %% expands to buffer directory
keymap.set('c', '%%', [[<C-R>=expand('%:h').'/'<cr>]], { remap = false })


-- function SetTerraformMappings()
--   -- get buffer active
--   -- set buffer local TerraformMappings
--   vim.keymap.set('n', '<leader>t', ':Shell terraform plan -out latest.tfplan<cr>', { buffer = 0, remap = false })
--   vim.keymap.set('n', '<leader>r', ':Shell terraform apply latest.tfplan<cr>', { buffer = 0, remap = false })
-- end

-- local terraformGrp = vim.api.nvim_create_augroup("TerraformMappings", { clear = True })
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
--   command = "lua SetTerraformMappings()",
--   group = terraformGrp,
-- })
--
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
--   pattern = { "*.tf" },
--   callback = SetTerraformMappings,
--   group = terraformGrp,
-- })
