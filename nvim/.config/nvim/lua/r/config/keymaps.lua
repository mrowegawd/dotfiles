-- vim: foldmethod=marker foldlevel=0

local silent = { silent = true }
local nosilent = { silent = false }

local fn, cmd, fmt = vim.fn, vim.cmd, string.format

local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

-- {{{ Text editing
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

-- conflict with mapping tmux split vertial/horizontal
-- RUtils.map.inoremap("<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
-- RUtils.map.inoremap("<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

-- }}}
-- {{{ Folds
-- RUtils.map.nnoremap("<BS>", "zazz", { desc = "Fold: toggle focus current fold/unfold" })
RUtils.map.nnoremap("zm", "zM", { desc = "Fold: close all" })
RUtils.map.nnoremap("<c-m>", "zM", { desc = "Fold: close all" }) -- <c-m> --> <c-enter>

RUtils.map.nnoremap("<c-s>", "zO", { desc = "Fold: open all" })

-- RUtils.map.nnoremap("<Leader>zf", "zMzvzz", { desc = "Fold: close all folds except the current one" })
RUtils.map.nnoremap("<c-a>", "zMzv", { desc = "Fold: close all folds except the current one" })

RUtils.map.nnoremap("<c-x>", function()
  return RUtils.fold.cycle_fold_level()
end, { desc = "Fold: cycle level fold" })

RUtils.map.nnoremap("zr", function()
  return RUtils.fold.cycle_fold_level()
end, { desc = "Fold: cycle level fold" })

RUtils.map.nnoremap("zo", function()
  vim.cmd "normal! zozz"
end, { desc = "Fold: zo" })
RUtils.map.nnoremap("zO", function()
  vim.cmd "normal! zOzz"
end, { desc = "Fold: zO" })

RUtils.map.nnoremap("<c-n>", function()
  return RUtils.fold.magic_jump_qf_or_fold()
end, { desc = "Fold: magic jump next fold/qf" })
RUtils.map.nnoremap("<c-p>", function()
  return RUtils.fold.magic_jump_qf_or_fold(true)
end, { desc = "Fold: magic jump prev fold/qf" })
-- }}}
-- {{{ Terminal
-- RUtils.map.nnoremap("<a-CR>", RUtils.terminal.smart_split, { desc = "Terminal: open smart-split" })
RUtils.map.tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
RUtils.map.tnoremap("<a-x>", function()
  local buf = vim.api.nvim_get_current_buf()
  require("bufdelete").bufdelete(buf, true)
end, { desc = "Terminal: close terminal" })
-- RUtils.map.tnoremap("<a-t>", function()
--   RUtils.map.feedkey("<C-\\><C-n>", "t")
--   require("fzf-lua").tabs()
-- end, { desc = "Terminal: show tabs [fzflua]" })
RUtils.map.tnoremap("<c-a-l>", function()
  RUtils.map.feedkey("<C-\\><C-n><c-a-l>", "t")
end, { desc = "Terminal: next tab" })
RUtils.map.tnoremap("<c-a-h>", function()
  RUtils.map.feedkey("<C-\\><C-n><c-a-h>", "t")
end, { desc = "Terminal: prev tab" })
-- RUtils.map.tnoremap("<a-f>", function()
--   RUtils.map.feedkey("<C-\\><C-n><a-f>", "t")
--   -- RUtils.terminal.toggle_right_term()
-- end, { desc = "Terminal: new term split" })
RUtils.map.tnoremap("<a-N>", function()
  RUtils.map.feedkey("<C-\\><C-n><a-N>", "t")
end, { desc = "Terminal: new tabterm" })
RUtils.map.tnoremap("<a-CR>", function()
  RUtils.terminal.smart_split()
end, { desc = "Terminal: new term" })
-- }}}
-- {{{ Windows, view and nav

local exclude_ft_arrange = { "rgflow", "DiffviewFileHistory", "DiffviewFiles" }

local arange_wins = function(direction)
  return function()
    if vim.wo.diff then
      return
    end

    if vim.tbl_contains(exclude_ft_arrange, vim.bo.filetype) then
      return
    end

    if vim.w.is_overlook_popup then
      if direction == "split" then
        require("overlook.api").open_in_split()
      end

      if direction == "vsplit" then
        require("overlook.api").open_in_vsplit()
      end
      return
    end

    if vim.tbl_contains({ "split", "vsplit" }, direction) then
      vim.cmd(direction)
      return
    end

    vim.cmd("wincmd " .. direction)
    vim.cmd "wincmd ="
  end
end

RUtils.map.nnoremap("<Leader>ws", arange_wins "split", { desc = "Window: split" })
RUtils.map.nnoremap("<Leader>wv", arange_wins "vsplit", { desc = "Window: vsplit" })

RUtils.map.nnoremap("<Leader>wj", arange_wins "J", { desc = "Window: wincmd J" })
RUtils.map.vnoremap("<Leader>wj", arange_wins "J", { desc = "Window: wincmd J (visual)" })

RUtils.map.nnoremap("<Leader>wk", arange_wins "K", { desc = "Window: wincmd K" })
RUtils.map.vnoremap("<Leader>wk", arange_wins "K", { desc = "Window: wincmd K (visual)" })

RUtils.map.nnoremap("<Leader>wh", arange_wins "H", { desc = "Window: wincmd H" })
RUtils.map.vnoremap("<Leader>wh", arange_wins "H", { desc = "Window: wincmd H (visual)" })

RUtils.map.nnoremap("<Leader>wl", arange_wins "L", { desc = "Window: wincmd L" })
RUtils.map.vnoremap("<Leader>wl", arange_wins "L", { desc = "Window: wincmd L (visual)" })

RUtils.map.nnoremap("<Leader>wo", function()
  local right_win = { "trouble", "aerial", "Outline", "rgflow", "neo-tree", "snacks_notif_history" }

  if vim.tbl_contains(right_win, vim.bo.filetype) then
    vim.cmd [[wincmd p]]
    return
  end

  for _, win in pairs(right_win) do
    local win_checked = RUtils.cmd.windows_is_opened { win }
    if win_checked.found then
      vim.api.nvim_set_current_win(win_checked.winid)
      break
    end
  end
end, { desc = "Window: jump to or from spesific window" })

-- if not RUtils.has "smart-splits.nvim" and not (os.getenv "TERMINAL" == "kitty") then
--   RUtils.map.nnoremap("<a-K>", "<cmd>resize +4<cr>", { desc = "View: incease window height" })
--   RUtils.map.nnoremap("<a-J>", "<cmd>resize -4<cr>", { desc = "View: increase window height" })
--   RUtils.map.nnoremap("<a-H>", "<cmd>vertical resize -4<cr>", { desc = "View: decrease window width" })
--   RUtils.map.nnoremap("<a-L>", "<cmd>vertical resize +4<cr>", { desc = "View: increase window width" })
-- end

-- Tab
RUtils.map.nnoremap("tn", function()
  if vim.bo.filetype == "neo-tree" then
    return
  end
  vim.cmd "tabedit %"
end, { desc = "Tab: new tab", silent = true })
RUtils.map.nnoremap("tc", "<CMD>tabclose<CR>", { desc = "Tab: close tab", silent = true })
RUtils.map.nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Tab: first tab", silent = true })
RUtils.map.nnoremap("tL", "<CMD>tablast<CR>", { desc = "Tab: last tab", silent = true })
RUtils.map.nnoremap("tl", "<CMD>tabnext<CR>", { desc = "Tab: next tab", silent = true })
RUtils.map.nnoremap("th", "<CMD>tabprevious<CR>", { desc = "Tab: prev tab", silent = true })

-- Only works outside tmux
RUtils.map.nnoremap("<C-a-l>", "<CMD>tabnext<CR>", { desc = "Tab: next tab (mod)", silent = true })
RUtils.map.nnoremap("<C-a-h>", "<CMD>tabprevious<CR>", { desc = "Tab: prev tab (mod)", silent = true })

-- }}}
-- {{{ Window scroll
RUtils.map.nnoremap(
  "zz",
  [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
  { expr = true, desc = "View: center cursor window" }
)

-- Scroll step sideways
-- RUtils.map.nnoremap("zl", "z4l")
-- RUtils.map.nnoremap("zh", "z4h") -- zh use for fold
RUtils.map.nnoremap("zL", "z20l")
RUtils.map.nnoremap("zH", "z20h")

-- Scroll Up/Down
RUtils.map.nnoremap("<C-b>", [[max([winheight(0) - 2, 1]) ."<C-u>".(line('w0') <= 1 ? "H" : "M")]], { expr = true })
RUtils.map.nnoremap(
  "<C-f>",
  [[max([winheight(0) - 2, 1]) ."<C-d>".(line('w$') >= line('$') ? "L" : "M")]],
  { expr = true }
)
RUtils.map.nnoremap("<C-e>", [[(line("w$") >= line('$') ? "2j" : "4<C-e>")]], { expr = true })
RUtils.map.nnoremap("<C-y>", [[(line("w0") <= 1 ? "2k" : "4<C-y>")]], { expr = true })
-- }}}
-- {{{ Buffers
RUtils.map.nnoremap("<Leader>bT", "<C-w><S-t>", { desc = "Buffer: change buffer into tab window" })
RUtils.map.nnoremap("<Leader>bb", "<C-^>", { desc = "Buffer: alternate file" })
RUtils.map.nnoremap("<Leader>bw", "<CMD>wincmd =<CR>", { desc = "Buffer: reset window buffer size", silent = true })
RUtils.map.nnoremap("<Leader>bc", "<CMD>q!<CR>", { desc = "Buffer: close buffer" })
RUtils.map.nnoremap("<a-x>", "<CMD>q!<CR>", { desc = "Buffer: close buffer (force)" })
RUtils.map.nnoremap("<Leader>bd", RUtils.buf.bufremove, { desc = "Buffer: delete buffer" })
RUtils.map.nnoremap("<Leader>bO", function()
  Snacks.bufdelete.other()
  ---@diagnostic disable-next-line: undefined-field
  RUtils.info(RUtils.config.icons.misc.checklist .. " Purge buffers", { title = "Buffers" })
end, { desc = "Buffer: delete all other buffers" })
RUtils.map.nnoremap("gh", function()
  return RUtils.fold.magic_nextprev_list_qf_or_buf(true)
end, { desc = "Buffer: magic gh (qf)" })
RUtils.map.nnoremap("gl", function()
  return RUtils.fold.magic_nextprev_list_qf_or_buf()
end, { desc = "Buffer: magic gl (qf)" })
RUtils.map.nnoremap("<Leader><TAB>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit" })
RUtils.map.nnoremap("<c-q>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit" })
RUtils.map.nnoremap("<Leader>R", function()
  vim.cmd [[wall!]]
  vim.cmd [[restart]]
end, { desc = "Buffer: restart nvim" })
RUtils.map.vnoremap("<Leader><TAB>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit (visual)" })
RUtils.map.nnoremap("<Leader>bk", RUtils.map.show_help_buf_keymap, {
  desc = "Buffer: show keymaps curbuf",
  silent = true,
})
-- }}}
-- {{{ Commandline
RUtils.map.cnoremap("hh", "<C-c>", { desc = "Commandline: exit" })
RUtils.map.cnoremap("<C-a>", "<Home>", { desc = "Commandline: go to first line" })
RUtils.map.cnoremap("<C-e>", "<End>", { desc = "Commandline: go to the last line" })
-- These mapping C-n/p have been disabled because conflict with mapping blink cmdline
-- RUtils.map.cnoremap("<C-n>", "<Down>", { desc = "Commandline: next hist" })
-- RUtils.map.cnoremap("<C-p>", "<Up>", { desc = "Commandline: prev hist" })
RUtils.map.cnoremap("<C-l>", "<Right>", { desc = "Commandline: next word" })
RUtils.map.cnoremap("<C-h>", "<Left>", { desc = "Commandline: prev word" })
RUtils.map.cnoremap("<C-f>", "<S-Right>", { desc = "Commandline: forward word" })
RUtils.map.cnoremap("<C-b>", "<S-Left>", { desc = "Commandline: backward word" })
-- }}}
-- {{{ Cabbrev
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
RUtils.map.nmap("K", "<Nop>")
RUtils.map.nmap("q", "<Nop>")
-- }}}
-- {{{ Diff
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
  "<Leader>gy",
  "<esc><cmd>CompareClipboardSelection<cr>",
  { desc = "Git: compare diff with selection clipboard (visual)" }
)
if vim.fn.executable "lazygit" == 1 then
  RUtils.map.nnoremap("<Leader>gg", function()
    ---@diagnostic disable-next-line: missing-fields
    Snacks.lazygit { cwd = RUtils.root.git() }
  end, { desc = "Git: lazygit (root dir) [snacks]" })
  RUtils.map.nnoremap("<Leader>gG", function()
    Snacks.lazygit()
  end, { desc = "Git: lazygit (cwd) [snacks]" })
  -- RUtils.map.nnoremap("<Leader>glc", function()
  --   Snacks.lazygit.log_file()
  -- end, { desc = "Git: lazygit current file history" })
  -- RUtils.map.nnoremap("<Leader>glC", function()
  --   Snacks.lazygit.log { cwd = RUtils.root.git() }
  -- end, { desc = "Git: lazygit log" })
  -- RUtils.map.nnoremap("<Leader>glg", function()
  --   Snacks.lazygit.log()
  -- end, { desc = "Git: lazygit log (cwd)" })
end
-- }}}
-- {{{ Misc
RUtils.map.nnoremap("<C-o>", "<C-o>zvzz", { desc = "Misc: jump back <c-o> and center" })
RUtils.map.nnoremap("<C-i>", "<C-i>zvzz", { desc = "Misc: jump forward <c-i> and center" })
RUtils.map.nnoremap("<Esc>", function()
  vim.cmd "noh"
  RUtils.cmp.actions.snippet_stop()
  return "<Esc>"
end, { desc = "Misc: escape and clear hlsearch", expr = true, silent = true })
RUtils.map.nnoremap("*", function()
  -- Don't jump to first match with *
  local word = vim.fn.expand "<cword>"
  vim.fn.setreg("/", "\\v" .. word)
  vim.o.hlsearch = true
end, { remap = true, desc = "Misc: search word under cursor (no jump)" })
RUtils.map.inoremap("<Esc>", function()
  vim.cmd "noh"
  RUtils.cmp.actions.snippet_stop()
  return "<Esc>"
end, { desc = "Misc: escape and clear hlsearch", expr = true, silent = true })
RUtils.map.nnoremap("dd", function()
  if vim.fn.getline "." == "" then
    return '"_dd'
  end
  return "dd"
end, { expr = true })
RUtils.map.xnoremap("<C-g>", "<Esc>/\\%V") --search within visual selection - this is magic
RUtils.map.nnoremap("<C-g>", "/", nosilent)
RUtils.map.nnoremap("~", "%", { desc = "Misc: go to.. matching tag" })
RUtils.map.nnoremap("g,", "g,zvzz", silent) -- go last edit
RUtils.map.nnoremap("g;", "g;zvzz", silent) -- go prev edit
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
RUtils.map.nnoremap(
  "<Leader>n",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Misc: redraw / clear hlsearch / diff update" }
)
RUtils.map.vnoremap(">", ">gv", { desc = "Misc: next align lines (visual)" })
RUtils.map.vnoremap("<", "<gv", { desc = "Misc: prev align lines (visual)" })
RUtils.map.nnoremap("vv", [[^vg_]], { desc = "Misc: select text lines" })
RUtils.map.nnoremap("<Leader>P", function()
  local cwd = vim.fn.expand "%:p:h"
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  ---@diagnostic disable-next-line: undefined-field
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
RUtils.map.nnoremap("<Leader>sr", replace_keymap, { desc = "Misc: Search and replace under cursor" })
RUtils.map.vnoremap("<Leader>sr", [["zy:%s/<C-r><C-o>"/]], { desc = "Misc: Search and replace under cursor (visual)" })
RUtils.map.nnoremap("<Leader>ol", "<Cmd>Lazy log<CR>", { desc = "Open: open lazy log [lazy]" })

RUtils.map.nnoremap("<Leader>ob", function()
  RUtils.cmd.open_with "browser"
end, { desc = "Open: browse/link under cursor" })
RUtils.map.vnoremap("<Leader>ob", function()
  RUtils.cmd.open_with("browser", true)
end, { desc = "Open: browse/link under cursor (visual)" })

RUtils.map.nnoremap("<Leader>oB", function()
  return RUtils.cmd.open_with "mpv or svix"
end, { desc = "Open: mpv or svix" })
RUtils.map.vnoremap("<Leader>oB", function()
  return RUtils.cmd.open_with("mpv or svix", true)
end, { desc = "Open: mpv or svix (visual" })

RUtils.map.nnoremap("<Leader>oo", function()
  RUtils.cmd.open_with "go to file"
end, { desc = "Open: open file under cursor" })
RUtils.map.vnoremap("<Leader>oo", function()
  RUtils.cmd.open_with("go to file", true)
end, { desc = "Open: open file under cursor (visual)" })

RUtils.map.vnoremap("<Leader>rb", function()
  RUtils.cmd.browse_this_error(true)
end, { desc = "Open: Search for error messages in the browser (visual)" })
RUtils.map.nnoremap("<Leader>rb", function()
  RUtils.cmd.browse_this_error(true)
end, { desc = "Open: Search for error messages in the browser" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
RUtils.map.nnoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
RUtils.map.xnoremap("n", "'Nn'[v:searchforward]", { expr = true, desc = "Misc: next search result" })
RUtils.map.onoremap("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Misc: next search result" })
RUtils.map.nnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
RUtils.map.xnoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })
RUtils.map.onoremap("N", "'nN'[v:searchforward]", { expr = true, desc = "Misc: prev search result" })

-- Allow moving the cursor through wrapped lines using j and k,
-- note that I have line wrapping turned off but turned on only for Markdown
RUtils.map.nnoremap("k", function()
  local count = vim.v.count
  local mode = vim.api.nvim_get_mode().mode
  local use_gk = count == 0 and not mode:match "no"

  local move = use_gk and "gk" or "k"
  -- Jadi setiap kamu jump memakai `10j` atau `6j`, akan di automatis mark
  local mark = tonumber(count) > 5 and "m'" .. count or ""

  return mark .. move
end, { expr = true })

RUtils.map.nnoremap("j", function()
  local count = vim.v.count
  local mode = vim.api.nvim_get_mode().mode
  local use_gj = count == 0 and not mode:match "no"

  local move = use_gj and "gj" or "j"
  local mark = tonumber(count) > 5 and "m'" .. count or ""

  return mark .. move
end, { expr = true })

RUtils.map.nnoremap("<F1>", function()
  local get_current_pane_tmux_id = function()
    local get_pane_id = vim.system({ "tmux", "display-message", "-p", "#{pane_id}" }, { text = true }):wait()
    if get_pane_id.code ~= 0 then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.error("Failed to get tmux pane_id", { title = "Config Keymaps" })
      return
    end
    return get_pane_id.stdout
  end

  local get_current_pane_tmux_idx = function(id)
    -- local cmds = { "tmux", "display-message", "-p", "-t", id, "'#{pane_index}'" }
    local cmds = ("tmux display-message -p -t " .. id .. " '#{pane_index}'"):gsub("\n", "")

    ---@diagnostic disable-next-line: undefined-field
    RUtils.info("cmds : " .. table.concat { "sh", "-c", cmds })

    local get_pane_idx = vim.system({ "sh", "-c", cmds }, { text = true }):wait()
    if get_pane_idx.code ~= 0 then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.error("Failed to get tmux idx", { title = "Config Keymaps" })
      return
    end
    return get_pane_idx.stdout
  end

  local pane_id = get_current_pane_tmux_id()

  if pane_id then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.info("the pane id is: " .. pane_id)

    ---@diagnostic disable-next-line: undefined-field
    RUtils.info("The idx is: " .. get_current_pane_tmux_idx(pane_id))
  end
end)

-- Visual
-- RUtils.map.xnoremap("il", "<Esc>^vg_", { desc = "View: dont mistake (x)" })
-- RUtils.map.onoremap("il", "<CMD><C-U>normal! ^vg_<CR>", { desc = "View: dont mistake (o)" })
-- RUtils.map.xnoremap("al", "$o0", { desc = "View: jump in (x)" })
-- RUtils.map.onoremap("al", "<CMD><C-u>normal val<CR>", { desc = "View: jump out (o)" })
-- }}}
-- {{{ Toggle
Snacks.toggle.option("wrap", { name = "Wrap" }):map "<Leader>uw"
-- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Toggle: dark background" }):map "<Leader>ub"
-- Snacks.toggle.option("spell", { name = "Spelling" }):map "<Leader>us"
-- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<Leader>uL"
-- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }) :map "<Leader>uc"
-- Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }) :map "<Leader>uA"
Snacks.toggle.zoom():map "<Leader>wm"
Snacks.toggle.zen():map "<Leader>uz"
Snacks.toggle.diagnostics():map "<Leader>ud"
Snacks.toggle.treesitter():map "<Leader>uT"
-- Snacks.toggle.scroll():map "<Leader>uS"
-- Snacks.toggle.animate():map "<Leader>ua"
-- Snacks.toggle.line_number():map "<leader>ul"
-- Snacks.toggle.profiler():map "<Localleader>spp"
-- Snacks.toggle.profiler_highlights():map "<Localleader>sph"

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map "<Leader>uh"
end

