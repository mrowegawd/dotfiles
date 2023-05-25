local cmd, api = vim.cmd, vim.api

return {
    -- COPILOT (disabled)
    {
        "zbirenbaum/copilot.lua",
        enabled = false,
        config = function()
            require("copilot").setup {}
        end,
    },
    -- NVIM-COVERAGE
    {
        "andythigpen/nvim-coverage", -- Display test coverage information
        config = function()
            local ok, coverage = as.safe_require "coverage"
            if not ok then
                return
            end
            coverage.setup {
                commands = false,
                highlights = {
                    covered = { fg = "green" },
                    uncovered = { fg = "red" },
                },
            }
        end,
    },
    -- OVERSEER
    {
        "stevearc/overseer.nvim", -- Task runner and job management
        -- Overseer lazy loads itself
        cmd = {
            "OverseerToggle",
            "OverseerOpen",
            "OverseerInfo",
            "OverseerRun",
            "OverseerBuild",
            "OverseerClose",
            "OverseerLoadBundle",
            "OverseerSaveBundle",
            "OverseerDeleteBundle",
            "OverseerRunCmd",
            "OverseerQuickAction",
            "OverseerTaskAction",
        },
        init = function()
            as.augroup("RunOverseerTasks", {
                event = { "FileType" },
                pattern = as.lspfiles,
                command = function()
                    require("r.mappings.utils.overseer").run_task(
                        api.nvim_get_current_buf()
                    )
                end,
            })

            require("legendary").keymaps {
                {
                    itemgroup = "Task runner",
                    icon = as.ui.icons.misc.run_program,
                    description = "A task runner and job management plugin",
                    keymaps = {

                        {
                            "<Leader>oo",
                            function()
                                require("r.utils.tiling").force_win_close(
                                    { "neo-tree", "undotree" },
                                    false
                                )
                                return cmd "OverseerToggle"
                            end,
                            description = "Overseer toggle",
                        },

                        {
                            "<Leader>ol",
                            "<Cmd>OverseerQuickAction open vsplit<CR>",
                            description = "Overseer open repl vsplit",
                        },

                        -- {
                        --     "<Leader>ol",
                        --     "<CMD>OverseerLoadBundle<CR>",
                        --     description = "Overseer load bundle",
                        -- },

                        -- {
                        --     "<Leader>ob",
                        --     "<CMD>OverseerBuild<CR>",
                        --     description = "Overseer build",
                        -- },

                        {
                            "<Leader>oa",
                            "<CMD>OverseerQuickAction<CR>",
                            description = "Overseer quick action",
                        },

                        {
                            "<Leader>ot",
                            "<CMD>OverseerTaskAction<CR>",
                            description = "Overseer task action",
                        },
                    },
                },
            }
        end,
        config = function()
            local overseer = require "overseer"

            overseer.setup {
                -- strategy = "toggleterm",
                strategy = { "toggleterm", open_on_start = true },
                templates = { "builtin", "r" },
                default_template_prompt = "avoid",
                component_aliases = {
                    log = {
                        {
                            type = "echo",
                            level = vim.log.levels.WARN,
                        },
                        {
                            type = "file",
                            filename = "overseer.log",
                            level = vim.log.levels.DEBUG,
                        },
                    },
                    --         default_neotest = {
                    --             "on_output_summarize",
                    --             "on_exit_set_status",
                    --             "on_complete_dispose",
                    --         },
                },
                --
                --     task_editor = {
                --         bindings = {
                --             i = {
                --                 ["<Esc>"] = "<Cmd>quit<CR>",
                --             },
                --             n = {
                --                 ["q"] = "<Cmd>quit<CR>",
                --             },
                --         },
                --     },
                --
                task_list = {
                    --         -- Default detail level for tasks. Can be 1-3.
                    --         default_detail = 1,
                    --         -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                    --         -- min_width and max_width can be a single value or a list of mixed integer/float types.
                    --         -- max_width = {100, 0.2} means "the lesser of 100 columns or 20% of total"
                    --         max_width = { 100, 0.2 },
                    --         -- min_width = {40, 0.1} means "the greater of 40 columns or 10% of total"
                    --         min_width = { 40, 0.1 },
                    --         -- optionally define an integer/float for the exact width of the task list
                    --         width = nil,
                    --         -- String that separates tasks
                    --         separator = "────────────────────────────────────────",
                    --         -- Default direction. Can be "left" or "right"
                    --         direction = "left",
                    --         -- Set keymap to false to remove default behavior
                    --         -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
                    bindings = {
                        ["?"] = "ShowHelp",
                        ["<CR>"] = "RunAction",
                        ["<C-e>"] = "Edit",
                        ["o"] = "Open",
                        ["<C-v>"] = "OpenVsplit",
                        ["<C-s>"] = "OpenSplit",
                        ["<C-f>"] = "OpenFloat",
                        ["P"] = "TogglePreview",
                        ["<right>"] = "IncreaseDetail",
                        ["<left>"] = "DecreaseDetail",
                        ["L"] = "IncreaseAllDetail",
                        ["H"] = "DecreaseAllDetail",
                        ["["] = nil,
                        ["]"] = nil,
                        ["{"] = "PrevTask",
                        ["}"] = "NextTask",
                    },
                },
            }
            -- overseer.add_template_hook(
            --     { module = "^npm$" },
            --     function(task_defn, util)
            --         util.add_component(task_defn, {
            --             "on_output_parse",
            --             parser = {
            --                 diagnostics = {
            --                     {
            --                         "extract",
            --                         "([^%s].*):(%d+):(%d+) - (.*)$",
            --                         "filename",
            --                         "lnum",
            --                         "col",
            --                         "text",
            --                     },
            --                 },
            --             },
            --         })
            --     end
            -- )
            --
            -- vim.api.nvim_create_user_command(
            --     "OverseerDebugParser",
            --     'lua require("overseer").debug_parser()',
            --     {}
            -- )
        end,
    },
    -- SCRATCH
    {
        "LintaoAmons/scratch.nvim",
        cmd = { "Scratch", "ScratchOpen" },
        -- config = function() end,
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Misc",
                    keymaps = {
                        {
                            "<Leader>sO",
                            "<CMD>Scratch<CR>",
                            description = "Scratch: open",
                        },
                        {
                            "<Leader>so",
                            "<CMD>ScratchOpen<CR>",
                            description = "Scratch: open list",
                        },
                    },
                },
            }
        end,
    },
}
