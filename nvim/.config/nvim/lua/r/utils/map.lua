local map = vim.keymap.set

---@class r.utils.map
local M = {
  lsp = {},
}

---@alias ModeKey "n" | "i" | "x" | "o" | "v" | "t"

---@param mode ModeKey
---@param lhs string
---@param rhs string | function
---@param opts vim.keymap.set.Opts
local recursive_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  map(mode, lhs, rhs, opts)
end

local function count_spaces(input)
  local spaceCount = 0

  -- Iterasi setiap karakter dalam string
  for i = 1, #input do
    local char = input:sub(i, i)
    if char == " " then
      spaceCount = spaceCount + 1
    end
  end

  return spaceCount
end
M.show_help_buf_keymap = function()
  local Fzf = require "fzf-lua"

  local ft = vim.bo.filetype
  local tbl_maps_normal = vim.api.nvim_buf_get_keymap(0, "n")
  local tbl_maps_insert = vim.api.nvim_buf_get_keymap(0, "i")
  -- local tbl_maps_visual = vim.api.nvim_buf_get_keymap(0, "v")

  local function merge_multiple_tables(...)
    local result = {}
    for _, tbl in ipairs { ... } do
      for k, v in pairs(tbl) do
        result[k] = v
      end
    end
    return result
  end

  local tbl_maps = merge_multiple_tables(tbl_maps_normal, tbl_maps_insert)

  local col = {}

  for _, tbl in pairs(tbl_maps) do
    if tbl.desc == nil then -- remove nil desc
      tbl.desc = "<builtin>"
    end

    local c_spaces = count_spaces(tbl.lhs)

    local lhs = tbl.lhs
    if c_spaces > 0 then
      lhs = "<space>" .. RUtils.strip_whitespaces(tbl.lhs)
    end

    local mode_color = "GitSignsAdd"
    if tbl.mode == "i" then
      mode_color = "GitSignsChange"
    elseif tbl.mode == "v" then
      mode_color = "GitSignsDelete"
    end

    local mode = Fzf.utils.ansi_from_hl(mode_color, tbl.mode)
    local icon_separator = Fzf.utils.ansi_from_hl("Tabline", "|")
    local desc = Fzf.utils.ansi_from_hl(mode_color, tbl.desc)

    local map_desc = string.format("%-14s %s mode:%s %s %s", lhs, icon_separator, mode, icon_separator, desc)
    col[#col + 1] = map_desc
  end

  local opts = RUtils.fzflua.open_center_height_small_but_wide {
    winopts = { title = "Keymaps For Curbuf (" .. ft .. ")" },
    actions = {
      ["default"] = function(_, _)
        RUtils.info "Not implemented yet"
      end,
    },
  }

  -- sort alphabetically
  table.sort(col)

  return require("fzf-lua").fzf_exec(col, opts)
end

M.nmap = function(...)
  recursive_map("n", ...)
end
M.imap = function(...)
  recursive_map("i", ...)
end

M.vmap = function(...)
  recursive_map("v", ...)
end

local detect_duplicate_map = function(...)
  local args = { ... } -- Menyimpan argumen dalam sebuah table
  local key = args[1] -- Misalkan 'n' adalah default mode jika tidak ada argumen
  local key_alt = args[2] -- Mengambil argumen kedua sebagai key
  local opts = args[3] -- Mengambil argumen kedua sebagai key
  if opts and opts.unique == nil then
    -- if opts.desc then
    --   print(key .. " " .. opts.desc)
    -- end
    opts.unique = true
  end
  return key, key_alt, opts
end

M.nnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("n", key, key_alt, opts)
end
M.xnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("x", key, key_alt, opts)
end
M.vnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("v", key, key_alt, opts)
end
M.inoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("i", key, key_alt, opts)
end
M.onoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("o", key, key_alt, opts)
end
M.cnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("c", key, key_alt, opts)
end
M.tnoremap = function(...)
  local key, key_alt, opts = detect_duplicate_map(...)
  map("t", key, key_alt, opts)
end

M.cabbrev = function(short, long)
  vim.cmd.cnoreabbrev(short, long)
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ AUGROUP                                                 ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param callback function
---@param list table
---@param accum table
---@return table
function M.fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

---@param augroup_name string
---@param bufnr integer
function M.delete_augroup_name(augroup_name, bufnr)
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup_name, buffer = bufnr })
  if cmds_found then
    vim.tbl_map(function(cmd)
      vim.api.nvim_del_autocmd(cmd.id)
    end, cmds)
  end
