local add_on_event = require("vim-pack").add_on_event

add_on_event("LspAttach", {
  { src = "stevearc/dressing.nvim", setup = false },
  {
    src = "smjonas/inc-rename.nvim",
    setup = false,
    -- opts = {
    --   show_message = false,
    --   preview_empty_name = false,
    --   cmd_name = "IncRename",
    -- },
  },
})
