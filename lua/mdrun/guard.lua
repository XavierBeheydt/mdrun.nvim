-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

---@module "mdrun.guard"
---Safety checks before a block runs: one-time sandbox warning and confirmation.
---@class Guard
local M = {}

local WARNING = "mdrun: there is no sandbox, commands run on your computer with your permissions. Be careful."

---@return string path marker file recording that the warning was shown
local function marker()
    return vim.fn.stdpath("state") .. "/mdrun_warned"
end

---Warn once, ever, that blocks are not sandboxed.
local function warn_once()
    local path = marker()
    if vim.uv.fs_stat(path) then
        return
    end
    vim.notify(WARNING, vim.log.levels.WARN)
    vim.fn.mkdir(vim.fs.dirname(path), "p")
    vim.fn.writefile({}, path)
end

---@param ctx Context block about to run
---@param confirm boolean ask before running
---@return boolean ok true when the block may run
function M.allow(ctx, confirm)
    warn_once()
    if not confirm then
        return true
    end
    return vim.fn.confirm(("mdrun: run this %s block?\n\n%s"):format(ctx.language, ctx:text()), "&Yes\n&No", 2) == 1
end

return M
