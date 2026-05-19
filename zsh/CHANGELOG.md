# Changelog

All notable changes to the zsh configuration are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2026-05-19]

### Added

- `_rlm-poetry-ensure-venv`: new internal helper. Given `(project_root, expected_bin, label)` it verifies that `poetry run <expected_bin>` resolves to a binary under the project's poetry virtualenv (via `poetry env info --path` + `poetry run which <bin>` + path-prefix check). If not, runs `poetry install` once in `$project_root` and re-checks; on hard failure prints a three-line diagnostic (expected venv, resolved bin, project dir) and returns non-zero. Stronger than a `poetry run <bin> --version` probe, which succeeds for any `<bin>` on `$PATH` and silently shadows the pinned version when `poetry install`/`poetry sync` has not been run.
- `pubsub-preview` (`~/bin/pubsub-preview`): standalone Pub/Sub topic metadata viewer for fzf preview panes. Prints `project_id`, `name`, `topic_schema` (OSC 8 hyperlink to the GCP console schema page, or `NO TOPIC SCHEMA`), and `subscriptions` (each as an OSC 8 hyperlink to its GCP console subscription page).

### Changed

- `rlm-bq-open` / `bq-preview`: garbage-collect stale BigQuery refs. When `bq-preview` hits a "not found" error it appends the ref to `~/.cache/bq-open/dead-refs.txt`; on the next `rlm-bq-open` invocation those refs are removed from the picker cache, sandbox cache, and history file before the picker is shown.
- `_rlm-dbt-cmd` (`rlm-dbt-run` / `rlm-dbt-build`): surface real `dbt ls` failures. Captures stderr to `~/.cache/{dbt-run,dbt-build}/dbt-ls.err`, prints the exit code and the exact command that ran, and points to the log file path instead of silently falling back to an empty node list.
- `_rlm-dbt-cmd` (`rlm-dbt-run` / `rlm-dbt-build`), `rlm-dbt-ls`, `rlm-afw-deploy`: replace per-function venv checks with calls to the new `_rlm-poetry-ensure-venv` helper. `rlm-dbt-ls` upgrades from the weak `poetry run dbt --version` probe to the robust path-prefix check; `rlm-afw-deploy` now auto-runs `poetry install` on failure instead of printing a manual suggestion. Behavior for `rlm-dbt-run` / `rlm-dbt-build` is unchanged (the helper is the exact pattern they already used inline).
- `rlm-pubsub-open`: fzf preview pane now calls `~/bin/pubsub-preview` instead of inlining `gcloud pubsub topics describe`. Added `--ansi` to the fzf invocation so OSC 8 hyperlinks in the preview render as clickable links. Updated helpdir to document the new preview fields and the OSC 8 / fzf / tmux requirements.
- `AGENTS.md` (`zsh/`): new `## Emitting Escape Sequences from zsh: print -r -- (not print --)` section explaining the `print --` backslash-eating gotcha (root cause of OSC 8 hyperlinks rendering as garbled `8;;https://...` text); new `## fzf Conventions (apply to every picker)` section mandating `--no-mouse --ansi --height=80% --reverse --preview-window=bottom:40%:wrap` plus the `ctrl-p` cycle binding, with the tmux `terminal-features "*:hyperlinks"` requirement.
- `.tmux.conf`: add `set -ga terminal-features "*:hyperlinks"` so OSC 8 hyperlinks survive tmux on the way from fzf preview panes to the host terminal.

## [2026-05-18]

### Added

- `rlm-dbt-build` (`dbt-build`): sibling of `rlm-dbt-run` that wraps `dbt build` (models, seeds, tests, snapshots). The fzf picker covers models *and* seeds. Shares deferred-state, history, cost-estimate, and `-n` list-only behaviour with `dbt-run` via the new `_rlm-dbt-cmd` helper.
- `_rlm-dbt-cmd`: shared implementation autoloaded helper backing `rlm-dbt-run` and `rlm-dbt-build`. Takes the dbt subcommand (`run`/`build`) and a comma-separated list of `--resource-type` values, and derives the cache dir / help text / picker labels from the caller's `funcstack` name.
- `rlm-bq-rm-tables` (`bq-rm-tables`): multi-select fzf picker to permanently delete BigQuery tables in sandbox datasets; preview pane shows table metadata via `bq-preview`.
- `bq-preview` (`~/bin/bq-preview`): standalone BigQuery metadata viewer for fzf preview panes; fixes jq `label` keyword conflict and avoids the zsh `\n`-expansion bug.