end

local autocmd_keys = {
  "event",
  "buffer",
  "pattern",
  "desc",
  "command",
  "group",
  "once",
  "nested",
}

---@param name string
local function validate_autocmd(name, command)
  local incorrect = M.fold(function(accum, _, key)
    if not vim.tbl_contains(autocmd_keys, key) then
      table.insert(accum, key)
    end
    return accum
  end, command, {})

  if #incorrect > 0 then
    vim.schedule(function()
      local msg = "Incorrect keys: " .. table.concat(incorrect, ", ")
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.notify(msg, "error", { title = string.format("Autocmd: %s", name) })
    end)
  end
end

function M.augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, string.format("You must specify at least one autocommand for %s", name))
  local id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ MISC                                                    ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

function M.escape(text, additional_char)
  if not additional_char then
    additional_char = ""
  end
  return vim.fn.escape(text, "/" .. additional_char)
end

---@param key string
---@param mode? ModeKey
function M.feedkey(key, mode)
  mode = mode or "n"
  if mode == "" then
    mode = "n"
  end

  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  local tc = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(tc, mode, false)
end

---@param key string
function M.feedkey_with_no_escape(key)
  vim.api.nvim_feedkeys(key, "n", false)
end

---@param cmd string
function M.wrap_fold_cmd(cmd)
  local _, err = pcall(function()
    vim.cmd(cmd)
  end)
  if err and (string.match(err, "E490") or string.match(err, "No fold found")) then
    RUtils.warn "No fold found"
  end
end

---@param au_name string
---@param tbl_ft table<string>
function M.disable_ctrl_i_and_o(au_name, tbl_ft)
  M.augroup(au_name, {
    event = "FileType",
    pattern = tbl_ft,
    desc = "Disable mapping C-o and C-i",
    command = function()
      vim.keymap.set("n", "<c-i>", "<Nop>", {
        buffer = vim.api.nvim_get_current_buf(),
      })
      vim.keymap.set("n", "<c-o>", "<Nop>", {
        buffer = vim.api.nvim_get_current_buf(),
      })
    end,
  })
end

---@param is_next? boolean
function M.go_prev_or_next_buffer(is_next)
  is_next = is_next or false

  local cmd_msg

  if is_next then
    cmd_msg = "bnext"
  else
    cmd_msg = "bprev"
  end

  local is_buf_winfixbuf = vim.api.nvim_get_option_value("winfixbuf", { scope = "local" })
  if not is_buf_winfixbuf then
    vim.cmd(cmd_msg)
  else
    RUtils.warn("Cannot use " .. cmd_msg .. ", `winfixbuf` is enabled")
  end
end

---@param winid number
---@param f fun(): any
---@return any
local function win_call(winid, f)
  if winid == 0 or winid == vim.api.nvim_get_current_win() then
    return f()
  else
    return vim.api.nvim_win_call(winid, f)
  end
end

local ft_disabled = { "neo-tree", "aerial" }

---@param winid number
---@param lnum number
---@return number
local function fold_closed(winid, lnum)
  return win_call(winid, function()
    return vim.fn.foldclosed(lnum)
  end)
end

