local add_on_event = require("vim-pack").add_on_event

add_on_event("BufReadPost", {
  {
    src = "famiu/bufdelete.nvim",
    setup = false,
  },
})
