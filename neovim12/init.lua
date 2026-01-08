vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/kylechui/nvim-surround", -- like tpope vim-surround but implemented in lua, it cause nvim-treesitter for simpler config
	"https://github.com/AndrewRadev/switch.vim", -- cycle between alternatives true->false, enabled->disabled, etc
})

-- nvim-surround
require("nvim-surround").setup()

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
	"python",
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
	},
	format_on_save = {
		timeout_ms = 1500,
		lsp_format = "fallback",
	},
})
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()" -- enables gq , like gqae

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
vim.opt.foldlevel = 3 -- zi disable folding, za toggle fold on current line, zc close fold, zR open recursive, zM close recursive, zv reveal cursor
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
-- vim.opt.shiftwidth = 2
-- vim.opt.tabstop = 2
-- vim.opt.softtabstop = 2

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
vim.cmd([[match ExtraWhitespace /\s\+$/]])
vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])

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
