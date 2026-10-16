-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

local assert = require("luassert")
local guard = require("mdrun.guard")
local Context = require("mdrun.context")
local parser = require("mdrun.parser")

describe("guard", function()
    local notify, confirm, state, notified, answer, asked

    before_each(function()
        vim.cmd("enew!")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "```sh", "rm -rf x", "```" })
        state = vim.fn.tempname()
        vim.env.XDG_STATE_HOME = state
        notify, notified = vim.notify, {}
        vim.notify = function(msg)
            table.insert(notified, msg)
        end
        confirm, answer, asked = vim.fn.confirm, 1, {}
        vim.fn.confirm = function(msg)
            table.insert(asked, msg)
            return answer
        end
    end)

    after_each(function()
        vim.notify, vim.fn.confirm = notify, confirm
        vim.env.XDG_STATE_HOME = nil
        vim.fn.delete(state, "rf")
    end)

    local function ctx()
        return assert(parser.parse(Context.new({ line1 = 2, line2 = 2 })))
    end

    it("warns about the missing sandbox only once", function()
        guard.allow(ctx(), false)
        guard.allow(ctx(), false)
        assert.are.equal(1, #notified)
        assert.is_truthy(notified[1]:find("no sandbox", 1, true))
    end)

    it("runs without asking when confirm is off", function()
        assert.is_true(guard.allow(ctx(), false))
        assert.are.equal(0, #asked)
    end)

    it("shows the code and runs when confirmed", function()
        assert.is_true(guard.allow(ctx(), true))
        assert.is_truthy(asked[1]:find("rm -rf x", 1, true))
    end)

    it("does not run when declined", function()
        answer = 2
        assert.is_false(guard.allow(ctx(), true))
    end)
end)
