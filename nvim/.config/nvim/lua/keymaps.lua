---@diagnostic disable: undefined-global

local Log = require "utils.log"

local UtilKey = require "utils.map"
local UtilWindow = require "utils.window"
local UtilTerm = require "utils.terminal"
local UtilFold = require "utils.fold"

local IconMisc = require("icons").misc

local silent = { silent = true }
local nosilent = { silent = false }

local fn, fmt = vim.fn, string.format
-- local fm_manager = vim.env.TERM_FILEMANAGER

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                 Edit/Insert                                 ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

UtilKey.inoremap("<C-a>", "<C-O>^", silent)
UtilKey.inoremap("<C-e>", "<C-O>$", silent)

UtilKey.inoremap("<a-l>", "<Right>", silent)
UtilKey.inoremap("<a-h>", "<Left>", silent)
UtilKey.inoremap("<a-j>", "<Down>", silent)
UtilKey.inoremap("<a-k>", "<Up>", silent)
UtilKey.inoremap("<a-b>", "<Esc>bi", silent)
UtilKey.inoremap("<a-f>", "<Esc>ea", silent)

UtilKey.vnoremap("<S-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", silent)
UtilKey.vnoremap("<S-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", silent)


--stylua: ignore
UtilKey.inoremap("<Esc>", function() UtilKey.feedkey "<C-c>" vim.cmd "noh" return "<esc>" end, silent)
--stylua: ignore
UtilKey.nnoremap("<Esc>", function() vim.cmd "noh" return "<esc>" end, silent)
--stylua: ignore
UtilKey.vnoremap("<Esc>", function() UtilKey.feedkey "<C-c>" vim.cmd "noh" return "<esc>" end, silent)

--stylua: ignore
UtilKey.inoremap("hh", function() vim.schedule(function() vim.cmd "nohlsearch" UtilKey.actions.snippet_stop() UtilKey.feedkey "<Esc>" end) end, silent)
--stylua: ignore
UtilKey.snoremap("hh", function() vim.schedule(function() vim.cmd "nohlsearch" UtilKey.actions.snippet_stop() UtilKey.feedkey "<Esc>" end) end, silent)

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                    FOLD                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--stylua: ignore
UtilKey.nnoremap("zb", function() UtilFold.cycle_fold_level() end, { desc = "Fold: cycle level (state-aware)" })
--stylua: ignore
UtilKey.nnoremap("zf", function() UtilFold.focus_current() end, { desc = "Fold: focus current (respect cycle level)" })
--stylua: ignore
UtilKey.nnoremap("zM", function() UtilFold.close_all() end, { desc = "Fold: close all (level tersimpan)" })
--stylua: ignore
UtilKey.nnoremap("zR", function() UtilFold.open_all() end, { desc = "Fold: open all (state dipertahankan)" })
--stylua: ignore
UtilKey.nnoremap("zx", function() UtilFold.restore_level() end, { desc = "Fold: restore level sebelum zRUtils.fold" })

-- This works on ghostty+tmux but failed on kitty+tmux,
UtilKey.nnoremap("<Tab>", "za", { desc = "Fold: toggle fold" })
UtilKey.nnoremap("<C-i>", "<C-i>")

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              WINDOW <leader>w                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local arange_wins = UtilWindow.arange_wins
local switch_focus_targeted_window = UtilWindow.switch_focus_targeted_window

UtilKey.nnoremap("<Leader>wv", arange_wins "vsplit", { desc = "Window: vsplit" })
UtilKey.nnoremap("<Leader>ws", arange_wins "split", { desc = "Window: split" })

UtilKey.noremap({ "n", "x" }, "<Leader>ll", switch_focus_targeted_window, { desc = "Window: switch focus" })

UtilKey.nnoremap("<c-w>s", arange_wins "split", { desc = "Window: split" })
UtilKey.nnoremap("<c-w>j", arange_wins "split", { desc = "Window: split (alternative)" })
UtilKey.nnoremap("<c-w>v", arange_wins "vsplit", { desc = "Window: vsplit (alternative)" })
UtilKey.nnoremap("<c-w>l", arange_wins "vsplit", { desc = "Window: vsplit (alternative)" })
--stylua: ignore
UtilKey.nnoremap("<c-w>L", function() if vim.w.is_overlook_popup then arange_wins "vsplit"() end UtilKey.feedkey "<C-w>L" end, { desc = "Window: vsplit (alternative)" })
UtilKey.nnoremap("<c-w>t", arange_wins "tabe", { desc = "Window: move new tab", silent = true })

