-- Plugins
--
local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.init({
  git = {
    clone_timeout = 240,
  }
})

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use { 
    'svrana/neosolarized.nvim', -- theme
    requires = { 'tjdevries/colorbuddy.nvim' }
  }

  use 'morhetz/gruvbox' -- theme

  -- use 'nvim-lualine/lualine.nvim' -- statusline
  -- use({ "L3MON4D3/LuaSnip", tag = "v2.*" }) -- https://github.com/L3MON4D3/LuaSnip
  -- use "windwp/nvim-autopairs" -- auto close quotes / brackets /parens
  -- use 'windwp/nvim-ts-autotag'
  -- use 'kyazdani42/nvim-web-devicons' -- for icons in nvim-tree
  -- use 'nvim-tree/nvim-web-devicons' -- for icons in nvim-tree
  --
  -- use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' } -- tab bar
  -- use 'norcalli/nvim-colorizer.lua' -- colorize hex codes


  -- git (begin)
  use 'lewis6991/gitsigns.nvim' -- git signs in gutter
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'shumphrey/fugitive-gitlab.vim'
  -- git (end)


  -- Autocomplete / completion engine (begin)
  -- use 'hrsh7th/cmp-buffer'   -- nvim-cmp source for buffer words
  -- use 'hrsh7th/cmp-nvim-lsp' -- nvim-cpm source neovim's builtin LSP
  -- use 'hrsh7th/nvim-cmp'     -- completion engine
  -- use { 'saadparwaiz1/cmp_luasnip' } -- luasnip source for nvim-cmp
  -- Autocomplete / completion engine (end)

  --LSP (begin)

  -- use 'onsails/lspkind-nvim' -- vscode-like pictograms that show on LSP autocomplete
  -- use 'neovim/nvim-lspconfig'
  -- use "williamboman/mason.nvim"
  -- use {
  --   "williamboman/mason-lspconfig.nvim",
  --   requires = {
  --     "neovim/nvim-lspconfig",
  --   }
  -- }

  -- LSP (end)
  --
  --
  --




-- syntax highlighting with treesitter  (begin)
use { -- tree-sitter for syntax highlighting
  'nvim-treesitter/nvim-treesitter',
  run = ":TSUpdate",
}

use({
  "nvim-treesitter/nvim-treesitter-textobjects",
  requires = "nvim-treesitter/nvim-treesitter",
})
-- syntax highlighting (end)


  -- Telescope (begin)
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use {
    'LukasPietzschmann/telescope-tabs',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require 'telescope-tabs'.setup {
      }
    end
  }
  -- Telescope (end)

  use 'mfussenegger/nvim-lint'
  use 'tpope/vim-commentary'
  use { "kylechui/nvim-surround" }
  use 'tommcdo/vim-exchange'
  use 'dstein64/vim-startuptime'
  use 'AndrewRadev/switch.vim' -- cycle through alternatives 
  use 'mhartington/formatter.nvim'

  use 'github/copilot.vim'
  use 'junegunn/vim-easy-align'
  use 'tpope/vim-unimpaired'

end)
