local silent = { silent = true }
local nosilent = { silent = false }
-- local moresilent = { noremap = true, expr = true, silent = true }

local fn, cmd, fmt, map = vim.fn, vim.cmd, string.format, vim.keymap.set

local Util = require "r.utils"

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
local vmap = function(...)
  recursive_map("v", ...)
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

local function cabbrev(short, long)
  local cmdpos = #short + 1
  vim.api.nvim_set_keymap("ca", short, "", {
    expr = true,
    callback = function()
      if vim.fn.getcmdtype() == ":" and vim.fn.getcmdpos() == cmdpos then
        return long
      else
        return short
      end
    end,
  })
end

nnoremap("<Localleader>ol", "<Cmd>Lazy<CR>", { desc = "Misc(lazy): manage" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ EDITING TEXT                                             │
--  ╰──────────────────────────────────────────────────────────╯
-- jk is escape, THEN move to the right to preserve the cursor position, unless
-- at the first column.  <esc> will continue to work the default way.
-- NOTE: this is a recursive mapping so anything bound (by a plugin) to <esc> still works
imap("jk", [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })
imap("kj", [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })

inoremap("<c-a>", "<c-O>^", silent)
inoremap("<c-e>", "<c-O>$", silent)
inoremap("<c-d>", "<c-O>dw", silent)
inoremap("<c-c>", "<Esc>", silent)

nnoremap("g,", "g,zvzz", silent) -- go last edit
nnoremap("g;", "g;zvzz", silent) -- go prev edit

inoremap("<c-j>", "<Down>", silent)
inoremap("<c-k>", "<Up>", silent)
inoremap("<c-l>", "<Right>", silent)
inoremap("<c-h>", "<Left>", silent)

inoremap("<c-b>", "<c-o>B", silent)
inoremap("<c-f>", "<S-Right>", silent)

nnoremap("<c-g>", "/", nosilent)
vnoremap("<c-g>", [["zy:%s/<C-r><C-o>"/]], { desc = "Search and replace on the fly" })

if not Util.has "bufferline.nvim" then
  nnoremap("gl", "<cmd>bnext<CR>", silent)
  nnoremap("gh", "<cmd>bprev<CR>", silent)
end

-- Automatically indent with i and A made by ycino
-- inoremap("i", function()
--   return string.len(vim.api.nvim_get_current_line()) ~= 0 and "i" or '"_cc'
-- end, moresilent)
-- inoremap("A", function()
--   return string.len(vim.api.nvim_get_current_line()) ~= 0 and "A" or '"_cc'
-- end, moresilent)

--  ╭──────────────────────────────────────────────────────────╮
--  │ MARKS                                                    │
--  ╰──────────────────────────────────────────────────────────╯
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

--  ╭──────────────────────────────────────────────────────────╮
--  │ FOLDS                                                    │
--  ╰──────────────────────────────────────────────────────────╯

-- Focus the current fold by closing all others
nnoremap("<space><space>", "zMzvzO", { desc = "Fold: focus the current fold by closing all others" })
nnoremap("zm", "zM")

-- Make zO recursively open whatever top level fold we're in, no matter where the
-- cursor happens to be.
-- nnoremap("zO", [[zCzO]], { desc = " fold: recursively zO" })

-- Jump next/prev to closing fold
nnoremap("<a-n>", function()
  return Util.fold.goNextClosedFold()
end, { desc = "Fold: go next closed" })
nnoremap("<a-p>", function()
  return Util.fold.goPreviousClosedFold()
end, { desc = "Fold: go prev closed" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ VISUAL                                                   │
--  ╰──────────────────────────────────────────────────────────╯
-- Cara mudah untuk cursor dari bawah ke atas dalam visual mode
xnoremap("il", "<Esc>^vg_", { desc = "Visual: dont mistake" })
onoremap("il", "<CMD><C-U>normal! ^vg_<CR>", { desc = "Visual: mistake" })

xnoremap("al", "$o0", { desc = "Visual: jump in" })
onoremap("al", "<CMD><C-u>normal val<CR>", { desc = "Visual: jump out" })

nnoremap("vv", [[^vg_]], { desc = "Visual: select text lines" })
vnoremap(">", ">gv", { desc = "Visual: next align lines" })
vnoremap("<", "<gv", { desc = "Visual: prev align lines" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ MISC                                                     │
--  ╰──────────────────────────────────────────────────────────╯
nnoremap("~", "%", silent)

nnoremap("<Leader>rf", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], { silent = false, desc = "Misc: search and replace" })

nnoremap("<Localleader>tb", function()
  return Util.toggle.background()
end, { desc = "Misc: toggle background" })

nnoremap("<Leader>rd", function()
  local query = vim.fn.input "Search DevDocs: "
  if #query > 0 then
    local encodedURL = string.format('open "https://devdocs.io/#q=%s"', query:gsub("%s", "%%20"))
    os.execute(encodedURL)
  end
end, { desc = "Misc: search devdocs" })

nnoremap("<Leader>cd", function()
  local filepath = fn.expand "%:p:h" -- code
  cmd(fmt("cd %s", filepath))
  vim.notify(fmt("ROOT CHANGED: %s", filepath))
end, { desc = "Misc: change cur pwd to curfile" })

nnoremap("<Leader>n", function()
  ---@diagnostic disable-next-line: missing-fields
  require("notify").dismiss {}
  return cmd.nohl()
end, { desc = "Misc: clear searches" })

nnoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
xnoremap("n", "'Nn'[v:searchforward]", { expr = true, desc = "Misc: next search result" })
onoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
nnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
xnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
onoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })

-- Save jumps > 3 lines to the jumplist
-- Jumps <= 3 respect line wraps
nnoremap("k", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'k' : 'gk']], { expr = true })
nnoremap("j", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'j' : 'gj']], { expr = true })

