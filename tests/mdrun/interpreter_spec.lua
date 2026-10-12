-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

local assert = require("luassert")
local interpreter = require("mdrun.interpreter")

describe("interpreter", function()
    local executable

    ---@param available string[]
    local function only(available)
        vim.fn.executable = function(exe)
            return vim.tbl_contains(available, exe) and 1 or 0
        end
    end

    before_each(function()
        executable = vim.fn.executable
    end)

    after_each(function()
        vim.fn.executable = executable
    end)

    it("tells whether a language is configured, ignoring the case", function()
        assert.is_true(interpreter.is_supported("python"))
        assert.is_true(interpreter.is_supported("Bash"))
        assert.is_false(interpreter.is_supported("cobol"))
    end)

    it("returns the first available executable with its own arguments", function()
        only({ "python", "node" })
        assert.are.same({ exe = "python", args = { "-c" } }, interpreter.find("python"))
        assert.are.same({ exe = "node", args = { "-e" } }, interpreter.find("js"))
    end)

    it("prefers the first executable of the list", function()
        only({ "python3", "python" })
        assert.are.equal("python3", interpreter.find("py").exe)
    end)

    it("asks to install the interpreter when none is available", function()
        only({})
        local found, err = interpreter.find("python")
        assert.is_nil(found)
        assert.are.equal("no interpreter found for 'python': install python3 or python", err)
    end)

    it("reports a language that is not configured", function()
        local found, err = interpreter.find("cobol")
        assert.is_nil(found)
        assert.are.equal("no interpreter configured for 'cobol'", err)
    end)
end)
