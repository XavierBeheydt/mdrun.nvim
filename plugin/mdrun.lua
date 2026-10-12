-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

local api = vim.api
local autocmd = api.nvim_create_autocmd
local autogroup = api.nvim_create_augroup
local bufusercmd = api.nvim_buf_create_user_command

autocmd("FileType", {
    group = autogroup("mdrun", { clear = true }),
    pattern = "markdown",
    callback = function(event)
        local opts = {
            desc = "Run the fenced code block in a split terminal window.",
            range = true,
        }
        -- User command line range, 1-based and buffer-local (cmd.line1/cmd.line2).
        local range = function(cmd)
            return { line1 = cmd.line1, line2 = cmd.line2 }
        end
        -- MDRun: run the block below the cursor (:split).
        bufusercmd(event.buf, "MDRun", function(cmd)
            require("mdrun").split(range(cmd))
        end, opts)
        -- VMDRun: run the block in a side window (:vsplit).
        bufusercmd(event.buf, "VMDRun", function(cmd)
            require("mdrun").vsplit(range(cmd))
        end, opts)
    end,
})
