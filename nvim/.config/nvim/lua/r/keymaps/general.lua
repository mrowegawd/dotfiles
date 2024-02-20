local silent = { silent = true }
local nosilent = { silent = false }

local fn, cmd, fmt = vim.fn, vim.cmd, string.format

local Util = require "r.utils"
local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

--  ╭──────────────────────────────────────────────────────────╮
--  │ EDITING TEXT                                             │
--  ╰──────────────────────────────────────────────────────────╯
-- jk is escape, THEN move to the right to preserve the cursor position, unless
-- at the first column.  <esc> will continue to work the default way.
-- NOTE: this is a recursive mapping so anything bound (by a plugin) to <esc> still works
Util.map.imap("jk", [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })
Util.map.imap("kj", [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })

Util.map.inoremap("<c-c>", "<Esc>", silent)
Util.map.inoremap("<c-a>", "<c-O>^", silent)
Util.map.inoremap("<c-e>", "<c-O>$", silent)
Util.map.inoremap("<c-d>", "<c-O>dw", silent)

Util.map.nnoremap("g,", "g,zvzz", silent) -- go last edit
Util.map.nnoremap("g;", "g;zvzz", silent) -- go prev edit
-- Avoid or don't yank on visual paste
Util.map.vnoremap("p", "pgvy")
Util.map.nnoremap("<Leader>Y", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or ""
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Yanked absolute path" })
end, { silent = true, desc = "Misc: yank absolute path" })
Util.map.nnoremap("Y", "y$", { desc = "Yank to end of line" })

Util.map.inoremap("<c-j>", "<Down>", silent)
Util.map.inoremap("<c-k>", "<Up>", silent)
Util.map.inoremap("<c-l>", "<Right>", silent)
Util.map.inoremap("<c-h>", "<Left>", silent)

Util.map.inoremap("<c-b>", "<Esc>ba", silent)
Util.map.inoremap("<c-f>", "<Esc>ea", silent)

Util.map.nnoremap("<c-g>", "/", nosilent)

if not Util.has "bufferline.nvim" then
  Util.map.nnoremap("gl", "<cmd>bnext<CR>", silent)
  Util.map.nnoremap("gh", "<cmd>bprev<CR>", silent)
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
Util.map.nnoremap("<space><space>", "zMzvzO", { desc = "Fold: focus the current fold by closing all others" })
Util.map.nnoremap("zm", "zM")
-- Util.map.nnoremap("<BS>", "za")

-- Make zO recursively open whatever top level fold we're in, no matter where the
-- cursor happens to be.
-- nnoremap("zO", [[zCzO]], { desc = " fold: recursively zO" })

-- Jump next/prev to closing fold
Util.map.nnoremap("<a-n>", function()
  return Util.fold.goNextClosedFold()
end, { desc = "Fold: go next closed" })
Util.map.nnoremap("<a-p>", function()
  return Util.fold.goPreviousClosedFold()
end, { desc = "Fold: go prev closed" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ VISUAL                                                   │
--  ╰──────────────────────────────────────────────────────────╯
-- Cara mudah untuk cursor dari bawah ke atas dalam visual mode
Util.map.xnoremap("il", "<Esc>^vg_", { desc = "Visual: dont mistake" })
Util.map.onoremap("il", "<CMD><C-U>normal! ^vg_<CR>", { desc = "Visual: mistake" })

Util.map.xnoremap("al", "$o0", { desc = "Visual: jump in" })
Util.map.onoremap("al", "<CMD><C-u>normal val<CR>", { desc = "Visual: jump out" })

Util.map.nnoremap("vv", [[^vg_]], { desc = "Visual: select text lines" })
Util.map.vnoremap(">", ">gv", { desc = "Visual: next align lines" })
Util.map.vnoremap("<", "<gv", { desc = "Visual: prev align lines" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ MISC                                                     │
--  ╰──────────────────────────────────────────────────────────╯
Util.map.nnoremap("~", "%", silent)

-- nnoremap("<Leader>rf", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], { silent = false, desc = "Misc: search and replace" })

Util.map.nnoremap("<Leader>rd", function()
  local query = vim.fn.input "Search DevDocs: "
  if #query > 0 then
    local encodedURL = string.format('open "https://devdocs.io/#q=%s"', query:gsub("%s", "%%20"))
    os.execute(encodedURL)
  end
end, { desc = "Misc: search devdocs" })

Util.map.nnoremap("<Leader>cd", function()
  local filepath = fn.expand "%:p:h" -- code
  cmd(fmt("cd %s", filepath))
  vim.notify(fmt("ROOT CHANGED: %s", filepath))
end, { desc = "Misc: change cur pwd to curfile" })

Util.map.nnoremap("<Leader>n", function()
  require("notify").dismiss {}
  cmd.nohl()
  -- return cmd [[let @/ = ""]]
end, { desc = "Misc: clear searches" })

Util.map.nnoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
Util.map.xnoremap("n", "'Nn'[v:searchforward]", { expr = true, desc = "Misc: next search result" })
Util.map.onoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
Util.map.nnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
Util.map.xnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
Util.map.onoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })

-- Save jumps > 3 lines to the jumplist
-- Jumps <= 3 respect line wraps
-- Util.map.nnoremap("k", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'k' : 'gk']], { expr = true })
-- Util.map.nnoremap("j", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'j' : 'gj']], { expr = true })

