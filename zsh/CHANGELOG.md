# Changelog

All notable changes to the zsh configuration are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `rlm-afw-deploy` (`afw-deploy`): deploy a DAG to the dev Airflow sandbox
  via fzf picker; validates `airflow_manager/`, `pyproject.toml`, and the
  poetry `afw` environment; caches last selection per project root in
  `~/.cache/afw-deploy/`. (2026-05-13)
- `rlm-gh-permalink` (`gh-permalink`): pick a file from the current git repo
  via fzf and open its immutable GitHub permalink (pinned to HEAD SHA) in the
  browser. (2026-05-13)
- `rlm-bq-open` (`bq-open`): browse BigQuery tables across GCP projects via
  fzf; table list cached in `~/.cache/bq-open/` keyed by `$BQ_SEARCH_PATH`;
  opens selected table in the GCP console, copies URL to clipboard. (2026-05-12)
- `rlm-gh-repo-init` (`gh-repo-init`): initialise a private GitHub repo from
  the current directory. (2026-05-12)
- `rlm-fcmd` (`fcmd`): fzf picker over all aliases, functions, builtins,
  reserved words, and `$PATH` commands; preview pane shows help text, alias
  expansion, or function body. (2026-05-10)
- `rlm-urldecode` (`urldecode`): split a URL into components and
  percent-decode its query string, one `key = value` line per param; reads
  `$1` or stdin. (2026-05-10)
- `rlm-brew-unlock` (`brew-unlock`): remove a stale Homebrew update lock only
  when the locking process is confirmed dead. (2026-05-10)
- `rlm-jira-open` (`jira-open`): open the JIRA ticket inferred from branch
  name, PR title, or commit subjects; `--print` flag outputs URL instead of
  opening browser. (2026-05-06)
- `rlm-pr-for-commit` (`pr-for-commit`): print the GitHub PR URL that
  introduced a given commit. (2026-05-05)
- `rlm-wts` (`wts`): interactive worktree selector with cached JIRA info.
  (2026-05-05)
- `helpdir/` directory with plain-text help files for all custom functions and
  aliases, used by `run-help` and the `fcmd` preview pane. (2026-05-11)
- Private function directories (`my-zsh-functions-private/`,
  `helpdir-private/`) for machine/company-specific code; gitignored.
  (2026-05-11)
- `sqlfluff_fix` and `sqlfluff_lint` aliases. (2026-02-18)
- `psql` added to `$PATH` when the Homebrew `libpq` prefix exists. (2026-03-29)
- `direnv` hook wired into zsh; `agy` (antigravity) added to `$PATH`.
  (2025-12-02)
- Pulumi aliases: `pu` (up), `pus` (preview --skip-preview). (2026-01-16 –
  2026-02-07)
- `SHARE_HISTORY` enabled for shared history across terminals. (2025-11-21)
- `AGENTS.md` / `CLAUDE.md` coding-agent guidance added to the zsh directory.
  (2026-05-11)

### Changed

- `rlm-fcmd` preview chain simplified: walks `$HELPDIR` directly, removes
  `autoload +X` intermediate step. (2026-05-11)
- `rlm-bq-open` preview pane now surfaces `type`, `kind`, `id`, `description`,
  `numPartitions`, `numRows`, and `numTotalLogicalBytes` at the top; added
  `ctrl-p` binding to resize the preview window. (2026-05-12)
- `rlm-pr-worktree` now includes all open PRs in the repo (not just yours) so
  teammates' PRs appear in the picker. (2026-05-06)
- `rlm-pr-worktree` updated with improved branch handling. (2026-04-27)
- `rlm-pyactivate` updated to prefer `uv` over `pyenv` when available.
  (2026-04-30)
- `wts` (`rlm-wts`) worktree selector added as an inline `.zshrc` function
  with JIRA info caching. (2026-04-21)
- Function prefix renamed from `rlm_` (underscore) to `rlm-` (hyphen)
  throughout. (2026-05-11)
- `.zshenv` cleaned up; zsh config files refactored for clarity. (2026-02-07)
- `.zlogin` now runs `fortune` with short messages only. (2026-03-11)
