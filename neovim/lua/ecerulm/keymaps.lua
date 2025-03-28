local keymap = vim.keymap

-- Do not yank with x
-- keymap.set('n', 'x', '"_x') -- commented out because otherwise xp won't work

-- Increment / decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
-- keymap.set('n', '<C-a>', 'gg<S-v>G') -- conflicts with increment C-a

-- Save with root permission / does not work switch to suda.vim
-- https://github.com/neovim/neovim/issues/12103
-- vim.api.nvim_create_user_command('W', 'w !sudo tee %', {})

-- New tab
keymap.set("n", "te", ":tabedit")

-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w")
keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- Switch between  windows/splits / cycle window split
keymap.set("n", "<Space>", "<C-w>w") -- nnoremap <Space> <C-w>w -- cycle window direction below/right
keymap.set("n", "<Tab>", "<C-w>w")   -- nnoremap <Tab> <C-w>w  -- cycle window direction below/right
keymap.set("n", "<bs>", "<C-w>W")    -- nnoremap <bs> <C-w>W -- cycle windows direction above/left

keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")
--keymap.set('n', 'sb', '<C-w>j20<C-w>_') -- switch to bottom split and set it's height  to 20

keymap.set("i", "jk", "<Esc>") -- exit insert mode with jk

-- visual model indent
keymap.set("v", ">", ">gv")
keymap.set("v", "<", "<gv")
keymap.set("v", "<Tab>", ">gv")
keymap.set("v", "<S-Tab>", "<gv")

-- textobjects :help text-objects :help motion
keymap.set("x", "ae", ":<c-u>normal! ggVG<cr>", { remap = false, silent = true }) -- visual mode "ae" entire file
keymap.set("o", "ae", ":<c-u>normal Vae<cr>", { remap = true, silent = false })   -- ae entire file

-- keymap.set('n', '<Enter>', ':nohlsearch<cr>', {}) -- clear search results , do not remap <Enter> because <Enter> is used for other things like in :h cmdwin
keymap.set("n", "<c-l>", ":nohlsearch<cr><c-l>", { remap = false })


-- uppercase with <c-u>
-- keymap.set('i', '<C-u>', '<Esc>viW~Ea', { remap = false }) -- W and E: spaces separate words, punctuation does not
-- keymap.set('n', '<C-u>', 'g~iWE', { remap = false }) -- W and E: spaces separate words, punctuation does not
keymap.set("i", "<C-u>", "<Esc>viw~ea", { remap = false }) -- w and e : punctuation or spaces separate words
-- keymap.set("n", "<C-u>", "g~iwe", { remap = false }) -- w and e : punctuation or spaces separate words

-- reselect last visual selection / last pasted text / last changed text
--
-- keymap.set('n', 'gz', function()
--   return '`[v`]'
-- end, { remap = false, expr = true })

keymap.set("n", "gv", "`[v`]", { remap = false })

-- visual mode indent
keymap.set("v", ">", ">gv")
keymap.set("v", "<", "<gv")
keymap.set("v", "<Tab>", ">gv")
keymap.set("v", "<S-Tab>", "<gv")
keymap.set("v", "<D-]>", ">gv") -- D- is Cmd- in macOS
keymap.set("v", "<D-[>", "<gv") -- D- is Cmd- in macOS

-- normal mode ident
-- >> and << are builtin
keymap.set("n", "<D-[", "<<")
keymap.set("n", "<D-]", ">>")

-- %% expands to buffer directory
keymap.set("c", "%%", [[<C-R>=expand('%:h').'/'<cr>]], { remap = false })

-- the terraform mappings were moved to after/ftplugin/terraform.vim

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
--
--