---@param is_jump_prev boolean
---@param is_toggle boolean
local function go_next_or_prev_folded_line(is_jump_prev, is_toggle)
  is_toggle = is_toggle or false
  local count = vim.v.count1
  local cnt = 0
  local lnum
  if is_jump_prev then
    local curLnum = vim.api.nvim_win_get_cursor(0)[1]
    for i = curLnum - 1, 1, -1 do
      if fold_closed(0, i) == i then
        cnt = cnt + 1
        lnum = i
        if cnt == count then
          break
        end
      end
    end

    if lnum then
      vim.cmd "norm! m`"
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })

      if is_toggle then
        if vim.fn.foldclosed(vim.fn.line ".") ~= -1 then
          vim.cmd "normal! zMzvzz"
        end
      end
    else
      vim.cmd "norm! zk"
    end
  else
    local curLnum = vim.api.nvim_win_get_cursor(0)[1]
    local lineCount = vim.api.nvim_buf_line_count(0)
    for i = curLnum + 1, lineCount do
      if fold_closed(0, i) == i then
        cnt = cnt + 1
        lnum = i
        if cnt == count then
          break
        end
      end
    end

    if lnum then
      vim.cmd "norm! m`"
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })

      if is_toggle then
        if vim.fn.foldclosed(vim.fn.line ".") ~= -1 then
          vim.cmd "normal! zMzvzz"
        end
      end
    else
      vim.cmd "norm! zj"
    end
  end
end

---@param is_jump_prev? boolean
function M.magic_jump(is_jump_prev)
  is_jump_prev = is_jump_prev or false

  if vim.tbl_contains(ft_disabled, vim.bo[0].filetype) then
    if is_jump_prev then
      return M.feedkey "<c-p>"
    end
    return M.feedkey "<c-n>"
  end

  if vim.wo.diff then
    if is_jump_prev then
      return M.feedkey "[c"
    else
      return M.feedkey "]c"
    end
  end

  if vim.bo.filetype == "http" then
    local ok, kulala = pcall(require, "kulala")
    if not ok then
      return
    end

    if is_jump_prev then
      return kulala.jump_prev()
    end

    return kulala.jump_next()
  end

  if vim.bo[0].filetype == "markdown" then
    if is_jump_prev then
      return RUtils.markdown.go_to_heading(nil, {})
    end
    return RUtils.markdown.go_to_heading(nil)
  end

  -- Execute next/prev fold
  go_next_or_prev_folded_line(is_jump_prev, false)
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ LSP                                                     ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param method string|string[]
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find "/" and method or "textDocument/" .. method
  local clients = vim.lsp.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    if client:supports_method(method) then
      return true
    end
  end
  return false
end

