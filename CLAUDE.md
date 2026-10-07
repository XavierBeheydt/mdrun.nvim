# AGENTS.md — Instructions for AI agents

## Project

See [README.md](README.md) for the full project description.

**Hard constraint: keep the plugin as light as possible.**

## Plugin organization

Layout modeled on
[ellisonleao/nvim-plugin-template](https://github.com/ellisonleao/nvim-plugin-template),
with `<name>` standing for the plugin name. Scaffold on demand: create a file
or directory only when a change needs it, never as empty placeholders.

```text
.
├── lua/
│   ├── <name>.lua           # public API (the only module users require)
│   └── <name>/
│       └── <module>.lua     # internal submodules, one concern per file
├── plugin/
│   └── <name>.lua           # entry point, sourced by Neovim at startup
├── tests/
│   ├── minimal_init.lua     # headless nvim bootstrap
│   └── <name>/
│       └── <module>_spec.lua
├── doc/
│   └── <name>.txt           # generated from README.md — do not edit by hand
├── .github/
│   └── workflows/           # tests, formatting, vimdocs, release
├── justfile                 # dev tasks (or Makefile): test, lint, fmt, check
├── .stylua.toml
├── .luarc.jsonc             # lua-language-server: runtime, test/nvim globals
├── README.md
└── LICENSE
```

Conventions:

- `lua/<name>/*` is internal; only `lua/<name>.lua` is public API.
- `plugin/<name>.lua` stays minimal (commands, mappings, autocmds) and does
  not `require` plugin modules at load time — defer to first use to keep
  startup cost near zero.
- No runtime dependency beyond Neovim itself; test-only dependencies stay in
  `tests/`.
- Each `lua/<name>/<module>.lua` has a matching
  `tests/<name>/<module>_spec.lua`.

## Code style

- [.stylua.toml](.stylua.toml)
- Comment sparingly and stay concise: no comment that restates the code, no
  verbose docblocks. Comment only the non-obvious *why*.
- Every source file, whatever its language, starts with a copyright header in
  that language's comment syntax, using the current year and the name(s) of
  the person(s) who wrote the code; add a line as others contribute:

  ```text
  Copyright (c) <ACTUAL-YEAR> FirstName Lastname <email>
  ```

## Agent configuration

- `AGENTS.md` (this file) is the single source of truth for agent instructions.
- `CLAUDE.md` is a symlink pointing at it — edit `AGENTS.md`, never `CLAUDE.md`.
- Extra agent assets (subagents, slash commands, tool-specific settings) live in
  `.agents/`, the canonical directory.
- `.claude` is a **committed symlink** to `.agents` (like `CLAUDE.md`), so a
  fresh clone is ready to use by AI agents as-is. Never commit regular files
  under `.claude/` — edit `.agents/` and commit there.

## Git workflow

- Never commit directly on `latest`. Work on another branch (e.g. `dev`, or a
  worktree) and bring changes into `latest` through a merge or a PR.
- Branch worktrees live under `.worktrees/`. Use them per
  feature or fix instead of juggling branches in the main tree.
- Commit messages follow Conventional Commits:
  <https://www.conventionalcommits.org/en/v1.0.0/>. Read that spec when in
  doubt.
- Keep commits small and atomic.
- No AI co-author: commits and PRs carry no `Co-Authored-By` trailer or
  "generated with" line for an AI, unless the user explicitly asks for it.

## Language rules

- All code, Lua comments, documentation, and anything committed to the
  repository are written in **English**, unless the user explicitly asks for
  another language.
- The interactive conversation with the user happens in **the user's own
  language**.

## License

MIT — see [LICENSE](LICENSE).
