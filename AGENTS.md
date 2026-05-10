# AGENTS.md

Guidance for coding agents (Claude Code, Gemini CLI, etc.) working in this repository.
`CLAUDE.md` and `GEMINI.md` are symlinks to this file — edit `AGENTS.md` only.

## Repository Purpose

Personal dotfiles for macOS (with Linux support). Configuration files are symlinked from `~/dotfiles/` into place using `create_links_mac.sh` (macOS) or `create_links_linux.sh` (Linux).

## Setup

To apply all dotfiles and install dependencies:

```bash
bash create_links_mac.sh   # macOS
bash create_links_linux.sh # Linux
```

This creates symlinks for all dotfiles, sets up `~/.config/` directories, and runs `brew install` for required tools.

## Git Hooks (lefthook)

Hooks are managed by [lefthook](https://lefthook.dev) and configured in `lefthook.yml`. Install the git hook once after cloning:

```bash
lefthook install
```

Configured `pre-commit` checks (all run in **strict** mode — warnings fail the commit):

- **stylua** — formats `*.lua` with `--verify` (re-parses output to detect AST drift)
- **mdformat** — formats `*.md` with `--number --end-of-line lf --wrap keep` (skips `CLAUDE.md`/`GEMINI.md` symlinks)
- **shfmt** — formats `*.sh` with `-s -i 2 -bn -ci -sr` (simplify enabled)
- **shellcheck** — lints `*.sh` at `--severity=style --enable=all --external-sources`; per-rule disables live in `.shellcheckrc`
- **check-yaml** — validates `*.{yml,yaml}` parse
- **check-merge-conflict** — rejects unresolved conflict markers
- **check-added-large-files** — rejects staged files >500 KB
- **trailing-whitespace** / **end-of-file-fixer** — basic hygiene

Run manually (via lefthook directly, or the `Justfile` wrappers):

```bash
lefthook run pre-commit                     # against staged files
lefthook run pre-commit --all-files         # against everything
lefthook run pre-commit --command stylua    # single command
lhd                                         # zsh alias: lefthook on every tracked file under cwd

just                                        # list recipes
just lint                                   # = lefthook run pre-commit
just lint-all                               # = lefthook run pre-commit --all-files
just lint-cmd shellcheck                    # = lefthook run pre-commit --command shellcheck
just fmt-lua | fmt-md | fmt-sh              # mutate-in-place formatters
just check-sh | check-yaml                  # non-mutating lints
```

Lua files must pass StyLua, shell scripts must pass `shfmt` and `shellcheck --severity=warning`, and Markdown must be `mdformat`-clean before commits succeed.

## Architecture

### Symlink Strategy

The repo root contains dotfiles with their `.` prefix (e.g., `.gitconfig`, `.zshenv`). `create_links_mac.sh` globs all dot-files at the root and symlinks them into `~`. Subdirectories are linked into `~/.config/<tool>/` or `~/bin/`.

Notable non-`~` symlinks created by `create_links_mac.sh`:

- `neovim/` → `~/.config/nvim` (and `~/.config/nvim12`)
- `kitty/` → `~/.config/kitty`
- `ghostty.conf` → `~/.config/ghostty/config`
- `karabiner/` → `~/.config/karabiner`
- `fishfunctions/` → `~/.config/fish/functions`
- `gpg.conf` → `~/.gnupg/gpg.conf`
- `sshconfig` → `~/.ssh/config`
- `bin/*` → `~/bin/*`

### Platform-Specific Files

Suffixed files are symlinked to generic names at install time:

- `.gitconfig_osx` → `~/.gitconfig_platform_specific`
- `.bashrc.macosx` → `~/.bashrc.extra`
- `.tmux.conf.macosx` → `~/.tmux.conf.extra`

### Per-Machine Overrides

Files named `.thismachine` (e.g., `.zshrc.thismachine`, `.gitconfig.thismachine`) are sourced at the end of their parent configs for machine-local customization. These are gitignored.

## Key Components

### Zsh (`zsh/`)

The repo uses `ZDOTDIR` to keep all zsh files inside `zsh/` rather than at the home directory. The root `.zshenv` simply sets `ZDOTDIR=$HOME/dotfiles/zsh` and sources `zsh/.zshenv`.

- `zsh/.zshenv` — environment variables, `$FPATH` (sourced by all shells)
- `zsh/.zshrc` — aliases, options, plugin loading, p10k prompt (sourced by interactive shells)
- `zsh/.zprofile` / `zsh/.zlogin` / `zsh/.zlogout` — login/logout hooks
- `zsh/.p10k.zsh` — Powerlevel10k prompt config
- `zsh/my-zsh-functions/` — autoloaded functions (lazy-loaded via `autoload -Uz`)

Notable autoloaded functions in `zsh/my-zsh-functions/`:

- `pr-worktree`, `pr-worktree-rm` — create/remove a git worktree for a GitHub PR
- `pr-for-commit` — find the PR associated with a commit
- `jira-open` — open the JIRA ticket inferred from branch/PR/commits
- `fcmd` — fzf picker over every alias/function/builtin/reserved word/`$PATH` command, with a preview of what each resolves to
- `urldecode` — split a URL into components and percent-decode its query string (one `key = value` line per param); reads `$1` or stdin
- `pyactivate`, `pyclean` — Python venv helpers
- `mkpw`, `randompassword` — password generation
- `dnsflush`, `openports`, `generatectags`, `testterminal`

`wts` (defined inline in `.zshrc`) shows worktrees with cached Jira info from `~/.cache/wts-jira/`.

### Neovim (`neovim/`)

Config is in `neovim/init.lua` (Lua-based, ~670 lines). Uses Neovim's native plugin system (`vim.pack`). Update plugins with `:lua vim.pack.update()`. The plugin lockfile is `neovim/nvim-pack-lock.json`.

Key plugins: nvim-lspconfig, nvim-treesitter, conform.nvim (format on save), snacks.nvim (picker/fzf), mini.nvim suite (ai, align, comment, move, snippets, operators, splitjoin, diff), nvim-surround, switch.vim.

To add LSP/treesitter support for a new language:

1. Add `neovim/after/indent/<filetype>.lua` (indentation settings)
2. Add `neovim/after/ftplugin/<filetype>.lua` (folds + treesitter highlighting)
3. Add LSP config via `vim.lsp.config()` / `vim.lsp.enable()` in `init.lua`
4. Add formatter to `require("conform").setup({ formatters_by_ft = { ... } })` in `init.lua`

Snippets live in `neovim/snippets/<filetype>.json`. The `neovim/` directory has its own `AGENTS.md` / `CHANGELOG.md` / `README.md` for editor-specific guidance.

### Git (`.gitconfig`)

~220 lines, 80+ aliases. Platform-specific config is included via `[include] path = ~/.gitconfig_platform_specific`. GPG signing is enabled; `diff-so-fancy` is used for paging.

### Terminal Emulators

- `kitty/` — Kitty terminal config (`~/.config/kitty`)
- `ghostty.conf` — Ghostty config including `shell-integration-features = no-title` to keep Ghostty from rewriting tab titles via OSC 2

### Other

- `bin/` — small utility scripts symlinked into `~/bin/` (e.g. `git-churn`, `git-overwritten`, `cljrepl`, `jsonoverview.jq`)
- `karabiner/` — Karabiner-Elements key remaps (note: Karabiner removes symlinks, see comment in `create_links_mac.sh`)
- `tmux.conf` + `tmux.conf.macosx` / `tmux.conf.linux` — tmux config with platform-specific extras
- `emacs.d/`, `vim/`, `vimrc`, `neovim_old/` — legacy editor configs kept for reference