### Changed

- `rlm-dbt-run`: collapsed to a thin wrapper that calls `_rlm-dbt-cmd run model`; existing behaviour, env vars, cache layout (`~/.cache/dbt-run/{models,history,history_ts}.txt`), and history are preserved.
- `rlm-gh-repo-init`: make `OWNER/REPO` argument optional; when omitted, defaults to `<gh-username>/<current-dir>` (username via `gh api user`) and prompts for confirmation before creating the repo.
- `rlm-bq-open`: switch fzf lines to tab-delimited `COLOUR_OPENER<TAB>BQ_REF` format; `--nth=2` restricts match highlighting to the BQ ref, fixing ANSI colouring reliability.
- `rlm-bq-open`: fetch sandbox datasets in parallel (background subshells) for faster cache population.
- `rlm-bq-open`: sandbox lines now appear after history (before non-sandbox lines) in the picker.
- `rlm-bq-rm-tables`: colorize the `project:dataset.table` parts in the deletion preview (project=cyan, dataset=yellow, table=green).
- `rlm-dbt-run`: drop `--favor-state` from `dbt run`/`ls`/`compile` calls; update help text accordingly.
- All fzf pickers: add `--no-mouse` so the terminal emulator handles mouse events (text selection / copy-paste in the preview pane).
- All fzf pickers with BigQuery preview: use the full path `"$HOME/bin/bq-preview"` so the plain `sh` preview subshell can find it without inheriting zsh `PATH`.
- `AGENTS.md`: document the `bq-preview` convention (full path, `--no-mouse`, tab-delimited ANSI stripping).

### Fixed

- `rlm-bq-open`: strip ANSI escape codes from the awk dedup key so the same table appearing once as a sandbox history entry (with trailing `\033[0m`) and once as a plain entry collapses to a single picker line.
- `rlm-bq-rm-tables`: stop splitting fzf output into individual fields via `$(...)` array expansion; capture as a single string and parse tab-delimited rows with `read` so each selection stays on one line.
- `rlm-dbt-run`: exclude `target/compiled/**/*.yml` and `*.sql` from the find that locates a model's compiled SQL; unit-test fixtures (e.g. `_foo_unit_tests.yml` / `foo.sql`) collided with real models and dry-ran to 0 bytes, silently zeroing the cost estimate.
- `rlm-dbt-run`: send `dbt compile --quiet` stdout to `/dev/null`; `--quiet` only silences logs, not the compiled SQL itself, which previously leaked into the estimate output.
- `rlm-dbt-run`: print per-model size and compiled SQL path in the summary so the user can re-run `bq query --dry_run` manually to verify.

## [2026-05-17]

### Fixed

- `rlm-bq-open`: add `--no-mouse` so terminal can select/copy text from the preview pane
- `rlm-bq-open`: fix duplicate sandbox entries when a table was previously selected (history entry lacked ANSI codes so `awk` dedup didn't recognise it as identical to the ANSI-tagged sandbox line; dedup now strips ANSI before comparing)

### Added

- `rlm-pr-worktree`: add `--suffix SUFFIX` / `-s SUFFIX` flag to create a worktree at `../<repo>-<SUFFIX>` off the default branch without any PR or JIRA lookup
- `rlm-sandbox-bq-open` (`sandbox-bq-open`): fzf picker over BigQuery tables in a sandbox project/datasets (configured via `$SANDBOX_BQ_PROJECT` / `$SANDBOX_BQ_DATASETS`); opens selected table in GCP console, copies URL to clipboard. Shares cache with `rlm-sandbox-bq-rm`.
- `rlm-sandbox-bq-rm` (`sandbox-bq-rm`): multi-select fzf picker to permanently delete BigQuery tables in the sandbox project/datasets; prompts for confirmation before deletion; invalidates the shared cache on success.
- `rlm-dbt-ls` (`dbt-ls`): run `dbt ls` via poetry with an fzf picker; discovers `dbt_project.yml` and profiles dir by walking up from cwd; Phase 1 picker over all models + past selectors, Phase 2 edit selector with `vared`, Phase 3 run `dbt ls -s <selector>`, Phase 4 multi-select results.
- `rlm-dbt-run` (`dbt-run`): moved from private to public; all company-specific paths replaced with env vars (`DBT_STATE_DIR`, `DBT_PROJECT_SUBDIR`, `DBT_TARGET`, `DBT_DEV_PROJECT`, `DBT_DATASET_PREFIX`).

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
