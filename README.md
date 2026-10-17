# mdrun.nvim

<!-- panvimdoc-ignore-start -->

[![CI](https://github.com/XavierBeheydt/mdrun.nvim/actions/workflows/lint-test.yml/badge.svg)](https://github.com/XavierBeheydt/mdrun.nvim/actions/workflows/lint-test.yml)
[![Version](https://img.shields.io/github/v/tag/XavierBeheydt/mdrun.nvim?sort=semver&label=version)](https://github.com/XavierBeheydt/mdrun.nvim/tags)
[![LuaRocks](https://img.shields.io/luarocks/v/xavierbeheydt/mdrun.nvim?logo=lua&color=purple)](https://luarocks.org/modules/xavierbeheydt/mdrun.nvim)
[![Neovim](https://img.shields.io/github/v/release/neovim/neovim?display_name=tag&label=Neovim%20tested&logo=neovim&logoColor=white&color=57A143)](https://github.com/neovim/neovim/releases)

<!-- panvimdoc-ignore-end -->

Lua Neovim plugin: run instructions inside fenced code blocks of
Markdown files.

> [!WARNING]
> There is no sandbox: blocks run on your computer. Every run asks for
> confirmation by default, see [Usage](#usage) to change it.

<!-- panvimdoc-ignore-start -->

![Demo: running a code block with :MDRun and :VMDRun](demo/demo.gif)

<!-- panvimdoc-ignore-end -->

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

To pin a release, set `version` to its tag, or to a range:
`vim.version.range("^0.1")` follows the 0.1.x releases and
`vim.version.range("*")` the latest release.

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

To pin a release, use `tag`, or a semver range: `version = "^0.1"` follows the
0.1.x releases and `version = "*"` the latest release.

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

Then run `:PlugInstall`. To pin a release, set `tag` to its tag, or to `'*'`
for the latest release:

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

Put the cursor inside a fenced code block that names a language, then run a
command. The block runs in a terminal window opened by the command:

````markdown
```python
print("hello")
```
````

Requires Neovim 0.11+ and the interpreter of the block in your `PATH`.

### Commands

Both commands are local to Markdown buffers (created on the `markdown`
`FileType`):

| Command   | Terminal opened in                         |
| --------- | ------------------------------------------ |
| `:MDRun`  | a split below the current window           |
| `:VMDRun` | a vertical split beside the current window |

The block is searched upward from the first line of the range, so the cursor
can be on the opening fence or on any line of the body, but not on the closing
fence. Nothing runs, and a warning is shown, when the cursor is outside a
block, when the block is not closed or when its fence has no language.

Every run opens a new terminal window.

> [!WARNING]
> There is no sandbox: blocks run on your computer with your permissions, so a
> destructive command does real damage. By default, every run
> asks for confirmation and shows the code first. The first run of each
> Neovim session also shows a warning about this. Disable the confirmation with
> `confirm = false` in [Setup](#setup).

The plugin sets no mapping. For example:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    vim.keymap.set("n", "<leader>r", "<cmd>MDRun<cr>", { buffer = event.buf })
  end,
})
```

### Languages

The fence language, case-insensitive, picks the interpreter. When several are
listed, the first one found in your `PATH` is used.

| Fence language                       | Interpreter                  |
| ------------------------------------ | ---------------------------- |
| `sh`                                 | `sh -c`                      |
| `bash`, `shell`                      | `bash -c`                    |
| `zsh`                                | `zsh -c`                     |
| `fish`                               | `fish -c`                    |
| `python`, `python3`, `py`            | `python3` or `python` (`-c`) |
| `javascript`, `js`, `node`, `nodejs` | `node` or `nodejs` (`-e`)    |
| `ruby`, `rb`                         | `ruby -e`                    |
| `lua`                                | `lua` or `luajit` (`-e`)     |

The code of the block is passed to the interpreter as its last argument.

### Setup

Calling `setup` is optional: the defaults below apply without it.

```lua
require("mdrun").setup({
  -- Fraction of the editor area taken by the terminal window:
  -- height for :MDRun, width for :VMDRun.
  split_size = 0.35,
  -- Ask for confirmation before running a block. Set to false at your own risk.
  confirm = true,
})
```

<!-- panvimdoc-ignore-start -->

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development tasks and how to try
the plugin from a checkout.

<!-- panvimdoc-ignore-end -->
