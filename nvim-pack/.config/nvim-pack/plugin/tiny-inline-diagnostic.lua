local add_on_event = require("vim-pack").add_on_event

add_on_event("LspAttach", {
  {
    src = "rachartier/tiny-inline-diagnostic.nvim",
  },
})
