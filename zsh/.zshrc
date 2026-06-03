# Sourced by interactive shells (incl. login shells). Non-interactive
# shells launched by make / scripts / editors do NOT source this — put
# environment-only state in .zshenv instead.
#
# This is where you define aliases, functions, shell options, keybindings.

# Homebrew prefix is hardcoded — avoids 4× `brew --prefix` subshells at
# startup (~50ms each). Apple Silicon uses /opt/homebrew; Intel Macs use
# /usr/local. Override per-machine in .zshrc.thismachine if needed.
HOMEBREW_PREFIX=/opt/homebrew

# Homebrew bin: kept in .zshrc (not .zshenv) so non-interactive shells
# spawned by make/scripts use the system tools by default. typeset -U in
# .zshenv keeps repeated path+= calls below idempotent.
path+=($HOMEBREW_PREFIX/bin)

# Ruby (brew) + gems — gives us `pod` etc.
[[ -d "$HOMEBREW_PREFIX/opt/ruby/bin" ]] && path=("$HOMEBREW_PREFIX/opt/ruby/bin" $path)
if (( $+commands[gem] )); then
	_gem_home=$(gem env home)
	[[ -d "$_gem_home/bin" ]] && path=("$_gem_home/bin" $path)
	unset _gem_home
fi

# Postgres client (libpq)
[[ -d "$HOMEBREW_PREFIX/opt/libpq/bin" ]] && path=("$HOMEBREW_PREFIX/opt/libpq/bin" $path)

HIST_STAMPS="yyyy-mm-dd"

# direnv will load the .envrc file on cd
eval "$(direnv hook zsh)"


# History — SHARE_HISTORY implies INC_APPEND_HISTORY and is mutually
# exclusive with APPEND_HISTORY / INC_APPEND_HISTORY_TIME (zsh enforces
# this), so an explicit `setopt SHARE_HISTORY` is all we need.
HISTSIZE=10000000
SAVEHIST=10000000
setopt SHARE_HISTORY

alias rlm-zshconfig="nvim $ZDOTDIR/.zshrc"
alias zshconfig='rlm-zshconfig'

# To customize prompt, run `p10k configure` or edit ~/dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/dotfiles/zsh/.p10k.zsh ]] || source ~/dotfiles/zsh/.p10k.zsh



alias vi=nvim
alias vim=nvim

alias rlm-s="git st"
alias rlm-gdc="git dc"
alias rlm-gd="git d"
alias rlm-gc="git commit -v"
alias rlm-gca="git commit -v --amend"
alias rlm-gau="git a" # git add -u
alias rlm-gap="git a -p"
alias rlm-gas="git as" # Add files that are already staged
alias rlm-glc="git rev-parse HEAD"
alias rlm-gdm="git diff main"
alias rlm-gdms="git diff --stat main"
alias rlm-diffmain='git fetch; git diff --stat $(git merge-base --fork-point origin/main HEAD)'
alias rlm-reviewmain='git fetch; git log $(git merge-base --fork-point origin/main HEAD)..HEAD'
alias rlm-gdlc="git diff HEAD^ HEAD" # or git diff @~..@
alias rlm-gdw="git diff"
alias rlm-gfa="git fetch --all"
alias rlm-gb="git branch --sort=-committerdate"
alias s="git st"
alias gdc="git dc"
alias gd="git d"
alias gc="git commit -v"
alias gca="git commit -v --amend"
alias gau="git a" # git add -u
alias gap="git a -p"
alias gas="git as" # Add files that are already staged
alias glc="git rev-parse HEAD"
alias gdm="git diff main"
alias gdms="git diff --stat main"
alias diffmain='git fetch; git diff --stat $(git merge-base --fork-point origin/main HEAD)'
alias reviewmain='git fetch; git log $(git merge-base --fork-point origin/main HEAD)..HEAD'
alias gdlc="git diff HEAD^ HEAD" # or git diff @~..@
alias gdw="git diff"
alias gfa="git fetch --all"
alias gb="git branch --sort=-committerdate"

