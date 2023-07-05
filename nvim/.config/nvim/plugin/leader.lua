-- vim: foldmethod=marker foldlevel=0
local keymap, api = vim.keymap, vim.api

local silent = { silent = true }
local nosilent = { silent = false }
local opts = { noremap = true, unique = true }

-- BASIC ---------------------------------------------------------------------- {{{

-- Insert mode
keymap.set("i", "hh", "<ESC>", silent)
keymap.set("i", "<c-f>", "<Right>", silent)
keymap.set("i", "<c-b>", "<Left>", silent)
keymap.set("i", "<c-d>", "<c-O>dw", silent)
keymap.set("i", "<c-a>", "<c-O>^", silent)
keymap.set("i", "<c-e>", "<c-O>$", silent)
keymap.set("i", "<c-j>", "<s-left>", silent)
keymap.set("i", "<c-k>", "<s-right>", silent)

-- keymap.set("i", "<C-w>", "<C-o>E<C-o>l")
-- keymap.set("i", "<C-b>", "<C-o>B")

-- https://vim.fandom.com/wiki/Moving_lines_up_or_down
-- keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
-- keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)
-- keymap.set("i", "<A-j>", "<ESC>:m .+1<CR>==gi", opts)
-- keymap.set("i", "<A-k>", "<ESC>:m .-2<CR>==gi", opts)
-- keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
-- keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Move across wrapped lines like regular lines
-- Go to the first non-blank character of a line
keymap.set("n", "0", "^", opts)
-- Just in case you need to go to the very beginning of a line
keymap.set("n", "^", "0", opts)

-- Map gm to `. Instead of `a, hit gma. See :help mark-motions as to why we use backtick.
keymap.set("n", "gm", "`", { noremap = false })
-- Jump using marks to last change, left insert, jump.
keymap.set("n", "<Leader>mc", ":norm `.<CR>", { noremap = true, unique = true })
keymap.set("n", "<Leader>mi", ":norm `^<CR>", { noremap = true, unique = true })
keymap.set("n", "<Leader>mj", ":norm `'<CR>", { noremap = true, unique = true })

-- Evaluates whether there is a fold on the current line if so unfold it else return a normal space
-- keymap.set(
--     "n",
--     "<space><space>",
--     [[@=(foldlevel('.')?'za':"\<Space>")<CR>]],
--     { noremap = true, desc = "toggle fold under cursor", silent = true }
-- )
-- Toggle open close fold (recursive)
keymap.set(
    "n",
    "<c-space>",
    [[@=(foldlevel('.')?'zA':"\<Space>")<CR>]],
    { noremap = true, desc = "toggle fold recursive", silent = true }
)
-- Refocus folds
keymap.set(
    "n",
    "<localleader>z",
    [[zMzvzz]],
    { desc = "center viewport", noremap = true }
)

-- Jump next/prev fold
-- keymap.set("n", "zn", "zjzz", opts)
-- keymap.set("n", "zp", "zkzz", opts)

-- Alternate the file
local ignore_alternate_ft = {
    ["qf"] = true,
    ["Outline"] = true,
    ["neo-tree"] = true,
    ["OverseerList"] = true,
}
keymap.set("n", "<Leader>b", function()
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
end)

-- Go to the last edit (juga center the window)
keymap.set("n", "g,", "g,zvzz", silent)
keymap.set("n", "g;", "g;zvzz", silent)

keymap.set("n", "<c-w>v", "<CMD>vsplit<CR>", silent)
keymap.set("n", "<c-w>s", "<CMD>split<CR>", silent)

keymap.set("n", "<c-f>", "/", nosilent)
keymap.set("n", "gQ", "<Nop>")
keymap.set(
    "n",
    "<Localleader>fs",
    [[:s/\<<C-r>=expand("<cword>")<CR>\>/]],
    nosilent
)

-- keymap.set("n", "<localleader>ws", "<C-W>t <C-W>K", {
--     desc = "change two horizontally split windows to vertical splits",
--     silent = true,
-- })
-- keymap.set("n", "<localleader>wv", "<C-W>t <C-W>H", {
--     desc = "change two vertically split windows to horizontal splits",
--     silent = true,
-- })

keymap.set("v", "<localleader>fs", [["zy:%s/<C-r><C-o>"/]], nosilent)
keymap.set("i", "<C-U>", "<ESC>b~hea", { noremap = true, silent = true }) -- Change case of word
keymap.set("n", "Q", "<Nop>", {}) -- Disable Ex mode:

-- Multiple Cursor Replacement
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-byses-of-vimscript/
-- vim.keymap.set("n", "cn", "*``cgn")
-- vim.keymap.set("n", "cn", "*``cgN")

-- Ketika dalam mode visual, bisa pindah cursor ke atas dan bawah
keymap.set("x", "al", "$o0", silent)
keymap.set("o", "al", "<cmd>normal val<CR>", silent)

keymap.set("v", ">", ">gv", silent)
keymap.set("v", "<", "<gv", silent)

keymap.set("n", "~", "%", silent)

-- Toggle top/center/bottom
keymap.set(
    "n",
    "zz",
    [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
    { expr = true }
)

-- Set a mark when moving more than 5 lines upwards/downards
-- this will populate the jumplist enabling us to jump back with Ctrl-O
-- keymap.set(
--     "n",
--     "k",
--     [[(v:count > 5 ? "m'" . v:count : "") . 'k']],
--     { expr = true }
-- )
-- keymap.set(
--     "n",
--     "j",
--     [[(v:count > 5 ? "m'" . v:count : "") . 'j']],
--     { expr = true }
-- )
-- }}}
-- NAVIGATIONS ---------------------------------------------------------------- {{{
--
-- vim.keymap.set("n", "<C-h>", "<C-w>h", silent)
-- vim.keymap.set("n", "<C-l>", "<C-w>l", silent)
-- vim.keymap.set("n", "<C-j>", "<C-w>j", silent)
-- vim.keymap.set("n", "<C-k>", "<C-w>k", silent)
--
-- }}}
-- COMMANDLINE ---------------------------------------------------------------- {{{
keymap.set("c", "hh", "<c-c>", { desc = "Cmdline escape" })

keymap.set("c", "<c-a>", "<Home>", { desc = "Cmdline go first" })
keymap.set("c", "<c-e>", "<End>", { desc = "Cmdline go last" })

keymap.set("c", "<c-f>", "<Right>", { desc = "Cmdline next word" })
keymap.set("c", "<c-b>", "<Left>", { desc = "Cmdline prev word" })
keymap.set("c", "<M-b>", "<S-Left>", { desc = "Cmdnline <" })
keymap.set("c", "<M-f>", "<S-Right>", { desc = "Cmdline > " })

keymap.set("c", "<c-j>", "<S-Left>", { desc = "Cmdline back word" })
keymap.set("c", "<c-k>", "<S-Right>", { desc = "Cmdline forward word" })

keymap.set("c", "<c-n>", "<Down>", { desc = "Cmdline next hist" })
keymap.set("c", "<c-p>", "<Up>", { desc = "Cmdline prev hist" })

-- vim.keymap.set("c", "<esc>b", "<Up>", { desc = "Cmdline prev hist" })
-- }}}
-- TERMINAL ------------------------------------------------------------------- {{{

keymap.set("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
keymap.set("t", "<F1>", "<C-w>w", { desc = "Terminal change window" })
keymap.set(
    "t",
    "<C-h>",
    "<C-\\><C-n><C-w>h",
    { desc = "Terminal left window navigation" }
)
keymap.set(
    "t",
    "<C-j>",
    "<C-\\><C-n><C-w>j",
    { desc = "Terminal down window navigation" }
)
keymap.set(
    "t",
    "<C-k>",
    "<C-\\><C-n><C-w>k",
    { desc = "Terminal up window navigation" }
)
keymap.set(
    "t",
    "<C-l>",
    "<C-\\><C-n><C-w>l",
    { desc = "Terminal right window naviation" }
)
-- }}}

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
