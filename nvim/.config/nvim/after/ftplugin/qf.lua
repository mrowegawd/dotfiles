local keymap, api, opt, wo, bo = vim.keymap, vim.api, vim.opt_local, vim.wo, vim.bo

wo.winfixheight = true
wo.scrolloff = 2
opt.listchars:append "trail: "
bo.buflisted = false
wo.list = false

vim.cmd.packadd "cfilter"

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"
local UtilQf = lazy "utils.qf"

local Log = lazy "utils.log"

local Fzflua = lazy "fzf-lua"
local FzfActions = lazy "fzf-lua.actions"
local WhichKey = lazy "which-key"

local mappings = {
  { "<C-c>F", group = "filter:cdo/cfdo/Cfilter/Dedupe" },
  { "<C-c>x", group = "exec" },
}
WhichKey.add(mappings)

-- `setup_trouble` helps load `trouble.nvim` upon entering the quickfix window.
-- Previously loaded via `UIEvent`; heavy plugins are optimized/cleared during
-- specific events to maintain performance.
vim.schedule(function()
  lazy("vim-pack").load_now "trouble.nvim"
end)

-- These keys are disabled
keymap.set("n", "<C-i>", "<Nop>", { buffer = api.nvim_get_current_buf() })
keymap.set("n", "<C-o>", "<Nop>", { buffer = api.nvim_get_current_buf() })
keymap.set("n", "K", "<Nop>", { buffer = api.nvim_get_current_buf() })

local __get_vars = {
  title_list = function()
    if UtilQf.is_loclist() then
      return "LF"
    end
    return "QF"
  end,
  title_icon = function()
    if UtilQf.is_loclist() then
      return " "
    end
    return ""
  end,
}
local get_items_list = function()
  if UtilQf.is_loclist() then
    local results = UtilQf.get_data_qf(true)
    return results.location.items
  end

  local results = UtilQf.get_data_qf()
  return results.quickfix.items
end

local function find_edit_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "" then
      return win
    end
  end
end
local function edit_at_line_col(selected, opts)
  local path = lazy "fzf-lua.path"

  if #selected > 1 then
    return FzfActions.file_sel_to_qf(selected, opts)
  end

  local entry = path.entry_to_file(selected[1], opts)

  local win = find_edit_win()
  if win then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd "topleft split"
  end

  vim.cmd("edit " .. vim.fn.fnameescape(entry.path))

  if entry.line and entry.line > 0 then
    pcall(vim.api.nvim_win_set_cursor, 0, { entry.line, math.max((entry.col or 1) - 1, 0) })
    vim.cmd "normal! zvzz"
  end
end

local function peek_item_qf()
  local cursor_lnum = vim.api.nvim_win_get_cursor(0)[1]
  local is_loc = UtilQf.is_loclist()
  local qflist = UtilQf.get_list_qf(is_loc)
  local item = qflist.items[cursor_lnum]

  lazy("overlook.window").open_popup {
    target_bufnr = item.bufnr,
    lnum = item.lnum,
    col = item.col,
    title = vim.fn.bufname(item.bufnr),
  }
end

UtilKey.nnoremap("<Leader>cpp", function()
  lazy("vim-pack").load_now "overlook.nvim"
  peek_item_qf()
end, { desc = "Action: peek qf item [overlook.nvim]", buffer = api.nvim_get_current_buf(), force = true })
UtilKey.nnoremap("P", function()
  lazy("vim-pack").load_now "overlook.nvim"
  peek_item_qf()
end, { desc = "Action: peek qf item [overlook.nvim]", buffer = api.nvim_get_current_buf(), force = true })