alias rlm-l="eza -l -s mod"
alias rlm-t="eza -l -s mod -T --git-ignore"
alias rlm-reuse-annotate="pipx run reuse annotate --year 2023 --copyright 'Ruben Laguna <ruben.laguna@gmail.com>' --license GPL-3.0-or-later"
# alias imgcat="kitty +kitten icat"
# alias icat="kitty +kitten icat"
alias rlm-tp="terraform plan -out latest.tfplan"
alias rlm-ta="terraform apply latest.tfplan"
alias l="eza -l -s mod"
alias t="eza -l -s mod -T --git-ignore"
alias reuse-annotate="pipx run reuse annotate --year 2023 --copyright 'Ruben Laguna <ruben.laguna@gmail.com>' --license GPL-3.0-or-later"
alias tp="terraform plan -out latest.tfplan"
alias ta="terraform apply latest.tfplan"

autoload -Uz rlm-pyactivate
autoload -Uz rlm-hello
autoload -Uz rlm-testterminal
autoload -Uz rlm-dnsflush
autoload -Uz rlm-openports
autoload -Uz rlm-pyclean
autoload -Uz rlm-randompassword
autoload -Uz rlm-mkpw
autoload -Uz rlm-pr-worktree
autoload -Uz rlm-pr-worktree-rm
autoload -Uz rlm-pr-worktree-rm-merged-closed
autoload -Uz rlm-gh-fork
autoload -Uz rlm-gh-repo-init
autoload -Uz rlm-bq-archive
autoload -Uz rlm-bq-open
autoload -Uz rlm-sandbox-bq-open
autoload -Uz rlm-sandbox-bq-rm
autoload -Uz rlm-bq-rm-tables
autoload -Uz rlm-gcp-project-open
autoload -Uz rlm-gar-open
autoload -Uz rlm-gar-search
autoload -Uz rlm-pubsub-open
autoload -Uz rlm-jira-open
autoload -Uz rlm-jira-pick
autoload -Uz rlm-brew-unlock
autoload -Uz rlm-fcmd
autoload -Uz rlm-urldecode
autoload -Uz rlm-generatectags
autoload -Uz rlm-pr-for-commit
autoload -Uz rlm-afw-deploy
autoload -Uz rlm-gh-permalink
autoload -Uz rlm-git-changed
autoload -Uz rlm-git-diff-base
autoload -Uz rlm-git-find-in-remotes
autoload -Uz rlm-git-squash-branch
autoload -Uz rlm-git-squash-branch-old
autoload -Uz rlm-dbt
autoload -Uz rlm-dbt-build
autoload -Uz rlm-dbt-find-source-code
autoload -Uz rlm-dbt-ls
autoload -Uz rlm-dbt-run
autoload -Uz rlm-dbt-sandbox
autoload -Uz rlm-dbt-test
autoload -Uz rlm-tsconv
# run-help: use the real autoloaded version (default is aliased to man)
unalias run-help 2>/dev/null
autoload -Uz run-help
# short aliases for autoloaded functions
alias pyactivate='rlm-pyactivate'
alias hello='rlm-hello'
alias testterminal='rlm-testterminal'
alias dnsflush='rlm-dnsflush'
alias openports='rlm-openports'
alias pyclean='rlm-pyclean'
alias mkpw='rlm-mkpw'
alias pr-worktree='rlm-pr-worktree'
alias pr-worktree-rm='rlm-pr-worktree-rm'
alias pr-worktree-rm-merged-closed='rlm-pr-worktree-rm-merged-closed'
alias gh-fork='rlm-gh-fork'
alias gh-repo-init='rlm-gh-repo-init'
alias create-gh-repo='rlm-gh-repo-init'
alias gh-permalink='rlm-gh-permalink'
alias git-changed='rlm-git-changed'
alias git-diff-base='rlm-git-diff-base'
alias git-find-in-remotes='rlm-git-find-in-remotes'
alias git-squash-branch='rlm-git-squash-branch'
alias git-squash-branch-old='rlm-git-squash-branch-old'
alias bq-archive='rlm-bq-archive'
alias bq-open='rlm-bq-open'
alias sandbox-bq-open='rlm-sandbox-bq-open'
alias sandbox-bq-rm='rlm-sandbox-bq-rm'
alias bq-rm-tables='rlm-bq-rm-tables'
alias gcp-project-open='rlm-gcp-project-open'
alias gar-open='rlm-gar-open'
alias gar-search='rlm-gar-search'
alias pubsub-open='rlm-pubsub-open'
alias jira-open='rlm-jira-open'
alias jira-pick='rlm-jira-pick'
alias brew-unlock='rlm-brew-unlock'
alias fcmd='rlm-fcmd'
alias urldecode='rlm-urldecode'
alias generatectags='rlm-generatectags'
alias pr-for-commit='rlm-pr-for-commit'
alias afw-deploy='rlm-afw-deploy'
alias dbt='rlm-dbt'
alias dbt-build='rlm-dbt-build'
alias dbt-find-source-code='rlm-dbt-find-source-code'
alias dbt-ls='rlm-dbt-ls'
alias dbt-run='rlm-dbt-run'
alias dbt-sandbox='rlm-dbt-sandbox'
alias dbt-test='rlm-dbt-test'
alias tsconv='rlm-tsconv'

