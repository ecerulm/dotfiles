
return {
    -- https://github.com/lewis6991/gitsigns.nvim
    -- :Gitsigns toggle_signs
    -- :Gitsigns toggle_current_line_blame
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()
    end,
}
