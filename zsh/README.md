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
| `rlm-pr-find [DIR] [-r|--refresh] [-d|--depth N]` | `pr-find` | Recursively scan a directory tree for git checkouts, find the PR for each one's *current* branch, and **cd** to the one you pick. Where `pr-list` covers one repo or one collection dir and prints a table, this walks a whole tree: run from `~/git/work` it finds every repo root *and* every linked worktree (~100 checkouts) and lists the ~quarter that have a PR — a repo without one is not a destination, so no-PR rows are omitted. Rows are `REPO #NUM STATE TITLE`, state color-coded (open/draft/merged/closed); preview is `gh pr view`, ENTER cds there. A bare basename is ambiguous in a collection dir (one `data-platform-dbt` per active ticket), so repeated basenames are prefixed with their parent dir, elided from the left to bound the column width; unique top-level repos stay bare. The scan issues one `gh` per checkout fanned out 16-at-a-time (~7s for 100), so results are **cached per scan root** and later runs open instantly; the first picker row is a `--- REFRESH SCAN (scanned 12m ago) ---` sentinel that rescans and reopens. Ordered most-recently-picked first, then by newest PR update; the MRU survives a refresh. Inline in `.zshrc` because it must `cd` the calling shell; the scan/cache lives in `_rlm-pr-find-cache`. Requires: `gh`, `git`, `jq`, `fd`, `fzf`. |
| `rlm-pr-list [--interactive\|-i]` | `pr-list` | List the PRs for the branches currently checked out across a set of repos — the status of a whole multi-repo change set in one table. Mode auto-detected: inside a git repo → that worktree only; otherwise every git repo found as a child of the cwd (i.e. a collection dir created by `pr-worktree`'s multi-repo mode, where each worktree sits on the same branch). For each repo it looks up the PR whose head is that worktree's *current* branch, so repos with no PR yet show as `no PR`. Columns: `REPO PR STATE CHECKS REVIEW UPDATED TITLE` — PR number is an OSC 8 link, STATE is colored (open/draft/merged/closed), CHECKS is the rollup (`ok 3`, `fail 1/4`, `pend 2/6`; SKIPPED/NEUTRAL excluded), REVIEW is the review decision. Ends with a block of bare `repo: url` lines for copy/pasting the set into Slack (bare, not OSC 8, because escape-byte links don't survive a copy-paste). Repos are queried in parallel. `-i` opens an fzf picker instead; ENTER opens the selected PR in the browser, preview shows `gh pr view`. |
| `rlm-pr-worktree [PR\|KEY]` | `pr-worktree` | Pick a GitHub PR or JIRA issue via fzf and create a sibling git worktree. Two modes, auto-detected from the cwd. **Single-repo** (cwd inside a git repo): opens a fuzzy picker showing a REFRESH sentinel (refresh the shared JIRA cache and reopen the picker — same as `Ctrl-R` from any row), a CUSTOM sentinel (free-form suffix → worktree dirname + branch name, off `origin/<default>`), all open PRs in the repo updated in the last 2 weeks (rows you authored are highlighted in green), followed by your JIRA issues (served off the shared `~/.cache/rlm-jira/` cache — assigned → reporter → watching → DATA-only, with previously-picked tickets floating to the top). Pass a PR number or JIRA key to skip the picker. Selecting a PR prompts for an optional free-form suffix appended to the worktree dirname (e.g. `<repo>-pr-1234-review-only`). **Multi-repo** (cwd is *not* a git repo but contains git repos, e.g. `~/git/work/StorytelDataPlatform`): the picker shows JIRA + CUSTOM + REFRESH only (no PRs). After the suffix/dirname prompts it creates one sibling collection dir `../<cwd-basename>_<date>_<suffix>/` holding a new worktree of every distinct repo found (deduped by `--git-common-dir`), each on a new branch off its own `origin/<default>` — JIRA → `<KEY>/feat/<slug>`, CUSTOM → the bare `<slug>`. |
| `rlm-pr-worktree-rm` | `pr-worktree-rm` | Multi-select worktrees via fzf and delete them. Shows merge status and PR state (open/merged/closed) for each. Confirms before deleting. |
| `rlm-pr-worktree-rm-merged-closed [--dry-run\|-n] [--yes\|-y]` | `pr-worktree-rm-merged-closed` | Clean up stale worktrees via a single fzf picker. Mode auto-detected: inside a git repo → that repo only; otherwise scans the cwd for primary git repos (child dirs with a `.git` directory) and gathers worktrees across all of them; otherwise, if the cwd holds git *worktrees* (i.e. it **is** a collection dir), resolves them to their primary repos via `--git-common-dir` and runs the same multi-repo mode — so invoking it from inside a collection is equivalent to `cd`-ing to the base dir first. One picker lists every worktree in scope (excluding each repo's main/current; the dir-name prefix identifies the repo), flagged by category — `[merged#N]`/`[closed#N]`/`[no-pr/no-diff]` (deletable, sorted first), `[open#N]`, `[has-work]`; TAB multi-selects, ENTER deletes (y/N confirm), Ctrl-G aborts. Worktrees created by `pr-worktree`'s multi-repo mode live together in a sibling collection dir; those render relative to the repos' grandparent (`Coll_20260727_DATA-1234/data-platform-dbt`) and, when the run covers the collection in full, get one aggregate row (`[7 wt: 5 merged, 2 open] Coll_20260727_DATA-1234/`) with the members listed under it — selecting it deletes them all and `rmdir`s the dir (refusing if anything is left). Afterwards prints a combined table of the REMAINING worktrees with staleness: `REPO WORKTREE BRANCH BEHIND AHEAD AGE CREATED` (behind/ahead vs the default branch, AGE = last-commit date, CREATED = dir birthtime; main shown as `(main)`). `--dry-run` skips the picker and just prints the deletable set + table; `--yes` is accepted but ignored. Same `worktree remove` → `worktree remove --force` fallback as `pr-worktree-rm`. PR state is resolved with one `gh pr list --search "head:… head:…"` per repo covering just that repo's pushed worktree branches (single `gh pr view` as fallback), rather than paging the last 500 PRs. Each phase reports progress to stderr (in place on a TTY); `PRWTRMC_QUIET=1` silences it. |
| `rlm-pr-for-commit <commit-ish>` | `pr-for-commit` | Print the GitHub PR URL that introduced a commit into the default branch. Tries the GitHub API first (works for squash-merges), then falls back to parsing merge commit subjects. |
| `rlm-jira-open [--print]` | `jira-open` | Open the JIRA ticket associated with the current repo/branch in a browser. Searches branch name → PR title → commit subjects in that order. `--print` outputs the URL instead of opening it. |
| `rlm-jira-pick` | `jira-pick` | Pick a JIRA issue via fzf and open it in the browser. Shows issues grouped (assigned → reporter → watching → DATA project), each group sorted by most recently updated. Picks are remembered as MRU and shared with `rlm-pr-worktree` (a pick in either function bumps the same MRU). Verifies `acli` auth on every run. Cached in `~/.cache/rlm-jira/`. Requires: `acli`, `fzf`, `python3`. |
| `rlm-git-changed` | `git-changed` | Pick a file changed since the fork point of the current branch (relative to the default remote branch) via fzf and open it in `$EDITOR`. Entries are sorted by recently-selected first (per-repo MRU at `~/.cache/git-changed/`), then by file mtime descending. Preview shows the diff for the selected file. Requires: `git`, `fzf`, `python3`. |
| `rlm-git-diff-base` | `git-diff-base` | Run `git diff` from the merge base of the current branch. Uses the PR's base branch if an open PR exists, otherwise falls back to the repo's default branch. Extra arguments are forwarded to `git diff`. Requires: `git`, `gh`. |
| `rlm-git-find-in-remotes <regex> [remote-glob]` | `git-find-in-remotes` | Search every remote-tracking branch for tracked paths matching an extended regex. Prints one block per branch, with the branch name and matching paths. Optional second arg restricts the refname glob (e.g. `refs/remotes/origin/`). Requires: `git`, `grep`. |
| `rlm-git-status [-c\|--changed] [-b\|--base <ref>] [-P\|--no-pr] [-J\|--no-jira] [<directory>]` | `git-status`, `git-repos` | Status table across every git repo in a directory, one row per repo — written for the multi-repo collection dirs created by `rlm-pr-worktree`'s multi-repo mode. Scans the immediate children of `<directory>` (default cwd) that are their own git worktree root; when the target is itself a repo with no repo children it reports on just that repo. Five independent state columns: `AHEAD/BEHIND` commit divergence from the base (`+N` ahead, `-N` behind, `=` in sync, `?` when the base ref is missing), `PUSH` divergence from the branch's own upstream — what `git status` calls ahead/behind (`^N` unpushed, `vN` unpulled, `unpushed` when there is no upstream, `gone` when the upstream ref was deleted, `-` detached, `=` in sync; column hidden when every repo is in sync), `LOCAL` uncommitted work (conflict/staged/unstaged/untracked counts, or `clean`), `PR` the branch's pull request rendered as `#407 open ✓ 3c 2d` — number as an OSC 8 hyperlink, state (green open, cyan merged, red closed, dim draft; a draft reads as `draft`, not `open`), review decision for open PRs only (`✓` approved, `✗` changes requested, `·` review required), comment count (issue comments plus reviews carrying a body — bare approve/reject reviews are excluded since the review glyph already reports them; omitted at zero), and time since the last activity, taken as the newest of `updatedAt`, the last comment and the last review (`updatedAt` alone also moves on a push or a label edit, so it cannot distinguish "someone replied" from "I rebased"), and `JIRA` the key parsed from the branch name (or from a key embedded in the collection dirname) as an OSC 8 hyperlink plus the cached `(Status) Summary`. `BRANCH` and `JIRA` are hoisted into the header and their columns dropped when every repo shares one value, as collection members do. Every repo gets a row by default; `--changed` narrows to repos that are dirty, diverged, or hold unpushed commits and collapses the rest onto one dim `unchanged:` line with a shared boilerplate prefix (`data-platform-`) stripped when it is long enough to be worth removing. Base defaults to `origin/<default>` (from `origin/HEAD`, falling back to `origin/main`); nothing is fetched, so divergence reflects the remote-tracking refs as they stand locally. JIRA summaries reuse the `~/.cache/wts-jira/<KEY>.summary` cache shared with `wt-preview`, on a 3-day TTL, looked up once per key rather than once per repo. Repos are probed in parallel since the `gh pr list` call dominates; `--no-pr` skips the network entirely. Colors and hyperlinks only when stdout is a tty, so the table stays pasteable. Formerly two functions (`rlm-git-repos` was the inventory view); merged, with `rlm-git-repos`/`git-repos` kept as aliases and `-a\|--all` accepted as a no-op. Requires: `git`; optionally `gh` + `jq` (PR column), `acli` (JIRA summaries). |
| `rlm-git-update [-n\|--dry-run] [-b\|--branch <name>] [<directory>]` | `git-update` | Switch every git repo in a directory to the target branch (default `main`) and hard-reset it to `origin/<branch>` — the companion write operation to `rlm-git-status`'s read-only table, for getting a whole multi-repo collection dir back to a clean copy of the remote. Uses the same discovery rule: immediate children of `<directory>` (default cwd) that are their own git worktree root, falling back to the enclosing repo when there are no repo children, so it also works from inside a single worktree at any depth. The target branch is treated as a read-only mirror of the remote, so the destructive parts are fenced: repos with uncommitted changes to *tracked* files are skipped and listed (untracked files do not block, since `reset` leaves them alone); commits present locally but not on origin are listed before being discarded and stay recoverable via `git reflog`; stashes (`refs/stash`) and other branches are never touched; and a branch left behind with no upstream is reported so local-only work stays visible. Each repo is fetched with `--prune` before the reset, because resetting to a stale cached `origin/<branch>` would report success while pinning the repo to an old commit. Per-repo log plus a summary counting updated/skipped/failed, with sections listing anything skipped, stranded without an upstream, or discarded; returns 1 when any repo failed. `--dry-run` reports without changing anything (and performs no fetch, so its discard report is computed against a possibly stale ref). Colors only when stdout is a tty, so the log stays pasteable. Converted from an `update-all-repos.sh` script that only worked in its own directory. Requires: `git`. |
| `rlm-git-squash-branch` | `git-squash-branch` | Squash every commit on the current branch since the merge base with the target branch into one signed-off commit. Target branch = current PR's base (via `gh pr view --json baseRefName`) when there is a PR, otherwise origin's default branch (`git symbolic-ref --short refs/remotes/origin/HEAD`, with `git remote show origin` fallback); always referenced as `origin/<branch>`. Runs `git fetch --all`, saves the messages of all commits in `merge_base..HEAD` in `git merge --squash` shape (oldest first, one `* <subject>` + body per commit), then `git reset <target>` (mixed) + `git add -A` + `git commit -s -e -F -` with the saved messages piped in as the editor's initial buffer. Refuses on dirty working tree, detached HEAD, when on the target branch, when HEAD is already at the target tip, or when reset leaves nothing staged. Prints the `git push --force-with-lease` / `git push -u origin <branch>` commands needed to publish. Requires: `git`; `gh` optional (only used to detect a PR base). |
| `rlm-git-squash-branch-old` | `git-squash-branch-old` | Previous implementation of `rlm-git-squash-branch`, kept for reference. Squashes via `git pull --rebase` + `git push` + `git reset --soft <merge-base>` + `git rebase <default-branch>`, always against origin's default branch (no PR-base detection). See the function source for full behavior. |
| `rlm-gh-browse` | `gh-browse` | Open the current GitHub repo in the browser at the currently checked-out branch (`gh repo view -w -b "$(git branch --show-current)"`). Refuses outside a git repo or on a detached HEAD. Requires: `gh`, `git`. |
| `rlm-gh-fork` | `gh-fork` | Ensure the current GitHub repo is forked under your account and wire up remotes. Resolves the upstream (open source) repo from the checkout (if the checkout is already your fork, its parent is upstream; otherwise the repo itself), checks via `gh` whether a fork exists, and creates one if not. Ends with `upstream` → open source repo and `origin` → your fork, and runs `gh repo set-default <upstream>` so `gh pr create` targets the OSS repo as the PR base (head pushed to your fork). Idempotent; refuses if a same-named non-fork (or fork of a different parent) already exists. Remote-URL protocol follows `gh config get git_protocol`. Requires: `gh`, `git`. |
| `rlm-gh-permalink` | `gh-permalink` | Pick a file from the current git repo via fzf (respecting .gitignore) and open its immutable GitHub permalink (pinned to HEAD SHA) in the browser. |

### Google Cloud / BigQuery

| Function | Short alias | Description |
|---|---|---|
| `rlm-bq-archive` | `bq-archive` | Multi-select BigQuery tables from the bq-open cache via fzf, then per table run three diagnostic queries (recent `INFORMATION_SCHEMA.JOBS` referencing the table, `bq_log.cloudaudit_googleapis_com_data_access` hits excluding `$BQ_ARCHIVE_IGNORED_PRINCIPALS`, and `TABLES`/`TABLE_STORAGE` freshness). Prints a confirmation summary table (rows, logical size, `storage_last_modified_time`) and pre-probes every destination, listing any that already exist and excluding them, before the typed `yes`. Copies each remaining table to `${BQ_ARCHIVE_TARGET:-<src_project>.archival_data}` with `bq cp --no-clobber`, then verifies with `SELECT COUNT(*)` on both sides (plus an advisory `TABLE_STORAGE` byte comparison). Only tables whose counts match are then offered for deletion — one prompt each, confirmed by typing the table name, running `bq rm --force --table` immediately. Selected **views** (VIEW / MATERIALIZED_VIEW) cannot be archived — a view stores no data — so they skip diagnostics and copy entirely and are offered for deletion at the end instead, each with its SQL definition printed inline (via `bq show --view`/`--materialized_view`) so you can save it before confirming; a views-only selection goes straight to those prompts. Undeleted sources still get `DROP TABLE`/`bq rm` instructions plus downstream-lookup queries written to `${TMPDIR}/bq-archive-drop-<ts>.sql`. Reuses the `~/.cache/bq-open/` cache so `bq-open` must have been run at least once. Env: `BQ_SEARCH_PATH` (required), `BQ_ARCHIVE_QUERY_PROJECT`, `BQ_ARCHIVE_TARGET`, `BQ_ARCHIVE_LOOKBACK_DAYS` (default 7), `BQ_ARCHIVE_IGNORED_PRINCIPALS`. Requires `bq`, `fzf`, `jq`. |
| `rlm-bq-open` | `bq-open` | Browse BigQuery tables across projects via fzf and open the selected table(s) in the GCP console. TAB multi-selects (Enter opens all). Projects are read from `$BQ_SEARCH_PATH` (colon-separated). Table list is cached in `~/.cache/bq-open/`; select `--- REFRESH CACHE ---` in the picker to re-fetch. Prints the kind-tagged fqn (e.g. `TABLE: proj.dataset.table` / `VIEW: …`) and the URL per table, copies all selected tables to the clipboard as a multi-format payload (rich text/HTML hyperlinks + Markdown links), and opens each in the browser. Requires `bq`, `fzf`, `jq`. |
| `rlm-sandbox-bq-open` | `sandbox-bq-open` | Browse BigQuery tables in `storytel-data-platform-dev` restricted to `ecerulm*` datasets via fzf and open the selected table in the GCP console. Table list is cached in `~/.cache/sandbox-bq-open/`; select `--- REFRESH CACHE ---` to re-fetch. Prints the URL, copies it to the clipboard, and opens it in the browser. Requires `bq`, `fzf`, `jq`. |
| `rlm-sandbox-bq-rm` | `sandbox-bq-rm` | Multi-select BigQuery tables in the sandbox project/datasets via fzf and permanently delete them. Shares the table-list cache with `sandbox-bq-open`. Prompts for confirmation before deletion; invalidates the cache on success. Requires `bq`, `fzf`, `jq`. |
| `rlm-gar-open` | `gar-open` | Browse all container images across one or more GCP projects via fzf and open the selected image in the Artifact Registry console. Projects are read from `$GAR_SEARCH_PROJECTS` (colon-separated, shared with `gar-search`); Artifact Registry locations from `$GAR_SEARCH_LOCATIONS` (default `europe:europe-west1`) — repos are listed per location, so a location missing there is invisible. Image list is cached in `~/.cache/gar-images/`; selecting `--- REFRESH CACHE ---` opens a secondary fzf picker (with an `*** ALL PROJECTS ***` sentinel) where you TAB-multi-select which projects to re-fetch — entries for un-picked projects are preserved. Picker is MRU-sorted. Prints the fully qualified image path and the GCP console URL, copies the URL to the clipboard, and opens it in the browser. GCR layer-cache pseudo-packages (`<image>/cache`) are filtered out. Requires `gcloud`, `fzf`, `jq`, `curl`, `python3`. |
| `rlm-gar-rm` | `gar-rm` | Multi-select Artifact Registry `<repo>/<package>` entries via fzf and permanently delete them. Shares the package-list cache with `gar-open` (`~/.cache/gar-open/`), including the `--- REFRESH CACHE ---` partial-refresh picker. **Sorted least-recently-pushed first**, with the time since the last image push in the left column (`today`, `6d`, `351d`, `1y19d`), so stale packages surface at the top; unlike `gar-open` it ignores the shared MRU history, since a recently-picked package is the opposite of stale. The age is the **newest version's** `updateTime`, fetched per package on a cache refresh — not the package-level `updateTime`, which also moves on metadata writes and registry housekeeping and so can make a year-dead package report a recent date; entries cached before ages were recorded show `unknown` and sort first until the next refresh. The preview is deletion-oriented: version count **broken down into tagged / untagged index / index members / unreferenced** — only the last is safe to remove, and a flat untagged count badly overstates it (68 of 74 untagged versions on `catalogue_export` were live index members) — plus total size, newest/oldest version dates, tag count, package create/update time and annotations, and the number of 1000-version delete batches required. Everything it shows is served from cache — the version listing (shared with `gar-version-rm`, written by whichever runs first), the access token (via `gcloud-token-cached`, 120s) and the package metadata (1h) — taking a keystroke from ~2.8s to ~0.49s with no network calls; the listing's age is printed beside the count so a stale number is never mistaken for a live one. The member-vs-orphan split is **read** from that cache and never fetched (one registry GET per index is far too slow for a pane that re-runs per keystroke); when the cache is absent or predates a newly-pushed index, the untagged versions are reported as unresolved rather than guessed as orphans. an auth or permission failure is reported loudly rather than rendering as an empty package. Deletes via a single `gcloud artifacts packages delete` (which removes the package and all its versions and tags server-side and waits for the operation), printing the exact gcloud command lines before the per-package confirmation. A single call tops out around 1000 versions, so on a partial delete it reports how many were removed and how many remain and prompts to continue rather than retrying on its own; an attempt that deletes nothing stops with an explanation. Successfully deleted entries are pruned from the cache and history. `-n`/`--dry-run` shows everything and runs nothing. Requires `gcloud`, `fzf`, `jq`, `curl`, `python3`. |
| `rlm-gar-version-rm` | `gar-version-rm` | Delete individual **versions** inside a single package (where `gar-rm` deletes whole packages). Two pickers: pick one `<repo>/<package>` using the shared gar-\* package picker, then TAB-multi-select versions inside it (`ctrl-a`/`ctrl-d` select/deselect all *matched* rows, `ctrl-t`/`ctrl-e` jump to first/last, `?` shows the full key list in the preview pane — fzf's own `alt-<`/`alt->` are unusable here, as the terminal sends a bare Escape that fzf reads as abort, bouncing back to the package picker). Versions list oldest-first (the old builds are the point of a delete tool; undated versions lead) with date, size, short digest and tags (untagged dimmed); the preview leads with the repository's active DELETE **cleanup policies** (a repo that prunes on a timer will delete versions out from under a manual selection), then shows the image name, every tag on the digest, the full SHA, size, media type (flagging multi-arch indexes), upload/update/create/build times, platform and other scalar metadata, and warns when a digest carries several tags since deleting it removes them all. **Multi-arch members are attributed to their index**: the per-arch images behind a tag are listed by the registry as plain untagged versions with no link to the index referencing them, so each index is resolved to its members and the picker renders them as `└─ linux/arm64 of pr-3765`, grouped under their parent and kept contiguous (buildx attestation manifests report no platform and are labelled `attestation`; an index with no tag of its own shows `(untagged index, N arch)` since deleting it strands its members). The preview names the relationship both ways. Only versions that are neither tagged nor referenced show as a bare `(untagged)`. **Cached per package** under `~/.cache/gar-version/<hash>/`: the listing has a 10-minute TTL, the attribution is kept indefinitely because a digest names an immutable manifest, so only newly-pushed indexes are fetched — a cold 205-version/41-index package takes ~3s and reopening it ~0.2s, with no API calls while scrolling. Detects and repairs a child map pruned out of step with the resolved-index record; drops the listing and purges deleted digests after a delete. The version picker's first row is a `--- REFRESH VERSIONS (cached <age>) ---` sentinel that reloads the listing for the same package and reopens, so a stale list needn't mean aborting and re-running; already-resolved indexes are reused. `-r`/`--refresh` bypasses the TTL. **Deletes parents before children** — the registry refuses to remove a manifest a live index still references, and picker order breaks for nested indexes (a grandchild can render as an earlier family than its grandparent), so the selection is depth-sorted; members whose index is *not* selected are listed before the confirmation, since ordering can't help those — with **every** index still referencing them named, as a digest can belong to several. Other refusals are reported too: a repo with immutable tags won't delete a *tagged* version (the count of tagged picks is shown), and `REMOTE`/`VIRTUAL` repos own nothing deletable. (`validateOnly` is no help here — it returns success for a known-refused member, so the checks are computed locally.) Prints the exact API call, confirms once, then deletes via `versions:batchDelete` in chunks of 75 (the server-enforced cap), polling each operation to completion — **there is no gcloud equivalent**: `gcloud artifacts versions delete` takes a single VERSION and dies with `unrecognized arguments:` on a list (same on alpha/beta), so the old batched-gcloud call deleted nothing. A clean API return isn't proof either (it 200s for names that don't exist), so it re-lists and verifies each digest, offering a retry for any that remain. **batchDelete is all-or-nothing per chunk** — one name that no longer exists aborts the request and every valid digest in it survives, and the API won't say which name was missing (`metadata.failedVersions` is populated only when *every* name is bad, empty for the mixed batch that needs it) — so the selection is re-listed immediately before the confirmation with already-gone digests dropped, and a chunk that still fails is retried one name at a time so the valid digests land and each failure is named. Selecting every version leaves an empty package behind — flagged before confirming, with a pointer to `gar-rm`. **Returns to the package picker after each package** so several can be pruned in one sitting; aborting the *package* picker is what exits, while aborting the version picker or declining the confirmation goes back one step (`--refresh` applies to the first package only). **Versions tagged `*latest*` are excluded from the selection** (a floating release tag is what a deployment resolves) — marked `[protected]` in the picker and reported with their refs; the match is *contains*, not prefix, because this repo's `keep-tagged` policy guards `dbt-1.11-latest` and friends too. `-f`/`--force` re-admits them behind a gate that requires typing the exact `<repo>/<package>:<tag>`. `-n`/`--dry-run` shows everything and runs nothing. Requires `gcloud`, `fzf`, `jq`, `curl`, `python3`. |
| `rlm-gar-search NEEDLE` | `gar-search` | Search all DOCKER repositories in one or more GCP projects for image names matching `NEEDLE` (substring). Uses the Artifact Registry `packages.list` REST endpoint with server-side AIP-160 filtering (one API call per repo, not per page), and covers `*.gcr.io` compatibility repos that Cloud Asset Inventory does not index. Projects come from `-p PROJECT` or `$GAR_SEARCH_PROJECTS` (colon-separated); one of the two is required. Prints each match as a fully qualified `LOCATION-docker.pkg.dev/PROJECT/REPO/PACKAGE` path followed by a blue OSC 8 hyperlink `(GCP console)` to the package's Artifact Registry console page. GCR layer-cache pseudo-packages (`<image>/cache`) are filtered out. Requires `gcloud`, `jq`, `curl`, `python3`. |
| `rlm-gcloud-venv` | `gcloud-venv` | Create (or verify) the dedicated Python venv that the Google Cloud SDK runs on, at `~/.local/gcloud-venv`. `.zshenv` exports `CLOUDSDK_PYTHON` / `CLOUDSDK_PYTHON_SITEPACKAGES=1` only when that venv exists, so this is the bootstrap step on a fresh machine — it is deliberately not run from `.zshenv`, which is sourced by every non-interactive shell. Pinning matters because without `CLOUDSDK_PYTHON` gcloud runs its own `order_python()` search over `$PATH`, so with pyenv installed the interpreter drifts with the cwd's `.python-version`. Built from `/usr/local/bin/python3.13` with `grpcio` and `google-cloud-logging`. Idempotent: an existing venv has its packages checked with `pip show` and only missing ones installed. `-f`/`--force` recreates from scratch. Requires `/usr/local/bin/python3.13`. |
| `rlm-gcp-project-open` | `gcp-project-open` | Browse all accessible GCP projects via fzf and open the selected project in the GCP console. Project list is cached in `~/.cache/gcp-project-open/`; select `--- REFRESH CACHE ---` to re-fetch. Prints the URL, copies it to the clipboard, and opens it in the browser. Requires `gcloud`, `fzf`. |
| `rlm-glogin` | `glogin` | Ensure valid gcloud Application Default Credentials (ADC). Checks whether the stored ADC can still mint an access token (`gcloud auth application-default print-access-token`); if they are missing/expired/revoked, runs an interactive `gcloud auth login --enable-gdrive-access --update-adc` so the refreshed credentials also carry the Google Drive scope. Prints a notice and exits without prompting when ADC are still valid. `-f`/`--force` re-authenticates unconditionally. Requires `gcloud`. |
| `rlm-pubsub-open` | `pubsub-open` | Browse Pub/Sub topics **and** subscriptions across one or more GCP projects via fzf and open the selected resource(s) in the GCP console. The picker is multi-select — TAB toggles entries and Enter opens every selected topic/subscription at once. Projects are read from `$PUBSUB_OPEN_PROJECTS` (colon-separated). Each row shows the type (`topic`, `pull`, `push`, `bigquery`, `cloudstorage`) alongside `project/name`, so filtering by type (e.g. type `bigquery` to see only BigQuery subscriptions) works out of the box. List is cached in `~/.cache/pubsub-open/`; selecting `--- REFRESH CACHE ---` opens a second fzf picker (with an `*** ALL PROJECTS ***` sentinel) where you TAB-multi-select which projects to re-fetch — entries for un-picked projects are preserved. Preview pane (via `~/bin/pubsub-preview`) shows kind-specific details: topic schema + subscriptions for topics, or the attached topic + delivery config (BQ table, GCS bucket, push endpoint) for subscriptions — all relevant values are OSC 8 hyperlinks to the GCP console. Prints each URL, opens them all in the browser, and copies them to the clipboard as a **multi-format payload** (via an inline Swift `NSPasteboard` helper on macOS): RTF + HTML carry the `project/name` labels hyperlinked to their console URLs, while the plain-text and `public.markdown` flavors hold Markdown links (`[project/name](url)`) — so a rich editor pastes clickable links and a plain editor pastes Markdown. Falls back to plain Markdown via `pbcopy` (no `swift`) / `xclip`/`xsel` (Linux). Requires `gcloud`, `fzf`, `jq`; optional `swift` for the rich copy. |
| `rlm-afw-deploy` | `afw-deploy` | Deploy one or more DAGs to the dev Airflow sandbox. Can be invoked from anywhere inside the project — walks up from `$PWD` to find the project root (containing `airflow_manager/` and `pyproject.toml`) and `cd`s there. Opens a multi-select fzf picker over `*.py` files in `airflow_manager/dag_folder/` (tab to tag, ctrl-a/ctrl-d select/deselect all); all tagged DAGs are deployed in one `afw` invocation (`-d` per DAG). Last selection is cached per project root in `~/.cache/afw-deploy/`. Verifies `afw` resolves to the project's uv venv (via the `_rlm-uv-ensure-venv` helper); auto-runs `uv sync` if not. Lets `afw` resolve the Composer bucket itself (no hardcoded `-b`). After deploying, waits until Composer has actually re-parsed the new code (via `_rlm-afw-wait-parsed`) so the command returns when the DAG is live, not when the upload finished; `AFW_NO_WAIT=1` skips it, `AFW_WAIT_TIMEOUT`/`AFW_WAIT_INTERVAL` tune it. Requires `uv`, `fd`, `fzf`, plus `gcloud`/`curl`/`jq` for the wait. |
| `rlm-dbt <subcmd> [args...]` | `dbt` | Generic dbt dispatcher. If `rlm-dbt-<subcmd>` exists as a function or alias, delegates to it (passing any remaining args through) — `dbt run` opens the `rlm-dbt-run` picker, `dbt run -s tag:foo` forwards the args. Otherwise invokes plain dbt via `_rlm-dbt-bin` (respects `DBT_USE_FUSION`), auto-injecting `--project-dir` (nearest `dbt_project.yml` walking up from `$PWD`) and `--profiles-dir` (from `$DBT_PROFILES_DIR` if set), unless either is already in the args. Example: `dbt parse`, `dbt deps`, `dbt debug`. |
| `rlm-dbt-ls [SELECTOR]` | `dbt-ls` | Run `dbt ls` via uv or poetry (auto-detected from `uv.lock`) and browse the results in an fzf multi-select picker. Finds `dbt_profiles.yml` automatically (up to 4 dirs deep) and uses its directory as `--profiles-dir`; profile is `local_dev`. After fzf exits without a selection, prompts to edit the selector and retry. The picker's top rows include a `--- REFRESH NODES CACHE ---` entry and a `--- CUSTOM SELECT ---` entry (picking the latter opens an empty prompt to type a free-form selector from scratch). Prints selected model names to stdout. Verifies `dbt` resolves to the project's poetry venv (via the `_rlm-poetry-ensure-venv` helper); auto-runs `poetry install` if not. Requires `poetry`, `fzf`. |
| `rlm-dbt-run [-s SELECTOR] [-n]` | `dbt-run` | Run a dbt model locally with `--defer` against a production ref-state manifest. Omit `-s` for an fzf picker over all models (recently used first); the picker's top rows include a `--- REFRESH NODES CACHE ---` entry and a `--- CUSTOM SELECT ---` entry (picking the latter opens an empty prompt to type a free-form selector from scratch). `-n` shows a dry-run list of which nodes build locally vs. are deferred from prod. Estimates query cost before running. Verifies `dbt` resolves to the project's poetry venv (via the `_rlm-poetry-ensure-venv` helper); auto-runs `poetry install` if not. Configured entirely via env vars (`DBT_STATE_DIR`, `DBT_PROJECT_SUBDIR`, `DBT_TARGET`, `DBT_DEV_PROJECT`, `DBT_DATASET_PREFIX`) — set these in `~/.zshrc.thismachine`. Requires `poetry`, `bq`, `fzf`, `python3`. |
| `rlm-dbt-build [-s SELECTOR] [-n]` | `dbt-build` | Like `dbt-run` but runs `dbt build` (models, seeds, tests, snapshots). The fzf picker covers both models and seeds. Shares the deferred-state, history, cost-estimate, `-n` list-only behaviour, `--- REFRESH NODES CACHE ---` / `--- CUSTOM SELECT ---` picker rows, and poetry-venv check with `dbt-run`; both wrappers delegate to the `_rlm-dbt-cmd` helper. Same env vars as `dbt-run`. |
| `rlm-dbt-find-source-code` | `dbt-find-source-code` | fzf picker over every resource in the current dbt project (model, seed, test, snapshot, source, analysis, exposure). Entries render as `<resource_type>:<short_name>` (e.g. `source:storytel_order_service.state`, `model:dim_customer_demographics_latest`) so typing `source:` or `model:` narrows by type. Reads from the shared per-project nodes cache at `~/.cache/rlm-dbt/<project_key>/nodes.json` populated by all `rlm-dbt-*` commands; MRU-sorted via the shared pooled history. Preview pane renders the source file (`bat` if installed, else `cat`). On confirmation, prints the absolute path to stdout, copies it to the clipboard, and opens `$EDITOR` on the file. The first picker entry is `--- REFRESH CACHE (cached ...) ---`. Requires `fzf`, `jq`, `poetry` (or `dbtf` when `DBT_USE_FUSION=1`), and `$EDITOR` set. Optional: `bat`, `pbcopy`/`xclip`/`xsel`. |
| `rlm-dbt-test [-s SELECTOR] [-n]` | `dbt-test` | Like `dbt-run` but runs `dbt test` — executes the schema and data tests attached to the selected model (or selector) while reading upstream models from prod via `--defer`. The fzf picker shows models (pick a model, run its tests). The cost estimate covers the test queries themselves (since tests are what scan data during `dbt test`), not the models. Shares the deferred-state, history, `-n` list-only behaviour, `--- REFRESH NODES CACHE ---` / `--- CUSTOM SELECT ---` picker rows, and poetry-venv check with `dbt-run` / `dbt-build`; all three wrappers delegate to the `_rlm-dbt-cmd` helper. Same env vars as `dbt-run`. |
| `rlm-dbt-sandbox` | `dbt-sandbox` | Create personal dbt sandbox BigQuery datasets in `$DBT_DEV_PROJECT`. For each layer L in `$DBT_SANDBOX_LAYERS` (colon-separated, e.g. `prep:psa:dw:rd`), creates dataset `<DBT_DATASET_PREFIX>_<L>` in the **EU** multi-region with label `sandbox:true` and a 30-day default table expiration. Idempotent — skips datasets that already exist in EU. If a dataset exists in a non-EU location, interactively prompts whether to delete and recreate it in EU (skips when stdin is not a TTY). Refuses to run if `$DBT_DEV_PROJECT` ends in `-prod`. Configure all three env vars in `~/.zshrc.thismachine`. Requires `bq`. |

### Python

| Function | Short alias | Description |
|---|---|---|
| `rlm-pyactivate [version]` | `pyactivate` | Activate a Python environment by name. Uses `uv` if available, falls back to `pyenv`. Without an argument reads the version from `.python-version`. Defines a `deactivate` function to restore `PATH`. |
| `rlm-pyclean` | `pyclean` | Delete all `*.pyc` / `*.pyo` files and `__pycache__` directories under the current directory. |

### Terraform

| Function | Short alias | Description |
|---|---|---|
| `rlm-tfapply [args...]` | `tfapply` | Apply the saved `latest.tfplan` written by `tfplan`, so the applied changes are the reviewed ones. Errors out if `terraform` is missing or the plan file is absent, and warns (without blocking) when a `*.tf` / `*.tf.json` file is newer than the plan. Extra arguments are forwarded to `terraform apply` before the plan file; override the plan filename with `$TFPLAN_FILE`. Function form of the `ta` alias. Requires `terraform`. |
| `rlm-tfplan [args...]` | `tfplan` | Run `terraform plan -out latest.tfplan` in the current directory and print the matching `terraform apply <plan-file>` command. Errors out early if `terraform` is missing or the directory holds no `*.tf` / `*.tf.json` files. Extra arguments are forwarded to `terraform plan` (`-target=`, `-var-file=`, …); override the output filename with `$TFPLAN_FILE`. Function form of the `tp` alias. Requires `terraform`. |

### Passwords / Security

| Function | Short alias | Description |
|---|---|---|
| `rlm-mkpw [length]` | `mkpw` | Generate an alphanumeric password. Default length is 14 characters. |
| `rlm-randompassword` | `randompassword` | Generate a 20-character password using alphanumeric chars plus `#`, `.`, `-`. |

### Shell / Command Discovery

| Function | Short alias | Description |
|---|---|---|
| `rlm-fcmd [query]` | `fcmd` | Fuzzy-pick any zsh alias, function, builtin, reserved word, or `$PATH` command. Preview pane shows the full alias expansion or function body. On selection, pushes the name onto the command line for editing. Requires `fzf`. |
| `rlm-fe` | `fe` | Fuzzy-pick one or more files reachable from the current directory (recursive; includes hidden and gitignored files, excludes `.git/`) via fzf and open them in `$EDITOR`. Tab marks files for multi-select. Entries form one timeline sorted newest-first, shown as a humanized age ("2 hours ago") in the first column. A file's change time is its **fs mtime when git reports it dirty/untracked**, else its **git commit time** (in a fresh clone every mtime is just the checkout timestamp, so mtime alone sorts nothing); that is then taken against the MRU pick time, so opening a file floats it to the top and it decays from there. The MRU cache stores full absolute paths (`~/.cache/rlm-fe/`), so a file keeps its recency regardless of which directory `fe` is run from. Preview (`bin/fe-preview`) shows path, a GitHub permalink to the file (pinned to its last-touching commit, only when that commit is on a remote branch), mtime (tagged `[dirty]`/`[untracked]`), last commit + author, the PR as a clickable link, and the contents. Requires: `fd`, `fzf`, `python3`; optional `git`, `gh`, `bat`. |
| `rlm-urldecode [url]` | `urldecode` | Break a URL into its components and percent-decode its query string, printing one `key = value` line per query parameter. Reads from `$1` or stdin. Requires `python3`. |
| `rlm-tsconv NUMBER` | `tsconv` | Convert a numeric input to a date/time, auto-detecting both the base (decimal, `0x`/`0o`/`0b`, or bare hex when digits contain `a-f`) and the magnitude (seconds / milliseconds / microseconds / nanoseconds since the Unix epoch). Prints decimal, hex, inferred unit, local time, UTC, and humanized delta. Reads from `$1` or stdin. Requires `python3`. |

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
| `rlm-wts` | `wts` | Switch into a git worktree via fzf. Strips common path prefixes for readability, annotates worktrees whose branch contains a JIRA key with `(Status) Summary` fetched from JIRA (cached in `~/.cache/wts-jira/`), and previews via `wt-preview`. Outside a repo, in a multi-repo base dir (e.g. `~/git/work/StorytelDataPlatform`) **or in any collection dir of that family** (e.g. `…/StorytelDataPlatform_20260729_DATA-2772-bigquery-import-lazy`), instead lists the whole family — the base dir plus its `<stem>_*` collections created by `rlm-pr-worktree`'s multi-repo mode, where `<stem>` is the dirname truncated at the first `_`. The current dir is flagged `<- here`. Each is previewed with its JIRA summary and a per-repo change roll-up (`wt-collection-preview`). |
| `rlm-pre-commit-pr [base]` | `pre-commit-pr`, `pcpr` | Run `pre-commit` on files changed in the current branch since its fork point from `base` (default: `main`). |
| `rlm-lhdir [hook]` | `lhdir`, `lhd` | Run lefthook on every tracked/non-ignored file under the current directory. Defaults to the `pre-commit` hook. |
| `rlm-awsprofile` | `awsprofile` | Pick an AWS profile via fzf and export it as `AWS_PROFILE`. |
| `rlm-pr-checkout [PR]` | `pr-checkout` | Pick one of the current repo's **open** PRs via fzf and switch to its branch in place (merged/closed are excluded; drafts count as open). Rows: `#NUM STATE CHECKS REVIEW AUTHOR TITLE`, with rows you authored in green — same convention as `pr-worktree`'s picker; preview is `gh pr view`. A branch can only be checked out in one worktree at a time, so PRs whose branch another worktree already holds are annotated `(wt: <dirname>)` and selecting one **cds into that worktree** instead of failing with git's "already used by worktree" error (the worktree you are standing in is never annotated — that is a no-op, not a conflict). Most open PRs have no local branch yet, so it defers to `gh pr checkout` (creates the branch, sets tracking, handles forks); an existing local branch is a plain `git switch`. Pass a PR number to skip the picker. Inline because it must `cd` the calling shell. Fills the gap between `switchbranch` (local branches, no PR context) and `pr-worktree` (picks a PR but makes a *new* worktree). |
| `rlm-cd-sub [fd-args...]` | `cd-sub`, `cds` | Pick a subdirectory under the current directory via fzf and `cd` into it. Useful when zoxide's `zi` won't help because the target dir has never been visited. Enumerates with `fd -t d`; extra args are passed through to `fd`. Requires: `fd`, `fzf`. |
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

zoxide's interactive picker (`zi`) is configured via `_ZO_FZF_OPTS` in `.zshrc` so it
matches the other fzf pickers here — `--no-mouse` (terminal keeps selection/copy and
clickable links), `--ansi`, and `Ctrl-G` to abort.

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
