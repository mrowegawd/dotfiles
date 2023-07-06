local fn = vim.fn

return {
    -- NEOTEST
    {
        "nvim-neotest/neotest",
        event = "BufRead",
        keys = {
            {
                "<LocalLeader>tn",
                '<CMD>lua require("neotest").run.run()<CR>',
                desc = "Testing(neotest): nearest",
            },
            {
                "<LocalLeader>tN",
                function()
                    return require("neotest").run.run {
                        strategy = "dap",
                    }
                end,
                desc = "Testing(neotest): nearest with debug",
            },

            {
                "<LocalLeader>tl",
                function()
                    return require("neotest").run.run_last {}
                end,
                desc = "Testing(neotest): run last",
            },
            {
                "<LocalLeader>tL",
                function()
                    return require("neotest").run.run_last {
                        strategy = "dap",
                    }
                end,
                desc = "Testing(neotest): run last with debug",
            },

            {
                "<LocalLeader>tF",
                function()
                    return require("neotest").run.run(fn.expand "%")
                end,
                desc = "Testing(neotest): test file with debug",
            },

            {
                "<LocalLeader>tc",
                function()
                    return require("neotest").run.stop {
                        interactive = true,
                    }
                end,
                desc = "Testing(neotest): stop",
            },

            {
                "<LocalLeader>ts",
                function()
                    local neotest = require "neotest"
                    for _, adapter_id in ipairs(neotest.run.adapters()) do
                        return neotest.run.run {
                            suite = true,
                            adapter = adapter_id,
                        }
                    end
                end,
                desc = "Testing(neotest): test suite",
            },

            {
                "<Localleader>tP",
                function()
                    return require("neotest").output.open {
                        enter = true,
                        short = false,
                    }
                end,
                desc = "Testing(neotest): preview the output",
            },
            {
                "<Localleader>to",
                '<CMD>lua require("neotest").summary.toggle()<CR>',
                desc = "Testing(neotest): summary",
            },

            --         ["[n"] = {
            --             function()
            --                 return require("neotest").jump.prev { status = "failed" }
            --             end,
            --             "Plugin: LSP: Neotest: jump to prev failed test",
            --         },
            --
            --         ["]n"] = {
            --             function()
            --                 return require("neotest").jump.next { status = "failed" }
            --             end,
            --             "Plugin: LSP: Neotest: jump to prev failed test",
            --         },
            -- },
        },
        --         {
        --             itemgroup = "Testing",
        --             commands = {
        --                 {
        --                     ":NeotestOutput",
        --                     description = "Neotest: Open test output",
        --                 },
        --                 {
        --                     ":Coverage",
        --                     function()
        --                         return require("coverage").toggle()
        --                     end,
        --                     description = "Coverage: Toggle",
        --                 },
        --                 {
        --                     ":CoverageLoad",
        --                     function()
        --                         return require("coverage").load(true)
        --                     end,
        --                     description = "Coverage: Load",
        --                 },
        --                 {
        --                     ":CoverageClear",
        --                     function()
        --                         return require("coverage").clear()
        --                     end,
        --                     description = "Coverage: Clear",
        --                 },
        --                 {
        --                     ":CoverageSummary",
        --                     function()
        --                         return require("coverage").summary()
        --                     end,
        --                     description = "Coverage: Summary",
        --                 },
        --             },
        --         },
        --     }
        -- end,
        dependencies = {
            { "rcarriga/neotest-plenary" },
            { "sidlatau/neotest-dart" },
            { "nvim-neotest/neotest-go" },
            { "rouge8/neotest-rust" },
            { "nvim-neotest/neotest-python" },
        },
        config = function()
            local namespace = vim.api.nvim_create_namespace "neotest"

            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        return diagnostic.message
                            :gsub("\n", " ")
                            :gsub("\t", " ")
                            :gsub("%s+", " ")
                            :gsub("^%s+", "")
                    end,
                },
            }, namespace)

            require("neotest").setup {
                discovery = { enabled = true },
                diagnostic = {
                    enabled = false, -- true
                },
                log_level = 1,
                consumers = {
                    overseer = require "neotest.consumers.overseer",
                    -- overseer = lazy.require("neotest.consumers.overseer"),
                },
                adapters = {
                    require "neotest-plenary",
                    require "neotest-rust",
                    require "neotest-dart" {
                        command = "flutter",
                    },
                    require "neotest-python" {
                        runner = "pytest",
                    },
                    require "neotest-go" {
                        experimental = {
                            test_table = true,
                        },
                    },
                },
            }
        end,
    },
}
