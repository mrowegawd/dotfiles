local opt_local = vim.opt_local
local keymap = vim.keymap.set

opt_local.number = false
opt_local.relativenumber = false
opt_local.signcolumn = "no"
opt_local.buflisted = false
opt_local.conceallevel = 2
opt_local.list = false

local UtilKey = require "utils.map"
local Log = require "utils.log"

local function get_text(wrapper)
  -- local escaped = vim.pesc(wrapper)
  local escaped = "\\" .. wrapper
  return vim.fn.matchstr(vim.fn.expand "<cWORD>", ([[\v%s\zs.{-}\ze%s]]):format(escaped, escaped))
end

keymap("n", "<Leader>lD", function()
  local text = get_text "|"
  if text ~= "" then
    vim.cmd "normal! m'"
    local result = vim.fn.search([[\V\<]] .. vim.fn.escape(text, [[\]]) .. [[\>]])
    if result == 0 or result == nil then
      Log.warn("Tag |" .. text .. "| not found in this document!")
    end
  end
end, { desc = "Help: search |tag|", buffer = true })
keymap("n", "<Leader>ld", function()
  local text = get_text "*"
  if text ~= "" then
    vim.cmd "normal! m'"
    local result = vim.fn.search([[\V\<]] .. vim.fn.escape(text, [[\]]) .. [[\>]])
    if result == 0 or result == nil then
      Log.warn("Word *" .. text .. "* not found in this document!")
    end
  end
end, { desc = "Help: search *word*", buffer = true })

keymap("n", "gd", "<C-]>", { desc = "Help: goto definition", buffer = true })
keymap("n", "<BS>", "<C-t>", { desc = "Help: goback last definition", buffer = true })

keymap("n", "go", function()
  local success = pcall(vim.cmd, "normal! /'\\l\\{2,\\}'\r")
  if not success then
    return
  end
end, { buffer = true, silent = true })

keymap("n", "gO", function()
  local success = pcall(vim.cmd, "normal! ?'\\l\\{2,\\}'\r")
  if not success then
    return
  end
end, { buffer = true, silent = true })
