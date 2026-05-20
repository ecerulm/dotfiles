# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Structure

- `.zshenv` — environment variables, `$fpath`, `$HELPDIR`; sourced by all shells (interactive and non-interactive)
- `.zshrc` — aliases, options, plugin loading, prompt; sourced by interactive shells only
- `my-zsh-functions/` — autoloaded function files, one per file, named `rlm-<name>`
- `helpdir/` — plain-text HELPDIR files, one per command name; used by `run-help` and `fcmd` preview
- `my-zsh-functions-private/` — **gitignored** autoloaded functions; for machine/company-specific use
- `helpdir-private/` — **gitignored** help files for private functions; searched before `helpdir/`

## Naming Convention

All user-defined functions and aliases follow a two-name pattern:

- **Canonical name**: `rlm-<name>` (e.g. `rlm-pr-worktree`) — defined in `my-zsh-functions/rlm-<name>` for autoloaded functions, or inline in `.zshrc` for short functions
- **Short alias**: `<name>` (e.g. `pr-worktree`) — an alias pointing directly to the expanded form, defined in `.zshrc`

Short aliases must expand to the real value directly (e.g. `alias gc="git commit -v"`), not chain through another alias (e.g. `alias gc='rlm-gc'` fails in zsh for hyphenated names).

## Autoloaded Functions vs Inline Functions

**Autoloaded** (in `my-zsh-functions/`): registered with `autoload -Uz rlm-<name>` in `.zshrc`. The file is lazy-loaded on first call. Use for non-trivial functions.

**Inline** (defined directly in `.zshrc`): use for short one-liners or functions that need to modify the calling shell's environment (e.g. `cd`, `export`).

## Internal Helpers (`_rlm-<name>`)

Functions whose name begins with an underscore are **internal helpers**: implementation details called by other `rlm-*` functions, never directly by the user. They follow these conventions:

- File at `my-zsh-functions/_rlm-<name>` (same dir as public functions).
- **No** `autoload -Uz` line in `.zshrc` and **no** short alias.
- Callers autoload them locally at the top of the calling function: `autoload -Uz _rlm-<name>`.
- **No** `helpdir/_rlm-<name>` file — internal helpers are not surfaced through `run-help` or `rlm-fcmd`.
- **No** entry in `README.md`'s function table.

Document them only in the source file (a header comment block stating purpose, signature, and return-code contract) and in `CHANGELOG.md` when they are introduced.

Current internal helpers:

- `_rlm-dbt-cmd` — shared implementation for `rlm-dbt-run` / `rlm-dbt-build` / `rlm-dbt-test`. Takes three positional args: `<dbt_subcmd>` (run|build|test), `<resource_types>` (picker/list-view resource types, e.g. `model` or `model,seed`), and `<cost_resource_types>` (resource types included in the bq dry-run cost estimate — `model` for run/build, `test` for test).
- `_rlm-poetry-ensure-venv` — verifies that `poetry run <bin>` resolves to a binary under the project's poetry virtualenv (not a stray `$PATH` shadow); auto-runs `poetry install` once on failure. Signature: `(project_root, expected_bin, label)`. Used by `_rlm-dbt-cmd`, `rlm-dbt-ls`, and `rlm-afw-deploy`. Use this helper from any new function that invokes `poetry run <bin>` for a project-pinned tool.
- `_rlm-dbt-ensure-deps` — if `<dbt_project_root>/packages.yml` declares more packages than are installed under `dbt_packages/`, runs `poetry run dbt deps --project-dir <dbt_project_root>` once. Signature: `(project_root, dbt_project_root, label)`. Used by `_rlm-dbt-cmd` and `rlm-dbt-ls` so a fresh checkout or a newly added package doesn't make `dbt ls` silently return an empty node list.
- `_rlm-dbt-state-info` — locates the prod ref-state manifest at `$DBT_STATE_DIR/manifest.json`, optionally enforces a freshness gate, and emits shell-assignable `key=value` lines (`state_dir`, `manifest`, `age_seconds`, `age_label`) on stdout for `eval`. Flags: `--require` (hard-fail when DBT_STATE_DIR is unset / manifest missing / too old; without it, fails silently with `return 2` and empty stdout — for opportunistic use), `--max-age-days N` (freshness gate; omit to skip), `--label LBL` (stderr prefix on diagnostics). Used by `_rlm-dbt-cmd` (with `--require --max-age-days 7`) and `rlm-dbt-ls` (without `--require`, so it still works outside the deferred-state workflow). Centralizes the env-var name, the manifest path layout, the freshness check, and the macOS-vs-Linux `stat -f %m` / `stat -c %Y` fallback that was previously duplicated.
- `_rlm-dbt-project-key` — md5 of the absolute `dbt_project_root` path. The shared project-key used by every other `rlm-dbt-*` cache helper to scope per-project state. Signature: `(dbt_project_root)`; stdout: 32-char hex digest. Falls back to `md5sum | awk '{print $1}'` on Linux when BSD `md5` is absent. Used by `_rlm-dbt-cmd` and `rlm-dbt-ls`. Centralizes a formula that was previously duplicated.
- `_rlm-dbt-history` — read/write the shared pooled history file at `~/.cache/rlm-dbt/history.tsv` (format: `<epoch>\t<command>\t<project_key>\t<selector>`, newest first, deduped on `(project_key, selector)`, capped at 500 lines). Subcommands: `append <command> <project_key> <selector>` and `read <project_key>` (the latter emits `<epoch>\t<command>\t<selector>` lines). On first read/append after the new file does not yet exist, opportunistically folds in entries from the four legacy paths (`~/.cache/dbt-{run,build,test}/history_ts.txt`, `~/.cache/dbt-ls/<md5>.history`) under the current project_key — legacy files are not deleted. Used by `_rlm-dbt-cmd` and `rlm-dbt-ls`. All four `rlm-dbt-*` commands now share one history file with pooled cross-command visibility (a `dbt-ls` pick of `tag:finance` shows up at the top of `dbt-run`'s picker as `tag:finance (last used 1h ago in dbt-ls)`).
- `_rlm-dbt-nodes-cache` — fetch / read the shared per-project nodes cache at `~/.cache/rlm-dbt/<project_key>/nodes.json` (one JSON object per line, from `dbt ls --output json` covering model + seed + test + snapshot). Subcommands: `path <project_key>` (cache file path), `refresh <project_key> <project_root> <dbt_project_root> <profiles_dir> <target> [<profile>]` (re-fetch and atomically rewrite the cache), and `read <project_key> <jq_filter>` (apply a `jq -r` filter and print one entry per line). Lets each `rlm-dbt-*` command filter the shared cache by `resource_type` (`select(.resource_type == "model") | .name` for run/ls, `or .resource_type == "seed"` for build, `"test"` for test) instead of fetching its own `dbt ls`. Used by `_rlm-dbt-cmd` and `rlm-dbt-ls`. The on-disk JSON also feeds `dbt-model-preview` in rlm-dbt-ls's Phase 1 preview pane.
- `_rlm-bq-cache-key` — md5 of `BQ_SEARCH_PATH + SANDBOX_BQ_PROJECT + SANDBOX_BQ_DATASETS`, the shared cache key used by every `rlm-bq-*` / `rlm-sandbox-bq-*` command to scope per-environment table-list state. Stdout: 32-char hex digest. Pipes `print -l --` directly into `md5` (or `md5sum | awk '{print $1}'` on Linux) — do **not** round-trip the input through `$(...)`, which would silently change the digest when sandbox vars are unset (a blank trailing arg legitimately contributes a blank line to the input). Centralizes a formula that was previously duplicated in `rlm-bq-open` and `rlm-bq-archive`.
- `_rlm-bq-cache` — fetch / read the shared cache pair at `~/.cache/bq-open/<md5>.txt` (non-sandbox tables from `BQ_SEARCH_PATH`) and `~/.cache/bq-open/<md5>-sandbox.txt` (sandbox tables from `SANDBOX_BQ_PROJECT` + `SANDBOX_BQ_DATASETS`). Subcommands: `paths` (emit `key=`, `cache=`, `sandbox=` lines for `eval`), `refresh [--main-only | --sandbox-only]` (re-fetch via `bq ls` — sandbox fetch runs each dataset in parallel; default is both), `read [--main | --sandbox | --both]` (concatenate the cache file(s) to stdout, one bq_ref per line). Used by all five `rlm-bq-*` / `rlm-sandbox-bq-*` commands. Replaces the per-command `_bq_open_fetch{,_sandbox}` (rlm-bq-open) and `_sandbox_bq_{open,rm}_fetch` (sandbox-bq-{open,rm}) functions and the always-fresh parallel `bq ls` in rlm-bq-rm-tables.
- `_rlm-bq-history` — read/write the shared pooled history file at `~/.cache/bq-open/history.tsv` (format: `<epoch>\t<command>\t<bq_ref>\t<flags>`, newest first, deduped on `bq_ref`, capped at 500 lines). Subcommands: `append <command> <bq_ref> [<flag> ...]` (flags are comma-joined into the flags column; today the only flags are `sandbox` and `deleted`) and `read` (stream the file back). On first read/append, opportunistically folds in entries from the two legacy paths (`~/.cache/bq-open/history.txt` with the `[sandbox] ` prefix scheme, and `~/.cache/sandbox-bq-open/history.txt` with bare refs) — legacy files are not deleted, just stop being read. Used by all five `rlm-bq-*` / `rlm-sandbox-bq-*` commands so a pick in any of them becomes a first-class suggestion in every other picker (e.g. a `sandbox-bq-open` pick of `proj:scratch.foo` shows up in `rlm-bq-open`'s picker as `proj:scratch.foo (last used 1h ago in sandbox-bq-open, sandbox)`).
- `_rlm-bq-dead-refs-gc` — garbage-collect refs that `bq-preview` marked as dead (one ref per line in `~/.cache/bq-open/dead-refs.txt`) out of every per-cache file (`<md5>.txt`, `<md5>-sandbox.txt`), the unified history TSV (matching on field 3 = `bq_ref`), and the legacy `history.txt` (stripping `[sandbox] ` for the match). Deletes `dead-refs.txt` post-sweep. Idempotent and safe to invoke unconditionally at the top of every `rlm-bq-*` / `rlm-sandbox-bq-*` caller. Originally inline in `rlm-bq-open:36–59`; lifted into a shared helper so all five callers run the GC, not just `rlm-bq-open`. Note: uses `$(cat …)` rather than `$(<…)` to read the dead-refs file so `zsh -n` (NO_EXEC) doesn't try to open the file during the parse pass.

## helpdir Files

Every user-defined function and alias should have a corresponding help file at `helpdir/<name>`. The canonical file is `helpdir/rlm-<name>`; the short-alias file `helpdir/<name>` must be a **symlink** pointing to it — not an independent copy:

```zsh
ln -s rlm-<name> helpdir/<name>
```

Format rules (required by `run-help`):

1. First line: synopsis (e.g. `pr-worktree [PR_NUMBER | JIRA_KEY]`)
2. Blank line
3. Description paragraphs, wrapped at ~72 chars
4. No ANSI escape codes, no trailing blank lines

Both `helpdir/rlm-<name>` (real file) and `helpdir/<name>` (symlink → `rlm-<name>`) must exist.

## fcmd Preview Chain

`rlm-fcmd` (the fzf command picker) uses this priority order for its preview pane:

1. `$HELPDIR/<name>` — custom help (the `helpdir/` files)
2. System zsh helpdir — builtins like `setopt`, `bindkey`
3. Pre-rendered def cache — alias expansion + function body (from running shell)
4. `man <name> | col -bx` — man page stripped of escape sequences
5. `type <name>` — fallback

## run-help

`.zshrc` replaces the default `man`-alias with the real builtin:

```zsh
unalias run-help 2>/dev/null
autoload -Uz run-help
```

Known limitation: autoloaded functions that haven't been called yet appear to `whence -va` as `"foo is an autoload shell function"`. The word `an` breaks `run-help`'s internal pattern match, causing fallthrough to `man`. The `helpdir/` files work around this — `run-help` checks `$HELPDIR` before classifying the name.

## Private (Machine/Company-Specific) Functions and Aliases

Functions and aliases that contain any of the following **must** go into the
private locations instead of the shared ones:

- Company-internal hostnames, IP addresses, URLs, or domain names
- Internal service names, cluster names, or environment identifiers
- API keys, tokens, credentials, or secrets (even as defaults/examples)
- Anything specific to a single machine (paths, hardware identifiers)
- Work-specific workflows that reference proprietary tooling or systems

### Private simple aliases

Add them to `~/.zshrc.thismachine` (gitignored, sourced at the end of `.zshrc`).
This is the right place for one-liner aliases — no autoload registration needed.

```zsh
alias rlm-<name>='...'
alias <name>='rlm-<name>'
```

### Private autoloaded functions

Use `my-zsh-functions-private/` and `helpdir-private/` (both gitignored).

1. Create `my-zsh-functions-private/rlm-<name>` with `emulate -L zsh` at the top.
2. Add `autoload -Uz rlm-<name>` to `~/.zshrc.thismachine` (not `.zshrc` — keeps the name out of the shared repo).
3. Add `alias <name>='rlm-<name>'` to `~/.zshrc.thismachine` as well.
4. Create `helpdir-private/rlm-<name>` with help content, then symlink: `ln -s rlm-<name> helpdir-private/<name>`.

Do **not** add private functions or aliases to `README.md`.

## Adding a New Function

1. Create `my-zsh-functions/rlm-<name>` with `emulate -L zsh` at the top.
2. Add `autoload -Uz rlm-<name>` to `.zshrc` (near the other `autoload` lines).
3. Add `alias <name>='rlm-<name>'` to `.zshrc` (near the other short aliases).
4. Create `helpdir/rlm-<name>` with help content, then symlink: `ln -s rlm-<name> helpdir/<name>`.
5. Update `README.md` (the function table in the relevant section).

## Emitting Escape Sequences from zsh: `print -r --` (not `print --`)

When a zsh function or script prints output that contains backslashes,
escape sequences, or strings captured from a command substitution that
itself produced escapes (e.g. an OSC 8 hyperlink builder), **always use
`print -r -- "$value"`**, never `print -- "$value"`.

Without `-r` (raw), `print` interprets backslashes in the string:

- `\\` becomes a single `\`
- `\e` becomes `ESC` (0x1b)
- A lone `\` followed by a non-special char is dropped

This is especially destructive for OSC 8 hyperlinks. Their terminator
is `ESC \` (bytes `0x1b 0x5c`). If the URL/text is built once with
`printf '\e]8;;URL\e\\TEXT\e]8;;\e\\'` and captured into a variable
via `$(...)`, the variable holds the correct two bytes. But re-emitting
it with `print -- "$var"` eats the `\` after each `ESC`, producing
`ESC` followed directly by the next character. The terminal then
consumes that next character as part of an (invalid) escape sequence:

- Input bytes: `prod ESC \ storytel` (correct ST + text)
- After `print --`: `prod ESC storytel` (one byte gone)
- On screen: `prodtorytel` (terminal eats the `s`)

This presents exactly as "the OSC 8 hyperlink is broken" / "I see
`8;;https://...` instead of a clickable link", but the root cause is
the zsh output formatter, not fzf or the terminal.

Rule: in any new zsh code, default to `print -r -- "..."` for emitting
strings; only use `print -- "..."` when you explicitly want backslash
interpretation (rare). `printf '%s\n' "$var"` is also safe.

## fzf Conventions (apply to every picker)

Every `fzf` invocation in this repo must include the following flags so
that pickers behave consistently and preview panes work as intended:

```sh
fzf \
    --no-mouse \
    --ansi \
    --height=80% --reverse \
    --preview-window=bottom:40%:wrap \
    --bind='ctrl-p:change-preview-window(bottom:70%:wrap|bottom:40%:wrap|hidden)'
```

- `--no-mouse` — keeps fzf from capturing mouse events, so the terminal
  emulator can handle text selection / copy-paste in the preview pane and
  OSC 8 hyperlinks remain clickable. Without this, fzf intercepts clicks
  before the terminal sees them.
- `--ansi` — required for both ANSI color codes **and** OSC 8 hyperlink
  pass-through (`\e]8;;URL\e\\TEXT\e]8;;\e\\`). Without `--ansi`, fzf
  strips the leading `ESC ]` from OSC sequences and the URL bytes leak
  into the visible preview as plain text (e.g. `8;;https://...TEXT`).
  This applies to all fzf >= 0.55. Always pass `--ansi`, even if the
  current preview does not yet emit color or hyperlinks — future
  preview-script edits should not need to also remember to add the flag.
- `--height=80%`, `--reverse`, `--preview-window=bottom:40%:wrap`, and
  the `ctrl-p` binding match the conventions used across all `rlm-*`
  pickers (see `memory/fzf_conventions.md`).

The fzf preview command runs in a plain `sh` subshell that does **not**
inherit the zsh `$PATH` additions or autoloaded functions. Bare command
names not in standard system locations (`/usr/bin`, `/bin`) will fail
with `command not found`. Use the full path (e.g. `$HOME/bin/<script>`)
for any helper script invoked from a preview.

When running inside tmux, OSC 8 hyperlinks also require:

```tmux
set -ga terminal-features "*:hyperlinks"
```

in `tmux.conf`. Without it, tmux strips OSC 8 before the host terminal
ever sees it. Document this in any function's helpdir entry whose
preview emits clickable links.

## Separating Display from ID in fzf Pickers

When picker entries need styling (ANSI color, highlight markers) or hidden
sort-key columns, do **not** inline ANSI escapes into the visible string
and then strip them back out of the selection. fzf has native support for
this through `--delimiter`, `--with-nth`, and field references inside
`--preview`. Use that instead.

The pattern: build each line as several tab-separated fields. Some fields
are hidden sort keys, one is the *display* form (with color), one is the
plain *id* (the raw value the function actually consumes). Hand fzf the
delimiter, tell it which fields to render with `--with-nth`, and read any
field back from the selection by index — either via `${selection##*$'\t'}`
in zsh or by referencing `{N}` inside the preview command.

```zsh
# Each line: <group>\t<-mtime>\t<colored-display>\t<raw-path>
#   group, -mtime: hidden sort keys (kept out of the display)
#   colored-display: what fzf shows (green ANSI for branch-changed files)
#   raw-path: the unstyled id, read back from the selection
picker_lines+=("${group}	-${mtime}	${green}${path}${reset}	${path}")
# ... sort by columns 1 and 2 ...
selection=$(
  printf '%s\n' "${picker_lines[@]}" \
  | fzf \
      --no-mouse \
      --ansi \
      --delimiter=$'\t' \
      --with-nth=3 \
      --preview='cat {4}' \
      --height=80% --reverse \
      --preview-window=bottom:40%:wrap \
      --bind='ctrl-p:change-preview-window(bottom:70%:wrap|bottom:40%:wrap|hidden)'
)
id=${selection##*$'\t'}     # field 4: the raw path, no ANSI strip needed
```

Key flags:

- `--delimiter=$'\t'` — splits each line into fields. Use a literal tab
  (not the string `\t`); zsh interprets `$'\t'` to the tab byte.
- `--with-nth=3` — fzf renders **only** column 3. Columns 1, 2, and 4
  are kept in the line but never shown. Supports ranges (`--with-nth=3..`)
  and exclusions (`--with-nth=3,5`).
- `--nth=3` (optional) — restricts fuzzy matching to a subset of fields.
  Omit it if you want the user's query to match any field, including the
  hidden id; include it if the sort keys would create spurious matches.
- `--preview='cat {N}'` — field references inside the preview command
  expand to the Nth field of the focused line. `{}` is the whole line,
  `{1}`, `{2}`, etc. are individual fields, `{4..}` is field 4 onward.
  This means the preview can call commands directly on the raw id
  without any sed/cut/awk dance.
- The selection echoed back to the caller is the **full original line**,
  so you extract whatever field you need with a parameter expansion
  (`${selection##*$'\t'}` for the last field, `${selection%%$'\t'*}` for
  the first) or with `cut -f N`.

Use this approach **whenever** a picker entry has any of the following:

- ANSI color that distinguishes categories of entries (e.g. files changed
  on this branch shown in green, others uncolored).
- Hidden sort keys (group, timestamp) that should not be visible.
- A display label that differs from the id (e.g. `<pr-title>` shown,
  `<pr-number>` consumed).
- Annotations like `[modified]`, `[stale]`, `(prod)` that exist for the
  human eye but should not leak into the value passed downstream.

Avoid the alternative — inlining ANSI into the visible string and then
stripping it from the selection with `sed 's/\x1b\[[0-9;]*m//g'` or a
zsh `${var//PATTERN/}` extended-glob expansion. That approach is fragile
(extended glob is off by default in `emulate -L zsh`, and the literal
`\e` byte inside a substitution pattern has surprising semantics), it
duplicates the strip logic between the selection-readback and the
preview command, and it makes the line content position-dependent in
ways that break when a new field is added later.

When the picker also needs MRU history (see the create-zsh-function
skill, Step 5), store **only the id field** in `history.txt` — that
keeps the history file readable and matches the field-1 key pattern
used by the tab-delimited variant of `_<name>_sorted_list`.

## BigQuery fzf Preview Panes

For any fzf picker that shows BigQuery table or view information in its
preview pane, always call the `bq-preview` script instead of inlining
`bq show` + jq/python3 logic:

```sh
--preview='"$HOME/bin/bq-preview" "project:dataset.table"'
```

Always use the full path `$HOME/bin/bq-preview` (not bare `bq-preview`)
— see the fzf conventions section above for why bare names fail in the
preview subshell.

`bq-preview` is a standalone executable at `~/dotfiles/bin/bq-preview`
(symlinked to `~/bin/bq-preview`). It accepts a single `project:dataset.table`
argument and prints standardized fields in this order:

01. type
02. project_id (purple if it ends in `-dev`, green if `-prod`, otherwise uncolored)
03. dataset_id
04. table_id
05. updated_at (local time + humanized "N units ago")
06. created_at (same format as updated_at)
07. num_rows (humanized: K/M/B)
08. logical_bytes (humanized: KiB/MiB/GiB/TiB)
09. description, partitions, partitioning, clustering (each only when present)
10. schema_fields (count)
11. fields — one line per column: `- <name> <TYPE> [<MODE>]  — <description>`,
    with nested RECORD/REPEATED children indented one level per nesting depth

Because fzf preview runs in a plain sh subshell, zsh autoloaded functions are
not available there — `bq-preview` being on `$PATH` is what makes it callable.

When fzf lines contain ANSI escape codes or tab-delimited fields, strip color
and extract the ref before passing to `bq-preview`, e.g.:

```sh
--preview='raw=$(printf "%s" {} | cut -f2 | sed "s/\x1b\[[0-9;]*m//g"); "$HOME/bin/bq-preview" "$raw"'
```

## git-worktree fzf Preview Panes

For any fzf picker that shows git-worktree information in its preview
pane, always call the `wt-preview` script instead of inlining JIRA
cache reads, `gh pr view`, `stat`-birthtime probes, and `find` mtime
sweeps:

```sh
--preview='"$HOME/bin/wt-preview" {N}'
```

where `{N}` is the field that holds the worktree's **absolute path**.
Use the standard `--no-mouse --ansi --preview-window=bottom:40%:wrap`
fzf conventions and pair with the `ctrl-p` cycle binding.

Always use the full path `$HOME/bin/wt-preview` (not bare `wt-preview`)
— see the fzf conventions section above for why bare names fail in the
preview subshell.

`wt-preview` is a standalone executable at `~/dotfiles/bin/wt-preview`
(symlinked to `~/bin/wt-preview`). It accepts a single absolute
worktree path and prints these fields in order (each line is omitted
silently when the underlying lookup fails):

1. Path — relative to the caller's `$PWD`
2. Branch — current branch in the worktree, or `<detached>`
3. JIRA — `<KEY>  <Status + summary>` as an OSC 8 hyperlink to
   `https://storytel.atlassian.net/browse/<KEY>` (blue), only when the
   branch contains a `[A-Z][A-Z0-9]+-[0-9]+` key. Summary served from
   `~/.cache/wts-jira/<KEY>.summary` with a 3-day-TTL `acli` refresh.
4. PR — `#N  [state]  <title>` as an OSC 8 hyperlink to the PR url
   (blue). Looked up per invocation via `cd "$abs_path" && gh pr list --head <branch>`; no cache.
5. Created — `YYYY-MM-DD HH:MM:SS  (X units ago)`. Directory birthtime
   (macOS `stat -f '%B'`, Linux `stat -c '%W'` with ctime fallback).
6. Updated — same format, most recent file mtime under the worktree
   excluding `.git/`. Uses `fd` when available, `find` otherwise.
7. Changed — `N file(s) vs origin/<default>` followed by one line per
   changed file: `+adds / -dels  <path>`, with adds in green and dels
   in red. Derived from `git diff --numstat <fork-point>`, which
   includes both committed and uncommitted changes. Fork point chain:
   `git merge-base --fork-point origin/<default>`, falling back to
   `git merge-base HEAD origin/<default>`. Binary files render as
   `bin / bin`. Column widths are padded so the `+N / -M` column lines
   up across rows.

Used by `rlm-wts` and `rlm-pr-worktree-rm`.

Click-through on the OSC 8 links requires a terminal with OSC 8
support; inside tmux also requires `set -ga terminal-features "*:hyperlinks"` (already configured in `tmux.conf`).

## Linting / Formatting

This directory has no standalone lint or test commands. The parent repo (`../`) uses lefthook with shfmt and shellcheck for `.sh` files, but zsh function files in `my-zsh-functions/` are not `.sh` and are not checked by those hooks. Validate zsh syntax manually:

```zsh
zsh -n my-zsh-functions/rlm-<name>
```