--  ╭──────────────────────────────────────────────────────────╮
--  │ WINDOWS AND NAV                                          │
--  ╰──────────────────────────────────────────────────────────╯

nnoremap("sv", "<CMD>vsplit<CR>", { desc = "WinNav: vsplit", silent = true })
nnoremap("ss", "<CMD>split<CR>", { desc = "WinNav: split", silent = true })
nnoremap("<c-w>v", [[<CMD> lua print("not allowed to use c-w v")<CR>]], { desc = "Misc: Remove" })
nnoremap("<c-w>s", [[<CMD> lua print("not allowed to use c-w s")<CR>]], { desc = "Misc: Remove" })
-- nnoremap("sa", [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true })

nnoremap("sw", "<CMD>wincmd =<CR>", { desc = "WinNav: wincmd =", silent = true })

nnoremap("sJ", "<C-W>t <C-W>K", { desc = "WinNav: force to splits", silent = true })
nnoremap("sL", "<C-W>t <C-W>H", { desc = "WinNav: force to vsplits", silent = true })

nnoremap("sc", "<CMD>q!<CR>")
nnoremap("sC", "<CMD>qa!<CR>")

nnoremap("sh", "<C-w>h", { desc = "WinNav: move left", silent = true })
nnoremap("sl", "<C-w>l", { desc = "WinNav: move right", silent = true })
nnoremap("sj", "<C-w>j", { desc = "WinNav: move down", silent = true })
nnoremap("sk", "<C-w>k", { desc = "WinNav: move up", silent = true })

nnoremap("sP", [[<CMD> lua print(vim.fn.expand "%:p") <CR>]], { desc = "WinNav: printout the path curbuf" })

nnoremap("tn", "<CMD>tabedit %<CR>", { desc = "WinNav(tab): new tab", silent = true })
nnoremap("tc", "<CMD>tabclose<CR>", { desc = "WinNav(tab): close", silent = true })

nnoremap("tl", "<CMD>tabn<CR>", { desc = "WinNav(tab): next tab", silent = true })
nnoremap("th", "<CMD>tabp<CR>", { desc = "WinNav(tab): prev tab", silent = true })

nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "WinNav(tab): first tab", silent = true })
nnoremap("tL", "<CMD>tablast<CR>", { desc = "WinNav(tab): last tab", silent = true })

-- Alternate the buffer
local dont_alternitefile = { "qf", "Outline", "neo-tree", "OverseerList" }
nnoremap("sbb", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  if vim.tbl_contains(dont_alternitefile, ft) then
    return
  end
  return Util.cmd.feedkey("<C-^>", "n")
end, { desc = "WinNav(buffer): alternate file" })

-- if not Util.has "bufferline.nvim" then
--   nnoremap("sO", function()
--     return Util.buf._only()
--   end, { desc = "Buffer: bufonly" })
-- end

nnoremap("sT", "<C-w><S-t>", { desc = "WinNav(buffer): break buffer into new tab" })

