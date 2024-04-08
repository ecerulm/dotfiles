-- https://github.com/mfussenegger/nvim-lint
return {

	"mfussenegger/nvim-lint",
  enabled = false,
  lazy = false,
	config = function()
		require("lint").linters_by_ft = {
			markdown = { "markdownlint", "vale" },
			sh = { "shellcheck" },
			lua = { "luacheck" },
			-- gitcommit = {'commitlint'},
		}
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				-- try_lint without arguments runs the linters defined in `linters_by_ft`
				-- for the current filetype
				require("lint").try_lint()

				-- You can call `try_lint` with a linter name or a list of names to always
				-- run specific linters, independent of the `linters_by_ft` configuration
				-- require("lint").try_lint("cspell")
			end,
		})
	end,
}
