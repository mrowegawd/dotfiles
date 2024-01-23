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
Util.map.nnoremap("p", function()
  vim.cmd.normal { vim.v.count1 .. "P`[", bang = true }
end, silent)

Util.map.inoremap("<c-j>", "<Down>", silent)
Util.map.inoremap("<c-k>", "<Up>", silent)
Util.map.inoremap("<c-l>", "<Right>", silent)
Util.map.inoremap("<c-h>", "<Left>", silent)

Util.map.inoremap("<c-b>", "<Esc>ba", silent)
Util.map.inoremap("<c-f>", "<Esc>ea", silent)

Util.map.nnoremap("<c-g>", "/", nosilent)
Util.map.vnoremap("<c-g>", [["zy:%s/<C-r><C-o>"/]], { desc = "Search and replace on the fly" })

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
  ---@diagnostic disable-next-line: missing-fields
  require("notify").dismiss {}
  cmd.nohl()
  return vim.cmd [[let @/ = ""]]
end, { desc = "Misc: clear searches" })

Util.map.nnoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
Util.map.xnoremap("n", "'Nn'[v:searchforward]", { expr = true, desc = "Misc: next search result" })
Util.map.onoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
Util.map.nnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
Util.map.xnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
Util.map.onoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })

-- Save jumps > 3 lines to the jumplist
-- Jumps <= 3 respect line wraps
Util.map.nnoremap("k", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'k' : 'gk']], { expr = true })
Util.map.nnoremap("j", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'j' : 'gj']], { expr = true })

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
Util.map.nnoremap("ss", "<CMD>split<CR>", { desc = "WinNav: split", silent = true })
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

if not Util.has "bufferline.nvim" then
  Util.map.nnoremap("sO", function()
    return Util.buf._only()
  end, { desc = "Buffer: bufonly" })
end

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
    ["DiffviewFileHistory"] = "DiffviewClose",
  }

  if buf_fts[vim.bo[0].filetype] then
    vim.cmd(buf_fts[vim.bo[0].filetype])
  else
    vim.cmd [[q!]]
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
  return vim.cmd [[ vnew ]]
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

local buf, win
Util.map.nnoremap("<F1>", function()
  local function create_win()
    vim.api.nvim_command "botright vnew"
    win = vim.api.nvim_get_current_win()
    buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_name(0, "result #" .. buf)

    vim.api.nvim_buf_set_option(0, "buftype", "nofile")
    vim.api.nvim_buf_set_option(0, "swapfile", false)
    -- vim.api.nvim_buf_set_option(0, "filetype", filetype)
    vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

    vim.api.nvim_command "setlocal wrap"
  end
  local function on_stdout(_, data)
    if data then
      for _, line in ipairs(data) do
        if line ~= "" then
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
        end
      end
    end
  end

  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  create_win()

  vim.fn.jobstart({ "cargo", "run" }, {
    on_stdout = on_stdout,
    on_stderr = on_stdout,
    stdout_buffered = false,
    stderr_buffered = false,
  })

  vim.cmd [[wincmd p]]
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
      vim.cmd "CccHighlighterToggle"
    end,
    ccc_pick = function()
      vim.cmd "CccPick"
    end,
    toggleterm_left_side = function()
      vim.cmd "ToggleTerm direction=vertical size=100"
    end,

    qf_save = function()
      vim.cmd "SaveQfLocal"
    end,
    qf_save_global = function()
      vim.cmd "SaveQfGlobal"
    end,
    qf_load = function()
      vim.cmd "LoadQfLocal"
    end,
    qf_load_global = function()
      vim.cmd "LoadQfGlobal"
    end,
    lazy = function()
      vim.cmd "Lazy"
    end,
    toggle_conceallevel = function()
      if checkconceallevel then
        vim.cmd [[setlocal conceallevel=2]]
        checkconceallevel = false
      else
        vim.cmd [[setlocal conceallevel=0]]
        checkconceallevel = true
      end
    end,
  }, { winopts = { title = "Cmds", row = row, col = col } })
end)
