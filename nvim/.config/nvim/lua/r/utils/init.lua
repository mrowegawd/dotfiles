local api, highlight, fmt, cmd = vim.api, as.highlight, string.format, vim.cmd
local option = api.nvim_get_option_value

local icons = as.ui.icons
local L = vim.log.levels

local utils = {}

local Job = require "plenary.job"
local scan = require "plenary.scandir"

--  ╭──────────────────────────────────────────────────────────╮
--  │                         GENERAL                                    │
--  ╰──────────────────────────────────────────────────────────╯
local vi = false
function utils.toggle_vi()
  if vi then
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.signcolumn = "yes" -- 'auto'
    vim.o.foldcolumn = "auto:1"
    vim.o.laststatus = 2
    -- if vim.b.hasLsp then
    --     vim.cmd.DefaultDiagnostics()
    -- end
    vim.cmd.IndentBlanklineToggle()

    vi = false
  else
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.signcolumn = "no"
    vim.o.foldcolumn = "0"
    vim.o.laststatus = 0
    -- if vim.b.hasLsp then
    --     vim.cmd.DisableDiagnostics()
    -- end
    vim.cmd.IndentBlanklineToggle()
    vi = true
  end
end

local function is_vim_list_open()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = vim.fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == "qf" or is_loc_list then
      return true
    end
  end
  return false
end

-- Usage: toggle_list "quickfix" or "location"
local function toggle_list(list_type, kill)
  if kill then
    return cmd [[q]]
  end

  local is_location_target = list_type == "location"
  local cmd_ = is_location_target and { "lclose", "lopen" } or { "cclose", "copen" }
  local is_open = is_vim_list_open()
  if is_open then
    return vim.cmd[cmd_[1]]()
  end
  local list = is_location_target and vim.fn.getloclist(0) or vim.fn.getqflist()
  if vim.tbl_isempty(list) then
    local msg_prefix = (is_location_target and "Location" or "QuickFix")
    return vim.notify(msg_prefix .. " List is Empty.", vim.log.levels.WARN)
  end

  local winnr = vim.fn.winnr()
  cmd[cmd_[2]]()
  if vim.fn.winnr() ~= winnr then
    cmd.wincmd "p"
  end
end

function utils.toggle_qf()
  toggle_list "quickfix"
end

function utils.toggle_loc()
  toggle_list "location"
end

function utils.toggle_kil_loc_qf()
  toggle_list("none", true)
end

function utils.foldtext()
  local ret = vim.treesitter.foldtext and vim.treesitter.foldtext()
  if not ret then
    ret = { { vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1], {} } }
  end
  ---@diagnostic disable-next-line: param-type-mismatch
  table.insert(ret, { " " .. icons.misc.dots })
  return ret
end

--- Opens the given url in the default browser.
---@param url string: The url to open.
function utils.open_in_browser(url)
  local open_cmd
  if vim.fn.executable "xdg-open" == 1 then
    open_cmd = "xdg-open"
  elseif vim.fn.executable "explorer" == 1 then
    open_cmd = "explorer"
  elseif vim.fn.executable "open" == 1 then
    open_cmd = "open"
  elseif vim.fn.executable "wslview" == 1 then
    open_cmd = "wslview"
  end

  local ret = vim.fn.jobstart({ open_cmd, url }, { detach = true })
  if ret <= 0 then
    vim.notify(
      string.format("[utils]: Failed to open '%s'\nwith command: '%s' (ret: '%d')", url, open_cmd, ret),
      vim.log.levels.ERROR,
      { title = "[tt.utils]" }
    )
  end
end

function utils.Buf_only()
  local del_non_modifiable = vim.g.bufonly_delete_non_modifiable or false

  local cur = api.nvim_get_current_buf()

  local deleted, modified = 0, 0

  for _, n in ipairs(api.nvim_list_bufs()) do
    -- If the iter buffer is modified one, then don't do anything
    ---@diagnostic disable-next-line: redundant-parameter
    if option("modified", { buf = n }) then
      modified = modified + 1

      -- iter is not equal to current buffer
      -- iter is modifiable or del_non_modifiable == true
      -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
      ---@diagnostic disable-next-line: redundant-parameter
    elseif n ~= cur and (option("modifiable", { buf = n }) or del_non_modifiable) then
      api.nvim_buf_delete(n, {})
      deleted = deleted + 1
    end
  end

  vim.notify("BufOnly: " .. deleted .. " deleted buffer(s), " .. modified .. " modified buffer(s)")
