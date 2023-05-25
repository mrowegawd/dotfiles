local keymap = vim.keymap
local buffer_dir = vim.fn.expand "%:p:h"

vim.b.make = "python"

local function run_toggleterm(post_mortem_mode)
    post_mortem_mode = post_mortem_mode or false

    vim.cmd "silent noautocmd update"

    local cmd = "python"
    if post_mortem_mode then
        cmd = cmd .. " -m pdb -cc"
    end

    -- If we have an ipython terminal open don't run `python` cmd but rather `run`
    local ttt = require "toggleterm.terminal"
    local term_info = ttt.get(1)
    if term_info ~= nil and term_info.cmd ~= nil then
        if term_info.cmd == "ipython" then
            cmd = "\\%run"
        end
    end

    vim.cmd(
        string.format(
            'TermExec cmd="%s %s"',
            cmd,
            vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
        )
    )
end

local function run_tmux_pane(debug_mode)
    debug_mode = debug_mode or false

    if vim.env.TMUX == nil then
        return
    end

    local python_cmd = "python"
    if debug_mode then
        python_cmd = python_cmd .. " -m pdb -cc"
    end

    local cwd = buffer_dir
    local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
    local sh_cmd = '"' .. python_cmd .. " " .. fname .. [[; read -p ''"]]
    vim.cmd(
        "silent! !tmux new-window -c "
            .. cwd
            .. " -n "
            .. fname
            .. " "
            .. sh_cmd
    )
end

keymap.set("n", "<Leader>rf", run_toggleterm, { buffer = true })
keymap.set("n", "<Leader>rp", function()
    run_toggleterm(true)
end, { buffer = true })

keymap.set({ "n", "i" }, "<F5>", run_tmux_pane, { buffer = true })
keymap.set({ "n", "i" }, "<F6>", function()
    run_tmux_pane(true)
end, { buffer = true })
