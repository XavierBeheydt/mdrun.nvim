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
    local runner, run, called, notify, notified

    before_each(function()
        vim.cmd("enew!")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "text", "```python", "print(1)", "```" })
        runner, called = require("mdrun.runner"), nil
        run = runner.run
        runner.run = function(ctx, open, size)
            called = { ctx = ctx, open = open, size = size }
        end
        notify, notified = vim.notify, nil
        vim.notify = function(msg)
            notified = msg
        end
    end)

    after_each(function()
        runner.run = run
        vim.notify = notify
    end)

    for fn, open in pairs({ split = "split", vsplit = "vsplit" }) do
        it(fn .. " hands the parsed block to the runner", function()
            mdrun[fn]({ line1 = 3, line2 = 3 })
            assert.are.equal(open, called.open)
            assert.are.equal(mdrun.config.split_size, called.size)
            assert.are.equal(2, called.ctx.line1)
            assert.are.equal(4, called.ctx.line2)
            assert.are.equal("python", called.ctx.language)
        end)

        it(fn .. " does not run outside a fenced block", function()
            mdrun[fn]({ line1 = 1, line2 = 1 })
            assert.is_nil(called)
            assert.is_truthy(notified)
        end)

        it(fn .. " rejects an invalid range", function()
            assert.has_error(function()
                mdrun[fn]({ line1 = 0, line2 = 3 })
            end)
        end)
    end
end)
