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
    local notify, notified

    before_each(function()
        vim.cmd("enew!")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "```python", "print(1)", "```" })
        notify, notified = vim.notify, nil
        vim.notify = function(msg)
            notified = msg
        end
    end)

    after_each(function()
        vim.notify = notify
    end)

    for fn, open in pairs({ split = "split", vsplit = "vsplit" }) do
        it(fn .. " builds a context from the user command arguments", function()
            mdrun[fn]({ line1 = 1, line2 = 3 })
            assert.is_truthy(notified:find(('open = "%s"'):format(open), 1, true))
            assert.is_truthy(notified:find("line1 = 1", 1, true))
            assert.is_truthy(notified:find("line2 = 3", 1, true))
            assert.is_truthy(notified:find("line_count = 3", 1, true))
        end)

        it(fn .. " notifies an error on an invalid range", function()
            mdrun[fn]({ line1 = 0, line2 = 3 })
            assert.is_truthy(notified:find("invalid range", 1, true))
            assert.is_nil(notified:find("open =", 1, true))
        end)
    end
end)
