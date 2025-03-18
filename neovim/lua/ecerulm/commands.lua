
vim.api.nvim_create_user_command(
  'Help',
  function(opts)
    -- vim.api.nvim_cmd({
    --   cmd={'vert'},
    --   -- args={'help', 'metals'},
    -- },{})
    vim.cmd ([[vert help ]] .. opts.args)
  end,
  {
    desc="Open help in vertical split",
    nargs="*",
  }
)
