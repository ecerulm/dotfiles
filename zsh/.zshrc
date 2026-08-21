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
autoload -Uz rlm-pr-list
autoload -Uz rlm-pr-worktree
autoload -Uz rlm-pr-worktree-rm
autoload -Uz rlm-pr-worktree-rm-merged-closed
autoload -Uz rlm-gh-browse
autoload -Uz rlm-gh-fork
autoload -Uz rlm-gh-repo-init
autoload -Uz rlm-bq-archive
autoload -Uz rlm-bq-open
autoload -Uz rlm-sandbox-bq-open
autoload -Uz rlm-sandbox-bq-rm
autoload -Uz rlm-bq-rm-tables
autoload -Uz rlm-gcloud-venv
autoload -Uz rlm-gcp-project-open
autoload -Uz rlm-glogin
autoload -Uz rlm-gar-open
autoload -Uz rlm-gar-rm
autoload -Uz rlm-gar-search
autoload -Uz rlm-gar-version-rm
autoload -Uz rlm-pubsub-open
autoload -Uz rlm-jira-open
autoload -Uz rlm-jira-pick
autoload -Uz rlm-brew-unlock
autoload -Uz rlm-fcmd
autoload -Uz rlm-fe
autoload -Uz rlm-urldecode
autoload -Uz rlm-generatectags
autoload -Uz rlm-pr-for-commit
autoload -Uz rlm-afw-deploy
autoload -Uz rlm-gh-permalink
autoload -Uz rlm-git-changed
autoload -Uz rlm-git-diff-base
autoload -Uz rlm-git-find-in-remotes
autoload -Uz rlm-git-status
autoload -Uz rlm-git-update
autoload -Uz rlm-git-squash-branch
autoload -Uz rlm-git-squash-branch-old
autoload -Uz rlm-dbt
autoload -Uz rlm-dbt-build
autoload -Uz rlm-dbt-find-source-code
autoload -Uz rlm-dbt-ls
autoload -Uz rlm-dbt-run
autoload -Uz rlm-dbt-sandbox
autoload -Uz rlm-dbt-test
autoload -Uz rlm-tfapply
autoload -Uz rlm-tfplan
autoload -Uz rlm-tsconv
# run-help: use the real autoloaded version (default is aliased to man)
unalias run-help 2>/dev/null
# Load the stock implementation under a second name so the wrapper below can
# delegate to it. `autoload +X` loads the body now and `functions -c` copies
# it; without the +X the copy would just be an unresolved autoload stub.
#
# Guarded so re-sourcing .zshrc in a live shell is safe: by then `run-help` is
# the WRAPPER below, and copying that over _rlm-run-help-orig would make the
# wrapper's delegation call itself — infinite recursion on any name without a
# helpdir file. Only capture the original when we haven't already.
if (( ! ${+functions[_rlm-run-help-orig]} )); then
	autoload -Uz +X run-help 2>/dev/null && functions -c run-help _rlm-run-help-orig
fi

