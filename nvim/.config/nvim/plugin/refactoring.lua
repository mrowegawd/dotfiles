local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

add {
  {
    src = "lewis6991/async.nvim",
    setup = false,
  },
  {
    src = "ThePrimeagen/refactoring.nvim",
    lazy = true,
    setup = false,
  },
}

UtilKey.nnoremap("<Localleader>rf", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return lazy("refactoring").extract_func()
end, { desc = "Refactoring: extract func" })

UtilKey.nnoremap("<Localleader>rF", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return lazy("refactoring").extract_func_to_file()
end, { desc = "Refactoring: extract func to file" })

UtilKey.xnoremap("<Localleader>ri", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return lazy("refactoring").inline_var()
end, { desc = "Refactoring: inline variable" })

UtilKey.nnoremap("<Localleader>rv", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return lazy("refactoring").extract_var()
end, { desc = "Refactoring: extract var" })

UtilKey.nnoremap("<Localleader>rP", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return lazy("refactoring.debug").print_loc { output_location = "below" }
end, { desc = "Refactoring: insert print above [refactoring]" })

UtilKey.nnoremap("<Localleader>rp", function()
  UtilKey.plugin_load_now "refactoring.nvim"
  return lazy("refactoring.debug").print_var { output_location = "below" } .. "iw"
end, { desc = "Refactoring: insert print below [refactoring]" })
