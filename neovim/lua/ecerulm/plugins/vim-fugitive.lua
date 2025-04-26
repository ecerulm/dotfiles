return {
	-- https://github.com/tpope/vim-fugitive
	"tpope/vim-fugitive",
	enabled = true,
	lazy = false,
	config = function()
		-- vim.g.fugitive_gitlab_domains = {'https://gitlab.mycompany.com', ''}
		-- vim.g.fugitive_gitlab_domains = {'', ''} -- put the private gitlab domains in ~/.config/nvim/init.thismachine.lua
		-- vim.g.fugitive_gitlab_domains = { "gitlab.com" }
		-- vim.cmd("echom g:fugitive_gitlab_domains")
		vim.api.nvim_create_user_command(
			"Browse",
			[[silent execute "!open " .. shellescape(<q-args>,1)]],
			{ nargs = 1 }
		)
	end,
}
