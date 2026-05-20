# Changelog

All notable changes to the zsh configuration are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2026-05-20]

### Added

- `rlm-jira-pick` (short alias `jira-pick`): fzf picker over JIRA issues that matter to me. Runs four JQL queries in parallel via `acli` (assigned, reporter-and-not-assigned, watching-and-not-assigned/reporter, project = DATA and not in any of the previous three), deduplicates, and renders each group with its own color label (yellow assigned → green reporter → cyan watching → magenta DATA). Within each group rows are sorted by `updated DESC` straight from JQL. All four queries filter out long-resolved tickets via `(resolved is EMPTY OR resolved >= -60d)` so closed work older than ~2 months drops off the list (configurable by editing the `-60d` constant). Picker also has a `--- REFRESH CACHE (cached … ago) ---` sentinel at the top that nukes only the items cache (history survives), and an MRU history at `~/.cache/jira-pick/history.txt` so recently-picked issues float to the top on the next invocation while keeping their original group color. Implementation notes: fields rendered with `--delimiter=$'\t' --with-nth=2` so the raw key sits in field 3 and the preview command can `acli jira workitem view {3}` directly with no sed/ANSI-strip dance; `--no-sort` is passed so the input order (group → updated) is preserved even when the user types a query that would otherwise reorder matches by fuzzy score (e.g. typing "decommission" was floating two old DATA-only Done tickets above an assigned In-Progress one); `setopt local_options no_monitor no_notify` silences the `[N] PID` / `[N] done` job-control chatter that zsh's job-control prints for the four backgrounded `acli` fetches in an interactive shell. Fullscreen UI: `--height=100%` and preview opens at the tallest setting (`bottom:70%:wrap`), with Ctrl-P cycling 40% → hidden → 70%. Every invocation runs `acli jira auth status` and transparently calls `acli jira auth login --web` if it's not authenticated, so the picker is safe to call out of a long-idle shell. Requires: `acli`, `fzf`, `python3`.

### Changed

- `rlm-jira-pick`: fzf preview pane now prepends two header lines — `Updated:` (issue's `fields.updated`) and `Last comment:` (newest `updated`, falling back to `created`, across `fields.comment.comments[]`; renders `(no comments)` when the list is empty) — to the standard `acli jira workitem view` body. Both timestamps render in Europe/Stockholm local time alongside a humanized "X units ago" delta (s/m/h/d/mo/y). Implementation: extracted the preview into a standalone `bin/jira-preview <KEY>` helper (symlinked into `~/bin/`, same pattern as `bq-preview` / `wt-preview` — needed because fzf preview runs in a plain `sh` subshell that doesn't inherit `$fpath` or autoloaded functions, so the preview command is `"$HOME/bin/jira-preview" "$key"` with the full path per the BigQuery-preview convention in `zsh/CLAUDE.md`). The helper issues two `acli jira workitem view` calls in parallel (one with `--fields key,updated,comment --json` for the header dates, one with no `--fields` for the human body) so preview latency stays close to a single acli round-trip. Time formatting uses Python's `zoneinfo.ZoneInfo("Europe/Stockholm")` for the local-time conversion (zoneinfo is in the stdlib since 3.9, so no extra dep) with a fallback to `dt.astimezone()` if the zoneinfo db isn't available. JIRA timestamps come back as `YYYY-MM-DDTHH:MM:SS.mmm+ZZZZ` and are parsed with `datetime.fromisoformat` (Python 3.11+ handles the colon-less offset; the helper also accepts trailing `Z`). Helpdir entry gains a `PREVIEW PANE` section documenting the new behavior.

- `rlm-bq-archive`: Query C (storage freshness) fixed to return exactly one row for the exact `(project, dataset, table)` that the picker selected. The previous form was `WHERE t.table_name LIKE '%${src_tbl}%'`, which collapsed the project's entire namespace of similarly-named tables into a single result set (for `events` it would pull rows for `events_archive`, `dim_events`, `fct_events_daily`, …) and used `LIMIT 20` to mask the resulting noise. Anchored to `WHERE t.table_schema = '${src_ds}' AND t.table_name = '${src_tbl}'`. Output reformatted from a one-line CSV-style row into a labeled vertical block (`type:`, `created:`, `last_modified:`, `rows:`, `logical_bytes:`) since there is now always exactly one row to render. `rows` and `logical_bytes` are humanized in jq (K/M/B for rows, KiB/MiB/GiB/TiB for bytes) followed by the raw count in parentheses, since 196682505310 doesn't read at a glance. Three columns (`table_catalog`, `table_schema`, `table_name`) dropped from the SELECT — they're already known from the picker selection and the header line already shows `${src_ds}.${src_tbl}`. A "no row in INFORMATION_SCHEMA.TABLES" diagnostic prints when the row count is zero (table may have been deleted between picker and freshness lookup). `last_modified` gracefully falls back to `(no TABLE_STORAGE row — view/external/snapshot)` when the LEFT JOIN against `TABLE_STORAGE` misses (views, external tables, and snapshots are in `TABLES` but not `TABLE_STORAGE`). Single-SELECT shape preserved.

