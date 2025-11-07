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
RUtils.map.nnoremap("<C-a>", function()
  RUtils.map.wrap_fold_cmd "normal! zMzv"
end, { desc = "Fold: focus current" })
RUtils.map.nnoremap("zf", function()
  RUtils.map.wrap_fold_cmd "normal! zMzv"
end, { desc = "Fold: focus current (alternativ)" })
RUtils.map.nnoremap("zc", function()
  RUtils.map.wrap_fold_cmd "normal! zM"
end, { desc = "Fold: close all" })
RUtils.map.nnoremap("zb", function()
  RUtils.fold.cycle_fold_level()
end, { desc = "Fold: cycle fold level (util)" })
RUtils.map.nnoremap("zo", function()
  RUtils.map.wrap_fold_cmd "normal! zRzz"
end, { desc = "Fold: open all" })

-- Navigate magic fold
RUtils.map.nnoremap("<c-n>", function()
  RUtils.map.magic_jump()
end, { desc = "View: magic jump" })
RUtils.map.nnoremap("<c-p>", function()
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

RUtils.map.tnoremap("<a-h>", function()
  RUtils.map.feedkey("<C-\\><C-n><C-w>h", "t")
end, { desc = "Terminal: move left" })
RUtils.map.tnoremap("<a-j>", function()
  RUtils.map.feedkey("<C-\\><C-n><C-w>j", "t")
end, { desc = "Terminal: move down" })
RUtils.map.tnoremap("<a-k>", function()
  RUtils.map.feedkey("<C-\\><C-n><C-w>k", "t")
end, { desc = "Terminal: move up" })
RUtils.map.tnoremap("<a-l>", function()
  RUtils.map.feedkey("<C-\\><C-n><C-w>l", "t")
end, { desc = "Terminal: move right" })

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

RUtils.map.nnoremap("<Leader>wJ", arange_wins "J", { desc = "Window: move down" })
RUtils.map.xnoremap("<Leader>wJ", arange_wins "J", { desc = "Window: move down (visual)" })

RUtils.map.nnoremap("<Leader>wK", arange_wins "K", { desc = "Window: move up" })
RUtils.map.xnoremap("<Leader>wK", arange_wins "K", { desc = "Window: move up (visual)" })

RUtils.map.nnoremap("<Leader>wH", arange_wins "H", { desc = "Window: move left" })
RUtils.map.xnoremap("<Leader>wH", arange_wins "H", { desc = "Window: move left (visual)" })

RUtils.map.nnoremap("<Leader>wL", arange_wins "L", { desc = "Window: move right" })
RUtils.map.xnoremap("<Leader>wL", arange_wins "L", { desc = "Window: move right (visual)" })

local function jump_back_to_back_windows()
  local right_win = { "trouble", "aerial", "Outline", "rgflow", "neo-tree", "snacks_notif_history", "ErgoTerm" }

  -- Go back to the window if any windows are open
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
end

RUtils.map.nnoremap("<Leader>ow", jump_back_to_back_windows, { desc = "Window: jump to side panel" })
RUtils.map.nnoremap("<Leader>wo", jump_back_to_back_windows, { desc = "Window: jump to side panel" })

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
-- RUtils.map.nnoremap("zl", "z4l")
-- RUtils.map.nnoremap("zh", "z4h") -- zh use for fold
RUtils.map.nnoremap("zL", "z20l")
RUtils.map.nnoremap("zH", "z20h")

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
RUtils.map.nnoremap("<Leader>bt", "<C-w><S-t>", { desc = "Buffer: move to new tab", silent = true })
RUtils.map.nnoremap("<Leader>bb", "<C-^>", { desc = "Buffer: alternate", silent = true })
RUtils.map.nnoremap("<Leader>bw", "<CMD>wincmd =<CR>", { desc = "Buffer: equalize size", silent = true })
RUtils.map.nnoremap("<Leader>bc", "<CMD>q!<CR>", { desc = "Buffer: close", silent = true })
RUtils.map.nnoremap("<Leader>bd", RUtils.buf.bufremove, { desc = "Buffer: delete", silent = true })
RUtils.map.nnoremap("<a-x>", "<CMD>q!<CR>", { desc = "Buffer: close (force)", silent = true })
RUtils.map.nnoremap("<Leader>bo", function()
  Snacks.bufdelete.other()
  ---@diagnostic disable-next-line: undefined-field
  RUtils.info(RUtils.config.icons.misc.checklist .. " Purge buffers", { title = "Buffers" })
end, { desc = "Buffer: delete all other buffers" })
RUtils.map.nnoremap("gl", function()
  RUtils.map.go_prev_or_next_buffer(true)
end, { desc = "Buffer: go next" })
RUtils.map.nnoremap("gh", function()
  RUtils.map.go_prev_or_next_buffer()
end, { desc = "Buffer: go prev" })
RUtils.map.nnoremap("<Leader><TAB>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit" })
RUtils.map.nnoremap("<c-q>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit" })
-- RUtils.map.nnoremap("<Leader>R", function()
--   vim.cmd [[wall!]]
--   vim.cmd [[restart]]
-- end, { desc = "Buffer: restart nvim" })
RUtils.map.xnoremap("<Leader><TAB>", RUtils.buf.magic_quit, { desc = "Buffer: magic exit (visual)" })
RUtils.map.nnoremap("<Leader>bk", RUtils.map.show_help_buf_keymap, {
  desc = "Buffer: show keymaps curbuf",
  silent = true,
})
-- }}}
-- {{{ Commandline
RUtils.map.cnoremap("hh", "<C-c>", { desc = "Commandline: exit" })
RUtils.map.cnoremap("<C-a>", "<Home>", { desc = "Commandline: start" })
RUtils.map.cnoremap("<C-e>", "<End>", { desc = "Commandline: end" })
-- Disabled: conflict with blink cmdline
-- RUtils.map.cnoremap("<C-n>", "<Down>", { desc = "Commandline: next hist" })
-- RUtils.map.cnoremap("<C-p>", "<Up>", { desc = "Commandline: prev hist" })
RUtils.map.cnoremap("<C-h>", "<Left>", { desc = "Commandline: left" })
RUtils.map.cnoremap("<C-l>", "<Right>", { desc = "Commandline: right" })
RUtils.map.cnoremap("<C-b>", "<S-Left>", { desc = "Commandline: back word" })
RUtils.map.cnoremap("<C-f>", "<S-Right>", { desc = "Commandline: fwd word" })
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
if vim.fn.executable "lazygit" == 1 then
  RUtils.map.nnoremap("<a-G>", function()
    ---@diagnostic disable-next-line: missing-fields
    Snacks.lazygit { cwd = RUtils.root.git() }
  end, { desc = "Git: lazygit (root dir) [snacks]" })

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
-- RUtils.map.nnoremap("<C-o>", "<C-o>zvzz", { desc = "Misc: jump back <c-o> and center" })
-- RUtils.map.nnoremap("<C-i>", "<C-i>zvzz", { desc = "Misc: jump forward <c-i> and center" })

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
RUtils.map.nnoremap("<Leader>n", function()
  -- "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  -- convert into lua:
  vim.cmd "nohlsearch"
  vim.cmd "diffupdate"
  vim.cmd "normal! <C-L>"

  -- clean up vim-highlighter
  --
  local ok, _ = pcall(vim.fn.HiList)
  if ok then
    local Hilist = vim.fn.HiList()
    if Hilist and #Hilist > 0 then
      RUtils.info("Clear", { title = "Vim-Highlighter" })
      vim.cmd "Hi -"
    end
  end
end, { desc = "Misc: redraw / clear hlsearch / diff update" })
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
RUtils.map.nnoremap("<Leader>sr", replace_keymap, { desc = "Misc: replace under cursor" })
RUtils.map.xnoremap("<Leader>sr", [["zy:%s/<C-r><C-o>"/]], { desc = "Misc: replace under cursor (visual)" })

-- Lazy log
RUtils.map.nnoremap("<Leader>ol", "<Cmd>Lazy log<CR>", { desc = "Open: lazy log" })

-- Open with browser
RUtils.map.nnoremap("<Leader>ob", function()
  RUtils.cmd.open_with "browser"
end, { desc = "Open: magic browser" })
RUtils.map.vnoremap("<Leader>ob", function()
  RUtils.cmd.open_with "browser"
end, { desc = "Open: magic browse (visual" })

-- Open with mpv or svix
RUtils.map.nnoremap("<Leader>oB", function()
  RUtils.cmd.open_with("mpv or svix", true)
end, { desc = "Open: magic media" })
RUtils.map.vnoremap("<Leader>oB", function()
  RUtils.cmd.open_with("mpv or svix", true)
end, { desc = "Open: magic media (visual)" })

-- Open file under cursor
RUtils.map.nnoremap("<Leader>oo", function()
  RUtils.cmd.open_with "go to file"
end, { desc = "Open: file under cursor" })
RUtils.map.xnoremap("<Leader>oo", function()
  RUtils.cmd.open_with "go to file"
end, { desc = "Open: file under cursor (visual)" })

-- Browse error messages
RUtils.map.nnoremap("<Leader>rb", function()
  RUtils.cmd.browse_this_error(true)
end, { desc = "Open: browse errors" })
RUtils.map.xnoremap("<Leader>rb", function()
  RUtils.cmd.browse_this_error(true)
end, { desc = "Open: browse errors (visual)" })

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
    -- Builtin mappings biasanya punya sid > 0
    -- RUtils.info(vim.inspect(map))
    if map.sid < 0 then
      -- RUtils.info(string.format("[%s] %s -> %s", mode, map.lhs, map.rhs or ""))
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

RUtils.map.nnoremap("<F1>", "<CMD>CheckMappings<CR>")

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
Snacks.toggle.zoom():map "<a-m>"
Snacks.toggle.zen():map "<Leader>uz"
Snacks.toggle.diagnostics():map "<Leader>ltd"
Snacks.toggle.treesitter():map "<Leader>us"
-- Snacks.toggle.scroll():map "<Leader>uS"
-- Snacks.toggle.animate():map "<Leader>ua"
-- Snacks.toggle.line_number():map "<leader>ul"
-- Snacks.toggle.profiler():map "<Localleader>spp"
-- Snacks.toggle.profiler_highlights():map "<Localleader>sph"

-- if vim.lsp.inlay_hint then
Snacks.toggle.inlay_hints():map "<Leader>uH"
--   if not vim.g.inlay_hints then
--     RUtils.info "Inlay hint On"
--     vim.g.inlay_hints = true
--   else
--     RUtils.info "Inlay hint OFF"
--     vim.g.inlay_hints = false
--   end
-- end

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

  local should_update_all_cursorlines = vim.g.should_update_all_cursorlines
  if should_update_all_cursorlines then
    vim.g.should_update_all_cursorlines = false
  else
    vim.g.should_update_all_cursorlines = true
  end

  RUtils.warn("Cursorline -> " .. msg_notify, { title = "Toggle: Cursorline" })
end, { desc = "Toggle: cursorline" })

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
RUtils.create_command("Snippets", RUtils.cmd.edit_snippet, { desc = "Misc: edit snippet file" })
RUtils.create_command("ChangeMasterTheme", RUtils.cmd.change_colors, { desc = "Misc: set theme bspwm" })
RUtils.create_command("InfoOption", function()
  vim.cmd "options"
end, { desc = "Misc: echo options" })
RUtils.create_command("ImgInsert", RUtils.maim.insert, { desc = "Misc: echo options" })
RUtils.create_command("E", function()
  return cmd [[ vnew ]]
end, { desc = "Misc: vnew" })

-- vim.api.nvim_create_user_command("Cfilter", function(opts)
--   vim.cmd.packadd "cfilter"
--   vim.cmd.Cfilter { args = opts.fargs, bang = opts.bang }
-- end, { force = true, bang = true, nargs = "*" })
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
  }, { winopts = { title = "CtrlO" } })
