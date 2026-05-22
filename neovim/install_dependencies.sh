#!/bin/bash

brew install lazygit

# LSP servers
brew install lua-language-server # lua_ls
brew install basedpyright
brew install gopls

# Formatters
brew install stylua                               # lua
brew install ruff                                 # python: ruff_fix + ruff_format (replaces isort/black)
brew install jq                                   # json
brew install clang-format                         # c / cpp
go install github.com/shurcooL/markdownfmt@latest # markdown
pipx install mbake                                # makefile: conform 'bake' formatter calls `mbake`
pipx install tombi                                # toml
# terraform_fmt, gofmt, dart_format ship with terraform / go / dart toolchains

# Linters (nvim-lint)
pipx install mypy # python
