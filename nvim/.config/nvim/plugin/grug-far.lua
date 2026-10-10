local add = require("vim-pack").add

local UtilKey = require "utils.map"

-- Find and replace.
add {
  {
    src = "MagicDuck/grug-far.nvim",
    lazy = true,
    opts = {
      -- Disable folding.
      folding = { enabled = false },
      -- Don't numerate the result list.
      resultLocation = { showNumberLabel = false },
      windowCreationCommand = "botright vsplit",
      keymaps = {
        replace = { n = "<c-c>" },
        qflist = { n = "<c-q>" },
        syncLocations = { n = "<Localleader>s" },
        syncLine = { n = "<Localleader>l" },
        close = { n = "q" },
        historyOpen = { n = "<Leader>h" },
        historyAdd = { n = "<Leader>A" },
        refresh = { n = "R" },
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },
      },
    },
  },
}

UtilKey.nnoremap("<Localleader>gg", function()
  UtilKey.plugin_load_now "grug-far.nvim"

  local grug = require "grug-far"
  local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
  grug.open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
      flags = "-i --multiline --hidden",
    },
  }
end, { desc = "GrepEnchanted: grug far current path (visual) [grugfar]" })
UtilKey.vnoremap("<Localleader>gg", function()
  UtilKey.plugin_load_now "grug-far.nvim"
  local grug = require "grug-far"
  local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
  grug.open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
      flags = "-i --multiline --hidden",
    },
  }
end, { desc = "GrepEnchanted: grug far current path (visual) [grugfar]" })

UtilKey.nnoremap("<Localleader>gb", function()
  UtilKey.plugin_load_now "grug-far.nvim"

  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or ""
  local grug = require "grug-far"
  grug.open {
    prefills = {
      search = "",
      replacement = "",
      filesFilter = "",
      flags = "-i --multiline --hidden",
      paths = path,
    },
    staticTitle = "Find and Replace",
  }
end, { desc = "GrepEnchanted: grug far current path [grugfar]" })

UtilKey.vnoremap("<Localleader>gb", function()
  UtilKey.plugin_load_now "grug-far.nvim"

  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p") or ""
  local grug = require "grug-far"
  local _str = require("utils.cmd").get_selection()

  grug.open {
    prefills = {
      search = _str,
      replacement = "",
      filesFilter = "",
      paths = path,
      flags = "-i --multiline --hidden",
    },
    staticTitle = "Find and Replace",
  }
end, { desc = "GrepEnchanted: grug far current path (visual) [grugfar]" })