end

---Write current file and source it within current nvim instance
---@param buf number Bufner to attach mapping to
function utils.write_and_source(buf)
  vim.keymap.set("n", "<F6>", function()
    vim.cmd.write()
    vim.cmd.source "%"
    vim.notify "Sourcing..."
  end, { buffer = buf, desc = "Evaluate current file" })
end

---Get keys with replaced termcodes
---@param key string key sequence
---@param mode string vim-mode for the keymap
function utils.feedkey(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

function utils.disable_ctrl_i_and_o(au_name, tbl_ft)
  local augroup = vim.api.nvim_create_augroup(au_name, { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = tbl_ft,
    group = augroup,
    callback = function()
      vim.keymap.set("n", "<c-i>", "<Nop>", {
        buffer = vim.api.nvim_get_current_buf(),
      })
      vim.keymap.set("n", "<c-o>", "<Nop>", {
        buffer = vim.api.nvim_get_current_buf(),
      })
    end,
  })
end

function utils.smart_quit()
  local bufnr = api.nvim_get_current_buf()
  ---@diagnostic disable-next-line: param-type-mismatch
  local buf_windows = vim.call("win_findbuf", bufnr)

  ---@diagnostic disable-next-line: redundant-parameter
  local modified = option("modified", { buf = bufnr })
  if modified and #buf_windows == 1 then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd "qa!"
      end
    end)
  else
    vim.cmd "q"
  end
end

function utils.infoBaseColorsTheme()
  local normal = "Normal"
  local colorcolumn = "ColorColumn"

  local pmenu = "Pmenu"
  local pmenusel = "PmenuSel"

  local winseparator = "WinSeparator"
  local winseparatorCUS = "WinSeparatorCUS"

  local cmpmatchabbr = "CmpItemAbbrMatch"
  local cmpitemabbr = "CmpItemAbbr"
  local cmpitemabbrmatchfuzzy = "CmpItemAbbrMatchFuzzy"

  local normal_bg = highlight.get(normal, "bg")
  local normal_fg = highlight.get(normal, "fg")

  local colorcolumn_bg = highlight.get(colorcolumn, "bg")

  local pmenu_bg = highlight.get(pmenu, "bg")
  local pmenu_fg = highlight.get(pmenu, "fg")

  local pmenusel_bg = highlight.get(pmenusel, "bg")

  local winseparator_fg = highlight.get(winseparator, "fg")
  local winseparator_bg = highlight.get(winseparatorCUS, "fg")

  local cmpmatchabbr_fg = highlight.get(cmpmatchabbr, "fg")
  local cmpitemabbr_fg = highlight.get(cmpitemabbr, "fg")

  local cmpmatchabbrfuzzy_fg = highlight.get(cmpitemabbrmatchfuzzy, "fg")

  print(
    fmt(
      [[
BG_ACTIVE_WINDOW (Normal) bg: %s
BG_ACTIVE_WINDOW (Normal) fg: %s

BACKGROUND_ACTIVE_STATUSLINE (ColorColumn) bg: %s

FZF_BG (Pmenu) bg: %s
FZF_FG (Pmenu) fg: %s

FZF_BG_SELECTION (PmenuSel) bg: %s

ACTIVE_FOREGROUND_WINSEPARATOR (WinSeparator) fg: %s
FOREGROUND_WINSEPARATOR (WinSeparator) bg: %s

FZF_BG_MATCH (CmpItemAbbrMatch) fg: %s
FZF_FG_ITEM (CmpItemAbbr) fg: %s
FZF_FG_ITEM_FUZZY (CmpItemAbbrMatchFuzzy) fg: %s ]],
      normal_bg,
      normal_fg,
      colorcolumn_bg,
      pmenu_bg,
      pmenu_fg,
      pmenusel_bg,
      winseparator_fg,
      winseparator_bg,
      cmpmatchabbr_fg,
      cmpitemabbr_fg,
      cmpmatchabbrfuzzy_fg
    )
  )
