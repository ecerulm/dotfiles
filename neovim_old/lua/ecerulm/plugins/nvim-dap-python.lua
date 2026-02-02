return {
	-- https://github.com/mfussenegger/nvim-dap-python
	"mfussenegger/nvim-dap-python",
	enabled = false,
	lazy = false,
	config = function()
		-- use the debugpy virtual environment created by :MasonInstall debugpy
		local python_path = table
		    .concat({ vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv", "bin", "python" }, "/")
		    :gsub("//+", "/")
		require("dap-python").setup(python_path)
	end,
	dependencies = {
		"mfussenegger/nvim-dap",
	},
}
