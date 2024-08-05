local keymap, api = vim.keymap, vim.api

-- Disable ctrl-i and ctrl-o
keymap.set("n", "<c-i>", "<Nop>", { buffer = api.nvim_get_current_buf() })
keymap.set("n", "<c-o>", "<Nop>", { buffer = api.nvim_get_current_buf() })

keymap.set("n", "<c-q>", function()
  print(vim.inspet(require("trouble").get_items(opts)))
end, { buffer = api.nvim_get_current_buf(), desc = "Trouble: send to quickfix" })
