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

Every user-defined function and alias should have a corresponding help file at `helpdir/<name>`. The same content is shared between the `rlm-` name and the short alias (byte-identical files or copies).

Format rules (required by `run-help`):

1. First line: synopsis (e.g. `pr-worktree [PR_NUMBER | JIRA_KEY]`)
2. Blank line
3. Description paragraphs, wrapped at ~72 chars
4. No ANSI escape codes, no trailing blank lines

Both the `rlm-<name>` and short alias files must exist. When adding a new function, add both `helpdir/rlm-<name>` and `helpdir/<name>`.

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

## Private (Machine/Company-Specific) Functions

Functions and aliases that contain any of the following **must** go into the
private directories instead of the shared ones:

- Company-internal hostnames, IP addresses, URLs, or domain names
- Internal service names, cluster names, or environment identifiers
- API keys, tokens, credentials, or secrets (even as defaults/examples)
- Anything specific to a single machine (paths, hardware identifiers)
- Work-specific workflows that reference proprietary tooling or systems

**Private directories** (`my-zsh-functions-private/`, `helpdir-private/`) are
`.gitignored` and never committed. Everything else is the same as the shared
workflow.

When adding a private autoloaded function:

1. Create `my-zsh-functions-private/rlm-<name>` with `emulate -L zsh` at the top.
2. Add `autoload -Uz rlm-<name>` to `.zshrc` (same place as shared functions).
3. Add `alias <name>='rlm-<name>'` to `.zshrc` (same place as shared aliases).
4. Create `helpdir-private/rlm-<name>` and `helpdir-private/<name>` with help content.

Do **not** add private functions to `README.md`.

## Adding a New Function

1. Create `my-zsh-functions/rlm-<name>` with `emulate -L zsh` at the top.
2. Add `autoload -Uz rlm-<name>` to `.zshrc` (near the other `autoload` lines).
3. Add `alias <name>='rlm-<name>'` to `.zshrc` (near the other short aliases).
4. Create `helpdir/rlm-<name>` and `helpdir/<name>` with identical content in the format above.
5. Update `README.md` (the function table in the relevant section).

## Linting / Formatting

This directory has no standalone lint or test commands. The parent repo (`../`) uses lefthook with shfmt and shellcheck for `.sh` files, but zsh function files in `my-zsh-functions/` are not `.sh` and are not checked by those hooks. Validate zsh syntax manually:

```zsh
zsh -n my-zsh-functions/rlm-<name>
```
