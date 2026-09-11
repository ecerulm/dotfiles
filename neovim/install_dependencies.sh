#!/bin/bash

brew_install() {
	if ! brew list --formula -- "$1" >/dev/null 2>&1; then
		brew install "$@"
	fi
}

uv_tool_install() {
	if ! command -v "$1" >/dev/null 2>&1; then
		uv tool install --force "$@"
	fi
}

brew_install lazygit

# LSP servers
brew_install lua-language-server # lua_ls
brew_install basedpyright
brew_install gopls
brew_install vscode-langservers-extracted # json/jsonc LSP
brew_install node                          # npm / prettier
node_prefix=$(brew --prefix node)
brew_prefix=$(brew --prefix)
export PATH="$node_prefix/bin:$brew_prefix/bin:$PATH"

# Formatters
brew_install stylua                               # lua
brew_install ruff                                 # python: ruff_fix + ruff_format (replaces isort/black)
brew_install jq                                   # json
brew_install clang-format                         # c / cpp
if ! command -v prettier >/dev/null 2>&1; then
	"$node_prefix/bin/npm" install --global prettier # json/jsonc
fi
go install github.com/shurcooL/markdownfmt@latest # markdown
uv_tool_install mbake                             # makefile: conform 'bake' formatter calls `mbake`
uv_tool_install tombi                             # toml
# terraform_fmt, gofmt, dart_format ship with terraform / go / dart toolchains

# Linters (nvim-lint)
uv_tool_install mypy # python
