local keymap, api = vim.keymap, vim.api

vim.opt_local.wrap = false

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

---@param mode "vsplit" | "split" | "none" | "tab"
---@param no_jump boolean?
local function open_item(mode, no_jump)
  no_jump = no_jump or false

  local inst = lazy("grug-far").get_instance(0)
  if not inst then
    return
  end

  local grug_win = api.nvim_get_current_win()

  local target_win = vim.fn.win_getid(vim.fn.winnr "#")

  if target_win == 0 or target_win == grug_win then
    return Log.warn "No previous window available"
  end

  api.nvim_set_current_win(target_win)

  if mode == "tab" then
    vim.cmd "tab split"
  elseif mode == "vsplit" then
    vim.cmd "vsplit"
  elseif mode == "split" then
    vim.cmd "split"
  end

  if no_jump then
    api.nvim_set_current_win(grug_win)
  end

  inst:open_location()
end

keymap.set("n", "<TAB>", function()
  open_item("none", true)
end, {
  buffer = api.nvim_get_current_buf(),
  silent = true,
  desc = "Open match (no jump)",
})

keymap.set("n", "o", function()
  open_item "none"
end, {
  buffer = api.nvim_get_current_buf(),
  silent = true,
  desc = "Open match",
})

keymap.set("n", "<Leader>ov", function()
  open_item "vsplit"
end, {
  buffer = api.nvim_get_current_buf(),
  silent = true,
  desc = "Open match in vsplit",
})

keymap.set("n", "<Leader>os", function()
  open_item "split"
end, {
  buffer = api.nvim_get_current_buf(),
  silent = true,
  desc = "Open match in split",
})

keymap.set("n", "<Leader>ot", function()
  open_item "tab"
end, {
  buffer = api.nvim_get_current_buf(),
  silent = true,
  desc = "Open match in current tab and send other matches to a new tab",
})