# $HELPDIR is a colon-separated LIST here (helpdir-private:helpdir), but the
# stock run-help treats it as a single directory — it tests `[[ -d $HELPDIR ]]`
# and reads `$HELPDIR/$1` verbatim. With a colon in the value neither ever
# matches, so every helpdir/ file was silently invisible to run-help and every
# lookup fell through to `man`, which then reports "No manual entry".
#
# This wrapper walks the list the way rlm-fcmd already does, and delegates to
# the stock function (with HELPDIR unset, so it uses its own compiled-in
# default for zsh builtins like `setopt`) when nothing matches.
run-help() {
	emulate -L zsh
	local name=$1 d target
	# Resolve one level of aliasing so `run-help pr-checkout` finds the help
	# for the alias name itself, then for what it expands to (rlm-pr-checkout).
	local -a candidates=("$name")
	local expanded=${aliases[$name]:-}
	[[ -n $expanded ]] && candidates+=("${expanded%% *}")
	for target in "${candidates[@]}"; do
		for d in ${(s.:.)HELPDIR}; do
			if [[ -r $d/$target ]]; then
				${=PAGER:-more} "$d/$target"
				return 0
			fi
		done
	done
	HELPDIR='' _rlm-run-help-orig "$@"
}
# short aliases for autoloaded functions
alias pyactivate='rlm-pyactivate'
alias hello='rlm-hello'
alias testterminal='rlm-testterminal'
alias dnsflush='rlm-dnsflush'
alias openports='rlm-openports'
alias pyclean='rlm-pyclean'
alias mkpw='rlm-mkpw'
alias pr-list='rlm-pr-list'
alias pr-worktree='rlm-pr-worktree'
alias pr-worktree-rm='rlm-pr-worktree-rm'
alias pr-worktree-rm-merged-closed='rlm-pr-worktree-rm-merged-closed'
alias gh-browse='rlm-gh-browse'
alias gh-fork='rlm-gh-fork'
alias gh-repo-init='rlm-gh-repo-init'
alias create-gh-repo='rlm-gh-repo-init'
alias gh-permalink='rlm-gh-permalink'
alias git-changed='rlm-git-changed'
alias git-diff-base='rlm-git-diff-base'
alias git-find-in-remotes='rlm-git-find-in-remotes'
# rlm-git-repos was merged into rlm-git-status; both names kept as aliases.
alias rlm-git-repos='rlm-git-status'
alias git-repos='rlm-git-status'
alias git-status='rlm-git-status'
alias git-update='rlm-git-update'
alias git-squash-branch='rlm-git-squash-branch'
alias git-squash-branch-old='rlm-git-squash-branch-old'
alias bq-archive='rlm-bq-archive'
alias bq-open='rlm-bq-open'
alias sandbox-bq-open='rlm-sandbox-bq-open'
alias sandbox-bq-rm='rlm-sandbox-bq-rm'
alias bq-rm-tables='rlm-bq-rm-tables'
alias gcloud-venv='rlm-gcloud-venv'
alias gcp-project-open='rlm-gcp-project-open'
alias glogin='rlm-glogin'
alias gar-open='rlm-gar-open'
alias gar-rm='rlm-gar-rm'
alias gar-search='rlm-gar-search'
alias gar-version-rm='rlm-gar-version-rm'
alias pubsub-open='rlm-pubsub-open'
alias jira-open='rlm-jira-open'
alias jira-pick='rlm-jira-pick'
alias brew-unlock='rlm-brew-unlock'
alias fcmd='rlm-fcmd'
alias fe='rlm-fe'
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
alias tfapply='rlm-tfapply'
alias tfplan='rlm-tfplan'
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

  export _ZO_FZF_OPTS="--no-sort --keep-right --cycle --exit-0
  --height=45% --layout=reverse --info=inline --tabstop=1 --border=sharp
  --no-mouse --ansi
  --bind=ctrl-z:ignore,btab:up,tab:down --bind=ctrl-g:abort
  --preview='command -p ls -Cp {2..}' --preview-window=down,30%,sharp"
  eval "$(zoxide init zsh)"
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

zstyle ':vcs_info:git*' formats " %F{blue}%b%f %u%c %a "
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

