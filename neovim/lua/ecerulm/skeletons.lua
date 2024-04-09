local skeletons = {
	"Makefile", -- ~/.vim/skeleton.Makefile
	{ skeleton = "index.html", patterns = { "*.html" } }, -- ~/.vim/index.html
	"config.py", -- ~/.vim/skeleton.config.py
	"gitlab-ci.yml", -- ~/.vim/skeleton.gitlab-ci.yml
	"setup.py", -- ~/.vim/skeleton.setup.py
	"tox.ini", -- ~/.vim/skeleton.tox.ini
	"ansible.cfg", -- ~/.vim/skeleton.ansible.cfg
	"docker-compose.yml", -- ~/.vim/skeleton.docker-compose.yml
	"gradle.build", -- ~/.vim/skeleton.gradle.build
	"pom.xml", -- ~/.vim/skeleton.pom.xml
	"stack.yaml", -- ~/.vim/skeleton.stack.yaml
  ".isort.cfg", -- ~/.vim/skeleton.isort.cfg
}

for _, skeleton in pairs(skeletons) do
	local patterns = { skeleton }
	if type(skeleton) == "table" then
		patterns = skeleton["patterns"]
		skeleton = skeleton["skeleton"]
	end
	vim.api.nvim_create_autocmd({ "BufNewFile" }, {
		pattern = patterns,
		command = "r ~/.vim/skeleton." .. skeleton .. " | normal ggdd",
	})
end

-- vim.api.nvim_create_autocmd({ "BufNewFile" }, {
--   pattern = { "Makefile" },
--   command = "r ~/.vim/skeleton.Makefile | normal ggdd"
-- })

-- vim.api.nvim_create_autocmd({ "BufNewFile" }, {
--   pattern = { "ansible.cfg" },
--   command = "r ~/.vim/skeleton.html | normal ggdd"
-- })

-- vim.api.nvim_create_autocmd({ "BufNewFile" }, {
--   pattern = { "*.html" },
--   command = "r ~/.vim/skeleton.index.html | normal ggdd"
-- })
