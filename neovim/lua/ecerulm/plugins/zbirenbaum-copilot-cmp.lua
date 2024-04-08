return {
  "zbirenbaum/copilot-cmp",
  enabled = true,
  lazy = false,
  dependencies = {
    "zbirenbaum/copilot.lua",
  },
  config = function ()
    require("copilot_cmp").setup({})
  end
}
