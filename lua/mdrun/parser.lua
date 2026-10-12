-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

---@module "mdrun.parser"
---Locate the fenced code block under the cursor.
---@class FenceParser
local M = {}

---Search upward from the cursor line for the opening fence of a code block.
---
---The first fence met decides: with a language it is the start; without one it
---closes a block, so there is none.
---@param ctx Context
---@param curpos number 1-based cursor line
---@return number?, string? line 1-based line of the opening fence, language
local function find_start(ctx, curpos)
    for line = math.min(curpos, ctx.line_count), 1, -1 do
        local fence, language = ctx:get_line(line):match("^[ \t]*(```)[ \t]*(%S*)")
        if fence then
            if language == "" then
                return nil
            end
            return line, language
        end
    end
end

---Search downward from the line after `start` for the closing fence.
---@param ctx Context
---@param start number 1-based line of the opening fence
---@return number? line 1-based line of the closing fence
local function find_end(ctx, start)
    for line = start + 1, ctx.line_count do
        if ctx:get_line(line):match("^[ \t]*```") then
            return line
        end
    end
end

---Narrow `ctx` to the fenced code block at the start of its range: `line1` and
---`line2` become the opening and closing fences, `language` is set.
---Notifies and returns nil when there is none or it is not closed.
---@param ctx Context
---@return Context? ctx
function M.parse(ctx)
    local first, language = find_start(ctx, ctx.line1)
    if not first then
        vim.notify("mdrun: no fenced code block with a language under the cursor", vim.log.levels.WARN)
        return nil
    end
    local last = find_end(ctx, first)
    if not last then
        vim.notify("mdrun: the fenced code block is not closed", vim.log.levels.WARN)
        return nil
    end
    ctx.line1, ctx.line2, ctx.language = first, last, language
    return ctx
end

return M
