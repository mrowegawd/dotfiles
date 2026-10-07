local add = require("vim-pack").add

local IconsLSP = require("icons").kinds

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
  require("vim-pack").load_now "meow.yarn.nvim"
end

vim.api.nvim_create_user_command("PeekWHOCallers", function()
  load_meoyarn()
  require("meow.yarn").open_tree("call_hierarchy", "callers")
end, { desc = "LSP: show callers (who calls this function) [meow.yarn]" })

vim.api.nvim_create_user_command("PeekWHATCallees", function()
  load_meoyarn()
  require("meow.yarn").open_tree("call_hierarchy", "callees")
end, { desc = "LSP: show callees (functions called by this function) [meow.yarn]" })

vim.api.nvim_create_user_command("PeekSUPERTYPE", function()
  load_meoyarn()
  require("meow.yarn").open_tree("type_hierarchy", "supertypes")
end, { desc = "LSP: show supertypes (parent types) [meow.yarn]" })

vim.api.nvim_create_user_command("PeekSUBTYPE", function()
  load_meoyarn()
  require("meow.yarn").open_tree("type_hierarchy", "subtypes")
end, { desc = "LSP: show subtypes (derived/child types) [meow.yarn]" })
