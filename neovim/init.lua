require('ecerulm.base')
require('ecerulm.highlights')
require('ecerulm.maps')
require('ecerulm.plugins')

if vim.fn.has('macunix') then
	require('ecerulm.macos')
end