-- RUtils.map.nnoremap("<space><F9>", function()
--   Snacks.notify.error("This is error", {})
--   Snacks.notify.warn("This is warn", {})
--   Snacks.notify.info("This is info", {})
-- end, {
--   desc = "Misc: check color Snacks Notify",
--   silent = true,
-- }}}
-- {{{ Commands
RUtils.map.nnoremap("<Leader>oI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input "I"
end, { desc = "Open: inspect tree" })
RUtils.cmd.create_command("Snippets", RUtils.cmd.edit_snippet, { desc = "Misc: edit snippet file" })
RUtils.cmd.create_command("ChangeMasterTheme", RUtils.cmd.change_colors, { desc = "Misc: set theme bspwm" })
RUtils.cmd.create_command("InfoOption", RUtils.cmd.infoFoldPreview, { desc = "Misc: echo options" })
RUtils.cmd.create_command("ImgInsert", RUtils.maim.insert, { desc = "Misc: echo options" })
RUtils.cmd.create_command("E", function()
  return cmd [[ vnew ]]
end, { desc = "Misc: vnew" })

vim.api.nvim_create_user_command("Cfilter", function(opts)
  vim.cmd.packadd "cfilter"
  vim.cmd.Cfilter { args = opts.fargs, bang = opts.bang }
end, { force = true, bang = true, nargs = "*" })
-- }}}
-- {{{ Bulk commands
-- These commands run outside tmux
local ctrl_o_nvim = function()
  local win_height = math.ceil(RUtils.cmd.get_option "lines" * 0.5)
  local win_width = math.ceil(RUtils.cmd.get_option "columns" * 1)

  local col = math.ceil((win_width / 2) - 40)
  local row = math.ceil((RUtils.cmd.get_option "lines" - win_height) - 10)

  RUtils.fzflua.open_cmd_bulk({
    ["Clock mode"] = function()
      RUtils.terminal.clock_mode()
    end,
    ["Newsboat"] = function()
      RUtils.terminal.float_newsboat()
    end,
    ["Calendar"] = function()
      RUtils.terminal.float_calcure()
    end,
    ["Btop"] = function()
      RUtils.terminal.float_btop()
    end,
    ["Rust upserv"] = function()
      print "sf"
    end,
    ["Rust upserv2"] = function()
      print "sf"
    end,
    ["Rust benc"] = function()
      print "sf"
    end,
    ["Grav term"] = function()
      print "sf"
    end,
    ["Log meta"] = function()
      print "sf"
    end,
    ["R-kill"] = function()
      RUtils.terminal.float_rkill()
    end,
  }, { winopts = { title = "Bulk: ctrl-o cmds", row = row, col = col } })
end

RUtils.map.nnoremap("<a-o>", ctrl_o_nvim, { desc = "Bulk: ctrl_o cmds" })
RUtils.map.tnoremap("<a-o>", ctrl_o_nvim, { desc = "Bulk: ctrl_o cmds" })
RUtils.map.vnoremap("<a-o>", ctrl_o_nvim, { desc = "Bulk: ctrl_o cmds (visual)" })

local bulk_cmd_misc = function()
  RUtils.fzflua.open_cmd_bulk({
    ["Qf - Load qf/lf list"] = function()
      cmd "LoadQf"
    end,
    ["Qf - Save qf/lf list"] = function()
      cmd "SaveQf"
    end,
    ["Browser - Open tailwindcss.com"] = function()
      cmd "!open https://tailwindcss.com"
    end,
    ["Kulala - Run"] = function()
      require("kulala").run()
    end,
    ["Browser - Open devdocs (with input)"] = function()
      local query = vim.fn.input "Search DevDocs: "
      if #query > 0 then
        local encodedURL = string.format('open "https://devdocs.io/#q=%s"', query:gsub("%s", "%%20"))
        os.execute(encodedURL)
      end
    end,
  }, { winopts = { title = "Bulk Misc" } })
end

RUtils.map.nnoremap("<Leader>of", bulk_cmd_misc, { desc = "Bulk: misc cmds" })
RUtils.map.tnoremap("<Leader>of", bulk_cmd_misc, { desc = "Bulk: misc cmds" })
RUtils.map.vnoremap("<Leader>of", bulk_cmd_misc, { desc = "Bulk: misc cmds (visual)" })

local bulk_cmd_git = function()
  RUtils.fzflua.open_cmd_bulk({
    ["Diffview - DiffviewOpen"] = function()
      vim.cmd [[DiffviewOpen]]
    end,
    ["Diffview - DiffviewFileHistory Repo"] = function()
      vim.cmd [[DiffviewFileHistory]]
    end,
    ["Diffview - DiffviewFileHistory Curbuf"] = function()
      vim.cmd [[DiffviewFileHistory --follow %]]
    end,
    ["Diffview - DiffviewFileHistory Line"] = function()
      vim.cmd [[.DiffviewFileHistory --follow]]
    end,
    ["Diff - Windo this"] = function()
      vim.cmd [[windo diffthis]]
    end,
    ["GH - Open PR"] = function()
      vim.cmd [[GHOpenPR]]
    end,
    ["GH - Open Issue"] = function()
      vim.cmd [[GHOpenIssue]]
    end,
    ["GitWorktree - Create"] = function()
      vim.cmd [[lua require("telescope").extensions.git_worktree.create_git_worktrees()]]
    end,
    ["GitWorktree - Manage"] = function()
      vim.cmd [[lua require("telescope").extensions.git_worktree.git_worktrees()]]
    end,
    ["GitConflict - Refresh"] = function()
      vim.cmd [[GitConflictRefresh]]
    end,
    ["GitConflict - Send list to qf"] = function()
      vim.cmd [[GitConflictListQf]]
    end,
    ["GitConflict - Choosing ours (current)"] = function()
      ---@diagnostic disable-next-line: undefined-field
      RUtils.info("Choosing ours (current)", { title = "GitConflict" })
      vim.cmd [[GitConflictChooseOurs]]
    end,
    ["GitConflict - Choosing theirs (incoming)"] = function()
      ---@diagnostic disable-next-line: undefined-field
      RUtils.info("Choosing theirs (incoming)", { title = "GitConflict" })
      vim.cmd [[GitConflictChooseTheirs]]
    end,
    ["GitConflict - Choosing none of them (deleted)"] = function()
      ---@diagnostic disable-next-line: undefined-field
      RUtils.info("Choosing none of them (deleted)", { title = "GitConflict" })
      vim.cmd [[GitConflictChooseNone]]
    end,
    ["GitSigns - Show blame"] = function()
      local gs = package.loaded.gitsigns
      gs.blame()
    end,
    ["GitSigns - Toggle diff changes"] = function()
      local gs = package.loaded.gitsigns
      gs.toggle_deleted()
    end,
    ["GitSigns - Toggle word diff"] = function()
      local gs = package.loaded.gitsigns
      gs.toggle_word_diff()
    end,
  }, { winopts = { title = RUtils.config.icons.git.branch .. "Git " } })
end

RUtils.map.nnoremap("<Leader>gof", bulk_cmd_git, { desc = "Bulk: git cmds" })
RUtils.map.tnoremap("<Leader>gof", bulk_cmd_git, { desc = "Bulk: git cmds" })
RUtils.map.vnoremap("<Leader>gof", bulk_cmd_git, { desc = "Bulk: git cmds (visual)" })

-- }}}
-- {{{ Tmux integration
local fm_manager = vim.env.TERM_FILEMANAGER

RUtils.map.nnoremap("<a-B>", function()
  RUtils.terminal.float_btop()
end, { desc = "CTRL_o: btop" })
RUtils.map.vnoremap("<a-B>", function()
  RUtils.terminal.float_btop()
end, { desc = "CTRL_o: btop" })

RUtils.map.nnoremap("<a-M>", function()
  RUtils.terminal.float_newsboat()
end, { desc = "CTRL_o: newsboat" })
RUtils.map.vnoremap("<a-M>", function()
  RUtils.terminal.float_newsboat()
end, { desc = "CTRL_o: newsboat" })

RUtils.map.nnoremap("<a-C>", function()
  RUtils.terminal.float_rkill()
end, { desc = "CTRL_o: rkill" })
RUtils.map.vnoremap("<a-C>", function()
  RUtils.terminal.float_rkill()
end, { desc = "CTRL_o: rkill" })

local go_left_tmux = function()
  vim.system { "tmux", "select-pane", "-L" }
end
local get_current_pane_tmux_id = function()
  local get_pane_id = vim.system({ "tmux", "display-message", "-p", "#{pane_id}" }, { text = true }):wait()
  if get_pane_id.code ~= 0 then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.error("Failed to get tmux pane_id", { title = "Config Keymaps" })
    return
  end
  return get_pane_id.stdout
end
local get_current_pane_tmux_cmd = function(run_cmd)
  vim.validate { run_cmd = { run_cmd, "string" } }
  local get_cmd = vim
    .system({
      "sh",
      "-c",
      [[tmux display-message -p "#{pane_id} #{pane_current_command}" | awk '$2 == "]]
        .. run_cmd
        .. [[" { print $2; exit }']],
    }, { text = true })
    :wait()

  if get_cmd.code ~= 0 or #get_cmd.stdout == 0 then
    return false
  end

  return true
end

local get_right_pane_id_wez = function()
  local get_pane_right_id = vim.system({ "wezterm", "cli", "get-pane-direction", "right" }, { text = true }):wait()
  if get_pane_right_id.code ~= 0 then
    return nil
  end
  return get_pane_right_id.stdout
end

RUtils.map.nnoremap("<a-E>", function()
  local dirname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":h:p")

  local tmux = os.getenv "TMUX"
  local terminal = os.getenv "TERMINAL"
  local pane_size = 35 -- 45 for normal window, tapi jika kecil 30 saja

  if not tmux then
    if terminal ~= "wezterm" then
      if RUtils.has "neo-tree.nvim" then
        vim.cmd "Neotree focus reveal right"
        return
      end
    end

    local pane_right_id = get_right_pane_id_wez()
    if pane_right_id then
      ---@diagnostic disable-next-line: assign-type-mismatch
      vim.system { "wezterm", "cli", "kill-pane", "--pane-id", tonumber(pane_right_id) }
    end

    vim.system { "wezterm", "cli", "split-pane", "--right", "--percent", "22" }
    ---@diagnostic disable-next-line: assign-type-mismatch
    vim.system { "sleep", 0.5 }
    vim.system { "wezterm", "cli", "activate-pane-direction", "left" }

    pane_right_id = get_right_pane_id_wez()

    if pane_right_id then
      local cmd_open_filemanager_wez = {
        "wezterm",
        "cli",
        "send-text",
        "--pane-id",
        tonumber(pane_right_id),
        "--no-paste",
        "" .. fm_manager .. " " .. dirname .. "\r",
      }
      vim.system(cmd_open_filemanager_wez)
      vim.system { "wezterm", "cli", "activate-pane-direction", "right" }
    end
  else
    local main_pane_id = get_current_pane_tmux_id()

    go_left_tmux()

    -- Kill all file manager panes
    if get_current_pane_tmux_cmd "nnn" or get_current_pane_tmux_cmd "yazi" or get_current_pane_tmux_cmd "lf" then
      vim.system { "tmux", "kill-pane" }
    end

    if get_current_pane_tmux_cmd "tmux" or get_current_pane_tmux_cmd "zsh" then
      vim.system { "tmux", "select-pane", "-t", main_pane_id }
    end

    local cmd_open_filemanager = {
      "tmux",
      "split-window",
      "-h",
      "-p",
      "30",
      "-l",
      pane_size,
      "-c",
      "'#{pane_current_path}'",
      fm_manager,
      dirname,
    }
    vim.system(cmd_open_filemanager)
  end
end)
-- }}}
