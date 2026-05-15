# Changelog

All notable changes to the zsh configuration are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2026-05-15]

### Changed

- `rlm-pr-worktree-rm`: show worktree paths relative to the git root in both the picker and confirmation prompt; preview pane now shows JIRA ticket (fetched via `acli` with 3-day cache) then PR then branch then changed files; picker shows path only (no branch/status columns).

### Added

- `rlm-gcp-project-open` (`gcp-project-open`): fzf picker over all accessible GCP projects; opens selected project in GCP console, copies URL to clipboard. Caches project list in `~/.cache/gcp-project-open/`.
- `rlm-pubsub-open` (`pubsub-open`): fzf picker over Pub/Sub topics across projects in `$PUBSUB_OPEN_PROJECTS`; opens selected topic in GCP console, copies URL to clipboard. Caches topic list in `~/.cache/pubsub-open/`.

## [2026-05-14]

### Added

- `create-gh-repo` short alias for `rlm-gh-repo-init`.

### Changed

- `rlm-gh-repo-init`: check for an existing remote before complaining about
  the missing `OWNER/REPO` argument, so the user is told the dir is already
  wired up rather than nagged for an argument that would not be used.

## [2026-05-13]

### Added

- `rlm-afw-deploy` (`afw-deploy`): deploy a DAG to the dev Airflow sandbox
  via fzf picker; validates `airflow_manager/`, `pyproject.toml`, and the
  poetry `afw` environment; caches last selection per project root in
  `~/.cache/afw-deploy/`.
- `rlm-gh-permalink` (`gh-permalink`): pick a file from the current git repo
  via fzf and open its immutable GitHub permalink (pinned to HEAD SHA) in the
  browser.

### Changed

- `rlm-pr-worktree-rm`: add fzf preview pane (Ctrl-P to cycle height) showing
  branch name, PR number/URL/state, and files changed vs fork point.
- `helpdir/`: convert short-name files that were byte-identical to their
  `rlm-*` counterparts into symlinks, eliminating duplicate content.
- `AGENTS.md`: document that `helpdir/<name>` must be a symlink to
  `helpdir/rlm-<name>`, not an independent copy.

## [2026-05-12]

### Added

- `rlm-bq-open` (`bq-open`): browse BigQuery tables across GCP projects via
  fzf; table list cached in `~/.cache/bq-open/` keyed by `$BQ_SEARCH_PATH`;
  opens selected table in the GCP console, copies URL to clipboard.
- `rlm-gh-repo-init` (`gh-repo-init`): initialise a private GitHub repo from
  the current directory.

### Changed

- `rlm-bq-open` preview pane surfaces `type`, `kind`, `id`, `description`,
  `numPartitions`, `numRows`, and `numTotalLogicalBytes` at the top; added
  `ctrl-p` binding to resize the preview window.

## [2026-05-11]

### Added

- `rlm-fcmd` preview chain: walks `$HELPDIR` first (builtins, man pages,
  function bodies) before falling back to `type`.
- `helpdir/` directory with plain-text help files for all custom functions and
  aliases, used by `run-help` and the `fcmd` preview pane.
- Private function directories (`my-zsh-functions-private/`,
  `helpdir-private/`) for machine/company-specific code; gitignored.
- `AGENTS.md` / `CLAUDE.md` coding-agent guidance for this directory.

### Changed

- `rlm-fcmd` preview simplified: walks `$HELPDIR` directly, removes
  `autoload +X` intermediate step.
- Function prefix renamed from `rlm_` (underscore) to `rlm-` (hyphen)
  throughout.

## [2026-05-10]

### Added

- `rlm-fcmd` (`fcmd`): fzf picker over all aliases, functions, builtins,
  reserved words, and `$PATH` commands; preview pane shows help text, alias
  expansion, or function body.
- `rlm-urldecode` (`urldecode`): split a URL into components and
  percent-decode its query string, one `key = value` line per param; reads
  `$1` or stdin.
- `rlm-brew-unlock` (`brew-unlock`): remove a stale Homebrew update lock only
  when the locking process is confirmed dead.

## [2026-05-06]

### Added

- `rlm-jira-open` (`jira-open`): open the JIRA ticket inferred from branch
  name, PR title, or commit subjects; `--print` flag outputs URL instead of
  opening browser.

### Changed

- `rlm-pr-worktree` now includes all open PRs in the repo (not just yours) so
  teammates' PRs appear in the picker.

## [2026-05-05]

### Added

- `rlm-pr-for-commit` (`pr-for-commit`): print the GitHub PR URL that
  introduced a given commit into the default branch.
- `rlm-wts` (`wts`): interactive worktree selector with cached JIRA info,
  defined inline in `.zshrc`.

## [2026-04-30]

### Changed

- `rlm-pyactivate` updated to prefer `uv` over `pyenv` when available.

## [2026-04-27]

### Changed

- `rlm-pr-worktree` updated with improved branch and worktree handling.

## [2026-04-21]

### Added

- `wts`: git worktree selector with JIRA ticket info caching in
  `~/.cache/wts-jira/`.

## [2026-03-29]

### Changed

- `psql` added to `$PATH` when the Homebrew `libpq` prefix exists.

## [2026-03-11]

### Changed

- `.zlogin` now runs `fortune` with short messages only.

## [2026-02-18]

### Added

- `sqlfluff_fix` and `sqlfluff_lint` aliases.

## [2026-02-07]

### Changed

- `.zshenv` cleaned up; zsh config files refactored and comments tidied.
- `.zlogin` wired up to run `fortune` on login.
- Pulumi aliases added: `pu` (`pulumi up`), `pus` (`pulumi preview --skip-preview`).

## [2026-01-16]

### Added

- `pulumi` alias.

## [2025-12-02]

### Added

- `direnv` hook wired into zsh.
- `agy` (antigravity) added to `$PATH`.

## [2025-11-21]

### Changed

- `SHARE_HISTORY` enabled so history is shared across all open terminals
  immediately.
