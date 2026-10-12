-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

---@module "mdrun.runner"
---Run a fenced code block in a terminal split.
---@class Runner
local M = {}

---@param ctx Context
---@param open string window command opening the runner, "split" or "vsplit"
---@param size number fraction of the editor area used by the terminal
---@return number? buf terminal buffer, nil when nothing ran
function M.run(ctx, open, size)
    if not require("mdrun.parser").parse(ctx) then
        return nil
    end
    local interp = require("mdrun.interpreter").find(ctx.language)
    if not interp then
        return nil
    end

    local code = ctx:text()
    local total = open == "split" and vim.o.lines or vim.o.columns
    vim.cmd(("%d%s"):format(math.floor(total * size), open))
    vim.cmd.enew()

    if vim.fn.jobstart(interp:cmd(code), { term = true }) <= 0 then
        vim.notify(("mdrun: failed to start '%s'"):format(interp.exe), vim.log.levels.ERROR)
        vim.cmd.close()
        return nil
    end
    return vim.api.nvim_get_current_buf()
end

return M