- `rlm-bq-archive`: Query B (data-access audit log) tightened to filter out two classes of false positives. (1) The match anchor moved from a wildcard substring (`LIKE '%${src_tbl}%'`) to an exact path suffix (`LIKE '%/datasets/${src_ds}/tables/${src_tbl}'`). The old form matched any resource whose path contained the table name as a substring — so a target like `pubsub_ingest.events` would also light up every audit row for the `sdp_psa_adjust_events` dataset (dataset name contains "events") and for the `__dbt_tmp` staging tables and the BigQuery anonymous result-cache tables that scheduled queries materialize *inside* that dataset (with mangled names like `z9k8dvf0nuv4_2026-05-20T100000_a5d70fa…_2853a1`). For the `pubsub_ingest.events` test case, the row count dropped from "dominated by hundreds of `sdp_psa_adjust_events` cache-table rows" to "1 row, 4 hits, real user" — i.e. only the actual `pubsub_ingest.events` reads that aren't from the ignored service-account principals. (2) Three defense-in-depth `NOT REGEXP_CONTAINS` predicates drop BigQuery-managed shadow tables that might still share a `tables/<name>` suffix when a user's table name itself collides with the BigQuery temp-table pattern: `/datasets/_<hex>/...` (anonymous query-result cache datasets, 24h TTL), `/tables/anon<hex>` (script/session temp tables), and `__dbt_tmp$` (dbt incremental staging tables). The header line also picks up `${src_ds}.${src_tbl}` (was bare `'${src_tbl}'`) and the `cache/tmp tables filtered` annotation so the user knows what's being excluded. Single-SELECT shape preserved.

- `rlm-bq-archive`: Query A output is now pivoted by day — each day becomes a top-level header (newest first), with distinct queries listed underneath as `  <statement_type> runs=<N> users=<M>\n    <excerpt>`. Reads like a calendar of "what hit this table on day X", which makes spotting cadence shifts (a dbt model that ran daily until last week, an ad-hoc burst yesterday, etc.) trivial. The SQL changed accordingly: it now `GROUP BY day, query_clean` and orders `day DESC, runs DESC, statement_type`, returning one row per (day, distinct query) instead of one row per distinct query with a `by_day ARRAY<STRUCT>` column. The pivot eliminates the JOIN-against-per_day workaround and the two extra CTEs added in the previous step (BigQuery had rejected the correlated-subquery form). jq groups the flat rows back into day-keyed paragraphs with `group_by(.day) | sort_by(.[0].day) | reverse` — SQL ORDER within each group is preserved by the stable group_by. `LIMIT` raised from 50 to 200 since rows now multiply by ~lookback_days per distinct query. The first_run/last_run/by_day columns from the previous output are dropped: with day as the grouping key those fields become redundant.

- `rlm-bq-archive`: Query A now also emits a per-day drilldown for each distinct query, as a second indented line of the form `by-day: 05-14:25 05-15:25 05-16:25 05-17:25 05-18:25 05-19:25 05-20:21` — so the temporal cadence is visible at a glance (steady daily run vs. one-off vs. front-loaded yesterday) without scrolling back through individual job rows. Implementation: the single CTE pipeline grew two more nodes — `per_day(query_clean, day, jobs)` and `by_day(query_clean, ARRAY<STRUCT<day, jobs>>)` — and the final SELECT JOINs `by_day` against the existing `per_query` rollup on `query_clean`. A correlated subquery (`SELECT ARRAY_AGG(STRUCT(day, jobs)) FROM per_day WHERE per_day.query_clean = h.query_clean`) was tried first but BigQuery rejects it with `Correlated subqueries that reference other tables are not supported unless they can be de-correlated, such as by transforming them into an efficient JOIN` — the JOIN is the canonical workaround. Days in the drilldown are emitted as `YYYY-MM-DD` from SQL and trimmed to `MM-DD` in the jq render (year prefix is redundant since lookback defaults to 7 days and `last_run` on the row above already pins it). `first_run` / `last_run` are also trimmed in jq to `YYYY-MM-DD HH:MM` — the seconds + microseconds + `+00` timezone suffix that bq returns from `MIN(creation_time)` / `MAX(creation_time)` are noise at this level. Single-SELECT shape preserved (three CTEs are still one statement).

- `rlm-bq-archive`: Query A is now a single deduped summary instead of a flat per-job listing. It lists *distinct* query bodies (one row per unique query text) with `runs` (total executions), `distinct_users`, `first_run`, `last_run`, `statement_type`, and `query_excerpt` — ordered by `runs DESC, last_run DESC`. The dedup is done by `GROUP BY` on the cleaned body, where "cleaned" means two `REGEXP_REPLACE` passes inside a CTE: (1) strip the per-invocation `"<uuid>" AS sdp_invocation_id` literal that dbt embeds (a 32-char UUID, so each run looks unique to a naive `GROUP BY query`); (2) strip all `/* ... */` comments. A final `\s+ -> ' '` collapse is applied to the displayed excerpt only. For the `events` test case this collapses 175 individual jobs over 7 days to 6 distinct queries (171 dbt CTAS + 7 view rebuilds + 4 ad-hoc SELECTs) — the picker's deletion decision now hinges on "what's actually running" (collapsed by intent) rather than scrolling through 50 row-per-job entries. A per-day×statement_type histogram was considered as a second query but dropped: the `runs` column already carries the count, so the histogram would be strictly redundant. Stays a single SQL statement (a CTE is still one statement, no DECLARE / no script) so the jq array shape from `bq query --format=prettyjson` stays flat.

