local keymap = vim.keymap

-- Disable ctrl-i and ctrl-o
vim.keymap.set("n", "<c-i>", "<Nop>", {
    buffer = vim.api.nvim_get_current_buf(),
})
vim.keymap.set("n", "<c-o>", "<Nop>", {
    buffer = vim.api.nvim_get_current_buf(),
})

keymap.set("n", "<c-p>", function()
    vim.cmd [[
        try
            execute  "cprevious"
        catch /^Vim\%((\a\+)\)\=:E553/
            " execute "echo 'stop it'"
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
            ]]

    local ft, _ = as.get_bo_buft()
    if ft ~= "qf" then
        vim.cmd "wincmd p"
    end
end, {
    silent = true,
    buffer = vim.api.nvim_get_current_buf(),
})
keymap.set("n", "<c-n>", function()
    vim.cmd [[
        try
            execute "cnext"
        catch /^Vim\%((\a\+)\)\=:E553/
            " execute "echo 'stop it'"
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
            ]]
    local ft, _ = as.get_bo_buft()
    if ft ~= "qf" then
        vim.cmd "wincmd p"
    end
end, {
    silent = true,
    buffer = vim.api.nvim_get_current_buf(),
})

keymap.set("n", "gh", function()
    vim.cmd [[
            try
                execute "colder"
            catch /^Vim\%((\a\+)\)\=:E\%(380\|381\):/
                " execute "echo 'yo stop it'"
            endtry
            ]]
end, {
    silent = true,
    buffer = vim.api.nvim_get_current_buf(),
})
keymap.set("n", "gl", function()
    vim.cmd [[
            try
                execute "cnewer"
            catch /^Vim\%((\a\+)\)\=:E\%(380\|381\):/
                " execute "echo 'yo stop it'"
            endtry
            ]]
end, {
    silent = true,
    buffer = vim.api.nvim_get_current_buf(),
})

vim.keymap.set("n", "<c-d>", function()
    local pvs = require "bqf.preview.session"

    if pvs.validate() then
        return require("bqf.preview.handler").scroll(1)
    else
        return vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-d>", true, true, true),
            "n",
            true
        )
    end
end, {
    silent = true,
    buffer = vim.api.nvim_get_current_buf(),
})
vim.keymap.set("n", "<c-u>", function()
    local pvs = require "bqf.preview.session"

    if pvs.validate() then
        return require("bqf.preview.handler").scroll(-1)
    else
        return vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-u>", true, true, true),
            "n",
            true
        )
    end
end, {
    silent = true,
    buffer = vim.api.nvim_get_current_buf(),
})
