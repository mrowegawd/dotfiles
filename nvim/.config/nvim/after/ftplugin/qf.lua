local keymap, api, opt = vim.keymap, vim.api, vim.opt_local
local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local builtin = require "fzf-lua.previewer.builtin"
local QFPreviewer = builtin.buffer_or_file:extend()

opt.buflisted = false
opt.winfixheight = true
opt.scrolloff = 2
opt.cursorline = true
opt.number = false
opt.relativenumber = false -- otherwise, show relative numbers in the ruler
opt.listchars:append "trail: "

-- these keys disabled
keymap.set("n", "<c-i>", "<Nop>", { buffer = api.nvim_get_current_buf() })
keymap.set("n", "<c-o>", "<Nop>", { buffer = api.nvim_get_current_buf() })

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
  local items = {}
  if RUtils.qf.is_loclist() then
    items = vim.tbl_map(function(item)
      return {
        filename = item.bufnr and vim.api.nvim_buf_get_name(item.bufnr),
        bufnr = item.bufnr,
        module = item.module,
        lnum = item.lnum,
        end_lnum = item.end_lnum,
        col = item.col,
        end_col = item.end_col,
        vcol = item.vcol,
        nr = item.nr,
        pattern = item.pattern,
        text = item.text,
        type = item.type,
        valid = item.valid,
      }
    end, vim.fn.getloclist(0))
  else
    items = vim.tbl_map(function(item)
      return {
        filename = item.bufnr and vim.api.nvim_buf_get_name(item.bufnr),
        bufnr = item.bufnr,
        module = item.module,
        lnum = item.lnum,
        -- end_lnum = item.end_lnum,
        col = item.col,
        -- end_col = item.end_col,
        -- vcol = item.vcol,
        -- nr = item.nr,
        -- pattern = item.pattern,
        text = item.text,
        type = item.type,
        -- valid = item.valid,
      }
    end, vim.fn.getqflist())
  end

  return items
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

      local filename = vim.api.nvim_buf_get_name(item.bufnr)

      -- buka lewat dgn tabnew
      -- vim.cmd("tabnew " .. filename)

      -- atau vertical split
      vim.cmd("vsp " .. filename)
    end
  end

  vim.cmd [[wincmd =]]
end, { buffer = vim.api.nvim_get_current_buf() })

keymap.set("n", "o", function()
  RUtils.map.feedkey("<CR>", "n")
  vim.schedule(function()
    local folded_line = vim.fn.foldclosed(vim.fn.line ".")
    if folded_line ~= -1 then
      vim.cmd "normal! zv" -- buka fold
    end
  end)
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: open item",
})

keymap.set("n", "<Leader>ff", function()
  local actions = require "fzf-lua.actions"
  local opts = {
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = {
      title = RUtils.fzflua.format_title(string.format("Select%s", __get_vars.title_list()), __get_vars.title_icon()),
    },
    actions = {
      ["alt-l"] = actions.file_sel_to_ll,
      ["alt-q"] = actions.file_sel_to_qf,
      ["ctrl-s"] = actions.git_buf_split,
      ["ctrl-t"] = actions.git_buf_tabedit,
      ["ctrl-v"] = actions.git_buf_vsplit,
    },
  }

  if RUtils.qf.is_loclist() then
    fzf_lua.loclist(opts)
  else
    fzf_lua.quickfix(opts)
  end
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: select items [fzflua]",
})

