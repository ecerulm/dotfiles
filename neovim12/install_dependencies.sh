#!/bin/bash

brew install lazygit

# LSP servers
brew install lua-language-server # lua_ls
brew install basedpyright
brew install gopls

# Formatters
brew install stylua
brew install isort black
go install github.com/shurcooL/markdownfmt@latest
