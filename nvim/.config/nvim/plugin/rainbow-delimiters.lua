local add_on_event = require("vim-pack").add_on_event

add_on_event({'BufReadPre', 'BufNewFile' }, {
  {
    src = "HiPhish/rainbow-delimiters.nvim",
    setup = false,
  },
})
