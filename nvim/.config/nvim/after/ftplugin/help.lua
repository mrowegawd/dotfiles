local keymap = vim.keymap.set

vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.signcolumn = "no"
vim.opt_local.buflisted = false
vim.opt_local.conceallevel = 2
vim.opt_local.list = false

-- local UtilKey = require "utils.map"
local Log = require "utils.log"

local function get_text(wrapper)
  -- local escaped = vim.pesc(wrapper)
  local escaped = "\\" .. wrapper
  return vim.fn.matchstr(vim.fn.expand "<cWORD>", ([[\v%s\zs.{-}\ze%s]]):format(escaped, escaped))
end

keymap("n", "gd", function()
  local text = get_text "|"
  if text ~= "" then
    vim.cmd "normal! m'"
    local result = vim.fn.search([[\V\<]] .. vim.fn.escape(text, [[\]]) .. [[\>]])
    if result == 0 or result == nil then
      Log.warn("Tag |" .. text .. "| not found in this document!")
    end
  end
end, { desc = "Help: search |tag|", buffer = true })
keymap("n", "gD", function()
  local text = get_text "*"
  if text ~= "" then
    vim.cmd "normal! m'"
    local result = vim.fn.search([[\V\<]] .. vim.fn.escape(text, [[\]]) .. [[\>]])
    if result == 0 or result == nil then
      Log.warn("Word *" .. text .. "* not found in this document!")
    end
  end
end, { desc = "Help: search *word*", buffer = true })

keymap("n", "<Leader>ld", "<C-]>", { desc = "Help: go to definition", buffer = true })
keymap("n", "<BS>", "<C-t>", { desc = "Help: go back last definition", buffer = true })

keymap("n", "go", function()
  pcall(function()
    vim.cmd "normal! /'\\l\\{2,\\}'\r"
  end)
end, { buffer = true, silent = true })

keymap("n", "gO", function()
  pcall(function()
    vim.cmd "normal! ?'\\l\\{2,\\}'\r"
  end)
end, { buffer = true, silent = true })
