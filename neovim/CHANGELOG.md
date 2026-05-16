# Changelog

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
