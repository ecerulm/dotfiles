require('ecerulm.base')
require('ecerulm.highlights')
require('ecerulm.maps')
require('ecerulm.plugins')
require('ecerulm.skeletons')
require('ecerulm.filetypes')

if vim.fn.has('macunix') then
  require('ecerulm.macos')
end

vim.cmd("colorscheme gruvbox")
