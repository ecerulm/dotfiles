return {
	-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	enabled = true,
	lazy = false,
	dependencies = {
		-- https://github.com/williamboman/mason.nvim
		"williamboman/mason.nvim",
	},
	config = function()
		require("mason-tool-installer").setup({

			ensure_installed = {
				{ "golangci-lint", version = "v1.47.0" },
				{ "bash-language-server", auto_update = true },
				"lua-language-server",
				"vim-language-server",
				"gopls",
				"stylua",
				"shellcheck",
				"editorconfig-checker",
				"gofumpt",
				"golines",
				"gomodifytags",
				"gotests",
				"impl",
				"json-to-struct",
				"luacheck",
				"misspell",
				"revive",
				"shellcheck",
				"shfmt",
				"staticcheck",
				"vint",
				"flake8",
				"debugpy",
				"isort",
				"mypy",
				"pylint",
			},
			auto_update = true,
			run_on_start = true,
			start_delay = 0, -- 3 second delay
			debounce_hours = nil, -- at least 5 hours between attempts to install/update
		})
	end,
}
