# Zsh Configuration

Personal zsh config with `ZDOTDIR` pointing to this directory.

## Directory Structure

- `.zshenv` — environment variables, `$FPATH`, sourced by all shells
- `.zshrc` — aliases, options, plugin loading, prompt (interactive shells only)
- `.zprofile` / `.zlogin` / `.zlogout` — login/logout hooks
- `.p10k.zsh` — Powerlevel10k prompt config
- `my-zsh-functions/` — autoloaded functions (lazy-loaded via `autoload -Uz`)

______________________________________________________________________

## FPATH, HELPDIR, and `run-help`

### FPATH

`$fpath` is zsh's search path for function files, analogous to `$PATH` for executables.
`zsh/.zshenv` prepends `~/dotfiles/zsh/my-zsh-functions` to `$fpath`:

```zsh
fpath+=~/dotfiles/zsh/my-zsh-functions
```

Each file in that directory whose name matches a function registered with `autoload -Uz <name>` is
lazy-loaded: the file is read and the function body compiled the first time the function is called.
Until that first call the function is a stub — its source text is on disk but not in memory.

### HELPDIR

`$HELPDIR` is an optional directory of per-command plain-text files used by `run-help` as a
last-resort fallback. Files are named after the command, e.g. `$HELPDIR/zshbuiltins`. Zsh ships
with a pre-populated `HELPDIR` (typically under the zsh share directory).

This config does **not** maintain a custom `$HELPDIR`. There are no separate help text files for
`rlm-pr-worktree`, `rlm-mkpw`, etc. The authoritative documentation for each function is its source
file in `my-zsh-functions/` — read it directly with `cat` or open it in an editor.

### `run-help` — how it works

By default, zsh aliases `run-help` to `man`, which only searches man pages. `.zshrc` replaces it
with the real autoloaded `run-help` builtin:

```zsh
unalias run-help 2>/dev/null
autoload -Uz run-help
```

When you press `<Esc-h>` (or call `run-help <name>`) the real builtin does the following:

1. Calls `whence -va <name>` to classify the name (builtin, alias, function, external command, …).
2. Based on the result:
   - **Zsh builtins** (`setopt`, `bindkey`, …) — opens inline builtin documentation.
   - **Aliases** — prints the alias expansion.
   - **Functions already in memory** — prints the function source body.
   - **Autoloaded-but-not-yet-called functions** — `whence -va` reports the stub as
     `"<name> is an autoload shell function"`. The pattern match inside `run-help` expects
     `"… is a … function"` (without `an`), so it falls through to `man <name>`, which usually
     yields "No manual entry". This is a known zsh limitation.
   - **External commands** — falls through to `man <name>`.

#### Help for `rlm-*` functions

Because these functions are autoloaded and typically have not been called yet in a fresh shell,
`run-help rlm-pr-worktree` will fall through to `man rlm-pr-worktree` (no entry found).

Workarounds:

- **Call the function once** to load it into memory, then `run-help <name>` will show the body.
- **Read the source directly**: `cat ~/dotfiles/zsh/my-zsh-functions/rlm-pr-worktree`
- **Use `which -a <name>`** or `type <name>` to see where the stub lives.

______________________________________________________________________

## Autoloaded Functions

Functions in `my-zsh-functions/` are registered in `.zshrc` with `autoload -Uz rlm-<name>` and
are available in any interactive shell. Each function is also aliased to a shorter name without the
`rlm-` prefix.

### Git / GitHub

