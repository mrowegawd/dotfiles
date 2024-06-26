return {
  name = "[Builtin]: Run sh/bash",
  -- desc = "Build and run single file",
  builder = function()
    local file = vim.fn.expand "%:p"
    local cmd = { "bash" }
    return {
      cmd = cmd,
      args = { file },
      metadata = { run_cmd = string.format("%s %s", cmd[1], file) },
      components = {
        { "on_complete_notify" }, -- don't notify on completion
        { "on_output_quickfix", open = false },
        "default",
      },
      default_component_params = {
        errorformat = ""
          .. [[%f:\ %[%^0-9]%#\ %l:%m,]]
          .. [[%f:\ %l:%m,%f:%l:%m,]]
          .. [[%f[%l]:%m,]]
          .. [[%-G[Process exited%.%#,]],
      },
    }
  end,
  condition = {
    filetype = { "sh" },
  },
}
