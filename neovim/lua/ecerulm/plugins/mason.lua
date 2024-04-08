return {
  -- https://github.com/williamboman/mason.nvim
  "williamboman/mason.nvim",
  enabled = true,
  lazy = false,
  config = function()
    require("mason").setup({})
  end,
}
