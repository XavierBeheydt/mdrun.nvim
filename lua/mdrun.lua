-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

---@class MDRun
local M = {}

---@class Config
---@field split_size number fraction of the editor area used by the runner's terminal

---@type Config
M.config = {
    split_size = 0.35,
}

---@param args Config?
function M.setup(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

---@class Context
---@field line1 number first line of the command range (1-based)
---@field line2 number last line of the command range (1-based, inclusive)
---@field line_count number number of lines in the buffer

---Run the fenced code block in a split below the current window (:split).
---@param ctx Context
function M.split(ctx)
    vim.notify(vim.inspect(ctx), vim.log.levels.DEBUG)
end

---Run the fenced code block in a vertical split beside the current window (:vsplit).
---@param ctx Context
function M.vsplit(ctx)
    vim.notify(vim.inspect(ctx), vim.log.levels.DEBUG)
end

return M
