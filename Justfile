# Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

# just — task runner for mdrun.nvim
# Usage: just <recipe>   (run `just` with no args to list recipes)
set shell := ["bash", "-u", "-o", "pipefail", "-c"]

TESTS_INIT := "tests/minimal_init.lua"
TESTS_DIR := "tests/"

# List available recipes
[default]
help:
    @just --list

# Run the test suite (plenary + busted inside headless nvim)
test:
    nvim \
        --headless \
        --noplugin \
        -u {{TESTS_INIT}} \
        -c "PlenaryBustedDirectory {{TESTS_DIR}} { minimal_init = '{{TESTS_INIT}}' }" \
        -c "qa!"

# Check formatting (does not modify files)
lint:
    stylua --color always --check .

# Format in place
fmt:
    stylua --color always --glob "**/*.lua" .

# CI in one shot
check: fmt lint test
