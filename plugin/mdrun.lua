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
        -- The raw user command args go to mdrun, which builds the context.
        -- MDRun: run the block below the cursor (:split).
        bufusercmd(event.buf, "MDRun", function(cmd)
            require("mdrun").split(cmd)
        end, opts)
        -- VMDRun: run the block in a side window (:vsplit).
        bufusercmd(event.buf, "VMDRun", function(cmd)
            require("mdrun").vsplit(cmd)
        end, opts)
    end,
})
