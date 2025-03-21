
-- vim.cmd[[highlight Whitespace gui=reverse guifg=#dc322f guibg=none guisp=none]]


-- highlight whitespace at the end of the line
-- vim.cmd[[match ExtraWhitespace /\s\+$/]]
-- vim.cmd[[highlight ExtraWhitespace ctermbg=red guibg=red]]
vim.cmd[[highlight GitSignsCurrentLineBlame ctermfg=grey ctermbg=darkblue]]


---
--- Terminal mode
---
--


vim.cmd[[highlight! link TermCursor Cursor]]
vim.cmd[[highlight! TermCursorNC guibg=red guifg=white ctermbg=red ctermfg=white]]
