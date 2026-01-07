vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main"},
})


-- nvim-lspconfig

-- lua 
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})
vim.lsp.enable('lua_ls')


-- nvim-treesitter , provides syntax highlighting groups, folding and indentation based on treesitter queries
-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter'.install { 
	'lua',
	'c',
	'go',
	'gomod',
	'gosum', 
	'gotmpl', 
	'gowork',
	'hcl',
	'terraform',
	'python',
	'vim', 
	'vimdoc',
	'yaml',
	'toml', 
	'json',
	'json5',
	'jsonnet',
	'zsh', 
	'bash', 
	'dart',
	'git_config',
	'gitignore',
} -- languages to install https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md


-- Keymaps
vim.keymap.set("i", "jk", "<Esc>")



-- global options
vim.opt.clipboard = "unnamedplus" -- paste from system clipboard
vim.opt.foldlevel=3 -- zi disable folding, za toggle fold on current line, zc close fold, zR open recursive, zM close recursive, zv reveal cursor 



