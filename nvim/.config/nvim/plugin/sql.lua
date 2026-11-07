local add = require("vim-pack").add
local on_plugin_update = require("vim-pack").on_plugin_update

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

add {
  { src = "MadKuntilanak/nui.nvim", setup = false },
  {
    src = "2giosangmitom/sqmeow.nvim",
    opts = {},
  },
  { src = "tpope/vim-dadbod", setup = false },
  {
    src = "kristijanhusak/vim-dadbod-ui",
    setup = false,
    on_setup = function()
      local data_path = vim.fn.stdpath "data"

      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      -- NOTE: The default behavior of auto-execution of queries on save is disabled
      -- this is useful when you have a big query that you don't want to run every time
      -- you save the file running those queries can crash neovim to run use the
      -- default keymap: <leader>S
      vim.g.db_ui_execute_on_save = false
    end,
  },
}
local cmds = {
  --stylua: ignore
  { "<Localleader>dd",function() vim.cmd("Sqmeow toggle") end, "toggle" },
  --stylua: ignore
  { "<Localleader>dc",function() vim.cmd("Sqmeow cancel") end, "cancel" },
  --stylua: ignore
  { "<Localleader>da",function() vim.cmd("Sqmeow add") end, "add connection" },
  --stylua: ignore
  { "<Localleader>ds",function() vim.cmd("Sqmeow scratch") end, "new scratchpad" },
}

for _, cmd in ipairs(cmds) do
  UtilKey.nnoremap(cmd[1], cmd[2], { desc = ("db: %s [sqmeow]"):format(cmd[3]) })
end

on_plugin_update("sqmeow.nvim", function()
  lazy("sqmeow").install()
end)
on_plugin_update("nvim-dbee", function()
  lazy("dbee").install()
end)
