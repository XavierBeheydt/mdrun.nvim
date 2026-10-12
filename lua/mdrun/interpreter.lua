-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

-- MODULE: Interpreter lookup for a fenced block language
---@module "mdrun.interpreter"

---@class Interpreter
---@field exe string executable name
---@field args string[] arguments placed before the code, they differ between interpreters

---@class InterpreterModule
local M = {}

---@param args string[]
---@param ... string executables, by order of preference
---@return Interpreter[]
local function interpreters(args, ...)
    local found = {}
    for _, exe in ipairs({ ... }) do
        found[#found + 1] = { exe = exe, args = args }
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

---@param language string fence language, as written after the opening fence
---@return boolean
function M.is_supported(language)
    return list[language:lower()] ~= nil
end

---First configured interpreter whose executable is available.
---@param language string fence language, as written after the opening fence
---@return Interpreter? interpreter
---@return string? err set when nothing can run the language
function M.find(language)
    local candidates = list[language:lower()]
    if not candidates then
        return nil, ("no interpreter configured for '%s'"):format(language)
    end

    local exes = {}
    for _, candidate in ipairs(candidates) do
        if vim.fn.executable(candidate.exe) == 1 then
            return candidate
        end
        exes[#exes + 1] = candidate.exe
    end
    return nil, ("no interpreter found for '%s': install %s"):format(language, table.concat(exes, " or "))
end

return M
