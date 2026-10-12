-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

local assert = require("luassert")
local runner = require("mdrun.runner")
local Context = require("mdrun.context")

describe("runner", function()
    local notify

    ---@param lines string[]
    ---@param line number cursor line
    ---@return Context
    local function ctx_for(lines, line)
        vim.cmd("enew!")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        return Context.new({ line1 = line, line2 = line })
    end

    before_each(function()
        notify = vim.notify
        vim.notify = function() end
        vim.cmd("silent! only!")
    end)

    after_each(function()
        vim.notify = notify
    end)

    it("runs the block in a terminal split below", function()
        local ctx = ctx_for({ "```sh", "exit 3", "```" }, 2)
        local buf = runner.run(ctx, "split", 0.35)
        assert(buf, "runner returned no buffer")
        assert.are.equal("terminal", vim.bo[buf].buftype)
        assert.are.equal(2, #vim.api.nvim_tabpage_list_wins(0))
        -- The exit code proves the code ran; the rendered text is not portable (ConPTY on Windows).
        assert.are.equal(3, vim.fn.jobwait({ vim.b[buf].terminal_job_id }, 5000)[1])
    end)

    it("opens a side window with vsplit", function()
        local ctx = ctx_for({ "```sh", "true", "```" }, 2)
        assert(runner.run(ctx, "vsplit", 0.35))
        assert.are.equal("row", vim.fn.winlayout()[1])
    end)

    it("sizes the window from the editor area", function()
        local ctx = ctx_for({ "```sh", "true", "```" }, 2)
        assert(runner.run(ctx, "split", 0.5))
        assert.are.equal(math.floor(vim.o.lines * 0.5), vim.api.nvim_win_get_height(0))
    end)

    it("opens nothing without a fenced block", function()
        assert.is_nil(runner.run(ctx_for({ "plain text" }, 1), "split", 0.35))
        assert.are.equal(1, #vim.api.nvim_tabpage_list_wins(0))
    end)

    it("opens nothing for an unsupported language", function()
        local ctx = ctx_for({ "```cobol", "DISPLAY 'x'.", "```" }, 2)
        assert.is_nil(runner.run(ctx, "split", 0.35))
        assert.are.equal(1, #vim.api.nvim_tabpage_list_wins(0))
    end)
end)
