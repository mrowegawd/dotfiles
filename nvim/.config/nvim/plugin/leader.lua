local silent = { silent = true }
local nosilent = { silent = false }
local opts = { noremap = true, unique = true }

local keymap, api = vim.keymap, vim.api

local fn, api, uv, cmd, command, fmt, map =
    vim.fn, vim.api, vim.uv, vim.cmd, as.command, string.format, vim.keymap.set

local recursive_map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.remap = true
    map(mode, lhs, rhs, opts)
end

local nmap = function(...)
    recursive_map("n", ...)
end
local imap = function(...)
    recursive_map("i", ...)
end
local nnoremap = function(...)
    map("n", ...)
end
local xnoremap = function(...)
    map("x", ...)
end
local vnoremap = function(...)
    map("v", ...)
end
local inoremap = function(...)
    map("i", ...)
end
local onoremap = function(...)
    map("o", ...)
end
local cnoremap = function(...)
    map("c", ...)
end
local tnoremap = function(...)
    map("t", ...)
end

--  ╭──────────────────────────────────────────────────────────╮
--  │ EDITING TEXT                                             │
--  ╰──────────────────────────────────────────────────────────╯
inoremap("hh", "<ESC>", silent)
inoremap("<c-f>", "<Right>", silent)
inoremap("<c-b>", "<Left>", silent)
inoremap("<c-d>", "<c-O>dw", silent)
inoremap("<c-a>", "<c-O>^", silent)
inoremap("<c-e>", "<c-O>$", silent)
inoremap("<c-j>", "<s-left>", silent)
inoremap("<c-k>", "<s-right>", silent)

nnoremap("0", "^", opts) -- Go to the first non-blank character of a line
nnoremap("^", "0", opts) -- Just in case you need to go to the very beginning of a line

nnoremap("g,", "g,zvzz", silent) -- go last edit
nnoremap("g;", "g;zvzz", silent) -- go prev edit

-- inoremap("<C-U>", "<ESC>b~hea") -- Change first word upper or low case

-- inoremap("<C-w>", "<C-o>E<C-o>l")
-- inoremap("<C-b>", "<C-o>B")

-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
-- keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
-- keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)
-- keymap.set("i", "<A-j>", "<ESC>:m .+1<CR>==gi", opts)
-- keymap.set("i", "<A-k>", "<ESC>:m .-2<CR>==gi", opts)
-- keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
-- keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

nnoremap("<c-f>", "/", nosilent)
vnoremap(
    "<c-f>",
    [["zy:%s/<C-r><C-o>"/]],
    { desc = "Insert: search and replace on the fly" }
)

--  ╭──────────────────────────────────────────────────────────╮
--  │ MARKS                                                    │
--  ╰──────────────────────────────────────────────────────────╯
-- nnoremap("gm", "`", { noremap = false }) -- Map gm to `. Instead of `a, hit gma. See :help mark-motions as to why we use backtick.