end

function utils.infoFoldPreview()
  vim.cmd "options"
end

function utils.testfunc()
  -- for _, winid in pairs(api.nvim_tabpage_list_wins(0)) do
  --   local winbufnr = fn.winbufnr(api.nvim_win_get_number(winid))
  --
  --   if winbufnr > 0 then
  --     print(winbufnr)
  --     -- print(api.nvim_win_get_option(winbufnr, "filetype"))
  --     --   local winft = api.nvim_buf_get_option(winbufnr, "filetype")
  --     --   print(winft)
  --   end
  -- end

  local ignore_filetypes = { "gitcommit", "gitrebase", "alpha", "norg", "org", "orgmode" }

  for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(bufnr) == 1 then
      if vim.tbl_contains(ignore_filetypes, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
        vim.api.nvim_buf_delete(bufnr, {})
      end
    end
  end
end

function utils.toggle_background()
  vim.go.background = vim.go.background == "light" and "dark" or "light"
  vim.notify(string.format("background=%s", vim.go.background))
end

function utils.icon(sign, len)
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(" ", len - vim.fn.strchars(text))
  return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

function utils.get_signs(buf, lnum)
  local signs = vim.tbl_map(function(sign)
    local ret = vim.fn.sign_getdefined(sign.name)[1]
    ret.priority = sign.priority
    return ret
  end, vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs)

  -- Get extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true, type = "sign" }
  )
  for _, extmark in pairs(extmarks) do
    signs[#signs + 1] = {
      name = extmark[4].sign_hl_group or "",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    }
  end

  -- Sort by priority
  table.sort(signs, function(a, b)
    return (a.priority or 0) < (b.priority or 0)
  end)

  return signs
end

function utils.get_mark(buf, lnum)
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match "[a-zA-Z]" then
      return { text = mark.mark:sub(2), texthl = "DiagnosticHint" }
    end
  end
end

function utils.statuscolumn()
  local win = vim.g.statusline_winid
  if vim.wo[win].signcolumn == "no" then
    return ""
  end
  local buf = vim.api.nvim_win_get_buf(win)

  local left, right, fold
  for _, s in ipairs(utils.get_signs(buf, vim.v.lnum)) do
    if s.name and s.name:find "GitSign" then
      right = s
    elseif not left then
      left = s
    end
  end

  vim.api.nvim_win_call(win, function()
    if vim.fn.foldclosed(vim.v.lnum) >= 0 then
      fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded" }
    end
  end)

  local nu = ""
  if vim.wo[win].number and vim.v.virtnum == 0 then
    nu = vim.wo[win].relativenumber and vim.v.relnum ~= 0 and vim.v.relnum or vim.v.lnum
  end

  return table.concat({
    utils.icon(utils.get_mark(buf, vim.v.lnum) or left),
    [[%=]],
    nu .. " ",
    utils.icon(fold or right),
  }, "")
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                           GIT                            │
--  ╰──────────────────────────────────────────────────────────╯
function utils.GitRemoteSync()
  if not _G.GitStatus then
    _G.GitStatus = { ahead = 0, behind = 0, status = nil }
  end

  -- Fetch the remote repository
  local git_fetch = Job:new {
    command = "git",
    args = { "fetch" },
    on_start = function()
      _G.GitStatus.status = "pending"
    end,
    on_exit = function()
      _G.GitStatus.status = "done"
    end,
  }

  -- Compare local repository to upstream
  local git_upstream = Job:new {
    command = "git",
    args = { "rev-list", "--left-right", "--count", "HEAD...@{upstream}" },
    on_start = function()
      _G.GitStatus.status = "pending"
      vim.schedule(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "GitStatusChanged" })
      end)
    end,
    on_exit = function(job, _)
      local res = job:result()[1]
      if type(res) ~= "string" then
        _G.GitStatus = { ahead = 0, behind = 0, status = "error" }
        return
      end
      local _, ahead, behind = pcall(string.match, res, "(%d+)%s*(%d+)")

      _G.GitStatus = {
        ahead = tonumber(ahead),
        behind = tonumber(behind),
        status = "done",
      }
      vim.schedule(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "GitStatusChanged" })
      end)
    end,
  }

  git_fetch:start()
  git_upstream:start()
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                      WORD PROCESSOR                      │
--  ╰──────────────────────────────────────────────────────────╯

