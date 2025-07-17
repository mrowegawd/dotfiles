local keymap, api, opt = vim.keymap, vim.api, vim.opt_local
local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

opt.buflisted = false
opt.winfixheight = true
opt.cursorline = true
opt.number = false
opt.relativenumber = false -- otherwise, show relative numbers in the ruler
opt.listchars:append "trail: "

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
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "qf",
--   callback = function()
--     -- tandai ftplugin sudah di-handle agar tidak dijalankan lagi
--     RUtils.info "ini wyes"
--     vim.b.did_ftplugin = 1
--   end,
-- })

-- these keys disabled
keymap.set("n", "<c-i>", "<Nop>", { buffer = api.nvim_get_current_buf() })
keymap.set("n", "<c-o>", "<Nop>", { buffer = api.nvim_get_current_buf() })

vim.keymap.set("v", "<c-v>", function()
  local items = vim.fn.getqflist()
  if #items == 0 then
    print "qf item kosong"
    return
  end

  if not (vim.bo.filetype == "qf") then
    print "not qf window"
    return
  end

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
    winopts = { title = RUtils.fzflua.format_title("Select Quickfix", __get_vars.title_icon()) },
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
  desc = "QF: live grep items [fzflua]",
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
      ---@diagnostic disable-next-line: undefined-field
      RUtils.warn("Convert from qf into loclist failed\nNot implemented yet", { title = __get_vars.title_list() })

      local items = vim.tbl_map(function(item)
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

      vim.fn.setloclist(1, items)

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
  desc = "QF: convert loclist into trouble",
})

keymap.set("n", "<a-q>", function()
  local qf_win = RUtils.cmd.windows_is_opened { "qf" }
  if RUtils.qf.is_loclist() then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.info("convert loclist into qf", { title = __get_vars.title_list() })

    local items = vim.tbl_map(function(item)
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

    local what = {
      idx = "$",
      items = items,
      title = vim.fn.getloclist(0, { title = 0 }).title,
    }

    local _qf = RUtils.cmd.windows_is_opened { "qf" }
    if _qf.found then
      if RUtils.qf.is_loclist() then
        vim.cmd "lclose"
      else
        vim.cmd "cclose"
      end
    end

    vim.fn.setqflist({}, "r", what)
    vim.cmd(RUtils.cmd.quickfix.copen)
  else
    if qf_win.found then
      vim.cmd [[cclose]]
    end
    vim.cmd "Trouble quickfix toggle focus=true"
  end
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: convert qf into trouble",
})