# brew shellenv — single eval based on the hardcoded prefix above.
# Sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, MANPATH, INFOPATH; PATH bits
# are absorbed by `typeset -U path`.
[[ -x $HOMEBREW_PREFIX/bin/brew ]] && eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

# NVM (NVM_DIR is already exported from .zshenv)
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"

alias rlm-randompassword="LC_ALL=C tr -cd '[:alnum:]' < /dev/urandom | fold -w30 |head -n1"
alias randompassword="LC_ALL=C tr -cd '[:alnum:]' < /dev/urandom | fold -w30 |head -n1"


if builtin command -v eza >/dev/null ;then
  alias ls="eza -l --git --icons --time-style long-iso -snew"
fi

# if builtin command -v bat >/dev/null ;then
#   alias cat=bat
# fi

if builtin command -v zoxide >/dev/null ;then
  eval "$(zoxide init zsh)"
  alias cd=z
fi

# fzf integration — keybindings + completion. Hardcode the fzf share dir
# off the brew prefix to skip two `brew --prefix fzf` subshells at startup.
_fzf_share=$HOMEBREW_PREFIX/opt/fzf/shell
[[ -e $_fzf_share/key-bindings.zsh ]] && source $_fzf_share/key-bindings.zsh
[[ -e $_fzf_share/completion.zsh ]] && source $_fzf_share/completion.zsh
unset _fzf_share


if builtin command -v fuck >/dev/null ;then
 eval $(thefuck --alias)
fi

[[ -f ~/.zshrc.thismachine ]] && source ~/.zshrc.thismachine

# GPG_TTY — set here (not .zshenv) so we capture the interactive TTY.
export GPG_TTY=$TTY

alias rlm-ctags="ctags -R --fields=+zK"
alias ctags="ctags -R --fields=+zK"

# SDKMAN — install snippet says "must be at the end of the file"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# gcloud shell completion (path.zsh.inc is in .zshenv so non-interactive shells see it too)
[[ -f "$HOME/.local/google-cloud-sdk/completion.zsh.inc" ]] \
    && . "$HOME/.local/google-cloud-sdk/completion.zsh.inc"

# Key bindings
# Uncomment to force emacs-mode keymap so Ctrl-A / Ctrl-E (and other emacs
# bindings) work. zsh picks viins when $EDITOR or $VISUAL matches *vi* —
# our EDITOR='nvim' (.zshenv) triggers that, leaving ^A/^E as self-insert.
# bindkey -e
bindkey ' ' magic-space

# VS Code CLI
[[ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]] \
    && path+=("/Applications/Visual Studio Code.app/Contents/Resources/app/bin")

# OpenJDK 21 (brew). Prepend so `java`/`javac` resolve here first.
if [[ -x "$HOMEBREW_PREFIX/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home/bin/javac" ]]; then
    export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
    path=("${JAVA_HOME}/bin" $path)
fi

