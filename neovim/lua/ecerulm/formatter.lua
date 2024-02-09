local status, formatter = pcall(require, 'formatter')
if (not status) then return end

-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

      -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
    },
    json =require("formatter.filetypes.json").jq,
    -- terraform=require("formatter.filetypes.terraform").ddd, -- there is no formatter in formatter.nvim for terraform
    -- terraform = function()
    --   vim.lsp.buf.format({async=true})
    -- end,
    terraform = require("formatter.filetypes.terraform").terraformfmt, -- https://github.com/mhartington/formatter.nvim/blob/master/lua/formatter/filetypes/terraform.lua
    python = require("formatter.filetypes.python").black, -- https://github.com/mhartington/formatter.nvim/blob/91651e6afaf6f73b0ffb8b433c06cd4e06f90403/lua/formatter/filetypes/python.lua#L34-L40

    ruby = require("formatter.filetypes.ruby").rubocop,

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}