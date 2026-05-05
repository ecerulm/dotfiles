# Justfile — task runner for this dotfiles repo.
# Run `just` to list available recipes.

# Default recipe: list all recipes.
default:
    @just --list

# Run all lefthook pre-commit checks against staged files.
lint:
    lefthook run pre-commit

# Run all lefthook pre-commit checks against every tracked file.
lint-all:
    lefthook run pre-commit --all-files

# Run a single lefthook command against staged files.
# Usage: just lint-cmd stylua  |  just lint-cmd mdformat  |  just lint-cmd shellcheck
lint-cmd CMD:
    lefthook run pre-commit --command {{CMD}}

# Format-only commands (mutating). Usable outside the commit flow.
fmt-lua:
    stylua .

fmt-md:
    mdformat .

fmt-sh:
    shfmt -w -i 2 -bn -ci -sr $(git ls-files '*.sh')

# Lint-only commands (non-mutating).
check-sh:
    shellcheck --severity=warning $(git ls-files '*.sh')

check-yaml:
    yq eval-all 'true' $(git ls-files '*.yml' '*.yaml') >/dev/null

# Reinstall the lefthook git hook (run after editing lefthook.yml).
hooks-install:
    lefthook install
