if not as then
    return
end

local fn, api, cmd = vim.fn, vim.api, vim.cmd
local windowdim = require "r.utils.windowdim"

local smart_close_filetypes = as.p_table {
    ["qf"] = true,
    ["log"] = true,
    ["help"] = true,
    ["query"] = true,
    ["dbui"] = true,
    ["lspinfo"] = true,
    ["git.*"] = true,
    ["Neogit.*"] = true,
    ["neotest.*"] = true,
    ["fugitive.*"] = true,
    ["copilot.*"] = true,
    ["tsplayground"] = true,
    ["startuptime"] = true,
}

local smart_close_buftypes = as.p_table {
    ["nofile"] = true,
}

local function smart_close()
    if fn.winnr "$" ~= 1 then
        api.nvim_win_close(0, true)
    end
end

as.augroup("SmartClose", {
    -- Close certain filetypes by pressing q.
    event = { "FileType" },
    command = function(args)
        local is_unmapped = fn.hasmapto("q", "n") == 0
        local buf = vim.bo[args.buf]
        local is_eligible = is_unmapped
            or vim.wo.previewwindow
            or smart_close_filetypes[buf.ft]
            or smart_close_buftypes[buf.bt]
        if is_eligible then
            vim.keymap.set(
                "n",
                "q",
                smart_close,
                { buffer = args.buf, nowait = true }
            )
        end
    end,
}, {
    -- Close quick fix window if the file containing it was closed
    event = { "BufEnter" },
    command = function()
        if fn.winnr "$" == 1 and vim.bo.buftype == "quickfix" then
            vim.notify "Bufenter autoclose running?"
            api.nvim_buf_delete(0, { force = true })
        end
    end,
}, {
    -- Automatically close corresponding loclist when quitting a window
    event = { "QuitPre", "BufDelete" },
    nested = true,
    command = function()
        if vim.bo.filetype ~= "qf" then
            cmd.lclose { mods = { silent = true } }
        end
    end,
})

as.augroup("TextYankHighlight", {
    -- don't execute silently in case of errors
    event = { "TextYankPost" },
    command = function()
        vim.highlight.on_yank {
            timeout = 500,
            on_visual = false,
            higroup = "Visual",
        }
    end,
})

-- local excluded = {
--     "neo-tree",
--     "NeogitStatus",
--     "NeogitCommitMessage",
--     "undotree",
--     "log",
--     "man",
--     "dap-repl",
--     "markdown",
--     "vimwiki",
--     "vim-plug",
--     "gitcommit",
--     "toggleterm",
--     "fugitive",
--     "list",
--     "NvimTree",
--     "startify",
--     "help",
--     "orgagenda",
--     "org",
--     "himalaya",
--     "Trouble",
--     "NeogitCommitMessage",
--     "NeogitRebaseTodo",
-- }

local ignore_buftype = { "quickfix", "nofile", "help", "terminal" }
local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }

