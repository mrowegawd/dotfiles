local add_on_file_type = require("vim-pack").add_on_file_type

add_on_file_type("gitignore", {
  {
    src = "wintermute-cell/gitignore.nvim",
    setup = false,
  },
})
