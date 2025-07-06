local keymap, api, opt = vim.keymap, vim.api, vim.opt_local
local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

opt.buflisted = false
opt.winfixheight = true
opt.cursorline = true
opt.listchars:append "trail: "

keymap.set("n", "<c-i>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

keymap.set("n", "<c-o>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

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
  -- vim.cmd [[wincmd p]]
  -- vim.cmd [[cc]]

  vim.schedule(function()
    local folded_line = vim.fn.foldclosed(vim.fn.line ".")
    if folded_line ~= -1 then
      -- vim.cmd [[normal! zO]]
      vim.cmd "normal! zv" -- buka fold
    end
  end)
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: open item",
})

keymap.set("n", "<Leader>ff", function()
  local actions = require "fzf-lua.actions"
  fzf_lua.quickfix {
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = { title = RUtils.fzflua.format_title("[QF] Select List", "󰈙") },
    actions = {
      ["ctrl-s"] = actions.git_buf_split,
      ["ctrl-v"] = actions.git_buf_vsplit,
      ["ctrl-q"] = actions.file_sel_to_qf,
      ["ctrl-t"] = actions.git_buf_tabedit,
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: select items [fzflua]",
})

keymap.set("n", "<Leader>fg", function()
  local path = require "fzf-lua.path"
  local actions = require "fzf-lua.actions"
  local qf_items = vim.fn.getqflist()

  local qf_ntbl = {}
  for _, qf_item in pairs(qf_items) do
    table.insert(qf_ntbl, path.normalize(vim.api.nvim_buf_get_name(qf_item.bufnr), vim.uv.cwd()))
  end

  local pcmd = [[rg --column --line-number -i --hidden --no-heading --color=always --smart-case ]]
    .. table.concat(qf_ntbl, " ")
    .. " -e "

  return fzf_lua.live_grep_glob {
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = { title = RUtils.fzflua.format_title("[QF] Grep", "") },
    cmd = pcmd,
    actions = {
      ["ctrl-s"] = actions.git_buf_split,
      ["ctrl-v"] = actions.git_buf_vsplit,
      ["ctrl-q"] = actions.file_sel_to_qf,
      ["ctrl-t"] = actions.git_buf_tabedit,
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: live grep items [fzflua]",
})
