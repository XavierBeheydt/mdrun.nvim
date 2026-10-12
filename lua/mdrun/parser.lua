-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

---@module "mdrun.parser"
---Locate the fenced code block under the cursor.
---@class FenceParser
local M = {}

---Search upward from `line` for the opening fence of a code block and set
---`ctx.line1` and `ctx.language` from it.
---
---The first fence met decides: with a language it is the start; without one it
---closes a block, so there is none.
---@param ctx Context
---@param line number 1-based line to start from, at most `ctx.line_count`
---@return Context? ctx nil when there is no opening fence
local function find_start(ctx, line)
    if line < 1 then
        return nil
    end

    local fence, language = ctx:get_line(line):match("^[ \t]*(```)[ \t]*(%S*)")
    if not fence then
        return find_start(ctx, line - 1)
    end
    if language == "" then
        return nil
    end
    ctx.line1, ctx.language = line, language
    return ctx
end

---Search downward from `line` for the closing fence and set `ctx.line2` from it.
---@param ctx Context
---@param line number 1-based line to start from, the one after the opening fence
---@return Context? ctx nil when the block is not closed
local function find_end(ctx, line)
    if line > ctx.line_count then
        return nil
    end

    if ctx:get_line(line):match("^[ \t]*```") then
        ctx.line2 = line
        return ctx
    end
    return find_end(ctx, line + 1)
end

---Narrow `ctx` to the fenced code block at the start of its range: `line1` and
---`line2` become the opening and closing fences, `language` is set.
---Notifies and returns nil when there is none or it is not closed; `ctx` is then
---partly updated.
---@param ctx Context
---@return Context? ctx
function M.parse(ctx)
    if not find_start(ctx, math.min(ctx.line1, ctx.line_count)) then
        vim.notify("mdrun: no fenced code block with a language under the cursor", vim.log.levels.WARN)
        return nil
    end
    if not find_end(ctx, ctx.line1 + 1) then
        vim.notify("mdrun: the fenced code block is not closed", vim.log.levels.WARN)
        return nil
    end
    return ctx
end

return M
