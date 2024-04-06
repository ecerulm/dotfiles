-- local status, gitsigns = pcall(require, 'gitsigns')
-- if (not status) then return end

-- https://github.com/lewis6991/gitsigns.nvim
-- :Gitsigns toggle_signs
-- :Gitsigns toggle_current_line_blame

local gitsigns = require('gitsigns')
gitsigns.setup()