- `rlm-bq-archive`: Query A now filters `INFORMATION_SCHEMA.JOBS` on `EXISTS (SELECT 1 FROM UNNEST(referenced_tables) AS rt WHERE rt.project_id = '<src_proj>' AND rt.dataset_id = '<src_ds>' AND rt.table_id = '<src_tbl>')` instead of `LOWER(query) LIKE LOWER('%<src_tbl>%')`. `referenced_tables` is populated by BigQuery *after* view / UDF expansion, so the picker now catches jobs that touched the table transitively through a wrapping view — the previous text-grep on the raw SQL body silently missed those. The exact `(project_id, dataset_id, table_id)` match also removes the false-positive class where a same-named table in a different dataset (or the substring appearing in a column name, comment, or function call) would show up. Added a dim secondary header line `(scope: jobs billed to <qp>; set BQ_ARCHIVE_QUERY_PROJECT to inspect a different billing project)` so the user is reminded that `JOBS` is billing-project-scoped — a `prod` table read by a job billed to `dev` or to a personal sandbox stays invisible without re-running the diagnostics against that project (or pointing the env var at it). Single-SELECT shape preserved per the "no DECLARE / no script" jq-shape constraint documented in the previous entry. Query B (data-access audit log) and Query C (storage freshness) are unchanged — B already operates on the resolved `resourceName` from the audit layer, and C is intentionally a metadata lookup that doesn't depend on read traffic.

### Fixed

- `rlm-bq-archive`: the copy step (`bq cp --no-clobber "$src" "$dst"`) was failing with `FATAL Flags parsing error: Unknown command line flag 'no-clobber'. Did you mean: no_clobber ?` for every selected table — the bq CLI uses underscore-separated flag names, not dashes. The error showed up only at the actual copy moment, after the user had already typed `yes` to the archive confirmation, so a full run ended `Summary: 0 copied, 1 failed` with no work done. Fixed by switching all three references (the comment header above the copy loop, the actual `bq cp` invocation, and the human-readable failure message) from `--no-clobber` to `--no_clobber`. Verified against `bq cp --help`: `-n,--[no]no_clobber: Do not overwrite an existing destination table`.

- `rlm-bq-archive`: diagnostics output (Query A "JOBS that reference table", Query B "data-access audit log", Query C "storage freshness") was silently swallowed for every selected table — the user only saw the three `-- Query X --` headers followed by nothing before the "Proceed with archive copy?" prompt. Root cause: `_bq_archive_run_query` was captured via `out=$(... 2>&1)`, so bq's "Waiting on bqjob\_… Current status: RUNNING/DONE" status spinner (written to stderr) got prepended to the JSON in `$out`. The downstream check `[[ $out == "["* ]]` then failed (string starts with `W`, not `[`), and the result-rendering branch was skipped without any diagnostic. Fix: pass `--quiet` to `bq` to suppress the status spinner, drop the `2>&1` redirect so genuine bq errors flow straight to the terminal, and switch the call-site pattern from `out=$(... 2>&1) || { print -u2 ... }` to `out=$(...); if (( $? != 0 )); then …; elif [[ $out == \[* ]]; then <render>; else <dump unexpected output>; fi`. The new `else` branch surfaces malformed output instead of silently swallowing it, so any future regression in `bq query --format=prettyjson`'s output shape is immediately visible. Applied to all three queries.

