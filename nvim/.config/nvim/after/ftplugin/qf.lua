local keymap, api = vim.keymap, vim.api

local opt = vim.opt_local

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

keymap.set("n", "o", function()
  RUtils.map.feedkey("<CR>", "n")
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "Qf: open item",
})

keymap.set("n", "<Leader>fq", function()
  require("fzf-lua").quickfix {
    prompt = "  ",
    winopts = {
      title = RUtils.fzflua.format_title("[QF] Select item list", "󰈙"),
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "Qf: select items [fzflua]",
})

keymap.set("n", "<Leader>fg", function()
  local path = require "fzf-lua.path"
  local qf_items = vim.fn.getqflist()

  local qf_ntbl = {}
  for _, qf_item in pairs(qf_items) do
    table.insert(qf_ntbl, path.normalize(vim.api.nvim_buf_get_name(qf_item.bufnr), vim.uv.cwd()))
  end

  local pcmd = [[rg --column --line-number -i --hidden --no-heading --color=always --smart-case ]]
    .. table.concat(qf_ntbl, " ")
    .. " -e "

  return require("fzf-lua").live_grep_glob {
    prompt = "  ",
    winopts = { title = RUtils.fzflua.format_title("[QF] Grep item lists", " ") },
    cmd = pcmd,
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "Qf: live grep items [fzflua]",
})

local function expose_items_qf(t)
  t = t or "split"

  local items = vim.fn.getqflist()
  local total_expose_item = 5

  vim.cmd "wincmd p"
  vim.cmd "cclose"
  -- local total_items = #items
  for i, item in pairs(items) do
    local filename = vim.api.nvim_buf_get_name(item.bufnr)
    if t == "tab" then
      vim.cmd("tabnew " .. filename)
      local lnum = tonumber(item.lnum)
      local line_count = vim.api.nvim_buf_line_count(item.bufnr)
      if lnum > 0 and line_count > lnum then
        vim.api.nvim_win_set_cursor(0, { lnum, tonumber(item.col) or 0 })
      end
    else
      if tonumber(i) <= (total_expose_item - 1) then
        vim.cmd(t .. " " .. filename)
        local lnum = tonumber(item.lnum)
        local line_count = vim.api.nvim_buf_line_count(item.bufnr)
        if lnum > 0 and line_count > lnum then
          vim.api.nvim_win_set_cursor(0, { lnum, tonumber(item.col) or 0 })
        end
      end
    end
  end

  if #items > total_expose_item and (t ~= "tab") then
    local number_expose = total_expose_item - 1
    RUtils.info(
      "too many items, only expose " .. number_expose .. " from the total(" .. tostring(#items) .. ")",
      { title = "QF" }
    )
    RUtils.map.feedkey("<c-w>=", "n")
  end
end

keymap.set("n", "<Leader>wl", function()
  expose_items_qf()
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "Qf: open items qf with stack window",
})

keymap.set("n", "<Leader>s", function()
  vim.cmd [[cclose]]
  vim.cmd [[Trouble quickfix]]
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "Qf: open in trouble",
})

keymap.set("n", "<Leader>wL", function()
  expose_items_qf "tab"
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "Qf: open items qf with tab window",
})
