# This file is sourced for interactive and non-interactive shells.
# Do not put aliases or anything that changes shell behavior here —
# tools like make open shells to execute commands, and any aliases
# defined here would affect those shells.
#
# This is the place for $PATH, $EDITOR, $PAGER, $LANG, etc.

# Dedupe path/PATH automatically: any later `path+=…` becomes idempotent,
# so accidental double-adds in .zshrc / installer snippets are absorbed.
typeset -U path PATH fpath

# Repair an inherited stale $FPATH after a Homebrew zsh upgrade. A long-lived
# login session exports $FPATH pointing at Cellar/zsh/<version>/.../functions;
# once `brew upgrade zsh` bumps the version that dir disappears and core
# functions (compinit, add-zsh-hook, VCS_INFO_*) fail with "function definition
# file not found". Drop any nonexistent fpath entries — the `(N-/)` qualifier
# keeps only dirs that exist — and add the version-independent Homebrew dir
# (its files are symlinks Homebrew re-points on every upgrade).
fpath=(${^fpath}(N-/) /opt/homebrew/share/zsh/functions /opt/homebrew/share/zsh/site-functions)

# fpath is the search path for function definitions
fpath+=~/dotfiles/zsh/my-zsh-functions
# Private functions (machine/company-specific, not committed to git)
fpath+=~/dotfiles/zsh/my-zsh-functions-private

# HELPDIR: custom help files take priority; zsh system helpdir is the fallback.
# run-help and fcmd both use these for preview/help lookup.
# Private helpdir entries shadow the shared ones when names collide.
export HELPDIR=~/dotfiles/zsh/helpdir-private:~/dotfiles/zsh/helpdir

export PAGER="less"
export LESS="-FRX"
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export FZF_DEFAULT_COMMAND="fd ."
export EDITOR='nvim'
export LC_ALL="en_US.utf-8"
# GPG_TTY is set in .zshrc — it depends on $TTY which is only meaningful
# in an interactive shell. Setting it here would capture an empty/wrong value.
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/nvm"
[[ ! -d "$NVM_DIR" && -d "$HOME/.nvm" ]] && export NVM_DIR="$HOME/.nvm"

# PATH additions that should be visible to non-interactive shells too
# (scripts, make, editor subshells). Homebrew / Java / VS Code / Antigravity
# stay in .zshrc because they're either interactive-only or installer-managed.
[[ -d ~/.local/bin ]] && path=(~/.local/bin $path)
[[ -d ~/go/bin ]] && path+=(~/go/bin)
[[ -d ~/.pyenv/bin ]] && path+=(~/.pyenv/bin)
[[ -d "$HOME/opt/nvim/bin" ]] && path=("$HOME/opt/nvim/bin" $path)
[[ -d ~/Library/Application\ Support/Coursier/bin ]] \
    && path+=(~/Library/Application\ Support/Coursier/bin)

# Google Cloud SDK — path only (completion is interactive-only, stays in .zshrc)
[[ -f "$HOME/.local/google-cloud-sdk/path.zsh.inc" ]] \
    && . "$HOME/.local/google-cloud-sdk/path.zsh.inc"

# Rust / Rustup / Cargo
[[ -f "$HOME/.cargo/env" ]] && . "${HOME}/.cargo/env"

# For things that you don't want to share between all your machines
[[ -f ~/.zshenv.thismachine ]] && . ~/.zshenv.thismachine
