local keymap = vim.keymap

keymap.set(
  "n",
  "<Leader>cv",
  "<cmd>:VenvSelect<cr>",
  { buffer = true, desc = "Action: select virtualenv [venv-selector]" }
)

keymap.set("n", "<Leader>dam", function()
  require("dap-python").test_method()
end, { buffer = true, desc = "Debug: debug method [dap-python]" })

keymap.set("n", "<Leader>dac", function()
  require("dap-python").test_class()
end, { buffer = true, desc = "Debug: debug class [dap-python]" })
