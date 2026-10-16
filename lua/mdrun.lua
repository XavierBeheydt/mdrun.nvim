-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

---@class MDRun
local M = {}

---@class Config
---@field split_size number fraction of the editor area used by the runner's terminal
---@field confirm boolean ask for confirmation before running a block

---@type Config
M.config = {
    split_size = 0.35,
    confirm = true,
}

---@param args Config?
function M.setup(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

---@alias MDRunCmd { line1: number, line2: number } arguments of the user command

---@param cmd MDRunCmd
---@param open string window command opening the runner, e.g. "split"
local function run(cmd, open)
    local ctx = require("mdrun.parser").parse(require("mdrun.context").new(cmd))
    if ctx and require("mdrun.guard").allow(ctx, M.config.confirm) then
        require("mdrun.runner").run(ctx, open, M.config.split_size)
    end
end

---Run the fenced code block in a split below the current window (:split).
---@param cmd MDRunCmd arguments of the :MDRun user command
function M.split(cmd)
    run(cmd, "split")
end

---Run the fenced code block in a vertical split beside the current window (:vsplit).
---@param cmd MDRunCmd arguments of the :VMDRun user command
function M.vsplit(cmd)
    run(cmd, "vsplit")
end

return M