-- Jump using marks to last change, left insert, jump.
nnoremap("<Leader>mc", ":norm `.<CR>", { desc = "Marks: jump to last change" })
nnoremap("<Leader>mi", ":norm `^<CR>", { desc = "Marks: jump to last insert" })
nnoremap("<Leader>mj", ":norm `'<CR>", { desc = "Marks: jump to last jump" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ FOLDS                                                    │
--  ╰──────────────────────────────────────────────────────────╯
nnoremap(
    "<c-space>",
    [[@=(foldlevel('.')?'zA':"\<Space>")<CR>]],
    { desc = "Fold: toggle fold recursive" }
) -- Toggle open close fold (recursive)
nnoremap("<localleader>z", [[zMzvzz]], { desc = "Fold: center viewport" }) -- Refocus folds

-- Jump next/prev fold
-- nnoremap("zn", "zjzz", opts)
-- nnoremap("zp", "zkzz", opts)

--  ╭──────────────────────────────────────────────────────────╮
--  │ BUFFERS                                                  │
--  ╰──────────────────────────────────────────────────────────╯
nnoremap("<Leader>O", function()
    return require("r.utils").Buf_only()
end, { desc = "Buffer: BufOnly" })

nnoremap("<c-w>b", "<C-w><S-t>", { desc = "Buffer: break buffer into new tab" })
nnoremap("gH", "<CMD>bfirst<CR>", { desc = "Buffer: go to the first buffer" })
nnoremap("gL", "<CMD>blast<CR>", { desc = "Buffer: go to the last buffer" })

-- Exit or delete a buffer
local neozoom = false
nnoremap("<Leader><TAB>", function()
    local ft, _ = as.get_bo_buft()
    if neozoom then
        neozoom = false
        return cmd "NeoZoomToggle"
    end

    local buf_fts = {
        ["fugitive"] = "bd",
        ["Trouble"] = "bd",
        ["help"] = "bd",
        ["norg"] = "bd",
        ["org"] = "bd",
        ["octo"] = "bd",

        ["alpha"] = "q",
        ["spectre_panel"] = "q",
        ["OverseerForm"] = "q!",
        ["orgagenda"] = "q",
        ["markdown"] = "q",
        ["NeogitStatus"] = "q",
        ["neo-tree"] = "NeoTreeShowToggle",
        ["DiffviewFileHistory"] = "DiffviewClose",
        ["qf"] = require("r.utils").toggle_kil_loc_qf,
    }

    local wins = vim.api.nvim_tabpage_list_wins(0)
    -- Both neo-tree and aerial will auto-quit if there is only a single window left
    if #wins <= 1 then
        return as.smart_quit()
    end

    local sidebar_fts = { aerial = true, ["neo-tree"] = true }

    for _, winid in ipairs(wins) do
        if vim.api.nvim_win_is_valid(winid) then
            local bufnr = vim.api.nvim_win_get_buf(winid)
            local filetype =
                vim.api.nvim_get_option_value("filetype", { buf = bufnr })

            -- If any visible windows are not sidebars, early return
            if not sidebar_fts[filetype] then
                for ft_i, exec_msg in pairs(buf_fts) do
                    if ft == ft_i then
                        if type(exec_msg) == "string" then
                            return cmd(exec_msg)
                        elseif type(exec_msg) == "function" then
                            return exec_msg()
                        end
                    else
                        return as.smart_quit()
                        -- return require("mini.bufremove").delete(0, false)
                    end
                end

                -- If the visible window is a sidebar
            else
                -- only count filetypes once, so remove a found sidebar from the detection
                sidebar_fts[filetype] = nil
            end
        end
    end

    if #vim.api.nvim_list_tabpages() > 1 then
        vim.cmd.tabclose()
    else
        vim.cmd.qall()
    end
end, { desc = "Buffer: Magic exit" })

-- Alternate the buffer
local ignore_alternate_ft = {
    ["qf"] = true,
    ["Outline"] = true,
    ["neo-tree"] = true,
    ["OverseerList"] = true,
}
nnoremap("<Leader>b", function()
    local bufnr = vim.api.nvim_get_current_buf()

    local ft = vim.bo[bufnr].filetype

    if ignore_alternate_ft[ft] then
        return
    end
    return api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-^>", true, true, true),
        "n",
        true
    )
end, { desc = "Buffer: Alternate the buffer/file" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ TABS                                                     │
--  ╰──────────────────────────────────────────────────────────╯
nnoremap("tn", "<CMD>tabedit %<CR>", { desc = "Tab: new tab" })
nnoremap("tl", "<CMD>tabn<CR>", { desc = "Tab: next tab" })
nnoremap("th", "<CMD>tabp<CR>", { desc = "Tab: prev tab" })
nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Tab; first tab" })
nnoremap("tL", "<CMD>tabfirst<CR>", { desc = "Tab: last tab" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ VISUAL                                                   │
--  ╰──────────────────────────────────────────────────────────╯
-- Ketika dalam mode visual, bisa pindah cursor ke atas dan bawah
xnoremap("al", "$o0", { desc = "Visual: jump in" })
onoremap("al", "<cmd>normal val<CR>", { desc = "Visual: jump out" })

nnoremap("vv", [[^vg_]], { desc = "Visual: select text lines" })

vnoremap(">", ">gv", { desc = "Visual: next align lines" })
vnoremap("<", "<gv", { desc = "Visual: prev align lines" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ MISC                                                     │
--  ╰──────────────────────────────────────────────────────────╯
nnoremap("~", "%", silent)

-- Multiple Cursor Replacement
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-byses-of-vimscript/
-- vim.keymap.set("n", "cn", "*``cgn")
-- vim.keymap.set("n", "cn", "*``cgN")

-- Toggle top/center/bottom
nnoremap(
    "zz",
    [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
    { expr = true }
)

nnoremap("<Leader>P", function()
    return vim.notify(fn.expand "%:p")
end, { desc = "Check cwd curfile" })

nnoremap("<Leader>cd", function()
    local filepath = fn.expand "%:p:h" -- code
    cmd(fmt("cd %s", filepath))
    vim.notify(fmt("ROOT CHANGED: %s", filepath))
end, { desc = "Change cur pwd to curfile" })

nnoremap("<Leader>n", function()
    require("notify").dismiss {}
    return cmd.nohl()
end, { desc = "Clear searches" })

nnoremap("n", "nzzzv", { desc = "Search next" })
nnoremap("N", "Nzzzv", { desc = "Search prev" })

-- Allow moving the cursor through wrapped lines using j and k,
-- note that I have line wrapping turned off but turned on only for Markdown
nnoremap("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
nnoremap("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- Set a mark when moving more than 5 lines upwards/downards
-- this will populate the jumplist enabling us to jump back with Ctrl-O
-- nnoremap(
--     "k",
--     [[(v:count > 5 ? "m'" . v:count : "") . 'k']],
--     { expr = true }
-- )
-- nnoremap(
--     "j",
--     [[(v:count > 5 ? "m'" . v:count : "") . 'j']],
--     { expr = true }
-- )

--  ╭──────────────────────────────────────────────────────────╮
--  │ WINDOWS                                                  │
--  ╰──────────────────────────────────────────────────────────╯
nnoremap("<c-w>v", "<CMD>vsplit<CR>", silent)
nnoremap("<c-w>s", "<CMD>split<CR>", silent)

nnoremap("<Localleader>fs", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], nosilent)

nnoremap("<c-w>J", "<C-W>t <C-W>K", {
    desc = "Windows: change two horizontally split windows to vertical splits",
})
nnoremap("<c-w>L", "<C-W>t <C-W>H", {
    desc = "Windows: change two vertically split windows to horizontal splits",
})

-- nnoremap("<localleader>ws", "<C-W>t <C-W>K", {
--     desc = "change two horizontally split windows to vertical splits",
--     silent = true,
-- })
-- nnoremap("<localleader>wv", "<C-W>t <C-W>H", {
--     desc = "change two vertically split windows to horizontal splits",
--     silent = true,
-- })
--  ╭──────────────────────────────────────────────────────────╮
--  │ NAVIGATIONS                                              │
--  ╰──────────────────────────────────────────────────────────╯

local isWindows, _ = pcall(require, "smart-splits")
if not isWindows then
    nnoremap("<C-h>", "<C-w>h", { desc = "Navigations: move left" })
    nnoremap("<C-l>", "<C-w>l", { desc = "Navigations: move right" })
    nnoremap("<C-j>", "<C-w>j", { desc = "Navigations: move down" })
    nnoremap("<C-k>", "<C-w>k", { desc = "Navigations: move up" })

    nnoremap(
        "<a-K>",
        "<cmd>resize +2<cr>",
        { desc = "Windows: resize window up" }
    )
    nnoremap(
        "<a-J>",
        "<cmd>resize -2<cr>",
        { desc = "Windows: resize window down" }
    )
    nnoremap(
        "<a-H>",
        "<cmd>vertical resize +2<cr>",
        { desc = "Windows: resize window right" }
    )
    nnoremap(
        "<a-L>",
        "<cmd>vertical resize -2<cr>",
        { desc = "Windows: resize window left" }
    )
end

--  ╭──────────────────────────────────────────────────────────╮
--  │ COMMANDLINE                                              │
--  ╰──────────────────────────────────────────────────────────╯
cnoremap("hh", "<c-c>", { desc = "Cmdline: exit from cmdline" })
cnoremap("<c-a>", "<Home>", { desc = "Cmdline: go to the first" })
cnoremap("<c-e>", "<End>", { desc = "Cmdline: go to the last" })

cnoremap("<c-f>", "<Right>", { desc = "Cmdline: next word" })
cnoremap("<c-b>", "<Left>", { desc = "Cmdline: prev word" })

cnoremap("<M-b>", "<S-Left>", { desc = "Cmdnline: <" })
cnoremap("<M-f>", "<S-Right>", { desc = "Cmdline: > " })

cnoremap("<c-j>", "<S-Left>", { desc = "Cmdline: back word" })
cnoremap("<c-k>", "<S-Right>", { desc = "Cmdline: forward word" })

cnoremap("<c-n>", "<Down>", { desc = "Cmdline: next hist" })
cnoremap("<c-p>", "<Up>", { desc = "Cmdline: prev hist" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ TERMINAL                                                 │
--  ╰──────────────────────────────────────────────────────────╯

as.augroup("AddTerminalMappings", {
    event = { "TermOpen" },
    pattern = { "term://*" },
    command = function()
        if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
            tnoremap("<F1>", "<C-w>w", { desc = "Terminal change window" })
            tnoremap(
                "<esc><esc>",
                "<C-\\><C-n>",
                { desc = "Terminal normal mode" }
            )
            tnoremap(
                "<C-h>",
                "<C-\\><C-n><C-w>h",
                { desc = "Terminal left window navigation" }
            )
            tnoremap(
                "<C-j>",
                "<C-\\><C-n><C-w>j",
                { desc = "Terminal down window navigation" }
            )
            tnoremap(
                "<C-k>",
                "<C-\\><C-n><C-w>k",
                { desc = "Terminal up window navigation" }
            )
            tnoremap(
                "<C-l>",
                "<C-\\><C-n><C-w>l",
                { desc = "Terminal right window naviation" }
            )
        end
    end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │ DISABLE                                                  │
--  ╰──────────────────────────────────────────────────────────╯

nnoremap("gQ", "<Nop>") -- disable
nnoremap("Q", "<Nop>", {}) -- Disable Ex mode:

vim.cmd [[
cab <silent> Wq wq
cab <silent> Q! q!
cab <silent> Q!! q!
cab <silent> q!! q!
cab <silent> WQ up
cab <silent> Q1 q
cab <silent> W1 updatee!
cab <silent> W! update!
cab <silent> w; update!
cab <silent> W; update!
cab <silent> W update
cab <silent> Q q
cab <silent> w@ update!
cab <silent> W@ update!

cab <silent> Bd bd!
cab <silent> BD bd!
cab <silent> bD bd!
cab <silent> Bd bd!
cab <silent> bd bd!]]
