local silent = { silent = true }
local nosilent = { silent = false }
-- local opts = { noremap = true, unique = true }

local fn, api, cmd, fmt, map = vim.fn, vim.api, vim.cmd, string.format, vim.keymap.set

local Util = require "r.utils"

-- local recursive_map = function(mode, lhs, rhs, opts)
--     opts = opts or {}
--     opts.remap = true
--     map(mode, lhs, rhs, opts)
-- end
--
-- local nmap = function(...)
--     recursive_map("n", ...)
-- end
-- local imap = function(...)
--     recursive_map("i", ...)
-- end

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

nnoremap("<leader>rL", "<Cmd>Lazy<CR>", { desc = "Misc(lazy): manage" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ EDITING TEXT                                             │
--  ╰──────────────────────────────────────────────────────────╯
inoremap("jk", "<ESC>", silent)
inoremap("kj", "<ESC>", silent)

inoremap("<c-a>", "<c-O>^", silent)
inoremap("<c-e>", "<c-O>$", silent)
inoremap("<c-d>", "<c-O>dw", silent)
inoremap("<c-j>", "<Down>", silent)
inoremap("<c-k>", "<Up>", silent)

nnoremap("g,", "g,zvzz", silent) -- go last edit
nnoremap("g;", "g;zvzz", silent) -- go prev edit

inoremap("<c-l>", "<Right>", silent)
inoremap("<c-h>", "<Left>", silent)
inoremap("<c-b>", "<S-Left>", silent)
inoremap("<c-f>", "<S-Right>", silent)

nnoremap("<c-g>", "/", nosilent)
vnoremap("<c-g>", [["zy:%s/<C-r><C-o>"/]], { desc = "Search and replace on the fly" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ MARKS                                                    │
--  ╰──────────────────────────────────────────────────────────╯
-- nnoremap("gm", "`", { noremap = false }) -- Map gm to `. Instead of `a, hit gma. See :help mark-motions as to why we use backtick.

-- if FzfLua not installed use this
-- jump using marks to last change, left insert, jump.
if not pcall(require, "fzf-lua") then
  nnoremap("<Leader>mc", ":norm `.<CR>", { desc = "Marks: jump to last change" })
  nnoremap("<Leader>mi", ":norm `^<CR>", { desc = "Marks: jump to last insert" })
  nnoremap("<Leader>mj", ":norm `'<CR>", { desc = "Marks: jump to last jump" })
end

--  ╭──────────────────────────────────────────────────────────╮
--  │ FOLDS                                                    │
--  ╰──────────────────────────────────────────────────────────╯
-- nnoremap("<space><space>", "za", { desc = "Folds: toggle" })

nnoremap("<a-n>", function()
  return Util.fold.goNextClosedFold()
end, { desc = "Folds: go next closed" })

nnoremap("<a-p>", function()
  return Util.fold.goPreviousClosedFold()
end, { desc = "Folds: go prev closed" })

nnoremap("zm", "zM", { desc = "Folds: close all" })

-- Jump next/prev fold
-- nnoremap("zn", "zjzz", opts)
-- nnoremap("zp", "zkzz", opts)

--  ╭──────────────────────────────────────────────────────────╮
--  │ BUFFERS                                                  │
--  ╰──────────────────────────────────────────────────────────╯
if not Util.has "bufferline.nvim" then
  nnoremap("<Leader>bO", function()
    return Util.buf._only()
  end, { desc = "Buffer: bufonly" })
end

nnoremap("<c-w>b", "<C-w><S-t>", { desc = "Buffer: break buffer into new tab" })
nnoremap("gH", "<CMD>bfirst<CR>", { desc = "Buffer: go to the first buffer" })
nnoremap("gL", "<CMD>blast<CR>", { desc = "Buffer: go to the last buffer" })

-- Exit or delete a buffer
local function magic_quit()
  local buf_fts = {
    ["fugitive"] = "bd",
    ["Trouble"] = "bd",
    ["help"] = "bd",
    -- ["norg"] = "bd",
    -- ["org"] = "bd",
    ["octo"] = "bd",
    ["log"] = "bd",

    ["alpha"] = "q",
    ["spectre_panel"] = "q",
    ["OverseerForm"] = "q!",
    ["orgagenda"] = "q",
    ["markdown"] = "q",
    ["NeogitStatus"] = "q",
    ["checkhealth"] = "q",
    ["neo-tree"] = "NeoTreeShowClose",
    ["DiffviewFileHistory"] = "DiffviewClose",
    ["qf"] = Util.toggle.kill_loc_qf,
  }

  local alias_mode = { i = "I", c = "C", V = "V", [""] = "V" }
  if alias_mode[vim.fn.mode()] ~= nil then
    return Util.cmd.feedkey("<esc>", "n")
  end

  local list_wins = {}

  for _, winid in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(winid) then
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
      if filetype ~= "notify" then
        table.insert(list_wins, winid)
      end
    end
  end

  if #list_wins > 0 then
    for _, winid in pairs(list_wins) do
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

      if buf_fts[filetype] ~= nil and vim.bo[0].filetype == buf_fts[filetype] then
        if buf_fts[filetype] == "q" then
          return Util.cmd.feedkey(":q<cr>", "n")
        elseif buf_fts[filetype] == "bd" then
          return Util.cmd.feedkey(":bd<cr>", "n")
        else
          return vim.cmd(buf_fts[filetype])
        end
      else
        return Util.cmd.feedkey(":q<cr>", "n")
      end
    end
  end
end
nnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit" })
vnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit [visual]" })

-- Alternate the buffer
local ignore_alternate_ft = {
  ["qf"] = true,
  ["Outline"] = true,
  ["neo-tree"] = true,
  ["OverseerList"] = true,
}
nnoremap("<leader>bb", function()
  local bufnr = vim.api.nvim_get_current_buf()

  local ft = vim.bo[bufnr].filetype

  if ignore_alternate_ft[ft] then
    return
  end
  return api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-^>", true, true, true), "n", true)
end, { desc = "Buffer: alternate file" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ TABS                                                     │
--  ╰──────────────────────────────────────────────────────────╯
nnoremap("tn", "<CMD>tabedit %<CR>", { desc = "Tab: new tab" })
nnoremap("tl", "<CMD>tabn<CR>", { desc = "Tab: next tab" })
nnoremap("th", "<CMD>tabp<CR>", { desc = "Tab: prev tab" })
nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Tab: first tab" })
nnoremap("tL", "<CMD>tabfirst<CR>", { desc = "Tab: last tab" })
nnoremap("tc", "<CMD>tabclose<CR>", { desc = "Tab: close" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ VISUAL                                                   │
--  ╰──────────────────────────────────────────────────────────╯
-- Ketika dalam mode visual, bisa pindah cursor ke atas dan bawah
xnoremap("il", "$o0", { desc = "Visual: jump in" })
onoremap("il", "<cmd>normal val<CR>", { desc = "Visual: jump out" })

nnoremap("vv", [[^vg_]], { desc = "Visual: select text lines" })

vnoremap(">", ">gv", { desc = "Visual: next align lines" })
vnoremap("<", "<gv", { desc = "Visual: prev align lines" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ MISC                                                     │
--  ╰──────────────────────────────────────────────────────────╯
nnoremap("~", "%", silent)

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

nnoremap("<Leader>rP", function()
  return print(fn.expand "%:p")
end, { desc = "Misc: check cwd curfile" })

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

-- nnoremap("n", "nzzzv", { desc = "Misc: search next" })
-- nnoremap("N", "Nzzzv", { desc = "Misc: search prev" })

nnoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
xnoremap("n", "'Nn'[v:searchforward]", { expr = true, desc = "Misc: next search result" })
onoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
nnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
xnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
onoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })

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
nnoremap("<c-w>y", "<CMD>wincmd =<CR>", silent)
nnoremap("<Leader>ww", "<C-W>p", silent)
nnoremap("<Leader>rf", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], { silent = false, desc = "Misc: search and replace" })
nnoremap("<c-w>J", "<C-W>t <C-W>K", { desc = "Windows: change two horizontally split windows to vertical splits" })
nnoremap("<c-w>L", "<C-W>t <C-W>H", { desc = "Windows: change two vertically split windows to horizontal splits" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ NAVIGATIONS                                              │
--  ╰──────────────────────────────────────────────────────────╯

local isWindows, _ = pcall(require, "smart-splits")
if not isWindows then
  nnoremap("<C-h>", "<C-w>h", { desc = "Navigations: move left" })
  nnoremap("<C-l>", "<C-w>l", { desc = "Navigations: move right" })
  nnoremap("<C-j>", "<C-w>j", { desc = "Navigations: move down" })
  nnoremap("<C-k>", "<C-w>k", { desc = "Navigations: move up" })

  nnoremap("<a-K>", "<cmd>resize +2<cr>", { desc = "Windows: resize window up" })
  nnoremap("<a-J>", "<cmd>resize -2<cr>", { desc = "Windows: resize window down" })
  nnoremap("<a-H>", "<cmd>vertical resize +2<cr>", { desc = "Windows: resize window right" })
  nnoremap("<a-L>", "<cmd>vertical resize -2<cr>", { desc = "Windows: resize window left" })
end

--  ╭──────────────────────────────────────────────────────────╮
--  │ COMMANDLINE                                              │
--  ╰──────────────────────────────────────────────────────────╯
cnoremap("jk", "<c-c>", { desc = "Commandline: exit from cmdline" })
cnoremap("<c-a>", "<Home>", { desc = "Commandline: go to the first" })
cnoremap("<c-e>", "<End>", { desc = "Commandline: go to the last" })
cnoremap("<c-n>", "<Down>", { desc = "Commandline: next hist" })
cnoremap("<c-p>", "<Up>", { desc = "Commandline: prev hist" })

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
      tnoremap("<F1>", "<C-w>w", { desc = "Terminal change window" })
      tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
      tnoremap("<a-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
      tnoremap("<a-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
      tnoremap("<a-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
      tnoremap("<a-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window naviation" })
      tnoremap("<a-/>", "<cmd>close<cr>", { desc = "Terminal close" })
    end
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │ DISABLE                                                  │
--  ╰──────────────────────────────────────────────────────────╯

-- nnoremap("gQ", "<Nop>") -- disable
-- nnoremap("<F1>", "<Nop>") -- disable
-- nnoremap("zL", "<Nop>") -- disable
-- nnoremap("Q", "<Nop>", {}) -- Disable Ex mode:
-- nnoremap("Q", "<F1>", {}) -- Disable Ex mode:

-- vim.keymap.del("n", "Q")
-- vim.keymap.del({ "x", "o" }, "x")
-- vim.keymap.del({ "x", "o" }, "X")

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
vim.cmd [[
noremap <expr> <C-b> max([winheight(0) - 2, 1])
      \ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
      ]]

vim.cmd [[
noremap <expr> <C-e> (line("w$") >= line('$') ? "2j" : "4\<C-e>")
]]

vim.cmd [[
noremap <expr> <C-y> (line("w0") <= 1         ? "2k" : "4\<C-y>")
]]

vim.cmd [[
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
      \ 'zt' : (winline() == 1) ? 'zb' : 'zz'
  ]]

-- TODO: check ini nanti, copy paste selection dan killPopups
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

vim.keymap.set("n", "<esc>", function()
  vim.cmd.noh()
  killPopups()
end)

-- vim.keymap.set("n", "<F5>", function()
--   return "`[" .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. "`]"
-- end, { expr = true })

-- vim.cmd [[
-- noremap <expr> <C-f> max([winheight(0) - 2, 1])
--       \ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
--       ]]
