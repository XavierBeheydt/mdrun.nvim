-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

local api = vim.api

---@class Context
---@field buf number buffer the command was run from
---@field line1 number first line of the command range (1-based)
---@field line2 number last line of the command range (1-based, inclusive)
---@field line_count number number of lines in the buffer
local Context = {}
Context.__index = Context

---@param cmd { line1: number, line2: number } user command arguments
---@return Context
function Context.new(cmd)
    local line1, line2 = cmd.line1, cmd.line2
    if type(line1) ~= "number" or type(line2) ~= "number" or line1 < 1 or line2 < line1 then
        error(("invalid range: line1=%s, line2=%s (need 1 <= line1 <= line2)"):format(line1, line2), 2)
    end

    local buf = api.nvim_get_current_buf()
    return setmetatable({
        buf = buf,
        line1 = line1,
        line2 = line2,
        line_count = api.nvim_buf_line_count(buf),
    }, Context)
end

---@param first number 1-based, inclusive
---@param last number 1-based, inclusive
---@return string[]
function Context:get_lines(first, last)
    return api.nvim_buf_get_lines(self.buf, first - 1, last, false)
end

---@param n number 1-based
---@return string? line nil when out of the buffer
function Context:get_line(n)
    return self:get_lines(n, n)[1]
end

---@param first number 1-based, inclusive
---@param last number 1-based, inclusive
---@return string lines joined by "\n"
function Context:get_text(first, last)
    return table.concat(self:get_lines(first, last), "\n")
end

---Text strictly between line1 and line2, the fences excluded.
---@return string
function Context:text()
    return self:get_text(self.line1 + 1, self.line2 - 1)
end

return Context
