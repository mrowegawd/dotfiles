local silent = { silent = true }
local nosilent = { silent = false }

local fn, cmd, fmt = vim.fn, vim.cmd, string.format
local fm_manager = vim.env.TERM_FILEMANAGER

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                 Edit/Insert                                 ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

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

RUtils.map.inoremap("<Esc>", function()
  RUtils.map.feedkey "<C-c>"
  vim.cmd "noh"
  return "<esc>"
end, silent)
RUtils.map.nnoremap("<Esc>", function()
  vim.cmd "noh"
  return "<esc>"
end, silent)
RUtils.map.vnoremap("<Esc>", function()
  RUtils.map.feedkey "<C-c>"
  vim.cmd "noh"
  return "<esc>"
end, silent)

RUtils.map.inoremap("hh", "<Esc>", silent)

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                    FOLD                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

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
--stylua: ignore
RUtils.map.nnoremap("zf", function() RUtils.map.wrap_fold_cmd "normal! zMzv" end, { desc = "Fold: focus current (alternativ)" })
--stylua: ignore
RUtils.map.nnoremap("zb", function() RUtils.fold.cycle_fold_level() end, { desc = "Fold: cycle fold level (util)" })

-- Navigate magic fold
RUtils.map.nnoremap("<a-n>", function()
  RUtils.map.magic_jump()
end, { desc = "View: magic jump" })
RUtils.map.nnoremap("<a-p>", function()
  RUtils.map.magic_jump(true)
end, { desc = "View: magic jump" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              WINDOW <leader>w                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local arange_wins = RUtils.buf.window.arange_wins
local switch_focus_targeted_window = RUtils.buf.window.switch_focus_targeted_window

RUtils.map.nnoremap("<Leader>wv", arange_wins "vsplit", { desc = "Window: vsplit" })
RUtils.map.nnoremap("<Leader>ws", arange_wins "split", { desc = "Window: split" })

RUtils.map.nnoremap("<Leader>ww", switch_focus_targeted_window, { desc = "Window: switch focus" })

RUtils.map.nnoremap("<c-w>s", arange_wins "split", { desc = "Window: split" })
RUtils.map.nnoremap("<c-w>j", arange_wins "split", { desc = "Window: split (alternative)" })
RUtils.map.nnoremap("<c-w>v", arange_wins "vsplit", { desc = "Window: vsplit (alternative)" })
RUtils.map.nnoremap("<c-w>l", arange_wins "vsplit", { desc = "Window: vsplit (alternative)" })
RUtils.map.nnoremap("<c-w>L", function()
  if vim.w.is_overlook_popup then
    arange_wins "vsplit"()
  end
  RUtils.map.feedkey "<C-w>L"
end, { desc = "Window: vsplit (alternative)" })
RUtils.map.nnoremap("<c-w>t", arange_wins "tabe", { desc = "Window: move new tab", silent = true })

RUtils.map.nnoremap("<Leader>wJ", arange_wins "J", { desc = "Window: move ↓" })
RUtils.map.xnoremap("<Leader>wJ", arange_wins "J", { desc = "Window: move ↓ (visual)" })
RUtils.map.nnoremap("<Leader>wK", arange_wins "K", { desc = "Window: move ↑" })
RUtils.map.xnoremap("<Leader>wK", arange_wins "K", { desc = "Window: move ↑ (visual)" })
RUtils.map.nnoremap("<Leader>wH", arange_wins "H", { desc = "Window: move ←" })
RUtils.map.xnoremap("<Leader>wH", arange_wins "H", { desc = "Window: move ← (visual)" })
RUtils.map.nnoremap("<Leader>wL", arange_wins "L", { desc = "Window: move →" })
RUtils.map.xnoremap("<Leader>wL", arange_wins "L", { desc = "Window: move → (visual)" })

RUtils.map.nnoremap("<Leader>ul", RUtils.layout.disable, { desc = "Toggle: disable/enable layout" })

-- stylua: ignore
RUtils.map.nnoremap("<leader>JJ", function() RUtils.info(vim.inspect(RUtils.layout.debug())) end, { desc = "Test: debug layout" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                   TAB t..                                   ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

RUtils.map.nnoremap("tn", function()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd "wincmd p"
  end
  vim.cmd "tabedit %"
end, { desc = "Tab: new tab", silent = true })
RUtils.map.nnoremap("tc", "<CMD>tabclose<CR>", { desc = "Tab: close", silent = true })
RUtils.map.nnoremap("tH", "<CMD>tabfirst<CR>", { desc = "Tab: first", silent = true })
RUtils.map.nnoremap("tL", "<CMD>tablast<CR>", { desc = "Tab: last", silent = true })
RUtils.map.nnoremap("tl", "<CMD>tabnext<CR>", { desc = "Tab: next", silent = true })
RUtils.map.nnoremap("th", "<CMD>tabprevious<CR>", { desc = "Tab: prev", silent = true })

-- Works outside tmux
RUtils.map.nnoremap("<C-a-l>", "<CMD>tabnext<CR>", { desc = "Tab: next (mod)", silent = true })
RUtils.map.nnoremap("<C-a-h>", "<CMD>tabprevious<CR>", { desc = "Tab: prev (mod)", silent = true })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              BUFFER <leader>b                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

RUtils.map.nnoremap("<Leader>bl", "<C-^>", { desc = "Buffer: last buf (alternate)", silent = true })
RUtils.map.nnoremap("<Leader>bw", "<CMD>wincmd =<CR>", { desc = "Buffer: equalize window size", silent = true })
RUtils.map.nnoremap("<Leader>bQ", function()
  Snacks.bufdelete.other()
  RUtils.info(RUtils.config.icons.misc.checklist .. " Purge buffers", { title = "Buffers" })
end, { desc = "Buffer: kill/purge other buffers" })
RUtils.map.nnoremap("<Leader>bk", RUtils.buf.magic_quit, { desc = "Buffer: magic exit" })
RUtils.map.nnoremap("<Leader>bK", RUtils.buf.bufremove, { desc = "Buffer: kill/close buffer" })
RUtils.map.nnoremap("<Leader>bN", vim.cmd.E, { desc = "Buffer: new empty" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                               HELP <leader>h                                ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--stylua: ignore
RUtils.map.nnoremap("<Leader>hR", function() vim.cmd [[wall!]] vim.cmd [[restart]] end, { desc = "Help: restart nvim" })
--stylua: ignore
RUtils.map.nnoremap( "<Leader>hb", RUtils.map.show_help_buf_keymap, { desc = "Help: show keymaps buffer", silent = true })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              SEARCH <leader>s                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local replace_keymap = RUtils.buf.window.replace_keymap
RUtils.map.nnoremap("<Leader>xR", replace_keymap, { desc = "Cmd: replace string under cursor" })
RUtils.map.xnoremap("<Leader>xR", [["zy:%s/\v\V<C-r><C-o>z/]], { desc = "Cmd: replace string under cursor" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                               OPEN <leader>o                                ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--stylua: ignore
RUtils.map.nnoremap("<Leader>ob", function() RUtils.cmd.open_with "browser" end, { desc = "Open: lookup in browser" })
--stylua: ignore
RUtils.map.vnoremap("<Leader>ob", function() RUtils.cmd.open_with "browser" end, { desc = "Open: lookup in browser(visual)" })

--stylua: ignore
RUtils.map.nnoremap("<Leader>oB", function() RUtils.cmd.open_with "mpv or svix" end, { desc = "Open: open-with" })
--stylua: ignore
RUtils.map.vnoremap("<Leader>oB", function() RUtils.cmd.open_with "mpv or svix" end, { desc = "Open: open-with (visual)" })

--stylua: ignore
RUtils.map.nnoremap("<Leader>oe", function() RUtils.cmd.open_with "go to file" end, { desc = "Open: under cursor" })
--stylua: ignore
RUtils.map.xnoremap("<Leader>oe", function() RUtils.cmd.open_with "go to file" end, { desc = "Open: under cursor (visual)" })
--stylua: ignore
RUtils.map.nnoremap("<Leader>ov", function() RUtils.cmd.open_with("go to file", "vsplit") end, { desc = "Open: under cursor vsplit" })
--stylua: ignore
RUtils.map.xnoremap("<Leader>ov", function() RUtils.cmd.open_with("go to file", "vsplit") end, { desc = "Open: under cursor (visual)" })

--stylua: ignore
RUtils.map.nnoremap("<Leader>oE", function() RUtils.cmd.browse_this_error(true) end, { desc = "Open: lookup error online" })
--stylua: ignore
RUtils.map.xnoremap("<Leader>oE", function() RUtils.cmd.browse_this_error(true) end, { desc = "Open: lookup error online (visual)" })

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

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              TOGGLE <leader>u                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

Snacks.toggle.option("wrap", { name = "Wrap" }):map "<Leader>uw"
Snacks.toggle.zen():map "<Leader>uz"

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                  TERMINAL                                   ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--stylua: ignore
RUtils.map.tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
--stylua: ignore
RUtils.map.tnoremap("<a-x>", function() local buf = vim.api.nvim_get_current_buf() require("bufdelete").bufdelete(buf, true) end, { desc = "Terminal: close", silent = true })
--stylua: ignore
RUtils.map.tnoremap("<C-a-l>", function() RUtils.map.feedkey("<C-\\><C-n><C-a-l>", "t") end, { desc = "Terminal: next tab" })
--stylua: ignore
RUtils.map.tnoremap("<C-a-h>", function() RUtils.map.feedkey("<C-\\><C-n><C-a-h>", "t") end, { desc = "Terminal: prev tab" })

-- stylua: ignore
RUtils.map.tnoremap("<c-w>h", function() RUtils.map.feedkey("<C-\\><C-n><C-w>h", "t") end, { desc = "Terminal: move left" })
-- stylua: ignore
RUtils.map.tnoremap("<c-w>j", function() RUtils.map.feedkey("<C-\\><C-n>:wincmd j<CR>", "t") end, { desc = "Terminal: move down" })
-- stylua: ignore
RUtils.map.tnoremap("<c-w>k", function() RUtils.map.feedkey("<C-\\><C-n><C-w>k", "t") end, { desc = "Terminal: move up" })
-- stylua: ignore
RUtils.map.tnoremap("<c-w>l", function() RUtils.map.feedkey("<C-\\><C-n>:wincmd l<CR>", "t") end, { desc = "Terminal: move right" })

-- ├──────────────────────────────────┤ OPEN ├──────────────────────────────────┤

-- ════════════════════════════════ TOGGLE TERM ═════════════════════════════
-- stylua: ignore
RUtils.map.nnoremap("<a-f>",RUtils.terminal.toggle_term, { desc = "Terminal: toggle [ergoterm]" })
-- stylua: ignore
RUtils.map.xnoremap("<a-f>",RUtils.terminal.toggle_term, { desc = "Terminal: toggle (visual) [ergoterm]" })
-- stylua: ignore
RUtils.map.tnoremap("<a-f>",RUtils.terminal.toggle_term, { desc = "Terminal: toggle (terminal) [ergoterm]" })

-- ══════════════════════════════════ TAB TERM ══════════════════════════════════
-- stylua: ignore
RUtils.map.nnoremap("<a-N>",RUtils.terminal.tab_term, { desc = "Terminal: tab [ergoterm]" })
-- stylua: ignore
RUtils.map.xnoremap("<a-N>",RUtils.terminal.tab_term, { desc = "Terminal: tab (visual) [ergoterm]" })
-- stylua: ignore
RUtils.map.tnoremap("<a-N>",RUtils.terminal.tab_term, { desc = "Terminal: tab (terminal) [ergoterm]" })

-- stylua: ignore
RUtils.map.nnoremap("<C-Space>l",RUtils.terminal.open_right, { desc = "Terminal: right [ergoterm]" })
-- stylua: ignore
RUtils.map.tnoremap("<C-Space>l",RUtils.terminal.open_right, { desc = "Terminal: right (terminal) [ergoterm]" })
-- stylua: ignore
RUtils.map.xnoremap("<C-Space>l",RUtils.terminal.open_right, { desc = "Terminal: right (visual) [ergoterm]" })

-- stylua: ignore
RUtils.map.nnoremap("<C-Space>j", RUtils.terminal.open_below, { desc = "Terminal: below [ergoterm]" })
-- stylua: ignore
RUtils.map.tnoremap("<C-Space>j", RUtils.terminal.open_below, { desc = "Terminal: below (terminal) [ergoterm]" })
-- stylua: ignore
RUtils.map.xnoremap("<C-Space>j", RUtils.terminal.open_below, { desc = "Terminal: below (visual) [ergoterm]" })

-- ═════════════════════════════════ FLOAT TERM ═════════════════════════════════
-- stylua: ignore
RUtils.map.xnoremap("<a-T>", RUtils.terminal.open_float, { desc = "Terminal: float (visual) [ergoterm]" })
-- stylua: ignore
RUtils.map.nnoremap("<a-T>", RUtils.terminal.open_float, { desc = "Terminal: float [ergoterm]" })
-- stylua: ignore
RUtils.map.tnoremap("<a-T>", RUtils.terminal.open_float, { desc = "Terminal: float [ergoterm]" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                 COMMANDLINE                                 ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

RUtils.map.cnoremap("hh", "<Esc>", { desc = "Commandline: exit" })
RUtils.map.cnoremap("<C-a>", "<Home>", { desc = "Commandline: start" })
RUtils.map.cnoremap("<C-e>", "<End>", { desc = "Commandline: end" })
RUtils.map.cnoremap("<C-h>", "<Left>", { desc = "Commandline: left" })
RUtils.map.cnoremap("<C-l>", "<Right>", { desc = "Commandline: right" })
RUtils.map.cnoremap("<C-b>", "<S-Left>", { desc = "Commandline: back word" })

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

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                   SCROLL                                    ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

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

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                    DIFF                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

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

--stylua: ignore
RUtils.map.xnoremap( "<Leader>gv", "<esc><cmd>CompareClipboardSelection<cr>", { desc = "Git: compare diff with selection (visual)" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                    MISC                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

RUtils.map.nnoremap("<a-x>", "<CMD>q!<CR>", { desc = "Misc: force to quit (without save)", silent = true })

RUtils.map.vmap("K", "<Nop>")
RUtils.map.nmap("K", "<Nop>")
RUtils.map.nmap("q", "<Nop>")

Snacks.toggle.zoom():map "<Leader>mm"

RUtils.map.nnoremap("<Leader>n", function()
  -- convert into lua: "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  vim.cmd "nohlsearch"
  vim.cmd "diffupdate"

  -- clean up vim-highlighter
  local ok, _ = pcall(vim.fn.HiList)
  if ok then
    local Hilist = vim.fn.HiList()
    if Hilist and #Hilist > 0 then
      vim.cmd "Hi -"
    end
  end

  RUtils.cmp.actions.snippet_stop()
end, { desc = "Misc: redraw / clear hlsearch / diff update" })

--stylua: ignore
RUtils.map.nnoremap("*", function() local word = vim.fn.expand "<cword>" vim.fn.setreg("/", "\\v" .. word) vim.o.hlsearch = true end, { remap = true, desc = "Misc: search word under cursor (no jump)" })
--stylua: ignore
RUtils.map.nnoremap("dd", function() if vim.fn.getline "." == "" then return '"_dd' end return "dd" end, { expr = true })
RUtils.map.xnoremap("<C-g>", [[<Esc>/\v%V]]) --search within visual selection - `very magic`
RUtils.map.nnoremap("<C-g>", "/\\v", nosilent) -- with `very magic`
RUtils.map.nnoremap("~", "%", { desc = "Misc: go to.. matching tag" })
RUtils.map.nnoremap("g,", "g,zvzz", silent) -- go last edit
RUtils.map.nnoremap("g;", "g;zvzz", silent) -- go prev edit

RUtils.map.xnoremap(">", ">gv", { desc = "Misc: next align lines (visual)" })
RUtils.map.xnoremap("<", "<gv", { desc = "Misc: prev align lines (visual)" })
RUtils.map.nnoremap("vv", [[^vg_]], { desc = "Misc: select text lines" })

--stylua: ignore
RUtils.map.nnoremap("<Leader>cd", function() local filepath = fn.expand "%:p:h" vim.cmd(fmt("cd %s", filepath)) vim.notify(fmt("ROOT CHANGED: %s", filepath)) end, { desc = "Action: cd to file" })
--stylua: ignore
RUtils.map.nnoremap("<Leader>cy", function() local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or "" vim.fn.setreg("+", path) vim.notify(path, vim.log.levels.INFO, { title = "Copy current path" }) end, { silent = true, desc = "Action: copy path buffer" })
RUtils.map.nnoremap("<Leader>xP", function()
  local cwd = vim.fn.expand "%:p:h"
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  ---@diagnostic disable-next-line: undefined-field
  RUtils.info(cwd .. "/" .. fname, { title = "Current path" })
end, { desc = "Cmd: printout current path" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                  COMMANDS                                   ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

RUtils.create_command("Snippets", RUtils.cmd.edit_snippet, { desc = "Misc: edit snippet file" })
RUtils.create_command("ChangeMasterTheme", RUtils.cmd.change_colors, { desc = "Misc: set theme bspwm" })

--stylua: ignore
RUtils.create_command("InfoOption", function() vim.cmd "options" end, { desc = "Misc: echo options" })
--stylua: ignore
RUtils.create_command("ImgInsert", RUtils.maim.insert, { desc = "Misc: echo options" })
--stylua: ignore
RUtils.create_command("E", function() return cmd [[ vnew ]] end, { desc = "Misc: vnew" })

--stylua: ignore
vim.api.nvim_create_user_command("LspLog", function() vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename())) end, { desc = "Show LSP client log" })
--stylua: ignore
vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Show LSP info" })

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

local ctrl_o_nvim = function()
  RUtils.fzflua.open_cmd_bulk_key_only({
    ["Clock mode"] = function()
      RUtils.terminal.clock_mode()
    end,
    ["Pomodoro 1h"] = function()
      RUtils.terminal.clock_mode { pomodoro = { timer = "1h" } }
    end,
    ["Pomodoro 25m"] = function()
      RUtils.terminal.clock_mode { pomodoro = { timer = "25m" } }
    end,
    ["Pomodoro 10m"] = function()
      RUtils.terminal.clock_mode { pomodoro = { timer = "10m" } }
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
    ["TestNotify - runt tess notification"] = function()
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
    ["Treesitter - open inspert tree under cursor"] = function()
      vim.treesitter.inspect_tree()
      vim.api.nvim_input "I"
    end,
  }

  if RUtils.has "candela.nvim" then
    cmds["Candela - add color for log highlights"] = function()
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
    ["Diffview - open DiffviewOpen"] = function()
      vim.cmd [[DiffviewOpen]]
    end,
    ["Diffview - open DiffviewFileHistory repo"] = function()
      vim.cmd [[DiffviewFileHistory]]
    end,
    ["Diffview - open DiffviewFileHistory curbuf"] = function()
      vim.cmd [[DiffviewFileHistory --follow %]]
    end,
    ["Diffview - open DiffviewFileHistory line"] = function()
      vim.cmd [[DiffviewFileHistory --follow]]
    end,
    ["Codediff - open VscodeDiff"] = function()
      vim.cmd [[VscodeDiff]]
    end,
    ["Diff - windo this"] = function()
      vim.cmd [[windo diffthis]]
    end,
    ["GH - open PR"] = function()
      vim.cmd [[GHOpenPR]]
    end,
    ["GH - open issue"] = function()
      vim.cmd [[GHOpenIssue]]
    end,
    ["GitWorktree - create"] = function()
      vim.cmd [[lua require("telescope").extensions.git_worktree.create_git_worktrees()]]
    end,
    ["GitWorktree - manage"] = function()
      vim.cmd [[lua require("telescope").extensions.git_worktree.git_worktrees()]]
    end,
    ["GitConflict - refresh"] = function()
      vim.cmd [[GitConflictRefresh]]
    end,
    ["GitConflict - send list to qf"] = function()
      vim.cmd [[GitConflictListQf]]
    end,
    ["GitConflict - choosing ours (current)"] = function()
      ---@diagnostic disable-next-line: undefined-field
      RUtils.info("Choosing ours (current)", { title = "GitConflict" })
      vim.cmd [[GitConflictChooseOurs]]
    end,
    ["GitConflict - choosing theirs (incoming)"] = function()
      ---@diagnostic disable-next-line: undefined-field
      RUtils.info("Choosing theirs (incoming)", { title = "GitConflict" })
      vim.cmd [[GitConflictChooseTheirs]]
    end,
    ["GitConflict - choosing none of them (deleted)"] = function()
      ---@diagnostic disable-next-line: undefined-field
      RUtils.info("Choosing none of them (deleted)", { title = "GitConflict" })
      vim.cmd [[GitConflictChooseNone]]
    end,
    ["GitSigns - show blame"] = function()
      local gs = package.loaded.gitsigns
      gs.blame()
    end,
    ["GitSigns - toggle diff changes"] = function()
      local gs = package.loaded.gitsigns
      gs.toggle_deleted()
    end,
    ["GitSigns - toggle word diff"] = function()
      local gs = package.loaded.gitsigns
      gs.toggle_word_diff()
    end,
  }, { winopts = { title = RUtils.fzflua.format_title("Git Commands", RUtils.config.icons.git.branch) } })
end

RUtils.map.nnoremap("<Leader>gF", bulk_cmd_git, { desc = "Bulk: git commands" })
RUtils.map.tnoremap("<Leader>gF", bulk_cmd_git, { desc = "Bulk: git commands" })
RUtils.map.xnoremap("<Leader>gF", bulk_cmd_git, { desc = "Bulk: git commands (visual)" })

local bulk_cmd_toggle = function()
  RUtils.fzflua.open_cmd_bulk_center({
    ["Layout - disable/enable layout sidebar size"] = function()
      RUtils.layout.disable()
    end,
    ["CCC - highlighter from ccc"] = function()
      vim.cmd.CccHighlighterToggle()
    end,
    ["Outline - disable/enable auto follow"] = function()
      vim.cmd.OutlineToggleFollow()
    end,
    ["highlighter - clear all"] = function()
      vim.cmd "Hi clear"
    end,
    ["Tresitter - disable/enable highlight"] = function()
      Snacks.toggle.treesitter()
    end,
  }, { winopts = { title = RUtils.fzflua.format_title("Toggle Commands", RUtils.config.icons.misc.tools) } })
end

RUtils.map.nnoremap("<Leader>uF", bulk_cmd_toggle, { desc = "Bulk: toggle commands" })
RUtils.map.tnoremap("<Leader>uF", bulk_cmd_toggle, { desc = "Bulk: toggle commands" })
RUtils.map.xnoremap("<Leader>uF", bulk_cmd_toggle, { desc = "Bulk: toggle commands (visual)" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                              TMUX INTEGRATION                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--stylua: ignore
RUtils.map.nnoremap("<a-B>", function() RUtils.terminal.float_btop() end, { desc = "CTRL_o: btop" })
--stylua: ignore
RUtils.map.tnoremap("<a-B>", function() RUtils.terminal.float_btop() end, { desc = "CTRL_o: btop (terminal)" })
--stylua: ignore
RUtils.map.nnoremap("<a-Z>", function() RUtils.terminal.float_resterm() end, { desc = "CTRL_o: resterm" })
--stylua: ignore
RUtils.map.tnoremap("<a-Z>", function() RUtils.terminal.float_resterm() end, { desc = "CTRL_o: resterm (terminal)" })
--stylua: ignore
RUtils.map.nnoremap("<a-C>", function() RUtils.terminal.float_rkill() end, { desc = "CTRL_o: rkill" })
--stylua: ignore
RUtils.map.tnoremap("<a-C>", function() RUtils.terminal.float_rkill() end, { desc = "CTRL_o: rkill (terminal)" })
--stylua: ignore
RUtils.map.nnoremap("<a-D>", function() RUtils.terminal.lazydocker() end, { desc = "CTRL_o: lazydocker" })
--stylua: ignore
RUtils.map.tnoremap("<a-D>", function() RUtils.terminal.lazydocker() end, { desc = "CTRL_o: lazydocker (terminal)" })
--stylua: ignore
RUtils.map.nnoremap("<a-G>", function() RUtils.terminal.lazygit() end, { desc = "CTRL_o: lazygit" })
--stylua: ignore
RUtils.map.tnoremap("<a-G>", function() RUtils.terminal.lazygit() end, { desc = "CTRL_o: lazygit (terminal)" })
--stylua: ignore
RUtils.map.nnoremap("<a-W>", function() RUtils.terminal.float_note() end, { desc = "CTRL_o: open notes" })
--stylua: ignore
RUtils.map.tnoremap("<a-W>", function() RUtils.terminal.float_note() end, { desc = "CTRL_o: open notes (terminal)" })

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
  if vim.g.main_layout == "default" then
    RUtils.layout.toggle_sidebar("neo-tree", function()
      vim.cmd "Neotree reveal focus"
    end)
    return
  end

  local dirname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":h:p")

  -- +-----------------------------------------------------------------------------+
  -- |                                   WEZTERM                                   |
  -- +-----------------------------------------------------------------------------+
  if not RUtils.tmux.is_tmux then
    if RUtils.tmux.is_terminal ~= "wezterm" then
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

  -- +-----------------------------------------------------------------------------+
  -- |                                    TMUX                                     |
  -- +-----------------------------------------------------------------------------+

  -- ─[ Resolve pane IDs ]─────────────────────────────────────────────

  local current_session = RUtils.tmux.tmux_cmd "tmux display-message -p '#S'"
  local current_window = RUtils.tmux.tmux_cmd "tmux display-message -p '#I'"
  if not current_session or not current_window then
    return
  end

  local file_manager_pane_id = RUtils.tmux.get_json_field(current_session, current_window, "file_manager_pane_id")

  if not file_manager_pane_id or not RUtils.tmux.is_pane_alive(file_manager_pane_id) then
    RUtils.warn "<a-E>: file_manager_pane_id not found or pane dead.\nRun tm-toggle-pane first to create the layout."
    return
  end

  -- ─[ Execute ]──────────────────────────────────────────────────────

  local proc = RUtils.tmux.get_pane_process(file_manager_pane_id)
  if proc == fm_manager then
    vim.system { "sh", "-c", "tmux send-keys -t " .. file_manager_pane_id .. " 'q' Enter" }
    RUtils.tmux.wait_for_process(file_manager_pane_id, fm_manager, true) -- tunggu sampai bukan fm_manager
  end

  proc = RUtils.tmux.get_pane_process(file_manager_pane_id)
  if proc == "nvim" then
    vim.system { "sh", "-c", "tmux send-keys -t " .. file_manager_pane_id .. " Escape ':qa!' Enter" }
    RUtils.tmux.wait_for_process(file_manager_pane_id, "nvim", true) -- tunggu sampai bukan nvim
  end

  vim.system {
    "sh",
    "-c",
    "tmux send-keys -t " .. file_manager_pane_id .. " '" .. fm_manager .. " " .. dirname .. "' Enter",
  }

  RUtils.tmux.wait_for_process(file_manager_pane_id, fm_manager, false)
  vim.system { "tmux", "select-pane", "-t", file_manager_pane_id }
end)
