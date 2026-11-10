local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local IconsDebug = lazy("icons").dap
local Log = lazy "utils.log"

local Plugin = lazy "utils.plugin"
local Neotest = lazy "neotest"
local Fzflua = lazy "utils.fzflua"
local UtilKey = lazy "utils.map"
local UtilQf = lazy "utils.qf"

add {
  {
    src = "nvim-neotest/nvim-nio",
    setup = false,
  },
  {
    src = "andythigpen/nvim-coverage", -- Display test coverage information
    module_name = "nvim-coverage",
    setup = false,
    opts = function()
      return { auto_reload = true }
    end,
  },
  {
    src = "nvim-neotest/neotest-python",
  },
  {
    src = "fredrikaverpil/neotest-golang",
    -- opts = {
    --   adapters = {
    --     ["neotest-golang"] = {
    --       -- Here we can set options for neotest-golang, e.g.
    --       -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
    --       dap_go_enabled = true, -- requires leoluz/nvim-dap-go
    --     },
    --   },
    -- },
  },
  {
    src = "nvim-neotest/neotest",
    opts = {
      status = { virtual_text = true },
      output = { open_on_run = true },
      adapters = {},
      summary = {
        mappings = {
          attach = "a",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "<TAB>",
          jumpto = "o",
          output = "P",
          run = "r",
          short = "O",
          stop = "u",
        },
      },
      quickfix = {
        open = function()
          if Plugin.has "trouble.nvim" then
            lazy("trouble").open { mode = "quickfix", focus = false }
          else
            vim.cmd(UtilQf.copen)
          end
        end,
      },
      consumers = {},
    },
  },
}

local function open_test_commands()
  Fzflua.open_cmd_bulk_center({
    --stylua: ignore
    ["Test - attach to test"] = function() Neotest.run.attach() end,
    --stylua: ignore
    ["Test - run test on current file"] = function() Neotest.run.run(vim.fn.expand "%") end,
    --stylua: ignore
    ["Test - run all test files"] = function() Neotest.run.run(vim.uv.cwd()) end,
    --stylua: ignore
    ["Test - run last test"] = function() Neotest.run.run_last() end,
    --stylua: ignore
    ["Test - run test nearest"] = function() Neotest.run.run() end,
    --stylua: ignore
    ["Test - run suit"] = function()
      vim.cmd [[lua for _, adapter_id in ipairs(Neotest.state.adapter_ids()) do Neotest.run.run { suite = true, adapter = adapter_id, } end]]
    end,
    --stylua: ignore
    ["Test - stop / quit"] = function() Neotest.run.stop { interactive = true } end,
    --stylua: ignore
    ["Test - run test with strategy Dap"] = function() Neotest.run.run { strategy = "dap" } end,
    --stylua: ignore
    ["Test - toggle summery test"] = function() Neotest.summary.toggle() end,
    --stylua: ignore
    ["Test - run toggle watch"] = function() Neotest.watch.toggle(vim.fn.expand "%") end,
    --stylua: ignore
    ["Coverage - run"] = function() vim.cmd [[CoverageLoad]] vim.cmd [[Coverage]] end,
    --stylua: ignore
    ["Coverage - summary"] = function() vim.cmd [[CoverageSummary]] end,
    --stylua: ignore
    ["Coverage - load"] = function() vim.cmd [[CoverageLoad]] end,
    --stylua: ignore
    ["Coverage - show"] = function() vim.cmd [[CoverageShow]] end,
    --stylua: ignore
    ["Coverage - hide"] = function() vim.cmd [[CoverageHide]] end,
    --stylua: ignore
    ["Coverage - clear"] = function() vim.cmd [[CoverageClear]] end,
    --stylua: ignore
    ["Coverage - toggle"] = function() vim.cmd [[CoverageToggle]] end,
  }, {
    winopts = {
      title = string.format("Test Commands", IconsDebug.BreakpointCondition),
    },
  })
end

local function test_with_coverage()
  vim.fn.jobstart({ "uv", "run", "coverage", "run", "-m", "pytest" }, {
    stdout_buffered = true,
    on_exit = function(_, code)
      if code == 0 then
        Log.info "Tests passed"
        lazy("coverage").load(true)
      else
        Log.info "Tests failed"
      end
    end,
  })
end

local function test_under_in_widest_window()
  local current_word = vim.fn.expand "<cWORD>"
  local tokens = vim.split(current_word, ":", { trimempty = true })
  local win_ids = vim.api.nvim_list_wins()
  local widest_win_id = -1
  local widest_win_width = -1
  for _, win_id in ipairs(win_ids) do
    if vim.api.nvim_win_get_config(win_id).zindex then
      goto continue
    end
    local win_width = vim.api.nvim_win_get_width(win_id)
    if win_width > widest_win_width then
      widest_win_width = win_width
      widest_win_id = win_id
    end
    ::continue::
  end
  vim.api.nvim_set_current_win(widest_win_id)
  if #tokens == 1 then
    vim.cmd("e " .. tokens[1])
  else
    vim.cmd("e +" .. tokens[2] .. " " .. tokens[1])
  end
end

local cmds = {
  { "<Leader>tc", test_with_coverage, "run tests with coverage" },
  -- https://github.com/nvim-neotest/neotest/issues/387#issuecomment-2409133005
  -- ft = "neotest-output",
  -- silent = true
  { "<Leader>tL", test_under_in_widest_window, "open file under cursor in widest window" },
  --stylua: ignore
  { "<Leader>tf", function() Neotest.run.run { vim.api.nvim_buf_get_name(0) } end, "current file" },
  --stylua: ignore
  { "<Leader>tl", function() Neotest.run.run_last() end, "run last" },
  --stylua: ignore
  { "<Leader>to", function() Neotest.summary.toggle() end, "toggle summary test" },
  --stylua: ignore
  { "<Leader>tP", function() Neotest.output.open { enter = true, short = false } end, "show output preview" },
  --stylua: ignore
  { "<Leader>tn", function() Neotest.run.run() end, "run test nearest", },
  {
    "<Leader>tN",
    function()
      for _, adapter_id in ipairs(Neotest.state.adapter_ids()) do
        Neotest.run.run { suite = true, adapter = adapter_id }
      end
    end,
    "run all test files",
  },
}

for _, cmd in ipairs(cmds) do
  UtilKey.nnoremap(cmd[1], cmd[2], { desc = ("Test: %s [neotest]"):format(cmd[3]) })
end

UtilKey.nnoremap("<Leader>tF", open_test_commands, { desc = "Bulk: test commands" })
