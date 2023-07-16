local silent = { silent = true }
-- local nosilent = { silent = false }
-- local opts = { noremap = true, unique = true }

local fn, api, cmd, command, fmt, map = vim.fn, vim.api, vim.cmd, as.command, string.format, vim.keymap.set

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

--  ╭──────────────────────────────────────────────────────────╮
--  │ EDITING TEXT                                             │
--  ╰──────────────────────────────────────────────────────────╯
inoremap("hh", "<ESC>", silent)
inoremap("<c-f>", "<Right>", silent)
inoremap("<c-b>", "<Left>", silent)
inoremap("<c-a>", "<Home>", silent)
inoremap("<c-e>", "<End>", silent)
inoremap("<c-j>", "<Down>", silent)
inoremap("<c-k>", "<Up>", silent)
inoremap("<c-d>", "<c-O>dw", silent)

-- inoremap("<c-h>", "<Left>", silent)
-- inoremap("<c-l>", "<Right>", silent)

nnoremap("g,", "g,zvzz", silent) -- go last edit
nnoremap("g;", "g;zvzz", silent) -- go prev edit

-- inoremap("<C-w>", "<C-o>E<C-o>l")
-- inoremap("<C-b>", "<C-o>B")

-- nnoremap("<c-f>", "/", nosilent)
-- TODO:  check ini nanti
-- vnoremap("<c-f>", [["zy:%s/<C-r><C-o>"/]], { desc = "Insert: search and replace on the fly" })

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
nnoremap("<space><space>", "za", { desc = "Folds: toggle" })

nnoremap("<a-n>", function()
  return require("r.utils").goNextClosedFold()
end, { desc = "Folds: go next closed" })

nnoremap("<a-p>", function()
  return require("r.utils").goPreviousClosedFold()
end, { desc = "Folds: go prev closed" })

nnoremap("zm", "zM", { desc = "Folds: close all" })

-- nnoremap(
--     "<c-space>",
--     [[@=(foldlevel('.')?'zA':"\<Space>")<CR>]],
--     { desc = "Fold: toggle fold recursive" }
-- ) -- Toggle open close fold (recursive)
-- nnoremap("<localleader>z", [[zMzvzz]], { desc = "Fold: center viewport" }) -- Refocus folds

-- Jump next/prev fold
-- nnoremap("zn", "zjzz", opts)
-- nnoremap("zp", "zkzz", opts)

--  ╭──────────────────────────────────────────────────────────╮
--  │ BUFFERS                                                  │
--  ╰──────────────────────────────────────────────────────────╯
nnoremap("<Leader>bO", function()
  return require("r.utils").Buf_only()
end, { desc = "Buffer: bufonly" })

nnoremap("<Leader>rB", function()
  return require("r.utils").toggle_background()
end, { desc = "Misc: toggle background" })

