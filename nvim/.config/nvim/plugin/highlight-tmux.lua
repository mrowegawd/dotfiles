local add_on_file_type = require("vim-pack").add_on_file_type

add_on_file_type("tmux", {
  {
    src = "tmux-plugins/vim-tmux",
    setup = false,
  },
})