# pr-checkout: pick one of the current repo's OPEN pull requests via fzf and
# switch to its branch in place.
#
# Complements the two neighbours that do almost-but-not-this:
#   switchbranch  local branches only, no PR context at all.
#   pr-worktree   picks a PR but creates a NEW worktree for it.
#
# Only open PRs are listed (merged/closed are noise for "go work on this").
# Rows you authored are green, matching pr-worktree's picker convention.
#
# WORKTREES. A branch can only be checked out in one worktree at a time, so
# `git switch` to a branch another worktree holds fails hard (exit 128,
# "already used by worktree at ..."). Those PRs are still listed — annotated
# `(wt: <dirname>)` — and selecting one cds you into that worktree instead of
# failing. Either way you end up looking at the branch.
#
# That cd is why this lives inline in .zshrc rather than my-zsh-functions/:
# an autoloaded function runs in the calling shell too, but the repo
# convention (AGENTS.md → Naming & Definition) is that anything which must
# modify the caller's cwd is defined inline.
#
# Branch resolution: most open PRs have no local branch yet, so this defers
# to `gh pr checkout`, which creates the branch, sets upstream, and handles
# PRs from forks. When a local branch already exists it is a plain switch.
#
# Usage: pr-checkout [PR-NUMBER]     (number skips the picker)
function rlm-pr-checkout {
	# Job-control chatter suppression + EXTENDED_GLOB for the trailing-space
	# trim below. local_options scopes both to this function. See AGENTS.md.
	setopt local_options no_notify no_monitor extended_glob

	local repo_root
	repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
		print -u2 "pr-checkout: not inside a git repository"
		return 1
	}

	local c
	for c in gh git jq fzf; do
		command -v "$c" >/dev/null 2>&1 || {
			print -u2 "pr-checkout: '$c' not found in PATH"
			return 1
		}
	done

	# branch -> worktree path, for every worktree of this repo except the one
	# we are standing in (switching to our own current branch is a no-op, not
	# a conflict, so it must not be annotated).
	local here
	here=$(git rev-parse --show-toplevel 2>/dev/null)
	local -A wt_of
	local wl_path='' wl_line=''
	while IFS= read -r wl_line; do
		case $wl_line in
			worktree\ *) wl_path=${wl_line#worktree } ;;
			branch\ *)
				[[ -n $wl_path && ${wl_path:A} != "${here:A}" ]] \
					&& wt_of[${wl_line#branch refs/heads/}]=$wl_path
				;;
			'') wl_path='' ;;
		esac
	done < <(git worktree list --porcelain)

	local pr_number=${1:-}

	if [[ -z $pr_number ]]; then
		local me
		me=$(gh api user --jq .login 2>/dev/null)

		# One call for everything the rows need. --limit 200 is well past any
		# realistic open-PR count; state defaults to open.
		local pr_json
		pr_json=$(gh pr list --limit 200 \
			--json number,title,author,isDraft,headRefName,statusCheckRollup,reviewDecision 2>/dev/null) \
			|| pr_json=''
		if [[ -z $pr_json || $pr_json == '[]' ]]; then
			print -u2 "pr-checkout: no open PRs in this repo"
			return 1
		fi

		# Rows: <num>\t<draft>\t<checks>\t<review>\t<author>\t<branch>\t<title>
		# Same rollup summary as rlm-pr-list; see the note there on `(.[0] // {})`
		# — here we map over the whole array so no such binding is involved.
		local -a raw
		raw=("${(@f)$(print -r -- "$pr_json" | jq -r '
			.[]
			| (.statusCheckRollup // []) as $ctx
			| [ $ctx[] | (.conclusion // .state // "") | ascii_upcase ] as $st
			| ($st | map(select(. == "SUCCESS")) | length) as $ok
			| ($st | map(select(. == "FAILURE" or . == "TIMED_OUT" or . == "CANCELLED" or . == "ERROR" or . == "ACTION_REQUIRED" or . == "STARTUP_FAILURE")) | length) as $bad
			| ($st | map(select(. == "PENDING" or . == "QUEUED" or . == "IN_PROGRESS" or . == "WAITING" or . == "REQUESTED" or . == "EXPECTED")) | length) as $wip
			| ($ok + $bad + $wip) as $tot
			| (if $tot == 0 then "-"
			   elif $bad > 0 then "fail \($bad)/\($tot)"
			   elif $wip > 0 then "pend \($wip)/\($tot)"
			   else "ok \($ok)" end) as $checks
			| (.reviewDecision // "") as $rd
			| (if $rd == "APPROVED" then "approved"
			   elif $rd == "CHANGES_REQUESTED" then "changes-req"
			   elif $rd == "REVIEW_REQUIRED" then "review-req"
			   else "-" end) as $review
			| [ (.number|tostring), (if .isDraft then "draft" else "open" end),
			    $checks, $review, (.author.login // "?"), .headRefName, .title ]
			| @tsv' 2>/dev/null)}")
		(( ${#raw} == 0 )) && {
			print -u2 "pr-checkout: failed to parse PR list"
			return 1
		}

		# Column widths so the display field lines up.
		local -i w_num=2 w_state=5 w_checks=6 w_review=6 w_auth=6
		local r
		local -a rr
		for r in "${raw[@]}"; do
			rr=("${(@s:	:)r}")
			(( ${#rr[1]} + 1 > w_num ))  && w_num=$(( ${#rr[1]} + 1 ))
			(( ${#rr[2]} > w_state ))    && w_state=${#rr[2]}
			(( ${#rr[3]} > w_checks ))   && w_checks=${#rr[3]}
			(( ${#rr[4]} > w_review ))   && w_review=${#rr[4]}
			(( ${#rr[5]} > w_auth ))     && w_auth=${#rr[5]}
		done

		local green=$'\e[32m' grey=$'\e[90m' reset=$'\e[0m'
		local -a lines
		for r in "${raw[@]}"; do
			rr=("${(@s:	:)r}")
			local num=${rr[1]} state=${rr[2]} checks=${rr[3]} review=${rr[4]}
			local author=${rr[5]} branch=${rr[6]} title=${rr[7]}

			# Worktree annotation. Only the basename — the full path is long and
			# the picker line is already wide; the preview pane shows the rest.
			local wt=${wt_of[$branch]:-} note=''
			[[ -n $wt ]] && note="  ${grey}(wt: ${wt:t})${reset}"

			local disp=''
			disp=$(printf '%-*s  %-*s  %-*s  %-*s  %-*s  %s' \
				$w_num "#$num" $w_state "$state" $w_checks "$checks" \
				$w_review "$review" $w_auth "$author" "$title")
			disp=${disp%% ##}
			[[ -n $me && $author == "$me" ]] && disp="${green}${disp}${reset}"

			# display \t number \t branch \t worktree ; fzf renders field 1 only.
			lines+=("$(printf '%s%s\t%s\t%s\t%s' "$disp" "$note" "$num" "$branch" "$wt")")
		done

		local sel
		sel=$(print -rl -- "${lines[@]}" | fzf \
			--no-mouse --ansi --height=80% --reverse \
			--delimiter=$'\t' --with-nth=1 \
			--header='ENTER switches to the PR branch ((wt:…) = cd to that worktree). Ctrl-P: preview. Ctrl-G: abort' \
			--preview='gh pr view {2}' \
			--preview-window=bottom:40%:wrap \
			--bind='ctrl-p:change-preview-window(bottom:70%:wrap|bottom:40%:wrap|hidden)' \
			--bind='ctrl-g:abort') || return 130
		[[ -z $sel ]] && return 130

		local -a sf=("${(@s:	:)sel}")
		pr_number=${sf[2]}
	fi

	# Resolve the head branch. When the picker ran we already know it, but an
	# explicit PR number argument skips all of the above.
	#
	# Initializers are mandatory, not style: `wt` is already declared inside
	# the picker block above, and a bare re-`local` of a declared name is
	# typeset REPORTING mode — it prints "wt=''" to stdout. See AGENTS.md →
	# "Bare `local x` inside a loop PRINTS x=<value>".
	local branch='' wt=''
	branch=$(gh pr view "$pr_number" --json headRefName --jq .headRefName 2>/dev/null) || branch=''
	if [[ -z $branch ]]; then
		print -u2 "pr-checkout: could not resolve a branch for PR #$pr_number"
		return 1
	fi
	wt=${wt_of[$branch]:-}

	# Already checked out elsewhere -> go there rather than failing.
	if [[ -n $wt ]]; then
		print -r -- "pr-checkout: #$pr_number ($branch) is checked out in another worktree"
		print -r -- "pr-checkout: cd $wt"
		cd -- "$wt"
		return $?
	fi

	if [[ $branch == "$(git branch --show-current 2>/dev/null)" ]]; then
		print -r -- "pr-checkout: already on $branch"
		return 0
	fi

	# Existing local branch -> plain switch. Otherwise let `gh pr checkout`
	# create it (handles fork PRs and sets up tracking).
	if git show-ref --verify --quiet "refs/heads/$branch"; then
		git switch "$branch"
	else
		git -C "$repo_root" fetch --quiet origin 2>/dev/null
		gh pr checkout "$pr_number"
	fi
}
alias pr-checkout='rlm-pr-checkout'

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

# Collection-directory mode for rlm-wts (see below). Called only when
# `git worktree list` produced nothing, i.e. the cwd is not inside a repo.
#
# `rlm-pr-worktree`'s multi-repo mode turns a plain directory holding several
# repos (a "base" dir, e.g. ~/git/work/StorytelDataPlatform) into sibling
# "collection" dirs <basename>_<YYYYMMDD>_<tail>, each holding one worktree of
# every repo on a shared branch. Those sets were unreachable from wts: the base
# dir is not a repo, so the picker came up empty and the function returned
# silently. Here we list the sibling collections instead and cd into the pick.
#
# Returns non-zero when the cwd is not a collection base dir, so the caller
# falls back to its previous silent no-op.
#
# NB: inline in .zshrc (not autoloaded) because it cd's the calling shell.
_rlm-wts-collections() {
	# Job-control chatter from the Jira fan-out below; see rlm-wts.
	setopt local_options no_notify no_monitor
	local base="${PWD:A}"

	# Qualify the cwd as a base dir: it must itself contain at least one git
	# repo. rlm-pr-worktree has a richer _prwt_discover_repos, but that is
	# defined inline in its own file (there is no _prwt_* autoload file), so it
	# cannot be autoloaded from here; we only need the boolean anyway.
	local sub found_repo=0
	for sub in "$base"/*(N/); do
		if git -C "$sub" rev-parse --git-dir >/dev/null 2>&1; then
			found_repo=1
			break
		fi
	done
	(( found_repo )) || return 1

	# Family stem: the dirname up to the first "_". rlm-pr-worktree names
	# collections "<stem>_<YYYYMMDD>_<tail>", so the cwd is either the base dir
	# itself (stem == dirname) or one of its collections — from either we want
	# to list the whole family. Truncating at the first "_" is what makes the
	# collection case work: globbing "<full dirname>_*" from inside a collection
	# matches nothing, since collections have no children of their own.
	local stem="${base:t}"
	stem="${stem%%_*}"

	# Family = the base dir plus its "<stem>_*" siblings. Collection dirs use
	# "_" separators while single-repo sibling worktrees use "-", so this glob
	# excludes those. (N/) = nullglob + directories only.
	local -a colls
	colls=( ${base:h}/${stem}(N/) ${base:h}/${stem}_*(N/) )
	if (( ${#colls} == 0 )); then
		print -u2 "wts: no collection directories matching ${stem}_* in ${base:h}"
		return 1
	fi

	# Warm the Jira cache for keys embedded in the collection dirnames, in
	# parallel, exactly as the worktree path below does. Dirname only: reading a
	# member branch would cost a git call per collection, and the preview script
	# already does that fallback where it is paying for git anyway.
	local c ckey
	local -a cpids
	for c in "${colls[@]}"; do
		if [[ ${c:t} =~ ([A-Z][A-Z0-9]+-[0-9]+) ]]; then
			ckey="${match[1]}"
			_rlm-wts-jira-refresh "$ckey" &
			cpids+=($!)
		fi
	done
	if (( ${#cpids[@]} > 0 )); then
		( sleep 3; for pid in "${cpids[@]}"; do kill "$pid" 2>/dev/null; done ) &
		local cguard=$!
		wait "${cpids[@]}" 2>/dev/null
		kill "$cguard" 2>/dev/null
	fi

	# Rows are stat-only: a `git diff` sweep over every member of every
	# collection takes ~1.7s each (~15s for the 9 collections here), which would
	# be paid before the picker even appears. All git work lives in the preview,
	# which fzf runs lazily for the highlighted row only.
	#
	# Columns: <sortkey>\t<display>\t<abs>. Only column 2 is shown; column 3 is
	# the id handed to the preview and to cd. See AGENTS.md -> fzf Conventions.
	local -a rows
	local mtime nrepos disp here
	for c in "${colls[@]}"; do
		mtime=$(stat -f %m "$c" 2>/dev/null || stat -c %Y "$c" 2>/dev/null || echo 0)
		nrepos=$(print -rl -- "$c"/*(N/) | grep -c . 2>/dev/null) || nrepos=0
		# The family now includes the cwd itself; flag it so the picker shows
		# where you are rather than offering an unmarked no-op row. Passed as an
		# argument, never folded into the format string — a dirname (or this
		# marker) containing '%' would otherwise be read as a format specifier.
		here=''
		[[ "$c" == "$base" ]] && here=$'  \033[36m<- here\033[0m'
		# Zero-pad so a plain lexical sort orders by time; negate for newest-first.
		disp=$(printf '%s/ \033[2m(%s repos)\033[0m%s' "${c:t}" "$nrepos" "$here")
		rows+=("$(printf '%012d\t%s\t%s' $(( 99999999999 - mtime )) "$disp" "$c")")
	done

	local selected
	selected=$(print -rl -- "${rows[@]}" | sort | fzf \
		--no-mouse \
		--ansi \
		--height=80% --reverse \
		--delimiter=$'\t' --with-nth=2 \
		--prompt='collection> ' \
		--header="${stem} collections — Enter: cd | Ctrl-P: toggle preview" \
		--preview='"$HOME/bin/wt-collection-preview" {3}' \
		--preview-window=bottom:40%:wrap \
		--bind='ctrl-p:change-preview-window(bottom:70%:wrap|bottom:40%:wrap|hidden)' \
		--bind='ctrl-g:abort') || return 0
	[[ -z "$selected" ]] && return 0

	# Split on tabs positionally: `IFS=$'\t' read` collapses runs of the
	# delimiter and would shift fields left. See AGENTS.md.
	local -a f
	f=("${(@s:	:)selected}")
	[[ -n "${f[3]}" && -d "${f[3]}" ]] && cd -- "${f[3]}"
	return 0
}

# git worktree switch / cd into a worktree, presents a fuzzy finder with all the worktree in the current repo.
# Display rules: $HOME -> ~, strip the longest common ancestor across all worktree paths.
# When a worktree's branch contains a Jira key (e.g. DATA-1234, DATA-2538-foo, feature/DATA-9), the line is
# annotated with "(Status) Summary" from Jira and a fuller preview pane is shown via fzf --preview.
#
# Outside a git repo, falls back to collection mode (_rlm-wts-collections above):
# in a multi-repo base dir it lists the sibling <basename>_* collection dirs.
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
	# 2>/dev/null: outside a repo this prints "fatal: not a git repository",
	# which is not an error here — it is the signal to try collection mode.
	done < <(git worktree list 2>/dev/null)

	# No worktrees: either not a git repo at all, or a repo that reported none.
	# Try collection mode (it cd's on success); otherwise keep the old silent
	# no-op rather than erroring.
	if (( ${#paths[@]} == 0 )); then
		_rlm-wts-collections && return 0
		return 0
	fi

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

# Recursively find every git checkout under a directory (default: the cwd),
# look up the PR for each one's CURRENT branch, and cd to the one you pick.
#
# Unlike rlm-pr-list — which covers a single repo or one collection dir and
# prints a table — this scans a whole TREE. From ~/git/work that is ~100
# checkouts (repo roots and linked worktrees alike), of which ~26 have a PR.
#
# Defined INLINE rather than in my-zsh-functions/ because it must cd the
# CALLING shell; an autoloaded function runs in the caller's shell too, but
# the repo convention is to keep cd-ing functions inline next to rlm-wts.
# The scan/cache work lives in _rlm-pr-find-cache.
#
# The scan costs ~7s, so results are cached per scan-root and the picker
# opens instantly on later runs; a "--- REFRESH SCAN ---" row at the top
# rescans on demand. Rows are ordered most-recently-picked first, then by
# newest PR update.
#
# Usage: rlm-pr-find [dir] [-r|--refresh] [-d|--depth N]    alias: pr-find
rlm-pr-find() {
	emulate -L zsh
	setopt local_options no_monitor no_notify

	local root='' depth=4 force_refresh=0
	while (( $# )); do
		case $1 in
			-r | --refresh) force_refresh=1; shift ;;
			-d | --depth)
				[[ -z $2 ]] && { print -u2 "pr-find: --depth needs a value"; return 1 }
				depth=$2; shift 2
				;;
			-h | --help)
				print -r -- "usage: pr-find [dir] [-r|--refresh] [-d|--depth N]"
				return 0
				;;
			-*) print -u2 "pr-find: unknown flag: $1"; return 1 ;;
			*)
				[[ -n $root ]] && { print -u2 "pr-find: too many arguments"; return 1 }
				root=$1; shift
				;;
		esac
	done
	[[ -z $root ]] && root=$PWD
	if [[ ! -d $root ]]; then
		print -u2 "pr-find: not a directory: $root"
		return 1
	fi
	root=${root:A}

	local cmd
	for cmd in gh git jq fd fzf; do
		if ! command -v "$cmd" >/dev/null 2>&1; then
			print -u2 "pr-find: '$cmd' not found in PATH"
			return 1
		fi
	done

	autoload -Uz _rlm-pr-find-cache
	local cache_file='' history_file=''
	eval "$(_rlm-pr-find-cache paths "$root")" || return 1

	if (( force_refresh )) || [[ ! -f $cache_file ]]; then
		_rlm-pr-find-cache refresh "$root" "$depth" || return 1
	fi

	# The picker is re-entered after a refresh, so it loops rather than
	# recursing — recursion would nest a second fzf inside the first.
	local -a rows
	local selection sel_rel sel_abs
	while :; do
		rows=(${(f)"$(_rlm-pr-find-cache read "$root")"})
		if (( ${#rows} == 0 )); then
			print -u2 "pr-find: no checkout under ${root/#$HOME/~} has a PR for its current branch"
			return 1
		fi

		local -A state_color=(
			open   $'\e[32m'
			draft  $'\e[90m'
			merged $'\e[35m'
			closed $'\e[31m'
		)
		local reset=$'\e[0m'

		# Width the label and PR columns to the data so the titles line up.
		local -i w_label=4 w_num=3
		local row=''
		local -a rf=()
		for row in "${rows[@]}"; do
			rf=("${(@s:	:)row}")
			(( ${#rf[2]} > w_label )) && w_label=${#rf[2]}
			(( ${#rf[4]} + 1 > w_num )) && w_num=$(( ${#rf[4]} + 1 ))
		done
		(( w_label > 52 )) && w_label=52

		local age=''
		age=$(_rlm-pr-find-cache age "$root")
		local refresh_row="--- REFRESH SCAN${age:+ (scanned $age)} ---"

		# Line: <display>\t<rel_path>\t<abs_path>. fzf renders field 1 only;
		# field 3 feeds the preview, field 2 is the MRU key. Do NOT add --nth
		# alongside --with-nth — fzf applies --nth to the post---with-nth text,
		# so the query would match a field that no longer exists and every
		# search would return 0 rows.
		local -a lines=("$(printf '%s\t\t' "$refresh_row")")
		for row in "${rows[@]}"; do
			rf=("${(@s:	:)row}")
			local rel=${rf[1]} label=${rf[2]} branch=${rf[3]}
			local num=${rf[4]} state=${rf[5]} title=${rf[7]:-}
			local disp=''
			disp=$(printf '%-*s  %-*s  %-6s  %s' \
				$w_label "$label" $w_num "#$num" "$state" "$title")
			local c=${state_color[$state]:-}
			[[ -n $c ]] && disp="${c}${disp}${reset}"
			lines+=("$(printf '%s\t%s\t%s' "$disp" "$rel" "$root/$rel")")
		done

		selection=$(print -rl -- "${lines[@]}" | fzf \
			--no-mouse \
			--ansi \
			--delimiter=$'\t' --with-nth=1 \
			--prompt="pr> " \
			--height=80% --reverse \
			--header='TAB multi • Enter cd • Shift/Alt-↑↓ scroll • Ctrl-P size • Ctrl-G abort' \
			--preview='[ -n "{3}" ] && cd "{3}" 2>/dev/null && gh pr view 2>&1 || echo "select a repo"' \
			--preview-window=bottom:40%:wrap \
			--bind='ctrl-p:change-preview-window(bottom:70%:wrap|bottom:40%:wrap|hidden)' \
			--bind='shift-up:preview-up' --bind='shift-down:preview-down' \
			--bind='alt-up:preview-half-page-up' --bind='alt-down:preview-half-page-down' \
			--bind='ctrl-g:abort') || return 130
		[[ -z $selection ]] && return 130

		if [[ $selection == '--- REFRESH SCAN'* ]]; then
			_rlm-pr-find-cache refresh "$root" "$depth" || return 1
			continue
		fi

		local -a sf=("${(@s:	:)selection}")
		sel_rel=${sf[2]:-}
		sel_abs=${sf[3]:-}
		break
	done

	if [[ -z $sel_abs || ! -d $sel_abs ]]; then
		print -u2 "pr-find: selected checkout no longer exists: ${sel_abs:-?}"
		return 1
	fi

	_rlm-pr-find-cache append "$root" "$sel_rel"
	cd -- "$sel_abs"
}
alias pr-find='rlm-pr-find'

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


if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi
