_default:
    @just --list --unsorted

# Run the same checks as .forgejo/workflows/ci.yml
ci: check

# Pull charts from upstream into charts/ (all if no name given)
vendor name='--all':
    helm-vendor vendor {{name}}

# Verify vendored charts match upstream (all if no name given)
check name='--all':
    helm-vendor check {{name}}

# Update a chart's pinned version in charts.toml
update name version:
    helm-vendor update {{name}} {{version}}

# List all charts and their versions
list:
    helm-vendor list
