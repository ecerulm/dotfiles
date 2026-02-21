-- load init.thismachine.lua so you could access THISMACHINESETTINGS
-- You can just get globals like vim.g.xxxx in that file as well
-- local function source_file_if_exists(file_path)
-- 	local file = io.open(file_path, "r")
-- 	if file then
-- 		io.close(file)
-- 		dofile(file_path)
-- 	end
-- end
--
-- source_file_if_exists(vim.fn.stdpath("config") .. "/init.thismachine.lua")

local ok, thismachine = pcall(require, "init_thismachine") -- You can use '.' in require since the loader will try treat it as `/`
if not ok then
	-- provide a dummy implementation
	thismachine = {}
	function thismachine.pre() end -- never add anything here, add it in init_thismachine.lua instead
	function thismachine.post() end -- never add anything here, add it in init_thismachine.lua instead
	-- your init_thismachine.lua should look like this:
	-- local M = {}
	--
	-- function M.pre()
	-- 	print("test1")
	-- end
	--
	-- function M.post()
	-- 	print("test2")
	-- end
	--
	-- return M
end
thismachine.pre()

-- plugins
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" }, -- the new full, incompatble, rewrite
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	-- "https://github.com/kylechui/nvim-surround", -- like tpope vim-surround but implemented in lua, it cause nvim-treesitter for simpler config
	"https://github.com/AndrewRadev/switch.vim", -- cycle between alternatives true->false, enabled->disabled, etc
	"https://github.com/nvim-mini/mini.nvim", --  mini.completion, mini.align
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/chrisgrieser/nvim-various-textobjs",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git",
})

require("mini.icons").setup()
require("mini.git").setup()

-- nvim-surround
-- require("nvim-surround").setup() -- replaced by mini.surround

-- nvim-lspconfig lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
vim.lsp.enable("lua_ls")

-- nvim-lspconfig LSP basedpyright (fork of pyright with pylance features)
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#basedpyright
-- https://docs.basedpyright.com/latest/
-- brew install basedpyright
vim.lsp.enable("basedpyright")

-- nvim-lspconfig LSP pyright
-- brew install pyright
-- vim.lsp.enable('pyright')

-- nvim-lspconfig LSP pylsp
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pylsp
-- https://github.com/python-lsp/python-lsp-server
-- brew install python-lsp-server
-- vim.lsp.enable('pylsp')

-- nvim-lspconfig LSP Golang gopls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#gopls
-- https://github.com/golang/tools/tree/master/gopls
-- brew install gopls
vim.lsp.enable("gopls")

-- nvim-treesitter , provides syntax highlighting groups, folding and indentation based on treesitter queries
-- https://github.com/nvim-treesitter/nvim-treesitter
require("nvim-treesitter").setup({
	-- using the defaults
})
require("nvim-treesitter").install({
	"lua",
	"c",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"gowork",
	"hcl",
	"terraform",
	"python", -- Highlights , Folds, Indents, inJection, Locals
	"vim",
	"vimdoc",
	"yaml",
	"toml",
	"json",
	"json5",
	"jsonnet",
	"zsh",
	"bash",
	"dart",
	"git_config",
	"gitignore",
}) -- languages to install https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md

