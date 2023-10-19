require('lint').linters_by_ft =  {
  markdown = {'vale'},
  sh = {'shellcheck'},
  lua = {'luacheck'},

}


local linterGrp = vim.api.nvim_create_augroup('Linters', {clear = true})


vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
  group = linterGrp,
})
