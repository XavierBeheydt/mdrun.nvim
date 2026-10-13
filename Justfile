# Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

# just — task runner for mdrun.nvim
# Usage: just <recipe>   (run `just` with no args to list recipes)
set shell := ["bash", "-u", "-o", "pipefail", "-c"]

TESTS_INIT := "tests/minimal_init.lua"
TESTS_DIR := "tests/"
ROCKSPEC := "mdrun.nvim-scm-1.rockspec"

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

# Lint the rockspec and install it into a throwaway tree (needs luarocks)
rockspec:
    luarocks lint {{ROCKSPEC}}
    tree=$(mktemp -d) && trap 'rm -rf "$tree"' EXIT && luarocks --tree "$tree" make {{ROCKSPEC}}

# CI in one shot
check: fmt lint rockspec test

# Record the demo by hand; quit nvim to stop (needs asciinema)
demo-rec:
    asciinema rec --overwrite demo/demo.rec -c 'nvim --clean -n --cmd "set rtp+=." -c "runtime plugin/mdrun.lua" -c "set ft=markdown" demo/demo.md'

# Render the demo GIF from the recording (needs agg)
demo:
    agg demo/demo.rec demo/demo.gif
