local dap = require("dap")
local g = vim.g

local k = require("astronauta.keymap")
local nnoremap = k.nnoremap
local vnoremap = k.vnoremap

vim.fn.sign_define(
  "DapBreakpoint",
  { text = "綠", texthl = "", linehl = "", numhl = "" }
)
vim.fn.sign_define(
  "DapStopped",
  { text = "->", texthl = "", linehl = "", numhl = "" }
)

local function debugJest(testName, filename)
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
  --
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

-- DEBUGGER --------------------------------------------------------------- {{{
nnoremap({
  "<leader>da",
  "<cmd>lua require'plugins._dap'.attachDebug()<CR>",
  { silent = true },
})

nnoremap({
  "<leader>db",
  "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
  { silent = true },
})

nnoremap({
  "<leader>de",
  "<cmd>lua require'dap'.set_exception_breakpoints({'all'})()<CR>",
  { silent = true },
})

nnoremap({
  "<leader>dB",
  "<cmd>lua require'dap'.list_breakpoints()<CR>",
  { silent = true },
})

nnoremap({
  "<leader>di",
  "<cmd>lua require'dap.ui.variables'.hover(function () return vim.fn.expand('<cexpr>') end)<CR>",
  { silent = true },
})

vnoremap({
  "<leader>di",
  "<cmd>lua require'dap.ui.variables'.visual_hover()<CR>",
  { silent = true },
})

nnoremap({
  "<leader>d?",
  "<cmd>lua require'dap.ui.variables'.scopes()<CR>",
  { silent = true },
})

nnoremap({
  "<leader>dn",
  "<cmd>lua require'dap'.continue()<CR>",
  { silent = true },
})
nnoremap({
  "<leader>d_",
  "<cmd>lua require'dap'.run_last()<CR>",
  { silent = true },
})

nnoremap({
  "<leader>dr",
  "<cmd>lua require'dap'.repl.open({}, 'vsplit')<CR><C-w>l",
  { silent = true },
})

-- STEP_OVER, STEP_OUT, STEP_INTO

nnoremap({
  "<a-n>",
  "<cmd>lua require'dap'.step_over()<CR>",
  { silent = true },
})

nnoremap({
  "<a-p>",
  "<cmd>lua require'dap'.step_into()<CR>",
  { silent = true },
})

nnoremap({
  "<a-o>",
  "<cmd>lua require'dap'.step_out()<CR>",
  { silent = true },
})
-- }}}

return {
  debugJest = debugJest,
  attachDebug = attachDebug,
}

-- vim: foldmethod=marker foldlevel=0
