require("ecerulm.plugins")
require("ecerulm.base")
require("ecerulm.highlights")
require("ecerulm.maps")
require("ecerulm.skeletons")
require("ecerulm.filetypes")
require("ecerulm.lsp")
require("ecerulm.linters")
require("ecerulm.mason")
require("ecerulm.formatter") -- configure mhartington/formatter.nvim if it's loaded
require("ecerulm.treesitter") -- configure nvim-treesitter if it's loaded

if vim.fn.has("macunix") then
	require("ecerulm.macos")
end


-- local formatAutoGroup = vim.api.nvim_create_augroup("FormatAutoGroup", {clear = true})
-- vim.api.nvim_create_autocmd(
--   {"BufWritePost"}, -- events to react to
--   {
--     command = "FormatWrite",
--     group = formatAutoGroup,
--   }

-- )

-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
--   pattern = {"*.tf", "*.tfvars"},
--   callback = function()
--     vim.lsp.buf.format()
--   end,
-- })
--

local function source_file_if_exists(file_path)
	local file = io.open(file_path, "r")
	if file then
		io.close(file)
		dofile(file_path)
	end
end

source_file_if_exists(vim.fn.stdpath("config") .. "/init.thismachine.lua")

-- vim.g.fugitive_gitlab_domains = { "gitlab.com" }
-- vim.cmd("echom g:fugitive_gitlab_domains")