| Function | Short alias | Description |
|---|---|---|
| `rlm-pr-worktree [PR\|KEY]` | `pr-worktree` | Pick a GitHub PR or JIRA issue via fzf and create a sibling git worktree. Without an argument opens a fuzzy picker showing your PRs, your JIRA issues, and other open repo PRs. Pass a PR number or JIRA key to skip the picker. |
| `rlm-pr-worktree-rm` | `pr-worktree-rm` | Multi-select worktrees via fzf and delete them. Shows merge status and PR state (open/merged/closed) for each. Confirms before deleting. |
| `rlm-pr-for-commit <commit-ish>` | `pr-for-commit` | Print the GitHub PR URL that introduced a commit into the default branch. Tries the GitHub API first (works for squash-merges), then falls back to parsing merge commit subjects. |
| `rlm-jira-open [--print]` | `jira-open` | Open the JIRA ticket associated with the current repo/branch in a browser. Searches branch name → PR title → commit subjects in that order. `--print` outputs the URL instead of opening it. |
| `rlm-git-changed` | `git-changed` | Pick a file changed since the fork point of the current branch (relative to the default remote branch) via fzf and open it in `$EDITOR`. Preview shows the diff for the selected file. Requires: `git`, `fzf`. |
| `rlm-git-diff-base` | `git-diff-base` | Run `git diff` from the merge base of the current branch. Uses the PR's base branch if an open PR exists, otherwise falls back to the repo's default branch. Extra arguments are forwarded to `git diff`. Requires: `git`, `gh`. |
| `rlm-gh-permalink` | `gh-permalink` | Pick a file from the current git repo via fzf (respecting .gitignore) and open its immutable GitHub permalink (pinned to HEAD SHA) in the browser. |

### Google Cloud / BigQuery

| Function | Short alias | Description |
|---|---|---|
| `rlm-bq-open` | `bq-open` | Browse BigQuery tables across projects via fzf and open the selected table in the GCP console. Projects are read from `$BQ_SEARCH_PATH` (colon-separated). Table list is cached in `~/.cache/bq-open/`; select `--- REFRESH CACHE ---` in the picker to re-fetch. Prints the URL, copies it to the clipboard, and opens it in the browser. Requires `bq`, `fzf`, `jq`. |
| `rlm-sandbox-bq-open` | `sandbox-bq-open` | Browse BigQuery tables in `storytel-data-platform-dev` restricted to `ecerulm*` datasets via fzf and open the selected table in the GCP console. Table list is cached in `~/.cache/sandbox-bq-open/`; select `--- REFRESH CACHE ---` to re-fetch. Prints the URL, copies it to the clipboard, and opens it in the browser. Requires `bq`, `fzf`, `jq`. |
| `rlm-sandbox-bq-rm` | `sandbox-bq-rm` | Multi-select BigQuery tables in the sandbox project/datasets via fzf and permanently delete them. Shares the table-list cache with `sandbox-bq-open`. Prompts for confirmation before deletion; invalidates the cache on success. Requires `bq`, `fzf`, `jq`. |
| `rlm-gcp-project-open` | `gcp-project-open` | Browse all accessible GCP projects via fzf and open the selected project in the GCP console. Project list is cached in `~/.cache/gcp-project-open/`; select `--- REFRESH CACHE ---` to re-fetch. Prints the URL, copies it to the clipboard, and opens it in the browser. Requires `gcloud`, `fzf`. |
| `rlm-pubsub-open` | `pubsub-open` | Browse Pub/Sub topics across one or more GCP projects via fzf and open the selected topic in the GCP console. Projects are read from `$PUBSUB_OPEN_PROJECTS` (colon-separated). Topic list is cached in `~/.cache/pubsub-open/`; select `--- REFRESH CACHE ---` to re-fetch. Preview pane (via `~/bin/pubsub-preview`) shows project, name, topic schema, and subscriptions — schema and subscriptions are OSC 8 hyperlinks to their GCP console pages. Prints the URL, copies it to the clipboard, and opens it in the browser. Requires `gcloud`, `fzf`, `jq`. |
| `rlm-afw-deploy` | `afw-deploy` | Deploy a DAG to the dev Airflow sandbox. Must be run from the project root (containing `airflow_manager/` and `pyproject.toml`). Opens an fzf picker over `*.py` files in `airflow_manager/dag_folder/`; last selection is cached per project root in `~/.cache/afw-deploy/`. Verifies `afw` resolves to the project's poetry venv (via the `_rlm-poetry-ensure-venv` helper); auto-runs `poetry install` if not. Requires `poetry`, `fd`, `fzf`. |
| `rlm-dbt-ls [SELECTOR]` | `dbt-ls` | Run `dbt ls` via poetry and browse the results in an fzf multi-select picker. Finds `dbt_profiles.yml` automatically (up to 4 dirs deep) and uses its directory as `--profiles-dir`; profile is `local_dev`. After fzf exits without a selection, prompts to edit the selector and retry. Prints selected model names to stdout. Verifies `dbt` resolves to the project's poetry venv (via the `_rlm-poetry-ensure-venv` helper); auto-runs `poetry install` if not. Requires `poetry`, `fzf`. |
| `rlm-dbt-run [-s SELECTOR] [-n]` | `dbt-run` | Run a dbt model locally with `--defer` against a production ref-state manifest. Omit `-s` for an fzf picker over all models (recently used first). `-n` shows a dry-run list of which nodes build locally vs. are deferred from prod. Estimates query cost before running. Verifies `dbt` resolves to the project's poetry venv (via the `_rlm-poetry-ensure-venv` helper); auto-runs `poetry install` if not. Configured entirely via env vars (`DBT_STATE_DIR`, `DBT_PROJECT_SUBDIR`, `DBT_TARGET`, `DBT_DEV_PROJECT`, `DBT_DATASET_PREFIX`) — set these in `~/.zshrc.thismachine`. Requires `poetry`, `bq`, `fzf`, `python3`. |
| `rlm-dbt-build [-s SELECTOR] [-n]` | `dbt-build` | Like `dbt-run` but runs `dbt build` (models, seeds, tests, snapshots). The fzf picker covers both models and seeds. Shares the deferred-state, history, cost-estimate, `-n` list-only behaviour, and poetry-venv check with `dbt-run`; both wrappers delegate to the `_rlm-dbt-cmd` helper. Same env vars as `dbt-run`. |

