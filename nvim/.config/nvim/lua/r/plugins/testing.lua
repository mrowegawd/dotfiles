return {
  -- recommended = true,
  -- desc = "Neotest support. Requires language specific adapters to be configured. (see lang extras)",
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/nvim-nio" },
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
          if RUtils.has "trouble.nvim" then
            require("trouble").open { mode = "quickfix", focus = false }
          else
            vim.cmd(RUtils.cmd.quickfix.copen)
          end
        end,
      },
      consumers = {},
    },
    config = function(_, opts)
      require("r.settings.highlights").plugin("neotestui", {
        { NeotestPassed = { bg = "NONE" } },
        { NeotestFailed = { bg = "NONE" } },
        { NeotestRunning = { bg = "NONE" } },
      })

      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if RUtils.has "trouble.nvim" then
        opts.consumers = opts.consumers or {}
        -- Refresh and auto close trouble after running tests
        ---@type neotest.Consumer
        opts.consumers.trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end
            local tree = assert(client:get_position(nil, { adapter = adapter_id }))

            local failed = 0
            for pos_id, result in pairs(results) do
              if result.status == "failed" and tree:get_key(pos_id) then
                failed = failed + 1
              end
            end
            vim.schedule(function()
              local trouble = require "trouble"
              if trouble.is_open() then
                trouble.refresh()
                if failed == 0 then
                  trouble.close()
                end
              end
            end)
            return {}
          end
        end
      end

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
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter = adapter(config)
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
      { "<leader>ta", function() require("neotest").run.attach() end, desc = "Testing: attach to test" },
      { "<Leader>tt", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Testing: run file" },
      { "<Leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Testing: run all test files" },
      { "<Leader>tr", function() require("neotest").run.run() end, desc = "Testing: test nearest" },
      { "<Leader>tl", function() require("neotest").run.run_last() end, desc = "Testing: run last" },
      { "<Leader>to", function() require("neotest").summary.toggle() end, desc = "Testing: open/close summary" },
      { "<Leader>tP", function() require("neotest").output.open { enter = true, short = false } end, desc = "Testing: show output preview" },
      { "<Leader>tS", function() require("neotest").run.stop() end, desc = "Testing: stop" },
      { "<Leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Testing: toggle watch" },
      { "<Leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug: nearest [dap]" },
      {
        "<Leader>tf",
        function()
          local neotest = require "neotest"
          RUtils.fzflua.open_cmd_bulk({
            ["Test - File"] = function()
              vim.cmd [[lua require("neotest").run.run(vim.fn.expand "%")]]
            end,
            ["Test - All files"] = function()
              vim.cmd [[lua require("neotest").run.run(vim.uv.cwd())]]
            end,
            ["Test - Unit"] = function()
              vim.cmd [[lua require("neotest").run.run()]]
            end,
            ["Test - Stop"] = function()
              vim.cmd [[lua require("neotest").run.stop { interactive = true }]]
            end,
            ["Test - Suit"] = function()
              vim.cmd [[lua for _, adapter_id in ipairs(require("neotest").state.adapter_ids()) do require("neotest").run.run { suite = true, adapter = adapter_id, } end]]
            end,
            ["Test - nearest"] = function()
              vim.cmd [[lua require("neotest").run.run { strategy = "dap" }]]
            end,
            ["Coverage - Run"] = function()
              vim.cmd [[CoverageLoad]]
              vim.cmd [[Coverage]]
            end,
            ["Coverage - Summary"] = function()
              vim.cmd [[CoverageSummary]]
            end,
            ["Coverage - Load"] = function()
              vim.cmd [[CoverageLoad]]
            end,
            ["Coverage - Show"] = function()
              vim.cmd [[CoverageShow]]
            end,
            ["Coverage - Hide"] = function()
              vim.cmd [[CoverageHide]]
            end,
            ["Coverage - Clear"] = function()
              vim.cmd [[CoverageClear]]
            end,
            ["Toggle - Summery test"] = function()
              neotest.summary.toggle()
            end,
            ["Toggle - coverage"] = function()
              vim.cmd [[CoverageToggle]]
            end,
          }, {
            winopts = { title = RUtils.config.icons.misc.dashboard .. " Testing",  },
          })
        end,
        desc = "Bulk: testing cmds",
      },
    },
  },
}
