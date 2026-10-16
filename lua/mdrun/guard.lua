-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

---@module "mdrun.guard"
---Safety checks before a block runs: per-session sandbox warning and confirmation.
---@class Guard
local M = {}

local WARNING = "mdrun: there is no sandbox, commands run on your computer with your permissions. Be careful."

local warned = false

---Warn once per Neovim session that blocks are not sandboxed.
local function warn_once()
    if warned then
        return
    end
    warned = true
    vim.notify(WARNING, vim.log.levels.WARN)
end

---@param ctx Context? block about to run, nil when the parser found none
---@param confirm boolean ask before running
---@return boolean ok true when the block may run
function M.allow(ctx, confirm)
    if not ctx then
        return false
    end
    warn_once()
    if not confirm then
        return true
    end
    return vim.fn.confirm(("mdrun: run this %s block?\n\n%s"):format(ctx.language, ctx:text()), "&Yes\n&No", 2) == 1
end

return M
