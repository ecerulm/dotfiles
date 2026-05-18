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

## BigQuery fzf Preview Panes

For any fzf picker that shows BigQuery table or view information in its
preview pane, always call the `bq-preview` script instead of inlining
`bq show` + jq/python3 logic:

```sh
--preview='"$HOME/bin/bq-preview" "project:dataset.table"'
```

Always use the full path `$HOME/bin/bq-preview` (not bare `bq-preview`).

All fzf pickers must include `--no-mouse` so that fzf does not capture mouse
events and the terminal emulator can handle them (e.g. for text selection and
copy-paste in the preview pane).
The fzf preview runs in a plain `sh` subshell that does not inherit the zsh
`PATH`, so bare command names not in `/usr/bin` etc. will fail with
`command not found`.

`bq-preview` is a standalone executable at `~/dotfiles/bin/bq-preview`
(symlinked to `~/bin/bq-preview`). It accepts a single `project:dataset.table`
argument and prints standardized fields in this order:

1. type
2. project_id
3. dataset_id
4. table_id
5. updated_at
6. num_rows (humanized: K/M/B)
7. logical_bytes (humanized: KiB/MiB/GiB/TiB)
8. description, partitions, partitioning, clustering, created_at,
   schema_fields (when present)

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
