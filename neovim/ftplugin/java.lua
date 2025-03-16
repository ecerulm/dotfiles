local config = {
	cmd = { "jdtls" },
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
	init_options = {
		settings = {
			java = {
				implementationsCodeLens = { enabled = true },
				imports = {
					gradle = {
						enabled = true,
						wrapper = {
							enabled = true,
							checksums = {
								{
									sha256 = "81a82aaea5abcc8ff68b3dfcb58b3c3c429378efd98e7433460610fecd7ae45f",
									allowed = true,
								},
							},
						},
					},
				},
			},
		},
	},
	settings = {
		java = {
			configuration = {
				runtimes = THISMACHINESETTINGS.java_runtimes, -- from ~/.config/nvim/init.thismachine.lua
				-- echo $(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home
			},
			symbols = {
				includeSourceMethodDeclarations = true,
			},
		},
	},
}
require("jdtls").start_or_attach(config)
