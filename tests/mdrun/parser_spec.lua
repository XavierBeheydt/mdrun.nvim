-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

local assert = require("luassert")
local Context = require("mdrun.context")
local parser = require("mdrun.parser")

describe("parser", function()
    local notify, level

    before_each(function()
        notify, level = vim.notify, nil
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.notify = function(_, lvl)
            level = lvl
        end
        vim.cmd("enew!")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {
            "intro", -- 1
            "```python", -- 2
            "a = 1", -- 3
            "```", -- 4
            "between", -- 5
            "  ``` lua", -- 6
            "print(1)", -- 7
            "  ```", -- 8
            "```sh", -- 9
            "echo unclosed", -- 10
        })
    end)

    after_each(function()
        vim.notify = notify
    end)

    local function parse(line)
        local ctx = Context.new({ line1 = line, line2 = line })
        if parser.parse(ctx) then
            return ctx.language, ctx.line1, ctx.line2
        end
    end

    it("finds the block from the opening fence or the body", function()
        for _, line in ipairs({ 2, 3 }) do
            assert.are.same({ "python", 2, 4 }, { parse(line) })
        end
    end)

    it("narrows the context so that text() is the body of the block", function()
        local ctx = Context.new({ line1 = 3, line2 = 3 })
        assert.is_truthy(parser.parse(ctx))
        assert.are.equal("a = 1", ctx:text())
    end)

    it("reads an indented fence and a language after a space", function()
        assert.are.same({ "lua", 6, 8 }, { parse(7) })
    end)

    it("returns nil and warns outside a block", function()
        for _, line in ipairs({ 1, 4, 5 }) do
            level = nil
            assert.is_nil(parse(line))
            assert.are.equal(vim.log.levels.WARN, level)
        end
    end)

    it("returns nil and warns when the block is not closed", function()
        assert.is_nil(parse(10))
        assert.are.equal(vim.log.levels.WARN, level)
    end)
end)