nnoremap("gH", "<CMD>bfirst<CR>", { desc = "Buffer: go to the first buffer" })
nnoremap("gL", "<CMD>blast<CR>", { desc = "Buffer: go to the last buffer" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ COMMANDLINE                                              │
--  ╰──────────────────────────────────────────────────────────╯
cnoremap("jk", "<c-c>", { desc = "Commandline: exit from cmdline" })
cnoremap("<c-a>", "<Home>", { desc = "Commandline: go to the first" })
cnoremap("<c-e>", "<End>", { desc = "Commandline: go to the last" })
cnoremap("<c-n>", "<Down>", { desc = "Commandline: next hist on text" })
cnoremap("<c-p>", "<Up>", { desc = "Commandline: prev hist on text" })
cnoremap("<a-n>", "<S-Down>", { desc = "Commandline: next hist" })
cnoremap("<a-p>", "<S-Up>", { desc = "Commandline: prev hist" })

cnoremap("<c-l>", "<Right>", { desc = "Commandline: next word" })
cnoremap("<c-h>", "<Left>", { desc = "Commandline: prev word" })
cnoremap("<c-f>", "<S-Right>")
cnoremap("<c-b>", "<S-Left>")

--  ╭──────────────────────────────────────────────────────────╮
--  │ TERMINAL                                                 │
--  ╰──────────────────────────────────────────────────────────╯

Util.cmd.augroup("AddTerminalMappings", {
  event = { "TermOpen" },
  pattern = { "term://*" },
  command = function()
    if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
      tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
      tnoremap("<a-h>", "<cmd>wincmd h<cr>", { desc = "Terminal: left window navigation" })
      tnoremap("<a-j>", "<cmd>wincmd j<cr>", { desc = "Terminal; down window navigation" })
      tnoremap("<a-k>", "<cmd>wincmd k<cr>", { desc = "Terminal: up window navigation" })
      tnoremap("<a-l>", "<cmd>wincmd l<cr>", { desc = "Terminal: right window naviation" })
      -- tnoremap("<a-/>", "<cmd>close<cr>", { desc = "Terminal: close" })
    end
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │ CABBREV                                                  │
--  ╰──────────────────────────────────────────────────────────╯

cabbrev("Wq", "wq")
cabbrev("Q!", "q!")
cabbrev("Q!!", "q!")
cabbrev("Q1", "q!")
cabbrev("Q", "q")
cabbrev("q!!", "q!")
cabbrev("ql", "q!")
cabbrev("Ql", "qal!")
cabbrev("qla", "qal!")
cabbrev("WQ", "up")
cabbrev("Qal", "qal!")
cabbrev("Qla", "qal!")
cabbrev("W1", "update!")
cabbrev("W;", "update!")
cabbrev("w;", "update!")
cabbrev("W", "update!")
cabbrev("W!", "update!")
cabbrev("Bd", "bd!")
cabbrev("BD", "bd!")
cabbrev("bD", "bd!")
cabbrev("Bd", "bd!")
cabbrev("bd", "bd!")

-- I don't need help to show when I type <F1>.
nmap("<F1>", "<Nop>")
imap("<F1>", "<Nop>")
vmap("K", "<Nop>")

--  ┌──────────────────────────────────────────────────────────┐
--  │                          MAGIC                           │
--  └──────────────────────────────────────────────────────────┘

-- Exit or delete a buffer
local function magic_quit()
  local buf_fts = {
    ["fugitive"] = "bd",
    ["Trouble"] = "bd",
    ["help"] = "bd",
    ["octo"] = "bd",
    ["log"] = "bd",
    ["DiffviewFileHistory"] = "DiffviewClose",
  }

  if buf_fts[vim.bo[0].filetype] then
    vim.cmd(buf_fts[vim.bo[0].filetype])
  else
    vim.cmd [[q!]]
  end
end
nnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit" })
vnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit [visual]" })

local function getPopups()
  return vim.fn.filter(vim.api.nvim_tabpage_list_wins(0), function(_, e)
    return vim.api.nvim_win_get_config(e).zindex
  end)
end

local function killPopups()
  vim.fn.map(getPopups(), function(_, e)
    vim.api.nvim_win_close(e, false)
  end)
end

vim.keymap.set("n", "<ESC>", function()
  vim.cmd.noh()
  killPopups()
end)
--  ╭──────────────────────────────────────────────────────────╮
--  │ COMMANDS                                                 │
--  ╰──────────────────────────────────────────────────────────╯

Util.cmd.create_command("Snippets", function()
  return Util.plugin.EditSnippet()
end, { desc = "Snippet: edit snippet file" })

Util.cmd.create_command("CBcatalog", function()
  return require("comment-box").catalog()
end, { desc = "Comment-box: show catalog" })

Util.cmd.create_command("InfoBaseColorsTheme", function()
  return Util.plugin.infoBaseColorsTheme()
end, { desc = "Misc: set theme bspwm" })

Util.cmd.create_command("InfoOption", function()
  return Util.plugin.infoFoldPreview()
end, { desc = "Misc: echo options" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ Improve scroll, credits: https://github.com/Shougo       │
--  ╰──────────────────────────────────────────────────────────╯

nmap("zz", [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true })

-- Scroll step sideways
nnoremap("zl", "z4l")
nnoremap("zh", "z4h")
nnoremap("zL", "z60l")
nnoremap("zH", "z60h")

nnoremap("<C-b>", [[max([winheight(0) - 2, 1]) ."<C-u>".(line('w0') <= 1 ? "H" : "M")]], { expr = true })
nnoremap("<C-f>", [[max([winheight(0) - 2, 1]) ."<C-d>".(line('w$') >= line('$') ? "L" : "M")]], { expr = true })

nnoremap("<C-e>", [[(line("w$") >= line('$') ? "2j" : "4<C-e>")]], { expr = true })
nnoremap("<C-y>", [[(line("w0") <= 1 ? "2k" : "4<C-y>")]], { expr = true })
