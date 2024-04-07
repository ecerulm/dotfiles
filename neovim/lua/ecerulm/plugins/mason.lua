return {
  -- https://github.com/williamboman/mason.nvim
  "williamboman/mason.nvim",
  lazy = false,
  config = function()
    require("mason").setup({})
  end,
}
