local keymap, api, opt = vim.keymap, vim.api, vim.opt_local

local builtin = require "fzf-lua.previewer.builtin"
local QFPreviewer = builtin.buffer_or_file:extend()

opt.winfixheight = true
opt.scrolloff = 2
opt.number = false
opt.relativenumber = false -- otherwise, show relative numbers in the ruler
opt.listchars:append "trail: "
opt.buflisted = false

-- These keys are disabled
keymap.set("n", "<c-i>", "<Nop>", { buffer = api.nvim_get_current_buf() })
keymap.set("n", "<c-o>", "<Nop>", { buffer = api.nvim_get_current_buf() })

local fzf_lua = function()
  return RUtils.cmd.reqcall "fzf-lua"
end

-- Func untuk mengatasi error `no room enaough` saat open split/vsplit pada qf item,
-- jadi dibutuhkan expand window height jika itu terjadi.
local open_split_or_vsplit = function(vsp_or_sp)
  if vim.bo.buftype ~= "quickfix" then
    vim.notify("Sorry, you are not in the qf window!", vim.log.levels.WARN)
    return
  end

  local increase_by_multiple = 3
  local is_split = vsp_or_sp == "split"
  -- local split_or_vsplit = is_split and "aboveleft split" or "topleft vsplit"

  local qf_win = api.nvim_get_current_win()
  local original_height = api.nvim_win_get_height(qf_win)

  if original_height < 50 then
    if original_height == 2 or original_height == 1 then
      original_height = 6
    end
    api.nvim_win_set_height(qf_win, original_height * increase_by_multiple)
  end

  if is_split then
    RUtils.map.feedkey("<C-W><CR>", "n")
  else
    RUtils.map.feedkey("<C-W><CR><C-W>Lzz", "n")
  end

  -- Ensure that it returns to the original QF height
  vim.defer_fn(function()
    if api.nvim_win_is_valid(qf_win) then
      api.nvim_win_set_height(qf_win, original_height)
    end
  end, 10)
end

keymap.set("n", "<C-s>", function()
  open_split_or_vsplit "split"
end, { buffer = api.nvim_get_current_buf() })

keymap.set("n", "<Leader>ws", function()
  open_split_or_vsplit "split"
end, { buffer = api.nvim_get_current_buf() })

keymap.set("n", "<C-v>", function()
  open_split_or_vsplit "vsplit"
end, { buffer = api.nvim_get_current_buf() })

keymap.set("n", "<Leader>wv", function()
  open_split_or_vsplit "vsplit"
end, { buffer = api.nvim_get_current_buf() })

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

vim.keymap.set("v", "<c-v>", function()
  local items = get_items_list()

  -- local from, to = vim.fn.line ".", vim.fn.line "v"
  local from, to = vim.fn.line ".", vim.fn.line "v"
  if from > to then
    from, to = to, from
  end

  for i = from, to do
    local item = items[i]
    if item then
      vim.cmd [[wincmd p]]

      local filename = item.filename

      -- buka lewat dgn tabnew
      -- vim.cmd("tabnew " .. filename)

      -- atau vertical split
      vim.cmd("vsp " .. filename)
    end
  end

  vim.cmd [[wincmd =]]
end, { buffer = vim.api.nvim_get_current_buf() })

keymap.set("n", "o", function()
  if RUtils.qf.is_loclist() then
    RUtils.map.feedkey("<CR>", "n")
    vim.schedule(function()
      local folded_line = vim.fn.foldclosed(vim.fn.line ".")
      if folded_line ~= -1 then
        vim.cmd "normal! zvzz" -- buka fold
        return
      end
      vim.cmd "normal! zz"
    end)
    return
  end

  RUtils.fold.handle_qf_open(true, "only", true)
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: open item",
})

-- keymap.set("n", "<CR>", function()
--   RUtils.map.feedkey("<CR>", "n")
--   vim.schedule(function()
--     local folded_line = vim.fn.foldclosed(vim.fn.line ".")
--     if folded_line ~= -1 then
--       vim.cmd "normal! zvzz" -- buka fold
--       return
--     end
--     vim.cmd "normal! zz"
--   end)
-- end, {
--   buffer = api.nvim_get_current_buf(),
--   desc = "QF: open item",
-- })

keymap.set("n", "<Leader>ff", function()
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
      ["ctrl-s"] = actions.git_buf_split,
      ["ctrl-t"] = actions.git_buf_tabedit,
      ["ctrl-v"] = actions.git_buf_vsplit,
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

  qf_ntbl = RUtils.cmd.rm_duplicates_tbl(qf_ntbl)

  local rg_opts_format = [[--column --line-number -i --hidden --no-heading --color=always --smart-case ]]
    .. table.concat(qf_ntbl, " ")
    .. " -e "

  return fzf_lua().live_grep {
    -- debug = true,
    winopts = { title = RUtils.fzflua.format_title(title_, __get_vars.title_icon()) },
    rg_opts = rg_opts_format,
    actions = {
      -- ["ctrl-s"] = actions.git_buf_split,
      -- ["ctrl-v"] = actions.git_buf_vsplit,
      -- ["ctrl-t"] = actions.git_buf_tabedit,

      ["ctrl-s"] = actions.buf_split,
      ["ctrl-v"] = actions.buf_vsplit,
      ["ctrl-t"] = actions.buf_tabedit,
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: live grep list of items [fzflua]",
})

keymap.set("n", "L", function()
  local _qf = RUtils.cmd.windows_is_opened { "qf" }
  if _qf.found then
    if not RUtils.qf.is_loclist() then
      vim.cmd "cclose"
      local title = RUtils.qf.get_title_qf()
      local results = RUtils.qf.get_data_qf()
      if #results.quickfix.items > 0 then
        RUtils.qf.save_to_qf_and_auto_open_qf(results.quickfix.items, title, true)
      end
      return
    end
    vim.cmd "lclose"
  end
  vim.cmd "Trouble loclist toggle focus=true"
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: convert loclist into trouble or quickfix",
})

keymap.set("n", "Q", function()
  local _qf = RUtils.cmd.windows_is_opened { "qf" }
  if _qf.found then
    if RUtils.qf.is_loclist() then
      vim.cmd "lclose"
      local title = RUtils.qf.get_title_qf(true)
      local results = RUtils.qf.get_data_qf(true)
      if #results.location.items > 0 then
        RUtils.qf.save_to_qf_and_auto_open_qf(results.location.items, title)
      end
      return
    end
    vim.cmd "cclose"
  end
  vim.cmd "Trouble quickfix toggle focus=true"
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: convert qf into trouble or loclist",
})

keymap.set("n", "<Leader>fw", function()
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
      -- prompt = RUtils.fzflua.padding_prompt(),
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
        ["alt-l"] = function(selected, _)
          title = title .. "  " .. require("fzf-lua").config.__resume_data.last_query
          RUtils.qf.save_to_qf_and_auto_open_qf(send_data(selected), title, true)
        end,
        ["alt-q"] = function(selected, _)
          title = title .. "  " .. require("fzf-lua").config.__resume_data.last_query
          RUtils.qf.save_to_qf_and_auto_open_qf(send_data(selected), title)
        end,
      },
    }
  )
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: grep text of items [fzflua]",
})

-- Autocmds
vim.api.nvim_create_autocmd({ "QuitPre", "BufDelete" }, {
  group = vim.api.nvim_create_augroup("ft_qf", { clear = true }),
  callback = function()
    -- Automatically close corresponding loclist when quitting a window
    if vim.bo.filetype ~= "qf" then
      vim.cmd "silent! lclose"
    end
  end,
})
