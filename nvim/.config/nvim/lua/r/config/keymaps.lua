-- vim: foldmethod=marker foldlevel=0
local silent = { silent = true }
local nosilent = { silent = false }

local fn, cmd, fmt = vim.fn, vim.cmd, string.format
local fm_manager = vim.env.TERM_FILEMANAGER

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

RUtils.map.inoremap("<a-l>", "<Right>", silent)
RUtils.map.inoremap("<a-h>", "<Left>", silent)
RUtils.map.inoremap("<a-j>", "<Down>", silent)
RUtils.map.inoremap("<a-k>", "<Up>", silent)

RUtils.map.vnoremap("<S-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", silent)
RUtils.map.vnoremap("<S-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", silent)

RUtils.map.inoremap("<C-b>", "<Esc>bi", silent)
RUtils.map.inoremap("<C-f>", "<Esc>ea", silent)

RUtils.map.inoremap("hh", function()
  vim.cmd "noh"
  RUtils.cmp.actions.snippet_stop()
  return "<Esc>"
end, { desc = "Misc: escape and clear hlsearch", expr = true, silent = true })
-- }}}
-- {{{ Folds
RUtils.map.nnoremap("<C-a>", function()
  local is_line_folded = RUtils.cmd.force_foldopen(true)

  if is_line_folded then
    RUtils.map.wrap_fold_cmd "normal! zMzv" -- "normal! zMzO"

    local row = vim.fn.winline()
    local height = vim.api.nvim_win_get_height(0)

    if row > height * 0.7 then
      vim.cmd "normal! zb"
    else
      vim.cmd "normal! zt"
    end
  else
    RUtils.map.wrap_fold_cmd "normal! zc"
  end
end, { desc = "Fold: focus current" })
RUtils.map.nnoremap("zf", function()
  RUtils.map.wrap_fold_cmd "normal! zMzv"
end, { desc = "Fold: focus current (alternativ)" })
RUtils.map.nnoremap("zb", function()
  RUtils.fold.cycle_fold_level()
end, { desc = "Fold: cycle fold level (util)" })

-- Navigate magic fold
RUtils.map.nnoremap("<a-n>", function()
  RUtils.map.magic_jump()
end, { desc = "View: magic jump" })
RUtils.map.nnoremap("<a-p>", function()
  RUtils.map.magic_jump(true)
end, { desc = "View: magic jump" })
-- }}}
-- {{{ Terminal
RUtils.map.tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
RUtils.map.tnoremap("<a-x>", function()
  local buf = vim.api.nvim_get_current_buf()
  require("bufdelete").bufdelete(buf, true)
end, { desc = "Terminal: close", silent = true })
RUtils.map.tnoremap("<C-a-l>", function()
  RUtils.map.feedkey("<C-\\><C-n><C-a-l>", "t")
end, { desc = "Terminal: next tab" })
RUtils.map.tnoremap("<C-a-h>", function()
  RUtils.map.feedkey("<C-\\><C-n><C-a-h>", "t")
end, { desc = "Terminal: prev tab" })
RUtils.map.tnoremap("<A-N>", function()
  RUtils.map.feedkey("<C-\\><C-n><A-N>", "t")
end, { desc = "Terminal: new tab", silent = true })

-- Navigation from terminal
RUtils.map.tnoremap("<a-h>", function()
  RUtils.map.feedkey("<C-\\><C-n><C-w>h", "t")
end, { desc = "Terminal: move left" })
RUtils.map.tnoremap("<a-j>", function()
  RUtils.map.feedkey("<C-\\><C-n>:wincmd j<CR>", "t")
end, { desc = "Terminal: move down" })
RUtils.map.tnoremap("<a-k>", function()
  RUtils.map.feedkey("<C-\\><C-n><C-w>k", "t")
end, { desc = "Terminal: move up" })
RUtils.map.tnoremap("<a-l>", function()
  RUtils.map.feedkey("<C-\\><C-n>:wincmd l<CR>", "t")
end, { desc = "Terminal: move right" })

-- }}}
-- {{{ Windows, view and nav

local exclude_ft_arrange = { "DiffviewFileHistory", "DiffviewFiles" }

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
      if direction == "tabe" then
        require("overlook.api").open_in_tab()
      end
      return
    end

    if vim.tbl_contains({ "split", "vsplit" }, direction) then
      vim.cmd(direction)
      return
    end

    if direction == "tabe" then
      vim.cmd "tabedit %"
      return
    end

    vim.cmd("wincmd " .. direction)
    vim.cmd "wincmd ="
  end
end

RUtils.map.nnoremap("<Leader>ws", arange_wins "split", { desc = "Window: split" })
RUtils.map.nnoremap("<c-w>s", arange_wins "split", { desc = "Window: split" })
RUtils.map.nnoremap("<c-w>j", arange_wins "split", { desc = "Window: split (alternative)" })

RUtils.map.nnoremap("<Leader>wv", arange_wins "vsplit", { desc = "Window: vsplit" })
RUtils.map.nnoremap("<c-w>v", arange_wins "vsplit", { desc = "Window: vsplit (alternative)" })
RUtils.map.nnoremap("<c-w>l", arange_wins "vsplit", { desc = "Window: vsplit (alternative)" })
RUtils.map.nnoremap("<c-w>t", arange_wins "tabe", { desc = "Window: move buffer to the new tab", silent = true })

RUtils.map.nnoremap("<Leader>wJ", arange_wins "J", { desc = "Window: move down" })
RUtils.map.xnoremap("<Leader>wJ", arange_wins "J", { desc = "Window: move down (visual)" })

RUtils.map.nnoremap("<Leader>wK", arange_wins "K", { desc = "Window: move up" })
RUtils.map.xnoremap("<Leader>wK", arange_wins "K", { desc = "Window: move up (visual)" })

RUtils.map.nnoremap("<Leader>wH", arange_wins "H", { desc = "Window: move left" })
RUtils.map.xnoremap("<Leader>wH", arange_wins "H", { desc = "Window: move left (visual)" })

RUtils.map.nnoremap("<Leader>wL", arange_wins "L", { desc = "Window: move right" })
RUtils.map.xnoremap("<Leader>wL", arange_wins "L", { desc = "Window: move right (visual)" })

---@param tbl_wins table
---@return boolean
local function go_back_to_window(tbl_wins)
  for _, win in pairs(tbl_wins) do
    local win_checked = RUtils.cmd.windows_is_opened { win }
    if win_checked.found then
      -- pcall(vim.api.nvim_set_current_win, win_checked.winid)
      vim.api.nvim_set_current_win(win_checked.winid)
      return true
    end
  end
  return false
end

---@param ft_wins table
---@return boolean
local function go_prev_window(ft_wins)
  -- Go back to the window if any windows are open
  if vim.tbl_contains(ft_wins, vim.bo.filetype) then
    vim.cmd [[wincmd p]]
    return true
  end
  return false
end

local function switch_focus_targeted_window()
  local function call_stack_peek()
    local Stack = require "overlook.stack"
    local switch_to_winid = nil
    if vim.w.is_overlook_popup then
      switch_to_winid = vim.w.overlook_popup.root_winid
    elseif Stack.instances[vim.api.nvim_get_current_win()] and not Stack.empty() then
      switch_to_winid = Stack.top().winid
    end

    if switch_to_winid == nil then
      return false, nil
    end
    return true, switch_to_winid
  end
  local ok, switch_winid = call_stack_peek()
  if ok then
    pcall(vim.api.nvim_set_current_win, switch_winid)
    return
  end

  local float_win = { "codecompanion", "wayfinder" }
  if go_prev_window(float_win) then
    return
  end
  if go_back_to_window(float_win) then
    return
  end

  local right_win = { "trouble", "aerial", "Outline", "neo-tree", "snacks_notif_history", "ErgoTerm" }
  if go_prev_window(right_win) then
    return
  end
  if go_back_to_window(right_win) then
    return
  end
end

RUtils.map.nnoremap("<Leader>wo", switch_focus_targeted_window, { desc = "Window: switch focus" })
RUtils.map.nnoremap("<Leader>ow", switch_focus_targeted_window, { desc = "Window: switch focus (alternative)" })

if not RUtils.has "smart-splits.nvim" then
  -- Resize
  RUtils.map.nnoremap("<a-K>", "<cmd>resize +4<cr>", { desc = "View: taller" })
  RUtils.map.nnoremap("<a-J>", "<cmd>resize -4<cr>", { desc = "View: shorter" })
  RUtils.map.nnoremap("<a-H>", "<cmd>vertical resize -4<cr>", { desc = "View: narrower" })
  RUtils.map.nnoremap("<a-L>", "<cmd>vertical resize +4<cr>", { desc = "View: wider" })

  -- Navigate
  RUtils.map.nnoremap("<C-h>", "<C-w>h", { desc = "Window: left" })
  RUtils.map.nnoremap("<C-j>", "<C-w>j", { desc = "Window: down" })
  RUtils.map.nnoremap("<C-k>", "<C-w>k", { desc = "Window: up" })
  RUtils.map.nnoremap("<C-l>", "<C-w>l", { desc = "Window: right" })
end

-- Tab
RUtils.map.nnoremap("tn", function()
  if vim.bo.filetype == "neo-tree" then
    return
  end
  vim.cmd "tabedit %"
end, { desc = "Tab: new tab", silent = true })
RUtils.map.nnoremap("tc", "<CMD>tabclose<CR>", { desc = "Tab: close", silent = true })
RUtils.map.nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Tab: first", silent = true })
RUtils.map.nnoremap("tL", "<CMD>tablast<CR>", { desc = "Tab: last", silent = true })
RUtils.map.nnoremap("tl", "<CMD>tabnext<CR>", { desc = "Tab: next", silent = true })
RUtils.map.nnoremap("th", "<CMD>tabprevious<CR>", { desc = "Tab: prev", silent = true })

-- Only works outside tmux
RUtils.map.nnoremap("<C-a-l>", "<CMD>tabnext<CR>", { desc = "Tab: next (mod)", silent = true })
RUtils.map.nnoremap("<C-a-h>", "<CMD>tabprevious<CR>", { desc = "Tab: prev (mod)", silent = true })

-- }}}
-- {{{ Window scroll
RUtils.map.nnoremap(
  "zz",
  [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
  { expr = true, desc = "View: center cursor window" }
)

-- Scroll step sideways
RUtils.map.nnoremap("zl", "z20l")
RUtils.map.nnoremap("zh", "z20h") -- zh use for fold
RUtils.map.nnoremap("zL", "z50l")
RUtils.map.nnoremap("zH", "z50h")

-- Scroll Up/Down
RUtils.map.nnoremap(
  "<C-b>",
  [[max([winheight(0) - 2, 1]) ."<C-u>".(line('w0') <= 1 ? "H" : "M")]],
  { expr = true, desc = "Scroll: fast upwards" }
)
RUtils.map.nnoremap(
  "<C-f>",
  [[max([winheight(0) - 2, 1]) ."<C-d>".(line('w$') >= line('$') ? "L" : "M")]],
  { expr = true, desc = "Scroll: fast downwards" }
)
RUtils.map.nnoremap(
  "<C-e>",
  [[(line("w$") >= line('$') ? "2j" : "2<C-e>")]],
  { expr = true, desc = "Scroll: down windows without moving the cursor" }
)
RUtils.map.nnoremap(
  "<C-y>",
  [[(line("w0") <= 1 ? "2k" : "2<C-y>")]],
  { expr = true, desc = "Scroll: up windows without moving the cursor" }
)
-- }}}
-- {{{ Buffers
RUtils.map.nnoremap("<Leader>bb", "<C-^>", { desc = "Buffer: alternate buffer", silent = true })
RUtils.map.nnoremap("<Leader>bw", "<CMD>wincmd =<CR>", { desc = "Buffer: equalize size buffer window", silent = true })

-- RUtils.map.nnoremap("<Leader>bn", function()
--   RUtils.map.go_prev_or_next_buffer(true)
-- end, { desc = "Buffer: next buffer" })
-- RUtils.map.nnoremap("<Leader>bp", function()
--   RUtils.map.go_prev_or_next_buffer()
-- end, { desc = "Buffer: prev buffer" })

RUtils.map.nnoremap("<Leader>bQ", function()
  Snacks.bufdelete.other()
  ---@diagnostic disable-next-line: undefined-field
  RUtils.info(RUtils.config.icons.misc.checklist .. " Purge buffers", { title = "Buffers" })
end, { desc = "Buffer: kill/purge other buffers" })
RUtils.map.nnoremap("<Leader>bk", RUtils.buf.magic_quit, { desc = "Buffer: magic exit" })
RUtils.map.nnoremap("<Leader><TAB>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit (alternative)" })
RUtils.map.xnoremap("<Leader><TAB>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit (visual)" })
RUtils.map.nnoremap("<Leader>bK", RUtils.buf.bufremove, { desc = "Buffer: kill/close buffer" })
RUtils.map.nnoremap("<a-x>", "<CMD>q!<CR>", { desc = "Buffer: force to quit (without save)", silent = true })

RUtils.map.nnoremap("<Leader>hR", function()
  vim.cmd [[wall!]]
  vim.cmd [[restart]]
end, { desc = "Buffer: restart nvim" })
RUtils.map.nnoremap(
  "<Leader>hb",
  RUtils.map.show_help_buf_keymap,
  { desc = "Help: show keymaps curbuf", silent = true }
)
-- }}}
-- {{{ Commandline
RUtils.map.cnoremap("hh", "<C-c>", { desc = "Commandline: exit" })
RUtils.map.cnoremap("<C-a>", "<Home>", { desc = "Commandline: start" })
RUtils.map.cnoremap("<C-e>", "<End>", { desc = "Commandline: end" })
RUtils.map.cnoremap("<C-h>", "<Left>", { desc = "Commandline: left" })
RUtils.map.cnoremap("<C-l>", "<Right>", { desc = "Commandline: right" })
RUtils.map.cnoremap("<C-b>", "<S-Left>", { desc = "Commandline: back word" })
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

RUtils.map.xnoremap(
  "<Leader>gv",
  "<esc><cmd>CompareClipboardSelection<cr>",
  { desc = "Git: compare diff with selection clipboard (visual)" }
)
-- }}}
-- {{{ Misc
RUtils.map.nnoremap("<Leader>qQ", function()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ft_buf = vim.api.nvim_get_option_value("modified", { buf = buf })
      if ft_buf then
        vim.api.nvim_set_current_buf(buf)

        RUtils.warn "Quit abort!"
        return
      end
    end
  end

  vim.cmd "wqa!"
end, { desc = "Quit: quit and save, but check first if any buffers are modified" })

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
RUtils.map.nnoremap("<Leader>n", function()
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
end, { desc = "Action: change cwd to dir file" })
RUtils.map.nnoremap("<Leader>fy", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or ""
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Copy current path" })
end, { silent = true, desc = "Files: yank current path" })
RUtils.map.nnoremap("<Leader>hn", function()
  -- convert into lua: "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  vim.cmd "nohlsearch"
  vim.cmd "diffupdate"

  -- clean up vim-highlighter
  --
  local ok, _ = pcall(vim.fn.HiList)
  if ok then
    local Hilist = vim.fn.HiList()
    if Hilist and #Hilist > 0 then
      vim.cmd "Hi -"
    end
  end
end, { desc = "Help: redraw / clear hlsearch / diff update" })
RUtils.map.nnoremap("<Esc>", function()
  vim.cmd "noh"
  return "<Esc>"
end, { desc = "Misc: escape and clear hlsearch", expr = true, silent = true })
RUtils.map.xnoremap(">", ">gv", { desc = "Misc: next align lines (visual)" })
RUtils.map.xnoremap("<", "<gv", { desc = "Misc: prev align lines (visual)" })
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
  local key = [[:%s/]]
  local search_string = ""
  if visual then
    local selection_str = RUtils.get_visual_selection()
    if selection_str then
      search_string = selection_str.selection
    end
  else
    key = key .. [[\<]]
    search_string = vim.fn.expand "<cword>"
  end
  key = key .. RUtils.map.escape(search_string, "[]")
  if not visual then
    key = key .. [[\>]]
  end
  key = key .. "/" .. RUtils.map.escape(search_string, "&")
  if confirmation then
    key = key .. [[/gcI]]
  else
    key = key .. [[/gI]]
  end
  RUtils.map.feedkey(key)

  if not_vscode() then
    local key_move = [[<Left><Left><Left>]]
    if confirmation then
      key_move = key_move .. [[<Left>]]
    end
    RUtils.map.feedkey(key_move)
  end
end
-- Search & replace
RUtils.map.nnoremap("<Leader>sr", replace_keymap, { desc = "Search: replace under cursor" })
RUtils.map.xnoremap("<Leader>sr", [["zy:%s/<C-r><C-o>"/]], { desc = "Misc: replace under cursor (visual)" })

-- Open with browser
RUtils.map.nnoremap("<Leader>ob", function()
  RUtils.cmd.open_with "browser"
end, { desc = "Search: open or look up online/browser" })
RUtils.map.vnoremap("<Leader>ob", function()
  RUtils.cmd.open_with "browser"
end, { desc = "Search: open or look up online/browser (visual" })

-- Open with mpv or svix
RUtils.map.nnoremap("<Leader>oB", function()
  RUtils.cmd.open_with "mpv or svix"
end, { desc = "Open: media" })
RUtils.map.vnoremap("<Leader>oB", function()
  RUtils.cmd.open_with "mpv or svix"
end, { desc = "Open: media (visual)" })

-- Open file under cursor
RUtils.map.nnoremap("<Leader>be", function()
  RUtils.cmd.open_with "go to file"
end, { desc = "Buffer: open file under cursor" })
RUtils.map.xnoremap("<Leader>be", function()
  RUtils.cmd.open_with "go to file"
end, { desc = "Buffer: open file under cursor (visual)" })

RUtils.map.nnoremap("<Leader>bv", function()
  RUtils.cmd.open_with("go to file", "vsplit")
end, { desc = "Buffer: open vsplit file under cursor" })
RUtils.map.xnoremap("<Leader>bv", function()
  RUtils.cmd.open_with("go to file", "vsplit")
end, { desc = "Buffer: open vpslit file under cursor (visual)" })

-- Browse error messages
RUtils.map.nnoremap("<Leader>oE", function()
  RUtils.cmd.browse_this_error(true)
end, { desc = "Open: look up errors in browser" })
RUtils.map.xnoremap("<Leader>oE", function()
  RUtils.cmd.browse_this_error(true)
end, { desc = "Open: look up errors in browser (visual)" })

-- Open notes
RUtils.map.nnoremap("<a-W>", function()
  RUtils.terminal.float_note()
end, { desc = "Misc: open notes" })
RUtils.map.tnoremap("<a-W>", function()
  RUtils.terminal.float_note()
end, { desc = "Misc: open notes (terminal)" })

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

-- Print non-builtin mappings
local function print_non_builtin_maps(mode)
  local maps = vim.api.nvim_get_keymap(mode)
  for _, map in ipairs(maps) do
    if map.sid < 0 then
      print(string.format("Mode:%s - %s -  %s desc: %s", mode, map.lhs, map.rhs or "", map.desc or ""))
    end
  end
end

RUtils.create_command("CheckMappings", function()
  -- Print untuk semua mode yang umum
  for _, mode in ipairs { "n", "i", "v", "x", "c", "t" } do
    print_non_builtin_maps(mode)
  end
end, { desc = "Misc: edit snippet file" })
-- }}}
-- {{{ Toggle
Snacks.toggle.option("wrap", { name = "Wrap" }):map "<Leader>uw"
Snacks.toggle.zoom():map "<a-m>"
Snacks.toggle.zen():map "<Leader>uz"
Snacks.toggle.treesitter():map "<Leader>us"

RUtils.map.nnoremap("<Leader>ul", function()
  local msg_notify
  local quickfix_cursorline_active = vim.g.is_quickfix_cursorline_active
  if quickfix_cursorline_active then
    vim.g.is_quickfix_cursorline_active = false
    msg_notify = "Turn Off"
  else
    vim.g.is_quickfix_cursorline_active = true
    msg_notify = "Turn On"
  end

  RUtils.warn("Cursorline -> " .. msg_notify, { title = "Toggle: Cursorline" })
end, { desc = "Toggle: cursorline" })
-- }}}
-- {{{ Commands
RUtils.map.nnoremap("<Leader>oI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input "I"
end, { desc = "Open: inspect treesitter" })
RUtils.create_command("Snippets", RUtils.cmd.edit_snippet, { desc = "Misc: edit snippet file" })
RUtils.create_command("ChangeMasterTheme", RUtils.cmd.change_colors, { desc = "Misc: set theme bspwm" })
RUtils.create_command("InfoOption", function()
  vim.cmd "options"
end, { desc = "Misc: echo options" })
RUtils.create_command("ImgInsert", RUtils.maim.insert, { desc = "Misc: echo options" })
RUtils.create_command("E", function()
  return cmd [[ vnew ]]
end, { desc = "Misc: vnew" })

RUtils.map.nnoremap("<Leader>bN", function()
  vim.cmd "E"
end, { desc = "Buffer: open empty buffer" })

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename()))
end, {
  desc = "Show LSP client log",
})

vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", {
  desc = "Show LSP info",
})

vim.api.nvim_create_user_command("DFile", function()
  local has_fzf, fzf = pcall(require, "fzf-lua")

  if has_fzf then
    -- Get current file path relative to git root
    local current_file = vim.fn.expand "%:p"
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    local relative_path = current_file:sub(#git_root + 2) -- +2 to account for trailing slash

    -- Use fzf-lua for commit selection
    fzf.git_commits {
      prompt = "Select commit> ",
      cmd = string.format("git log --oneline --decorate --color=always %s", vim.fn.shellescape(relative_path)),
      actions = {
        ["alt-u"] = function(selected)
          if selected and selected[1] then
            -- Extract commit hash from the first word of the selected line
            local commit_hash = selected[1]:match "^([^ ]+)"
            if commit_hash then
              vim.cmd(
                string.format("DiffviewOpen %s^ -- %s", commit_hash, current_file, vim.fn.shellescape(relative_path))
              )
            end
          end
        end,
        ["default"] = function(selected)
          if selected and selected[1] then
            -- Extract commit hash from the first word of the selected line
            local commit_hash = selected[1]:match "^([^ ]+)"
            if commit_hash then
              vim.cmd(
                string.format("DiffviewOpen %s^ -- %s", commit_hash, current_file, vim.fn.shellescape(relative_path))
              )
            end
          end
        end,
      },
      winopts = {
        preview = { horizontal = "right:70%" }, -- right|left:size
        title = "Changes of file against Commits - Selecting end change on right",
      },
      preview_pager = string.format(
        "git diff {1}^..{1} -- %s | delta --features=commit-hashes --commit-style=box --side-by-side --width ${FZF_PREVIEW_COLUMNS-$COLUMNS}",
        vim.fn.shellescape(relative_path)
      ),
    }
  end
end, {})
-- }}}
-- {{{ Bulk commands
-- These commands run outside tmux
local ctrl_o_nvim = function()
  RUtils.fzflua.open_cmd_bulk_key_only({
    ["Clock mode"] = function()
      RUtils.terminal.clock_mode()
    end,
    ["News"] = function()
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
  }, { winopts = { title = RUtils.fzflua.format_title("Alt-Y", RUtils.config.icons.misc.circle) } })
end

RUtils.map.nnoremap("<a-s-y>", ctrl_o_nvim, { desc = "Bulk: alt_Y commands" })
RUtils.map.tnoremap("<a-s-y>", ctrl_o_nvim, { desc = "Bulk: alt_Y commands" })
RUtils.map.xnoremap("<a-s-y>", ctrl_o_nvim, { desc = "Bulk: alt_Y commands (visual)" })

local bulk_cmd_misc = function()
  local cmds = {
    ["tailwindcss.com - open in browser"] = function()
      cmd "!open https://tailwindcss.com"
    end,
    ["TestNotify - Run to test notification display"] = function()
      -- to replace an existing notification just use the same id.
      -- you can also use the return value of the notify function as id.
      for i = 1, 10 do
        vim.defer_fn(function()
          vim.notify("Hello " .. i, "info", { id = "test" })
        end, i * 500)
      end

      RUtils.info "this RUtils info"
      RUtils.warn "this RUtils warn"
      RUtils.error "this RUtils error"
    end,
    ["Browser devdocs - with input"] = function()
      local query = vim.fn.input "Search DevDocs: "
      if #query > 0 then
        local encodedURL = string.format('open "https://devdocs.io/#q=%s"', query:gsub("%s", "%%20"))
        os.execute(encodedURL)
      end
    end,
  }

  if RUtils.has "candela.nvim" then
    cmds["Candela - Add color for log highlights"] = function()
      if not vim.tbl_contains({ "log", "bigfile" }, vim.bo.filetype) then
        RUtils.warn "Not log file!"
        return
      end

      local CandelaUi = require "candela.ui"
      CandelaUi.toggle()
    end
  end

  RUtils.fzflua.open_cmd_bulk_center(
    cmds,
    { winopts = { title = RUtils.fzflua.format_title("Open Commands", RUtils.config.icons.misc.fire) } }
  )
end

RUtils.map.nnoremap("<Leader>oF", bulk_cmd_misc, { desc = "Bulk: open commands" })
RUtils.map.tnoremap("<Leader>oF", bulk_cmd_misc, { desc = "Bulk: open commands" })
RUtils.map.xnoremap("<Leader>oF", bulk_cmd_misc, { desc = "Bulk: open commands (visual)" })

local bulk_cmd_git = function()
  RUtils.fzflua.open_cmd_bulk_center({
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
      vim.cmd [[DiffviewFileHistory --follow]]
    end,
    ["Codediff - VscodeDiff"] = function()
      vim.cmd [[VscodeDiff]]
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
  }, { winopts = { title = RUtils.fzflua.format_title("Git Commands", RUtils.config.icons.git.branch) } })
end

RUtils.map.nnoremap("<Leader>gF", bulk_cmd_git, { desc = "Bulk: git commands" })
RUtils.map.tnoremap("<Leader>gF", bulk_cmd_git, { desc = "Bulk: git commands" })
RUtils.map.xnoremap("<Leader>gF", bulk_cmd_git, { desc = "Bulk: git commands (visual)" })

-- }}}
-- {{{ Tmux integration

RUtils.map.nnoremap("<a-B>", function()
  RUtils.terminal.float_btop()
end, { desc = "CTRL_o: btop" })
RUtils.map.nnoremap("<a-Z>", function()
  RUtils.terminal.float_resterm()
end, { desc = "CTRL_o: resterm" })
RUtils.map.xnoremap("<a-B>", function()
  RUtils.terminal.float_btop()
end, { desc = "CTRL_o: btop" })

RUtils.map.nnoremap("<a-C>", function()
  RUtils.terminal.float_rkill()
end, { desc = "CTRL_o: rkill" })
RUtils.map.xnoremap("<a-C>", function()
  RUtils.terminal.float_rkill()
end, { desc = "CTRL_o: rkill" })

local get_right_pane_id_wez = function()
  local result = vim.system({ "wezterm", "cli", "get-pane-direction", "right" }, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout)
end

---@class TmuxDirectCmds
---@field close_program string
---@field is_kill boolean

---@class TmuxLayoutCmds
---@field command table
---@field pane_id string
---@field program string
---@field direct_command TmuxDirectCmds

RUtils.map.nnoremap("<a-E>", function()
  local dirname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":h:p")

  local PATH_PANE_COLLECT_JSON = "/tmp/tmux-main-layout-workspaces.json"
  local tmux = os.getenv "TMUX"
  local terminal = os.getenv "TERMINAL"

  -- ─[ Wezterm ]──────────────────────────────────────────────────────
  if not tmux then
    if terminal ~= "wezterm" then
      if RUtils.has "neo-tree.nvim" then
        vim.cmd "Neotree focus reveal right"
        return
      end
    end

    local pane_right_id = get_right_pane_id_wez()
    if pane_right_id then
      vim.system { "wezterm", "cli", "kill-pane", "--pane-id", pane_right_id }
    end

    vim.system { "wezterm", "cli", "split-pane", "--right", "--percent", "22" }
    vim.system { "sleep", "0.5" }
    vim.system { "wezterm", "cli", "activate-pane-direction", "left" }

    pane_right_id = get_right_pane_id_wez()
    if pane_right_id then
      vim.system {
        "wezterm",
        "cli",
        "send-text",
        "--pane-id",
        pane_right_id,
        "--no-paste",
        fm_manager .. " " .. dirname .. "\r",
      }
      vim.system { "wezterm", "cli", "activate-pane-direction", "right" }
    end
    return
  end

  -- ─[ Tmux helpers ]─────────────────────────────────────────────────

  local function tmux_cmd(io_cmd)
    local handle = io.popen(io_cmd)
    if not handle then
      RUtils.warn("Something went wrong when running `" .. io_cmd .. "`")
      return nil
    end
    local out = handle:read "*a"
    handle:close()
    if not out or out == "" then
      return nil
    end
    return out:gsub("%s+$", "")
  end

  local function get_json_field(session_name, window_id, field)
    if not RUtils.file.exists(PATH_PANE_COLLECT_JSON) then
      RUtils.warn("JSON not found: " .. PATH_PANE_COLLECT_JSON)
      return nil
    end

    local result = tmux_cmd(
      string.format(
        "jq -r --arg s %q --arg w %q --arg f %q '.[$s][$w][$f] // empty' %s",
        session_name,
        window_id,
        field,
        PATH_PANE_COLLECT_JSON
      )
    )

    if not result or result == "" or result == "null" then
      return nil
    end
    return result
  end

  local function is_pane_alive(pane_id)
    if not pane_id or pane_id == "" then
      return false
    end
    local result = vim.system({ "tmux", "list-panes", "-a", "-F", "#{pane_id}" }, { text = true }):wait()
    if result.code ~= 0 then
      return false
    end
    for line in result.stdout:gmatch "[^\n]+" do
      if vim.trim(line) == pane_id then
        return true
      end
    end
    return false
  end

  local function get_pane_process(pane_id)
    local result = vim
      .system({ "tmux", "display-message", "-p", "-t", pane_id, "#{pane_current_command}" }, { text = true })
      :wait()
    if result.code ~= 0 then
      return ""
    end
    return vim.trim(result.stdout)
  end

  -- Tunggu sampai proses di pane BUKAN target_proc lagi (mode close)
  -- atau SUDAH menjadi target_proc (mode jump)
  local function wait_for_process(pane_id, target_proc, is_close)
    for _ = 1, 20 do
      local proc = get_pane_process(pane_id)
      if is_close then
        if proc ~= target_proc then
          return
        end
      else
        if proc == target_proc then
          return
        end
      end
      os.execute "sleep 0.15"
    end
  end

  -- ─[ Resolve pane IDs ]─────────────────────────────────────────────

  local current_session = tmux_cmd "tmux display-message -p '#S'"
  local current_window = tmux_cmd "tmux display-message -p '#I'"
  if not current_session or not current_window then
    return
  end

  local file_manager_pane_id = get_json_field(current_session, current_window, "file_manager_pane_id")

  if not file_manager_pane_id or not is_pane_alive(file_manager_pane_id) then
    RUtils.warn "<a-E>: file_manager_pane_id not found or pane dead.\nRun tm-toggle-pane first to create the layout."
    return
  end

  -- ─[ Execute ]──────────────────────────────────────────────────────

  local proc = get_pane_process(file_manager_pane_id)
  if proc == fm_manager then
    vim.system { "sh", "-c", "tmux send-keys -t " .. file_manager_pane_id .. " 'q' Enter" }
    wait_for_process(file_manager_pane_id, fm_manager, true) -- tunggu sampai bukan fm_manager
  end

  proc = get_pane_process(file_manager_pane_id)
  if proc == "nvim" then
    vim.system { "sh", "-c", "tmux send-keys -t " .. file_manager_pane_id .. " Escape ':qa!' Enter" }
    wait_for_process(file_manager_pane_id, "nvim", true) -- tunggu sampai bukan nvim
  end

  vim.system {
    "sh",
    "-c",
    "tmux send-keys -t " .. file_manager_pane_id .. " '" .. fm_manager .. " " .. dirname .. "' Enter",
  }

  wait_for_process(file_manager_pane_id, fm_manager, false)
  vim.system { "tmux", "select-pane", "-t", file_manager_pane_id }
end)
-- }}}
-- }}}
