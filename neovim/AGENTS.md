# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Overview

This is a Lua-based Neovim configuration using Neovim's native `vim.pack` plugin system (no external plugin manager). The config lives at `/Users/ecerulm/dotfiles/neovim` and is symlinked to `~/.config/nvim`.

## Plugin Management

- Update plugins: `:lua vim.pack.update()` inside Neovim
- Plugin versions are locked in `nvim-pack-lock.json`
- Install system dependencies (LSP servers, formatters): `./install_dependencies.sh`

## Architecture

- **`init.lua`**: Main entry point — global options, keymaps, treesitter setup, LSP configuration, conform.nvim (formatting), nvim-lint setup
- **`lua/mini_config.lua`**: All mini.nvim module configuration (completion, align, surround, comment, move, operators, snippets, files, splitjoin, statusline, diff, basics)
- **`lua/snacks_config.lua`**: snacks.nvim configuration (file pickers, git blame, lazygit, toggles)
- **`init_thismachine.lua`**: Machine-specific overrides (empty template, not committed)
- **`after/ftplugin/<filetype>.lua`**: Per-filetype settings (treesitter highlighting, folding)
- **`after/indent/<filetype>.lua`**: Per-filetype indentation settings
- **`after/lsp/<lspname>.lua`**: Per-LSP configuration
- **`after/snippets/<filetype>.json`**: Custom snippets (VSCode format)
- **`skeletons/`**: Template files inserted when creating new files of that type

## Adding Support for a New Language

1. **Indentation** — create `after/indent/<filetype>.lua`:

   ```lua
   vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
   vim.opt_local.shiftwidth = 2
   vim.opt_local.tabstop = 2
   vim.opt_local.expandtab = true
   ```

1. **Syntax/folding** — create `after/ftplugin/<filetype>.lua`:

   ```lua
   vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
   vim.opt_local.foldmethod = "expr"
   vim.treesitter.start()
   ```

1. **LSP** — add to `init.lua`:

   ```lua
   vim.lsp.config('server-name', { cmd = { '/path/to/server' } })
   vim.lsp.enable('server-name')
   ```

1. **Formatter** — add to `require("conform").setup({ formatters_by_ft = { ... } })` in `init.lua`

## Key Plugins

| Plugin | Purpose |
|--------|---------|
| nvim-lspconfig | LSP client configuration |
| nvim-treesitter | Syntax highlighting, folding, indentation |
| conform.nvim | Format on save, `:Format` command |
| snacks.nvim | File/buffer/git pickers, lazygit, git blame |
| mini.nvim | Completion, snippets, surround, comment, align, move, operators, statusline, diff |
| gitsigns.nvim | Git hunk signs, blame, diff in sign column |
| nvim-lint | Linting (mypy for Python) |
| switch.vim | Cycle between word alternatives (`gs`) |
| nvim-various-textobjs | Additional text objects |