end

RUtils.map.nnoremap("<a-o>", ctrl_o_nvim, { desc = "Bulk: ctrl_o cmds" })
RUtils.map.tnoremap("<a-o>", ctrl_o_nvim, { desc = "Bulk: ctrl_o cmds" })
RUtils.map.xnoremap("<a-o>", ctrl_o_nvim, { desc = "Bulk: ctrl_o cmds (visual)" })

local bulk_cmd_misc = function()
  local cmds = {
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
    ["Browser - Open devdocs (with input)"] = function()
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

  RUtils.fzflua.open_cmd_bulk(cmds, { winopts = { title = "Bulk Misc" } })
end

RUtils.map.nnoremap("<Leader>of", bulk_cmd_misc, { desc = "Bulk: misc cmds" })
RUtils.map.tnoremap("<Leader>of", bulk_cmd_misc, { desc = "Bulk: misc cmds" })
RUtils.map.xnoremap("<Leader>of", bulk_cmd_misc, { desc = "Bulk: misc cmds (visual)" })

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
RUtils.map.xnoremap("<Leader>gof", bulk_cmd_git, { desc = "Bulk: git cmds (visual)" })

-- }}}
-- {{{ Tmux integration

RUtils.map.nnoremap("<a-B>", function()
  RUtils.terminal.float_btop()
end, { desc = "CTRL_o: btop" })
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
  local get_pane_right_id = vim.system({ "wezterm", "cli", "get-pane-direction", "right" }, { text = true }):wait()
  if get_pane_right_id.code ~= 0 then
    return nil
  end
  return get_pane_right_id.stdout
end

---@class TmuxDirectCmds
---@field close_program string
---@field is_kill boolean
---@field is_jump boolean

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
    return
  end

  ---@param io_cmd string
  ---@return string | nil
  local tmux_cmd = function(io_cmd)
    local handle = io.popen(io_cmd)
    if not handle then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.warn("Something went wrong when running `" .. io_cmd "`")
      return
    end

    local output_cmd = handle:read "*a"
    handle:close()

    if output_cmd == "" then
      return
    end

    return output_cmd:gsub("%s+$", "")
  end

  local get_current_session = function()
    return tmux_cmd "tmux display-message -p '#S'"
  end

  local get_current_window_id = function()
    return tmux_cmd "tmux display-message -p '#I'"
  end

  ---@param session_name string
  ---@param window_id string
  ---@param field string
  ---@param path string
  ---@return string | nil
  local function get_json_field(session_name, window_id, field, path)
    if not RUtils.file.exists(path) then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.warn("Path json not found: " .. path)
      return
    end

    -- Jalankan command jq
    local handle = io.popen(string.format("jq -r '.%s.\"%s\".%s' %s", session_name, window_id, field, path))
    if not handle then
      RUtils.warn "Failed to run jq"
      return
    end

    local result = handle:read "*a"
    handle:close()

    -- Trim whitespace
    result = result:gsub("^%s+", ""):gsub("%s+$", "")

    return result
  end

  local current_session = get_current_session()
  local current_window = get_current_window_id()
  if not current_session or not current_window then
    return
  end

  local main_pane_id = get_json_field(current_session, current_window, "main_pane_id", PATH_PANE_COLLECT_JSON)
  local file_manager_pane_id =
    get_json_field(current_session, current_window, "file_manager_pane_id", PATH_PANE_COLLECT_JSON)

  -- stop process if needed it
  if not main_pane_id or not file_manager_pane_id then
    return
  end

  ---@param cal TmuxLayoutCmds
  ---@param mode "close" | "jump"
  local function wait_for_pane(cal, mode)
    mode = mode or "close"

    for _ = 1, 10 do
      local get_cmd = vim
        .system({
          "sh",
          "-c",
          string.format([[tmux display -p -t %s '#{pane_current_command}' | tr -d '\n']], cal.pane_id),
        }, { text = true })
        :wait()

      if get_cmd.code ~= 0 or #get_cmd.stdout == 0 then
        break
      end

      -- berhenti jika program sudah sesuai
      if get_cmd.stdout == cal.program then
        break
      end

      os.execute "sleep 0.5"
    end
  end

  ---@param cmds TmuxLayoutCmds[]
  local function exec_commands(cmds)
    for _, cal in pairs(cmds) do
      if cal.direct_command.is_kill then
        local get_current_process = vim
          .system({
            "sh",
            "-c",
            [[tmux display -p -t ]] .. file_manager_pane_id .. [[ '#{pane_current_command}' | tr -d '\n']],
          }, { text = true })
          :wait()

        if get_current_process.code ~= 0 or #get_current_process.stdout == 0 then
          break
        end

        if get_current_process.stdout == cal.direct_command.close_program then
          vim.system(cal.command)

          -- Wait until program is closed
          wait_for_pane(cal, "close")
        end
      end

      vim.system(cal.command)

      if cal.direct_command.is_jump then
        wait_for_pane(cal, "jump")
        vim.system(cal.command)
      end
    end
  end

  ---@type TmuxLayoutCmds[]
  local send_command = {
    --- Close yazi
    {
      command = { "sh", "-c", "tmux send-keys -t " .. file_manager_pane_id .. " 'q' Enter" },
      direct_command = { is_kill = true, close_program = fm_manager, is_jump = false },
      pane_id = file_manager_pane_id,
      program = "zsh",
    },

    --- Close nvim
    {
      command = { "sh", "-c", "tmux send-keys -t " .. file_manager_pane_id .. " 'q' Enter" },
      direct_command = { is_kill = true, close_program = fm_manager, is_jump = false },
      pane_id = file_manager_pane_id,
      program = "zsh",
    },

    --- Open yazi with targeted cwd
    {
      command = {
        "sh",
        "-c",
        "tmux send-keys -t " .. file_manager_pane_id .. " '" .. fm_manager .. " " .. dirname .. "' Enter",
      },
      direct_command = { is_kill = false, close_program = "", is_jump = false },
      pane_id = file_manager_pane_id,
      program = fm_manager,
    },

    -- Jump to target pane
    {
      command = {
        "sh",
        "-c",
        "tmux select-pane -t " .. file_manager_pane_id,
      },
      direct_command = { is_kill = false, close_program = "", is_jump = true },
      pane_id = file_manager_pane_id,
      program = fm_manager,
    },
  }

  exec_commands(send_command)
end)
-- }}}
