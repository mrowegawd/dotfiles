local silent = { silent = true }
local nosilent = { silent = false }

local fn, cmd, fmt = vim.fn, vim.cmd, string.format

local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ EDITING TEXT                                             │
-- ╰──────────────────────────────────────────────────────────╯
-- jk is escape, THEN move to the right to preserve the cursor position, unless
-- at the first column.  <esc> will continue to work the default way.
-- NOTE: this is a recursive mapping so anything bound (by a plugin) to <esc> still works
RUtils.map.inoremap("hh", [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })
-- RUtils.map.imap("kj", [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })
-- RUtils.map.inoremap("hh", "<Esc>", silent)

RUtils.map.inoremap("<c-c>", "<Esc>", silent)
RUtils.map.inoremap("<c-a>", "<c-O>^", silent)
RUtils.map.inoremap("<c-e>", "<c-O>$", silent)
RUtils.map.inoremap("<c-d>", "<c-O>dw", silent)

RUtils.map.nnoremap("g,", "g,zvzz", silent) -- go last edit
RUtils.map.nnoremap("g;", "g;zvzz", silent) -- go prev edit
-- Avoid or don't yank on visual paste
RUtils.map.vnoremap("p", "pgvy")
RUtils.map.nnoremap("<Leader>Y", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or ""
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Yanked absolute path" })
end, { silent = true, desc = "Misc: yank absolute path" })
RUtils.map.nnoremap("Y", "y$", { desc = "Yank to end of line" })

-- RUtils.map.inoremap("<c-j>", "<Down>", silent)
-- RUtils.map.inoremap("<c-k>", "<Up>", silent)

RUtils.map.inoremap("<c-l>", "<Right>", silent)
RUtils.map.inoremap("<c-h>", "<Left>", silent)

RUtils.map.inoremap("<c-b>", "<Esc>ba", silent)
RUtils.map.inoremap("<c-f>", "<Esc>ea", silent)

RUtils.map.nnoremap("<c-g>", "/", nosilent)

if not RUtils.has "bufferline.nvim" then
  RUtils.map.nnoremap("gl", "<cmd>bnext<CR>", silent)
  RUtils.map.nnoremap("gh", "<cmd>bprev<CR>", silent)
end

-- Automatically indent with i and A made by ycino
-- inoremap("i", function()
--   return string.len(vim.api.nvim_get_current_line()) ~= 0 and "i" or '"_cc'
-- end, moresilent)
-- inoremap("A", function()
--   return string.len(vim.api.nvim_get_current_line()) ~= 0 and "A" or '"_cc'
-- end, moresilent)

-- ╭──────────────────────────────────────────────────────────╮
-- │ MARKS                                                    │
-- ╰──────────────────────────────────────────────────────────╯
-- Map gm to `. Instead of `a, hit gma. See :help mark-motions as to why we use backtick.
-- nnoremap("gm", "`", { noremap = false })

-- Easy to remember when do marks stuff
-- if not pcall(require, "fzf-lua") then
--   nnoremap("<Leader>mc", ":norm `.<CR>", { desc = "Marks: jump to last change" })
--   nnoremap("<Leader>mi", ":norm `^<CR>", { desc = "Marks: jump to last insert" })
--   nnoremap("<Leader>mj", ":norm `'<CR>", { desc = "Marks: jump to last jump" })
-- end

-- Always do center win, when do jump <c-o/i>
-- nnoremap("<c-o>", "<c-o>zz")
-- nnoremap("<c-i>", "<c-i>zz")

-- ╭──────────────────────────────────────────────────────────╮
-- │ FOLDS                                                    │
-- ╰──────────────────────────────────────────────────────────╯
-- Focus the current fold by closing all others
-- RUtils.map.nnoremap("<space><space>", "zMzvzO", { desc = "Fold: focus the current fold by closing all others" })
RUtils.map.nnoremap("<space><space>", "za", { desc = "Fold: focus the current fold by closing all others" })
-- RUtils.map.nnoremap("<space><space>", "zo", { desc = "Fold: open fold" })
RUtils.map.nnoremap("zm", "zM", { desc = "Fold: close all" })
-- RUtils.map.nnoremap("<BS>", "za")

