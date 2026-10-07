-- Copyright (c) 2026 Xavier Beheydt <xavier.beheydt@gmail.com>

vim.api.nvim_create_user_command("MyFirstFunction", function()
    print(require("mdrun").hello())
end, {})
