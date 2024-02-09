local status, lspconfig = pcall(require, 'lspconfig')
if (not status) then return end
lspconfig.terraformls.setup{}
