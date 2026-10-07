local add_on_file_type = require("vim-pack").add_on_file_type

add_on_file_type("python", {
  {
    src = "benomahony/uv.nvim",
    lazy = true,
    opts = {},
  },

  {
    src = "mizisu/django.nvim",
    opts = {},
  },
})
