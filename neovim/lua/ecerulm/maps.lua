local keymap = vim.keymap

-- Do not yank with x
-- keymap.set('n', 'x', '"_x') -- commented out because otherwise xp won't work

-- Increment / decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

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

keymap.set('n', '<Enter>', ':nohlsearch<cr>', {}) -- clear search results

-- formatting a file
keymap.set('n', '<Leader>lf', ':lua vim.lsp.buf.formatting()<cr>', { remap = false, silent = true })

-- uppercase with <c-u>
keymap.set('i', '<C-u>', '<Esc>viW~Ea', { remap = false })
