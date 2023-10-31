local keymap = vim.keymap

keymap.set(
  "n",
  "<Leader>lv",
  "<cmd>:VenvSelect<cr>",
  { buffer = true, desc = "Lang(vinv-selsctor): select virtualEnv" }
)

keymap.set("n", "<Leader>dam", function()
  require("dap-python").test_method()
end, { buffer = true, desc = "Debug(dap-python): debug method" })

keymap.set("n", "<Leader>dac", function()
  require("dap-python").test_class()
end, { buffer = true, desc = "Debug(dap-python): debug class" })
