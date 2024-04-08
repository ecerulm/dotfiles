-- Navigate nvim and tmux windows/panels with vim bindings
return {
  -- https://github.com/christoomey/vim-tmux-navigator
  'christoomey/vim-tmux-navigator',
  enabled = false,
  lazy = false,
  -- Only load this plugin if tmux is being used
  cond = function()
    return vim.fn.exists("$TMUX") == 1
  end,
}

