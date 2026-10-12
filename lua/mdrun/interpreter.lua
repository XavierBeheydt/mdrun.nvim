-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

-- MODULE: Interpreter lookup for a fenced block language
---@module "mdrun.interpreter"

---@class Interpreter
---@field exe string executable name
---@field args string[] arguments placed before the code, they differ between interpreters
local Interpreter = {}
Interpreter.__index = Interpreter

---@param exe string
---@param args string[]
---@return Interpreter
function Interpreter.new(exe, args)
    return setmetatable({ exe = exe, args = args }, Interpreter)
end

---@return boolean
function Interpreter:available()
    return vim.fn.executable(self.exe) == 1
end

---@param code string
---@return string[] argv ready for vim.system / jobstart
function Interpreter:cmd(code)
    return vim.list_extend(vim.list_extend({ self.exe }, self.args), { code })
end

---@param args string[]
---@param ... string executables, by order of preference
---@return Interpreter[]
local function interpreters(args, ...)
    local found = {}
    for _, exe in ipairs({ ... }) do
        found[#found + 1] = Interpreter.new(exe, args)
    end
    return found
end

local sh = interpreters({ "-c" }, "sh")
local bash = interpreters({ "-c" }, "bash")
local zsh = interpreters({ "-c" }, "zsh")
local fish = interpreters({ "-c" }, "fish")
local python = interpreters({ "-c" }, "python3", "python")
local node = interpreters({ "-e" }, "node", "nodejs")
local ruby = interpreters({ "-e" }, "ruby")
local lua = interpreters({ "-e" }, "lua", "luajit")

---@type table<string, Interpreter[]> fence language (lowercase) -> interpreters by order of preference
local list = {
    sh = sh,
    bash = bash,
    shell = bash,
    zsh = zsh,
    fish = fish,
    py = python,
    python = python,
    python3 = python,
    javascript = node,
    js = node,
    node = node,
    nodejs = node,
    rb = ruby,
    ruby = ruby,
    lua = lua,
}

---@class InterpreterModule
local M = {}

---@param language string fence language, as written after the opening fence
---@return boolean
function M.is_supported(language)
    return list[language:lower()] ~= nil
end

---First configured interpreter whose executable is available; notifies an error otherwise.
---@param language string fence language, as written after the opening fence
---@return Interpreter?
function M.find(language)
    local candidates = list[language:lower()]
    if not candidates then
        vim.notify(("mdrun: no interpreter configured for '%s'"):format(language), vim.log.levels.ERROR)
        return nil
    end

    for _, candidate in ipairs(candidates) do
        if candidate:available() then
            return candidate
        end
    end
    local exes = vim.tbl_map(function(candidate)
        return candidate.exe
    end, candidates)
    vim.notify(
        ("mdrun: no interpreter found for '%s': install %s"):format(language, table.concat(exes, " or ")),
        vim.log.levels.ERROR
    )
    return nil
end

return M
