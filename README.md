# mdrun.nvim

<!-- panvimdoc-ignore-start -->

[![CI](https://github.com/XavierBeheydt/mdrun.nvim/actions/workflows/lint-test.yml/badge.svg)](https://github.com/XavierBeheydt/mdrun.nvim/actions/workflows/lint-test.yml)
[![Version](https://img.shields.io/github/v/tag/XavierBeheydt/mdrun.nvim?sort=semver&label=version)](https://github.com/XavierBeheydt/mdrun.nvim/tags)
[![LuaRocks](https://img.shields.io/luarocks/v/xavierbeheydt/mdrun.nvim?logo=lua&color=purple)](https://luarocks.org/modules/xavierbeheydt/mdrun.nvim)
[![Neovim](https://img.shields.io/github/v/release/neovim/neovim?display_name=tag&label=Neovim%20tested&logo=neovim&logoColor=white&color=57A143)](https://github.com/neovim/neovim/releases)

<!-- panvimdoc-ignore-end -->

Lua Neovim plugin: run instructions inside fenced code blocks of
Markdown files.

<!-- markdownlint-disable MD036 -->

<!-- panvimdoc-ignore-start -->

## Installing

### Native packages

Neovim loads every plugin found in a `pack/*/start/` directory of its
`packpath` (see `:help packages`):

```sh
git clone https://github.com/XavierBeheydt/mdrun.nvim \
  ~/.local/share/nvim/site/pack/plugins/start/mdrun.nvim
```

Run `:helptags ALL` once to index the help. On Windows the same layout lives
under `$env:LOCALAPPDATA\nvim-data\site`. Clone into `pack/plugins/opt/`
instead and run `:packadd mdrun.nvim` to load the plugin on demand.

### vim.pack (Neovim 0.12+)

```lua
vim.pack.add({
  {
    src = "https://github.com/XavierBeheydt/mdrun.nvim",
    version = vim.version.range("*"), -- latest release
  },
})
```

### lazy.nvim

```lua
{
  "XavierBeheydt/mdrun.nvim",
  version = "*", -- latest release
}
```

### rocks.nvim

```vim
:Rocks install mdrun.nvim
```

### mini.deps

```lua
MiniDeps.add({ source = "XavierBeheydt/mdrun.nvim" })
```

### vim-plug

```vim
call plug#begin()
Plug 'XavierBeheydt/mdrun.nvim'
call plug#end()
```

Then run `:PlugInstall`.

### paq-nvim

```lua
require("paq")({
  "XavierBeheydt/mdrun.nvim",
})
```

Then run `:PaqInstall`.

<!-- panvimdoc-ignore-end -->

## Usage

<!-- TODO -->

## Development

Tasks are driven by [just](https://github.com/casey/just) — run `just` to
list them:

- `just test` — run the test suite (plenary + busted, headless nvim)
- `just lint` — check formatting (stylua)
- `just fmt` — format in place
- `just check` — lint + test (what CI runs)

