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
