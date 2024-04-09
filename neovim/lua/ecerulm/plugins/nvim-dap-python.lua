return {
  -- https://github.com/mfussenegger/nvim-dap-python
  "mfussenegger/nvim-dap-python",
  enabled = true,
  lazy = false,
  config = function(_,opts)
    require('dap-python').setup('/Users/rubelagu/.pyenv/versions/debugpy/bin/python')
  end,
  dependencies = {
    'mfussenegger/nvim-dap',
  }

}