-- move lines up and down with Alt-j and Alt-k
--
--nnoremap <A-j> :m .+1<CR>==
-- nnoremap <A-k> :m .-2<CR>==
--inoremap <A-j> <Esc>:m .+1<CR>==gi
--inoremap <A-k> <Esc>:m .-2<CR>==gi
--vnoremap <A-j> :m '>+1<CR>gv=gv
--vnoremap <A-k> :m '<-2<CR>gv=gv
--
keymap.set("n", "<A-j>", ":m .+1<CR>==")
keymap.set("n", "<A-k>", ":m .-2<CR>==")
keymap.set("i", "<A-j>", "<esc>:m .+1<CR>==gi")
keymap.set("i", "<A-k>", "<esc>:m .-2<CR>==gi")
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- vim-easy-align EasyAlign
keymap.set("x", "ga", "<Plug>(EasyAlign)")
keymap.set("n", "ga", "<Plug>(EasyAlign)")

-- LSP

-- NVIM include some default keymappings :help lsp-defaults
-- grn    -> vim.lsp.buf.rename()
-- gra    -> vim.lsp.buf.code_action()
-- grr    -> vim.lsp.buf.references()
-- gri    -> vim.lsp.buf.implementation()
-- gO     -> vim.lsp.buf.document_symbol()
-- CTRL-S -> vim.lsp.buf.signature_help()


-- This should be set only on LspAttach
-- from :help lsp-default-disable
-- :help LspAttach
-- :help lsp-config
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- print("client_id", args.data.client_id)
    -- print("LspAttach", client.name)
    -- print("buffer", args.buf)
    -- print("support for textDocument/hover", client:supports_method(vim.lsp.protocol.Methods.textDocument_hover))
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_hover) then
      -- it seems that this never true, not for copilot not for jdtls
      -- jdtls uses dynamic registration / registerCapability so you can't check for that on LspAttach
      keymap.set("n", "K", function() vim.lsp.buf.hover({ border = 'rounded' }) end,
        { desc = "show documentation", buffer = args.buf })
    end
  end,
})

