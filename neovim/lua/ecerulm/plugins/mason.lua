return {
  -- https://github.com/williamboman/mason.nvim
  "williamboman/mason.nvim",
  enabled = true,
  lazy = false,
  config = function()
    require("mason").setup({})

    local registry = require "mason-registry"
    local Optional = require "mason-core.optional"
    local Package = require "mason-core.package"

    local ensure_installed = {'google-java-format'}
    local to_install = {}
    for i,package_name in ipairs(ensure_installed) do
        -- local server_name, version = Package.Parse(package_name)
      local package = registry.get_package(package_name)
      if not package:is_installed() then
          table.insert(to_install, package_name)
      end
    end
    if next(to_install) then
      require("mason.api.command").MasonInstall(to_install,{})
    end

    -- require("mason").install("google-java-format")

  end,
}
