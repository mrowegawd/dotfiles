return {
  -- NEOTEST
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
    },
    opts = {
      status = { virtual_text = true },
      output = { open_on_run = true },
      adapters = {
        ["neotest-go"] = {
          recursive_run = true,
        },
        ["neotest-rust"] = {},
        ["neotest-python"] = {

          -- require("rustaceanvim.neotest") <-- TODO: ini harus di sematkan pada adapters

          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
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
      require("r.settings.highlights").plugin("neotest", {
        { NeotestPassed = { bg = { from = "Normal", attr = "bg" } } },
        { NeotestFailed = { bg = { from = "Normal", attr = "bg" } } },
        { NeotestRunning = { bg = { from = "Normal", attr = "bg" } } },
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
    keys = {
      -- { "<Leader>tf", function() require("neotest").run.run(fn.expand "%") end, desc = "Testing: test file [neotest]" },
      -- { "<Leader>tF", function() require("neotest").run.run(vim.uv.cwd()) end, "Testing: test all files [neotest]" },
      -- { "<Leader>tc", function() require("neotest").run.stop { interactive = true, } end, desc = "Testing: stop [neotest]" },
      {
        "<Leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Testing: run last [neotest]",
      },
      {
        "<Leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Testing: test unit [neotest]",
      },
      {
        "<Leader>to",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Testing: open output summary [neotest]",
      },
      {
        "<Leader>tP",
        function()
          require("neotest").output.open { enter = true, short = false }
        end,
        desc = "Testing: preview [neotest]",
      },
      {
        "<Leader>tf",
        function()
          local col, row = RUtils.fzflua.rectangle_win_pojokan()
          local neotest = require "neotest"
          RUtils.fzflua.send_cmds({
            test_file = function()
              vim.cmd [[lua require("neotest").run.run(vim.fn.expand "%")]]
            end,
            test_all_files = function()
              vim.cmd [[lua require("neotest").run.run(vim.uv.cwd())]]
            end,
            test_unit = function()
              vim.cmd [[lua require("neotest").run.run()]]
            end,
            test_stop = function()
              vim.cmd [[lua require("neotest").run.stop { interactive = true }]]
            end,
            test_suit = function()
              vim.cmd [[lua for _, adapter_id in ipairs(require("neotest").state.adapter_ids()) do require("neotest").run.run { suite = true, adapter = adapter_id, } end]]
            end,
            test_open_summary = function()
              neotest.summary.toggle()
            end,
            test_debug_nearest = function()
              vim.cmd [[lua require("neotest").run.run { strategy = "dap" }]]
            end,
            coverage = function()
              vim.cmd [[CoverageLoad]]
              vim.cmd [[Coverage]]
            end,
            coverage_summary = function()
              vim.cmd [[CoverageSummary]]
            end,
            coverage_load = function()
              vim.cmd [[CoverageLoad]]
            end,
            coverage_show = function()
              vim.cmd [[CoverageShow]]
            end,
            coverage_hide = function()
              vim.cmd [[CoverageHide]]
            end,
            coverage_toggle = function()
              vim.cmd [[CoverageToggle]]
            end,
            coverage_clear = function()
              vim.cmd [[CoverageClear]]
            end,
          }, {
            winopts = { title = RUtils.config.icons.misc.dashboard .. " Testing", row = row, col = col },
          })
        end,
        desc = "Testing: list of cmds [neotest]",
      },
    },
  },
  -- {
  --   "mfussenegger/nvim-dap",
  --   optional = true,
  --   keys = {
  --     {
  --       "<Leader>td",
  --       function()
  --         require("neotest").run.run { strategy = "dap" }
  --       end,
  --       desc = "Testing: debug nearest [neotest]",
  --     },
  --   },
  -- },
}
