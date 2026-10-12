-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

-- MODULE: Fenced code bloc parser TODO: make a right description as module documentation
local api = vim.api

---@module "mdrun.parser"
---@class FenceParser
local M = {}

---Search upward from the cursor line for the opening fence of a code block.
---
---The first fence met decides: with a language it is the start; without one it
---closes a block, so there is none.
---@param curpos number 1-based cursor line
---@param line_count number number of lines in the buffer
---@return number?, string? line 1-based line of the opening fence, language
local function find_start(curpos, line_count)
    curpos = math.min(curpos, line_count)
    if curpos <= 0 then
        return nil
    end

    local text = api.nvim_buf_get_lines(0, curpos - 1, curpos, false)[1]
    local fence, language = text:match("^[ \t]*(```)[ \t]*(%S*)")
    if not fence then
        return find_start(curpos - 1, line_count)
    end
    if language == "" then
        return nil
    end
    return curpos, language
end

---Search downward from the line after `start` for the closing fence.
---@param start number 1-based line of the opening fence
---@param line_count number number of lines in the buffer
---@return number? line 1-based line of the closing fence
local function find_end(start, line_count)
    local line = start + 1
    if line > line_count then
        return nil
    end

    local text = api.nvim_buf_get_lines(0, line - 1, line, false)[1]
    if text:match("^[ \t]*```") then
        return line
    end
    return find_end(line, line_count)
end

-- HACK: improve function name?
-- TODO: make comment doc for the following function
---@return nil | string, number, number
function M.parse(curpos, line_count)
    if find_start(curpos, line_count) then
        print("TODO")
        return "python", 1, 2
    end
end

return M
