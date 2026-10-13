-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

---@diagnostic disable: lowercase-global
-- Template for luarocks-tag-release: it fills in the version and the source tag on `vX.Y.Z`.
rockspec_format = "3.0"
package = "mdrun.nvim"
version = "scm-1"

source = {
    url = "git+https://github.com/XavierBeheydt/mdrun.nvim",
}

description = {
    summary = "Run the fenced code blocks of Markdown files from Neovim.",
    detailed = "Run the fenced code block under the cursor in a terminal split.",
    homepage = "https://github.com/XavierBeheydt/mdrun.nvim",
    license = "MIT",
    labels = { "neovim", "markdown" },
}

dependencies = {
    "lua >= 5.1",
}

build = {
    type = "builtin",
    copy_directories = { "plugin", "doc" },
}
