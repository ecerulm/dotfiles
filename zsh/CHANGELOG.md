# Changelog

All notable changes to the zsh configuration are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2026-05-20]

### Added

- `_rlm-dbt-ensure-deps`: new internal helper. Given `(project_root, dbt_project_root, label)` it counts list entries in `<dbt_project_root>/packages.yml` vs subdirectories under `<dbt_project_root>/dbt_packages/`; if fewer packages are installed than declared, runs `poetry run dbt deps --project-dir <dbt_project_root>` once. No-op when `packages.yml` is absent or already satisfied.
- `dbt-model-preview` (`~/bin/dbt-model-preview`): standalone dbt model metadata viewer for fzf preview panes. Usage `dbt-model-preview <models_json_file> <dbt_project_root> <model_name>`. Reads a file containing one `dbt ls --output json` line per node, finds the matching `name`, and prints `name`, `unique_id`, `resource_type`, `package`, `materialized`, `bq_relation` (BigQuery `project:dataset.table` derived from `database/schema/alias`), `tags`, `meta` (when non-empty), `description` (truncated to 280 chars), `upstream_count`, `upstream` (first 8 unique parent node names), `file_path` (absolute, resolved against the project root), and `last_modified` (file mtime via macOS or Linux `stat`). Graceful on missing model / missing file / missing `jq`.
- `_rlm-dbt-state-info`: new internal helper. Locates the prod ref-state manifest at `$DBT_STATE_DIR/manifest.json`, optionally enforces a freshness gate (`--max-age-days N`), and emits `state_dir=…`, `manifest=…`, `age_seconds=…`, `age_label=…` lines on stdout for `eval`. With `--require`, missing / unset / stale fails loudly with a stderr diagnostic (`return 1`); without it, the same conditions fail silently (`return 2`, empty stdout) so callers can use the manifest opportunistically. Replaces inline duplication of the env-var name, manifest path, freshness check, and macOS/Linux stat-mtime fallback across `_rlm-dbt-cmd` and the manifest-fallback path in `rlm-dbt-ls`.
- `bq-console-url` (`~/bin/bq-console-url`): new standalone helper. Given `project:dataset.table` (or `project.dataset.table`), prints the GCP Cloud Console BigQuery UI deep-link (`https://console.cloud.google.com/bigquery?project=…&ws=!1m5!1m4!4m3!1s…!2s…!3s…`). Rejects malformed inputs (missing components, fewer than three parts) with a stderr diagnostic. Becomes the single source of truth for the deep-link format that was previously duplicated in `rlm-bq-open`, `rlm-sandbox-bq-open`, and the private `rlm-dbt-bq-link`.

### Changed

- `rlm-dbt-ls`, `_rlm-dbt-cmd` (`rlm-dbt-run` / `rlm-dbt-build`): call the new `_rlm-dbt-ensure-deps` helper right after the venv check so a fresh checkout (or a newly added `packages.yml` entry) auto-runs `dbt deps` instead of surfacing dbt's "N package(s) specified … but only 0 package(s) installed" warning and returning an empty node list.
- `rlm-dbt-ls`: phase-4 multi-select picker now binds `Ctrl-Y` to copy `{+}` (marked items, or the highlighted line if none are marked) to the system clipboard via `pbcopy` / `xclip` / `xsel` without exiting the picker; the header briefly changes to confirm the copy. After confirming with Enter, the final selection is *also* auto-copied to the clipboard (newline-separated, matching stdout) and a `dbt-ls: N model(s) copied to clipboard` line is printed to stderr. The picker also picks up the standard `--no-mouse --ansi --preview-window=...:wrap` fzf conventions it was previously missing.
- `rlm-dbt-ls`: phase-3 now runs `dbt ls --output json` (instead of plain-name output) and caches the result to a per-invocation temp file; the phase-4 fzf preview pane calls `~/bin/dbt-model-preview <json> <project> {}` to render `name`, `unique_id`, `resource_type`, `package`, `materialized`, `bq_relation`, `bq_rel_source`, `tags`, `meta`, `description`, `upstream_count`, `upstream`, `file_path`, and `last_modified` for the highlighted model. The model name list shown in the picker is unchanged (extracted from the JSON with `jq -r .name`). The temp file is removed on function exit via `trap … EXIT INT TERM`. Adds `jq` as a hard dependency.
- `rlm-dbt-ls` + `dbt-model-preview`: prod-manifest fallback for `bq_relation`. When `$DBT_STATE_DIR/manifest.json` exists (same env var consumed by `rlm-dbt-run` / `rlm-dbt-build`), `rlm-dbt-ls` passes its path as a 4th argument to `dbt-model-preview`. The preview script then looks up the model by `unique_id` in the prod manifest and fills in any null `database` / `schema` / `alias` fields from prod, so `bq_relation` resolves to `acme-prod:dataset.table` instead of the previous `?:?.alias` symptom that appeared when the local target left these fields unresolved. A new `bq_rel_source` line in the preview indicates which source supplied the *target-resolved* relation parts: `local target`, `prod manifest`, `mixed`, or `unresolved` (alias is excluded from the attribution since it defaults to the node name even with no target resolution — verified empirically against `storytel-dbt`'s `local_dev` target where database/schema come back null and alias = node name). Note: this is NOT done via `dbt ls --defer --state` — per the dbt docs, defer affects `ref()` resolution at compile/run time only; empirically confirmed by running `poetry run dbt ls --output json --defer [--favor-state] --state $DBT_STATE_DIR -s prep_change_request_service_value_status` against `storytel-dbt`, which still emits `{"database":null,"schema":null,"alias":"prep_change_request_service_value_status"}` for the model in question.
- `_rlm-dbt-cmd` (`rlm-dbt-run` / `rlm-dbt-build`) and `rlm-dbt-ls`: route prod-manifest discovery through the new `_rlm-dbt-state-info` helper. `_rlm-dbt-cmd` keeps its hard-fail-with-"Run: dbt-sync-state"-hint behavior (via `--require --max-age-days 7`); `rlm-dbt-ls` uses the soft path so it still works outside the deferred-state workflow. The duplicated 7-day freshness check, age-label formatting, and macOS/Linux `stat` fallback have been removed from both call sites.
- `dbt-model-preview`: `bq_relation` line is now emitted as an OSC 8 hyperlink to the GCP BigQuery console deep-link (URL built via the shared `~/bin/bq-console-url`, wrapped inline with a `_hyperlink` function following the `pubsub-preview` pattern). Falls back to plain text when the relation is unresolved (any `?` component) or when `bq-console-url` is unavailable. Click-through requires a terminal with OSC 8 support; inside tmux also requires `set -ga terminal-features "*:hyperlinks"` (already configured in `.tmux.conf`).
- `rlm-bq-open`, `rlm-sandbox-bq-open`, private `rlm-dbt-bq-link`: stop inlining the GCP BigQuery console URL template; call `~/bin/bq-console-url` instead. Same emitted URL, single source of truth.

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
