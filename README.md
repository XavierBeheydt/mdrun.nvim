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

The `main` branch always holds the latest release. Releases are git tags named
`vX.Y.Z` (see the [tags](https://github.com/XavierBeheydt/mdrun.nvim/tags)).
Each manager below can pin one, shown after its install snippet: replace
`v0.1.0` with the tag you want.

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

To pin a release, check out its tag (`git checkout main` goes back to the
latest):

```sh
git -C ~/.local/share/nvim/site/pack/plugins/start/mdrun.nvim checkout v0.1.0
```

### vim.pack (Neovim 0.12+)

```lua
vim.pack.add({
  {
    src = "https://github.com/XavierBeheydt/mdrun.nvim",
    version = vim.version.range("*"), -- latest release
  },
})
```

To pin a release, set `version` to its tag, or to a range such as
`vim.version.range("^0.1")` for the 0.1.x releases:

```lua
vim.pack.add({
  { src = "https://github.com/XavierBeheydt/mdrun.nvim", version = "v0.1.0" },
})
```

### lazy.nvim

```lua
{
  "XavierBeheydt/mdrun.nvim",
  version = "*", -- latest release
}
```

To pin a release, use `tag`, or a semver range such as `version = "^0.1"` for
the 0.1.x releases:

```lua
{
  "XavierBeheydt/mdrun.nvim",
  tag = "v0.1.0",
}
```

### rocks.nvim

```vim
:Rocks install mdrun.nvim
```

To pin a release, add its version, which is the tag without the `v`:

```vim
:Rocks install mdrun.nvim 0.1.0
```

### mini.deps

```lua
MiniDeps.add({ source = "XavierBeheydt/mdrun.nvim" })
```

To pin a release, set `checkout` to its tag:

```lua
MiniDeps.add({ source = "XavierBeheydt/mdrun.nvim", checkout = "v0.1.0" })
```

### vim-plug

```vim
call plug#begin()
Plug 'XavierBeheydt/mdrun.nvim'
call plug#end()
```

Then run `:PlugInstall`. To pin a release, set `tag`:

```vim
Plug 'XavierBeheydt/mdrun.nvim', { 'tag': 'v0.1.0' }
```

### paq-nvim

```lua
require("paq")({
  "XavierBeheydt/mdrun.nvim",
})
```

Then run `:PaqInstall`. paq-nvim has no `tag` option, it only follows a
branch. To pin a release, check its tag out by hand and pin the package so
updates leave it alone:

```sh
git -C ~/.local/share/nvim/site/pack/paqs/start/mdrun.nvim checkout v0.1.0
```

```lua
require("paq")({
  { "XavierBeheydt/mdrun.nvim", pin = true },
})
```

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

