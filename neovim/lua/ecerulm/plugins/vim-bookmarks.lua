-- https://github.com/MattesGroeger/vim-bookmarks
return {
  'MattesGroeger/vim-bookmarks',
  enabled = true,
  lazy = false,
  config = function()
    vim.cmd[[highlight BookmarkSign ctermbg=NONE ctermfg=160]]
    vim.cmd[[highlight BookmarkLine ctermbg=194 ctermfg=NONE]]
    vim.g.bookmark_sign = '♥'
    vim.g.bookmark_highlight_lines = 1
  end

}