keymap.set("n", "<Leader>fg", function()
  local path = require "fzf-lua.path"
  local actions = require "fzf-lua.actions"

  local qf_items = vim.fn.getqflist()
  local title_ = "Grep" .. __get_vars.title_list()
  if RUtils.qf.is_loclist() then
    qf_items = vim.fn.getloclist(0)
  end

  local qf_ntbl = {}
  for _, qf_item in pairs(qf_items) do
    table.insert(qf_ntbl, path.normalize(vim.api.nvim_buf_get_name(qf_item.bufnr), vim.uv.cwd()))
  end

  local pcmd = [[rg --column --line-number -i --hidden --no-heading --color=always --smart-case ]]
    .. table.concat(qf_ntbl, " ")
    .. " -e "

  return fzf_lua.live_grep_glob {
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = { title = RUtils.fzflua.format_title(title_, __get_vars.title_icon()) },
    cmd = pcmd,
    actions = {
      ["ctrl-s"] = actions.git_buf_split,
      ["ctrl-v"] = actions.git_buf_vsplit,
      ["ctrl-t"] = actions.git_buf_tabedit,
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: live grep list of items [fzflua]",
})

keymap.set("n", "<a-l>", function()
  local qf_win = RUtils.cmd.windows_is_opened { "qf" }
  if qf_win.found then
    if RUtils.qf.is_loclist() then
      if qf_win.found then
        vim.cmd [[lclose]]
      end
      vim.cmd "Trouble loclist toggle focus=true"
    else
      vim.fn.setloclist(1, get_items_list())

      -- vim.fn.setloclist(0, {}, " ", {
      --   nr = "$",
      --   items = items,
      --   title = vim.fn.getqflist({ title = 0 }).title,
      -- })

      local _qf = RUtils.cmd.windows_is_opened { "qf" }
      if _qf.found then
        if RUtils.qf.is_loclist() then
          vim.cmd "lclose"
        else
          vim.cmd "cclose"
        end
      end

      vim.cmd(RUtils.cmd.quickfix.lopen)
    end
  end
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: convert loclist into trouble/qf",
})

keymap.set("n", "<a-q>", function()
  if RUtils.qf.is_loclist() then
    local _qf = RUtils.cmd.windows_is_opened { "qf" }
    if _qf.found then
      if RUtils.qf.is_loclist() then
        vim.cmd "lclose"
      else
        vim.cmd "cclose"
      end
    end

    local what = {
      idx = "$",
      items = get_items_list(),
      title = vim.fn.getloclist(0, { title = 0 }).title,
    }

    vim.fn.setqflist({}, "r", what)
    vim.cmd(RUtils.cmd.quickfix.copen)
  else
    local qf_win = RUtils.cmd.windows_is_opened { "qf" }
    if qf_win.found then
      vim.cmd [[cclose]]
    end
    vim.cmd "Trouble quickfix toggle focus=true"
  end
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: convert qf into trouble/lf",
})

keymap.set("n", "<Leader>fw", function()
  local items = get_items_list()
  local title = RUtils.qf.is_loclist() and vim.fn.getloclist(0, { title = 0 }).title
    or vim.fn.getqflist({ title = 0 }).title

  local _tbl = {}
  for _, x in pairs(items) do
    if #x.text == 0 then
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

  fzf_lua.fzf_exec(_tbl, {
    previewer = QFPreviewer,
    -- prompt = RUtils.fzflua.default_title_prompt(),
    winopts = {
      title = RUtils.fzflua.format_title(
        string.format("Grep%s Word >> %s", __get_vars.title_list(), title),
        __get_vars.title_icon()
      ),
    },
    -- fzf_opts = { ["--header"] = [[^x:addtag  ^g:grep  ^r:reload  ^f:greptitle  ^e:filtertag]] },
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
        vim.fn.setloclist(0, {}, " ", {
          nr = "$",
          items = send_data(selected),
          title = title .. "  " .. require("fzf-lua").config.__resume_data.last_query,
        })
        vim.cmd(RUtils.cmd.quickfix.lopen)
      end,
      ["alt-q"] = function(selected, _)
        local what = {
          idx = "$",
          items = send_data(selected),
          title = title .. "  " .. require("fzf-lua").config.__resume_data.last_query,
        }
        vim.fn.setqflist({}, " ", what)
        vim.cmd(RUtils.cmd.quickfix.copen)
      end,
    },
  })
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: grep text of items [fzflua]",
})
