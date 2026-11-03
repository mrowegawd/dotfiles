local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local IconsLSP = lazy("icons").kinds

add {
  { src = "MadKuntilanak/nui.nvim", setup = false },
  {
    src = "retran/meow.yarn.nvim",
    lazy = true,
    opts = {
      mappings = {
        jump = "<CR>",
        toggle = "<Tab>",
        expand = "<S-Right",
        expand_alt = "<Right>",
        collapse = "<S-Left>",
        collapse_alt = "<Left>",
        show_super_hierarchy = "K",
        show_sub_hierarchy = "J",
        quit = "q",
      },
      hierarchies = {
        type_hierarchy = {
          icons = {
            class = IconsLSP.Class,
            struct = IconsLSP.Struct,
            interface = IconsLSP.Interface,
            default = "",
          },
        },
        call_hierarchy = {
          icons = {
            method = IconsLSP.Method,
            func = IconsLSP.Function,
            variable = IconsLSP.Variable,
            default = "",
          },
        },
      },
    },
  },
}

local load_meoyarn = function()
  lazy("vim-pack").load_now "meow.yarn.nvim"
end

local UtilKey = lazy "utils.map"

local function call_meow(type, sub_type)
  return lazy("meow.yarn").open_tree(type, sub_type)
end

local cmds = {
  --stylua: ignore
  { "<Leader>cpw", function() call_meow("call_hierarchy", "callers") end, "who caller" },
  --stylua: ignore
  { "<Leader>cpW", function() call_meow("call_hierarchy", "callees") end, "what callers" },
  --stylua: ignore
  { "<Leader>cpS", function() call_meow("type_hierarchy", "supertypes") end, "Super Type" },
  --stylua: ignore
  { "<Leader>cps", function() call_meow("type_hierarchy", "subtypes") end, "Sub Type" },
}

for _, cmd in ipairs(cmds) do
  UtilKey.nnoremap(cmd[1], function()
    load_meoyarn()
    cmd[2]()
  end, { desc = ("Peek: %s [meow.yarn]"):format(cmd[3]) })
end
