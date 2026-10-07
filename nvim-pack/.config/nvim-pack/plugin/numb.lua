local add_on_event = require("vim-pack").add_on_event

add_on_event("CmdlineEnter", {
  {
    src = "nacro90/numb.nvim",
    setup = false,
  },
})
