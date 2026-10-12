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

---Run the fenced code block in a split below the current window (:split).
---@param range table line1 and line2 of the block (1-based, inclusive)
function M.split(range)
    vim.notify(vim.inspect(range), vim.log.levels.DEBUG)
end

---Run the fenced code block in a vertical split beside the current window (:vsplit).
---@param range table line1 and line2 of the block (1-based, inclusive)
function M.vsplit(range)
    vim.notify(vim.inspect(range), vim.log.levels.DEBUG)
end

return M
