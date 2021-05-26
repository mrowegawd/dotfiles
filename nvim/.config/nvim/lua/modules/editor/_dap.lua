local dap = require("dap")
local g = vim.g

local debugJest = function(testName, filename)
  print("starting " .. testName .. " with file " .. filename)
  dap.run({
    type = "node2",
    request = "launch",
    cwd = vim.fn.getcwd(),
    runtimeArgs = {
      "--inspect-brk",
      "/usr/local/bin/jest",
      "--no-coverage",
      "-t",
      testName,
      "--",
      filename,
    },
    sourceMaps = true,
    protocol = "inspector",
    skipFiles = { "<node_internals>/**/*.js" },
    console = "integratedTerminal",
    port = 9229,
  })
end

g.dap_virtual_text = true

local attachDebug = function()
  print("Debugger nvim-dap launched..")
  -- PYTHON --------------------------------------------------------------- {{{
  require("dap-python").setup(
    os.getenv("HOME") .. "/.config/debugpy/bin/python",
    { console = "internalConsole" }
  )
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = function()
        return "python"
      end,
    },
  }
  -- }}}

  -- NODE ----------------------------------------------------------------- {{{
  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = {
      os.getenv("HOME") .. "/bin/build/vscode-node-debug2/out/src/nodeDebug.js",
    },
  }
  dap.configurations.javascript = {
    {
      type = "node2",
      request = "launch",
      -- request = "attach",
      program = "${workspaceFolder}/${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
      skipFiles = { "<node_internals>/**/*.js" },
    },
  }
  dap.configurations.typescript = {
    {
      type = "node2",
      request = "launch",
      program = "${workspaceFolder}/${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
      skipFiles = { "<node_internals>/**/*.js" },
    },
  }
  -- }}}
end

return {
  debugJest = debugJest,
  attachDebug = attachDebug,
}