function utils.WordProcessor()
  vim.wo.wrap = true
  vim.wo.linebreak = true
  vim.bo.expandtab = true
  vim.opt_local.spell = true
  vim.opt_local.complete:append "k"
  vim.opt_local.spelllang = { "en_us", "en_gb" }
  -- vim.o.thesaurus = vim.env.XDG_CONFIG_HOME .. "/nvim/thesaurus/mthesaur.txt"
  require("r.mappings.util").wordProcessor()
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                      PLUGINS STUFF                       │
--  ╰──────────────────────────────────────────────────────────╯

function utils.EditOrgTodo()
  local org_todos = { "inbox", "refile" }
  local org_todo_path = as.wiki_path .. "/orgmode/gtd/"

  vim.ui.select(org_todos, { prompt = "Edit OrgTODO's> " }, function(choice)
    if choice == nil then
      return
    end

    if not as.exists(org_todo_path .. choice .. ".org") then
      return vim.notify("Cant find todo path: " .. org_todo_path .. choice .. ".org", L.WARN, { title = "Todo info" })
    end
    cmd(":edit " .. org_todo_path .. choice .. ".org")
  end)
end

function utils.EditSnippet()
  local base_snippets = { "package", "global" }

  local ft, _ = as.get_bo_buft()

  if ft == "" then
    return vim.notify("Belum dibuat??", L.WARN, { title = "No snippets" })
  elseif ft == "typescript" then
    ft = "javascript"
  elseif ft == "sh" then
    ft = "shell"
  end

  local ft_snippet_path = as.snippet_path .. "/snippets/"

  local snippets = {}
  local is_file = true

  if as.is_dir(ft_snippet_path .. ft) then
    if not as.exists(ft_snippet_path .. ft) then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end
    -- Untuk akses ke snippet khusus dir harus di tambahkan ext sama `ft` nya
    -- e.g path/ft-nya/<snippet.json>
    ft_snippet_path = ft_snippet_path .. ft .. "/"

    local dirs = scan.scan_dir(ft_snippet_path, { depth = 1, search_pattern = "json" })
    for _, sp in pairs(dirs) do
      local nm = sp:match "[^/]*.json$"
      local sp_e = nm:gsub(".json", "")
      table.insert(snippets, sp_e)
    end

    for _, sp in pairs(base_snippets) do
      table.insert(snippets, sp)
    end
  else
    snippets = { ft }

    if not as.exists(ft_snippet_path .. ft .. ".json") then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end
    if not as.exists(ft_snippet_path .. ft .. ".json") then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end

    for _, sp in pairs(base_snippets) do
      table.insert(snippets, sp)
    end
  end

  vim.ui.select(snippets, { prompt = "Edit snippet> " }, function(choice)
    if choice == nil then
      return
    end
    if is_file then
      if not as.exists(ft_snippet_path .. choice .. ".json") then
        return vim.notify(ft_snippet_path .. choice .. ".json", L.WARN, { title = "Snippet file not exists" })
      end
      cmd(":edit " .. ft_snippet_path .. choice .. ".json")
    end
  end)
end

function utils.ufo_handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0

  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end

  table.insert(newVirtText, { suffix, "MoreMsg" })

  return newVirtText
end

local text = require "nui.text"
local select = require "nui.menu"
local event = require("nui.utils.autocmd").event

