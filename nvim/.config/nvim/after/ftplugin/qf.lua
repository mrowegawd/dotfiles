local keymap, api = vim.keymap, vim.api

local opt = vim.opt_local

opt.buflisted = false
opt.winfixheight = true
opt.cursorline = true
-- opt.signcolumn = "yes"
opt.listchars:append "trail: "

-- Disable ctrl-i and ctrl-o
keymap.set("n", "<c-i>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})
keymap.set("n", "<c-o>", "<Nop>", {
  buffer = api.nvim_get_current_buf(),
})

RUtils.map.nnoremap("<leader>fq", function()
  require("fzf-lua").quickfix {
    prompt = "  ",
    winopts = {
      title = RUtils.fzflua.format_title("[QF] Select item list", "󰈙"),
    },
  }
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: select items [fzflua]",
})

RUtils.map.nnoremap("<leader>fg", function()
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
  desc = "QF: live grep items [fzflua]",
})

RUtils.map.nnoremap("o", function()
  RUtils.map.feedkey("<CR>", "n")
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: open item",
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
      vim.api.nvim_win_set_cursor(0, { tonumber(item.lnum), tonumber(item.col) })
    else
      if tonumber(i) <= (total_expose_item - 1) then
        vim.cmd(t .. " " .. filename)
        vim.api.nvim_win_set_cursor(0, { tonumber(item.lnum), tonumber(item.col) })
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

RUtils.map.nnoremap("<Leader>wl", function()
  expose_items_qf()
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: open items qf with stack window",
})

RUtils.map.nnoremap("<Leader>wL", function()
  expose_items_qf "tab"
end, {
  buffer = api.nvim_get_current_buf(),
  desc = "QF: open items qf with tab window",
})