UtilKey.noremap({ "n", "x" }, "<Leader>wJ", arange_wins "J", { desc = "Window: move ↓" })
UtilKey.noremap({ "n", "x" }, "<Leader>wK", arange_wins "K", { desc = "Window: move ↑" })
UtilKey.noremap({ "n", "x" }, "<Leader>wH", arange_wins "H", { desc = "Window: move ←" })
UtilKey.noremap({ "n", "x" }, "<Leader>wL", arange_wins "L", { desc = "Window: move →" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                   TAB t..                                   ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

UtilKey.nnoremap("tn", function()
  if vim.bo.buftype == "nofile" then
    vim.cmd "tabnew"
    return
  end
  if vim.bo.filetype == "neo-tree" then
    vim.cmd "wincmd p"
  end
  vim.cmd "tabedit %"
end, { desc = "Tab: new tab", silent = true })
UtilKey.nnoremap("tc", "<CMD>tabclose<CR>", { desc = "Tab: close" })
UtilKey.nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Tab: first" })
UtilKey.nnoremap("tL", "<CMD>tablast<CR>", { desc = "Tab: last" })
UtilKey.nnoremap("tl", "<CMD>tabnext<CR>", { desc = "Tab: next" })
UtilKey.nnoremap("th", "<CMD>tabprevious<CR>", { desc = "Tab: prev" })

-- -- Works outside tmux
-- UtilKey.nnoremap("<C-a-l>", "<CMD>tabnext<CR>", { desc = "Tab: next (mod)", silent = true })
-- UtilKey.nnoremap("<C-a-h>", "<CMD>tabprevious<CR>", { desc = "Tab: prev (mod)", silent = true })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              BUFFER <leader>b                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

UtilKey.nnoremap("<Leader>bl", "<C-^>", { desc = "Buffer: last buf (alternate)", silent = true })
UtilKey.nnoremap("<Leader>bw", "<CMD>wincmd =<CR>", { desc = "Buffer: equalize window size", silent = true })

--stylua: ignore
UtilKey.nnoremap("<Leader>bQ", function() UtilWindow._only() Log.info(IconMisc.checklist .. " Purge buffers") end, { desc = "Buffer: kill/purge other buffers" })

UtilKey.nnoremap("<Leader>bk", UtilWindow.magic_quit, { desc = "Buffer: magic exit" })
UtilKey.nnoremap("<Leader>bK", UtilWindow.bufremove, { desc = "Buffer: kill/close buffer" })
UtilKey.nnoremap("<Leader>bN", vim.cmd.E, { desc = "Buffer: new empty" })
UtilKey.nnoremap("<a-x>", "<CMD>q!<CR>", { desc = "Buffer: force to quit (without save)", silent = true })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                               HELP <leader>h                                ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--stylua: ignore
UtilKey.nnoremap("<Leader>hR", function() vim.cmd [[wall!]] vim.cmd [[restart]] end, { desc = "Help: restart nvim" }) --stylua: ignore
--stylua: ignore
UtilKey.nnoremap("<Leader>hb", require("utils.map").show_help_buf_keymap, { desc = "Help: show keymaps buffer", silent = true })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              SEARCH <leader>s                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local replace_keymap = require("utils.map").search_replace_keymap
UtilKey.nnoremap("<Leader>xR", replace_keymap, { desc = "Exec: replace string under cursor" })
UtilKey.xnoremap("<Leader>xR", [["zy:%s/\v\V<C-r><C-o>z/]], { desc = "Exec: replace string under cursor" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                               OPEN <leader>o                                ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--stylua: ignore
UtilKey.noremap({ "n", "x" }, "<Leader>ob", function() require("utils.cmd").open_with "browser" end, { desc = "Open: lookup in browser" })
--stylua: ignore
UtilKey.noremap({ "n", "x" }, "<Leader>oB", function() require("utils.cmd").open_with "mpv or svix" end, { desc = "Open: open-with" })
--stylua: ignore
UtilKey.noremap({ "n", "x" }, "<Leader>oe", function() require("utils.cmd").open_with "go to file" end, { desc = "Open: under cursor" })
--stylua: ignore
UtilKey.noremap({ "n", "x" }, "<Leader>ov", function() require("utils.cmd").open_with("go to file", "vsplit") end, { desc = "Open: under cursor vsplit" })

--stylua: ignore
UtilKey.nnoremap("<Leader>oR", function() RUtils.cmd.browse_this_error(true) end, { desc = "Open: lookup error online" })
--stylua: ignore
UtilKey.xnoremap("<Leader>oR", function() RUtils.cmd.browse_this_error(true) end, { desc = "Open: lookup error online (visual)" })

UtilKey.nnoremap("<Leader>oU", function()
  if not package.loaded["undotree"] then
    vim.cmd "packadd nvim.undotree "
  end
  require("utils.layout").toggle_sidebar("nvim-undotree", function()
    require("undotree").open()
  end, true)
end, { desc = "Open: undotree" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              TOGGLE <leader>u                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

UtilKey.nnoremap("<Leader>ul", require("utils.layout").disable, { desc = "Toggle: disable/enable layout" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                  TERMINAL                                   ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--stylua: ignore
UtilKey.tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
--stylua: ignore
UtilKey.tnoremap("<a-x>", function() local buf = vim.api.nvim_get_current_buf() require("bufdelete").bufdelete(buf, true) end, { desc = "Terminal: close", silent = true })
--stylua: ignore
UtilKey.tnoremap("<C-a-l>", function() UtilKey.feedkey("<C-\\><C-n><C-a-l>", "t") end, { desc = "Terminal: next tab" })
--stylua: ignore
UtilKey.tnoremap("<C-a-h>", function() UtilKey.feedkey("<C-\\><C-n><C-a-h>", "t") end, { desc = "Terminal: prev tab" })

-- stylua: ignore
UtilKey.tnoremap("<c-Left>", function() UtilKey.feedkey("<C-\\><C-n><C-w>h", "t") end, { desc = "Terminal: move left" })
-- stylua: ignore
UtilKey.tnoremap("<c-Down>", function() UtilKey.feedkey("<C-\\><C-n>:wincmd j<CR>", "t") end, { desc = "Terminal: move down" })
-- stylua: ignore
UtilKey.tnoremap("<c-Up>", function() UtilKey.feedkey("<C-\\><C-n><C-w>k", "t") end, { desc = "Terminal: move up" })
-- stylua: ignore
UtilKey.tnoremap("<c-Right>", function() UtilKey.feedkey("<C-\\><C-n>:wincmd l<CR>", "t") end, { desc = "Terminal: move right" })

-- ├──────────────────────────────────┤ OPEN ├──────────────────────────────────┤
-- ════════════════════════════════ TOGGLE TERM ═════════════════════════════
-- stylua: ignore
UtilKey.noremap({ "n", "x", "t" }, "<a-v>", UtilTerm.toggle_term, { desc = "Terminal: toggle [ergoterm]" })

-- ══════════════════════════════════ TAB TERM ══════════════════════════════════
-- stylua: ignore
UtilKey.noremap({ "n", "x", "t" }, "<a-N>", UtilTerm.tab_term, { desc = "Terminal: tab [ergoterm]" })
-- stylua: ignore
UtilKey.noremap({ "n", "x", "t" }, "<C-Space>l", UtilTerm.open_right, { desc = "Terminal: right [ergoterm]" })
-- stylua: ignore
UtilKey.noremap({ "n", "x", "t" }, "<C-Space>j", UtilTerm.open_below, { desc = "Terminal: below [ergoterm]" })

-- ═════════════════════════════════ FLOAT TERM ═════════════════════════════════
-- stylua: ignore
UtilKey.noremap({ "n", "x", "t" }, "T", UtilTerm.open_float, { desc = "Terminal: float [ergoterm]" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                 COMMANDLINE                                 ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

UtilKey.cnoremap("hh", "<Esc>", { desc = "Commandline: exit" })
UtilKey.cnoremap("<a-a>", "<Home>", { desc = "Commandline: start" })
UtilKey.cnoremap("<a-e>", "<End>", { desc = "Commandline: end" })
UtilKey.cnoremap("<a-h>", "<Left>", { desc = "Commandline: left" })
UtilKey.cnoremap("<a-l>", "<Right>", { desc = "Commandline: right" })
UtilKey.cnoremap("<a-b>", "<S-Left>", { desc = "Commandline: back word" })
UtilKey.cnoremap("<a-f>", "<S-Right>", { desc = "Commandline: forwaaard word" })

UtilKey.cabbrev("BD", "bd!")
UtilKey.cabbrev("Bd", "bd!")
UtilKey.cabbrev("Bd", "bd!")
UtilKey.cabbrev("Q!!", "q!")
UtilKey.cabbrev("Q!", "q!")
UtilKey.cabbrev("Q", "q")
UtilKey.cabbrev("Qal", "qal!")
UtilKey.cabbrev("Ql", "qal!")
UtilKey.cabbrev("Qla", "qal!")
UtilKey.cabbrev("W!", "update!")
UtilKey.cabbrev("W", "update!")
UtilKey.cabbrev("W;", "update!")
UtilKey.cabbrev("WQ", "up")
UtilKey.cabbrev("Wq", "wq")
UtilKey.cabbrev("bD", "bd!")
UtilKey.cabbrev("bd", "bd!")
UtilKey.cabbrev("q!!", "q!")
UtilKey.cabbrev("ql", "q!")
UtilKey.cabbrev("qla", "qal!")
UtilKey.cabbrev("w;", "update!")

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                   SCROLL                                    ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

-- Scroll with magic jump
--stylua: ignore
UtilKey.nnoremap("<a-n>", function() UtilKey.magic_jump() end, { desc = "Scroll: magic jump" })
--stylua: ignore
UtilKey.nnoremap("<a-p>", function() UtilKey.magic_jump(true) end, { desc = "Scroll: magic jump" })

UtilKey.nnoremap(
  "zz",
  [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
  { expr = true, desc = "Scroll: center cursor window" }
)

-- Scroll step sideways
local scroll = {
  horizontal_small = 20, -- columns moved by zl / zh
  horizontal_large = 50, -- columns moved by zL / zH
  nudge_lines = 2, -- lines moved by <C-e> / <C-y>  (nudge)
}

UtilKey.nnoremap("zl", scroll.horizontal_small .. "zl", { desc = "Scroll: right (small)" })
UtilKey.nnoremap("zh", scroll.horizontal_small .. "zh", { desc = "Scroll: left (small)" })
UtilKey.nnoremap("zL", scroll.horizontal_large .. "zl", { desc = "Scroll: right (large)" })
UtilKey.nnoremap("zH", scroll.horizontal_large .. "zh", { desc = "Scroll: left (large)" })

-- ---------------------------------------------------------------------------
-- Nudge  <C-e> / <C-y>
-- Viewport shifts by `nudge_lines`; cursor does not move.
-- Falls back to j/k when already at the buffer edge.
-- ---------------------------------------------------------------------------

UtilKey.nnoremap("<C-e>", function()
  local at_end = vim.fn.line "w$" >= vim.fn.line "$"
  local motion = at_end and (scroll.nudge_lines .. "j") -- at buffer end: move cursor instead
    or (scroll.nudge_lines .. "\5") -- \5 = <C-e>
  vim.cmd("normal! " .. motion)
end, { desc = "Scroll: nudge down (viewport)" })

UtilKey.nnoremap("<C-y>", function()
  local at_top = vim.fn.line "w0" <= 1
  local motion = at_top and (scroll.nudge_lines .. "k") -- at buffer top: move cursor instead
    or (scroll.nudge_lines .. "\25") -- \25 = <C-y>
  vim.cmd("normal! " .. motion)
end, { desc = "Scroll: nudge up (viewport)" })

-- ---------------------------------------------------------------------------
-- Step  <C-d> / <C-u>
-- Half-page scroll; cursor follows the viewport (standard vim behavior).
-- Falls back to j/k when already at the buffer edge.
-- ---------------------------------------------------------------------------

UtilKey.nnoremap("<C-d>", function()
  local half = math.max(math.floor(vim.api.nvim_win_get_height(0) / 2), 1)
  local at_end = vim.fn.line "w$" >= vim.fn.line "$"
  local motion = at_end and (half .. "j") -- at buffer end: just move cursor down
    or (half .. "\4") -- \4 = <C-d>
  vim.cmd("normal! " .. motion)
end, { desc = "Scroll: step down (half-page)" })

UtilKey.nnoremap("<C-u>", function()
  local half = math.max(math.floor(vim.api.nvim_win_get_height(0) / 2), 1)
  local at_top = vim.fn.line "w0" <= 1
  local motion = at_top and (half .. "k") -- at buffer top: just move cursor up
    or (half .. "\21") -- \21 = <C-u>
  vim.cmd("normal! " .. motion)
end, { desc = "Scroll: step up (half-page)" })

-- ---------------------------------------------------------------------------
-- Leap  <C-f> / <C-b>
-- Full viewport scroll (winheight - 2 lines); cursor adjusts to H/M/L.
-- At buffer edges the cursor snaps to L (bottom) or H (top) of window.
-- ---------------------------------------------------------------------------

UtilKey.nnoremap("<C-f>", function()
  local lines = math.max(vim.api.nvim_win_get_height(0) - 2, 1)
  local at_end = vim.fn.line "w$" >= vim.fn.line "$"
  -- \4 = <C-d>; repeat `lines` times to approximate a full-page leap
  vim.cmd("normal! " .. lines .. "\4" .. (at_end and "L" or "M"))
end, { desc = "Scroll: leap down (full-page)" })

UtilKey.nnoremap("<C-b>", function()
  local lines = math.max(vim.api.nvim_win_get_height(0) - 2, 1)
  local at_top = vim.fn.line "w0" <= 1
  -- \21 = <C-u>; repeat `lines` times to approximate a full-page leap
  vim.cmd("normal! " .. lines .. "\21" .. (at_top and "H" or "M"))
end, { desc = "Scroll: leap up (full-page)" })

-- Allow moving the cursor through wrapped lines using j and k,
-- note that I have line wrapping turned off but turned on only for Markdown
local function smart_move(dir)
  local count = vim.v.count
  local mode = vim.api.nvim_get_mode().mode
  local is_op = mode:match "no"
  local move = (count == 0 and not is_op) and ("g" .. dir) or dir
  local mark = count > 5 and "m'" or ""
  return mark .. move
end

-- stylua: ignore
UtilKey.nnoremap("j", function() return smart_move "j" end, { expr = true })
-- stylua: ignore
UtilKey.nnoremap("k", function() return smart_move "k" end, { expr = true })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                    DIFF                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

-- =============================================================================
-- Compare Clipboard vs Visual Selection
--
-- Workflow:
--   1. Yank a function (from anywhere: file, git history, etc.)
--   2. Visual-select the function you want to compare in the current file
--   3. <Leader>gv
--   4. A new tab opens with two scratch buffers side-by-side:
--        left  = your visual selection
--        right = your yanked clipboard
--      Both buffers share the filetype of the original file so treesitter
--      and syntax highlighting work correctly.
--   5. Press <q> in either pane to close the whole tab.
-- =============================================================================

-- Create a scratch buffer in the current window.
-- Filetype is set BEFORE content is pasted so treesitter attaches properly.
---@param ftype string   original filetype to apply
---@param content string[] lines to paste into the buffer
local function open_scratch(ftype, content)
  vim.cmd "enew"
  local buf = vim.api.nvim_get_current_buf()

  -- Set filetype first → treesitter parser attaches to an empty buffer,
  -- then content arrives and highlighting is already active.
  vim.bo[buf].filetype = ftype
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

  -- Close tab with <q>; map only for this buffer
  vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = buf, desc = "Diff: close compare tab" })

  return buf
end

vim.api.nvim_create_user_command("CompareClipboardSelection", function()
  local ftype = vim.bo.filetype -- capture before switching buffers

  -- Yank the visual selection into register z
  vim.cmd [[normal! gv"zy]]

  local selection = vim.fn.getreg "z"
  local clipboard = vim.fn.getreg "+"

  local sel_lines = vim.split(selection, "\n", { plain = true })
  local clip_lines = vim.split(clipboard, "\n", { plain = true })

  -- Open a new tab for the diff view
  vim.cmd "tabnew"

  -- Left pane: visual selection
  open_scratch(ftype, sel_lines)
  vim.cmd "diffthis"

  -- Right pane: clipboard (yanked function)
  vim.cmd "vsplit"
  open_scratch(ftype, clip_lines)
  vim.cmd "diffthis"

  -- Start on the left pane
  vim.cmd "wincmd h"
end, {
  nargs = 0,
  range = true,
})

--stylua: ignore
UtilKey.xnoremap("<Leader>gv", "<esc><cmd>CompareClipboardSelection<cr>", { desc = "Git: compare selection vs clipboard" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                    MISC                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

-- UtilKey.vmap("K", "<Nop>")
-- UtilKey.nmap("K", "<Nop>")
UtilKey.nmap("q", "<Nop>")

-- Snacks.toggle.zoom():map "<Leader>mm"
--
UtilKey.nnoremap("<Leader>n", function()
  -- convert into lua: "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  vim.cmd "nohlsearch"
  vim.cmd "diffupdate"

  -- clean up vim-highlighter
  local ok, _ = require("utils.plugin").require(vim.fn.HiList)
  if ok then
    local Hilist = vim.fn.HiList()
    if Hilist and #Hilist > 0 then
      vim.cmd "Hi -"
    end
  end

  UtilKey.actions.snippet_stop()
end, { desc = "Misc: redraw / clear hlsearch / diff update" })

--stylua: ignore
UtilKey.nnoremap("*", function() local word = vim.fn.expand "<cword>" vim.fn.setreg("/", "\\v" .. word) vim.o.hlsearch = true end, { remap = true, desc = "Misc: search word under cursor (no jump)" })
--stylua: ignore
UtilKey.nnoremap("dd", function() if vim.fn.getline "." == "" then return '"_dd' end return "dd" end, { expr = true })

-- It works better with "Very Magic", but it still doesn't work well with blink.
-- [[<Esc>/\v%V]])
--  "/\\v")
UtilKey.xnoremap("<C-g>", [[<Esc>/%V]]) --search within visual selection
UtilKey.nnoremap("<C-g>", "/", nosilent)

UtilKey.nnoremap("~", "%", { desc = "Misc: go to.. matching tag" })
UtilKey.nnoremap("g,", "g,zvzz", silent) -- go last edit
UtilKey.nnoremap("g;", "g;zvzz", silent) -- go prev edit

UtilKey.xnoremap(">", ">gv", { desc = "Misc: next align lines (visual)" })
UtilKey.xnoremap("<", "<gv", { desc = "Misc: prev align lines (visual)" })
UtilKey.nnoremap("vv", [[^vg_]], { desc = "Misc: select text lines" })

--stylua: ignore
UtilKey.nnoremap("<Leader>cd", function() local filepath = fn.expand "%:p:h" vim.cmd(fmt("cd %s", filepath)) vim.notify(fmt("ROOT CHANGED: %s", filepath)) end, { desc = "Action: cd to file" })
--stylua: ignore
UtilKey.nnoremap("<Leader>cy", function() local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or "" vim.fn.setreg("+", path) vim.notify(path, vim.log.levels.INFO, { title = "Copy current path" }) end, { silent = true, desc = "Action: copy path buffer" })
UtilKey.nnoremap("<Leader>xP", function()
  local cwd = vim.fn.expand "%:p:h"
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  ---@diagnostic disable-next-line: undefined-field
  Log.info(cwd .. "/" .. fname)
end, { desc = "Exec: printout current path" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
UtilKey.nnoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
UtilKey.xnoremap("n", "'Nn'[v:searchforward]", { expr = true, desc = "Misc: next search result" })
UtilKey.onoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
UtilKey.nnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
UtilKey.xnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
UtilKey.onoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                    NOTES                                    ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

UtilKey.nnoremap("<Localleader>aft", require("utils.note").filter_by_tags, { desc = "Note: find notes by tag" })
UtilKey.nnoremap("<Localleader>afl", require("utils.note").last_filter_by_tags, { desc = "Note: repeat tag search" })
UtilKey.nnoremap("<Localleader>aff", require("utils.note").find_files_notes, { desc = "Note: find note files" })
UtilKey.nnoremap("<Localleader>afg", require("utils.note").live_grep, { desc = "Note: live grep" })
UtilKey.vnoremap("<Localleader>afg", require("utils.note").live_grep_visual, { desc = "Note: live grep (visual)" })

-- -- UtilKey.nnoremap("<Localleader>a<F5>", RUtils.notes.get_note_mode, { desc = "Note: show note mode" })
--stylua: ignore
UtilKey.nnoremap( "<Localleader>aS", require("utils.note").swith_note_mode, { desc = "Note: swith note mode org or markdown" })

-- -- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- -- ╏                                  COMMANDS                                   ╏
-- -- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
--
-- -- RUtils.create_command("Snippets", RUtils.cmd.edit_snippet, { desc = "Misc: edit snippet file" })
-- -- RUtils.create_command("ChangeMasterTheme", RUtils.cmd.change_colors, { desc = "Misc: set theme bspwm" })
--
-- --stylua: ignore
-- RUtils.create_command("InfoOption", function() vim.cmd "options" end, { desc = "Misc: echo options" })
--
-- --stylua: ignore
-- vim.api.nvim_create_user_command("LspLog", function() vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename())) end, { desc = "Show LSP client log" })
-- --stylua: ignore
-- vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Show LSP info" })
--
-- vim.api.nvim_create_user_command("DFile", function()
--   local has_fzf, fzf = pcall(require, "fzf-lua")
--
--   if has_fzf then
--     -- Get current file path relative to git root
--     local current_file = vim.fn.expand "%:p"
--     local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
--     local relative_path = current_file:sub(#git_root + 2) -- +2 to account for trailing slash
--
--     -- Use fzf-lua for commit selection
--     fzf.git_commits {
--       prompt = "Select commit> ",
--       cmd = string.format("git log --oneline --decorate --color=always %s", vim.fn.shellescape(relative_path)),
--       actions = {
--         ["alt-u"] = function(selected)
--           if selected and selected[1] then
--             -- Extract commit hash from the first word of the selected line
--             local commit_hash = selected[1]:match "^([^ ]+)"
--             if commit_hash then
--               vim.cmd(
--                 string.format("DiffviewOpen %s^ -- %s", commit_hash, current_file, vim.fn.shellescape(relative_path))
--               )
--             end
--           end
--         end,
--         ["default"] = function(selected)
--           if selected and selected[1] then
--             -- Extract commit hash from the first word of the selected line
--             local commit_hash = selected[1]:match "^([^ ]+)"
--             if commit_hash then
--               vim.cmd(
--                 string.format("DiffviewOpen %s^ -- %s", commit_hash, current_file, vim.fn.shellescape(relative_path))
--               )
--             end
--           end
--         end,
--       },
--       winopts = {
--         preview = { horizontal = "right:70%" }, -- right|left:size
--         title = "Changes of file against Commits - Selecting end change on right",
--       },
--       preview_pager = string.format(
--         "git diff {1}^..{1} -- %s | delta --features=commit-hashes --commit-style=box --side-by-side --width ${FZF_PREVIEW_COLUMNS-$COLUMNS}",
--         vim.fn.shellescape(relative_path)
--       ),
--     }
--   end
-- end, {})
--
-- local ctrl_o_nvim = function()
--   RUtils.fzflua.open_cmd_bulk_key_only({
--     ["Clock mode"] = function()
--       RUtils.terminal.clock_mode("clock", true)
--     end,
--     ["Pomodoro 1h"] = function()
--       RUtils.terminal.clock_mode { pomodoro = { timer = "1h" } }
--     end,
--     ["Pomodoro 25m"] = function()
--       RUtils.terminal.clock_mode { pomodoro = { timer = "25m" } }
--     end,
--     ["Pomodoro 10m"] = function()
--       RUtils.terminal.clock_mode { pomodoro = { timer = "10m" } }
--     end,
--     ["Layout width toggle"] = function()
--       RUtils.layout.disable()
--     end,
--     ["News"] = function()
--       RUtils.terminal.float_newsboat()
--     end,
--     ["Calendar"] = function()
--       RUtils.terminal.float_calcure()
--     end,
--     ["Btop"] = function()
--       RUtils.terminal.float_btop()
--     end,
--     ["Rust upserv"] = function()
--       print "sf"
--     end,
--     ["Rust upserv2"] = function()
--       print "sf"
--     end,
--     ["Rust benc"] = function()
--       print "sf"
--     end,
--     ["Grav term"] = function()
--       print "sf"
--     end,
--     ["Log meta"] = function()
--       print "sf"
--     end,
--     ["R-kill"] = function()
--       RUtils.terminal.float_rkill()
--     end,
--   }, { winopts = { title = RUtils.fzflua.format_title("Alt-Y", RUtils.config.icons.misc.circle) } })
-- end
--
-- UtilKey.nnoremap("<a-s-y>", ctrl_o_nvim, { desc = "Bulk: alt_Y commands" })
-- UtilKey.tnoremap("<a-s-y>", ctrl_o_nvim, { desc = "Bulk: alt_Y commands" })
-- UtilKey.xnoremap("<a-s-y>", ctrl_o_nvim, { desc = "Bulk: alt_Y commands (visual)" })
--
-- local bulk_cmd_misc = function()
--   local cmds = {
--     ["Screenkey - open screenkey on nvim"] = function()
--       cmd "Screenkey"
--     end,
--     ["PDFview - open pdf with nvim"] = function()
--       require("pdfview").menu()
--     end,
--     ["tailwindcss.com - open in browser"] = function()
--       cmd "!open https://tailwindcss.com"
--     end,
--     ["Clock mode - run clock"] = function()
--       RUtils.terminal.clock_mode("clock", true)
--     end,
--     ["Pomodoro 1h - work 1hour"] = function()
--       RUtils.terminal.clock_mode { pomodoro = { timer = "1h" } }
--     end,
--     ["Pomodoro 25m - work 25minutes"] = function()
--       RUtils.terminal.clock_mode { pomodoro = { timer = "25m" } }
--     end,
--     ["Pomodoro 10m - work 10minutes"] = function()
--       RUtils.terminal.clock_mode { pomodoro = { timer = "10m" } }
--     end,
--     ["TestNotify - runt tess notification"] = function()
--       -- to replace an existing notification just use the same id.
--       -- you can also use the return value of the notify function as id.
--       for i = 1, 10 do
--         vim.defer_fn(function()
--           vim.notify("Hello " .. i, "info", { id = "test" })
--         end, i * 500)
--       end
--
--       RUtils.info "this RUtils info"
--       RUtils.warn "this RUtils warn"
--       RUtils.error "this RUtils error"
--     end,
--     ["Browser devdocs - with input"] = function()
--       local ok, query = pcall(vim.fn.input, "Search DevDocs: ")
--       if not ok or not query or query == "" then
--         return
--       end
--
--       local encoded_url = string.format('open "https://devdocs.io/#q=%s"', query:gsub(" ", "%%20"))
--       os.execute(encoded_url)
--     end,
--     ["Treesitter - open inspect tree under cursor"] = function()
--       vim.treesitter.inspect_tree()
--       vim.api.nvim_input "I"
--     end,
--   }
--
--   if RUtils.has "candela.nvim" then
--     cmds["Candela - add color for log highlights"] = function()
--       if not vim.tbl_contains({ "log", "bigfile" }, vim.bo.filetype) then
--         RUtils.warn "Not log file!"
--         return
--       end
--
--       local CandelaUi = require "candela.ui"
--       CandelaUi.toggle()
--     end
--   end
--
--   RUtils.fzflua.open_cmd_bulk_center(
--     cmds,
--     { winopts = { title = RUtils.fzflua.format_title("Open Commands", RUtils.config.icons.misc.fire) } }
--   )
-- end
--
-- UtilKey.nnoremap("<Leader>oF", bulk_cmd_misc, { desc = "Bulk: open commands" })
-- UtilKey.tnoremap("<Leader>oF", bulk_cmd_misc, { desc = "Bulk: open commands" })
-- UtilKey.xnoremap("<Leader>oF", bulk_cmd_misc, { desc = "Bulk: open commands (visual)" })
--
-- local bulk_cmd_git = function()
--   RUtils.fzflua.open_cmd_bulk_center({
--     ["Diffview - open DiffviewOpen"] = function()
--       vim.cmd [[DiffviewOpen]]
--     end,
--     ["Diffview - open DiffviewFileHistory repo"] = function()
--       vim.cmd [[DiffviewFileHistory]]
--     end,
--     ["Diffview - open DiffviewFileHistory curbuf"] = function()
--       vim.cmd [[DiffviewFileHistory --follow %]]
--     end,
--     ["Diffview - open DiffviewFileHistory line"] = function()
--       vim.cmd [[DiffviewFileHistory --follow]]
--     end,
--     ["Codediff - open VscodeDiff"] = function()
--       vim.cmd [[VscodeDiff]]
--     end,
--     ["Diff - windo this"] = function()
--       vim.cmd [[windo diffthis]]
--     end,
--     ["GH - open PR"] = function()
--       vim.cmd [[GHOpenPR]]
--     end,
--     ["GH - open issue"] = function()
--       vim.cmd [[GHOpenIssue]]
--     end,
--     ["GitWorktree - create"] = function()
--       vim.cmd [[lua require("telescope").extensions.git_worktree.create_git_worktrees()]]
--     end,
--     ["GitWorktree - manage"] = function()
--       vim.cmd [[lua require("telescope").extensions.git_worktree.git_worktrees()]]
--     end,
--     ["GitConflict - refresh"] = function()
--       vim.cmd [[GitConflictRefresh]]
--     end,
--     ["GitConflict - send list to qf"] = function()
--       vim.cmd [[GitConflictListQf]]
--     end,
--     ["GitConflict - choosing ours (current)"] = function()
--       ---@diagnostic disable-next-line: undefined-field
--       RUtils.info("Choosing ours (current)", { title = "GitConflict" })
--       vim.cmd [[GitConflictChooseOurs]]
--     end,
--     ["GitConflict - choosing theirs (incoming)"] = function()
--       ---@diagnostic disable-next-line: undefined-field
--       RUtils.info("Choosing theirs (incoming)", { title = "GitConflict" })
--       vim.cmd [[GitConflictChooseTheirs]]
--     end,
--     ["GitConflict - choosing none of them (deleted)"] = function()
--       ---@diagnostic disable-next-line: undefined-field
--       RUtils.info("Choosing none of them (deleted)", { title = "GitConflict" })
--       vim.cmd [[GitConflictChooseNone]]
--     end,
--     ["GitSigns - show blame"] = function()
--       local gs = package.loaded.gitsigns
--       gs.blame()
--     end,
--     ["GitSigns - toggle diff deleted"] = function()
--       local gs = package.loaded.gitsigns
--       gs.toggle_deleted()
--     end,
--     ["GitSigns - toggle word diff"] = function()
--       local gs = package.loaded.gitsigns
--       gs.toggle_word_diff()
--     end,
--   }, { winopts = { title = RUtils.fzflua.format_title("Git Commands", RUtils.config.icons.git.branch) } })
-- end
--
-- UtilKey.nnoremap("<Leader>gF", bulk_cmd_git, { desc = "Bulk: git commands" })
-- UtilKey.tnoremap("<Leader>gF", bulk_cmd_git, { desc = "Bulk: git commands" })
-- UtilKey.xnoremap("<Leader>gF", bulk_cmd_git, { desc = "Bulk: git commands (visual)" })
--
-- local bulk_cmd_toggle = function()
--   RUtils.fzflua.open_cmd_bulk_center({
--     ["Layout - toggle sidebar size"] = function()
--       RUtils.layout.disable()
--     end,
--     ["Color highlight - toggle CccHighlighterToggle"] = function()
--       vim.cmd.CccHighlighterToggle()
--     end,
--     ["Outline - toggle auto follow"] = function()
--       vim.cmd.OutlineToggleFollow()
--     end,
--     ["VimHighlighter - clear all"] = function()
--       local ok, _ = pcall(vim.fn.HiList)
--       if ok then
--         local Hilist = vim.fn.HiList()
--         if Hilist and #Hilist > 0 then
--           vim.cmd "Hi clear"
--           return
--         end
--       end
--       RUtils.info "No active highlights to clear"
--     end,
--     ["Treesitter - toggle highlight"] = function()
--       Snacks.toggle.treesitter()
--     end,
--   }, { winopts = { title = RUtils.fzflua.format_title("Toggle Commands", RUtils.config.icons.misc.tools) } })
-- end
--
-- UtilKey.nnoremap("<Leader>uF", bulk_cmd_toggle, { desc = "Bulk: toggle commands" })
-- UtilKey.tnoremap("<Leader>uF", bulk_cmd_toggle, { desc = "Bulk: toggle commands" })
-- UtilKey.xnoremap("<Leader>uF", bulk_cmd_toggle, { desc = "Bulk: toggle commands (visual)" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              TMUX INTEGRATION                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

-- --stylua: ignore
-- UtilKey.nnoremap("<a-B>", function() RUtils.terminal.float_btop() end, { desc = "CTRL_o: btop" })
-- --stylua: ignore
-- UtilKey.tnoremap("<a-B>", function() RUtils.terminal.float_btop() end, { desc = "CTRL_o: btop (terminal)" })
-- --stylua: ignore
-- UtilKey.nnoremap("<a-Z>", function() RUtils.terminal.float_resterm() end, { desc = "CTRL_o: resterm" })
-- --stylua: ignore
-- UtilKey.tnoremap("<a-Z>", function() RUtils.terminal.float_resterm() end, { desc = "CTRL_o: resterm (terminal)" })
-- --stylua: ignore
-- UtilKey.nnoremap("<a-C>", function() RUtils.terminal.float_rkill() end, { desc = "CTRL_o: rkill" })
-- --stylua: ignore
-- UtilKey.tnoremap("<a-C>", function() RUtils.terminal.float_rkill() end, { desc = "CTRL_o: rkill (terminal)" })
-- --stylua: ignore
-- UtilKey.nnoremap("<a-D>", function() RUtils.terminal.lazydocker() end, { desc = "CTRL_o: lazydocker" })
-- --stylua: ignore
-- UtilKey.tnoremap("<a-D>", function() RUtils.terminal.lazydocker() end, { desc = "CTRL_o: lazydocker (terminal)" })
-- --stylua: ignore
-- UtilKey.nnoremap("<a-G>", function() RUtils.terminal.lazygit() end, { desc = "CTRL_o: lazygit" })
-- --stylua: ignore
-- UtilKey.tnoremap("<a-G>", function() RUtils.terminal.lazygit() end, { desc = "CTRL_o: lazygit (terminal)" })
-- --stylua: ignore
-- UtilKey.nnoremap("<a-W>", function() RUtils.terminal.float_note() end, { desc = "CTRL_o: open notes" })
-- --stylua: ignore
-- UtilKey.tnoremap("<a-W>", function() RUtils.terminal.float_note() end, { desc = "CTRL_o: open notes (terminal)" })

-- local get_right_pane_id_wez = function()
--   local result = vim.system({ "wezterm", "cli", "get-pane-direction", "right" }, { text = true }):wait()
--   if result.code ~= 0 then
--     return nil
--   end
--   return vim.trim(result.stdout)
-- end
--
-- ---@class TmuxDirectCmds
-- ---@field close_program string
-- ---@field is_kill boolean
--
-- ---@class TmuxLayoutCmds
-- ---@field command table
-- ---@field pane_id string
-- ---@field program string
-- ---@field direct_command TmuxDirectCmds

UtilKey.nnoremap("<a-E>", function()
  if vim.g.main_layout == "default" or not vim.g.main_layout then
    require("utils.layout").toggle_sidebar("neo-tree", function()
      vim.cmd "Neotree reveal focus"
    end)
    return
  end

  -- local dirname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":h:p")

  -- +-----------------------------------------------------------------------------+
  -- |                                   WEZTERM                                   |
  -- +-----------------------------------------------------------------------------+
  -- if not RUtils.tmux.is_tmux then
  --   if RUtils.tmux.is_terminal ~= "wezterm" then
  --     if RUtils.has "neo-tree.nvim" then
  --       vim.cmd "Neotree focus reveal right"
  --       return
  --     end
  --   end
  --
  --   local pane_right_id = get_right_pane_id_wez()
  --   if pane_right_id then
  --     vim.system { "wezterm", "cli", "kill-pane", "--pane-id", pane_right_id }
  --   end
  --
  --   vim.system { "wezterm", "cli", "split-pane", "--right", "--percent", "22" }
  --   vim.system { "sleep", "0.5" }
  --   vim.system { "wezterm", "cli", "activate-pane-direction", "left" }
  --
  --   pane_right_id = get_right_pane_id_wez()
  --   if pane_right_id then
  --     vim.system {
  --       "wezterm",
  --       "cli",
  --       "send-text",
  --       "--pane-id",
  --       pane_right_id,
  --       "--no-paste",
  --       fm_manager .. " " .. dirname .. "\r",
  --     }
  --     vim.system { "wezterm", "cli", "activate-pane-direction", "right" }
  --   end
  --   return
  -- end
  --
  -- -- +-----------------------------------------------------------------------------+
  -- -- |                                    TMUX                                     |
  -- -- +-----------------------------------------------------------------------------+
  --
  -- -- ─[ Resolve pane IDs ]─────────────────────────────────────────────
  --
  -- local current_session = RUtils.tmux.tmux_cmd "tmux display-message -p '#S'"
  -- local current_window = RUtils.tmux.tmux_cmd "tmux display-message -p '#I'"
  -- if not current_session or not current_window then
  --   return
  -- end
  --
  -- local file_manager_pane_id = RUtils.tmux.get_json_field(current_session, current_window, "file_manager_pane_id")
  --
  -- if not file_manager_pane_id or not RUtils.tmux.is_pane_alive(file_manager_pane_id) then
  --   Log.warn "<a-E>: file_manager_pane_id not found or pane dead.\nRun tm-toggle-pane first to create the layout."
  --   return
  -- end
  --
  -- -- ─[ Execute ]──────────────────────────────────────────────────────
  --
  -- local proc = RUtils.tmux.get_pane_process(file_manager_pane_id)
  -- if proc == fm_manager then
  --   vim.system { "sh", "-c", "tmux send-keys -t " .. file_manager_pane_id .. " 'q' Enter" }
  --   RUtils.tmux.wait_for_process(file_manager_pane_id, fm_manager, true) -- tunggu sampai bukan fm_manager
  -- end
  --
  -- proc = RUtils.tmux.get_pane_process(file_manager_pane_id)
  -- if proc == "nvim" then
  --   vim.system { "sh", "-c", "tmux send-keys -t " .. file_manager_pane_id .. " Escape ':qa!' Enter" }
  --   RUtils.tmux.wait_for_process(file_manager_pane_id, "nvim", true) -- tunggu sampai bukan nvim
  -- end
  --
  -- vim.system {
  --   "sh",
  --   "-c",
  --   "tmux send-keys -t " .. file_manager_pane_id .. " '" .. fm_manager .. " " .. dirname .. "' Enter",
  -- }
  --
  -- RUtils.tmux.wait_for_process(file_manager_pane_id, fm_manager, false)
  -- vim.system { "tmux", "select-pane", "-t", file_manager_pane_id }
end)
