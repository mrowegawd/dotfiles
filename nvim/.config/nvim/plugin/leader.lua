-- vim: foldmethod=marker foldlevel=0
local silent = { silent = true }
local nosilent = { silent = false }
local keymap, api = vim.keymap, vim.api
-- local cmd = vim.cmd

-- BASIC ---------------------------------------------------------------------- {{{
keymap.set("i", "hh", "<ESC>", silent)
keymap.set("i", "<c-f>", "<Right>", silent)
keymap.set("i", "<c-b>", "<Left>", silent)

keymap.set("n", "<leader>q", "<Nop>", silent)

-- Alternate the file
local ignore_alternate_ft = {
    ["qf"] = true,
    ["Outline"] = true,
    ["neo-tree"] = true,
    ["OverseerList"] = true,
}
keymap.set("n", "<Leader><Leader>", function()
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

-- Better quit
-- keymap.set("n", "q", function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local ft = vim.bo[bufnr].filetype
--
--     if ft == "TelescopePromt" then
--         return
--     end
--     -- return cmd [[q]]
-- end, silent)

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
-- vim.keymap.set("i", "<C-r>", "<C-o>B") -- next jump per kata
-- vim.keymap.set("i", "<C-v>", "<C-o>E<C-o>l") -- prev jump perk kata

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
keymap.set("c", "hh", "<c-c>", { desc = "Cmdline <esc>" })

keymap.set("c", "<c-a>", "<Home>", { desc = "Cmdline go first" })
keymap.set("c", "<c-e>", "<End>", { desc = "Cmdline go last" })

keymap.set("c", "<c-f>", "<Right>", { desc = "Cmdline next word" })
keymap.set("c", "<c-b>", "<Left>", { desc = "Cmdline prev word" })

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
cab Wq wq
cab Q! q!
cab Q!! q!
cab q!! q!
cab WQ up
cab Q1 q
cab W1 updatee!
cab W! update!
cab w; update!
cab W; update!
cab W update
cab Q q
cab w@ update!
cab W@ update!

cab Bd bd!
cab BD bd!
cab bD bd!
cab Bd bd!
cab bd bd!]]
