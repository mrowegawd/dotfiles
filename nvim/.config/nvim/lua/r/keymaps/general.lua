local silent = { silent = true }
local nosilent = { silent = false }

local fn, cmd, fmt = vim.fn, vim.cmd, string.format

local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ EDITING TEXT                                             │
-- ╰──────────────────────────────────────────────────────────╯
-- Insert mode
RUtils.map.inoremap("<c-a>", "<c-O>^", silent)
RUtils.map.inoremap("<c-e>", "<c-O>$", silent)
RUtils.map.inoremap("<c-d>", "<c-O>dw", silent)
RUtils.map.inoremap("<c-l>", "<Right>", silent)
RUtils.map.inoremap("<c-h>", "<Left>", silent)
RUtils.map.inoremap("<c-b>", "<Esc>ba", silent)
RUtils.map.inoremap("<c-f>", "<Esc>ea", silent)

RUtils.map.inoremap("hh", "<Esc>")
RUtils.map.inoremap("<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
RUtils.map.inoremap("<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ FOLDS                                                    │
-- ╰──────────────────────────────────────────────────────────╯
RUtils.map.nnoremap("<space><space>", "za", { desc = "Fold: toggle focus current fold/unfold" })
RUtils.map.nnoremap("zm", "zM", { desc = "Fold: close all" })
RUtils.map.nnoremap("<a-n>", function()
  return RUtils.fold.magic_prev_next_move()
end, { desc = "Fold: magic next closed" })
RUtils.map.nnoremap("<a-p>", function()
  return RUtils.fold.magic_prev_next_move(true)
end, { desc = "Fold: magic prev closed" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ TERMINAL                                                │
-- ╰─────────────────────────────────────────────────────────╯
RUtils.map.tnoremap("<c-h>", "<Left>", { desc = "Terminal: left char" })
RUtils.map.tnoremap("<c-l>", "<Right>", { desc = "Terminal: right char" })
RUtils.map.tnoremap("<c-b>", "<c-Left>", { desc = "Terminal: backward" })
RUtils.map.tnoremap("<c-f>", "<c-Right>", { desc = "Terminal: forward" })
RUtils.map.nnoremap("<a-CR>", RUtils.terminal.smart_split, { desc = "Terminal: open smart-split" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ WINDOWS, VIEW AND NAV                                    │
-- ╰──────────────────────────────────────────────────────────╯
-- edit window state
RUtils.map.nnoremap("sv", "<CMD>vsplit<CR>", { desc = "View: vertical split", silent = true })
RUtils.map.nnoremap("ss", "<CMD>split|wincmd p<CR>", { desc = "View: horizontal split", silent = true })
RUtils.map.nnoremap("sw", "<CMD>wincmd =<CR>", { desc = "View: reset size window to =", silent = true })
RUtils.map.nnoremap("sJ", "<C-W>t <C-W>K", { desc = "View: force view to horizontal split", silent = true })
RUtils.map.nnoremap("sL", "<C-W>t <C-W>H", { desc = "View: force view to vertical split", silent = true })

-- navigate window
RUtils.map.nnoremap("sh", "<C-w>h", { desc = "View: left window", silent = true })
RUtils.map.nnoremap("sl", "<C-w>l", { desc = "View: right window", silent = true })
RUtils.map.nnoremap("sj", "<C-w>j", { desc = "View: down window", silent = true })
RUtils.map.nnoremap("sk", "<C-w>k", { desc = "View: up window", silent = true })

-- RUtils.map.nnoremap("<a-w>h", "<C-w>h", { desc = "View: left window (mod)", silent = true })
-- RUtils.map.nnoremap("<a-w>l", "<C-w>l", { desc = "View: right window (mod)", silent = true })
-- RUtils.map.nnoremap("<a-w>j", "<C-w>j", { desc = "View: down window (mod)", silent = true })
-- RUtils.map.nnoremap("<a-w>k", "<C-w>k", { desc = "View: up window (mod)", silent = true })

if not RUtils.has "smart-splits.nvim" then
  RUtils.map.nnoremap("<a-h>", "<C-w>h", { desc = "View: left window (mod)", silent = true })
  RUtils.map.nnoremap("<a-l>", "<C-w>l", { desc = "View: right window (mod)", silent = true })
  RUtils.map.nnoremap("<a-j>", "<C-w>j", { desc = "View: down window (mod)", silent = true })
  RUtils.map.nnoremap("<a-k>", "<C-w>k", { desc = "View: up window (mod)", silent = true })

  -- Resize window using
  RUtils.map.nnoremap("<a-K>", "<cmd>resize +4<cr>", { desc = "View: incease window height" })
  RUtils.map.nnoremap("<a-J>", "<cmd>resize -4<cr>", { desc = "View: increase window height" })
  RUtils.map.nnoremap("<a-H>", "<cmd>vertical resize -4<cr>", { desc = "View: decrease window width" })
  RUtils.map.nnoremap("<a-L>", "<cmd>vertical resize +4<cr>", { desc = "View: increase window width" })
end

-- RUtils.map.nnoremap("sm", RUtils.toggle.maximize, { desc = "View: toggle zoom" })
-- RUtils.map.nnoremap("<a-m>", RUtils.toggle.maximize, { desc = "View: toggle zoom" })

-- Tab
RUtils.map.nnoremap("tn", "<CMD>tabedit %<CR>", { desc = "Tab: new tab", silent = true })
RUtils.map.nnoremap("tc", "<CMD>tabclose<CR>", { desc = "Tab: close tab", silent = true })

RUtils.map.nnoremap("tl", "<CMD>tabnext<CR>", { desc = "Tab: next tab", silent = true })
RUtils.map.nnoremap("th", "<CMD>tabprevious<CR>", { desc = "Tab: prev tab", silent = true })
RUtils.map.nnoremap("<c-a-l>", "<CMD>tabnext<CR>", { desc = "Tab: next tab (mod)", silent = true })
RUtils.map.nnoremap("<c-a-h>", "<CMD>tabprevious<CR>", { desc = "Tab: prev tab (mod)", silent = true })

RUtils.map.nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Tab: first tab", silent = true })
RUtils.map.nnoremap("tL", "<CMD>tablast<CR>", { desc = "Tab: last tab", silent = true })

-- ╭─────────────────────────────────────────────────────────╮
-- │ BUFFER                                                  │
-- ╰─────────────────────────────────────────────────────────╯
RUtils.map.nnoremap("<Leader>bT", "<C-w><S-t>", { desc = "Buffer: break buffer/change to new tab" })
RUtils.map.nnoremap("<Leader>bO", RUtils.buf._only, { desc = "Buffer: buffonly" })
RUtils.map.nnoremap("<Leader>bb", "<cmd>e #<cr>", { desc = "Buffer: switch to other buffer" })
RUtils.map.nnoremap("<Leader>bd", RUtils.ui.bufremove, { desc = "Buffer: delete buffer" })
RUtils.map.nnoremap("<a-x>", "<CMD>q!<CR>", { desc = "Buffer: close buffer" })
RUtils.map.nnoremap("<Leader>bn", "<CMD>vnew<CR>", { desc = "Buffer: close buffer" })
RUtils.map.nnoremap("gh", function()
  return RUtils.fold.magic_prev_next_qf(true)
end, { desc = "Buffer: magic gh" })
RUtils.map.nnoremap("gl", function()
  return RUtils.fold.magic_prev_next_qf()
end, { desc = "Buffer: magic gl" })

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
    else
      cmd(buf_fts[vim.bo[0].filetype])
    end
  else
    cmd [[q!]]
  end
end
RUtils.map.nnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit" })
RUtils.map.vnoremap("<Leader><TAB>", magic_quit, { desc = "Buffer: magic exit (visual)" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ COMMANDLINE                                              │
-- ╰──────────────────────────────────────────────────────────╯
RUtils.map.cnoremap("hh", "<c-c>", { desc = "Commandline: exit" })
RUtils.map.cnoremap("<c-a>", "<Home>", { desc = "Commandline: go to first line" })
RUtils.map.cnoremap("<c-e>", "<End>", { desc = "Commandline: go to the last line" })
RUtils.map.cnoremap("<c-n>", "<Down>", { desc = "Commandline: next hist" })
RUtils.map.cnoremap("<c-p>", "<Up>", { desc = "Commandline: prev hist" })
RUtils.map.cnoremap("<a-n>", "<S-Down>", { desc = "Commandline: next hist" })
RUtils.map.cnoremap("<a-p>", "<S-Up>", { desc = "Commandline: prev hist" })
RUtils.map.cnoremap("<c-l>", "<Right>", { desc = "Commandline: next word" })
RUtils.map.cnoremap("<c-h>", "<Left>", { desc = "Commandline: prev word" })
RUtils.map.cnoremap("<c-f>", "<S-Right>", { desc = "Commandline: forward word" })
RUtils.map.cnoremap("<c-b>", "<S-Left>", { desc = "Commandline: backward word" })

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
RUtils.map.nmap("<F1>", "<Nop>")
RUtils.map.imap("<F1>", "<Nop>")
RUtils.map.vmap("K", "<Nop>")

-- ╭─────────────────────────────────────────────────────────╮
-- │ COMMANDS                                                │
-- ╰─────────────────────────────────────────────────────────╯
RUtils.cmd.create_command("Snippets", RUtils.plugin.EditSnippet, { desc = "Misc: edit snippet file" })
-- RUtils.cmd.create_command("CBcatalog", require("comment-box").catalog, { desc = "Misc: show catalog [comment-box]" })
RUtils.cmd.create_command("ChangeMasterTheme", RUtils.plugin.change_colors, { desc = "Misc: set theme bspwm" })
RUtils.cmd.create_command("InfoOption", RUtils.plugin.infoFoldPreview, { desc = "Misc: echo options" })
RUtils.cmd.create_command("ImgInsert", RUtils.maim.insert, { desc = "Misc: echo options" })
RUtils.cmd.create_command("E", function()
  return cmd [[ vnew ]]
end, { desc = "Misc: vnew" })
-- ╭─────────────────────────────────────────────────────────╮
-- │ SCROLL                                                  │
-- ╰─────────────────────────────────────────────────────────╯
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

-- ╭─────────────────────────────────────────────────────────╮
-- │ TOGGLE                                                  │
-- ╰─────────────────────────────────────────────────────────╯

RUtils.map.nnoremap("<Leader>uF", function()
  RUtils.format.toggle()
end, { desc = "Toggle: toggle auto format (global)" })
RUtils.map.nnoremap("<Leader>uf", function()
  RUtils.format.toggle(true)
end, { desc = "Toggle: auto format (buffer)" })
RUtils.map.nnoremap("<Leader>uw", function()
  RUtils.toggle "wrap"
end, { desc = "Toggle: wrap" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
RUtils.map.nnoremap("<Leader>uL", function()
  RUtils.toggle "relativenumber"
end, { desc = "Toggle: relative line numbers" })
RUtils.map.nnoremap("<Leader>ul", function()
  RUtils.toggle.number()
end, { desc = "Toggle: line numbers" })
RUtils.map.nnoremap("<Leader>uc", function()
  RUtils.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle: conceal" })
RUtils.map.nnoremap("<Leader>us", function()
  RUtils.toggle "spell"
end, { desc = "Toggle: spelling" })
RUtils.map.nnoremap("<Leader>ud", function()
  RUtils.toggle.diagnostics()
end, { desc = "Toggle: diagnostic" })
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  RUtils.map.nnoremap("<Leader>uh", function()
    RUtils.toggle.inlay_hints()
  end, { desc = "Toggle: inlay hints" })
end
RUtils.map.nnoremap("<Leader>ub", function()
  RUtils.toggle("background", false, { "light", "dark" })
end, { desc = "Toggle: background" })
RUtils.map.nnoremap("<Leader>uT", function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
  else
    vim.treesitter.start()
  end
end, { desc = "Toggle: treesitter highlight" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ MISC                                                     │
-- ╰──────────────────────────────────────────────────────────╯
-- General
RUtils.map.nnoremap("<c-g>", "/", nosilent)
RUtils.map.nnoremap("~", "%", { desc = "Misc: go to.. matching tag" })
RUtils.map.nnoremap("g,", "g,zvzz", silent) -- go last edit
RUtils.map.nnoremap("g;", "g;zvzz", silent) -- go prev edit
RUtils.map.vnoremap("p", "pgvy")
RUtils.map.nnoremap("<Leader>Y", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or ""
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Yanked absolute path" })
end, { silent = true, desc = "Misc: yank current absolute path" })
RUtils.map.nnoremap("Y", "y$", { desc = "Yank to end of line" })

RUtils.map.nnoremap("<Leader>n", cmd.nohl, { desc = "Misc: clear searches" })
RUtils.map.nnoremap("<ESC>", cmd.noh, { desc = "Misc: clear searches" })
RUtils.map.inoremap("<ESC>", cmd.noh, { desc = "Misc: clear searches" })

RUtils.map.nnoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
RUtils.map.xnoremap("n", "'Nn'[v:searchforward]", { expr = true, desc = "Misc: next search result" })
RUtils.map.onoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
RUtils.map.nnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
RUtils.map.xnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
RUtils.map.onoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })

-- Visual
RUtils.map.xnoremap("il", "<Esc>^vg_", { desc = "View: dont mistake (x)" })
RUtils.map.onoremap("il", "<CMD><C-U>normal! ^vg_<CR>", { desc = "View: dont mistake (o)" })

RUtils.map.xnoremap("al", "$o0", { desc = "View: jump in (x)" })
RUtils.map.onoremap("al", "<CMD><C-u>normal val<CR>", { desc = "View: jump out (o)" })

RUtils.map.vnoremap(">", ">gv", { desc = "Misc: next align lines (visual)" })
RUtils.map.vnoremap("<", "<gv", { desc = "Misc: prev align lines (visual)" })

RUtils.map.nnoremap("vv", [[^vg_]], { desc = "Misc: select text lines" })

RUtils.map.nnoremap("<Leader>cd", function()
  local filepath = fn.expand "%:p:h" -- code
  cmd(fmt("cd %s", filepath))
  vim.notify(fmt("ROOT CHANGED: %s", filepath))
end, { desc = "Misc: change pwd to dir file" })

-- allow moving the cursor through wrapped lines using j and k,
-- note that I have line wrapping turned off but turned on only for Markdown
RUtils.map.nnoremap("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
RUtils.map.nnoremap("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
RUtils.map.vnoremap("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
RUtils.map.vnoremap("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

RUtils.map.nnoremap("<Leader>P", function()
  local cwd = vim.fn.expand "%:p:h"
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  RUtils.info(cwd .. "/" .. fname)
end, { desc = "Misc: printout current path" })

local function replace_keymap(confirmation, visual)
  confirmation = confirmation or false
  visual = visual or false
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

RUtils.map.nnoremap("sr", replace_keymap, { desc = "Misc: find and replace under cursor" })
RUtils.map.vnoremap("sr", [["zy:%s/<C-r><C-o>"/]], { desc = "Misc: find and replace (visual)" })

RUtils.map.nnoremap("<Leader>oo", function()
  return RUtils.markdown.follow_link(false)
end, { desc = "Misc: magic follow link" })

RUtils.map.vnoremap("<Leader>oo", function()
  return RUtils.markdown.follow_link(true)
end, { desc = "Misc: magic follow link (visual)" })

RUtils.map.nnoremap("?", RUtils.map.show_help_buf_keymap, {
  desc = "MISC: show keymap helps curbuf",
  silent = true,
})

RUtils.map.nnoremap("<a-o>", function()
  local win_height = math.ceil(RUtils.cmd.get_option "lines" * 0.5)
  local win_width = math.ceil(RUtils.cmd.get_option "columns" * 1)

  local col = math.ceil((win_width / 2) - 40)
  local row = math.ceil((RUtils.cmd.get_option "lines" - win_height) - 10)

  RUtils.fzflua.send_cmds({
    clock_mode = function()
      RUtils.terminal.clock_mode()
    end,
  }, { winopts = { title = "Mods commands", row = row, col = col } })
end, { desc = "Misc: list commands" })

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
    toggle_undotree = function()
      cmd "UndotreeToggle"
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
