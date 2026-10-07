local keymap, api, wo = vim.keymap, vim.api, vim.wo

local UtilKey = require "utils.map"
local Log = require "utils.log"

wo.foldexpr = ""
vim.opt_local.foldmethod = "syntax"

keymap.set("n", "<Tab>", function()
  vim.schedule(function()
    local _, err = pcall(function()
      vim.fn.execute "normal! za"
    end)

    if err and (string.match(err, "E510") or string.match(err, "E490")) then
      local msg = string.format "No fold found"
      ---@diagnostic disable-next-line: undefined-field
      Log.warn(msg)
    end
  end)
end, { buffer = api.nvim_get_current_buf() })

UtilKey.nnoremap("<Leader>oe", "o", { buffer = api.nvim_get_current_buf(), remap = true }, true)
UtilKey.nnoremap("<Leader>ot", "O", { buffer = api.nvim_get_current_buf(), remap = true }, true)
UtilKey.nnoremap("<Leader>ov", "gO", { buffer = api.nvim_get_current_buf(), remap = true }, true)

UtilKey.nnoremap("<C-n>", ")", { buffer = api.nvim_get_current_buf(), remap = true }, true)
UtilKey.nnoremap("<C-p>", "(", { buffer = api.nvim_get_current_buf(), remap = true }, true)
