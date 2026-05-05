# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal dotfiles for macOS (with Linux support). Configuration files are symlinked from `~/dotfiles/` into place using `create_links_mac.sh` (macOS) or `create_links_linux.sh` (Linux).

## Setup

To apply all dotfiles and install dependencies:
```bash
bash create_links_mac.sh   # macOS
bash create_links_linux.sh # Linux
```

This creates symlinks for all dotfiles, sets up `~/.config/` directories, and runs `brew install` for all required tools.

## Pre-commit Hooks

Pre-commit is configured with StyLua (Lua formatter), trailing whitespace, end-of-file, YAML validity, and merge conflict checks.

```bash
pre-commit run --all-files   # run all hooks manually
pre-commit run stylua        # run only StyLua on staged files
```

Lua files in `neovim/` must pass StyLua formatting before commits will succeed.

## Architecture

### Symlink Strategy

The repo root contains dotfiles with their `.` prefix (e.g., `.gitconfig`, `.zshrc`). `create_links_mac.sh` globs all dot-files and symlinks them into `~`. Subdirectories are linked into `~/.config/<tool>/` or `~/bin/`.

### Platform-Specific Files

Suffixed files are symlinked to generic names at install time:
- `.gitconfig_osx` → `~/.gitconfig_platform_specific`
- `.bashrc.macosx` → `~/.bashrc.extra`
- `.tmux.conf.macosx` → `~/.tmux.conf.extra`

### Per-Machine Overrides

Files named `.thismachine` (e.g., `.zshrc.thismachine`, `.gitconfig.thismachine`) are sourced at the end of their parent configs for machine-local customization. These are gitignored.

## Key Components

### Neovim (`neovim/`)

Config is in `neovim/init.lua` (Lua-based, ~800 lines). Uses Neovim's native plugin system (`vim.pack`). Update plugins with `:lua vim.pack.update()`.

Key plugins: nvim-lspconfig, nvim-treesitter, conform.nvim (format on save), snacks.nvim (picker/fzf), mini.nvim suite (ai, align, comment, move, snippets, operators, splitjoin, diff), nvim-surround, switch.vim.

To add LSP/treesitter support for a new language:
1. Add `neovim/after/indent/<filetype>.lua` (indentation settings)
2. Add `neovim/after/ftplugin/<filetype>.lua` (folds + treesitter highlighting)
3. Add LSP config via `vim.lsp.config()`/`vim.lsp.enable()` in `init.lua`
4. Add formatter to `require("conform").setup({ formatters_by_ft = { ... } })` in `init.lua`

Snippets live in `neovim/snippets/<filetype>.json`.

### Zsh (`zsh/`)

- `.zshenv` — environment variables, `$FPATH` (sourced by all shells)
- `.zshrc` — aliases, options, plugin loading (sourced by interactive shells)
- `.zlogin` — login-only commands (fortune)
- `zsh/my-zsh-functions/` — autoloaded functions (lazy-loaded via `autoload -Uz`)

### Git (`.gitconfig`)

80+ aliases defined. Platform-specific config is included via `[include] path = ~/.gitconfig_platform_specific`. GPG signing is enabled; `diff-so-fancy` is used for paging.
