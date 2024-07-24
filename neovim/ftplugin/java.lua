local config = {
    cmd = {'jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
  settings = {
    java = {
      configuration = {
        -- runtimes = {
        --   {
        --     name = "JavaSE-21",
        --     -- path = "/usr/local/opt/openjdk@21",
        --     path = "/usr/local/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
        --   },
        -- },
      },
    },
  },
}
require('jdtls').start_or_attach(config)

