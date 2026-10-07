return {
  -- recommended = true,
  -- desc = "Neotest support. Requires language specific adapters to be configured. (see lang extras)",
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      -- NVIM-COVERAGE
      {
        "andythigpen/nvim-coverage", -- Display test coverage information
        version = "*",
        config = function()
          require("coverage").setup {
            auto_reload = true,
          }
        end,
      },
    },
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
            vim.cmd(RUtils.qf.copen)
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
    keys = {
      {
        "<Leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Testing: run test nearest",
      },
      {
        "<leader>tc",
        function()
          vim.fn.jobstart({ "uv", "run", "coverage", "run", "-m", "pytest" }, {
            stdout_buffered = true,
            on_exit = function(_, code)
              if code == 0 then
                RUtils.info "Tests passed"
                require("coverage").load(true)
              else
                RUtils.info "Tests failed"
              end
            end,
          })
        end,
        desc = "Testing: run tests with coverage",
      },

      {
        "<Leader>tL",
        -- https://github.com/nvim-neotest/neotest/issues/387#issuecomment-2409133005
        function()
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
        end,
        desc = "Testing: open file under cursor in widest window",
        ft = "neotest-output",
        silent = true,
      },

      {
        "<Leader>tN",
        function()
          for _, adapter_id in ipairs(require("neotest").state.adapter_ids()) do
            require("neotest").run.run { suite = true, adapter = adapter_id }
          end
        end,
        desc = "Testing: run all test files",
      },
      {
        "<Leader>tf",
        function()
          require("neotest").run.run { vim.api.nvim_buf_get_name(0) }
        end,
        desc = "Testing: current file",
      },
      {
        "<Leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Testing: run last",
      },
      {
        "<Leader>to",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Testing: toggle summary test",
      },
      {
        "<Leader>tP",
        function()
          require("neotest").output.open { enter = true, short = false }
        end,
        desc = "Testing: show output preview",
      },
      {
        "<Leader>tF",
        function()
          local neotest = require "neotest"
          RUtils.fzflua.open_cmd_bulk_center({
            ["Test - attach to test"] = function()
              neotest.run.attach()
            end,
            ["Test - run test on current file"] = function()
              neotest.run.run(vim.fn.expand "%")
            end,
            ["Test - run all test files"] = function()
              neotest.run.run(vim.uv.cwd())
            end,
            ["Test - run last test"] = function()
              neotest.run.run_last()
            end,
            ["Test - run test nearest"] = function()
              neotest.run.run()
            end,
            ["Test - run suit"] = function()
              vim.cmd [[lua for _, adapter_id in ipairs(require("neotest").state.adapter_ids()) do require("neotest").run.run { suite = true, adapter = adapter_id, } end]]
            end,
            ["Test - stop / quit"] = function()
              neotest.run.stop { interactive = true }
            end,
            ["Test - run test with strategy Dap"] = function()
              neotest.run.run { strategy = "dap" }
            end,
            ["Test - toggle summery test"] = function()
              neotest.summary.toggle()
            end,
            ["Test - run toggle watch"] = function()
              neotest.watch.toggle(vim.fn.expand "%")
            end,
            ["Coverage - run"] = function()
              vim.cmd [[CoverageLoad]]
              vim.cmd [[Coverage]]
            end,
            ["Coverage - summary"] = function()
              vim.cmd [[CoverageSummary]]
            end,
            ["Coverage - load"] = function()
              vim.cmd [[CoverageLoad]]
            end,
            ["Coverage - show"] = function()
              vim.cmd [[CoverageShow]]
            end,
            ["Coverage - hide"] = function()
              vim.cmd [[CoverageHide]]
            end,
            ["Coverage - clear"] = function()
              vim.cmd [[CoverageClear]]
            end,
            ["Coverage - toggle"] = function()
              vim.cmd [[CoverageToggle]]
            end,
          }, {
            winopts = {
              title = RUtils.fzflua.format_title("Test Commands", RUtils.config.icons.dap.BreakpointCondition),
            },
          })
        end,
        desc = "Bulk: test commands",
      },
    },
  },
}