-- Make zO recursively open whatever top level fold we're in, no matter where the
-- cursor happens to be.
-- nnoremap("zO", [[zCzO]], { desc = " fold: recursively zO" })

-- Jump next/prev to closing fold
RUtils.map.nnoremap("<a-n>", function()
  return RUtils.fold.magic_prev_next_move()
end, { desc = "Fold: go next closed" })
RUtils.map.nnoremap("<a-p>", function()
  return RUtils.fold.magic_prev_next_move(true)
end, { desc = "Fold: go prev closed" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ VISUAL                                                   │
-- ╰──────────────────────────────────────────────────────────╯
-- Cara mudah untuk cursor dari bawah ke atas dalam visual mode
RUtils.map.xnoremap("il", "<Esc>^vg_", { desc = "View: dont mistake (x)" })
RUtils.map.onoremap("il", "<CMD><C-U>normal! ^vg_<CR>", { desc = "View: dont mistake (o)" })

RUtils.map.xnoremap("al", "$o0", { desc = "View: jump in (x)" })
RUtils.map.onoremap("al", "<CMD><C-u>normal val<CR>", { desc = "View: jump out (o)" })

RUtils.map.nnoremap("vv", [[^vg_]], { desc = "View: select text lines" })
RUtils.map.vnoremap(">", ">gv", { desc = "View: next align lines (visual)" })
RUtils.map.vnoremap("<", "<gv", { desc = "View: prev align lines (visual)" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ MISC                                                     │
-- ╰──────────────────────────────────────────────────────────╯
RUtils.map.nnoremap("~", "%", { desc = "Misc: go to.. matching tag" })

-- RUtils.map.nnoremap("<TAB>", function()
--   if vim.bo.filetype == "fugitive" then
--     print "yes"
--     return RUtils.cmd.feedkey("=", "n")
--   end
--   return RUtils.cmd.feedkey("<TAB>", "n")
-- end, { desc = "togglet up" })

-- nnoremap("<Leader>rf", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], { silent = false, desc = "Misc: search and replace" })

RUtils.map.nnoremap("<Leader>cd", function()
  local filepath = fn.expand "%:p:h" -- code
  cmd(fmt("cd %s", filepath))
  vim.notify(fmt("ROOT CHANGED: %s", filepath))
end, { desc = "Misc: change cur pwd to curfile" })

RUtils.map.nnoremap("<Leader>n", function()
  -- require("notify").dismiss {}
  cmd.nohl()
  -- return cmd [[let @/ = ""]]
end, { desc = "Misc: clear searches" })

RUtils.map.nnoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
RUtils.map.xnoremap("n", "'Nn'[v:searchforward]", { expr = true, desc = "Misc: next search result" })
RUtils.map.onoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
RUtils.map.nnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
RUtils.map.xnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
RUtils.map.onoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })

-- Save jumps > 3 lines to the jumplist
-- Jumps <= 3 respect line wraps
-- RUtils.map.nnoremap("k", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'k' : 'gk']], { expr = true })
-- RUtils.map.nnoremap("j", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'j' : 'gj']], { expr = true })

