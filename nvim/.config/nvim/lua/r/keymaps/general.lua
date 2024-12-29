local silent = { silent = true }
local nosilent = { silent = false }

local fn, cmd, fmt = vim.fn, vim.cmd, string.format

local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

vim.cmd.highlight "Overnesting guibg=#E06C75"
vim.fn.matchadd("Overnesting", ("\t"):rep(5) .. "\t*")

-- ╭──────────────────────────────────────────────────────────╮
-- │ EDITING TEXT                                             │
-- ╰──────────────────────────────────────────────────────────╯

-- Insert mode
RUtils.map.inoremap("<C-a>", "<C-O>^", silent)
RUtils.map.inoremap("<C-e>", "<C-O>$", silent)
RUtils.map.inoremap("<C-d>", "<esc>yypi", silent)
RUtils.map.inoremap("<C-l>", "<Right>", silent)
RUtils.map.inoremap("<C-h>", "<Left>", silent)
-- RUtils.map.inoremap("<C-b>", "<Esc>ba", silent)
RUtils.map.inoremap("<C-b>", "<Esc>bi", silent)
RUtils.map.inoremap("<C-f>", "<Esc>ea", silent)

-- RUtils.map.inoremap("hh", "<Esc>")
RUtils.map.inoremap("hh", function()
  vim.cmd "noh"
  RUtils.cmp.actions.snippet_stop()
  return "<Esc>"
end, { desc = "Misc: escape and clear hlsearch", expr = true, silent = true })
-- RUtils.map.inoremap("<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
-- RUtils.map.inoremap("<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ FOLDS                                                    │
-- ╰──────────────────────────────────────────────────────────╯

RUtils.map.nnoremap("<BS>", "zazz", { desc = "Fold: toggle focus current fold/unfold" })
RUtils.map.nnoremap("zm", "zM", { desc = "Fold: close all" })
RUtils.map.nnoremap("<c-n>", function()
  return RUtils.fold.magic_jump_qf_or_fold()
end, { desc = "Fold: magic next closed" })
RUtils.map.nnoremap("<c-p>", function()
  return RUtils.fold.magic_jump_qf_or_fold(true)
end, { desc = "Fold: magic prev closed" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ TERMINAL                                                │
-- ╰─────────────────────────────────────────────────────────╯

RUtils.map.nnoremap("<a-CR>", RUtils.terminal.smart_split, { desc = "Terminal: open smart-split" })
RUtils.map.tnoremap("qq", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
RUtils.map.tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
RUtils.map.tnoremap("<a-x>", function()
  local buf = vim.api.nvim_get_current_buf()
  require("bufdelete").bufdelete(buf, true)
end, { desc = "Terminal: close terminal" })
RUtils.map.tnoremap("<a-w>", function()
  RUtils.map.feedkey("<C-\\><C-n>", "t")
  require("fzf-lua").tabs()
end, { desc = "Terminal: show tabs [fzflua]" })
RUtils.map.tnoremap("<c-a-l>", function()
  RUtils.map.feedkey("<C-\\><C-n><c-a-l>", "t")
end, { desc = "Terminal: next tab" })
RUtils.map.tnoremap("<c-a-h>", function()
  RUtils.map.feedkey("<C-\\><C-n><c-a-h>", "t")
end, { desc = "Terminal: prev tab" })
RUtils.map.tnoremap("<a-f>", function()
  RUtils.map.feedkey("<C-\\><C-n><a-f>", "t")
  -- RUtils.terminal.toggle_right_term()
end, { desc = "Terminal: new term split" })
RUtils.map.tnoremap("<a-N>", function()
  RUtils.map.feedkey("<C-\\><C-n><a-N>", "t")
end, { desc = "Terminal: new tabterm" })
RUtils.map.tnoremap("<a-CR>", function()
  RUtils.terminal.smart_split()
end, { desc = "Terminal: new term" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ WINDOWS, VIEW AND NAV                                    │
-- ╰──────────────────────────────────────────────────────────╯

-- Edit window state
RUtils.map.nnoremap("sv", "<CMD>vsplit<CR>", { desc = "View: vertical split", silent = true })
RUtils.map.nnoremap("ss", "<CMD>split<CR>", { desc = "View: horizontal split", silent = true })
RUtils.map.nnoremap("sw", "<CMD>wincmd =<CR>", { desc = "View: reset size window to =", silent = true })
RUtils.map.nnoremap("sJ", "<C-W>t <C-W>K", { desc = "View: force view to horizontal split", silent = true })
RUtils.map.nnoremap("sL", "<C-W>t <C-W>H", { desc = "View: force view to vertical split", silent = true })
RUtils.map.nnoremap("sc", "<CMD>q!<CR>", { desc = "Buffer: close buffer" })

-- Navigate window
RUtils.map.nnoremap("sh", "<C-w>h", { desc = "View: left window", silent = true })
RUtils.map.nnoremap("sl", "<C-w>l", { desc = "View: right window", silent = true })
RUtils.map.nnoremap("sj", "<C-w>j", { desc = "View: down window", silent = true })
RUtils.map.nnoremap("sk", "<C-w>k", { desc = "View: up window", silent = true })

-- RUtils.map.nnoremap("<a-w>h", "<C-w>h", { desc = "View: left window (mod)", silent = true })
-- RUtils.map.nnoremap("<a-w>l", "<C-w>l", { desc = "View: right window (mod)", silent = true })
-- RUtils.map.nnoremap("<a-w>j", "<C-w>j", { desc = "View: down window (mod)", silent = true })
-- RUtils.map.nnoremap("<a-w>k", "<C-w>k", { desc = "View: up window (mod)", silent = true })

-- RUtils.map.nnoremap("<a-h>", "<C-w>h", { desc = "View: left window (mod)", silent = true })
-- RUtils.map.nnoremap("<a-l>", "<C-w>l", { desc = "View: right window (mod)", silent = true })
-- RUtils.map.nnoremap("<a-j>", "<C-w>j", { desc = "View: down window (mod)", silent = true })
-- RUtils.map.nnoremap("<a-k>", "<C-w>k", { desc = "View: up window (mod)", silent = true })

if not RUtils.has "smart-splits.nvim" then
  RUtils.map.nnoremap("<a-K>", "<cmd>resize +4<cr>", { desc = "View: incease window height" })
  RUtils.map.nnoremap("<a-J>", "<cmd>resize -4<cr>", { desc = "View: increase window height" })
  RUtils.map.nnoremap("<a-H>", "<cmd>vertical resize -4<cr>", { desc = "View: decrease window width" })
  RUtils.map.nnoremap("<a-L>", "<cmd>vertical resize +3<cr>", { desc = "View: increase window width" })
end

-- Tab
RUtils.map.nnoremap("tn", "<CMD>tabedit %<CR>", { desc = "Tab: new tab", silent = true })
RUtils.map.nnoremap("st", "<CMD>tabedit %<CR>", { desc = "Tab: view buffer in new tab", silent = true })

RUtils.map.nnoremap("tc", "<CMD>tabclose<CR>", { desc = "Tab: close tab", silent = true })

RUtils.map.nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Tab: first tab", silent = true })
RUtils.map.nnoremap("tL", "<CMD>tablast<CR>", { desc = "Tab: last tab", silent = true })

RUtils.map.nnoremap("tl", "<CMD>tabnext<CR>", { desc = "Tab: next tab", silent = true })
RUtils.map.nnoremap("th", "<CMD>tabprevious<CR>", { desc = "Tab: prev tab", silent = true })

-- These mappings works only outside tmux
RUtils.map.nnoremap("<C-a-l>", "<CMD>tabnext<CR>", { desc = "Tab: next tab (mod)", silent = true })
RUtils.map.nnoremap("<C-a-h>", "<CMD>tabprevious<CR>", { desc = "Tab: prev tab (mod)", silent = true })

-- ╭─────────────────────────────────────────────────────────╮
-- │ BUFFER                                                  │
-- ╰─────────────────────────────────────────────────────────╯

RUtils.map.nnoremap("<Leader>bT", "<C-w><S-t>", { desc = "Buffer: change buffer split into tab window" })
RUtils.map.nnoremap("<Leader>bb", "<C-^>", { desc = "Buffer: alternate file" })
RUtils.map.nnoremap("<Leader>bd", RUtils.ui.bufremove, { desc = "Buffer: delete buffer" })
RUtils.map.nnoremap("<a-x>", "<CMD>q!<CR>", { desc = "Buffer: close buffer" })
RUtils.map.nnoremap("<Leader>bn", "<CMD>vnew<CR>", { desc = "Buffer: open split new buffer" })
RUtils.map.nnoremap("gh", function()
  return RUtils.fold.magic_nextprev_list_qf_or_buf(true)
end, { desc = "Buffer/Qf: magic gh" })
RUtils.map.nnoremap("gl", function()
  return RUtils.fold.magic_nextprev_list_qf_or_buf()
end, { desc = "Buffer/Qf: magic gl" })
RUtils.map.nnoremap("<Leader><TAB>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit" })
RUtils.map.vnoremap("<Leader><TAB>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit (visual)" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ COMMANDLINE                                              │
-- ╰──────────────────────────────────────────────────────────╯

RUtils.map.cnoremap("hh", "<C-c>", { desc = "Commandline: exit" })
RUtils.map.cnoremap("<C-a>", "<Home>", { desc = "Commandline: go to first line" })
RUtils.map.cnoremap("<C-e>", "<End>", { desc = "Commandline: go to the last line" })
RUtils.map.cnoremap("<C-n>", "<Down>", { desc = "Commandline: next hist" })
RUtils.map.cnoremap("<C-p>", "<Up>", { desc = "Commandline: prev hist" })
RUtils.map.cnoremap("<C-l>", "<Right>", { desc = "Commandline: next word" })
RUtils.map.cnoremap("<C-h>", "<Left>", { desc = "Commandline: prev word" })
RUtils.map.cnoremap("<C-f>", "<S-Right>", { desc = "Commandline: forward word" })
RUtils.map.cnoremap("<C-b>", "<S-Left>", { desc = "Commandline: backward word" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ CABBREV                                                  │
-- ╰──────────────────────────────────────────────────────────╯

RUtils.map.cabbrev("BD", "bd!")
RUtils.map.cabbrev("Bd", "bd!")
RUtils.map.cabbrev("Bd", "bd!")
RUtils.map.cabbrev("Q!!", "q!")
RUtils.map.cabbrev("Q!", "q!")
RUtils.map.cabbrev("Q", "q")
RUtils.map.cabbrev("Qal", "qal!")
RUtils.map.cabbrev("Ql", "qal!")
RUtils.map.cabbrev("Qla", "qal!")
RUtils.map.cabbrev("W!", "update!")
RUtils.map.cabbrev("W", "update!")
RUtils.map.cabbrev("W;", "update!")
RUtils.map.cabbrev("WQ", "up")
RUtils.map.cabbrev("Wq", "wq")
RUtils.map.cabbrev("bD", "bd!")
RUtils.map.cabbrev("bd", "bd!")
RUtils.map.cabbrev("q!!", "q!")
RUtils.map.cabbrev("ql", "q!")
RUtils.map.cabbrev("qla", "qal!")
RUtils.map.cabbrev("w;", "update!")

RUtils.map.vmap("K", "<Nop>")
RUtils.map.nmap("q", "<Nop>")

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

-- Scroll Up/Down
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

Snacks.toggle.zoom():map "sm"
Snacks.toggle.zen():map "<Leader>uz"
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<Leader>ub"
Snacks.toggle.option("wrap", { name = "Wrap" }):map "<Leader>uw"
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<Leader>uL"
Snacks.toggle.line_number():map "<leader>ul"
--stylua: ignore
Snacks.toggle .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }) :map "<Leader>uc"
--stylua: ignore
Snacks.toggle .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }) :map "<Leader>uA"

Snacks.toggle.diagnostics():map "<Leader>ud"
Snacks.toggle.option("spell", { name = "Spelling" }):map "<Leader>us"
Snacks.toggle.scroll():map "<Leader>uS"
Snacks.toggle.animate():map "<Leader>ua"
Snacks.toggle.treesitter():map "<Leader>uT"

Snacks.toggle.profiler():map "<Localleader>spp"
Snacks.toggle.profiler_highlights():map "<Localleader>sph"

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map "<Leader>uh"
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ DIFF                                                    │
-- ╰─────────────────────────────────────────────────────────╯

-- Create a new scratch buffer
vim.api.nvim_create_user_command("Ns", function()
  vim.cmd [[
		execute 'vsplit | enew'
		setlocal buftype=nofile
		setlocal bufhidden=hide
		setlocal noswapfile
	]]
end, { nargs = 0 })

-- Compare the clipboard to the current buffer
vim.api.nvim_create_user_command("CompareClipboard", function()
  local ftype = vim.api.nvim_eval "&filetype" -- original filetype
  vim.cmd [[
		tabnew %
		Ns
		normal! P
		windo diffthis
	]]
  vim.cmd("set filetype=" .. ftype)
end, { nargs = 0 })

-- Compare the clipboard to a visual selection
vim.api.nvim_create_user_command("CompareClipboardSelection", function()
  vim.cmd [[
		" yank visual selection to z register
		normal! gv"zy
		" open new tab, set options to prevent save prompt when closing
		execute 'tabnew | setlocal buftype=nofile bufhidden=hide noswapfile'
		" paste z register into new buffer
		normal! V"zp
		Ns
		normal! Vp
    " alternative: diffview
		windo diffthis
	]]
end, {
  nargs = 0,
  range = true,
})

RUtils.map.vnoremap(
  "<Leader>gV",
  "<esc><cmd>CompareClipboardSelection<cr>",
  { desc = "Git: compare diff with selection clipboard (visual)" }
)

-- ╭──────────────────────────────────────────────────────────╮
-- │ MISC                                                     │
-- ╰──────────────────────────────────────────────────────────╯

RUtils.map.nnoremap("<Esc>", function()
  vim.cmd "noh"
  RUtils.cmp.actions.snippet_stop()
  return "<Esc>"
end, { desc = "Misc: escape and clear hlsearch", expr = true, silent = true })
RUtils.map.inoremap("<Esc>", function()
  vim.cmd "noh"
  RUtils.cmp.actions.snippet_stop()
  return "<Esc>"
end, { desc = "Misc: escape and clear hlsearch", expr = true, silent = true })
RUtils.map.nnoremap(
  "<Leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Misc: redraw / clear hlsearch / diff update" }
)
RUtils.map.nnoremap("dd", function()
  if vim.fn.getline "." == "" then
    return '"_dd'
  end
  return "dd"
end, { expr = true })
RUtils.map.nnoremap("<C-g>", "/", nosilent)
RUtils.map.nnoremap("~", "%", { desc = "Misc: go to.. matching tag" })
RUtils.map.nnoremap("g,", "g,zvzz", silent) -- go last edit
RUtils.map.nnoremap("g;", "g;zvzz", silent) -- go prev edit
RUtils.map.vnoremap("p", "pgvy")
RUtils.map.nnoremap("<Leader>cd", function()
  local filepath = fn.expand "%:p:h" -- code
  vim.cmd(fmt("cd %s", filepath))
  vim.notify(fmt("ROOT CHANGED: %s", filepath))
end, { desc = "Action: change pwd to dir file" })
RUtils.map.nnoremap("<Leader>Y", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or ""
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Yanked absolute path" })
end, { silent = true, desc = "Misc: yank current absolute path" })
RUtils.map.nnoremap("<Leader>n", vim.cmd.nohl, { desc = "Misc: clear searches" })
RUtils.map.vnoremap(">", ">gv", { desc = "Misc: next align lines (visual)" })
RUtils.map.vnoremap("<", "<gv", { desc = "Misc: prev align lines (visual)" })
RUtils.map.nnoremap("vv", [[^vg_]], { desc = "Misc: select text lines" })
RUtils.map.nnoremap("<Leader>P", function()
  local cwd = vim.fn.expand "%:p:h"
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  RUtils.info(cwd .. "/" .. fname, { title = "Current path" })
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
end, { desc = "Open: browse under cursor/follow linke note" })
RUtils.map.vnoremap("<Leader>oo", function()
  return RUtils.markdown.follow_link(true)
end, { desc = "Open: browse under cursor/follow linke note (visual)" })
RUtils.map.nnoremap("<F1>", RUtils.map.show_help_buf_keymap, {
  desc = "Misc: show keymaps curbuf",
  silent = true,
})

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
RUtils.map.nnoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
RUtils.map.xnoremap("n", "'Nn'[v:searchforward]", { expr = true, desc = "Misc: next search result" })
RUtils.map.onoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
RUtils.map.nnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
RUtils.map.xnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
RUtils.map.onoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })

-- Allow moving the cursor through wrapped lines using j and k,
-- note that I have line wrapping turned off but turned on only for Markdown
RUtils.map.nnoremap("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
RUtils.map.nnoremap("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
RUtils.map.vnoremap("j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
RUtils.map.vnoremap("k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- Visual
-- RUtils.map.xnoremap("il", "<Esc>^vg_", { desc = "View: dont mistake (x)" })
-- RUtils.map.onoremap("il", "<CMD><C-U>normal! ^vg_<CR>", { desc = "View: dont mistake (o)" })

-- RUtils.map.xnoremap("al", "$o0", { desc = "View: jump in (x)" })
-- RUtils.map.onoremap("al", "<CMD><C-u>normal val<CR>", { desc = "View: jump out (o)" })

if vim.fn.executable "lazygit" == 1 then
  RUtils.map.nnoremap("<Leader>gg", function()
    Snacks.lazygit { cwd = RUtils.root.git() }
  end, { desc = "Git: lazygit (root dir) [snacks]" })
  RUtils.map.nnoremap("<Leader>gG", function()
    Snacks.lazygit()
  end, { desc = "Git: lazygit (cwd) [snacks]" })
  -- RUtils.map.nnoremap("<Leader>gf", function()
  --   Snacks.lazygit.log_file()
  -- end, { desc = "Git: lazygit current file history" })
  -- RUtils.map.nnoremap("<Leader>gL", function()
  --   Snacks.lazygit.log { cwd = RUtils.root.git() }
  -- end, { desc = "Git: lazygit log" })
  -- RUtils.map.nnoremap("<Leader>gLL", function()
  --   Snacks.lazygit.log()
  -- end, { desc = "Git: lazygit log (cwd)" })
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ COMMANDS                                                │
-- ╰─────────────────────────────────────────────────────────╯

RUtils.cmd.create_command("Snippets", RUtils.plugin.EditSnippet, { desc = "Misc: edit snippet file" })
RUtils.cmd.create_command("ChangeMasterTheme", RUtils.plugin.change_colors, { desc = "Misc: set theme bspwm" })
RUtils.cmd.create_command("InfoOption", RUtils.plugin.infoFoldPreview, { desc = "Misc: echo options" })
RUtils.cmd.create_command("ImgInsert", RUtils.maim.insert, { desc = "Misc: echo options" })
RUtils.cmd.create_command("E", function()
  return cmd [[ vnew ]]
end, { desc = "Misc: vnew" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ BULK COMMANDS                                           │
-- ╰─────────────────────────────────────────────────────────╯

-- These commands run outside tmux
local func_cmds = function()
  local win_height = math.ceil(RUtils.cmd.get_option "lines" * 0.5)
  local win_width = math.ceil(RUtils.cmd.get_option "columns" * 1)

  local col = math.ceil((win_width / 2) - 40)
  local row = math.ceil((RUtils.cmd.get_option "lines" - win_height) - 10)

  RUtils.fzflua.send_cmds({
    clock_mode = function()
      RUtils.terminal.clock_mode()
    end,
    newsboat = function()
      RUtils.terminal.float_newsboat()
    end,
    calcure = function()
      RUtils.terminal.float_calcure()
    end,
    btop = function()
      RUtils.terminal.float_btop()
    end,
    rust_upserv = function()
      print "sf"
    end,
    rust_upserv2 = function()
      print "sf"
    end,
    rust_bench = function()
      print "sf"
    end,
    gravterm = function()
      print "sf"
    end,
    log_meta = function()
      print "sf"
    end,
    r_kill = function()
      RUtils.terminal.float_rkill()
    end,
  }, { winopts = { title = "fz-ctrlo", row = row, col = col } })
end
RUtils.map.nnoremap("<a-o>", func_cmds, { desc = "Misc: list commands" })
RUtils.map.tnoremap("<a-o>", func_cmds, { desc = "Misc: list commands" })
RUtils.map.vnoremap("<a-o>", func_cmds, { desc = "Misc: list commands" })

RUtils.map.nnoremap("<Leader>uf", function()
  local col, row = RUtils.fzflua.rectangle_win_pojokan()
  RUtils.fzflua.send_cmds({
    loadqf = function()
      cmd "LoadQf"
    end,
    saveqf = function()
      cmd "SaveQf"
    end,
    open_url_tailwindcss = function()
      cmd "!open https://tailwindcss.com"
    end,
    lazy = function()
      cmd "Lazy"
    end,
    sourcegraph_sg = function()
      cmd "SourcegraphSearch"
    end,
    cheat = function()
      cmd "Cheat"
    end,
    cheatlist = function()
      cmd "CheatList"
    end,
    kulala = function()
      require("kulala").run()
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
    refresh_symbol_usage = function()
      require("symbol-usage").refresh()
    end,
    resume_telescope = function()
      vim.cmd [[Telescope resume]]
    end,
    resume_fzf = function()
      vim.cmd [[FzfLua resume]]
    end,
    diagnostic_lsp_lines_toggle = function()
      require("lsp_lines").toggle()
    end,
    session_load = function()
      if RUtils.has "persistence.nvim" then
        return require("persistence").load()
      end
      if RUtils.has "resession.nvim" then
        return require("resession").load()
      end
      RUtils.info "no session to load. abort it"
    end,
    session_load_cwd = function()
      if RUtils.has "resession.nvim" then
        return require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
      end
      RUtils.info "no session cwd to load. abort it"
    end,
    session_delete = function()
      if RUtils.has "resession.nvim" then
        return require("resession").delete()
      end
      RUtils.info "no plugin session actived. abort it"
    end,
    session_save = function()
      if RUtils.has "persistence.nvim" then
        return require("persistence").save()
      end
      if RUtils.has "resession.nvim" then
        return require("resession").save()
      end
      RUtils.info "no session to save or no plugin session actived. abort it"
    end,
    session_save_cwd = function()
      if RUtils.has "resession.nvim" then
        return require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
      end
      RUtils.info "no session cwd to save or no plugin session actived. abort it"
    end,
  }, { winopts = { title = "Misc commands", row = row, col = col } })
end, { desc = "Misc: list commands of misc" })
RUtils.map.nnoremap("<Leader>gf", function()
  local col, row = RUtils.fzflua.rectangle_win_pojokan()
  RUtils.fzflua.send_cmds(
    vim.tbl_deep_extend("force", {
      diffview_open = function()
        vim.cmd [[DiffviewOpen]]
      end,
      diffview_filehistory_repo = function()
        vim.cmd [[DiffviewFileHistory]]
      end,
      diffview_filehistory_curbuf = function()
        vim.cmd [[DiffviewFileHistory --follow %]]
      end,
      diffview_filehistory_line = function()
        vim.cmd [[.DiffviewFileHistory --follow]]
      end,
      diffview_windo_this = function()
        vim.cmd [[windo diffthis]]
      end,
      git_pr_openpr = function()
        vim.cmd [[GHOpenPR]]
      end,
      git_pr_openissue = function()
        vim.cmd [[GHOpenIssue]]
      end,
      git_worktree_create = function()
        vim.cmd [[lua require("telescope").extensions.git_worktree.create_git_worktrees()]]
      end,
      git_worktree_manage = function()
        vim.cmd [[lua require("telescope").extensions.git_worktree.git_worktrees()]]
      end,
      git_conflict_refresh = function()
        vim.cmd [[GitConflictRefresh]]
      end,
      git_conflict_collect_qf = function()
        vim.cmd [[GitConflictListQf]]
      end,
      git_conflict_pilih_current_ours = function()
        RUtils.info("Choosing ours (current)", { title = "GitConflict" })
        vim.cmd [[GitConflictChooseOurs]]
      end,
      git_conflict_pilih_theirs = function()
        RUtils.info("Choosing theirs (incoming)", { title = "GitConflict" })
        vim.cmd [[GitConflictChooseTheirs]]
      end,
      git_conflict_pilih_none = function()
        RUtils.info("Choosing none of them (deleted)", { title = "GitConflict" })
        vim.cmd [[GitConflictChooseNone]]
      end,
      git_blame = function()
        local gs = package.loaded.gitsigns
        gs.blame()
      end,
    }, {}),
    { winopts = { title = RUtils.config.icons.git.branch .. "Git ", row = row, col = col } }
  )
end, { desc = "Git: list commands of git" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ TMUX INTEGRATE                                          │
-- ╰─────────────────────────────────────────────────────────╯

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

local go_left = function()
  vim.fn.system [[tmux select-pane -L]]
end

local get_current_pane_id = function()
  return normalize_return(vim.fn.system [[tmux display-message -p "#{pane_id}"]])
end

local pane_left_current_cmd_nnn = function()
  return normalize_return(
    vim.fn.system [[tmux display-message -p "#{pane_id} #{pane_current_command}" | awk '$2 == "nnn" { print $2; exit }']]
  )
end

local pane_left_current_cmd_zsh = function()
  return normalize_return(
    vim.fn.system [[tmux display-message -p "#{pane_id} #{pane_current_command}" | awk '$2 == "zsh" { print $2; exit }']]
  )
end

local pane_left_current_cmd_tmux = function()
  return normalize_return(
    vim.fn.system [[tmux display-message -p "#{pane_id} #{pane_current_command}" | awk '$2 == "tmux" { print $2; exit }']]
  )
end

local pane_left_current_cmd_lf = function()
  return normalize_return(
    vim.fn.system [[tmux display-message -p "#{pane_id} #{pane_current_command}" | awk '$2 == "lf" { print $2; exit }']]
  )
end

local pane_left_current_cmd_yazi = function()
  return normalize_return(
    vim.fn.system [[tmux display-message -p "#{pane_id} #{pane_current_command}" | awk '$2 == "yazi" { print $2; exit }']]
  )
end

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
    -- local get_total_active_panes = normalize_return(vim.fn.system [[ tmux display-message -p '#{window_panes}']])
    local main_pane_id = get_current_pane_id()
    local cmd_open_filemanager =
      fmt("tmux split-window -hb -p 30 -l 30 -c '#{pane_current_path}' '%s %s'", fm_manager, dirname)

    go_left()

    if pane_left_current_cmd_nnn() == "nnn" then
      vim.fn.system "tmux kill-pane"
    end

    if pane_left_current_cmd_yazi() == "yazi" then
      vim.fn.system "tmux kill-pane"
    end

    if pane_left_current_cmd_lf() == "lf" then
      vim.fn.system "tmux kill-pane"
    end

    local cmd_backtopane = "tmux select-pane -t " .. main_pane_id

    if pane_left_current_cmd_tmux() == "tmux" then
      vim.fn.system(cmd_backtopane)
    end

    if pane_left_current_cmd_zsh() == "zsh" then
      vim.fn.system(cmd_backtopane)
    end

    vim.fn.system(cmd_open_filemanager)
  end
end)
