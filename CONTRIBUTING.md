<!--
Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>
-->

# Contributing

Tasks are driven by [just](https://github.com/casey/just) — run `just` to
list them:

- `just test` — run the test suite (plenary + busted, headless nvim)
- `just lint` — check formatting (stylua)
- `just fmt` — format in place
- `just rockspec` — lint the rockspec and test-install it (needs luarocks)
- `just check` — lint + test (what CI runs)

## Trying the plugin from a checkout

Start Neovim with the working tree on the `runtimepath`, without installing
anything (run from the repository root):

```sh
nvim --cmd "set rtp+=." -c "runtime plugin/mdrun.lua" -c "set ft=markdown" test.md
```

Add `--clean` to skip your own config.

Or load it into a running session:

```vim
:set rtp+=/path/to/mdrun.nvim
:runtime plugin/mdrun.lua
:set ft=markdown
```

`:MDRun` and `:VMDRun` are buffer-local and created on the `FileType`
autocmd for `markdown`. Buffers already open when the plugin is sourced do not
have them until the filetype is detected again, hence `:set ft=markdown` (or
`:e`). Check the current filetype with `:set ft?`.

`require` caches modules: after editing the code, drop them from the cache
before requiring the plugin again.

```vim
:lua for k in pairs(package.loaded) do if k:match("^mdrun") then package.loaded[k] = nil end end
```