-- allow moving the cursor through wrapped lines using j and k,
-- note that I have line wrapping turned off but turned on only for Markdown
RUtils.map.nnoremap("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
RUtils.map.nnoremap("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
RUtils.map.vnoremap("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
RUtils.map.vnoremap("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- RUtils.map.nnoremap("j", [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true })
-- RUtils.map.nnoremap("k", [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true })

RUtils.map.nnoremap("<Leader>P", function()
  local cwd = vim.fn.expand "%:p:h"
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  print(cwd .. "/" .. fname)
end, { desc = "Winav: show path curbuf (printout)" })

local function replace_keymap(confirmation, visual)
  local text = [[:%s/]]
  local search_string = ""
  if visual then
    search_string = RUtils.map.getVisualSelection()
  else
    text = text .. [[\<]]
    search_string = vim.fn.expand "<cword>"
  end
  text = text .. RUtils.map.escape(search_string, "[]")
  if not visual then
    text = text .. [[\>]]
  end
  text = text .. "/" .. RUtils.map.escape(search_string, "&")
  if confirmation then
    text = text .. [[/gcI]]
  else
    text = text .. [[/gI]]
  end
  RUtils.map.type_no_escape(text)

  if not_vscode() then
    local move_text = [[<Left><Left><Left>]]
    if confirmation then
      move_text = move_text .. [[<Left>]]
    end
    RUtils.map.type_escape(move_text)
  end
end

RUtils.map.nnoremap("sr", function()
  replace_keymap(false, false)
end, { desc = "Misc: find and replace word under cursor" })

RUtils.map.vnoremap("sr", [["zy:%s/<C-r><C-o>"/]], { desc = "Misc: find and replace word (visual)" })

-- RUtils.map.nnoremap("sc", function()
--   replace_keymap(true, false)
-- end, { desc = "Misc: find and replace word under cursor with confirmation" })
-- RUtils.map.nnoremap("<leader>r", function()
--   replace_keymap(false, true)
-- end, { desc = "Misc: find and replace selected" })
-- RUtils.map.nnoremap("<leader>rc", function()
--   replace_keymap(true, true)
-- end, { desc = "Misc: find and replace selected with confirmation" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ TERMINAL                                                │
-- ╰─────────────────────────────────────────────────────────╯
RUtils.map.tnoremap("<c-h>", "<Left>", { desc = "Terminal: left char" })
RUtils.map.tnoremap("<c-l>", "<Right>", { desc = "Terminal: right char" })
RUtils.map.tnoremap("<c-b>", "<c-Left>", { desc = "Terminal: backward" })
RUtils.map.tnoremap("<c-f>", "<c-Right>", { desc = "Terminal: forward" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ WINDOWS, VIEW AND NAV                                    │
-- ╰──────────────────────────────────────────────────────────╯

RUtils.map.nnoremap("sv", "<CMD>vsplit<CR>", { desc = "View: vertical split", silent = true })
RUtils.map.nnoremap("ss", "<CMD>split|wincmd p<CR>", { desc = "View: horizontal split", silent = true })
-- RUtils.map.nnoremap("<c-w>v", [[<CMD> lua print("not allowed to use c-w v")<CR>]], { desc = "Misc: <c-w>v not allowed" })
-- RUtils.map.nnoremap("<c-w>s", [[<CMD> lua print("not allowed to use c-w s")<CR>]], { desc = "Misc: <c-w>s not allowed" })
-- nnoremap("sa", [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true })

RUtils.map.nnoremap("sw", "<CMD>wincmd =<CR>", { desc = "View: reset size window to =", silent = true })

RUtils.map.nnoremap("sJ", "<C-W>t <C-W>K", { desc = "View: force to horizontal split", silent = true })
RUtils.map.nnoremap("sL", "<C-W>t <C-W>H", { desc = "View: force to vertical split", silent = true })

RUtils.map.nnoremap("<a-x>", "<CMD>q!<CR>", { desc = "View: close buffer" })

RUtils.map.nnoremap("sC", "<CMD>qa!<CR>", { desc = "View: close all buffer" })

RUtils.map.nnoremap("sh", "<C-w>h", { desc = "View: left window", silent = true })
RUtils.map.nnoremap("sl", "<C-w>l", { desc = "View: right window", silent = true })
RUtils.map.nnoremap("sj", "<C-w>j", { desc = "View: down window", silent = true })
RUtils.map.nnoremap("sk", "<C-w>k", { desc = "View: up window", silent = true })

RUtils.map.nnoremap("<a-w>h", "<C-w>h", { desc = "View: left window (mod)", silent = true })
RUtils.map.nnoremap("<a-w>l", "<C-w>l", { desc = "View: right window (mod)", silent = true })
RUtils.map.nnoremap("<a-w>j", "<C-w>j", { desc = "View: down window (mod)", silent = true })
RUtils.map.nnoremap("<a-w>k", "<C-w>k", { desc = "View: up window (mod)", silent = true })

RUtils.map.nnoremap("<Left>", "<cmd>wincmd h<cr>", { desc = "View: left window (alternate)" })
RUtils.map.nnoremap("<Right>", "<cmd>wincmd l<cr>", { desc = "View: right window (alternate)" })
RUtils.map.nnoremap("<Up>", "<cmd>wincmd k<cr>", { desc = "View: up window (alternate)" })
RUtils.map.nnoremap("<Down>", "<cmd>wincmd j<cr>", { desc = "View: down window (alternate)" })

RUtils.map.nnoremap("tn", "<CMD>tabedit %<CR>", { desc = "Winav: new tab", silent = true })
RUtils.map.nnoremap("tc", "<CMD>tabclose<CR>", { desc = "Winav: close tab", silent = true })

RUtils.map.nnoremap("tl", "<CMD>tabn<CR>", { desc = "Winav: next tab", silent = true })
RUtils.map.nnoremap("th", "<CMD>tabp<CR>", { desc = "Winav: prev tab", silent = true })
RUtils.map.nnoremap("<a-w>L", "<CMD>tabn<CR>", { desc = "Winav: next tab (mod)", silent = true })
RUtils.map.nnoremap("<a-w>H", "<CMD>tabp<CR>", { desc = "Winav: prev tab (mod)", silent = true })

RUtils.map.nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Winav: first tab", silent = true })
RUtils.map.nnoremap("tL", "<CMD>tablast<CR>", { desc = "Winav: last tab", silent = true })

-- Alternate the buffer
local dont_alternitefile = { "qf", "Outline", "neo-tree", "OverseerList" }
RUtils.map.nnoremap("sbb", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  if vim.tbl_contains(dont_alternitefile, ft) then
    return
  end
  return RUtils.cmd.feedkey("<C-^>", "n")
end, { desc = "View: alternate file" })

RUtils.map.nnoremap("sO", function()
  return RUtils.buf._only()
end, { desc = "View: buffonly" })

RUtils.map.nnoremap("sT", "<C-w><S-t>", { desc = "Buffer: break buffer/change to new tab" })

-- RUtils.map.nnoremap("gH", "<CMD>bfirst<CR>", { desc = "Buffer: first buffer" })
-- RUtils.map.nnoremap("gL", "<CMD>blast<CR>", { desc = "Buffer: last buffer" })

-- RUtils.map.nnoremap("gh", "<CMD>bprev<CR>", { desc = "Buffer: prev buffer" })
-- RUtils.map.nnoremap("gl", "<CMD>bnext<CR>", { desc = "Buffer: next buffer" })

RUtils.map.nnoremap("gh", function()
  return RUtils.fold.magic_prev_next_qf(true)
end, { desc = "Misc: magic move gh" })
RUtils.map.nnoremap("gl", function()
  return RUtils.fold.magic_prev_next_qf()
end, { desc = "Misc: magic move gl" })

-- RUtils.map.nnoremap("<S-Left>", "<CMD>colder<CR>", { desc = "qf: prev stack" })
-- RUtils.map.nnoremap("<S-Right>", "<CMD>cnewer<CR>", { desc = "qf: next stack" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ COMMANDLINE                                              │
-- ╰──────────────────────────────────────────────────────────╯
RUtils.map.cnoremap("hh", "<c-c>", { desc = "Commandline: exit from cmdline" })
-- RUtils.map.cnoremap("<c-c>", "<Esc>", { desc = "Commandline: exit" })
RUtils.map.cnoremap("<c-a>", "<Home>", { desc = "Commandline: go to the first" })
RUtils.map.cnoremap("<c-e>", "<End>", { desc = "Commandline: go to the last" })
RUtils.map.cnoremap("<c-n>", "<Down>", { desc = "Commandline: next hist on text" })
RUtils.map.cnoremap("<c-p>", "<Up>", { desc = "Commandline: prev hist on text" })
RUtils.map.cnoremap("<a-n>", "<S-Down>", { desc = "Commandline: next hist" })
RUtils.map.cnoremap("<a-p>", "<S-Up>", { desc = "Commandline: prev hist" })

RUtils.map.cnoremap("<c-l>", "<Right>", { desc = "Commandline: next word" })
RUtils.map.cnoremap("<c-h>", "<Left>", { desc = "Commandline: prev word" })
RUtils.map.cnoremap("<c-f>", "<S-Right>")
RUtils.map.cnoremap("<c-b>", "<S-Left>")

-- ╭──────────────────────────────────────────────────────────╮
-- │ CABBREV                                                  │
-- ╰──────────────────────────────────────────────────────────╯
RUtils.map.cabbrev("BD", "bd!")
RUtils.map.cabbrev("Bd", "bd!")
RUtils.map.cabbrev("Bd", "bd!")
RUtils.map.cabbrev("Q!!", "q!")
RUtils.map.cabbrev("Q!", "q!")
RUtils.map.cabbrev("Q", "q")
-- RUtils.map.cabbrev("Q1", "q!")
RUtils.map.cabbrev("Qal", "qal!")
RUtils.map.cabbrev("Ql", "qal!")
RUtils.map.cabbrev("Qla", "qal!")
RUtils.map.cabbrev("W!", "update!")
RUtils.map.cabbrev("W", "update!")
-- RUtils.map.cabbrev("W1", "update!")
RUtils.map.cabbrev("W;", "update!")
RUtils.map.cabbrev("WQ", "up")
RUtils.map.cabbrev("Wq", "wq")
RUtils.map.cabbrev("bD", "bd!")
RUtils.map.cabbrev("bd", "bd!")
RUtils.map.cabbrev("q!!", "q!")
RUtils.map.cabbrev("ql", "q!")
RUtils.map.cabbrev("qla", "qal!")
-- RUtils.map.cabbrev("w1", "w")
RUtils.map.cabbrev("w;", "update!")

-- I don't need help to show when I type <F1>.
-- RUtils.map.nmap("<F1>", "<Nop>")
-- RUtils.map.imap("<F1>", "<Nop>")
RUtils.map.vmap("K", "<Nop>")

-- ╭─────────────────────────────────────────────────────────╮
-- │ MAGIC                                                   │
-- ╰─────────────────────────────────────────────────────────╯
-- Exit or delete a buffer
local function magic_quit()
  local buf_fts = {
    ["fugitive"] = "bd",
    ["Trouble"] = "bd",
    ["help"] = "bd",
    ["octo"] = "bd",
    ["log"] = "bd",
    ["Outline"] = "bd",
    -- ["qf"] = "bnext | bdelete #",
    -- ["DiffviewFileHistory"] = function()
    --   local view = require("diffview.lib").get_current_view()
    --   if view then
    --     vim.cmd "DiffviewClose"
    --   end
    -- end,
    --
    -- ["DiffviewFiles"] = function()
    --   local view = require("diffview.lib").get_current_view()
    --   if view then
    --     vim.cmd "DiffviewClose"
    --   end
    -- end,
  }

  -- for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
  --   local bufnr = vim.api.nvim_win_get_buf(winid)
  --   local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  --   if vim.bo[0].filetype ~= buf_ft then
  --     return print(bufnr)
  --   else
  --     return cmd [[q!]]
  --   end
  -- end

  if buf_fts[vim.bo[0].filetype] then
    if type(buf_fts[vim.bo[0].filetype]) == "function" then
      buf_fts[vim.bo[0].filetype]()
    end
    cmd(buf_fts[vim.bo[0].filetype])
  else
    cmd [[q!]]
  end
end
RUtils.map.nnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit" })
RUtils.map.vnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit (visual)" })

RUtils.map.nnoremap("<ESC>", function()
  cmd.noh()
end, { desc = "Misc: magic escape" })

RUtils.map.nnoremap("<Leader>oo", function()
  return RUtils.markdown.follow_link(false)
end, { desc = "Misc: magic follow link" })

RUtils.map.vnoremap("<Leader>oo", function()
  return RUtils.markdown.follow_link(true)
end, { desc = "Misc: magic follow link (visual)" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ COMMANDS                                                 │
-- ╰──────────────────────────────────────────────────────────╯
RUtils.cmd.create_command("Snippets", function()
  return RUtils.plugin.EditSnippet()
end, { desc = "Snippet: edit snippet file" })

RUtils.cmd.create_command("CBcatalog", function()
  return require("comment-box").catalog()
end, { desc = "Misc: show catalog [comment-box]" })

RUtils.cmd.create_command("ChangeMasterTheme", function()
  return RUtils.plugin.change_colors()
end, { desc = "Misc: set theme bspwm" })

RUtils.cmd.create_command("InfoOption", function()
  return RUtils.plugin.infoFoldPreview()
end, { desc = "Misc: echo options" })

RUtils.cmd.create_command("ImgInsert", function()
  return RUtils.maim.insert()
end, { desc = "Misc: echo options" })

RUtils.cmd.create_command("E", function()
  return cmd [[ vnew ]]
end, { desc = "Misc: echo options" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ Improve scroll, credits: https://github.com/Shougo       │
-- ╰──────────────────────────────────────────────────────────╯
RUtils.map.nnoremap(
  "zz",
  [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
  { expr = true, desc = "View: center cursor window" }
)

-- Scroll step sideways
RUtils.map.nnoremap("zl", "z4l")
RUtils.map.nnoremap("zh", "z4h")
RUtils.map.nnoremap("zL", "z60l")
RUtils.map.nnoremap("zH", "z60h")

RUtils.map.nnoremap("<C-b>", [[max([winheight(0) - 2, 1]) ."<C-u>".(line('w0') <= 1 ? "H" : "M")]], { expr = true })
RUtils.map.nnoremap(
  "<C-f>",
  [[max([winheight(0) - 2, 1]) ."<C-d>".(line('w$') >= line('$') ? "L" : "M")]],
  { expr = true }
)

RUtils.map.nnoremap("<C-e>", [[(line("w$") >= line('$') ? "2j" : "4<C-e>")]], { expr = true })
RUtils.map.nnoremap("<C-y>", [[(line("w0") <= 1 ? "2k" : "4<C-y>")]], { expr = true })

RUtils.map.nnoremap("sm", function()
  RUtils.toggle.maximize()
end)

RUtils.map.nnoremap("?", RUtils.map.show_help_buf_keymap, {
  desc = "MISC: show keymap helps curbuf",
  silent = true,
})

local checkconceallevel = false
RUtils.map.nnoremap("<Localleader>r", function()
  local col, row = RUtils.fzflua.rectangle_win_pojokan()
  RUtils.fzflua.send_cmds({
    loadqf = function()
      cmd "LoadQf"
    end,
    saveqf = function()
      cmd "SaveQf"
    end,
    lazy = function()
      cmd "Lazy"
    end,
    sourcegraph_sg = function()
      cmd "SourcegraphSearch"
    end,
    search_cheat = function()
      cmd "Cheat"
    end,
    search_cheatlist = function()
      cmd "CheatList"
    end,
    search_devdocs = function()
      local query = vim.fn.input "Search DevDocs: "
      if #query > 0 then
        local encodedURL = string.format('open "https://devdocs.io/#q=%s"', query:gsub("%s", "%%20"))
        os.execute(encodedURL)
      end
    end,
    dismiss_noice = function()
      require("noice").cmd "dismiss"
    end,
    toggle_background = function()
      RUtils.toggle.background()
    end,
    toggle_highlight_color = function()
      require("nvim-highlight-colors").toggle()
    end,
    toggle_undotree = function()
      cmd "UndotreeToggle"
    end,
    toggle_number = function()
      RUtils.toggle.number()
    end,
    session_load = function()
      if RUtils.has "persistence.nvim" then
        require("persistence").load()
      elseif RUtils.has "resession.nvim" then
        require("resession").load()
      end
    end,
    session_load_cwd = function()
      if RUtils.has "resession.nvim" then
        require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
      else
        RUtils.info "current plugin sessions, dont have this feature. so abort"
      end
    end,
    session_delete = function()
      if RUtils.has "resession.nvim" then
        require("resession").delete()
      else
        print "do nothing, ignore me"
      end
    end,
    session_save = function()
      if RUtils.has "persistence.nvim" then
        require("persistence").save()
      elseif RUtils.has "resession.nvim" then
        require("resession").save()
      end
    end,
    session_save_cwd = function()
      if RUtils.has "resession.nvim" then
        -- require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
        require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
      else
        print "do nothinn, ignore me"
      end
    end,
    toggle_conceallevel = function()
      if checkconceallevel then
        cmd [[setlocal conceallevel=2]]
        checkconceallevel = false
        RUtils.info "setlocal conceallevel=2"
      else
        cmd [[setlocal conceallevel=0]]
        checkconceallevel = true
        RUtils.info "setlocal conceallevel=0"
      end
    end,
  }, { winopts = { title = "Misc commands", row = row, col = col } })
end, { desc = "Misc: list commands" })

local function normalize_return(str)
  ---@diagnostic disable-next-line: redefined-local
  local str_slice = string.gsub(str, "\n", "")
  local res = vim.split(str_slice, "\n")
  if res[1] then
    return res[1]
  end

  return str_slice
end

local fm_manager = vim.env.TERM_FILEMANAGER

RUtils.map.nnoremap("<a-E>", function()
  local dirname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":h:p")

  local TMUX = os.getenv "TMUX"
  if not TMUX then
    if RUtils.has "neo-tree.nvim" then
      vim.cmd "Neotree focus reveal"
    else
      local pane_left_id = tonumber(normalize_return(vim.fn.system "wezterm cli get-pane-direction Left"))
      if pane_left_id then
        vim.fn.system("wezterm cli kill-pane --pane-id " .. pane_left_id)
      end

      vim.fn.system "wezterm cli split-pane --left --percent 15"
      vim.fn.system "wezterm cli activate-pane-direction Right"

      local pane_left_id2 = tonumber(normalize_return(vim.fn.system "wezterm cli get-pane-direction Left"))
      vim.fn.system(
        string.format("wezterm cli send-text --no-paste '%s %s\r' --pane-id %s", fm_manager, dirname, pane_left_id2)
      )

      vim.fn.system "wezterm cli activate-pane-direction Left"
    end
  else
    vim.fn.system [[tmux select-pane -L]]

    local pane_left_currend_cmd_nnn = normalize_return(
      vim.fn.system [[tmux display-message -p "#{pane_id} #{pane_current_command}" | awk '$2 == "nnn" { print $2; exit }']]
    )
    if pane_left_currend_cmd_nnn == "nnn" then
      vim.fn.system "tmux kill-pane"
    end

    local pane_left_current_cmd_lf = normalize_return(
      vim.fn.system [[tmux display-message -p "#{pane_id} #{pane_current_command}" | awk '$2 == "lf" { print $2; exit }']]
    )
    if pane_left_current_cmd_lf == "lf" then
      vim.fn.system "tmux kill-pane"
    end

    local msg = fmt("tmux split-window -hb -p 30 -l 30 -c '#{pane_current_path}' '%s %s'", fm_manager, dirname)
    vim.fn.system(msg)
    -- local current_pane = normalize_return(vim.fn.system [[tmux display-message -p "#{pane_id}" ]])
    --
    -- vim.fn.system(string.format("tmux send-keys -t %s 'nnn -c %s' Enter", current_pane, dirname))
  end
end)
