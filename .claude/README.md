# .claude — canonical agent assets

This directory is the canonical home for extra AI-agent assets: subagents,
slash commands, tool-specific settings.

- `CLAUDE.md` (repo root) is the single source of truth for instructions.
- `AGENTS.md` (repo root) is a symlink to `CLAUDE.md` — do not edit it.
- Other agents read this directory through the committed symlink
  `.agents -> .claude`. Like `AGENTS.md`, this symlink is part of the repo,
  so a fresh clone is ready to use by any AI agent as-is.

`.claude` must stay a real directory: Claude Code refuses to create worktrees
when it is a symlink. Commit changes here (`.claude/`), never under `.agents/`.
