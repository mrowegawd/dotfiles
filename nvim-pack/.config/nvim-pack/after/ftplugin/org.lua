local bo = vim.bo

bo.textwidth = 60
vim.opt_local.list = false

local UtilKey = require "utils.map"

UtilKey.nnoremap("<Leader>ri", function()
  vim.cmd.ImgInsert()
end, { desc = "Note: insert image", buffer = vim.api.nvim_get_current_buf(), remap = true }, true)

UtilKey.nnoremap("<Leader>rn", function()
  local opts = {
    winopts = {
      fullscreen = false,
      width = 0.60,
      height = 0.25,
      col = 0.50,
      row = 0.50,
    },
  }

  opts.actions = vim.tbl_extend("keep", {
    ["default"] = {
      fn = function(selected, _)
        local sel = selected[1]
        if sel then
          vim.cmd(sel)
        end
      end,
    },
  }, {})

  require("fzf-lua").fzf_exec({ "SnipRun", "ImgInsert" }, opts)
end, { desc = "Note: task runner", buffer = vim.api.nvim_get_current_buf(), remap = true }, true)
