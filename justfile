_default:
    @just --list --unsorted

# Run the same checks as .forgejo/workflows/ci.yml
ci: check

# Pull charts from upstream into charts/ (all if no name given)
fetch name='--all':
    helm-vendor fetch {{name}}

# Verify vendored charts match upstream (all if no name given)
check name='--all':
    helm-vendor check {{name}}

# Show charts whose pinned version is older than upstream
outdated:
    helm-vendor outdated

# Update a chart's pinned version in charts.toml
update name version:
    helm-vendor update {{name}} {{version}}

# Bump every chart in charts.toml to its latest upstream version
update-all:
    helm-vendor update --all --latest

# List all charts and their versions (pass --check to query upstream)
list *flags:
    helm-vendor list {{flags}}