as.augroup("WindowBehaviours", {
    event = { "CmdwinEnter" }, -- map q to close command window on quit
    pattern = { "*" },
    command = "nnoremap <silent><buffer><nowait> q <C-W>c",
}, {
    event = { "BufWinEnter" },
    command = function(args)
        if vim.wo.diff then
            vim.diagnostic.disable(args.buf)
        end
    end,
}, {
    event = { "BufWinLeave" },
    command = function(args)
        if vim.wo.diff then
            vim.diagnostic.enable(args.buf)
        end
    end,
}, {
    -- Go to last loc when opening a buffer
    event = { "BufWinEnter", "FileType", "BufRead", "BufEnter" },
    pattern = { "*" },
    command = function()
        if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
            return
        end

        if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
            -- reset cursor to first line
            vim.cmd "normal! gg"
            return
        end

        -- If a line has already been specified on the command line, we are done e.g. nvim file +num
        if fn.line "." > 1 then
            return
        end

        local last_line = fn.line [['"]]
        local buff_last_line = fn.line "$"

        -- If the last line is set and the less than the last line in the buffer
        if last_line > 0 and last_line <= buff_last_line then
            local win_last_line = fn.line "w$"
            local win_first_line = fn.line "w0"
            -- Check if the last line of the buffer is the same as the win
            if win_last_line == buff_last_line then
                vim.cmd 'normal! g`"' -- Set line to last line edited
                -- Try to center
            elseif
                buff_last_line - last_line
                > ((win_last_line - win_first_line) / 2) - 1
            then
                vim.cmd 'normal! g`"zz'
            else
                vim.cmd [[normal! G'"<c-e>]]
            end
        end
    end,
}, {
    event = { "FileType" },
    pattern = {
        "orgagenda",
        "capture",
        "gitcommit",
        "help",
        "qf",
        "Trouble",
    },
    command = function()
        cmd "wincmd J"
    end,
}, {
    event = { "FileType" },
    pattern = { "qf" },
    command = function()
        cmd "stopinsert"
    end,
}, {
    event = { "FileType" },
    pattern = { "norg", "org", "orgagenda" },
    command = function()
        vim.opt_local.foldcolumn = "0"
    end,
})

as.augroup("DisableWinBf", {
    event = { "BufRead", "BufWinEnter" },
    pattern = { "*" },
    command = function(args)
        local buf = vim.bo[args.buf].filetype

        if buf == "BufTerm" then
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
        end
    end,
})

as.augroup("CheckOutsideTime", {
    -- automatically check for changed files outside vim
    event = {
        "WinEnter",
        "BufWinEnter",
        "BufWinLeave",
        "BufRead",
        "BufEnter",
        "FocusGained",
    },
    command = "silent! checktime",
})

-- Disable swap/undo/backup files in temp directories or shm
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPre" }, {
--     group = augroup "secure",
--     pattern = {
--         "/tmp/*",
--         "$TMPDIR/*",
--         "$TMP/*",
--         "$TEMP/*",
--         "*/shm/*",
--         "/private/var/*",
--     },
--     callback = function()
--         vim.opt_local.undofile = false
--         vim.opt_local.swapfile = false
--         vim.opt_global.backup = false
--         vim.opt_global.writebackup = false
--     end,
-- })

as.augroup("WindowDim", {
    event = { "BufRead" },
    pattern = { "*" },
    command = function()
        windowdim.buf_enter()
    end,
}, {
    event = { "BufEnter" },
    pattern = { "*" },
    command = function()
        windowdim.buf_enter()
    end,
}, {

    event = { "FocusGained" },
    pattern = "*",
    command = function()
        windowdim.focus_gained()
    end,
}, {
    event = { "FocusLost" },
    pattern = "*",
    command = function()
        windowdim.focus_lost()
    end,
}, {
    event = { "WinEnter" },
    pattern = "*",
    command = function()
        windowdim.win_enter()
    end,
}, {
    event = { "WinLeave" },
    pattern = "*",
    command = function()
        windowdim.win_leave()
    end,
})

as.augroup("UnwareCursorLine", {
    event = { "InsertLeave" },
    pattern = { "*" },
    command = function()
        cmd [[set cursorline]]
    end,
}, {
    event = { "InsertEnter" },
    pattern = { "*" },
    command = function()
        cmd [[set nocursorline]]
    end,
})

as.augroup("DisableStatusline", {
    event = { "FocusLost" },
    pattern = "*",
    command = function()
        cmd [[set laststatus=0]]
    end,
}, {

    event = { "BufRead", "FocusGained" },
    pattern = "*",
    command = function()
        cmd [[set laststatus=2]]
    end,
})

local trim = function(pattern)
    local save = fn.winsaveview()
    cmd(string.format("keepjumps keeppatterns silent! %s", pattern))
    fn.winrestview(save)
end

local ignore_filetype_trim = { "norg", "text" }
local remove_group =
    vim.api.nvim_create_augroup("removeTrailingSpaces", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        -- trim trailing lines
        if vim.tbl_contains(ignore_filetype_trim, vim.bo.filetype) then
            trim [[%s/\($\n\s*\)\+\%$//]]
            trim [[%s/\s\+$//e]]
            vim.notify "Auto remove trailing spaces and lines"
        end
    end,
    group = remove_group,
})

-- NOTE ga suka behaviour fold window, setelah <CR> dari telescope bikin fold
-- nya menjadi kacau, beberapa solusi udah di aplikasikan ke config telescope dari
-- link ini https://github.com/nvim-telescope/telescope.nvim/issues/559
-- jika sudah di perbaiki, hapus ini command ini
vim.cmd [[
  autocmd BufRead * autocmd BufWinEnter * ++once normal! zx
]]