- `rlm-bq-archive`: follow-up — all three diagnostic queries now actually render their rows instead of failing with `jq: error (at <stdin>:NNN): Cannot index array with string "…"` after the new `rows: 1` header. Root cause: each query started with `DECLARE TABLE_NAME_PATTERN DEFAULT '%${src_tbl}%';` (Query B also `DECLARE IGNORED ARRAY<STRING> …`), which makes the body a BigQuery *script* rather than a single SELECT. `bq query --format=prettyjson` wraps script results in an extra array layer (`[[{row}, ...]]` instead of `[{row}, ...]`), so the row-rendering jq filter `.[] | .field` walked into the inner array as a whole and tried to index it by string field name. `jq 'length'` returned `1` (the outer wrapper's length), masking the shape mismatch as a real one-row result. Fix: drop all four `DECLARE`s and inline the pattern as a SQL string literal (`LIKE LOWER('%${src_tbl}%')` for Query A, `LIKE '%${src_tbl}%'` for B and C) and the ignored-principals array as `NOT IN UNNEST(${ignored_sql_array})` (the array literal was already being built in shell). `src_tbl` comes from a parsed `project:dataset.table` ref so it's a `[A-Za-z0-9_]+` BigQuery identifier — safe to inline without SQL-injection risk. Added a comment on Query A and shorter cross-references on B and C documenting the "keep this a single SELECT" constraint so a future edit doesn't reintroduce a `DECLARE`.

### Added

- `_rlm-bq-cache-key`, `_rlm-bq-cache`, `_rlm-bq-history`, `_rlm-bq-dead-refs-gc`: four new internal helpers that back the unified cache + pooled history shared by all five `rlm-bq-*` / `rlm-sandbox-bq-*` commands. `_rlm-bq-cache-key` returns the md5 of `BQ_SEARCH_PATH + SANDBOX_BQ_PROJECT + SANDBOX_BQ_DATASETS` — same digest as the previous inline formula in `rlm-bq-open` and `rlm-bq-archive` (existing caches stay valid). Pipes `print -l --` directly into `md5` rather than round-tripping through `$(...)` so trailing empty args (unset sandbox vars) still contribute their blank line to the input. `_rlm-bq-cache` owns the two cache files at `~/.cache/bq-open/<md5>.txt` (non-sandbox) and `~/.cache/bq-open/<md5>-sandbox.txt`; subcommands `paths` (emit `key=`, `cache=`, `sandbox=` for `eval`), `refresh [--main-only | --sandbox-only]` (re-fetch via `bq ls` — sandbox fetch is parallel-per-dataset), `read [--main | --sandbox | --both]` (concat selected file(s) to stdout). `_rlm-bq-history` owns the pooled history at `~/.cache/bq-open/history.tsv` (format `<epoch>\t<command>\t<bq_ref>\t<flags>`, newest first, deduped on `bq_ref`, capped at 500 lines); subcommands `append <command> <bq_ref> [<flag> ...]` (flags comma-joined; today `sandbox` and `deleted` are the recognised values) and `read`. On first read/append, opportunistically folds in entries from the two legacy paths (`~/.cache/bq-open/history.txt` with the `[sandbox] ` prefix scheme, and `~/.cache/sandbox-bq-open/history.txt` with bare refs) — legacy files are not deleted, just stop being read. `_rlm-bq-dead-refs-gc` lifts the dead-ref garbage-collect pass (previously inline in `rlm-bq-open:36–59`) into its own helper that all five callers run on entry, not just `rlm-bq-open`; sweeps `dead-refs.txt` entries out of every `<md5>.txt`, every `<md5>-sandbox.txt`, the new `history.tsv` (matching on field 3 = `bq_ref`), and the legacy `history.txt` (with `[sandbox] ` stripped for the match). Uses `$(cat …)` rather than `$(<…)` so `zsh -n` doesn't try to open the file during the parse pass.

- `_rlm-dbt-project-key`, `_rlm-dbt-history`, `_rlm-dbt-nodes-cache`: three new internal helpers that back the unified history + nodes cache shared by all four `rlm-dbt-*` commands (`rlm-dbt-run`, `rlm-dbt-build`, `rlm-dbt-test`, `rlm-dbt-ls`). `_rlm-dbt-project-key` returns md5 of the absolute `dbt_project_root` (falls back to `md5sum | awk '{print $1}'` on Linux when BSD `md5` is absent) — the formula was previously duplicated in `rlm-dbt-ls`. `_rlm-dbt-history` owns a single pooled history file at `~/.cache/rlm-dbt/history.tsv` (format `<epoch>\t<command>\t<project_key>\t<selector>`, newest first, deduped on `(project_key, selector)`, capped at 500 lines); subcommands `append <command> <project_key> <selector>` and `read <project_key>` (the latter emits `<epoch>\t<command>\t<selector>` lines). `_rlm-dbt-nodes-cache` owns a single per-project nodes cache at `~/.cache/rlm-dbt/<project_key>/nodes.json` from one `dbt ls --output json --resource-type model --resource-type seed --resource-type test --resource-type snapshot` call; subcommands `path <project_key>`, `refresh <project_key> <project_root> <dbt_project_root> <profiles_dir> <target> [<profile>]`, and `read <project_key> <jq_filter>` (so each command filters with its own `select(.resource_type == "...") | .name`). On first read/append, `_rlm-dbt-history` opportunistically folds in entries from the four legacy paths (`~/.cache/dbt-{run,build,test}/history_ts.txt` and `~/.cache/dbt-ls/<md5>.history`) under the current project_key — legacy files are not deleted, just stop being read.

- `wt-preview` (`~/bin/wt-preview`): new standalone helper that prints a standardized git-worktree summary for fzf preview panes. Usage: `wt-preview <worktree-absolute-path>`. Emits `Path` (relative to the caller's `$PWD` via `python3 os.path.relpath` with a prefix-trim + `$HOME→~` fallback for the no-python3 case), `Branch`, `JIRA: <KEY>  <Status + summary>` wrapped in an OSC 8 hyperlink to `https://storytel.atlassian.net/browse/<KEY>` (only when the branch contains a `[A-Z][A-Z0-9]+-[0-9]+` key — same regex used by `rlm-wts` / `rlm-jira-open`), `PR: #N  [state]  <title>` wrapped in an OSC 8 hyperlink to the PR's `url` (via `cd "$abs_path" && gh pr list --state all --head <branch> --limit 1 --json number,title,url,state` — `gh` has no `-C` / `--cwd` flag, hence the cd-in-subshell), `Created` (directory birthtime — macOS `stat -f '%B'`, Linux `stat -c '%W'` with `%Z` ctime fallback when birthtime is 0/`-`), `Updated` (most recent file mtime under the worktree excluding `.git/` — `fd --type f --hidden --exclude .git . <path> --exec-batch stat ...` with a `find ... -prune ... | xargs stat` fallback), and `Changed: N file(s) vs origin/<default>` followed by one indented line per changed file in the form `+adds / -dels  <path>` (adds green, dels red, binary files render as `bin / bin`). The numstat output is derived from `git diff --numstat <fork-point>` so it captures both committed and uncommitted changes; fork point chain is `git merge-base --fork-point origin/<default>` with a `git merge-base HEAD origin/<default>` fallback, matching the previous inline logic in `rlm-pr-worktree-rm`. The `+N / -M` column widths are padded across rows for vertical alignment. Note on a subtle zsh trap: the per-row read loop avoids using `$path` (and `$fpath`) as the relative-path variable name, because both are zsh-special lowercase aliases of `$PATH` / `$FPATH` — assigning a string to them silently splits and reprints the array contents into the preview pane. Both timestamps are formatted as `YYYY-MM-DD HH:MM:SS  (<humanized> ago)` where the humanizer picks the largest unit ≥ 1 across seconds/minutes/hours/days/months/years. Both BSD (`date -r`) and GNU (`date -d @…`) variants are probed. The OSC 8 hyperlink label is colored blue (`\e[34m`) inside the anchor text so terminals strip the SGR from the URL and apply it only to the visible label — matches the convention used by `rlm-gar-search` and `dbt-model-preview`. The full byte sequence (`ESC ] 8 ; ; URL ESC \\ TEXT ESC ] 8 ; ; ESC \\`) is built once via `printf` and re-emitted with `print -r --` per the zsh/CLAUDE.md "Emitting Escape Sequences from zsh" guidance, so the `ESC \\` ST terminator survives intact. JIRA summaries are served from the same `~/.cache/wts-jira/<KEY>.summary` cache used by `rlm-wts`, with an opportunistic 3-day-TTL refresh via `acli jira workitem view <KEY> -f summary,status` when `acli` is installed; failures (no `acli`, network, auth) silently omit the title. PR lookup has no cache — every preview hover calls `gh` — but that's fast enough in practice and avoids stale state. Every section is independently best-effort: missing JIRA key, missing PR, missing `gh`/`acli`/`fd` all just omit the corresponding line rather than failing the preview. Hooked into `~/bin` by the existing `ls bin | xargs ... ln -Fvhfs` loop in `create_links_mac.sh` / `create_links_linux.sh` — no manifest edit needed.

### Changed

- `rlm-bq-open`, `rlm-bq-archive`, `rlm-bq-rm-tables`, `rlm-sandbox-bq-open`, `rlm-sandbox-bq-rm`: all five now share **one cache pair** (`~/.cache/bq-open/<md5>.txt` and `<md5>-sandbox.txt`) and **one pooled history file** (`~/.cache/bq-open/history.tsv`) via the four new internal helpers above. The previously separate `~/.cache/sandbox-bq-open/` directory (used by `rlm-sandbox-bq-open` / `rlm-sandbox-bq-rm`) is gone — both now key off the shared md5 (`BQ_SEARCH_PATH + SANDBOX_BQ_PROJECT + SANDBOX_BQ_DATASETS`) and read from `<md5>-sandbox.txt`. *Pooled history* means a pick made by any of the five becomes a first-class suggestion in every other picker, with a flags column distinguishing `sandbox` and `deleted` entries (so the recently-deleted refs don't get picked again unwittingly). `rlm-bq-rm-tables`, which previously always-fresh `bq ls`-ed every dataset on every invocation, now reads from the shared sandbox cache and exposes a `--- REFRESH SANDBOX CACHE ---` sentinel for explicit re-fetch — same UX as the other four. Its picker layout also changed from a 5-column TSV (`TYPE\tPROJ\tDS\tTABLE\tREF` with `--with-nth=1,3,4`) to the canonical 2-column `TAG\tREF` (`--with-nth=1,2 --nth=2`) that `rlm-bq-open` uses; the TYPE column is gone (it's visible in `bq-preview`). Picker history filters by `in_scope` so cross-environment refs (a different `BQ_SEARCH_PATH`) don't bleed in. Each command appends to the pooled history with its own command tag (`bq-open` / `bq-archive` / `bq-rm-tables` / `sandbox-bq-open` / `sandbox-bq-rm`), so the suffix the user sees is e.g. `proj:scratch.foo (last used 1h ago in sandbox-bq-open, sandbox)`. Dead-ref GC (was inline only in `rlm-bq-open`) now runs at the top of every caller via `_rlm-bq-dead-refs-gc`. Legacy state at `~/.cache/bq-open/history.txt` and `~/.cache/sandbox-bq-open/{items,history}.txt` is read once during the migration handled by `_rlm-bq-history` and then ignored; legacy files are not deleted automatically.

- `_rlm-dbt-cmd` (`rlm-dbt-run` / `rlm-dbt-build` / `rlm-dbt-test`) and `rlm-dbt-ls`: now share **one pooled history file** (`~/.cache/rlm-dbt/history.tsv`) and **one per-project nodes cache** (`~/.cache/rlm-dbt/<project_key>/nodes.json`) via the new internal helpers above, replacing four separate `~/.cache/dbt-{run,build,test,ls}/` directories. *Pooled* means every command's picks for the current project show up at the top of every other command's picker — a `dbt-ls` exploration of `tag:finance` immediately becomes a first-class suggestion for the next `dbt-run` / `dbt-build` / `dbt-test`, rendered as `tag:finance (last used 1h ago in dbt-ls)`. Each command filters the shared nodes cache by `resource_type` with `jq` at picker time (`select(.resource_type == "model")` for run/ls, `or .resource_type == "seed"` for build, `"test"` for test), so the four commands now drive a single `dbt ls` call per project refresh instead of four. The in-picker "REFRESH NODES CACHE" sentinel is now project-wide: refreshing from any of the four commands repopulates every command's picker content at once. The `--ansi` flag is added to `_rlm-dbt-cmd`'s picker invocation per the fzf-conventions section of `AGENTS.md` (previously missing). Legacy per-command cache files at `~/.cache/dbt-{run,build,test}/{models,history,history_ts}.txt` and `~/.cache/dbt-ls/<md5>.history` are still read once during the migration handled by `_rlm-dbt-history` and then ignored; they're not deleted automatically.

- `rlm-wts` (inline in `.zshrc`): fzf preview pane switched from the previous inline `cat $HOME/.cache/wts-jira/<KEY>.preview` to the shared `~/bin/wt-preview <abs_path>`, so the preview now also shows the PR (with clickable OSC 8 link), `Created`, `Updated`, and the per-file `+adds / -dels` numstat list vs the fork point — in addition to the JIRA info. The picker's hidden-column layout grew a 5th tab-separated field (`<index>\t<jira_key_or_->\t<branch_info>\t<path>\t<abs_path>`) so the preview can address the absolute path via `{5}` per the `AGENTS.md` "Separating Display from ID in fzf Pickers" pattern (`--with-nth=4` still renders only the relative path). Picker also picks up the standard `--no-mouse --ansi`, `--preview-window=bottom:40%:wrap`, and the `ctrl-p` cycle binding that it was previously missing. The background `_rlm-wts-jira-refresh` pre-warm is retained — it makes the first preview hover snappier even though `wt-preview` itself also refreshes opportunistically.

- `rlm-pr-worktree-rm`: replaced the ~115-line embedded `/tmp/prwtrm-preview.XXXXXX` temp-file preview script with a single-line preview command (`'"$HOME/bin/wt-preview" {5}'`). Eliminates the `mktemp` + `cat > "$preview_file" << 'PREVIEW_EOF'` + `chmod +x` + `rm -f "$preview_file"` dance, and removes the duplicated JIRA cache logic, creation/update timestamp computation, and fork-point + `git diff --name-only` computation — all now centralized in `wt-preview`. Gains OSC 8 hyperlinks for both JIRA and PR, plus the richer per-file `+adds / -dels` numstat output in place of the previous `name-only` list. The `--no-mouse --ansi --preview-window=bottom:40%:wrap` + `ctrl-p` cycle binding are unchanged. PR lookup moves from `gh pr view <number>` (per-row, populated by the upfront `gh pr list` map) to `wt-preview`'s `gh pr list --state all --head <branch>` (per-preview); the upfront `pr_state` map is still used to render the picker rows' `pr-status` column.

- `bq-preview` (`~/bin/bq-preview`): expanded the fzf-preview output. Field order is now `type`, `project_id` (colorized — green for `*-prod`, magenta/purple for `*-dev`, uncolored otherwise; the ANSI is applied outside jq so the JSON pipeline stays clean), `dataset_id`, `table_id`, `updated_at`, `created_at`, `num_rows`, `logical_bytes`, then the existing optional rows (`description`, `partitions`, `partitioning`, `clustering`) in the same place, then `schema_fields` (count), then a new `fields:` block. Timestamps now render as local wall-clock (`YYYY-MM-DD HH:MM:SS <TZ>`) followed by a humanized "(N units ago)" — the offset and TZ label are captured once via `date +%z` / `date +%Z` in the host shell and handed to jq with `--argjson`/`--arg` so all the formatting still happens inside the single jq pass (jq has no native TZ support). The `fields:` block prints one line per column as `- <name> <TYPE> [<MODE>]  — <description>`, omits the mode for `NULLABLE`, omits the em-dash when the description is missing, and recursively indents nested `RECORD`/`REPEATED` children by four spaces per nesting depth via a `walk_fields($indent)` jq function. No existing rows were removed; the changes are pure additions, reorderings, and the new field list. All five call sites (`rlm-bq-open`, `rlm-bq-rm-tables`, `rlm-sandbox-bq-open`, `rlm-sandbox-bq-rm`, `_rlm-dbt-cmd`) continue to invoke `"$HOME/bin/bq-preview" "<ref>"` unchanged.

- `AGENTS.md` (`zsh/`): new top-level section "Separating Display from ID in fzf Pickers" documenting the `--delimiter=$'\t'` + `--with-nth=N` + `{N}`-in-preview pattern for stylable / multi-field picker entries. Mandates this approach whenever a picker line carries ANSI color, hidden sort keys, a display label that differs from the id, or human-only annotations — and explicitly warns off the older inline-ANSI-plus-strip-on-readback workaround. Cross-references the parallel addition to the `create-zsh-function` skill (Step 5).

- `rlm-afw-deploy`: fzf picker over `airflow_manager/dag_folder/*dag.py` is now sorted with files changed on the current branch first (vs the merge-base / fork-point with `origin/HEAD`, computed the same way as `rlm-git-changed` / `rlm-git-diff-base` — try `git merge-base --fork-point origin/<default>`, fall back to plain `git merge-base HEAD origin/<default>`), then by file mtime newest-first. Changed entries are highlighted in green. To avoid an ANSI strip-on-readback, each picker line is built as four tab-separated columns (`<group>\t<-mtime>\t<colored-display>\t<raw-path>`) and fzf is invoked with `--delimiter=$'\t' --with-nth=3 --ansi`, so the green-styled display is what's rendered while the raw, unstyled path is read back from the 4th field (`dag_file=${picker_out##*$'\t'}`). Mtime is collected via macOS `stat -f %m` with a Linux `stat -c %Y` fallback. The git-state derivation is best-effort: when the cwd isn't a git repo, the default branch can't be determined, or no merge-base exists, the picker silently falls back to mtime-only ordering with no green highlighting (rather than aborting). Also moved the picker to the project-standard fzf conventions: `--no-mouse`, `--ansi`, `--height=80%`, `--preview-window=bottom:40%:wrap`, and the `ctrl-p` cycle binding (`bottom:70% → bottom:40% → hidden`).

- `rlm-pr-worktree-rm`: fzf preview pane now shows two extra lines between `Branch` and the changed-files section. `Created:` reports the worktree directory's birthtime (macOS `stat -f '%SB'`, falling back to `stat -c '%w'`/`%y` on Linux) as a best-effort proxy for when the worktree was added. `Updated:` reports the most recent file mtime under the worktree, excluding `.git/`, using `fd` when available (`fd --type f --hidden --exclude .git . <path> --exec stat ...`) and falling back to `find … -prune … | xargs stat`. Both macOS (`stat -f %m`, `date -r`) and Linux (`stat -c %Y`, `date -d @…`) variants are probed.

- `rlm-pr-worktree`: fzf picker preview pane moved from `right:60%:wrap` to the project-standard `bottom:40%:wrap`, with `Ctrl-P` bound to cycle `bottom:70% → bottom:40% → hidden` (matching `rlm-pr-worktree-rm` and the rest of the `rlm-*` pickers per the fzf-conventions section of `CLAUDE.md`). Header text updated to mention the toggle.

- `rlm-pr-worktree`: after picking from the fzf list (and after the optional JIRA suffix prompt), a new `vared` prompt lets the user edit the final worktree directory name. Pre-fills with the proposed default (`<repo>-pr-<N>`, `<repo>-<KEY>`, or `<repo>-<KEY>-<slug>` depending on selection); Enter accepts as-is, edits override only the basename — the parent is always `${repo_root:h}/`. Clearing the input cancels with `pr-worktree: cancelled (empty worktree name)`. Implemented as a new internal helper `_prwt_prompt_dirname`. Wired into all three creation paths: `_prwt_make_pr_worktree`, `_prwt_make_jira_worktree`, and `_prwt_make_suffix_worktree` (the `--suffix` / `-s` direct-arg flow).

- `rlm-pr-worktree`: fixed the new `_prwt_prompt_dirname` and the pre-existing `_prwt_prompt_suffix` to actually present an editable prompt in the fzf flow. `vared` requires an interactive zle session and fails with "device not configured" when called from inside `$(...)` if stdin is a pipe (which it is, downstream of `fzf`); redirecting `</dev/tty` does NOT rescue it — the redirect itself is what fails. Switched both helpers to write their result into a global (`_prwt_dirname_out`, `_prwt_suffix_out`) and to be invoked as plain statements (not via command substitution) from the main shell, after `selection=$(... | fzf ...)` has returned. Five callers updated: `_prwt_make_pr_worktree`, `_prwt_make_jira_worktree`, `_prwt_make_suffix_worktree`, plus the direct-arg JIRA path and the fzf-picker JIRA branch. Symptom before the fix was `pr-worktree: creating worktree at …-<KEY> on new branch <KEY>` appearing immediately after selecting an item, with no prompt ever shown — root cause was the silent `</dev/tty` redirect failure inside the subshell.

- `rlm-pr-worktree`: after picking a JIRA issue from the fzf picker (or passing a JIRA key directly on the command line), a `vared` prompt now lets the user type an optional free-form description. Empty input keeps the legacy layout (worktree `../<repo>-<KEY>`, branch `<KEY>`). A non-empty value like `fix bq cost` is sanitized in two passes — runs of non-alphanumerics collapse to a single separator, the result is lowercased and trimmed — using `-` for the path slug and `_` for the branch slug, so the worktree lands at `../<repo>-<KEY>-fix-bq-cost` on a new branch `<KEY>/feat/fix_bq_cost`. Matches the project-wide `DATA-xxxx/feat/<snake_case>` branch convention documented for `/commit`. New internal helpers: `_prwt_slug` (separator-aware slugger reused for path + branch) and `_prwt_prompt_suffix`. The `--suffix` / `-s` flag is unchanged and remains non-interactive for scripting.

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
- `dbt-model-preview`: `bq_relation` line is now emitted as an OSC 8 hyperlink to the GCP BigQuery console deep-link (URL built via the shared `~/bin/bq-console-url`, wrapped inline with a `_hyperlink` function following the `pubsub-preview` pattern). Falls back to plain text when the relation is unresolved (any `?` component) or when `bq-console-url` is unavailable. Click-through requires a terminal with OSC 8 support; inside tmux also requires `set -ga terminal-features "*:hyperlinks"` (already configured in `.tmux.conf`). The hyperlink display text is colored by GCP project suffix so the environment is identifiable at a glance: `*-prod` → green (`\e[32m`), `*-dev` → magenta (`\e[35m`, matching the sandbox/non-prod color used elsewhere in the repo), other → orange (`\e[38;5;208m`, 8-bit color). The SGR sequences live inside the OSC 8 anchor text so terminals strip them from the URL and apply them only to the visible label.
- `rlm-bq-open`, `rlm-sandbox-bq-open`, private `rlm-dbt-bq-link`: stop inlining the GCP BigQuery console URL template; call `~/bin/bq-console-url` instead. Same emitted URL, single source of truth.
- `rlm-dbt-ls`: phase-1 selector picker now uses the same rich `dbt-model-preview` preview pane as phase 4 (instead of the previous `echo {}` placeholder). The initial `dbt ls` is run with `--output json` to a per-invocation temp file; the picker list shows bare names (extracted with `jq -r .name`), and the fzf preview pane calls `~/bin/dbt-model-preview <json> <project> {} [<prod_manifest>]` so highlighting a model shows `bq_relation` (with the OSC 8 hyperlink + project-suffix color), tags, materialized, file path, etc. — same fields the phase-4 picker shows. Prod-manifest discovery (`_rlm-dbt-state-info`) moved from phase 4 to phase 1 so both pickers share the same fallback path; the temp JSON is cleaned up via `trap … EXIT INT TERM` alongside the phase-3 file. History entries that are not bare model names (e.g. `+model`, `tag:foo`) gracefully degrade to the `(no metadata found in <json>)` message from `dbt-model-preview`. The picker also picks up the standard `--no-mouse --ansi --preview-window=...:wrap` fzf conventions it was previously missing.
- `rlm-dbt-test`: new wrapper for `dbt test`, sibling of `rlm-dbt-run` / `rlm-dbt-build`. Same `-s SELECTOR` / `-n, --list` / `-- EXTRA_ARGS` flag surface, same env-var configuration (`DBT_STATE_DIR`, `DBT_PROJECT_SUBDIR`, `DBT_TARGET`, `DBT_DEV_PROJECT`, `DBT_DATASET_PREFIX`), same `--defer --state` flow, same poetry-venv check and packages-yml auto-deps via the existing shared helpers. The fzf picker shows models (pick a model, `dbt test -s <model>` runs the tests attached to it); recently-selected models appear at the top with "last run X ago" labels in `~/.cache/dbt-test/history_ts.txt`. Cost estimate is driven by `--resource-type test` rather than `model`, since for `dbt test` it's the test queries themselves that scan data (the models can stay read from prod via `--defer`). Registered in `.zshrc` (`autoload -Uz rlm-dbt-test`, `alias dbt-test='rlm-dbt-test'`), with full help at `helpdir/rlm-dbt-test` plus the canonical `helpdir/dbt-test → rlm-dbt-test` symlink.
- `_rlm-dbt-cmd`: parameterized the cost-estimate resource-type list. Now takes three positional args — `<dbt_subcmd>`, `<resource_types>` (picker/list-view types), and a new `<cost_resource_types>` (types included in the bq dry-run cost estimate) — instead of hardcoding `--resource-type model` inside `_dbt_cmd_cost_estimate`. The cost-summary lines and per-item breakdown header are derived from `cost_resource_types` (`Models running locally` for run/build, `Tests running locally` for test, `Models/Seeds` if ever needed). Both existing wrappers updated: `rlm-dbt-run` → `_rlm-dbt-cmd run model model`, `rlm-dbt-build` → `_rlm-dbt-cmd build model,seed model` (same behavior as before — models only for cost), and the new `rlm-dbt-test` passes `_rlm-dbt-cmd test model test`. `AGENTS.md` (the `_rlm-dbt-cmd` internal-helpers entry) updated to document the new positional contract.

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