local function remove_duplicates_lsp(lsp_items)
  if (lsp_items.lsp_items and #lsp_items.items == 0) or not lsp_items.items then
    return lsp_items
  end

  local look_up = {}

  local function check_tbl_element(new_tbl, element_1, element_2, element_3, element_4)
    for _, x in pairs(new_tbl) do
      if x.text == element_1 and x.lnum == element_2 and x.col == element_3 and x.filename == element_4 then
        return true
      end
    end
    return false
  end

  for _, x in pairs(lsp_items.items) do
    if not check_tbl_element(look_up, x.text, x.lnum, x.col, x.filename) then
      table.insert(look_up, x)
    end
  end

  if #look_up > 0 then
    lsp_items.items = vim.deepcopy(look_up)
  end

  return lsp_items
end

---@return LazyKeysLsp[]
function M.resolve(buffer, spec_maps)
  local Keys = require "lazy.core.handler.keys"
  if not Keys.resolve then
    return {}
  end
  local spec = vim.tbl_extend("force", {}, spec_maps)
  local opts = RUtils.opts "nvim-lspconfig"
  if opts ~= nil then
    local clients = vim.lsp.get_clients { bufnr = buffer }
    for _, client in ipairs(clients) do
      if opts.servers ~= nil then
        local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
        vim.list_extend(spec, maps)
      end
    end
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer, spec_maps)
  local Keys = require "lazy.core.handler.keys"
  local keymaps = M.resolve(buffer, spec_maps)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      ---@cast opts snacks.keymap.set.Opts
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      if opts.unique == nil then
        opts.unique = true
      end
      map(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

---@param curpos { pos: integer, col: integer, line: string, buf: integer }
---@return string | nil
local function get_extracted_strings(curpos)
  local word_under_cursor

  -- Ambil karakter di posisi kursor (bisa nil kalau di ujung baris)
  local char_at_cursor = curpos.line:sub(curpos.col + 1, curpos.col + 1)

  -- Ambil bagian sebelum dan sesudah kursor
  local before = curpos.line:sub(1, curpos.col):match "[_%w%.:]+$"
  local after = curpos.line:sub(curpos.col + 1):match "^[%w_%.:]+" or ""

  -- Jika kursor berada di titik pemisah seperti '.', maka abaikan `after`
  if char_at_cursor == "." or char_at_cursor == ":" then
    word_under_cursor = before
  else
    word_under_cursor = (before or "") .. after
  end

  if not word_under_cursor or word_under_cursor == "" then
    RUtils.warn "No string found under cursor."
    return
  end

  return word_under_cursor
end

---@param items {bufnr: integer, filename: string, lnum:integer}
local function all_item_locations_equal(items)
  if #items == 0 then
    return false
  end
  for i = 2, #items do
    local item = items[i]
    if item.bufnr ~= items[1].bufnr or item.filename ~= items[1].filename or item.lnum ~= items[1].lnum then
      return false
    end
  end
  return true
end

---@param yield any
---@param open_mode? "vsplit" | "split" | "tabnew" | "none"
function M.lsp.wrap_location_method(yield, open_mode)
  open_mode = open_mode or "none"
  return function()
    local from = RUtils.get_curpos_under_cursor()
    if not from then
      return
    end

    local target_strings = get_extracted_strings(from)
    if not target_strings then
      return
    end

    yield {
      ---@param t vim.lsp.LocationOpts.OnList
      on_list = function(t)
        local curpos = RUtils.get_curpos_under_cursor()
        if not vim.deep_equal(from, curpos) then
          -- We have moved the cursor since fetching locations, so abort
          RUtils.warn("Request definition abort process,\nyour cursor postion has been changed!", { title = "LSP" })
          return
        end

        if open_mode ~= "none" then
          vim.cmd(open_mode)
        end

        RUtils.info("`" .. target_strings .. "`", { title = t.title })

        if all_item_locations_equal(t.items) then
          -- Mostly copied from neovim source
          local item = t.items[1]
          local b = item.bufnr or vim.fn.bufadd(item.filename)

          -- Save position in jumplist
          vim.cmd "normal! m'"
          -- Push a new item into tagstack
          local tagname = vim.fn.expand "<cword>"
          local tagstack = { { tagname = tagname, from = from } }
          local winid = vim.api.nvim_get_current_win()
          vim.fn.settagstack(vim.fn.win_getid(winid), { items = tagstack }, "t")

          vim.bo[b].buflisted = true
          vim.api.nvim_win_set_buf(winid, b)
          pcall(vim.api.nvim_win_set_cursor, winid, { item.lnum, item.col - 1 })
          vim._with({ win = winid }, function()
            -- Open folds under the cursor
            vim.cmd "normal! zv"
          end)
        else
          local items = t.items
          if #t.items == 3 or #t.items == 2 then
            if not vim.deep_equal(t.items[1], t.items[2]) then
              items[#items + 1] = t.items[1]
            end
          end

          local list_items = { items = items, title = t.title .. ": " .. target_strings, context = t.context }
          if t.context and type(t.context) == "string" then
            list_items["context"] = t.context
          end
          list_items = remove_duplicates_lsp(list_items)
          RUtils.qf.save_to_qf_and_auto_open_qf(list_items)
        end
      end,
    }
  end
end

function M.lsp.wrap_references_to_send_qf()
  local from = RUtils.get_curpos_under_cursor()
  if not from then
    return
  end

  local target_strings = get_extracted_strings(from)
  if not target_strings then
    return
  end

  vim.lsp.buf.references(nil, {
    on_list = function(t)
      local curpos = RUtils.get_curpos_under_cursor()

      -- if all_item_locations_equal(t.items) then
      if not vim.islist(t.items) or type(t.items) ~= "table" or #t.items == 0 then
        RUtils.warn("No results request references for `" .. from.line .. "`", { title = "LSP" })
        return
      end

      local qf_win = require("qfbookmark.utils").windows_is_opened "qf"
      if qf_win.found then
        pcall(vim.api.nvim_win_close, qf_win.winnr, true)
      end

      local items = t.items
      if #t.items == 3 or #t.items == 2 then
        if not vim.deep_equal(t.items[1], t.items[2]) then
          items[#items + 1] = t.items[1]
        end
      end

      RUtils.info("`" .. target_strings .. "`", { title = "LSP " .. t.title })

      -- RUtils.info(vim.inspect(t.context))
      -- Info ----- notify.info RUtils { method: textDocument/references, id: 13 }

      -- How to get
      -- getqflist({'all': 1})          " dapatkan semua field
      -- getqflist({'items': 1})        " hanya items
      -- getqflist({'context': 1})      " hanya context
      -- getqflist({'id': id, 'items': 1, 'context': 1}) " berdasarkan id tertentu
      --
      --
      -- Kalau kamu mau melihat context quickfix saat ini:
      -- vim.notify(vim.inspect(vim.fn.getqflist({ context = 1 }).context))
      --
      -- Kalau kamu mau melihat semua field (termasuk items, title, context, dll):
      -- vim.notify(vim.inspect(vim.fn.getqflist({ all = 1 })))
      --
      local set_jump = false

      if not vim.deep_equal(from, curpos) then
        if #t.items > 1 then
          local bufname = vim.api.nvim_buf_get_name(t.context.bufnr)
          vim.cmd("topleft vsplit " .. bufname)
          local win_id = vim.api.nvim_get_current_win()

          local target_width = 80

          -- Check current window width
          local cur_width = vim.api.nvim_win_get_width(win_id)
          if cur_width ~= target_width then
            vim.cmd "wincmd ="
            vim.api.nvim_win_set_width(win_id, target_width)
          end
        end
        set_jump = true
      end

      local list_items =
        { items = items, title = "LSP " .. t.title .. ": " .. RUtils.lstrip_whitespace(target_strings) }
      if t.context and type(t.context) == "table" then
        if t.context.method and t.context.bufnr then
          list_items["context"] = { name = t.context.method, bufnr = t.context.bufnr }
        end
      end

      list_items = remove_duplicates_lsp(list_items)
      RUtils.qf.save_to_qf_and_auto_open_qf(list_items)

      if vim.bo.filetype == "qf" then
        vim.cmd "wincmd p"
      end
      if set_jump then
        pcall(vim.api.nvim_win_set_cursor, 0, { from.pos, from.col - 1 })
        vim.cmd "normal! m'"
      end
    end,
  })
end

---@param next integer
---@param severity vim.diagnostic.Severity | nil
function M.lsp.diagnostic_goto(next, severity)
  local go = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, float = false, count = go }
  end
end

local is_set_toggle_words = false
function M.lsp.toggle_words()
  local notify_msg
  local is_enabled = Snacks.words.enabled

  if is_enabled and is_set_toggle_words then
    Snacks.words.disable()
    is_set_toggle_words = false
    notify_msg = "LSP Document Highlight: OFF"
  else
    Snacks.words.enable()
    is_set_toggle_words = true
    notify_msg = "LSP Document Highlight: ON"
  end
  RUtils.info(notify_msg)
end

return M
