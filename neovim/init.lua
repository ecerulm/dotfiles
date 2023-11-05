require('ecerulm.base')
require('ecerulm.highlights')
require('ecerulm.maps')
require('ecerulm.plugins')
require('ecerulm.skeletons')
require('ecerulm.filetypes')
require('ecerulm.lsp')
require('ecerulm.linters')

if vim.fn.has('macunix') then
  require('ecerulm.macos')
end

vim.cmd("colorscheme gruvbox")

require'lspconfig'.terraformls.setup{}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})
