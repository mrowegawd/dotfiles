local keymap, api, opt = vim.keymap, vim.api, vim.opt_local

local builtin = require "fzf-lua.previewer.builtin"
local QFPreviewer = builtin.buffer_or_file:extend()

opt.winfixheight = true
opt.scrolloff = 2
opt.number = false
opt.relativenumber = false -- otherwise, show relative numbers in the ruler
opt.listchars:append "trail: "
opt.buflisted = false
opt.list = false

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
