# Neovim Keymaps

> **Leader key:** `\` (backslash)
> Mini.basics sets leader to `<Space>` during setup; it is immediately restored to `\` afterwards.

______________________________________________________________________

## Conflicts and Overrides

| Key | Default Vim | This Config | Source |
|-----|-------------|-------------|--------|
| `<Space>` | Enter a space (insert), leader candidate | Cycle window forward (`<C-w>w`) | `init.lua` |
| `<Tab>` | Jump to next tab stop / indent | Cycle window forward (`<C-w>w`) | `init.lua` |
| `<C-u>` (insert) | Delete to start of line | Uppercase last WORD and return to insert | `init.lua` |
| `]c` / `[c` | Jump to next/prev diff change | gitsigns: next/prev hunk (falls back to diff jump in diff mode) | `init.lua` |
| `[c` / `]c` | mini.bracketed would also use these | mini.bracketed comment suffix disabled (`comment = { suffix = "" }`) to avoid this | `mini_config.lua` |
| `>` / `<` (visual) | Indent once, drop selection | Indent and re-select (`>gv` / `<gv`) | `init.lua` |
| `p` / `P` (visual/x) | `p` replaces and yanks old text; `P` does not yank | Swapped: `p` → `P` (no yank), `P` → `p` | `init.lua` |
| `grd` | LSP default: show references | Go to definition/implementation | `init.lua` |
| `gs` | Default: sleep | switch.vim: cycle word alternatives (true↔false, etc.) | `init.lua` (`vim.g.switch_mapping`) |
| `gx` | Open URL under cursor | Unchanged (mini.operators `exchange` was moved to `cx`; mini.operators `replace` moved to `cr` to avoid overriding `gx`) | `mini_config.lua` |
| `yo*` | — | Toggle option prefix (mini.basics) — see Toggles section | `mini_config.lua` |
| `<leader>n` | — | Show notification history (snacks) — note: mini.basics may also map this for line numbers | `snacks_config.lua` |
| `ih` (operator/visual) | — | gitsigns: select hunk (text object) | `init.lua` |

______________________________________________________________________

## General / Window

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| n | `ss` | Horizontal split | `init.lua` |
| n | `sv` | Vertical split | `init.lua` |
| n | `<Space>` | Cycle window forward (`<C-w>w`) | `init.lua` |
| n | `<Tab>` | Cycle window forward (`<C-w>w`) | `init.lua` |
| n | `<bs>` | Cycle window backward (`<C-w>W`) | `init.lua` |
| n | `<D-[>` | Dedent line (`<<`) — GUI/macOS only | `init.lua` |
| n | `<D-]>` | Indent line (`>>`) — GUI/macOS only | `init.lua` |
| n | `-` | Open MiniFiles at current file's directory | `mini_config.lua` |

______________________________________________________________________

## Insert Mode

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| i | `jk` | Exit insert mode (`<Esc>`) | `init.lua` |
| i | `<C-u>` | Uppercase last WORD (overrides default delete-to-BOL) | `init.lua` |

______________________________________________________________________

## Terminal Mode

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| t | `<Esc>` | Exit terminal mode | `init.lua` |
| t | `<C-v><Esc>` | Send literal `<Esc>` to terminal | `init.lua` |

______________________________________________________________________

## Command Mode

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| c | `%%` | Expand to directory of current buffer | `init.lua` |

______________________________________________________________________

## Text Objects

### Visual / Operator-Pending

| Mode | Key | Object | Source |
|------|-----|--------|--------|
| o, v | `ae` | Entire buffer | `init.lua` |
| x, o | `af` / `if` | Outer / inner function (treesitter) | `init.lua` |
| x, o | `ac` / `ic` | Outer / inner class (treesitter) | `init.lua` |
| x, o | `aa` / `ia` | Outer / inner parameter/argument (treesitter) | `init.lua` |
| x, o | `as` | Scope (treesitter locals) | `init.lua` |
| o, x | `ih` | Git hunk (gitsigns) | `init.lua` |

> `nvim-various-textobjs` also registers its default text objects (see `:h various-textobjs`). These include `iv`/`av` (value), `ik`/`ak` (key), `iS`/`aS` (subword), `iR`/`aR` (rest of paragraph), etc.

______________________________________________________________________

## Motions (Normal / Visual / Operator-Pending)

### Treesitter Textobjects — Move

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| n, x, o | `]m` | Next function start | `init.lua` |
| n, x, o | `]M` | Next function end | `init.lua` |
| n, x, o | `[m` | Prev function start | `init.lua` |
| n, x, o | `[M` | Prev function end | `init.lua` |
| n, x, o | `]]` | Next class start | `init.lua` |
| n, x, o | `][` | Next class end | `init.lua` |
| n, x, o | `[[` | Prev class start | `init.lua` |
| n, x, o | `[]` | Prev class end | `init.lua` |
| n, x, o | `]s` | Next scope start | `init.lua` |
| n, x, o | `]z` | Next fold start | `init.lua` |

### mini.bracketed (`[` / `]` navigation)

> Suffix letter follows `]`/`[`. Comment suffix is disabled (would conflict with `]c`/`[c` for hunks).

| Key | Object |
|-----|--------|
| `]b` / `[b` | Buffer |
| `]d` / `[d` | Diagnostic |
| `]f` / `[f` | File on disk |
| `]i` / `[i` | Indent change |
| `]j` / `[j` | Jump (jumplist) |
| `]l` / `[l` | Location list entry |
| `]o` / `[o` | Oldfile |
| `]q` / `[q` | Quickfix entry |
| `]t` / `[t` | Treesitter node |
| `]u` / `[u` | Undo |
| `]w` / `[w` | Window |
| `]x` / `[x` | Conflict marker |
| `]y` / `[y` | Yank |

### mini.diff

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / prev diff hunk (mini.diff) |

______________________________________________________________________

## LSP

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| n | `grd` | Go to definition/implementation (overrides default LSP references) | `init.lua` |

> Other LSP defaults remain active: `grn` (rename), `gra` (code action), `K` (hover), `<C-s>` (signature help in insert).

______________________________________________________________________

## Git (gitsigns) — buffer-local

> These are set per-buffer when gitsigns attaches.

### Navigation

| Mode | Key | Action |
|------|-----|--------|
| n | `]c` | Next hunk (falls back to `]c` diff jump in diff mode) |
| n | `[c` | Prev hunk (falls back to `[c` diff jump in diff mode) |

### Hunk Actions

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>hs` | Stage hunk |
| n | `<leader>hr` | Reset hunk |
| v | `<leader>hs` | Stage selected lines |
| v | `<leader>hr` | Reset selected lines |
| n | `<leader>hS` | Stage entire buffer |
| n | `<leader>hR` | Reset entire buffer |
| n | `<leader>hp` | Preview hunk (popup) |
| n | `<leader>hi` | Preview hunk inline |
| n | `<leader>hb` | Blame line (full) |
| n | `<leader>hd` | Diff this file vs HEAD |
| n | `<leader>hD` | Diff this file vs parent commit (`~`) |
| n | `<leader>hq` | Send hunks to quickfix list |
| n | `<leader>hQ` | Send all hunks (all buffers) to quickfix list |
| n | `<leader>hm` | Toggle diff base between fork point and HEAD (all buffers). Fork point is `git merge-base HEAD <target>` where target is the PR base branch (via `gh pr view`) if this is a PR, else `origin/HEAD`. SHA is cached for the session. |

### Toggles

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>tb` | Toggle current-line blame |
| n | `<leader>tw` | Toggle word diff |

______________________________________________________________________

## Git (snacks.nvim)

| Mode | Key | Action |
|------|-----|--------|
| n, v | `<leader>gc` | Copy GitHub URL for current file/selection to clipboard |
| n, v | `<leader>gB` | Open current file/line in browser (git browse) |
| n, v | `<leader>gb` | Git blame line (snacks) |
| n | `<leader>gbb` | Git branches picker |
| n | `<leader>gl` | Git log picker |
| n | `<leader>gL` | Git log for current line |
| n | `<leader>gs` | Git status picker |
| n | `<leader>gS` | Git stash picker |
| n | `<leader>gd` | Git diff (hunks) picker |
| n | `<leader>gf` | Git log for current file |
| n | `<leader>gg` | Open Lazygit UI |

______________________________________________________________________

## File / Buffer Pickers (snacks.nvim)

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>fb` | Find open buffers |
| n | `<leader>ff` | Find files |
| n | `<leader>fg` | Find git-tracked files |
| n | `<leader>fr` | Recent files |
| n | `<leader>fp` | Recent projects |

______________________________________________________________________

## Search / Grep (snacks.nvim)

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>/` | Grep across all files |
| n | `<leader>sg` | Grep across all files (alias) |
| n | `<leader>sb` | Grep in current buffer |
| n | `<leader>sB` | Grep across all open buffers |
| n, x | `<leader>sw` | Grep word under cursor / visual selection |
| n | `<leader>sd` | Search diagnostics (all) |
| n | `<leader>sD` | Search diagnostics (current buffer) |
| n | `<leader>sh` | Search help pages |
| n | `<leader>sk` | Search keymaps |

______________________________________________________________________

## Toggles (`yo*` — mini.basics / snacks)

| Key | Toggle |
|-----|--------|
| `yol` | List chars (show tabs, EOL, trailing spaces) |
| `yon` | Line numbers |
| `yor` | Relative line numbers |
| `yoh` | Highlight search |
| `yow` | Line wrap |
| `<leader>ud` | Diagnostics on/off |
| `<leader>uT` | Treesitter on/off |
| `<leader>tb` | gitsigns current-line blame |
| `<leader>tw` | gitsigns word diff |
| `<leader>m` | Mouse on/off |
| `<leader>d` | mini.diff overlay |

______________________________________________________________________

## Treesitter Swap (Parameters)

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>a` | Swap current parameter with next |
| n | `<leader>A` | Swap current parameter with previous |

______________________________________________________________________

## Operators (mini.operators)

| Key | Operator | Example |
|-----|----------|---------|
| `cr` | Replace region with register | `crip` replace paragraph with clipboard |
| `cx` / `cxx` | Exchange regions | `cxiw` then `cxiw` on another word |
| `gs` | Sort | `gsip` sort paragraph — **conflicts with switch.vim `gs`** |
| `gm` | Multiply/duplicate | `gmip` duplicate paragraph |

> **Conflict:** `gs` is claimed by both mini.operators (sort) and switch.vim (cycle alternatives). switch.vim wins because `vim.g.switch_mapping = "gs"` is set after mini.operators is loaded.

______________________________________________________________________

## Surround (mini.surround)

| Mode | Key | Action |
|------|-----|--------|
| n, x | `sa` | Add surrounding (e.g. `saiwb` wraps word in `()`) |
| n | `sd` | Delete surrounding |
| n | `sr` | Replace surrounding |
| n | `sf` | Find surrounding (forward) |
| n | `sF` | Find surrounding (backward) |
| n | `sh` | Highlight surrounding |
| n | `sn` | Update `n` for surroundings |

______________________________________________________________________

## Move Lines (mini.move)

| Mode | Key | Action |
|------|-----|--------|
| n | `<M-h>` / `<M-l>` | Move line left / right |
| n | `<M-j>` / `<M-k>` | Move line down / up |
| v | `<M-h>` / `<M-l>` | Move selection left / right |
| v | `<M-j>` / `<M-k>` | Move selection down / up |

> Requires Ghostty config `macos-option-as-alt = left` to pass `<M->` keys through.

______________________________________________________________________

## Snippets (mini.snippets)

| Mode | Key | Action |
|------|-----|--------|
| i | `<C-j>` | Expand snippet / confirm completion |
| i | `<C-l>` | Jump to next tabstop |
| i | `<C-h>` | Jump to previous tabstop |

______________________________________________________________________

## Comments (mini.comment)

| Mode | Key | Action |
|------|-----|--------|
| n | `gcc` | Toggle comment on line |
| n, v | `gc` | Toggle comment on motion/selection |

______________________________________________________________________

## Split / Join (mini.splitjoin)

| Mode | Key | Action |
|------|-----|--------|
| n | `gS` | Toggle split/join arguments/array/object |

______________________________________________________________________

## Alignment (mini.align)

| Mode | Key | Action |
|------|-----|--------|
| n, v | `ga` | Start alignment (interactive) |
| n, v | `gA` | Start alignment with preview |

______________________________________________________________________

## Switch (switch.vim)

| Mode | Key | Action |
|------|-----|--------|
| n | `gs` | Cycle word under cursor (true↔false, enabled↔disabled, `==`↔`!=`, etc.) |

______________________________________________________________________

## Misc

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| n | `<leader>cR` | Rename file (snacks) | `snacks_config.lua` |
| n | `<leader>.` | Toggle scratch buffer | `snacks_config.lua` |
| n | `<leader>n` | Show notification history | `snacks_config.lua` |
| n | `<leader>un` | Dismiss all notifications | `snacks_config.lua` |
| v | `>` | Indent and re-select | `init.lua` |
| v | `<` | Dedent and re-select | `init.lua` |
| x | `p` | Paste without yanking replaced text (mapped to `P`) | `init.lua` |
| x | `P` | Paste and yank replaced text (mapped to `p`) | `init.lua` |