-- allow moving the cursor through wrapped lines using j and k,
-- note that I have line wrapping turned off but turned on only for Markdown
Util.map.nnoremap("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
Util.map.nnoremap("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
Util.map.vnoremap("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
Util.map.vnoremap("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- Util.map.nnoremap("j", [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true })
-- Util.map.nnoremap("k", [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true })

Util.map.nnoremap("<Leader>P", function()
  local cwd = vim.fn.expand "%:p:h"
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  print(cwd .. "/" .. fname)
end)

local function replace_keymap(confirmation, visual)
  local text = [[:%s/]]
  local search_string = ""
  if visual then
    search_string = Util.map.getVisualSelection()
  else
    text = text .. [[\<]]
    search_string = vim.fn.expand "<cword>"
  end
  text = text .. Util.map.escape(search_string, "[]")
  if not visual then
    text = text .. [[\>]]
  end
  text = text .. "/" .. Util.map.escape(search_string, "&")
  if confirmation then
    text = text .. [[/gcI]]
  else
    text = text .. [[/gI]]
  end
  Util.map.type_no_escape(text)

  if not_vscode() then
    local move_text = [[<Left><Left><Left>]]
    if confirmation then
      move_text = move_text .. [[<Left>]]
    end
    Util.map.type_escape(move_text)
  end
end

Util.map.nnoremap("sr", function()
  replace_keymap(false, false)
end, { desc = "Misc: find and [r]eplace word under cursor" })
Util.map.vnoremap("sr", [["zy:%s/<C-r><C-o>"/]], { desc = "Misc: find and [r]eplace word (visual)" })

-- Util.map.nnoremap("sc", function()
--   replace_keymap(true, false)
-- end, { desc = "Misc: find and [r]eplace word under cursor with [c]onfirmation" })
-- Util.map.nnoremap("<leader>r", function()
--   replace_keymap(false, true)
-- end, { desc = "Misc: find and [r]eplace selected" })
-- Util.map.nnoremap("<leader>rc", function()
--   replace_keymap(true, true)
-- end, { desc = "Misc: find and [r]eplace selected with [c]onfirmation" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ WINDOWS AND NAV                                          │
--  ╰──────────────────────────────────────────────────────────╯

Util.map.nnoremap("sv", "<CMD>vsplit<CR>", { desc = "WinNav: vsplit", silent = true })
Util.map.nnoremap("ss", "<CMD>split|wincmd p<CR>", { desc = "WinNav: split", silent = true })
Util.map.nnoremap("<c-w>v", [[<CMD> lua print("not allowed to use c-w v")<CR>]], { desc = "Misc: Remove" })
Util.map.nnoremap("<c-w>s", [[<CMD> lua print("not allowed to use c-w s")<CR>]], { desc = "Misc: Remove" })
-- nnoremap("sa", [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true })

Util.map.nnoremap("sw", "<CMD>wincmd =<CR>", { desc = "WinNav: wincmd =", silent = true })

Util.map.nnoremap("sJ", "<C-W>t <C-W>K", { desc = "WinNav: force to splits", silent = true })
Util.map.nnoremap("sL", "<C-W>t <C-W>H", { desc = "WinNav: force to vsplits", silent = true })

Util.map.nnoremap("sc", "<CMD>q!<CR>")
Util.map.nnoremap("sC", "<CMD>qa!<CR>")

Util.map.nnoremap("sh", "<C-w>h", { desc = "WinNav: move left", silent = true })
Util.map.nnoremap("sl", "<C-w>l", { desc = "WinNav: move right", silent = true })
Util.map.nnoremap("sj", "<C-w>j", { desc = "WinNav: move down", silent = true })
Util.map.nnoremap("sk", "<C-w>k", { desc = "WinNav: move up", silent = true })

Util.map.nnoremap("sP", [[<CMD> lua print(vim.fn.expand "%:p") <CR>]], { desc = "WinNav: printout the path curbuf" })

Util.map.nnoremap("tn", "<CMD>tabedit %<CR>", { desc = "WinNav(tab): new tab", silent = true })
Util.map.nnoremap("tc", "<CMD>tabclose<CR>", { desc = "WinNav(tab): close", silent = true })

Util.map.nnoremap("tl", "<CMD>tabn<CR>", { desc = "WinNav(tab): next tab", silent = true })
Util.map.nnoremap("th", "<CMD>tabp<CR>", { desc = "WinNav(tab): prev tab", silent = true })

Util.map.nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "WinNav(tab): first tab", silent = true })
Util.map.nnoremap("tL", "<CMD>tablast<CR>", { desc = "WinNav(tab): last tab", silent = true })

-- Alternate the buffer
local dont_alternitefile = { "qf", "Outline", "neo-tree", "OverseerList" }
Util.map.nnoremap("sbb", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  if vim.tbl_contains(dont_alternitefile, ft) then
    return
  end
  return Util.cmd.feedkey("<C-^>", "n")
end, { desc = "WinNav(buffer): alternate file" })

Util.map.nnoremap("sO", function()
  return Util.buf._only()
end, { desc = "Buffer: bufonly" })

Util.map.nnoremap("sT", "<C-w><S-t>", { desc = "WinNav(buffer): break buffer into new tab" })

Util.map.nnoremap("gH", "<CMD>bfirst<CR>", { desc = "Buffer: go to the first buffer" })
Util.map.nnoremap("gL", "<CMD>blast<CR>", { desc = "Buffer: go to the last buffer" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ COMMANDLINE                                              │
--  ╰──────────────────────────────────────────────────────────╯
-- Util.map.cnoremap("jk", "<Esc>", { desc = "Commandline: exit from cmdline" })
-- Util.map.cnoremap("<c-c>", "<Esc>", { desc = "Commandline: exit" })
Util.map.cnoremap("<c-a>", "<Home>", { desc = "Commandline: go to the first" })
Util.map.cnoremap("<c-e>", "<End>", { desc = "Commandline: go to the last" })
Util.map.cnoremap("<c-n>", "<Down>", { desc = "Commandline: next hist on text" })
Util.map.cnoremap("<c-p>", "<Up>", { desc = "Commandline: prev hist on text" })
Util.map.cnoremap("<a-n>", "<S-Down>", { desc = "Commandline: next hist" })
Util.map.cnoremap("<a-p>", "<S-Up>", { desc = "Commandline: prev hist" })

Util.map.cnoremap("<c-l>", "<Right>", { desc = "Commandline: next word" })
Util.map.cnoremap("<c-h>", "<Left>", { desc = "Commandline: prev word" })
Util.map.cnoremap("<c-f>", "<S-Right>")
Util.map.cnoremap("<c-b>", "<S-Left>")

--  ╭──────────────────────────────────────────────────────────╮
--  │ TERMINAL                                                 │
--  ╰──────────────────────────────────────────────────────────╯

Util.cmd.augroup("AddTerminalMappings", {
  event = { "TermOpen" },
  pattern = { "term://*" },
  command = function()
    if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
      Util.map.tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
      Util.map.tnoremap("<a-h>", "<cmd>wincmd h<cr>", { desc = "Terminal: left window navigation" })
      Util.map.tnoremap("<a-j>", "<cmd>wincmd j<cr>", { desc = "Terminal; down window navigation" })
      Util.map.tnoremap("<a-k>", "<cmd>wincmd k<cr>", { desc = "Terminal: up window navigation" })
      Util.map.tnoremap("<a-l>", "<cmd>wincmd l<cr>", { desc = "Terminal: right window naviation" })
      -- tnoremap("<a-/>", "<cmd>close<cr>", { desc = "Terminal: close" })
    end
  end,
})

--  ╭──────────────────────────────────────────────────────────╮
--  │ CABBREV                                                  │
--  ╰──────────────────────────────────────────────────────────╯

Util.map.cabbrev("BD", "bd!")
Util.map.cabbrev("Bd", "bd!")
Util.map.cabbrev("Bd", "bd!")
Util.map.cabbrev("Q!!", "q!")
Util.map.cabbrev("Q!", "q!")
Util.map.cabbrev("Q", "q")
-- Util.map.cabbrev("Q1", "q!")
Util.map.cabbrev("Qal", "qal!")
Util.map.cabbrev("Ql", "qal!")
Util.map.cabbrev("Qla", "qal!")
Util.map.cabbrev("W!", "update!")
Util.map.cabbrev("W", "update!")
-- Util.map.cabbrev("W1", "update!")
Util.map.cabbrev("W;", "update!")
Util.map.cabbrev("WQ", "up")
Util.map.cabbrev("Wq", "wq")
Util.map.cabbrev("bD", "bd!")
Util.map.cabbrev("bd", "bd!")
Util.map.cabbrev("q!!", "q!")
Util.map.cabbrev("ql", "q!")
Util.map.cabbrev("qla", "qal!")
-- Util.map.cabbrev("w1", "w")
Util.map.cabbrev("w;", "update!")

-- I don't need help to show when I type <F1>.
Util.map.nmap("<F1>", "<Nop>")
Util.map.imap("<F1>", "<Nop>")
Util.map.vmap("K", "<Nop>")

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
    -- ["qf"] = "bnext | bdelete #",
    ["DiffviewFileHistory"] = "DiffviewClose",
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
    cmd(buf_fts[vim.bo[0].filetype])
  else
    cmd [[q!]]
  end
end
Util.map.nnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit" })
Util.map.vnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit [visual]" })

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
  cmd.noh()
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

Util.cmd.create_command("ChangeMasterTheme", function()
  return Util.plugin.change_colors()
end, { desc = "Misc: set theme bspwm" })

Util.cmd.create_command("InfoOption", function()
  return Util.plugin.infoFoldPreview()
end, { desc = "Misc: echo options" })

Util.cmd.create_command("ImgInsert", function()
  return Util.maim.insert()
end, { desc = "Misc: echo options" })

Util.cmd.create_command("E", function()
  return cmd [[ vnew ]]
end, { desc = "Misc: echo options" })

--  ╭──────────────────────────────────────────────────────────╮
--  │ Improve scroll, credits: https://github.com/Shougo       │
--  ╰──────────────────────────────────────────────────────────╯

Util.map.nmap("zz", [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true })

-- Scroll step sideways
Util.map.nnoremap("zl", "z4l")
Util.map.nnoremap("zh", "z4h")
Util.map.nnoremap("zL", "z60l")
Util.map.nnoremap("zH", "z60h")

Util.map.nnoremap("<C-b>", [[max([winheight(0) - 2, 1]) ."<C-u>".(line('w0') <= 1 ? "H" : "M")]], { expr = true })
Util.map.nnoremap(
  "<C-f>",
  [[max([winheight(0) - 2, 1]) ."<C-d>".(line('w$') >= line('$') ? "L" : "M")]],
  { expr = true }
)

Util.map.nnoremap("<C-e>", [[(line("w$") >= line('$') ? "2j" : "4<C-e>")]], { expr = true })
Util.map.nnoremap("<C-y>", [[(line("w0") <= 1 ? "2k" : "4<C-y>")]], { expr = true })

Util.map.nnoremap("<F1>", function()
  -- local tbl_nc = {}
  -- local win_amount = vim.api.nvim_tabpage_list_wins(0)
  -- for _, winnr in ipairs(win_amount) do
  --   if not vim.tbl_contains({ "incline" }, vim.fn.getwinvar(winnr, "&syntax")) then
  --     local winbufnr = vim.fn.winbufnr(winnr)
  --
  --     if winbufnr > 0 then
  --       local winft = vim.api.nvim_buf_get_option(winbufnr, "filetype")
  --       if not vim.tbl_contains({ "notify" }, winft) and #winft > 0 then
  --         table.insert(tbl_nc, winft)
  --       end
  --     end
  --   end
  -- end
  local layout = vim.fn.winlayout()

  local nwin
  if layout[1] == "col" then -- a split window
    nwin = #layout[2]
  end
  print(tostring(nwin) .. " " .. layout[1])

  -- print(tostring(vim.inspect(tbl_nc)) .. " " .. tostring(#tbl_nc == 1))
end)

local checkconceallevel = false
Util.map.nnoremap("<Localleader>g", function()
  local col, row = Util.fzflua.rectangle_win_pojokan()
  Util.fzflua.send_cmds({
    check_todocurbuf = function()
      -- cmd(fmt("TodoTrouble cwd=%s", fn.expand "%:p"))
      cmd(fmt("TodoQuickFix cwd=%s", fn.expand "%:p"))
    end,
    check_todorepo = function()
      -- cmd(fmt("TodoTrouble cwd=%s", fn.getcwd()))
      cmd(fmt("TodoQuickFix cwd=%s", fn.getcwd()))
    end,
    toggle_background = function()
      Util.toggle.background()
    end,
    ccc_highlight_color = function()
      cmd "CccHighlighterToggle"
    end,
    ccc_pick = function()
      cmd "CccPick"
    end,
    toggleterm_left_side = function()
      cmd "ToggleTerm direction=vertical size=100"
    end,

    qf_save = function()
      cmd "SaveQfLocal"
    end,
    qf_save_global = function()
      cmd "SaveQfGlobal"
    end,
    qf_load = function()
      cmd "LoadQfLocal"
    end,
    qf_load_global = function()
      cmd "LoadQfGlobal"
    end,
    lazy = function()
      cmd "Lazy"
    end,
    toggle_conceallevel = function()
      if checkconceallevel then
        cmd [[setlocal conceallevel=2]]
        checkconceallevel = false
      else
        cmd [[setlocal conceallevel=0]]
        checkconceallevel = true
      end
    end,
  }, { winopts = { title = "Cmds", row = row, col = col } })
end)

local function normalize_return(str)
  ---@diagnostic disable-next-line: redefined-local
  local str_slice = string.gsub(str, "\n", "")
  local res = vim.split(str_slice, "\n")
  if res[1] then
    return res[1]
  end

  return str_slice
end

Util.map.nnoremap("<a-E>", function()
  local dirname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":h:p")

  local TMUX = os.getenv "TMUX"
  if not TMUX then
    local pane_left_id = tonumber(normalize_return(vim.fn.system "wezterm cli get-pane-direction Left"))
    if pane_left_id then
      vim.fn.system("wezterm cli kill-pane --pane-id " .. pane_left_id)
    end

    vim.fn.system "wezterm cli split-pane --left --percent 15"
    vim.fn.system "wezterm cli activate-pane-direction Right"

    local pane_left_id2 = tonumber(normalize_return(vim.fn.system "wezterm cli get-pane-direction Left"))
    vim.fn.system(string.format("wezterm cli send-text --no-paste 'nnn -c %s\r' --pane-id %s", dirname, pane_left_id2))

    vim.fn.system "wezterm cli activate-pane-direction Left"
  else
    vim.fn.system [[tmux select-pane -L]]

    local pane_left_current_cmd = normalize_return(
      vim.fn.system [[tmux display-message -p "#{pane_id} #{pane_current_command}" | awk '$2 == "nnn" { print $2; exit }']]
    )

    if pane_left_current_cmd == "nnn" then
      vim.fn.system "tmux kill-pane"
    end

    vim.fn.system "tmux split-pane -hb -p 15 -c '#{pane_current_path}'"
    local current_pane = normalize_return(vim.fn.system [[tmux display-message -p "#{pane_id}" ]])

    vim.fn.system(string.format("tmux send-keys -t %s 'nnn -c %s' Enter", current_pane, dirname))
  end
end)
