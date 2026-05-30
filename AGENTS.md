# AGENTS.md

Guidance for coding agents working in this repo. `CLAUDE.md`/`GEMINI.md` symlink here — **edit `AGENTS.md` only**.

Personal macOS (+Linux) dotfiles, symlinked into place by `create_links_mac.sh` / `create_links_linux.sh` (run with `bash`). These also create `~/.config/` dirs and `brew install` required tools.

## Git Hooks (lefthook)

Configured in `lefthook.yml`; install once with `lefthook install`. `pre-commit` runs **strict** (warnings fail):

- **stylua** (`*.lua`, `--verify`), **mdformat** (`*.md`, `--number --end-of-line lf --wrap keep`, skips `CLAUDE.md`/`GEMINI.md` symlinks)
- **shfmt** (`*.sh`, `-s -i 2 -bn -ci -sr`), **shellcheck** (`*.sh`, `--severity=style --enable=all --external-sources`; disables in `.shellcheckrc`)
- **check-yaml**, **check-merge-conflict**, **check-added-large-files** (>500 KB), **trailing-whitespace**, **end-of-file-fixer**

Run manually: `lefthook run pre-commit [--all-files | --command <name>]`. `Justfile` wraps these (`just lint`, `lint-all`, `lint-cmd <name>`, `fmt-{lua,md,sh}`, `check-{sh,yaml}`); `lhd` is a zsh alias for lefthook over tracked files under cwd. Note: zsh function files in `my-zsh-functions/` are not `.sh`, so they're unchecked — validate with `zsh -n <file>`.

## Symlink Strategy

Root holds `.`-prefixed dotfiles; `create_links_mac.sh` globs and links them into `~`. Notable non-`~` links: `neovim/`→`~/.config/nvim` (+`nvim12`), `kitty/`→`~/.config/kitty`, `ghostty.conf`→`~/.config/ghostty/config`, `karabiner/`→`~/.config/karabiner`, `fishfunctions/`→`~/.config/fish/functions`, `gpg.conf`→`~/.gnupg/gpg.conf`, `sshconfig`→`~/.ssh/config`, `bin/*`→`~/bin/*`.

Platform-suffixed files link to generic names: `.gitconfig_osx`→`~/.gitconfig_platform_specific`, `.bashrc.macosx`→`~/.bashrc.extra`, `.tmux.conf.macosx`→`~/.tmux.conf.extra`.

`*.thismachine` files (e.g. `.zshrc.thismachine`) are gitignored and sourced at the end of their parent config for machine-local overrides.

## Zsh (`zsh/`)

Uses `ZDOTDIR` to keep zsh files in `zsh/`; root `.zshenv` sets `ZDOTDIR=$HOME/dotfiles/zsh` and sources `zsh/.zshenv`. See `zsh/CLAUDE.md` for conventions (naming, autoload, helpdir, fzf).

- `.zshenv` — env vars, `$fpath`, `$HELPDIR` (all shells); `.zshrc` — aliases, options, plugins, p10k (interactive)
- `.zprofile`/`.zlogin`/`.zlogout`, `.p10k.zsh`, `my-zsh-functions/` (autoloaded, `rlm-` prefixed, short-name aliases)

Notable functions: `rlm-pr-worktree`/`-rm`, `rlm-pr-for-commit`, `rlm-jira-open`, `rlm-jira-pick`, `rlm-fcmd`, `rlm-urldecode`, `rlm-pyactivate`/`-pyclean`, `rlm-mkpw`/`-randompassword`, `rlm-dnsflush`, `rlm-openports`, `rlm-generatectags`, `rlm-testterminal`. `rlm-wts` (inline in `.zshrc`) lists worktrees with cached Jira info from `~/.cache/wts-jira/`.

## Neovim (`neovim/`)

Lua config in `init.lua`, native `vim.pack` plugins (update: `:lua vim.pack.update()`; lockfile `nvim-pack-lock.json`). Key plugins: nvim-lspconfig, nvim-treesitter, conform.nvim (format on save), snacks.nvim, mini.nvim suite, nvim-surround, switch.vim. Has its own `AGENTS.md`/`CHANGELOG.md`/`README.md`.

Add a language: (1) `after/indent/<ft>.lua`, (2) `after/ftplugin/<ft>.lua` (folds + treesitter), (3) `vim.lsp.config()`/`vim.lsp.enable()` in `init.lua`, (4) formatter in conform's `formatters_by_ft`. Snippets: `neovim/snippets/<ft>.json`.

## Other

- `.gitconfig` — 80+ aliases, GPG signing, diff-so-fancy pager; platform config via `[include] ~/.gitconfig_platform_specific`
- `ghostty.conf` — `shell-integration-features = no-title` (stops OSC 2 tab-title rewrites)
- `bin/` — utility scripts → `~/bin/` (`git-churn`, `git-overwritten`, `cljrepl`, `bq-preview`, `wt-preview`, …)
- `karabiner/` — Karabiner removes symlinks (see `create_links_mac.sh` comment)
- `tmux.conf` + `tmux.conf.{macosx,linux}`; legacy: `emacs.d/`, `vim/`, `vimrc`, `neovim_old/`
