-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

local assert = require("luassert")
local interpreter = require("mdrun.interpreter")

describe("interpreter", function()
    local executable, notify, notified

    ---@param available string[]
    local function only(available)
        vim.fn.executable = function(exe)
            return vim.tbl_contains(available, exe) and 1 or 0
        end
    end

    before_each(function()
        executable, notify, notified = vim.fn.executable, vim.notify, nil
        vim.notify = function(msg, level)
            notified = { msg = msg, level = level }
        end
    end)

    after_each(function()
        vim.fn.executable = executable
        vim.notify = notify
    end)

    it("tells whether a language is configured, ignoring the case", function()
        assert.is_true(interpreter.is_supported("python"))
        assert.is_true(interpreter.is_supported("Bash"))
        assert.is_false(interpreter.is_supported("cobol"))
    end)

    it("returns the first available executable with its own arguments", function()
        only({ "python", "node" })
        local py, js = interpreter.find("python"), interpreter.find("js")
        assert.are.equal("python", py.exe)
        assert.are.same({ "-c" }, py.args)
        assert.are.equal("node", js.exe)
        assert.are.same({ "-e" }, js.args)
        assert.is_nil(notified)
    end)

    it("prefers the first executable of the list", function()
        only({ "python3", "python" })
        assert.are.equal("python3", interpreter.find("py").exe)
    end)

    it("builds the command line of the interpreter", function()
        only({ "node" })
        assert.are.same({ "node", "-e", "console.log(1)" }, interpreter.find("js"):cmd("console.log(1)"))
    end)

    it("notifies an error asking to install the interpreter when none is available", function()
        only({})
        assert.is_nil(interpreter.find("python"))
        assert.are.equal("mdrun: no interpreter found for 'python': install python3 or python", notified.msg)
        assert.are.equal(vim.log.levels.ERROR, notified.level)
    end)

    it("notifies an error for a language that is not configured", function()
        assert.is_nil(interpreter.find("cobol"))
        assert.are.equal("mdrun: no interpreter configured for 'cobol'", notified.msg)
        assert.are.equal(vim.log.levels.ERROR, notified.level)
    end)
end)
