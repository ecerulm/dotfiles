return {
  -- https://github.com/hedyhli/outline.nvim?tab=readme-ov-file#installationhttps://github.com/hedyhli/outline.nvim?tab=readme-ov-file#installation
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  opts = {
    outline_window = {
      width = 40,
    },
    -- Your setup opts here
  }
}
