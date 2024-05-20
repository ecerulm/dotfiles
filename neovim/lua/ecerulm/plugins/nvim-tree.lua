-- File Explorer / Tree
return {
	-- https://github.com/nvim-tree/nvim-tree.lua
	"nvim-tree/nvim-tree.lua",
	enabled = true,
	lazy = false,
	dependencies = {
		-- https://github.com/nvim-tree/nvim-web-devicons
		"nvim-tree/nvim-web-devicons", -- Fancy icon support
	},
	config = function(_, opts)
		-- Recommended settings to disable default netrw file explorer
		-- vim.g.loaded_netrw = 1
		-- vim.g.loaded_netrwPlugin = 1

		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")
			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom mappings
			vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
			vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
		end

		require("nvim-tree").setup({
			disable_netrw = false,
			hijack_netrw = true,
			on_attach = my_on_attach,
		})
	end,
}
