# AGENTS.md

Guidance for coding agents working in `zsh/`. `CLAUDE.md`/`GEMINI.md` symlink to `AGENTS.md` — edit `AGENTS.md` only.

## Structure

- `.zshenv` — env vars, `$fpath`, `$HELPDIR` (all shells); `.zshrc` — aliases, options, plugins, prompt (interactive only)
- `my-zsh-functions/` — autoloaded function files, one per file, `rlm-<name>`
- `helpdir/` — plain-text help files (one per command), used by `run-help` + `fcmd` preview
- `my-zsh-functions-private/`, `helpdir-private/` — **gitignored**, machine/company-specific (the latter searched before `helpdir/`)

## Naming & Definition

Two-name pattern: canonical `rlm-<name>` (autoloaded file or inline in `.zshrc`) + short alias `<name>` in `.zshrc`. Short aliases must expand to the real value directly (`alias gc="git commit -v"`), never chain through another alias (`alias gc='rlm-gc'` fails in zsh for hyphenated names).

- **Autoloaded** (`my-zsh-functions/`, `autoload -Uz` in `.zshrc`): non-trivial functions, lazy-loaded.
- **Inline** (`.zshrc`): short one-liners, or functions that must modify the calling shell (`cd`, `export`).

Every function file starts with `emulate -L zsh`. Validate syntax with `zsh -n <file>` (these files are not `.sh`, so the parent repo's shfmt/shellcheck hooks skip them).

## Adding a New Function

1. `my-zsh-functions/rlm-<name>` (start with `emulate -L zsh`)
2. `autoload -Uz rlm-<name>` in `.zshrc`
3. `alias <name>='rlm-<name>'` in `.zshrc`
4. `helpdir/rlm-<name>` (help content), then `ln -s rlm-<name> helpdir/<name>`
5. Update `README.md` function table

**Private** variant (company/machine-specific — internal hostnames, service/cluster names, secrets, machine paths, proprietary workflows): put the function in `my-zsh-functions-private/`, help in `helpdir-private/`, and the `autoload`/`alias` lines in `~/.zshrc.thismachine` (gitignored, sourced at end of `.zshrc`). One-liner private aliases can just live in `~/.zshrc.thismachine`. Do **not** add private functions to `README.md`.

## helpdir Files

`helpdir/rlm-<name>` is the real file; `helpdir/<name>` must be a **symlink** to it (`ln -s rlm-<name> helpdir/<name>`). Format: line 1 synopsis, blank line, description wrapped ~72 chars, no ANSI, no trailing blank lines.

`rlm-fcmd` preview priority: `$HELPDIR/<name>` → system zsh helpdir → def cache (alias/function body) → `man <name> | col -bx` → `type <name>`.

**run-help**: `.zshrc` does `unalias run-help`, captures the stock implementation as `_rlm-run-help-orig` (via `autoload -Uz +X` + `functions -c`, guarded so re-sourcing `.zshrc` doesn't make the wrapper recurse into itself), then defines a `run-help` **wrapper**.

The wrapper exists because `$HELPDIR` here is a colon-separated *list* (`helpdir-private:helpdir`) while stock run-help treats it as a single directory — it tests `[[ -d $HELPDIR ]]` and reads `$HELPDIR/$1` verbatim, so a colon made every `helpdir/` file invisible and every lookup fell through to `man` ("No manual entry for rlm-foo"). The wrapper walks the list the way `rlm-fcmd` does, resolving the alias name first and then what it expands to (so both `run-help pr-list` and `run-help rlm-pr-list` work), and delegates to `_rlm-run-help-orig` with `HELPDIR=''` when nothing matches — the empty value makes the stock function fall back to its own compiled-in helpdir, keeping builtins like `setopt` working.

This also sidesteps the older problem the `helpdir/` files were meant to work around: uncalled autoloaded functions report as `"foo is an autoload shell function"`, and the word `an` breaks run-help's matcher.

## Internal Helpers (`_rlm-<name>`)

Underscore-prefixed = implementation detail called only by other `rlm-*` functions. Conventions: file in `my-zsh-functions/`; **no** `autoload`/alias in `.zshrc` (callers autoload locally), **no** `helpdir/` file, **no** `README.md` entry. Document them in the source-file header comment (purpose, signature, return-code contract) and in `CHANGELOG.md`. Read the source for full detail — below is just the index.

dbt:

- `_rlm-dbt-cmd` — shared impl for `rlm-dbt-{run,build,test}`. Args: `<subcmd> <resource_types> <cost_resource_types>`.
- `_rlm-dbt-bin` — emit dbt command-prefix tokens (one/line): `dbtf` resolved path when `DBT_USE_FUSION=1`; `uv`/`run`/`dbt` when `DBT_USE_UV=1` or `uv.lock` found in `project_root`; else `poetry`/`run`/`dbt`. Validates+caches the Fusion path. Optional `project_root` arg enables uv auto-detection.
- `_rlm-dbt-ensure-venv` — dispatcher: calls `_rlm-uv-ensure-venv` when `DBT_USE_UV=1` or `uv.lock` present, else `_rlm-poetry-ensure-venv`. `(project_root, expected_bin, label)`.
- `_rlm-poetry-ensure-venv` — verify `poetry run <bin>` resolves inside the project venv (not a `$PATH` shadow); `poetry install` once on failure. `(project_root, expected_bin, label)`.
- `_rlm-uv-ensure-venv` — verify `uv run <bin>` resolves inside `.venv/` (not a `$PATH` shadow); `uv sync` once on failure. `(project_root, expected_bin, label)`.
- `_rlm-python-ensure-version` — verify pyenv's `python` shim resolves from a given cwd via `python -EsSc ...`. `(cwd, label)`. Run *before* `_rlm-poetry-ensure-venv`. Gated off when `DBT_USE_FUSION=1` or project is uv-managed. cwd must be the dir holding `.python-version`.
- `_rlm-dbt-ensure-deps` — `dbt deps` once if `packages.yml` declares more than `dbt_packages/` holds. `(project_root, dbt_project_root, label)`.
- `_rlm-dbt-state-info` — locate `$DBT_STATE_DIR/manifest.json`, optional freshness gate, emit `key=value` lines for `eval`. Flags `--require`, `--max-age-days N`, `--label`.
- `_rlm-dbt-project-key` — worktree-stable project cache key: `md5("<remote_url>:<rel_subdir>")`. Falls back to `md5(abs_path)` when no git remote exists. All worktrees of the same repo share one history + nodes cache.
- `_rlm-dbt-history` — pooled history TSV `~/.cache/rlm-dbt/history.tsv` (`epoch\tcommand\tproject_key\tselector`, deduped, cap 500). `append`/`read`. Folds in legacy paths once.
- `_rlm-dbt-nodes-cache` — per-project nodes cache `~/.cache/rlm-dbt/<key>/nodes.json` (one JSON/line, all resource types). `path`/`refresh`/`read <jq_filter>`. `refresh` validates first line is JSON before overwriting (dbt errors to stdout would otherwise poison the cache).
- `_rlm-dbt-refresh-sentinel` — shared `--- REFRESH NODES CACHE (cached <age>) ---` sentinel for the rlm-dbt-\* pickers (`rlm-dbt-ls` + `_rlm-dbt-cmd`). `emit <cache_file>` (age suffix omitted when the file is absent), `is <line>` (prefix-match detection), `age-label <cache_file>` (bare mtime→"4m ago" string). Selecting the sentinel row rebuilds the nodes cache and reopens the picker.

bq (`rlm-bq-*` / `rlm-sandbox-bq-*`):

- `_rlm-bq-cache-key` — md5 of `BQ_SEARCH_PATH + SANDBOX_BQ_PROJECT + SANDBOX_BQ_DATASETS`. Pipe `print -l` directly into `md5` (don't round-trip through `$(...)`).
- `_rlm-bq-cache` — cache pair `~/.cache/bq-open/<md5>{,-sandbox}.txt`. `paths`/`refresh [--main-only|--sandbox-only] [--projects p1:p2:…] [--datasets d1:d2:…]`/`read [--main|--sandbox|--both]`. `--projects` (subset of `BQ_SEARCH_PATH`) / `--datasets` (subset of `SANDBOX_BQ_DATASETS`) do a **partial-refresh merge** — only listed projects/datasets are re-fetched, the rest are preserved from the existing cache file; unknown values are dropped with a warning.
- `_rlm-bq-history` — pooled history `~/.cache/bq-open/history.tsv` (`epoch\tcommand\tbq_ref\tflags`, deduped on ref, cap 500). `append`/`read`.
- `_rlm-bq-dead-refs-gc` — sweep refs `bq-preview` marked dead (`dead-refs.txt`) from all caches + history. Idempotent; call unconditionally at caller top.
- `_rlm-bq-refresh-sentinels` — shared `--- REFRESH CACHE ---` sentinel logic for the bq pickers. `emit-main`/`emit-sandbox`/`is-main`/`is-sandbox`/`apply-main`/`apply-sandbox`; includes the cache-age formatter. `apply-main`/`apply-sandbox` open a multi-select fzf picker (projects from `BQ_SEARCH_PATH` / datasets from `SANDBOX_BQ_DATASETS`, plus an ALL sentinel) and pass the chosen subset to `_rlm-bq-cache refresh --projects`/`--datasets`; ≤1 configured item skips the picker and refreshes the lot; picker-abort returns 130.

gar (`rlm-gar-*`):

All three user-facing commands (`rlm-gar-open`, `rlm-gar-rm`, `rlm-gar-version-rm`) are thin: preflight → pick → act. Everything shared lives in the helpers below, so a change to the cache, the picker chrome, or the command rendering lands in all of them at once.

- `_rlm-gar-preflight` — validate `GAR_SEARCH_PROJECTS` + required commands (`gcloud fzf jq curl python3`, plus any extra passed as args), emit the parsed project list one per line. `(label, extra_cmd…)`.
- **Locations**: repositories are listed **per location** — the API has no all-locations query (`locations/-` → `INVALID_ARGUMENT`), and `gcloud artifacts repositories list` without `--location` silently returns only its default location's repos. `$GAR_SEARCH_LOCATIONS` (colon-separated, default `europe:europe-west1:us`) is the scan list; a location missing from it is invisible to every gar-\* picker. Do not "fix" this by enumerating all ~46 GCP locations — that is 46 round-trips per project to find the 2-3 that hold anything.
- `_rlm-gar-cache` — shared package-list cache, `~/.cache/gar-open/<md5>.txt` (one `LOCATION-docker.pkg.dev/PROJECT/REPO/PACKAGE` per line) plus a shared `history.txt` MRU. Key is md5 of the sorted+deduped project list, matching the key `rlm-gar-open` computed inline before the extraction — the existing cache is reused, not forked. Actions: `paths <projects…>` (emit `cache_file=`/`history_file=` for `eval`), `refresh <label> <all_projects_csv> <projects…>` (re-fetch via the `packages.list` REST endpoint, **merging** — entries for un-refreshed projects are preserved), `read <projects…>` (MRU-sorted), `age <projects…>` (humanized mtime, empty when no cache), `remove <projects_csv> <image…>` (drop deleted packages). Filters GCR `<image>/cache` layer-cache pseudo-packages.
- `_rlm-gar-pick-package` — the whole cache-backed package picker: initial fetch, cache-age label, `--- REFRESH CACHE ---` sentinel with the project sub-picker, MRU-sorted rows, standard fzf chrome. `(label, prompt, preview_script, multi, projects…)`; emits selected image path(s). Handles the refresh sentinel internally and reopens, so callers never see it and don't re-enter themselves. Deliberately does **not** record MRU — only the caller knows whether the selection was acted on (a delete the user then declines shouldn't reorder the picker).
- `_rlm-gar-pick-projects` — secondary fzf picker behind the refresh sentinel; multi-select projects to re-fetch, with an `*** ALL PROJECTS ***` sentinel. ≤1 configured project skips the picker. Returns 1 on abort/empty.
- `_rlm-gar-history` — shared MRU `~/.cache/gar-open/history.txt` (one image per line, cap 1000). `append`/`remove`/`path`. Shared across all gar-\* pickers so ordering learned in one carries into the others.
- `_rlm-gar-parse-image` — split `LOCATION-docker.pkg.dev/PROJECT/REPO/PACKAGE[/sub/path]` into `loc_host`/`proj`/`repo`/`pkg_path`/`location_slug`/`pkg_encoded`/`console_url` as `key=value` lines for `eval`. Splits positionally so nested package subpaths (`app-engine-tmp/app/dbt-docs/ttl-18h`) stay intact; returns 2 on a path with fewer than 4 components.
- `_rlm-gar-show-cmd` — render the exact gcloud command before a destructive action, one argument per line. `raw <label> <arg…>`, `versions-delete <n> <pkg> <loc> <repo> <proj>`, `package-delete <pkg> <loc> <repo> <proj>`. Digest lists are always summarized as `<N version digest(s)>`: expanding 1000 sha256 digests pushes the `--project`/`--repository` flags off screen, which defeats the point of showing the command.

airflow:

- `_rlm-afw-wait-parsed` — block until Composer has re-parsed deployed DAG files, so `rlm-afw-deploy` returns when the code is live rather than when the upload finished. Modes: `snapshot` (emit `<relative_fileloc>\t<last_parsed_time>` for a pre-deploy baseline), `generation` (emit the DAG zip's current GCS generation), and the default poll. Polls Airflow's `/api/v2/dags` (Airflow 3 — `/api/v1` is removed; auth is a plain `gcloud auth print-access-token`, an *identity* token gets a 401 from the Composer proxy). Returns 0 parsed / 2 timeout / 3 parsed-but-import-errors / 4 zip generation unchanged / 130 interrupt. **Why three conditions and not a timestamp:** Composer re-parses the bundle on a timer (~40-80s), so `last_parsed_time > upload_time` alone passes as soon as the scheduler re-parses the *old* code — observed reporting success in ~14s with nothing deployed. A pass therefore requires the zip's GCS generation to have changed **and** the parse to be at/after the new zip's `updated` **and** to differ from the baseline. Matches on `relative_fileloc` (`<sandbox>_dags.zip/<file>.py`), never `dag_id` — the id carries an in-file version suffix (`dbt_all_in_one_dag.py` → `ecerulm_dbt_all_in_one_v1.3`) that isn't derivable from the filename.

jira / git:

- `_rlm-jira-cache` — issue cache `~/.cache/rlm-jira/items.tsv` (7-field rows: `group\tKEY\tstatus\tsummary\tassignee\tupdated_epoch\tlast_commented_epoch`). `path` (keys `cache_path`/`history_path` — *not* `history`, which is read-only in zsh), `refresh` (parallel `acli` bulk search + per-issue view), `read`, `age`.
- `_rlm-jira-history` — MRU `~/.cache/rlm-jira/history.txt` (`epoch\tKEY`, cap 1000). `path`/`append`/`read`/`migrate-legacy`; auto-upgrades legacy single-column format.
- `_rlm-jira-sorted-rows` — emit cache rows in composite-key DESC: `max(picked_at, updated_epoch, last_commented_epoch)`; 4-group priority is only a tiebreaker.
- `_rlm-git-changed-history` — per-repo MRU `~/.cache/rlm-git-changed/history.tsv` (`epoch\tcommand\trepo_key\tpath`, `repo_key` = md5 of git_root, deduped on `(repo_key,path)`, cap 500). `append`/`read`.

## zsh Gotchas

### `print -r --`, not `print --`

Always emit strings with `print -r -- "$value"` (or `printf '%s\n'`). Without `-r`, `print` interprets backslashes (`\e`→ESC, `\\`→`\`, lone `\` dropped), which corrupts captured OSC 8 hyperlinks — the ST terminator `ESC \` loses its `\`, the terminal eats the next byte, and the link renders broken (`prodtorytel` instead of `prod storytel`). Only use bare `print --` when you deliberately want backslash interpretation.

### awk on macOS is BWK, not gawk

Three patterns silently fail (exit 0, no error):

1. **`-` for stdin alongside a real file** (`awk '...' fileA -`) breaks when `fileA` is empty (0 bytes); BWK skips the `-`. Fix: write both inputs to real `mktemp` files, or gate the awk pass on `[[ -s $file ]]` and use a shell-only path otherwise. `/dev/stdin` is not a fix.
2. **`awk -v var=value` with embedded newlines** → `awk: newline in string`. Pass multi-line data via a real file, never `-v`.
3. **`RS='\0'` for NUL-separated input** (`git … -z`, `find -print0`) is **not supported**. BWK does not error — it reads the *entire stream as one record*, so a loop that should emit N paths emits 1. Fix: `| tr '\0' '\n' |` before awk. Caught in `rlm-fe`'s `_fe_dirty_files`, where 8 dirty files produced 1 path and the other 7 were silently mis-sorted as clean — the tell is output that is non-empty but suspiciously short, which is easier to miss than an empty pipeline.

Symptom card: an awk pipeline producing zero output despite healthy upstream → suspect (1) a `-` after a possibly-empty mktemp file, or (2) `-v var=$(cmd_emitting_newlines)`. Producing exactly **one** record from many → suspect (3).

### direnv chatter from `$(cd … && cmd)` subshells

`$(cd "$dir" && cmd)` leaks `direnv: loading/unloading` when `$dir` is outside the current direnv scope (the chpwd hook fires in the subshell). Fix: scope the redirect to `cd` only — `$(cd "$dir" 2>/dev/null && cmd)`. Do **not** redirect the whole subshell (`$(…) 2>/dev/null`) — that also swallows the inner command's diagnostics. No env-var override exists (`DIRENV_LOG_FORMAT` is not a thing; only `direnv.toml`'s `log_format = "-"` globally, or the per-call redirect). Already applied in the shared dbt helpers.

### `IFS=$'\t' read` collapses empty fields — use `"${(@s:<tab>:)line}"`

`read` treats a *run* of IFS delimiters as one separator, so any row with an
empty field silently shifts every later field left:

```zsh
line=$(printf 'a\tb\t\td\te')          # col3 empty
IFS=$'\t' read -r c1 c2 c3 c4 c5 <<< "$line"
# c3=d  c4=e  c5=''   -- NOT c3='' c4=d c5=e
```

This bites hard on tab-separated picker rows where some row types legitimately
have blank columns (an aggregate/sentinel row with no path, no id, no repo).
The failure is downstream and confusing: a later field's value — often a
human-readable display string — ends up where a path was expected, and you get
`git -C '[7 wt: …]': No such file or directory` rather than a parse error.

Split with the zsh parameter flag instead, which is positional and keeps empty
fields:

```zsh
local -a f
f=("${(@s:	:)line}")                  # a literal TAB between the colons
local id=${f[4]} repo=${f[6]}
```

Note the separator must be an actual tab character in the source, not `\t`.
Use one parsing style per file — mixing `read` and `(@s)` over the same row
format is how this bug got in.

Symptom card: a field holds the value of a *later* column, only for the row
type that has a blank cell.

### Bare `local x` inside a loop PRINTS `x=<value>` to stdout

`local` is `typeset`, and `typeset name` with no `=` is *reporting* mode: if
the name is already declared it prints `name=<current value>` to **stdout**.
`local` scopes to the whole function, not to the enclosing loop, so a bare
declaration in a loop body re-declares an already-declared name on every
iteration after the first:

```zsh
f() {
  for i in 1 2 3; do
    local st            # iterations 2,3 print "st=b"
    for st in a b; do :; done
  done
}
# stdout: st=b
#         st=b
```

This is silent sabotage when the function's stdout is data — the stray
`name=value` lines land in the picker's input, the cache file, or the
`$(...)` a caller is parsing.

Always give loop-body locals an explicit initializer — `local st=''`,
`local -a parts=()`, `local -A counts=()`, `local n=0`. This also resets
them, which a bare re-declaration does **not** do: an accumulating
`state_count[$k]=$(( ... + 1 ))` will otherwise carry the previous
iteration's tallies forward.

Loop *variables* (`local mrow` immediately before `for mrow in …`) are fine
— that declaration runs once, outside the body.

Symptom card: unexplained `somevar=somevalue` lines in a function's output,
or per-group counters that grow monotonically across groups.

### jq: `as` binds looser than `//`

Not zsh, but it bites these functions whenever `gh --json` output is
summarized. `as` binds **looser** than the alternative operator `//`, so

```jq
.[0] // {} as $pr | ($pr.number|tostring)
```

parses as `.[0] // ({} as $pr | rest)`: when `.[0]` is truthy jq
short-circuits and emits the **raw input**, never running the pipeline.
Exit code 0, no error — you get pretty-printed JSON where a scalar was
expected. Parenthesize: `(.[0] // {}) as $pr | …`.

Symptom card: a jq filter that looks ignored, but only when the data is
non-empty (the empty case works, since `//` then falls through). Bit
`rlm-pr-list`'s check-rollup summarizer.

### `emulate -L zsh` turns EXTENDED_GLOB **off**

Every function here starts with `emulate -L zsh`, which disables
EXTENDED_GLOB. Any pattern using the closure operators `#` / `##` then
silently never matches — no error, the substitution returns the string
unchanged:

```zsh
f() {
  emulate -L zsh
  local s="abc   "
  print -r -- "[${s%%[[:space:]]##}]"   # [abc   ]  <- strip did nothing
}
```

Fix: `setopt extended_glob` right after `emulate -L zsh` (`-L` scopes it to
the function). Do **not** substitute `%%[[:space:]]*` — `%%` is greedy from
the left, so it strips from the *first* space and eats most of the string.

Symptom card: a `${var%%…#}` / `${var##…#}` trim that is a visible no-op.

### Backgrounded jobs print job-control noise in interactive shells

A parallel fan-out (`cmd &` … `wait`) prints a start line and a done line
per job when the shell is interactive:

```
[4] 23959
[4]  + done       { local -i n=$idx ; … }
```

`emulate -L zsh` does **not** suppress these — MONITOR and NOTIFY are
interactive-shell state, not emulation options. Add `unsetopt monitor notify` after `emulate -L zsh` (both: MONITOR off kills the job lines,
NOTIFY off stops async completion reports).

Testing trap: this never reproduces under `zsh -c` / `zsh -n`, where
MONITOR is already off — so the function tests clean and still spews for
the user. Reproduce with `script -q /dev/null zsh -ic '…'` and assert
`grep -c '^\[[0-9]'` is 0. Applied in `rlm-pr-list`.

### `${var:+--flag "$var"}` passes ONE argument, not two

zsh does not word-split unquoted parameter expansions the way bash does, so
the common bash idiom for an optional flag-with-value collapses into a single
argv entry:

```zsh
f=/tmp/x
show ${f:+--baseline "$f"}     # argv[1] = '--baseline /tmp/x'   <- one word
```

The callee's arg parser then sees `--baseline /tmp/x` as one unrecognized
flag and dies with `unknown flag: --baseline /tmp/x` — the value visibly
glued to the flag in the error message is the tell.

Build optional args as array elements instead, which also keeps the empty
case clean (an empty array expands to nothing under `"${arr[@]}"`):

```zsh
local -a opt_args=()
[[ -n $baseline_file ]] && opt_args+=(--baseline "$baseline_file")
[[ -n $prev_gen ]] && opt_args+=(--prev-generation "$prev_gen")
cmd --project "$p" "${opt_args[@]}" --timeout 300
```

`${f:+--baseline} ${f:+"$f"}` also works but is easy to mis-edit into the
broken form. Bit `rlm-afw-deploy`'s call into `_rlm-afw-wait-parsed`.

Symptom card: `unknown flag: --something /some/value` — flag and value in a
single error token.

### Never use `path` as a local variable name

`path` is a zsh tied array — the lowercase synonym for `$PATH`. Under
`emulate -L zsh`, `local path=$1` fails silently with "inconsistent type
for assignment": the assignment is dropped and `$path` remains the PATH
array. All subsequent uses see PATH entries instead of the intended value,
with no error message.

Use a descriptive name instead: `wt_abs`, `abs_path`, `dir_path`, etc.
The same applies to other zsh tied scalars/arrays: `cdpath`, `fpath`,
`manpath`, `mailpath`.

### `git log` over a partial clone hangs — set `GIT_NO_LAZY_FETCH=1`

Some checkouts here are partial clones (`git config remote.origin.partialclonefilter` → `blob:none`; `storytelhomepage` is
one). Any history walk that needs tree/blob data — `git log --name-only`,
`--stat`, `-p`, `--follow` — makes git **lazily fetch the missing objects
over the network, one round-trip at a time**. There is no error and no
progress output; the command just sits there.

The cost is per missing object, not per commit, so the usual "cap it with
`-n`" reflex misleads you into thinking it scales:

| repo | walk |
|---|---|
| dotfiles (2k commits) | 0.13 s |
| infra-gcp (16k commits) | 0.19 s |
| storytelhomepage `-n 300` | 0.06 s |
| storytelhomepage `-n 1500` | **45 s** |
| storytelhomepage (full) | **>3 min** |

Prefix any history walk in an interactive path with `GIT_NO_LAZY_FETCH=1`:

```zsh
GIT_NO_LAZY_FETCH=1 git -C "$repo_root" log --format='C%ct' --name-only --no-merges
```

git then refuses to hit the network and stops at the first missing object
— 1.16s instead of minutes, still resolving ~78% of tracked files. Treat
partial results as expected and fall back per-file (`rlm-fe` falls back to
filesystem mtime). This matters most in fzf previews, which re-run on
every keystroke.

Symptom card: a `git log` variant that is instant in one repo and appears
to hang forever in another, with no error and no output.

### Always use OSC 8 hyperlinks for URLs — never print a bare URL

Bare URLs in fzf preview panes (and in terminal output generally) wrap at
the terminal width. A click on a wrapped line navigates to a truncated URL,
silently opening the wrong page with no error. Use OSC 8 hyperlinks instead:
the visible label is short and never wraps, while the full URL is carried
invisibly in the escape sequence.

```sh
# In a preview command (sh subshell — use printf, not print):
printf '\e]8;;%s\e\\Open in GCP console\e]8;;\e\\' "$url"; printf '\n'

# In zsh function body (capture then re-emit with print -r --):
link=$(printf '\e]8;;%s\e\\Open in GCP console\e]8;;\e\\' "$url")
print -r -- "$link"
```

Rules:

- **Always** use OSC 8 for any URL that will appear in a preview pane or
  terminal output, no matter how short it looks — URLs grow over time
  (query params, long project IDs) and wrapping breaks them silently.
- Keep the visible label short and human-readable (`Open in GCP console`,
  `Artifact Registry`, `BigQuery table`, etc.).
- When a line pairs a short identifier with long prose (`#13106` +
  a PR title, a ticket key + its summary), **link only the identifier**
  and print the prose as plain text beside it. The click target then
  cannot wrap, it is visually obvious, and the prose is free to be any
  length — plain-text wrapping is harmless. Linking the whole string
  forces you to truncate it to protect the link. Applied in
  `bin/fe-preview`'s PR line.
- In preview commands (plain `sh` subshell): use `printf` directly —
  `print` is not available and `echo` interprets escapes inconsistently.
- In zsh function bodies: capture with `$(printf …)` and re-emit with
  `print -r --` to preserve the `ESC \` ST terminator bytes (see the
  `print -r --` gotcha above).
- `--ansi` on the `fzf` call is required for OSC 8 pass-through (already
  mandatory for all pickers — see fzf Conventions below).

## fzf Conventions

Every `fzf` invocation includes:

```sh
fzf --no-mouse --ansi --height=80% --reverse \
    --preview-window=bottom:40%:wrap \
    --header='TAB multi • Enter open • Shift/Alt-↑↓ scroll • Ctrl-P size • Ctrl-G abort' \
    --bind='ctrl-p:change-preview-window(bottom:70%:wrap|bottom:40%:wrap|hidden)' \
    --bind='shift-up:preview-up' --bind='shift-down:preview-down' \
    --bind='alt-up:preview-half-page-up' --bind='alt-down:preview-half-page-down' \
    --bind='ctrl-g:abort'
```

- `--no-mouse` — lets the terminal handle selection/copy and keep OSC 8 links clickable.
- `--ansi` — required for ANSI color **and** OSC 8 pass-through (fzf ≥0.55 strips `ESC ]` without it). Always pass it, even when the preview doesn't yet emit color/links.
- `--bind='ctrl-g:abort'` — reliable escape hatch; Ghostty's keyboard protocol can swallow Ctrl-C and leave the picker hung. Add to **every** picker regardless of terminal.
- **Preview scrolling** — `shift-up`/`shift-down` are fzf defaults but undiscoverable; bind them explicitly so the header can't drift from behaviour, and add `alt-up`/`alt-down` for half-page jumps (a previewed file is usually longer than the pane). Do **not** use Ctrl-U/Ctrl-D: fzf binds those to `unix-line-discard` and `delete-char/eof` on the query line.
- `--header` — list the keys. Keep it **≤80 display columns** or it wraps and eats a second row; `•` is the separator used across these pickers. Measure the string, don't eyeball it — `Shift/Alt-↑↓` reads as ASCII width but the arrows are multibyte.

Preview commands run in a plain `sh` subshell with **no** zsh `$PATH` additions or autoloaded functions — use full paths (e.g. `$HOME/bin/<script>`) for helper scripts. Inside tmux, OSC 8 also needs `set -ga terminal-features "*:hyperlinks"` in `tmux.conf` (already set).

Third-party pickers that shell out to `fzf` themselves take their options from an env var, not from these call sites — set that var in `.zshrc` so they inherit the same conventions. zoxide's `zi` reads `_ZO_FZF_OPTS`, which must be exported **before** `eval "$(zoxide init zsh)"`; it *replaces* zoxide's built-in defaults rather than adding to them, so the whole option set has to be restated (the upstream defaults plus `--no-mouse`, `--ansi`, and `ctrl-g:abort`).

### Separating display from ID

Don't inline ANSI into the visible string and strip it back out. Build each line as tab-separated fields (hidden sort keys, colored display, raw id); hand fzf `--delimiter=$'\t'` + `--with-nth=<N>` to render only the display field, and read fields back by index — `${sel##*$'\t'}` in zsh, or `{N}` inside `--preview`.

```zsh
# line: <group>\t<-mtime>\t<colored-display>\t<raw-path>
selection=$(printf '%s\n' "${lines[@]}" | fzf --ansi --no-mouse \
  --delimiter=$'\t' --with-nth=3 --preview='cat {4}' \
  --height=80% --reverse --preview-window=bottom:40%:wrap \
  --bind='ctrl-p:change-preview-window(bottom:70%:wrap|bottom:40%:wrap|hidden)')
id=${selection##*$'\t'}   # field 4, no ANSI strip needed
```

Use this whenever entries have color categories, hidden sort keys, a display≠id, or human-only annotations (`[stale]`, `(prod)`). When the picker stores MRU history, store **only the id field**.

**Don't combine `--with-nth=N` with `--nth=N`.** fzf applies `--nth` to the *post-`--with-nth`* text: after `--with-nth=2` the display is a single field, so `--nth=2` then matches against a non-existent second field and returns **0 matches for every query** (silent — no error). With `--with-nth=N` alone, fuzzy matching already operates on the displayed text, which is what you want. Reach for `--nth` only when you're *not* using `--with-nth` and need to restrict matching to specific fields of the raw line.

### Standard preview scripts

For BigQuery, git-worktree, and file previews, call the shared scripts (full path) instead of inlining `bq show`/jq or JIRA/`gh`/`stat` logic:

- `"$HOME/bin/bq-preview" "project:dataset.table"` — type, project_id (purple `-dev`/green `-prod`), dataset, table, updated/created (local + humanized), rows, bytes, description/partitioning/clustering when present, schema field list. Strip ANSI + extract the ref first if lines are colored/tab-delimited.
- `"$HOME/bin/wt-preview" {N}` (`{N}` = absolute worktree path) — path, branch, JIRA (OSC 8 link, cached `~/.cache/wts-jira/<KEY>.summary`, 3-day TTL), PR (`gh pr list`), created (birthtime), updated (newest mtime), changed files vs `origin/<default>`. Used by `rlm-wts`, `rlm-pr-worktree-rm`.
- `"$HOME/bin/wt-collection-preview" {N}` (`{N}` = absolute path of a multi-repo **collection** dir) — JIRA (OSC 8 link, key from the dirname else a member branch; same cache/TTL), the branch shared by members, created/updated, and a per-repo change roll-up: repos differing from `origin/<default>` get their changed-file list, the rest collapse onto one `unchanged:` line. Used by `rlm-wts`'s collection mode. Reserve for collection dirs; `wt-preview` remains the single-worktree case.
- `"$HOME/bin/fe-preview" {N}` (`{N}` = absolute **file** path) — path, GitHub permalink (OSC 8; pinned to the file's last-touching commit, emitted only when `git branch -r --contains` proves that commit is on a remote — a local-only commit would 404; label is the repo-relative path, middle-elided past 58 chars so it never wraps), fs mtime (tagged `[dirty XY]`/`[untracked]`), last commit (time + short SHA + subject), author as `Name <email>` via **`%aN <%aE>`** (mailmap-aware — `%an`/`%ae` leak GitHub noreply addresses; `~/git/work/.gitconfig` sets `mailmap.file`), PR number **and title** (only `#N` is the OSC 8 link — a short click target can't wrap; title follows as plain text, sourced from the subject for `… (#N)` or from the API for `Merge pull request #N from …`, which carries only the branch), then contents via `bat` else `cat`. PR number is parsed from the commit subject first (`… (#123)` / `Merge pull request #123 from …`, free + offline), falling back to `gh api …/commits/<sha>/pulls` cached at `~/.cache/rlm-fe/pr/<sha>` (negatives cached as empty files). Used by `rlm-fe`. Binary files render `<binary file>`; untracked files and non-git dirs omit the git sections.

All four are at `~/dotfiles/bin/` symlinked to `~/bin/`; being on `$PATH` is what makes them callable from the preview subshell.

## Linting

No standalone lint/test here. Validate syntax with `zsh -n my-zsh-functions/rlm-<name>`.
