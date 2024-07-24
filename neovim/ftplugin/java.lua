local config = {
    cmd = {'jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
  settings = {
    java = {
      configuration = {
        runtimes = THISMACHINESETTINGS.java_runtimes, -- from ~/.config/nvim/init.thismachine.lua
      },
    },
  },
}
require('jdtls').start_or_attach(config)

