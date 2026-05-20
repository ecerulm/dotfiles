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

- `_rlm-dbt-cmd` — shared implementation for `rlm-dbt-run` / `rlm-dbt-build`.
- `_rlm-poetry-ensure-venv` — verifies that `poetry run <bin>` resolves to a binary under the project's poetry virtualenv (not a stray `$PATH` shadow); auto-runs `poetry install` once on failure. Signature: `(project_root, expected_bin, label)`. Used by `_rlm-dbt-cmd`, `rlm-dbt-ls`, and `rlm-afw-deploy`. Use this helper from any new function that invokes `poetry run <bin>` for a project-pinned tool.
- `_rlm-dbt-ensure-deps` — if `<dbt_project_root>/packages.yml` declares more packages than are installed under `dbt_packages/`, runs `poetry run dbt deps --project-dir <dbt_project_root>` once. Signature: `(project_root, dbt_project_root, label)`. Used by `_rlm-dbt-cmd` and `rlm-dbt-ls` so a fresh checkout or a newly added package doesn't make `dbt ls` silently return an empty node list.
- `_rlm-dbt-state-info` — locates the prod ref-state manifest at `$DBT_STATE_DIR/manifest.json`, optionally enforces a freshness gate, and emits shell-assignable `key=value` lines (`state_dir`, `manifest`, `age_seconds`, `age_label`) on stdout for `eval`. Flags: `--require` (hard-fail when DBT_STATE_DIR is unset / manifest missing / too old; without it, fails silently with `return 2` and empty stdout — for opportunistic use), `--max-age-days N` (freshness gate; omit to skip), `--label LBL` (stderr prefix on diagnostics). Used by `_rlm-dbt-cmd` (with `--require --max-age-days 7`) and `rlm-dbt-ls` (without `--require`, so it still works outside the deferred-state workflow). Centralizes the env-var name, the manifest path layout, the freshness check, and the macOS-vs-Linux `stat -f %m` / `stat -c %Y` fallback that was previously duplicated.

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

## Linting / Formatting

This directory has no standalone lint or test commands. The parent repo (`../`) uses lefthook with shfmt and shellcheck for `.sh` files, but zsh function files in `my-zsh-functions/` are not `.sh` and are not checked by those hooks. Validate zsh syntax manually:

```zsh
zsh -n my-zsh-functions/rlm-<name>
```
