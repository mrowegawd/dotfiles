local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

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
        replace = { n = "<C-x>er" },
        qflist = { n = "<C-q>" },
        syncLocations = { n = "<C-x>es" },
        syncLine = { n = "<C-x>el" },
        close = { n = "q" },
        historyOpen = { n = "<C-x>oh" },
        historyAdd = { n = "<C-x>oo" },
        refresh = { n = "<C-x>R" },
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },

        nextInput = { n = "<C-n>" },
        prevInput = { n = "<C-p>" },

        openNextLocation = { n = "<a-n>" },
        openPrevLocation = { n = "<a-p>" },

        toggleShowCommand = { n = "<C-x>ui" },
        help = { n = "g?", "<C-x>?" },
        abort = { n = "<C-x><C-k>" },

        swapEngine = { n = "<localleader>e" },

        syncNext = { n = "<S-Down>" },
        syncPrev = { n = "<S-Up>" },
        applyNext = { n = "<C-j>" },
        applyPrev = { n = "<C-k>" },
      },
    },
  },
}

UtilKey.nnoremap("<Localleader>gg", function()
  lazy("utils.layout").close_master_window()

  UtilKey.plugin_load_now "grug-far.nvim"

  local grug = lazy "grug-far"
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
  local grug = lazy "grug-far"
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
  local grug = lazy "grug-far"
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
  local grug = lazy "grug-far"
  local _str = lazy("utils.cmd").get_selection()

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