autoload -Uz vcs_info
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
setopt prompt_subst # setopp PROMPT_SUBST is required to enable prompt substitution
setopt interactivecomments # so you can use # in the shell when you copy and paste

zstyle ':vcs_info:git*' formats " %F{blue}%b%f %m%u%c %a "
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' %F{green}✚%f'
zstyle ':vcs_info:*' unstagedstr ' %F{red}●%f'

precmd() {
    vcs_info
    print -P '%B%~%b ${vcs_info_msg_0_}'
}

PROMPT='%B%(!.#.$)%b '


# Google Antigravity CLI
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && path+=("$HOME/.antigravity/antigravity/bin")

alias rlm-pu="pulumi up"
alias rlm-pus="pulumi up --skip-preview"
alias pu="pulumi up"
alias pus="pulumi up --skip-preview"

# export PATH=$HOME/.jbang/bin:$PATH
# export PATH="/usr/local/opt/openjdk@17/bin:$PATH"

function rlm-awsprofile {
  export AWS_PROFILE=$(aws configure list-profiles|fzf)
}
alias awsprofile='rlm-awsprofile'

function rlm-switchbranch {
  git switch $(git branch | fzf)
}
alias switchbranch='rlm-switchbranch'

function rlm-sqlfluff-fix {
pre-commit run sqlfluff-fix --from-ref $(git merge-base --fork-point origin/main HEAD) --to-ref HEAD
}

function rlm-sqlfluff-lint {
pre-commit run sqlfluff-lint --from-ref $(git merge-base --fork-point origin/main HEAD) --to-ref HEAD
}
alias sqlfluff_fix='rlm-sqlfluff-fix'
alias sqlfluff_lint='rlm-sqlfluff-lint'


