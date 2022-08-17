require('base')
require('highlights')
require('maps')
require('plugins')

if vim.fn.has('macunix') then
  require('macos')
end
