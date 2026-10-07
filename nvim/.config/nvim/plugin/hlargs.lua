local add_on_event = require("vim-pack").add_on_event

-- Find and replace.
add_on_event("LspAttach", {
  {
    src = "m-demare/hlargs.nvim",
    opts = {
      hl_priority = 200,
      color = "#d19a66",
      excluded_argnames = {
        declarations = {
          python = { "self", "cls" },
          lua = { "self" },
        },
        usages = {
          python = { "self", "cls" },
          lua = { "self" },
        },
      },
    },
  },
})
