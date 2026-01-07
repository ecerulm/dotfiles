-- vim.cmd[[highlight Whitespace gui=reverse guifg=#dc322f guibg=none guisp=none]]

-- highlight whitespace at the end of the line
-- vim.cmd[[match ExtraWhitespace /\s\+$/]]
-- vim.cmd[[highlight ExtraWhitespace ctermbg=red guibg=red]]
vim.cmd([[highlight GitSignsCurrentLineBlame ctermfg=grey ctermbg=darkblue]])

---
--- Terminal mode
---
--

-- Cursor is only for GUI vim, the cursor is handled by the terminal emulator otherwise
vim.cmd([[highlight! link TermCursor Cursor]])
vim.cmd([[highlight! TermCursorNC guibg=red guifg=white ctermbg=red ctermfg=white]])