local format_select_entries = function(entries, formatter)
  local formatItem = formatter or tostring
  local results = {
    select.separator("", {
      char = " ",
    }),
  }
  for _, entry in pairs(entries) do
    table.insert(results, select.item(string.format("%s", formatItem(entry))))
  end
  return results
end

local calculate_select_width = function(entries, prompt)
  local result = 6
  for _, entry in pairs(entries) do
    if #entry.text + 6 > result then
      result = #entry.text + 6
    end
  end
  if #prompt ~= nil then
    if #prompt + 6 > result then
      result = #prompt + 6
    end
  end
  return result + 6
end

local concat = function(t1, t2)
  for i = 1, #t2 do
    table.insert(t1, t2[i])
  end
  return t1
end

local is_array = function(t)
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end
  return true
end

local merge = function(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      if is_array(t1[k]) then
        t1[k] = concat(t1[k], v)
      else
        merge(t1[k], t2[k])
      end
    else
      t1[k] = v
    end
  end
  return t1
end

utils.select = function(entries, stuff, opts)
  local formatted_entries = format_select_entries(entries, stuff.format_item)
  local default_opts = {
    relative = "editor",
    position = "50%",
    size = {
      width = calculate_select_width(formatted_entries, stuff.prompt or "Choice:"),
      height = #formatted_entries,
    },
    border = {
      highlight = "FloatBorder:Pmenu",
      style = { " ", " ", " ", " ", " ", " ", " ", " " },
      text = {
        top = text(stuff.prompt or "Choice:", "FloatBorder"),
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal",
    },
  }
  opts = merge(default_opts, opts)
  return {
    opts = opts,
    formatted_entries = formatted_entries,
  }
end

local reference = nil

function utils.nui_select(opts, on_choice)
  local userChoice = function(choiceIndex)
    on_choice(choiceIndex["text"])
  end
  reference = select(opts.opts, {
    lines = opts.formatted_entries,
    on_close = function()
      reference = nil
    end,
    on_submit = function(item)
      userChoice(item)
      reference = nil
    end,
  })
  pcall(function()
    reference:mount()
    reference:on(event.BufLeave, reference.menu_props.on_close, { once = true })
  end)
end

function utils.ConvertNorgToMarkdown()
  local fname = vim.fn.expand "%:t:r"
  local pname = vim.fn.expand "%:p:h"

  local msg_cmd = "Neorg export to-file " .. pname .. "/" .. fname .. ".md"

  vim.cmd(msg_cmd)
end

--  ╔══════════════════════════════════════════════════════════╗
--  ║ Taken from nvim-ufo                                      ║
--  ╚══════════════════════════════════════════════════════════╝

---@param winid number
---@param f fun(): any
---@return any
local function winCall(winid, f)
  if winid == 0 or winid == api.nvim_get_current_win() then
    return f()
  else
    return api.nvim_win_call(winid, f)
  end
end

---@param winid number
---@param lnum number
---@return number
local function foldClosed(winid, lnum)
  return winCall(winid, function()
    return vim.fn.foldclosed(lnum)
  end)
end

function utils.goPreviousClosedFold()
  local count = vim.v.count1
  local curLnum = api.nvim_win_get_cursor(0)[1]
  local cnt = 0
  local lnum
  for i = curLnum - 1, 1, -1 do
    if foldClosed(0, i) == i then
      cnt = cnt + 1
      lnum = i
      if cnt == count then
        break
      end
    end
  end
  if lnum then
    cmd "norm! m`"
    api.nvim_win_set_cursor(0, { lnum, 0 })
  else
    cmd "norm! zk"
  end
end

function utils.goNextClosedFold()
  local count = vim.v.count1
  local curLnum = api.nvim_win_get_cursor(0)[1]
  local lineCount = api.nvim_buf_line_count(0)
  local cnt = 0
  local lnum
  for i = curLnum + 1, lineCount do
    if foldClosed(0, i) == i then
      cnt = cnt + 1
      lnum = i
      if cnt == count then
        break
      end
    end
  end
  if lnum then
    cmd "norm! m`"
    api.nvim_win_set_cursor(0, { lnum, 0 })
  else
    cmd "norm! zj"
  end
end

return utils
