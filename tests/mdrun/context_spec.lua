-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

local assert = require("luassert")
local Context = require("mdrun.context")

describe("context", function()
    local ctx

    before_each(function()
        vim.cmd("enew!")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "```python", "a = 1", "print(a)", "```", "tail" })
        ctx = Context.new({ line1 = 1, line2 = 4 })
    end)

    it("stores the buffer, the range and the line count", function()
        assert.are.equal(vim.api.nvim_get_current_buf(), ctx.buf)
        assert.are.equal(1, ctx.line1)
        assert.are.equal(4, ctx.line2)
        assert.are.equal(5, ctx.line_count)
    end)

    it("notifies an error and returns nil for a range that is not 1 <= line1 <= line2", function()
        local notify, level = vim.notify, nil
        vim.notify = function(_, lvl)
            level = lvl
        end
        for _, cmd in ipairs({
            { line1 = 0, line2 = 3 },
            { line1 = -2, line2 = 3 },
            { line1 = 4, line2 = 2 },
            { line1 = 1 },
            {},
        }) do
            level = nil
            assert.is_nil(Context.new(cmd))
            assert.are.equal(vim.log.levels.ERROR, level)
        end
        vim.notify = notify
    end)

    it("accepts line1 == line2 (no range) and has no text between", function()
        local single = Context.new({ line1 = 3, line2 = 3 })
        assert.are.equal(3, single.line1)
        assert.are.equal("", single:text())
    end)

    it("gets lines with 1-based inclusive bounds", function()
        assert.are.same({ "a = 1", "print(a)" }, ctx:get_lines(2, 3))
    end)

    it("gets a single line, nil out of the buffer", function()
        assert.are.equal("tail", ctx:get_line(5))
        assert.is_nil(ctx:get_line(6))
    end)

    it("joins the lines of get_text", function()
        assert.are.equal("a = 1\nprint(a)", ctx:get_text(2, 3))
    end)

    it("returns the text between line1 and line2, both excluded", function()
        assert.are.equal("a = 1\nprint(a)", ctx:text())
    end)

    it("returns an empty text for an empty block", function()
        assert.are.equal("", Context.new({ line1 = 1, line2 = 2 }):text())
    end)
end)
