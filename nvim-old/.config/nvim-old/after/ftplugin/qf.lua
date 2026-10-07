local keymap, api, opt = vim.keymap, vim.api, vim.opt_local

local builtin = require "fzf-lua.previewer.builtin"
local QFPreviewer = builtin.buffer_or_file:extend()

vim.opt_local.winfixheight = true
vim.opt_local.scrolloff = 2
opt.listchars:append "trail: "
vim.opt_local.buflisted = false
vim.opt_local.list = false

-- These keys are disabled
keymap.set("n", "<c-i>", "<Nop>", { buffer = api.nvim_get_current_buf() })
keymap.set("n", "<c-o>", "<Nop>", { buffer = api.nvim_get_current_buf() })

local fzf_lua = function()
  return RUtils.cmd.reqcall "fzf-lua"
end

local __get_vars = {
  title_list = function()
    if RUtils.qf.is_loclist() then
      return "LF"
    end
    return "QF"
  end,
  title_icon = function()
    if RUtils.qf.is_loclist() then
      return " "
    end
    return ""
  end,
}
local get_items_list = function()
  if RUtils.qf.is_loclist() then
    local results = RUtils.qf.get_data_qf(true)
    return results.location.items
  end

  local results = RUtils.qf.get_data_qf()
  return results.quickfix.items
end

keymap.set("n", "<Leader><Leader>", function()
  local actions = require "fzf-lua.actions"
  local opts = {
    winopts = {
      title = RUtils.fzflua.format_title(string.format("Select%s", __get_vars.title_list()), __get_vars.title_icon()),
    },
    actions = {
      ["alt-l"] = actions.file_sel_to_ll,
      ["alt-L"] = {
        prefix = "toggle-all",
        fn = actions.file_sel_to_ll,
      },
      ["alt-q"] = actions.file_sel_to_qf,
      ["alt-Q"] = {
        prefix = "toggle-all",
        fn = actions.file_sel_to_qf,
      },

      ["ctrl-s"] = actions.buf_split,
      ["ctrl-v"] = actions.buf_vsplit,
      ["ctrl-t"] = actions.buf_tabedit,
    },
  }

  if RUtils.qf.is_loclist() then
    fzf_lua().loclist(opts)
  else
    fzf_lua().quickfix(opts)
  end
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: select items [fzflua]",
})

keymap.set("n", "<Leader>fg", function()
  local path = require "fzf-lua.path"
  local actions = require "fzf-lua.actions"

  local qf_items = get_items_list()
  local title_ = "Grep" .. __get_vars.title_list()

  local qf_ntbl = {}
  for _, qf_item in pairs(qf_items) do
    local fname = qf_item.filename
    if
      not fname:match "%.png$"
      and not fname:match "%.jpeg$"
      and not fname:match "%.gif$"
      and not fname:match "%.jpg$"
      and not fname:match "%.spl$"
      and not fname:match "%.csv$"
      and not fname:match "%.add$"
      and not fname:match "%.sug$"
    then
      table.insert(qf_ntbl, path.normalize(fname, vim.uv.cwd()))
    end
  end

  qf_ntbl = RUtils.remove_duplicates_table(qf_ntbl)

  local rg_opts_format = [[--column --line-number -i --hidden --no-heading --color=always --smart-case ]]
    .. table.concat(qf_ntbl, " ")
    .. " -e "

  return fzf_lua().live_grep {
    winopts = { title = RUtils.fzflua.format_title(title_, __get_vars.title_icon()) },
    rg_opts = rg_opts_format,
    actions = {
      ["ctrl-s"] = actions.buf_split,
      ["ctrl-v"] = actions.buf_vsplit,
      ["ctrl-t"] = actions.buf_tabedit,
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: live grep list of items [fzflua]",
})

keymap.set("n", "<Leader>fG", function()
  local items = get_items_list()
  local title = RUtils.qf.is_loclist() and RUtils.qf.get_title_qf(true) or RUtils.qf.get_title_qf()

  local _tbl = {}
  for _, x in pairs(items) do
    if #x.text == 0 then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.warn("No text, abort", { title = "QF" })
      return
    end
    _tbl[#_tbl + 1] = x.text
  end

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

  fzf_lua().fzf_exec(
    _tbl,
    RUtils.fzflua.open_dock_bottom {
      previewer = QFPreviewer,
      winopts = {
        title = RUtils.fzflua.format_title(
          string.format("Grep%s Word >> %s", __get_vars.title_list(), title),
          __get_vars.title_icon()
        ),
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
          local Fzflua = RUtils.fzflua.setup_fzflua()
          title = title .. "  " .. Fzflua.config.__resume_data.last_query
          local list_items = { items = send_data(selected), title = title }
          RUtils.qf.save_to_qf_and_auto_open_qf(list_items, true)
        end,
        ["alt-q"] = function(selected, _)
          local Fzflua = RUtils.fzflua.setup_fzflua()
          title = title .. "  " .. Fzflua.config.__resume_data.last_query
          local list_items = { items = send_data(selected), title = title }
          RUtils.qf.save_to_qf_and_auto_open_qf(list_items)
        end,
      },
    }
  )
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: grep text of items [fzflua]",
})

-- Autocmds
-- vim.api.nvim_create_autocmd({ "QuitPre", "BufDelete" }, {
--   group = vim.api.nvim_create_augroup("ft_qf", { clear = true }),
--   callback = function()
--     -- Automatically close corresponding loclist when quitting a window
--     if vim.bo.filetype ~= "qf" then
--       vim.cmd "silent! lclose"
--     end
--   end,
-- })

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
      vim.notify(
        "QfSort: field tidak dikenal: " .. tostring(name) .. " (pakai: file, line, col, text, type)",
        vim.log.levels.ERROR
      )
      return nil
    end
    table.insert(specs, { name = name, desc = (dir == "desc") })
  end
  return specs
end

vim.api.nvim_create_user_command("QfReindentBlock", function()
  local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, false, true)
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

  vim.cmd("cdo normal! gg" .. ctrl_v .. "G=" .. esc)
  vim.cmd "cdo update"
  vim.api.nvim_feedkeys(esc, "n", false)
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
    vim.notify("QfSort: perlu argumen f=<field>, contoh: :QfSort f=file,line", vim.log.levels.ERROR)
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
    vim.notify("Quickfix kosong.", vim.log.levels.WARN)
    return
  end

  vim.cmd("vimgrep /\\%>70c./ " .. table.concat(files, " "))
end, { desc = "Cari baris >70 karakter di semua file unik dari quickfix saat ini" })