### Python

| Function | Short alias | Description |
|---|---|---|
| `rlm-pyactivate [version]` | `pyactivate` | Activate a Python environment by name. Uses `uv` if available, falls back to `pyenv`. Without an argument reads the version from `.python-version`. Defines a `deactivate` function to restore `PATH`. |
| `rlm-pyclean` | `pyclean` | Delete all `*.pyc` / `*.pyo` files and `__pycache__` directories under the current directory. |

### Passwords / Security

| Function | Short alias | Description |
|---|---|---|
| `rlm-mkpw [length]` | `mkpw` | Generate an alphanumeric password. Default length is 14 characters. |
| `rlm-randompassword` | `randompassword` | Generate a 20-character password using alphanumeric chars plus `#`, `.`, `-`. |

### Shell / Command Discovery

| Function | Short alias | Description |
|---|---|---|
| `rlm-fcmd [query]` | `fcmd` | Fuzzy-pick any zsh alias, function, builtin, reserved word, or `$PATH` command. Preview pane shows the full alias expansion or function body. On selection, pushes the name onto the command line for editing. Requires `fzf`. |
| `rlm-urldecode [url]` | `urldecode` | Break a URL into its components and percent-decode its query string, printing one `key = value` line per query parameter. Reads from `$1` or stdin. Requires `python3`. |

### System / macOS

| Function | Short alias | Description |
|---|---|---|
| `rlm-brew-unlock` | `brew-unlock` | Remove a stale Homebrew update lock file. Checks whether the locking process is still running first; refuses to remove if the process is alive. |
| `rlm-dnsflush` | `dnsflush` | Flush the macOS DNS cache (`dscacheutil -flushcache` + restart `mDNSResponder`). |
| `rlm-openports` | `openports` | List all TCP ports currently in LISTEN state (`lsof -iTCP -sTCP:LISTEN`). |
| `rlm-generatectags` | `generatectags` | Run `ctags -R --fields=+zK` to generate tags for the current tree. |
| `rlm-testterminal` | `testterminal` | Print all 256 terminal colours plus samples of bold, italic, underline, and strikethrough to verify terminal rendering. |
| `rlm-hello` | `hello` | Print "Hello world." — sanity-check that autoloading works. |

