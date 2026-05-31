# Changelog

## 2026-05-31

- Add `:ChangedFiles` user command — quickfix list of files changed on this branch vs its base (PR target via `gh`, else `origin/HEAD`, else `origin/main`), measured from the fork point; includes working-tree and untracked changes
- Add `:ChangedFiles!` variant — one quickfix entry per diff hunk (forces `a/`/`b/` prefixes so it survives `diff.mnemonicPrefix`/`diff.noprefix`)

## 2026-05-25

- Add `:Mergetool` user command — opens a 3-way merge view (LOCAL | MERGED | REMOTE, with BASE above) for the current buffer using its git index stages 1/2/3; requires the file to be in a conflicted state

## 2026-05-22

- Add `:DiffThisRemote` user command (gitsigns diffthis against upstream tracking branch)
- Add `:DiffThisMain` user command (gitsigns diffthis against merge-base of PR base / origin/HEAD / origin/main)
- Fix last-position-jump guard (`or` → `and`) so invalid `'"` positions are actually skipped
- Remove redundant `lua_ls` config block from `init.lua` (kept canonical copy in `after/lsp/lua.lua`)
- Remove duplicate `friendly-snippets` plugin entry
- Add `markdown`/`markdown_inline` treesitter parsers and populate `after/ftplugin/markdown.lua` (highlight + folds)
- Drop dead `cindent` from `after/indent/python.lua` (overridden by treesitter `indentexpr`)
- Sync `install_dependencies.sh`: `ruff` (replaces isort/black), add `mypy`, `jq`, `clang-format`, `tombi`
- Move insert-mode uppercase-last-WORD from `<C-u>` to `<C-l>`, restoring the built-in `i_CTRL-U`
- Disable global `cursorcolumn` (redraw lag with treesitter on large files)
- Drop global `smartindent` (misbehaves; superseded by treesitter `indentexpr`)
- Lower `mini.completion` delay from 1000ms to 150ms
- Gate the restore-cursor autocmd on normal buffers (skip help/terminal/plugin windows)
- Remove dead `align_blame` function and commented-out MiniGit block

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