# resets Kitty Keyboard Protocol after each command, avoid the ctrl-c showing up as 9;5u after killing claude
rlm-reset-kkp() {
	print '\e[>u'
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd rlm-reset-kkp


# path+=$(pyenv prefix 3.14)/bin


# Refresh the cached Jira info for a given key into ~/.cache/wts-jira/.
# Writes two files:
#   <KEY>.summary  — single line: "(Status) Summary"   (used in the fzf list)
#   <KEY>.preview  — multi-line, ANSI-colored          (used in the fzf preview pane)
# Cache TTL is 1 hour. Failures (auth, network, missing key) leave the files empty.
_rlm-wts-jira-refresh() {
	local key="$1" dir="$HOME/.cache/wts-jira"
	local sf="$dir/$key.summary" pf="$dir/$key.preview"
	mkdir -p "$dir"

	# Skip if cache is fresh (<1h old) AND non-empty.
	if [[ -s "$sf" ]]; then
		local age now mtime
		now=$(date +%s)
		mtime=$(stat -f %m "$sf" 2>/dev/null || stat -c %Y "$sf" 2>/dev/null || echo 0)
		age=$(( now - mtime ))
		(( age < 3600 )) && return 0
	fi

	command -v acli >/dev/null 2>&1 || { : >"$sf"; : >"$pf"; return 0; }

	local raw
	raw=$(acli jira workitem view "$key" -f summary,status,assignee,issuetype 2>/dev/null) || {
		: >"$sf"; : >"$pf"; return 0
	}
	[[ -z "$raw" ]] && { : >"$sf"; : >"$pf"; return 0; }

	# NB: `status` is a read-only special in zsh; use jstatus/etc.
	local summary jstatus assignee itype
	summary=$(printf '%s\n' "$raw"  | awk -F': ' '/^Summary: /{sub(/^Summary: /,""); print; exit}')
	jstatus=$(printf '%s\n' "$raw"  | awk -F': ' '/^Status: /{sub(/^Status: /,""); print; exit}')
	assignee=$(printf '%s\n' "$raw" | awk -F': ' '/^Assignee: /{sub(/^Assignee: /,""); print; exit}')
	itype=$(printf '%s\n' "$raw"    | awk -F': ' '/^Type: /{sub(/^Type: /,""); print; exit}')

	# Trim summary for the inline column so wide-terminal layout stays readable.
	local short="$summary"
	if (( ${#short} > 60 )); then
		short="${short:0:57}..."
	fi
	if [[ -n "$jstatus" ]]; then
		printf '(%s) %s\n' "$jstatus" "$short" >"$sf"
	else
		printf '%s\n' "$short" >"$sf"
	fi

	# Preview pane: a few colored lines. Keep it compact — fzf preview is small.
	{
		printf '\033[1m%s\033[0m  \033[2m%s\033[0m\n' "$key" "${itype:-?}"
		printf '\033[1;33m%s\033[0m\n' "${jstatus:-unknown status}"
		printf '\n%s\n' "${summary:-(no summary)}"
		[[ -n "$assignee" ]] && printf '\n\033[2massignee:\033[0m %s\n' "$assignee"
	} >"$pf"
}

# git worktree switch / cd into a worktree, presents a fuzzy finder with all the worktree in the current repo.
# Display rules: $HOME -> ~, strip the longest common ancestor across all worktree paths,
# and if a line is wider than the terminal, truncate from the left (preserving the tail) with a leading "...".
# When a worktree's branch contains a Jira key (e.g. DATA-1234, DATA-2538-foo, feature/DATA-9), the line is
# annotated with "(Status) Summary" from Jira and a fuller preview pane is shown via fzf --preview.
rlm-wts() {
	# Suppress "[1] 2966" job-control chatter from the background _wts_jira_refresh
	# calls and the watchdog subshell below. local_options scopes these to the function.
	setopt local_options no_notify no_monitor
	local -a paths rest jkeys display
	local line p r common selected dir

	while IFS= read -r line; do
		p="${line%% *}"
		r="${line#"$p"}"
		r="${r# }"
		paths+=("${p/#$HOME/~}")
		rest+=("$r")

		# Extract a Jira-style key (LETTERS-NUMBER) from the bracketed branch name.
		local branch="" jkey=""
		if [[ "$r" == *\[*\]* ]]; then
			branch="${r##*\[}"
			branch="${branch%%\]*}"
		fi
		if [[ "$branch" =~ ([A-Z][A-Z0-9]+-[0-9]+) ]]; then
			jkey="${match[1]}"
		fi
		jkeys+=("$jkey")
	done < <(git worktree list)

	[[ ${#paths[@]} -eq 0 ]] && return 0

	# Refresh Jira info in parallel; cache lives in ~/.cache/wts-jira.
	local i
	local -a pids
	for (( i=1; i<=${#jkeys[@]}; i++ )); do
		[[ -n "${jkeys[$i]}" ]] || continue
		_rlm-wts-jira-refresh "${jkeys[$i]}" &
		pids+=($!)
	done
	# Bound the wait so a slow/hung acli call can't freeze the picker.
	if (( ${#pids[@]} > 0 )); then
		( sleep 3; for pid in "${pids[@]}"; do kill "$pid" 2>/dev/null; done ) &
		local guard=$!
		wait "${pids[@]}" 2>/dev/null
		kill "$guard" 2>/dev/null
	fi

	if [[ ${#paths[@]} -gt 1 ]]; then
		common="${paths[1]}"
		while [[ -n "$common" ]]; do
			local all_match=1
			for p in "${paths[@]}"; do
				[[ "$p" == "$common"/* || "$p" == "$common" ]] || { all_match=0; break; }
			done
			(( all_match )) && break
			common="${common%/*}"
		done
	else
		common=""
	fi

	local shown abs
	for (( i=1; i<=${#paths[@]}; i++ )); do
		shown="${paths[$i]}"
		if [[ -n "$common" && "$shown" != "$common" ]]; then
			shown="${shown#$common/}"
		fi
		abs="${paths[$i]/#\~/$HOME}"
		# Hidden columns: <index>\t<jira_key_or_->\t<branch_info>\t<path>\t<abs_path>.
		# fzf shows only column 4 via --with-nth; column 5 (abs path) is the id passed
		# to wt-preview. See AGENTS.md → "Separating Display from ID in fzf Pickers".
		display+=("$i	${jkeys[$i]:--}	${rest[$i]}	$shown	$abs")
	done

	# Preview pane is the shared ~/bin/wt-preview script (rel path, branch,
	# JIRA + OSC 8 link, PR + OSC 8 link, created, updated). Bare names
	# don't resolve in fzf's sh subshell — use the full path.
	selected=$(printf '%s\n' "${display[@]}" | fzf \
		--no-mouse \
		--ansi \
		--height=80% --reverse \
		--delimiter=$'\t' --with-nth=4 \
		--preview='"$HOME/bin/wt-preview" {5}' \
		--preview-window=bottom:40%:wrap \
		--bind='ctrl-p:change-preview-window(bottom:70%:wrap|bottom:40%:wrap|hidden)' \
		--bind='ctrl-g:abort') || return
	[[ -z "$selected" ]] && return

	# Selected format: "<index>\t<key>\t<branch_info>\t<path>\t<abs_path>". Use the index for lookup.
	local idx="${selected%%	*}"
	if [[ "$idx" == <-> ]] && (( idx >= 1 && idx <= ${#paths[@]} )); then
		dir="${paths[$idx]/#\~/$HOME}"
	fi

	[[ -n "$dir" ]] && cd "$dir"
}
alias wts='rlm-wts'

# Run pre-commit on files changed in the current branch since its fork point from the base
# branch (default: main). Usage: rlm-pre-commit-pr [base-branch]    alias: pcpr
rlm-pre-commit-pr() {
      local base="${1:-main}"
      local fork_point
      fork_point=$(git merge-base --fork-point "$base" HEAD 2>/dev/null) \
              || fork_point=$(git merge-base "$base" HEAD) \
              || { echo "pre-commit-pr: cannot find merge base with $base" >&2; return 1; }

      local files
      files=("${(@f)$(git diff --name-only --diff-filter=ACMR "$fork_point"...HEAD)}")
      if [[ -z "${files[1]}" ]]; then
              echo "pre-commit-pr: no changed files vs $base ($fork_point)"
              return 0
      fi

      echo "pre-commit-pr: base=$base fork_point=$fork_point files=${#files}"
      pre-commit run --files "${files[@]}"
}
alias rlm-pcpr='rlm-pre-commit-pr'
alias pre-commit-pr='rlm-pre-commit-pr'
alias pcpr='rlm-pcpr'

# Run lefthook on every tracked + non-ignored file under the current directory,
# recursively, regardless of git stage state. Defaults to the pre-commit hook;
# pass another stage as the first arg, e.g. `rlm-lhdir pre-push`.
# Usage: rlm-lhdir [hook-name]    alias: lhd
rlm-lhdir() {
      local hook="${1:-pre-commit}"
      git ls-files --cached --others --exclude-standard . \
              | lefthook run "$hook" --files-from-stdin
}
alias rlm-lhd='rlm-lhdir'
alias lhdir='rlm-lhdir'
alias lhd='rlm-lhd'

rlm-cd-sub() {
  emulate -L zsh
  set -o pipefail
  for _cmd in fd fzf; do
    if ! command -v "$_cmd" >/dev/null 2>&1; then
      print -u2 -r -- "cd-sub: '$_cmd' not found in PATH"
      return 1
    fi
  done
  local target
  target=$(fd -t d --color=always "$@" \
    | fzf --no-mouse --ansi \
          --prompt="cd> " \
          --height=80% --reverse \
          --preview='eza -l --color=always {} 2>/dev/null || ls -la {}' \
          --preview-window=bottom:40%:wrap \
          --bind='ctrl-p:change-preview-window(bottom:70%:wrap|bottom:40%:wrap|hidden)') || return 130
  [[ -z $target ]] && return 130
  cd -- "$target"
}
alias cd-sub='rlm-cd-sub'
alias cds='rlm-cd-sub'

# pyenv — PYENV_ROOT/bin is on $PATH from .zshenv; this hooks shims into the shell.
export PYENV_ROOT="$HOME/.pyenv"
(( $+commands[pyenv] )) && eval "$(pyenv init -)"

# dbt Fusion extension
alias dbtf="$HOME/.local/bin/dbt"