-- format / formatting / formatter conform.nvim
require("conform").setup({
	formatters_by_ft = { -- :h conform-formaters for a list of formatters, :ConformInfo to see configured formatters
		-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
		lua = { "stylua" }, -- brew install stylua
		python = { "isort", "black" }, -- brew install isort black
		terraform = { "terraform_fmt" }, -- terraform fmt comes with terraform
		go = { "gofmt" }, -- go fmt comes with golang
		markdown = { "markdownfmt" }, -- go install github.com/shurcooL/markdownfmt@latest, ~/go/bin/markdownfmt in the path
		json = { "jq" }, -- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/jq.lua
		c = { "clang-format" },
		cpp = { "clang-format" },
		make = { "bake" },
		dart = { "dart_format" },
		-- toml = {},
	},
	format_on_save = function(bufnr)
		local ignore_filetypes = { "markdown", "sql", "java" }
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		-- disable autoformat on save for files in a certain path
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/node_modules/") then
			return
		end
		local timeout = 1500
		if vim.tbl_contains({ "python" }, vim.bo[bufnr].filetype) then
			timeout = 3000
		end
		return { timeout = timeout, lsp_format = "fallback" }
	end,
})
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()" -- enables gq , like gqae
vim.api.nvim_create_user_command("Format", function(args) -- adds :Format command
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

-- Snacks.nvim / pickers / telescope
require("snacks").setup({
	gitbrowse = {
		remote_patterns = {
			{ "^(https?://.*)%.git$", "%1" },
			{ "^git@github%-ecerulm:(.+)%.git$", "https://github.com/%1" }, -- %- escapes the `-` as it has special meaning in a regex
			{ "^git@(.+):(.+)%.git$", "https://%1/%2" },
			{ "^git@(.+):(.+)$", "https://%1/%2" },
			{ "^git@(.+)/(.+)$", "https://%1/%2" },
			{ "^org%-%d+@(.+):(.+)%.git$", "https://%1/%2" },
			{ "^ssh://git@(.*)$", "https://%1" },
			{ "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
			{ "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
			{ "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
			{ "^https://%w*@(.*)", "https://%1" },
			{ "^git@(.*)", "https://%1" },
			{ ":%d+", "" },
			{ "%.git$", "" },
		},
	},
	picker = {},
})

-- Keymaps
vim.keymap.set("i", "jk", "<Esc>")

-- copy github remote link / copy remote url
vim.keymap.set({ "n", "v" }, "<leader>gc", function()
	Snacks.gitbrowse({
		notify = true,
		open = function(url)
			-- vim.fn.setreg("*", url) -- PRIMARY selection :h quotestar
			vim.fn.setreg("+", url) -- CLIPBOARD selection :h quoteplus
		end,
	})
end, { desc = "Git Browse" })

vim.keymap.set({ "n", "v" }, "<leader>gB", function()
	Snacks.gitbrowse()
end, { desc = "Git Browse" })

-- vim.keymap.set({ "n", "v" }, "<leader>gb", function()
-- 	Snacks.git.blame_line()
-- end, { desc = "Git Blame" })

-- snacks.nvim pickers
vim.keymap.set("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function()
	Snacks.picker.git_files()
end, { desc = "Find Git tracked files in the whole repo" })
vim.keymap.set("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fp", function()
	Snacks.picker.projects({
		finder = "recent_projects",
		dev = {
			"~/git/personal",
			"~/git/work",
		},
		max_depth = 3,
		patterns = { ".git", "Makefile", "pyproject.toml", ".test" },
		recent = false, --  include project directories of recent files
	})
end, { desc = "Recent projects" })

--
-- snacks.nvim git pickers
--
vim.keymap.set("n", "<leader>gb", function()
	Snacks.picker.git_branches()
end, { desc = "Git Branches" })

vim.keymap.set("n", "<leader>gl", function()
	Snacks.picker.git_log()
end, { desc = "Git Log" })

vim.keymap.set("n", "<leader>gL", function()
	Snacks.picker.git_log_line()
end, { desc = "Git Log Line, show commits that affect this line" })

vim.keymap.set("n", "<leader>gs", function()
	Snacks.picker.git_status()
end, { desc = "Git status" })

vim.keymap.set("n", "<leader>gS", function()
	Snacks.picker.git_stash()
end, { desc = "Git stash" })

vim.keymap.set("n", "<leader>gd", function()
	Snacks.picker.git_diff()
end, { desc = "Git diff (hunks)" })

vim.keymap.set("n", "<leader>gf", function()
	Snacks.picker.git_log_file()
end, { desc = "Git Log file, show commits that affects this file" })

vim.keymap.set("n", "<leader>gf", function()
	Snacks.picker.git_log_file()
end, { desc = "Git Log file, show commits that affects this file" })

vim.keymap.set("n", "<leader>gg", function()
	Snacks.picker.lazygit()
end, { desc = "Lazygit UI" })

-- snacks.nvim search pickers

vim.keymap.set("n", "<leader>sd", function()
	Snacks.picker.diagnostics()
end, { desc = "Search diagnostics" })

vim.keymap.set("n", "<leader>sD", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "Search diagnostics in this buffer" })

vim.keymap.set("n", "<leader>sh", function()
	Snacks.picker.help()
end, { desc = "Search help pages" })

vim.keymap.set("n", "<leader>sk", function()
	Snacks.picker.keymaps()
end, { desc = "Search vim keymaps / keyboards shortcut" })

-- snacks.nvim other keymaps
vim.keymap.set("n", "<leader>cR", function()
	Snacks.rename.rename_file()
end, { desc = "Rename file" })

vim.keymap.set("n", "<leader>.", function()
	Snacks.scratch()
end, { desc = "Toggle Scratch buffer" })

vim.keymap.set("n", "<leader>n", function()
	Snacks.notifier.show_history()
end, { desc = "Show notification history / error messages" })
vim.keymap.set("n", "<leader>un", function()
	Snacks.notifier.hide()
end, { desc = "Dismiss all notifications / error messages" })

-- snacks.nvim grep / search inside files

vim.keymap.set("n", "<leader>/", function()
	Snacks.picker.grep()
end, { desc = "Grep in all files" })
vim.keymap.set("n", "<leader>sg", function()
	Snacks.picker.grep()
end, { desc = "Grep in all files" })
vim.keymap.set("n", "<leader>sb", function()
	Snacks.picker.lines()
end, { desc = "Grep in this buffer" })
vim.keymap.set("n", "<leader>sB", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep in all open buffers" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function()
	Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })

-- toggle options like with vim-unimpaired
Snacks.toggle.option("list", { name = "List" }):map("yol")
Snacks.toggle.option("number", { name = "Line Numbers" }):map("yon")
Snacks.toggle.option("relativenumber", { name = "Relative Line Numbers" }):map("yor")
Snacks.toggle.option("hlsearch", { name = "Highlight search" }):map("yoh")
Snacks.toggle.option("wrap", { name = "wrap line" }):map("yow")
Snacks.toggle.diagnostics():map("<leader>ud") -- keymap to enable disable diagnostics

Snacks.toggle.treesitter():map("<leader>uT") -- keymap to enable disable treesitter

-- textobject / text objects / text-objects / motions
vim.keymap.set({ "o", "v" }, "ae", ":<C-u>normal! m'ggVG<cr>", { noremap = true, silent = true }) -- "o" is the operator pending mode :help omap-info, :help mapmode-o

-- global options
vim.opt.clipboard = "unnamedplus" -- paste from system clipboard , consider vim.opt.clipboard:append { 'unnamedplus' }
-- vim.opt.foldlevel = 3 -- zi disable folding, za toggle fold on current line, zc close fold, zR open recursive, zM close recursive, zv reveal cursor
vim.opt.foldlevelstart = 99 -- zi disable folding, za toggle fold on current line, zc close fold, zR open recursive, zM close recursive, zv reveal cursor
vim.opt.conceallevel = 2

vim.g.loaded_python3_provider = 0 -- Disable python3 support
vim.g.loaded_ruby_provider = 0 -- Disable ruby support
vim.g.loaded_node_provider = 0 -- Disable node support
vim.g.loaded_perl_provider = 0 -- Disable perl support

vim.opt.encoding = "utf-8" -- Unicode,  fileencodings  set automatically to ucs-bom,utf-8,default,latin1

vim.wo.number = true
vim.opt.title = true
vim.opt.autoread = true -- reload file if changed outside of vim
vim.opt.hlsearch = true -- highlight search, yoh to toggle
vim.opt.backup = false -- make a backup before overwriting a file
vim.opt.showcmd = true -- show command on last line of the screen
vim.opt.cmdheight = 1 -- lines to use for command-line
vim.opt.laststatus = 2 -- last window always have status line
vim.opt.scrolloff = 10 --  minimal number of lines to keep above and below cursor
vim.opt.shell = "bash"
vim.opt.backupskip = "/tmp/*,/private/tmp/*"
vim.opt.inccommand = "split" -- show the effects of search/etc as you type
vim.opt.ignorecase = true -- ignore case in search
-- vim.opt.smarttab = true --  softtabstop is a better option
vim.opt.breakindent = true

-- indent / indentation related settings
vim.opt.autoindent = true -- this may conflict with nvim-treesitter indentexpr thing, disable nvim-treesitter indent
vim.opt.smartindent = true -- this may conflict with nvim-treesitter indentexpr thing, disable nvim-treesitter indent, if smartindent, autoindent must be also on
-- autoindent/smartident are alternatives to cindent/indentexpr, if indentexpr is set it overrides autoindent/smartindent
-- vim.opt.expandtab = true -- insert spaces instead of tabs
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.wrap = false -- toggle with
vim.opt.backspace = "start,eol,indent"
vim.opt.path:append({ "**" }) -- where does the gf search for files
vim.opt.wildignore:append({ "*/node_modules/*" }) -- ignored by wilcards, completing filename, expands(), glob, globpath()
vim.opt.smartcase = true -- ignore case if regex in lowercase, othewise case sensitive
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case" -- see Practical Vim Chapter 18
vim.opt.list = false -- togle with yol
vim.opt.splitright = true --
vim.opt.undofile = true -- persistent undo / undo persistence

if vim.fn.exists("&messagesopt") == 1 then -- NVIM 0.10.2 does NOT have this option
	-- vim.opt.messagesopt = "wait:3000,history:50" -- :h 'messagesopt' -- the default is 'hit-enter;history:500'
	vim.opt.messagesopt = "hit-enter,history:50" -- :h 'messagesopt' -- wait:3000 was a bad idea it makes impossible to use :messages
end

-- undercurl (it doesn't work on iTerm2
-- squiggly red lines for highlighting errors, typos, etc
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
-- undercurl finish

-- Check if file has changed outside of vim, works with vim.opt.autoread
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "VimResume", "CursorHold" }, {
	pattern = "*",
	command = "checktime",
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Add asterisk in block comments
-- vim.opt.formatoptions:append { 'r' }

-- Prevent vim from adding comment leader on pressing enter in insert mode or 'o' in normalmode
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- this will be overwritten by system ftplugin/java.vim for example

-- :h restore-cursor
-- :h last-position-jump
vim.api.nvim_create_autocmd("BufWinEnter", { -- BufReadPost won't work because for zz we need the window
	pattern = { "*" },
	callback = function()
		-- skip if the filetype is commit or rebase
		for _, value in ipairs({ "commit", "rebase" }) do
			if vim.regex(value):match_str(vim.bo.filetype) then
				return
			end
		end
		-- check that the position is still valid, line > 1 and less than max line in buffer
		local targetline = vim.fn.line([['"]])
		if targetline > 1 or targetline <= vim.fn.line("$") then
			vim.cmd('silent! normal! g`"zvzz', false) -- zv to open fold, zz to center
		end
	end,
})

vim.api.nvim_create_user_command("Help", function(opts)
	vim.cmd([[vert help ]] .. opts.args)
end, {
	desc = "Open help in vertical split",
	nargs = "*",
})

-- highlight whitespace at the end of the line
-- vim.cmd([[match ExtraWhitespace /\s\+$/]])
-- vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])
require("mini.trailspace").setup()
vim.api.nvim_create_user_command("TrimTrailingWhitespace", function(args) -- adds :TrimTrailingWhitespace command
	MiniTrailspace.trim()
end, {})

-- other keymaps

-- Split window
vim.keymap.set("n", "ss", ":split<Return><C-w>w")
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- Switch between  windows/splits / cycle window split
vim.keymap.set("n", "<Space>", "<C-w>w") -- nnoremap <Space> <C-w>w -- cycle window direction below/right
vim.keymap.set("n", "<Tab>", "<C-w>w") -- nnoremap <Tab> <C-w>w  -- cycle window direction below/right
vim.keymap.set("n", "<bs>", "<C-w>W") -- nnoremap <bs> <C-w>W -- cycle windows direction above/left

-- clear hlsearch / highlight search results
vim.keymap.set("n", "<c-l>", ":nohlsearch<cr><c-l>", { remap = false }) -- you have also yoh

-- normal mode indent
-- >> and << are builtin
vim.keymap.set("n", "<D-[", "<<") -- <D-X> means Cmd-X in macOS but only for GUI, terminal emulators do not pass it
vim.keymap.set("n", "<D-]", ">>") -- <D-X> means Cmd-X in macOS but only for GUI, terminal emulators do not pass it

-- visual model indent
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", "<Tab>", ">gv") -- <D-X> means Cmd-X in macOS but only for GUI, terminal emulators do not pass it
vim.keymap.set("v", "<S-Tab>", "<gv") -- <D-X> means Cmd-X in macOS but only for GUI, terminal emulators do not pass it

-- %% expands to buffer directory
vim.keymap.set("c", "%%", [[<C-R>=expand('%:h').'/'<cr>]], { remap = false })

-- for <A-j> to work the macos-option-as-alt = left in ghostty must be set
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==") -- Alt-j, move line down
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==") -- Alt-k, move line up
vim.keymap.set("i", "<A-j>", "<esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- <esc> in terminal mode exit terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { remap = false }) -- :tnoremap <esc> <c-\><c-n> exit terminal mode with <Esc>
vim.keymap.set("t", "<C-v><Esc>", "<Esc>", { remap = false }) -- exit terminal mode with <Esc>

-- invert p and P in visual model
-- the black hole register "_ (see :h quote_) is not needed
-- see :h v_p and v_P
vim.keymap.set("x", "p", [[P]], { noremap = true, silent = true }) -- the default P (v_P) does not set the default register, we map p to P because that is the default you want to use
vim.keymap.set("x", "P", [[p]], { noremap = true, silent = true })

local skeletons = {
	"Makefile", -- ~/.vim/skeleton.Makefile
	{ skeleton = "index.html", patterns = { "*.html" } }, -- ~/.vim/index.html
	"config.py", -- ~/.vim/skeleton.config.py
	"gitlab-ci.yml", -- ~/.vim/skeleton.gitlab-ci.yml
	"setup.py", -- ~/.vim/skeleton.setup.py
	"tox.ini", -- ~/.vim/skeleton.tox.ini
	"ansible.cfg", -- ~/.vim/skeleton.ansible.cfg
	"docker-compose.yml", -- ~/.vim/skeleton.docker-compose.yml
	"gradle.build", -- ~/.vim/skeleton.gradle.build
	"pom.xml", -- ~/.vim/skeleton.pom.xml
	"stack.yaml", -- ~/.vim/skeleton.stack.yaml
	".isort.cfg", -- ~/.vim/skeleton.isort.cfg
}

for _, skeleton in pairs(skeletons) do
	local patterns = { skeleton }
	if type(skeleton) == "table" then
		patterns = skeleton["patterns"]
		skeleton = skeleton["skeleton"]
	end
	vim.api.nvim_create_autocmd({ "BufNewFile" }, {
		pattern = patterns,
		command = [[r ]] .. vim.fn.stdpath("config") .. [[/skeletons/skeleton.]] .. skeleton .. [[ | normal ggdd]],
	})
end

vim.g.switch_mapping = "gs"
vim.g.switch_custom_definitions = {
	vim.fn["switch#NormalizedCase"]({ "enabled", "disabled" }),
	{ "==", "!=" },
	vim.fn["switch#NormalizedCase"]({ "one", "two" }), -- xxoness <-> xxtwoss,
	vim.fn["switch#Words"]({ "three", "four" }),
	vim.fn["switch#NormalizedCaseWords"]({ "five", "six" }),
}

require("mini.align").setup() -- gAiP :h MiniAlign-modifiers-builtin and :h MiniAlign-examples.
require("mini.comment").setup() --  gc, gcc
-- require("mini.ai").setup() -- balanced textobjects
require("mini.move").setup() -- Alt + hjkl

-- mini.operators
-- the mini.operators gx overrides the gx that you used for open url link under cursor
-- replace with gr, grr (gr conflict with grn for rename)  / you changed the prefix from gr to cr
-- exchange text regions gx / sort gs / multiply gm / swap text
require("mini.operators").setup({ replace = { prefix = "cr" } })

vim.keymap.set("n", "gX", function()
	vim.ui.open(vim.fn.expand("<cfile>")) -- :h <cfile> , it expands to the filename or url under cursor
end, { desc = "Open url under cursor" })

-- mini.operators / :h MiniSnippets-examples
-- trigger<c-j>
-- next tabstop <c-l>
-- prev tabstop <c-h>
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
	snippets = {
		-- Load custom file with global snippets first
		gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),

		-- Load snippets based on current language by reading files from
		-- "snippets/" subdirectories from 'runtimepath' directories.
		gen_loader.from_lang(),
	},
})

require("mini.splitjoin").setup() -- gS :h MiniSplitjoin
require("mini.surround").setup() -- replaces nvim-surround / saw" / sd" / sr"'
require("mini.bracketed").setup({}) -- b] , b[
require("mini.files").setup({}) -- :lua MiniFiles.open()

vim.keymap.set("n", "-", function()
	local buf_name = vim.api.nvim_buf_get_name(0)
	local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
	MiniFiles.open(path)
	MiniFiles.reveal_cwd()
end, { desc = "Open Mini Files" })

require("mini.statusline").setup({})
require("mini.diff").setup()

vim.keymap.set("n", "<leader>d", function()
	MiniDiff.toggle_overlay()
end, { desc = "Toggle the mini.diff overlay" })

require("mini.basics").setup() -- prefix \w -> toggle wrap, this will change <leader> to <space>
vim.g.mapleader = "\\" -- restore \ as <leader>, nvim.basics rewrites it with " " (space)
vim.opt.mouse = ""
vim.keymap.set("n", "<leader>m", function()
	vim.opt.mouse = (vim.opt.mouse == "" and "a" or "")
end, { desc = "Toggle mouse" })

vim.opt.timeout = true
vim.opt.timeoutlen = 700 -- :h timeoutlen, how much to wait between keypresses in a map, 2026-01-16: 1500ms is too much, 1000ms is too much as well

require("mini.completion").setup({})

vim.keymap.set("n", "grd", function() -- Go to definition / Go to declaration / Go to implementation
	vim.lsp.buf.definition()
end, { desc = "Go to definition/implmentation" })

local align_blame = function(au_data)
	if au_data.data.git_subcommand ~= "blame" then
		return
	end

	-- Align blame output with source
	local win_src = au_data.data.win_source
	vim.wo.wrap = false
	vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
	vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })

	-- Bind both windows so that they scroll together
	vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
