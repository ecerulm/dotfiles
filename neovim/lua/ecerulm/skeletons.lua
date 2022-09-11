local skeletons = { "Makefile", { skeleton = "index.html", patterns = { "*.html" } }, "config.py", "gitlab-ci.yml",
  "setup.py", "tox.ini", "ansible.cfg",
  "docker-compose.yml", "gradle.build", "pom.xml", "stack.yaml" }

for _, skeleton in pairs(skeletons) do
  local patterns = { skeleton }
  if (type(skeleton) == "table") then
    patterns = skeleton['patterns']
    skeleton = skeleton['skeleton']
  end
  vim.api.nvim_create_autocmd({ "BufNewFile" }, {
    pattern = patterns,
    command = "r ~/.vim/skeleton." .. skeleton .. " | normal ggdd"
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
