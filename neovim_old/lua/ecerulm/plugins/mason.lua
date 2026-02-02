return {
	-- https://github.com/williamboman/mason.nvim
	"williamboman/mason.nvim",
	enabled = true,
	lazy = false,
	init = function(_)
		local pylsp = require("mason-registry").get_package("python-lsp-server")
		pylsp:on("install:success", function()
			local function mason_package_path(package)
				local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
				return path
			end

			local path = mason_package_path("python-lsp-server")
			local command = path .. "/venv/bin/pip"
			local args = {
				"install",
				"-U",
				"pylsp-rope",
				"python-lsp-black",
				"python-lsp-isort",
				"python-lsp-ruff",
				"pyls-memestra",
				"pylsp-mypy",
			}

			require("plenary.job")
				:new({
					command = command,
					args = args,
					cwd = path,
				})
				:start()
		end)
	end,
	config = function()
		require("mason").setup({})

		local registry = require("mason-registry")
		local Optional = require("mason-core.optional")
		local Package = require("mason-core.package")

		local ensure_installed = {
			"google-java-format",
			"python-lsp-server",
			-- "python-lsp-server", -- python-language-server pylsp -- this is installed via mason-lspconfig
		}
		local to_install = {}
		for i, package_name in ipairs(ensure_installed) do
			-- local server_name, version = Package.Parse(package_name)
			local package = registry.get_package(package_name)
			if not package:is_installed() then
				table.insert(to_install, package_name)
			end
		end
		if next(to_install) then
			require("mason.api.command").MasonInstall(to_install, {})
		end

		-- require("mason").install("google-java-format")
	end,
}
