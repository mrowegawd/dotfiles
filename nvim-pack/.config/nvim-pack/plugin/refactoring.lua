local add = require("vim-pack").add

local UtilKey = require "utils.map"

add {
  { src = "lewis6991/async.nvim", setup = false },
  {
    src = "ThePrimeagen/refactoring.nvim",
    lazy = true,
    setup = false,
  },
}

UtilKey.xnoremap("<Localleader>xi", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return require("refactoring").inline_var()
end, { desc = "Refactoring: inline variable" })

UtilKey.nnoremap("<Localleader>xf", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return require("refactoring").extract_func()
end, { desc = "Refactoring: extract func" })

UtilKey.nnoremap("<Localleader>xF", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return require("refactoring").extract_func_to_file()
end, { desc = "Refactoring: extract func to file" })

UtilKey.nnoremap("<Localleader>xv", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return require("refactoring").extract_var()
end, { desc = "Refactoring: extract var" })

UtilKey.nnoremap("<Localleader>xP", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return require("refactoring.debug").print_loc { output_location = "below" }
end, { desc = "Refactoring: insert print above [refactoring]" })

UtilKey.nnoremap("<Localleader>xp", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return require("refactoring.debug").print_var { output_location = "below" } .. "iw"
end, { desc = "Refactoring: insert print below [refactoring]" })
