local add = require("vim-pack").add

local UtilKey = require "utils.map"

-- Navigation with jump motions.
add {
  {
    src = "folke/flash.nvim",
    lazy = true,
    opts = {
      jump = { nohlsearch = true },
      prompt = {
        win_config = {
          border = "none",
          -- Place the prompt above the statusline.
          row = -3,
        },
      },
      search = {
        exclude = {
          "flash_prompt",
          "qf",
          function(win)
            -- Non-focusable windows.
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
      },
      modes = {
        -- Enable flash when searching with ? or /
        search = { enabled = false },
        char = {
          enabled = false,
          keys = { "f", "F", "t", "T", ";" },
        },
      },
    },
    on_setup = function() end,
  },
}

local load_flash = function()
  UtilKey.plugin_load_now "flash.nvim"
end

--stylua: ignore
UtilKey.noremap({ "n", "o", "x" }, "gs", function() load_flash() require("flash").jump() end, { desc = "Flash: jump [flash]" })
--stylua: ignore
UtilKey.onoremap("r", function() load_flash() require("flash").treesitter_search() end, { desc = "Flash: treesitter search" })
--stylua: ignore
UtilKey.onoremap("R", function() load_flash() require("flash").remote() end, { desc = "Flash: remote flash" })