nnoremap("<Leader>b5", function()
  return require("r.utils").testfunc()
end, { desc = "Buffer: test func" })

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
    ["qf"] = require("r.utils").toggle_kil_loc_qf,
  }

  local alias_mode = { i = "I", c = "C", V = "V", [""] = "V" }
  if alias_mode[vim.fn.mode()] ~= nil then
    return require("r.utils").feedkey("<esc>", "n")
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
          return require("r.utils").feedkey(":q<cr>", "n")
        elseif buf_fts[filetype] == "bd" then
          return require("r.utils").feedkey(":bd<cr>", "n")
        else
          return vim.cmd(buf_fts[filetype])
        end
      else
        return require("r.utils").feedkey(":q<cr>", "n")
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
nnoremap("<Leader>bb", function()
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
-- TODO: check ini apakah, <leader>t conflict dengan
nnoremap("tn", "<CMD>tabedit %<CR>", { desc = "Tab: new tab" })
nnoremap("tl", "<CMD>tabn<CR>", { desc = "Tab: next tab" })
nnoremap("th", "<CMD>tabp<CR>", { desc = "Tab: prev tab" })
nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Tab: first tab" })
nnoremap("tL", "<CMD>tabfirst<CR>", { desc = "Tab: last tab" })

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

nnoremap("<leader>rd", function()
  local query = vim.fn.input "Search DevDocs: "
  if #query > 0 then
    local encodedURL = string.format('open "https://devdocs.io/#q=%s"', query:gsub("%s", "%%20"))
    os.execute(encodedURL)
  end
end, { desc = "Misc: search devdocs" })

-- Multiple Cursor Replacement
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-byses-of-vimscript/
-- vim.keymap.set("n", "cn", "*``cgn")
-- vim.keymap.set("n", "cn", "*``cgN")

nnoremap("<Leader>rP", function()
  return print(fn.expand "%:p")
end, { desc = "Misc: check cwd curfile" })

nnoremap("<leader>cd", function()
  local filepath = fn.expand "%:p:h" -- code
  cmd(fmt("cd %s", filepath))
  vim.notify(fmt("ROOT CHANGED: %s", filepath))
end, { desc = "Misc: change cur pwd to curfile" })

nnoremap("<Leader>n", function()
  require("notify").dismiss {}
  return cmd.nohl()
end, { desc = "Misc: clear searches" })

nnoremap("n", "nzzzv", { desc = "Misc: search next" })
nnoremap("N", "Nzzzv", { desc = "Misc: search prev" })

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

nnoremap("<leader>rf", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], { silent = false, desc = "Misc: search and replace" })

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

  nnoremap("<a-K>", "<cmd>resize +2<cr>", { desc = "Windows: resize window up" })
  nnoremap("<a-J>", "<cmd>resize -2<cr>", { desc = "Windows: resize window down" })
  nnoremap("<a-H>", "<cmd>vertical resize +2<cr>", { desc = "Windows: resize window right" })
  nnoremap("<a-L>", "<cmd>vertical resize -2<cr>", { desc = "Windows: resize window left" })
end

--  ╭──────────────────────────────────────────────────────────╮
--  │ COMMANDLINE                                              │
--  ╰──────────────────────────────────────────────────────────╯
cnoremap("hh", "<c-c>", { desc = "Cmdline: exit from cmdline" })
cnoremap("<c-a>", "<Home>", { desc = "Cmdline: go to the first" })
cnoremap("<c-e>", "<End>", { desc = "Cmdline: go to the last" })

cnoremap("<c-f>", "<Right>", { desc = "Cmdline: next word" })
cnoremap("<c-b>", "<Left>", { desc = "Cmdline: prev word" })

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
      tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
      tnoremap("<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal left window navigation" })
      tnoremap("<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal down window navigation" })
      tnoremap("<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal up window navigation" })
      tnoremap("<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal right window naviation" })
    end
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │ DISABLE                                                  │
--  ╰──────────────────────────────────────────────────────────╯

nnoremap("gQ", "<Nop>") -- disable
nnoremap("<F1>", "<Nop>") -- disable
nnoremap("zL", "<Nop>") -- disable
nnoremap("Q", "<Nop>", {}) -- Disable Ex mode:
nnoremap("Q", "<F1>", {}) -- Disable Ex mode:

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

--  ╭──────────────────────────────────────────────────────────╮
--  │ COMMANDS                                                 │
--  ╰──────────────────────────────────────────────────────────╯

command("Snippets", function()
  require("r.utils").EditSnippet()
end, { desc = "Snippet: edit snippet file" })

command("CBcatalog", function()
  return require("comment-box").catalog()
end, { desc = "Comment-box: show catalog" })

command("InfoBaseColorsTheme", function()
  return require("r.utils").infoBaseColorsTheme()
end, { desc = "Misc: set theme bspwm" })

command("InfoOption", function()
  return require("r.utils").infoFoldPreview()
end, { desc = "Misc: echo options" })

command("Uuid", function()
  local uuid = fn.system("uuidgen"):gsub("\n", ""):lower()
  local line = fn.getline "."
  return vim.schedule(function()
    fn.setline(
      ---@diagnostic disable-next-line: param-type-mismatch
      ".",
      fn.strpart(line, 0, fn.col ".") .. uuid .. fn.strpart(line, fn.col ".")
    )
  end)
end, { desc = "Misc: Generate a UUID and insert it into the buffer" })

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

vim.cmd [[
noremap <expr> <C-f> max([winheight(0) - 2, 1])
      \ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
      ]]
