return {
  enabled = false, -- To get rid of the Error loading picker provider telescope
  -- https://github.com/pwntester/octo.nvim
  'pwntester/octo.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    -- OR 'ibhagwan/fzf-lua',
    -- OR 'folke/snacks.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function ()
    require"octo".setup()
  end
}
