# Changelog

## 2026-05-22

- Add `:DiffThisRemote` user command (gitsigns diffthis against upstream tracking branch)
- Add `:DiffThisMain` user command (gitsigns diffthis against merge-base of PR base / origin/HEAD / origin/main)
- Fix last-position-jump guard (`or` → `and`) so invalid `'"` positions are actually skipped
- Remove redundant `lua_ls` config block from `init.lua` (kept canonical copy in `after/lsp/lua.lua`)
- Remove duplicate `friendly-snippets` plugin entry
- Add `markdown`/`markdown_inline` treesitter parsers and populate `after/ftplugin/markdown.lua` (highlight + folds)
- Drop dead `cindent` from `after/indent/python.lua` (overridden by treesitter `indentexpr`)
- Sync `install_dependencies.sh`: `ruff` (replaces isort/black), add `mypy`, `jq`, `clang-format`, `tombi`

## 2026-05-16

- Wire local `git-pr-review.nvim` plugin into runtime via `vim.opt.rtp:prepend`
- Add `<leader>gP` keymap to toggle the `:PRView` drawer and document it in KEYMAPS.md

## 2026-05-14

- Add `<leader>hm` gitsigns keymap to toggle diff base between `origin/main` and HEAD by reading `gitsigns.config.base`
- Add KEYMAPS.md documenting all keymaps, conflicts, and overrides
- Add AGENTS.md instruction to keep KEYMAPS.md updated when keymaps change

## 2026-04-24

- Add tim-pope's vim-fugitive plugin
- Rename CLAUDE.md to AGENTS.md; add CLAUDE.md and GEMINI.md as symlinks
