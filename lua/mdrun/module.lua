-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

---@class CustomModule
local M = {}

---@param greeting string
---@return string
M.my_first_function = function(greeting)
    return greeting
end

return M