______________________________________________________________________

## Inline Functions (defined in `.zshrc`)

| Function | Short alias | Description |
|---|---|---|
| `rlm-wts` | `wts` | Switch into a git worktree via fzf. Strips common path prefixes for readability, annotates worktrees whose branch contains a JIRA key with `(Status) Summary` fetched from JIRA (cached 1 hour in `~/.cache/wts-jira/`), and shows a preview pane with full JIRA detail. |
| `rlm-pre-commit-pr [base]` | `pre-commit-pr`, `pcpr` | Run `pre-commit` on files changed in the current branch since its fork point from `base` (default: `main`). |
| `rlm-lhdir [hook]` | `lhdir`, `lhd` | Run lefthook on every tracked/non-ignored file under the current directory. Defaults to the `pre-commit` hook. |
| `rlm-awsprofile` | `awsprofile` | Pick an AWS profile via fzf and export it as `AWS_PROFILE`. |
| `rlm-sqlfluff-fix` | — | Run `sqlfluff-lint` via `pre-commit` on files changed between the current branch and `origin/main`. |
| `rlm-reset-kkp` | — | Reset the Kitty Keyboard Protocol escape sequence after each command (runs as a `precmd` hook). Prevents `ctrl-c` showing as `9;5u` after killing certain apps. |

______________________________________________________________________

## Aliases

### Editor

| Alias | Expands to |
|---|---|
| `vi` | `nvim` |
| `vim` | `nvim` |
| `zshconfig` | `nvim $ZDOTDIR/.zshrc` |

### Git

| Alias | Expands to |
|---|---|
| `s` | `git st` |
| `gdc` | `git dc` |
| `gd` | `git d` |
| `gc` | `git commit -v` |
| `gca` | `git commit -v --amend` |
| `gau` | `git a` (add -u) |
| `gap` | `git a -p` (add --patch) |
| `gas` | `git as` (add already-staged files) |
| `glc` | `git rev-parse HEAD` (print last commit SHA) |
| `gdm` | `git diff main` |
| `gdms` | `git diff --stat main` |
| `diffmain` | Fetch then diff stat from fork point of `origin/main` |
| `reviewmain` | Fetch then log commits since fork point of `origin/main` |
| `gdlc` | `git diff HEAD^ HEAD` (diff last commit) |
| `gdw` | `git diff` |
| `gfa` | `git fetch --all` |
| `gb` | `git branch --sort=-committerdate` |

### File Listing

| Alias | Expands to |
|---|---|
| `l` | `eza -l -s mod` |
| `t` | `eza -l -s mod -T --git-ignore` (tree view) |
| `ls` | `eza -l --git --icons --time-style long-iso -snew` (if `eza` installed) |

### Navigation

| Alias | Expands to |
|---|---|
| `cd` | `z` (zoxide, if installed) |

### Terraform

| Alias | Expands to |
|---|---|
| `tp` | `terraform plan -out latest.tfplan` |
| `ta` | `terraform apply latest.tfplan` |

### Pulumi

| Alias | Expands to |
|---|---|
| `pu` | `pulumi up` |
| `pus` | `pulumi up --skip-preview` |

### Misc

| Alias | Expands to |
|---|---|
| `ctags` | `ctags -R --fields=+zK` |
| `reuse-annotate` | `pipx run reuse annotate ...` with standard copyright/license headers |
| `pcpr` | `pre-commit-pr` (see inline functions) |
| `lhd` | `lhdir` (see inline functions) |
