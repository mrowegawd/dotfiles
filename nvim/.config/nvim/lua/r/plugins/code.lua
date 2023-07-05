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
        dependencies = "nvim-lua/plenary.nvim",
        cmd = {
            "Coverage",
            "CoverageSummary",
            "CoverageLoad",
            "CoverageShow",
            "CoverageHide",
            "CoverageToggle",
            "CoverageClear",
        },
        config = function()
            require("coverage").setup {
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
                    -- require("legendary").keymaps {
                    --     {
                    --         itemgroup = "Task runner",
                    --         keymaps = {
                    --
                    --             {
                    --                 "<F4>",
                    --                 function()
                    --                     local overseer = require "overseer"
                    --                     local tasks = overseer.list_tasks {
                    --                         recent_first = true,
                    --                     }
                    --                     if vim.tbl_isempty(tasks) then
                    --                         return vim.notify(
                    --                             "No tasks found",
                    --                             vim.log.levels.WARN
                    --                         )
                    --                     else
                    --                         return overseer.run_action(
                    --                             tasks[1],
                    --                             "restart"
                    --                         )
                    --                     end
                    --                 end,
                    --                 description = "Overseer: run or restart the task",
                    --                 opts = {
                    --                     buffer = api.nvim_get_current_buf(),
                    --                 },
                    --             },
                    --
                    --             {
                    --                 "<F1>",
                    --                 function()
                    --                     if
                    --                         vim.bo.filetype ~= "OverseerList"
                    --                     then
                    --                         return cmd "OverseerRun"
                    --                     end
                    --                     return cmd "OverseerQuickAction"
                    --                 end,
                    --                 description = "Overseer: run quick action",
                    --                 opts = {
                    --                     buffer = api.nvim_get_current_buf(),
                    --                 },
                    --             },
                    --         },
                    --     },
                    -- }
                end,
            })
        end,
        keys = {

            {
                "<Leader>oo",
                function()
                    require("r.utils.tiling").force_win_close(
                        { "neo-tree", "undotree" },
                        false
                    )
                    return cmd "OverseerToggle"
                end,
                desc = "Overseer: toggle",
            },

            {
                "<Leader>ol",
                "<Cmd>OverseerQuickAction open vsplit<CR>",
                desc = "Overseer: open repl vsplit",
            },

            {
                "<Leader>oa",
                "<CMD>OverseerQuickAction<CR>",
                desc = "Overseer: quick action",
            },

            {
                "<Leader>ot",
                "<CMD>OverseerTaskAction<CR>",
                desc = "Overseer: task action",
            },
        },
        config = function()
            require("overseer").setup {
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
    -- IRON.NVIM
    {
        "hkupty/iron.nvim",
        init = function()
            vim.g.iron_map_defaults = 0
            vim.g.iron_map_extended = 0
        end,
        event = "VeryLazy",
        cmd = { "IronRepl", "IronRestart", "IronHide" },
        keys = {
            -- {
            --     "<Leader>rr",
            --     function()
            --         if not isIronShow then
            --             isIronShow = true
            --             return vim.cmd.IronRepl()
            --         else
            --             isIronShow = false
            --             return vim.cmd.IronHide()
            --         end
            --     end,
            --     desc = "Iron: open repl",
            -- },
            {
                "<Leader>rR",
                "<CMD>IronRestart<CR>",
                desc = "Iron: restart repl",
            },

            {
                "rm",
                function()
                    require("iron.core").run_motion "send_motion"
                end,
                desc = "Iron: send motion",
            },
            {
                "rl",
                function()
                    require("iron.core").visual_send()
                    -- require("iron.core").send(nil, string.char(13))
                end,
                desc = "Iron: send visual",
                mode = { "v" },
            },

            {
                "rf",
                function()
                    require("iron.core").send_file()
                end,
                desc = "Iron: send file",
            },

            {
                "rl",
                function()
                    require("iron.core").send_line()
                end,
                desc = "Iron: send line",
            },
            {
                "r<cr>",
                function()
                    require("iron.core").send(nil, string.char(13))
                end,
                desc = "Iron: send (ENTER)",
            },

            {
                "ri",
                function()
                    require("iron.core").send(nil, string.char(03))
                end,
                desc = "Iron: send (interrupt)",
            },

            {
                "rc",
                function()
                    require("iron.core").send(nil, string.char(12))
                end,
                desc = "Iron: clear",
            },

            {
                "<leader>rL",
                function()
                    require("iron.core").send_until_cursor()
                end,
                desc = "Iron: run until cursor",
            },
        },
        config = function()
            require("iron.core").setup {
                config = {
                    -- Whether a repl should be discarded or not
                    scratch_repl = true,
                    -- Your repl definitions come here
                    repl_definition = {
                        sh = {
                            command = { "zsh" },
                        },
                        python = require("iron.fts.python").python,
                    },

                    repl_open_cmd = "vertical botright 80 split",
                    buflisted = false,
                },
                -- If the highlight is on, you can change how it looks
                -- For the available options, check nvim_set_hl
                highlight = {
                    italic = true,
                },

                -- keymaps = {
                --     send_motion = "rl",
                --     visual_send = "sl",
                --     send_file = "<space>sf",
                --     send_line = "<space>sl",
                --     send_until_cursor = "<space>su",
                --     send_mark = "<space>sm",
                --     mark_motion = "<space>mc",
                --     mark_visual = "<space>mc",
                --     remove_mark = "<space>md",
                --     cr = "<space>s<cr>",
                --     interrupt = "<space>s<space>",
                --     exit = "<space>sq",
                --     clear = "<space>cl",
                -- },
                ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
            }
        end,
    },
    -- SCRATCH
    {
        "LintaoAmons/scratch.nvim",
        cmd = { "Scratch", "ScratchOpen" },
        keys = {

            {
                "<Leader>sO",
                "<CMD>Scratch<CR>",
                desc = "Scratch: open",
            },
            {
                "<Leader>so",
                "<CMD>ScratchOpen<CR>",
                desc = "Scratch: open list",
            },
        },
    },
}