--
-- keymap.set("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>")
keymap.set("n", "<leader>gg", function() vim.lsp.buf.hover({ border = 'rounded' }) end, { remap = false })
keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")
keymap.set("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("n", "<Leader>lf", ":lua vim.lsp.buf.formatting()<cr>", { remap = false, silent = true }) -- format a file
keymap.set("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
keymap.set("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
keymap.set("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
keymap.set("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
keymap.set("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
-- keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action)
-- vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "vim.lsp.buf.rename()" }) -- this are already on NVIM 0.11
-- vim.keymap.set("n", "gra", vim.lsp.buf.code_action, { desc = "vim.lsp.buf.code_action()" }) -- this are already on NVIM 0.11
-- vim.keymap.set("n", "grr", vim.lsp.buf.references, { desc = "vim.lsp.buf.references()" }) -- this are already on NVIM 0.11
-- vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "vim.lsp.buf.signature_help()" }) --  control-s  (the letter s) not control-space this is the default already on NVIM 0.11
-- vim.keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>") -- c-space, c-s
-- vim.keymap.set("i", "<C-Space>", vim.lsp.completion.trigger, { desc = "lsp completion"})

-- vim-fugitive

vim.keymap.set("n", "<Leader>go", "<cmd>.GBrowse<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>gc", "<cmd>.GBrowse!<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "<Leader>go", ":GBrowse<cr>", { noremap = true })
vim.keymap.set("v", "<Leader>gc", ":GBrowse!<cr>", { noremap = true })

-- nvim-cmp

-- keymap.set('i', '<C-Space>', 'cmp.complete()', { expr = true, noremap = true, silent = true })

-- Telescope
--
local opts = { noremap = true, silent = true }
-- keymap.set("n", "<leader>ts", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { noremap = true, silent = true })
-- keymap.set("n", "<leader>ts", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { noremap = true, silent = true })

if pcall(require, 'telescope.builtin') then
  keymap.set("n", "<leader>ts", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)
  keymap.set("n", "<leader>td", require("telescope.builtin").lsp_document_symbols, opts)
  keymap.set("n", "<leader>ls", require("telescope.builtin").lsp_document_symbols, opts)
  keymap.set("n", "<leader>lm", function()
    require("telescope.builtin").lsp_document_symbols({ symbols = { "method", "function" } })
  end, opts)
  keymap.set("n", "<leader>lds", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

  -- telescope ctags builtin picker https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
  keymap.set("n", "<leader>ct", require("telescope.builtin").tags, opts)

  vim.keymap.set(
    "n",
    ";f",
    '<cmd>lua require("telescope.builtin").find_files({ no_ignore = false, hidden = true})<cr>',
    opts
  )
  vim.keymap.set("n", ";r", '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
  vim.keymap.set("n", "\\\\", '<cmd>lua require("telescope.builtin").buffers()<cr>', opts)
  vim.keymap.set("n", ";t", '<cmd>lua require("telescope.builtin").help_tags()<cr>', opts)
  vim.keymap.set("n", ";;", '<cmd>lua require("telescope.builtin").resume()<cr>', opts)
  vim.keymap.set("n", ";e", '<cmd>lua require("telescope.builtin").diagnostics()<cr>', opts)
  vim.keymap.set("n", ";m", require("telescope.builtin").marks, opts)
  vim.keymap.set("n", ";c", function()
    require("telescope.builtin").tags({ only_sort_tags = true, show_line = true, path_display = { "filename_first" }, })
    -- options for path_display are "hidden", "tail", "absolute", "smart", "shorten", "truncate", "filename_first", see :h telescope.defaults.path_display
  end, opts)

  vim.keymap.set(
    "n",
    "sf",
    '<cmd>lua require("telescope").extensions.file_browser.file_browser({ path = "%:p:h", cwd = telescope_buffer_dir(), respect_git_ignore=false, hidden=true, grouped = true, previewer = false, initial_mode = "normal", layout_config = {height = 40 }})<cr>',
    opts
  )
  vim.keymap.set(
    "n",
    ";s",
    '<cmd>lua require("telescope.builtin").git_status{on_complete = {function() vim.cmd"stopinsert" end }}<cr>',
    opts
  )
end

if pcall(require, 'telescope-tabs') then
  vim.keymap.set("n", ";x", '<cmd>lua require("telescope-tabs").list_tabs()<cr>', opts)
end

-- DAP / Debugging

vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
  require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
  require("dap").set_breakpoint()
end)
vim.keymap.set("n", "<Leader>lp", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dr", function()
  require("dap").repl.open()
end)
vim.keymap.set("n", "<Leader>dl", function()
  require("dap").run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
  require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
  require("dap.ui.widgets").preview()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dt", function()
  require("dap").terminate()
end)
vim.keymap.set("n", "<Leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end)

---
-- Keymaps for python tests

keymap.set("n", "<leader>tc", function()
  if vim.bo.filetype == "python" then
    require("dap-python").test_class() -- dap-python comes from mfussenegger/nvim-dap-python
  end
end)

keymap.set("n", "<leader>tm", function()
  if vim.bo.filetype == "python" then
    require("dap-python").test_method() -- dap-python comes from mfussenegger/nvim-dap-python
  end
end)

keymap.set("t", "<Esc>", "<C-\\><C-n>", { remap = false }) -- :tnoremap <esc> <c-\><c-n> exit terminal mode with <Esc>
keymap.set("t", "<C-v><Esc>", "<Esc>", { remap = false })  -- exit terminal mode with <Esc>

-- keymap.set("x", "p", '"_dp', { remap = false, silent = false }) -- do not mess with the clipboard during paste
vim.api.nvim_set_keymap('x', 'p', '"_dP', { noremap = true, silent = true }) -- delete visual selection into blackhole register "_ , then paste
vim.api.nvim_set_keymap('x', 'P', '"_dp', { noremap = true, silent = true }) -- delete visual selection into blackhole register "_ , then paste
