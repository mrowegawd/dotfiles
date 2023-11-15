local fn = vim.fn

return {
  -- NEOTEST
  {
    "nvim-neotest/neotest",
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
          vim.cmd "copen"
        end,
      },
      -- overseer.nvim
      -- consumers = {
      --   overseer = require "neotest.consumers.overseer",
      -- },
      -- overseer = {
      --   enabled = true,
      --   force_default = true,
      -- },
    },
    config = function(_, opts)
      require("r.config.highlights").plugin("neotest", {
        { NeotestPassed = { bg = { from = "ColorColumn", attr = "bg" } } },
        { NeotestFailed = { bg = { from = "ColorColumn", attr = "bg" } } },
        { NeotestRunning = { bg = { from = "ColorColumn", attr = "bg" } } },
      })

      local namespace = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          end,
        },
      }, namespace)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
    -- stylua: ignore
    keys = {
      -- { "<Leader>tL", function() require("neotest").run.run_last { strategy = "dap", } end, desc = "Testing(neotest): run last with debug" },
      { "<Leader>tf", function() require("neotest").run.run(fn.expand "%") end, desc = "Testing(neotest): test file" },
      { "<Leader>tF", function() require("neotest").run.run(vim.loop.cwd()) end, "Testing(neotest): test all files" },
      { "<Leader>tt", function() require("neotest").run.run() end, desc = "Testing(neotest): test unit" },
      { "<Leader>tc", function() require("neotest").run.stop { interactive = true, } end, desc = "Testing(neotest): stop" },
      { "<Leader>to", function() require("neotest").summary.toggle() end, desc = "Testing(neotest): output summary panel" },
      { "<Leader>tP", function() require("neotest").output.open { enter = true, short = false, } end, desc = "Testing(neotest): preview the output" },
      { "<Leader>ts",
        function()
          local neotest = require "neotest"
          for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
            return neotest.run.run {
              suite = true,
              adapter = adapter_id,
            }
          end
        end,
        desc = "Testing(neotest): test suite",
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<Leader>td", function() require("neotest").run.run { strategy = "dap", } end, desc = "Testing(neotest): debug nearest" }, },
  },
}
