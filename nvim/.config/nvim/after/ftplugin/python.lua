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

local function run_ipython(mode)
    vim.cmd "silent noautocmd update"
    local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")

    local ttt = require "toggleterm.terminal"
    local term_info = ttt.get(1)
    local is_open = term_info ~= nil and term_info:is_open() or false
    if not is_open then
        local ipython = ttt.Terminal:new {
            cmd = "ipython",
            hidden = false,
        }
        ipython:toggle()
        vim.cmd "wincmd p"
        vim.cmd "stopinsert"
    else
        if term_info ~= nil and term_info.cmd ~= "ipython" then
            -- Switch to an ipython console if we are not already in one
            vim.cmd 'TermExec cmd="ipython"'
            term_info.cmd = "ipython"
        end
    end

    if mode == "open" then
        return
    elseif mode == "module" then
        vim.cmd(string.format('TermExec cmd="\\%%run %s"', fname))
    elseif mode == "line" then
        vim.cmd "ToggleTermSendCurrentLine"
    elseif mode == "selection" then
        -- vim.cmd "normal " -- leave visual mode to set <,> marks
        vim.cmd "ToggleTermSendVisualLines"
    elseif mode == "reset" then
        vim.cmd 'TermExec cmd="\\%reset -f"'
    end
end

-- keymap.set("n", "<localleader>rf", run_toggleterm, { buffer = true })
keymap.set({ "n", "i" }, "<F5>", run_tmux_pane, { buffer = true })
keymap.set("n", "<localleader>rp", function()
    run_toggleterm(true)
end, { buffer = true })

keymap.set({ "n", "i" }, "<F6>", function()
    run_tmux_pane(true)
end, { buffer = true })
keymap.set("n", "<localleader>rl", function()
    run_ipython "line"
end, { buffer = true })
keymap.set("v", "<localleader>rl", function()
    print "send"
    run_ipython "selection"
end, { buffer = true })
keymap.set("n", "<localleader>ri", function()
    run_ipython "module"
end, { buffer = true })