end

local au_opts = { pattern = "MiniGitCommandSplit", callback = align_blame }
vim.api.nvim_create_autocmd("User", au_opts)

vim.opt.showbreak = "↪ " -- added to lines that have been wrapped
vim.opt.listchars = { -- set list / yol
	tab = "→ ",
	eol = "↲",
	nbsp = "␣",
	trail = "•",
	extends = "⟩",
	precedes = "⟨",
}

vim.diagnostic.config({ virtual_lines = { current_line = true } })
vim.diagnostic.enable(false) -- start with diagnostic disabled, toggle enablement with <leader>ud

require("various-textobjs").setup({
	keymaps = {
		useDefaults = true,
	},
})

vim.opt.cursorcolumn = true

require("nvim-treesitter-textobjects").setup({
	select = {
		-- Automatically jump forward to textobj, similar to targets.vim
		lookahead = true,
		-- You can choose the select mode (default is charwise 'v')
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * method: eg 'v' or 'o'
		-- and should return the mode ('v', 'V', or '<c-v>') or a table
		-- mapping query_strings to modes.
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			-- ['@class.outer'] = '<c-v>', -- blockwise
		},
		-- If you set this to `true` (default is `false`) then any textobject is
		-- extended to include preceding or succeeding whitespace. Succeeding
		-- whitespace has priority in order to act similarly to eg the built-in
		-- `ap`.
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * selection_mode: eg 'v'
		-- and should return true of false
		include_surrounding_whitespace = false,
	},
})

-- keymaps treesitter-textobjects
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ia", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "aa", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end)

-- treesitter text objects: swap
vim.keymap.set("n", "<leader>a", function()
	require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
end)

vim.keymap.set("n", "<leader>A", function()
	require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
end)

thismachine.post()
