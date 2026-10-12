-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

local assert = require("luassert")
local mdrun = require("mdrun")

describe("setup", function()
    local default = vim.deepcopy(mdrun.config)

    after_each(function()
        mdrun.config = vim.deepcopy(default)
    end)

    it("keeps the defaults without arguments", function()
        mdrun.setup()
        assert.are.same(default, mdrun.config)
    end)

    it("overrides only the given options", function()
        mdrun.setup({ split_size = 0.5 })
        assert.are.equal(0.5, mdrun.config.split_size)
    end)
end)

describe("commands", function()
    local runner, run, called

    before_each(function()
        vim.cmd("enew!")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "```python", "print(1)", "```" })
        runner, called = require("mdrun.runner"), nil
        run = runner.run
        runner.run = function(ctx, open, size)
            called = { ctx = ctx, open = open, size = size }
        end
    end)

    after_each(function()
        runner.run = run
    end)

    for fn, open in pairs({ split = "split", vsplit = "vsplit" }) do
        it(fn .. " hands a context built from the user command to the runner", function()
            mdrun[fn]({ line1 = 1, line2 = 3 })
            assert.are.equal(open, called.open)
            assert.are.equal(mdrun.config.split_size, called.size)
            assert.are.equal(1, called.ctx.line1)
            assert.are.equal(3, called.ctx.line2)
            assert.are.equal(3, called.ctx.line_count)
        end)

        it(fn .. " rejects an invalid range", function()
            assert.has_error(function()
                mdrun[fn]({ line1 = 0, line2 = 3 })
            end)
        end)
    end
end)
