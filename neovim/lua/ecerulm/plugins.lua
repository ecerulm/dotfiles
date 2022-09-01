local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'svrana/neosolarized.nvim',
    requires = { 'tjdevries/colorbuddy.nvim' }
  }
  use 'nvim-lualine/lualine.nvim'
  use 'onsails/lspkind-nvim' -- vscode-like pictograms
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cpm source neovim's builtin LSP
  use 'hrsh7th/nvim-cmp' -- completion
  use 'neovim/nvim-lspconfig'
  use 'L3MON4D3/LuaSnip'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate"
  }
  use "windwp/nvim-autopairs"
  use 'windwp/nvim-ts-autotag'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use 'kyazdani42/nvim-web-devicons'
  -- using packer.nvim
  use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' }
  use 'norcalli/nvim-colorizer.lua'
  use 'glepnir/lspsaga.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  -- use({
  --   'MunifTanjim/prettier.nvim',
  --   requires = {
  --     'neovim/nvim-lspconfig',
  --     'jose-elias-alvarez/null-ls.nvim',
  --   }
  -- })
  use 'lewis6991/gitsigns.nvim'
  -- use 'dinhhuy258/git.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'shumphrey/fugitive-gitlab.vim'
  use "williamboman/mason.nvim"
  use {
    "williamboman/mason-lspconfig.nvim",
    requires = {
      "neovim/nvim-lspconfig",
    }
  }
  use 'tpope/vim-commentary'
  use { 'saadparwaiz1/cmp_luasnip' } -- luasnip source for nvim-cmp
  use { "kylechui/nvim-surround" }
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-textobjects'

end)