UtilKey.nnoremap("<Leader>ff", function()
  local opts = {
    actions = {
      ["default"] = edit_at_line_col,
      ["ctrl-s"] = FzfActions.file_split,
      ["ctrl-v"] = FzfActions.file_vsplit,
      ["ctrl-t"] = FzfActions.file_tabedit,
      ["alt-q"] = {
        prefix = "select-all",
        fn = function(selected, opts)
          FzfActions.file_sel_to_qf(selected, opts)
        end,
      },
    },
  }

  if UtilQf.is_loclist() then
    Fzflua.loclist(opts)
  else
    Fzflua.quickfix(opts)
  end
end, { desc = "QF: select items [fzflua]", buffer = api.nvim_get_current_buf(), force = true })

UtilKey.nnoremap("<Leader>fg", function()
  local qf_items = get_items_list()
  local qf_files = {}
  local excluded_ext = {
    png = true,
    jpeg = true,
    gif = true,
    jpg = true,
    spl = true,
    csv = true,
    add = true,
    sug = true,
  }

  for _, item in ipairs(qf_items) do
    local fname = item.filename

    if (not fname or fname == "") and item.bufnr and item.bufnr > 0 then
      fname = vim.api.nvim_buf_get_name(item.bufnr)
    end

    if fname and fname ~= "" then
      fname = vim.fn.fnamemodify(vim.fn.expand(fname), ":p")

      local ext = fname:match "%.([^./]+)$"
      ext = ext and ext:lower() or nil

      if vim.fn.filereadable(fname) == 1 and (not ext or not excluded_ext[ext]) then
        qf_files[#qf_files + 1] = fname
      end
    end
  end

  if #qf_files == 0 then
    Log.warn "Quickfix list has no searchable files"
    return
  end

  local cmd = lazy "utils.cmd"
  qf_files = cmd.remove_duplicates_table(qf_files)

  local escaped = {}
  for _, f in ipairs(qf_files) do
    escaped[#escaped + 1] = vim.fn.shellescape(f)
  end

  local rg_opts_format = [[--with-filename --column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
    .. table.concat(escaped, " ")
    .. " -e "

  Fzflua.live_grep {
    rg_opts = rg_opts_format,
    actions = {
      ["default"] = edit_at_line_col,
      ["ctrl-s"] = FzfActions.file_split,
      ["ctrl-v"] = FzfActions.file_vsplit,
      ["ctrl-t"] = FzfActions.file_tabedit,
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: live grep list of items [fzflua]",
  force = true,
})

UtilKey.nnoremap("<Leader>fG", function()
  local items = get_items_list()
  local title = UtilQf.is_loclist() and UtilQf.get_title_qf(true) or UtilQf.get_title_qf()

  local _tbl = {}
  for _, x in pairs(items) do
    if #x.text == 0 then
      Log.warn "No text, abort"
      return
    end
    _tbl[#_tbl + 1] = x.text
  end

  local builtin = lazy "fzf-lua.previewer.builtin"
  local QFPreviewer = builtin.buffer_or_file:extend()

  function QFPreviewer:new(o, opts, fzf_win)
    QFPreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, QFPreviewer)
    return self
  end

  function QFPreviewer:parse_entry(entry_str)
    local data = {}
    for _, x in pairs(items) do
      if x.text == entry_str then
        data = {
          path = x.filename,
          line = x.lnum,
          col = x.col,
        }
      end
    end

    if data then
      return data
    end
    return {}
  end

  local send_data = function(selected)
    selected = selected or {}
    local data = {}
    for _, _sel in pairs(selected) do
      for _, item in pairs(items) do
        if item.text == _sel then
          data[#data + 1] = item
        end
      end
    end
    return data
  end

  Fzflua.fzf_exec(_tbl, {
    previewer = QFPreviewer,
    winopts = {
      title = string.format("Grep%s Word >> %s", __get_vars.title_list(), title),
    },
    actions = {
      ["default"] = function(selected, _)
        local sel
        if #selected == 1 then
          sel = selected[1]
          for _, x in pairs(items) do
            if x.text == sel then
              vim.cmd("e " .. x.filename)
              vim.api.nvim_win_set_cursor(0, { x.lnum, x.col })
              vim.cmd "normal! zz"
            end
          end
        end
      end,
      ["ctrl-v"] = function(selected, _)
        local sel
        if #selected == 1 then
          sel = selected[1]
          for _, x in pairs(items) do
            if x.text == sel then
              vim.cmd("vsplit " .. x.filename)
              vim.api.nvim_win_set_cursor(0, { x.lnum, x.col })
              vim.cmd "normal! zz"
            end
          end
        end
      end,
      ["ctrl-s"] = function(selected, _)
        local sel
        if #selected == 1 then
          sel = selected[1]
          for _, x in pairs(items) do
            if x.text == sel then
              vim.cmd("split " .. x.filename)
              vim.api.nvim_win_set_cursor(0, { x.lnum, x.col })
              vim.cmd "normal! zz"
            end
          end
        end
      end,
      ["alt-v"] = function(selected, _)
        title = title .. "  " .. Fzflua.config.__resume_data.last_query
        local list_items = { items = send_data(selected), title = title }
        UtilQf.save_to_qf_and_auto_open_qf(list_items, true)
      end,
      ["alt-q"] = function(selected, _)
        title = title .. "  " .. Fzflua.config.__resume_data.last_query
        local list_items = { items = send_data(selected), title = title }
        UtilQf.save_to_qf_and_auto_open_qf(list_items)
      end,
    },
  })
end, { buffer = api.nvim_get_current_buf(), desc = "QF: grep text of items [fzflua]", force = true })

-- ============================================================
-- QfSort — sort quickfix list berdasarkan field
-- Usage:
-- :QfSort f=file
-- :QfSort f=line
-- :QfSort f=text
-- :QfSort f=file,line              " sort bertingkat: file dulu, lalu line
-- :QfSort f=line:desc              " urutan terbalik
-- ============================================================

local qf_fields = {
  file = function(item)
    return vim.fn.bufname(item.bufnr)
  end,
  line = function(item)
    return item.lnum
  end,
  col = function(item)
    return item.col
  end,
  text = function(item)
    return item.text
  end,
  type = function(item)
    return item.type
  end,
}

local function parse_field_arg(raw)
  -- raw contoh: "file,line:desc"
  local specs = {}
  for part in raw:gmatch "[^,]+" do
    local name, dir = part:match "^([%w_]+):?(%a*)$"
    name = name or part
    if not qf_fields[name] then
      Log.error("QfSort: field tidak dikenal: " .. tostring(name) .. " (pakai: file, line, col, text, type)")
      return nil
    end
    table.insert(specs, { name = name, desc = (dir == "desc") })
  end
  return specs
end

vim.api.nvim_create_user_command("QfReindentBlock", function()
  local seen, files = {}, {}
  for _, item in ipairs(vim.fn.getqflist()) do
    if item.bufnr > 0 then
      local name = vim.api.nvim_buf_get_name(item.bufnr)
      if name ~= "" and not seen[name] then
        seen[name] = true
        files[#files + 1] = name
      end
    end
  end

  if #files == 0 then
    Log.warn "Quickfix is empty"
    return
  end

  local origin = vim.api.nvim_get_current_buf()

  for _, name in ipairs(files) do
    -- `edit` memicu ftdetect/ftplugin, jadi filetype dan indentexpr org terpasang
    vim.cmd("silent! hide edit " .. vim.fn.fnameescape(name))

    if vim.bo.filetype == "org" then
      lazy("org.indent").indent_region(0, 1, vim.api.nvim_buf_line_count(0))
    else
      vim.cmd "silent keepjumps normal! gg=G"
    end

    vim.cmd "silent update"
  end

  if vim.api.nvim_buf_is_valid(origin) then
    vim.api.nvim_set_current_buf(origin)
  end
  Log.info(("Reindent done: %d file"):format(#files))
end, {})

vim.api.nvim_create_user_command("QfSort", function(opts)
  local field_arg = nil
  for _, a in ipairs(opts.fargs) do
    local key, val = a:match "^(%a+)=(.+)$"
    if key == "f" then
      field_arg = val
    end
  end

  if not field_arg then
    Log.error "QfSort: perlu argumen f=<field>, contoh: :QfSort f=file,line"
    return
  end

  local specs = parse_field_arg(field_arg)
  if not specs then
    return
  end

  local qf = vim.fn.getqflist()
  table.sort(qf, function(a, b)
    for _, spec in ipairs(specs) do
      local get = qf_fields[spec.name]
      local va, vb = get(a), get(b)
      if va ~= vb then
        if spec.desc then
          return va > vb
        else
          return va < vb
        end
      end
    end
    return false
  end)

  vim.fn.setqflist(qf)
  vim.cmd "copen"
end, {
  nargs = "+",
  complete = function(_, cmdline)
    if cmdline:match "f=$" or cmdline:match "f=[^%s]*$" then
      return { "f=file", "f=line", "f=col", "f=text", "f=file,line", "f=line:desc" }
    end
    return {}
  end,
  desc = "Sort quickfix list. Usage: :QfSort f=file|line|col|text|type[:desc][,field2...]",
})

-- ============================================================
-- QfDedupe — hapus duplikat quickfix berdasarkan field
-- Usage:
--   :QfDedupe            " default: dedupe by file+line
--   :QfDedupe f=file      " dedupe cuma per file (1 entry per file)
--   :QfDedupe f=line      " dedupe cuma per line number
--   :QfDedupe f=file,line " sama seperti default, eksplisit
-- ============================================================

vim.api.nvim_create_user_command("QfDedupe", function(opts)
  local field_arg = "file,line"
  for _, a in ipairs(opts.fargs) do
    local key, val = a:match "^(%a+)=(.+)$"
    if key == "f" then
      field_arg = val
    end
  end

  local specs = parse_field_arg(field_arg)
  if not specs then
    return
  end

  local qf = vim.fn.getqflist()
  local seen = {}
  local out = {}

  for _, item in ipairs(qf) do
    local key_parts = {}
    for _, spec in ipairs(specs) do
      table.insert(key_parts, tostring(qf_fields[spec.name](item)))
    end
    local key = table.concat(key_parts, "\0")

    if not seen[key] then
      table.insert(out, item)
      seen[key] = true
    end
  end

  vim.fn.setqflist(out)
  vim.cmd "copen"
end, {
  nargs = "*",
  complete = function(_, cmdline)
    if cmdline:match "f=$" or cmdline:match "f=[^%s]*$" then
      return { "f=file", "f=line", "f=file,line", "f=text" }
    end
    return {}
  end,
  desc = "Dedupe quickfix list. Usage: :QfDedupe [f=file|line|file,line|text]",
})

vim.api.nvim_create_user_command("QfLongLines", function()
  local qf = vim.fn.getqflist()
  local seen, files = {}, {}

  for _, item in ipairs(qf) do
    local f = vim.fn.bufname(item.bufnr)
    if f ~= "" and not seen[f] then
      seen[f] = true
      table.insert(files, vim.fn.fnameescape(f))
    end
  end

  if #files == 0 then
    Log.warn "Quickfix is empty."
    return
  end

  vim.cmd("vimgrep /\\%>70c./ " .. table.concat(files, " "))
end, { desc = "Qf: Cari baris >70 karakter di semua file unik dari quickfix saat ini" })

UtilKey.nnoremap("<C-c>xl", "<CMD>QfLongLines<CR>", {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: collect long lines from qf items",
  force = true,
})

UtilKey.nnoremap("<C-c>xD", ":QfDedupe ", {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: check dedupe by filter f=file/line/file,line",
  force = true,
})

UtilKey.nnoremap("<C-c>xs", ":QfSort ", {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: short by filter f=file|line|col|text|type[:desc][,field2...]",
  force = true,
})
