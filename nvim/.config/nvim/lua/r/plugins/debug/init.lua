local highlight, icons, fn, border =
    as.highlight, as.ui.icons, vim.fn, as.ui.border
local palette = as.ui.palette

local isDapRunning = false

return {
    -- NVIM DAP
    {
        "mfussenegger/nvim-dap",
        event = "BufReadPre",
        init = function()
            require("legendary").keymaps {

                {
                    itemgroup = "Debug",
                    icon = as.ui.icons.misc.bug,
                    description = "Debug functionality",
                    keymaps = {

                        --  +----------------------------------------------------------+
                        --    Breakpoints

                        {
                            "<localleader>db",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().toggle_breakpoint()
                            end,
                            description = "Dap: breakpoint (toggle)",
                        },
                        {
                            "<localleader>dL",
                            function()
                                require("dap").set_breakpoint(
                                    nil,
                                    nil,
                                    fn.input "Log point message: "
                                )
                            end,
                            desc = "dap: log breakpoint",
                        },
                        {
                            "<localleader>dB",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().set_breakpoint(
                                    fn.input "Breakpoint condition: "
                                )
                            end,
                            description = "Dap: breakpoint with condition",
                        },

                        {
                            "<localleader>dC",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().clear_breakpoints()
                            end,
                            description = "Dap: clear all breakpoints",
                        },

                        --  +----------------------------------------------------------+
                        --    DAP commands
                        {

                            "<localleader>dc",
                            function()
                                if isDapRunning then
                                    local function dap()
                                        return require "dap"
                                    end
                                    return dap().continue()
                                else
                                    as.warn(
                                        "Run debug with: <localleader>dd",
                                        "DAP"
                                    )
                                end
                            end,
                            description = "Dap: continue or start debugging",
                        },

                        -- {
                        --     "<localleader>dR",
                        --     function()
                        --         require("dap").run_to_cursor()
                        --     end,
                        --     description = "Dap: Run to Cursor",
                        -- },
                        {
                            "<localleader>dl",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().run_last()
                            end,
                            description = "Dap: run last",
                        },
                        {
                            "<localleader>de",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().eval()
                            end,
                            description = "Dap: evaluate",
                        },
                        -- {
                        --     "<localleader>dr",
                        --     function()
                        --         local function dap()
                        --             return require "dap"
                        --         end
                        --         return dap().repl.toggle(nil, "botright split")
                        --     end,
                        --     description = "Dap: toggle REPL",
                        -- },
                        {
                            "<localleader>dS",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().session()
                            end,
                            description = "Dap: get session",
                        },

                        --  +----------------------------------------------------------+
                        --    UI DAP

                        {
                            "<localleader>dt",
                            function()
                                return require("dapui").toggle()
                            end,
                            description = "Dapui: toggle UI (dapui)",
                        },

                        {
                            "<localleader>dr",
                            function()
                                return require("dapui").open { reset = true }
                            end,
                            description = "Dapui: Reset UI (dapui)",
                        },

                        --  +----------------------------------------------------------+
                        --    Close and run debug

                        {
                            "<localleader>dd",
                            function()
                                if not isDapRunning then
                                    local function dap()
                                        return require "dap"
                                    end
                                    isDapRunning = true
                                    return dap().continue()
                                else
                                    local function dap()
                                        return require "dap"
                                    end
                                    isDapRunning = false
                                    return dap().disconnect()
                                end
                            end,
                            description = "Dap: disconnect",
                        },
                        {
                            "<localleader>dq",
                            function()
                                if isDapRunning then
                                    local function dap()
                                        return require "dap"
                                    end
                                    isDapRunning = false
                                    return dap().close()
                                end
                            end,
                            description = "Dap: quit",
                        },
                        -- {
                        --     "<localleader>dx",
                        --     function()
                        --         local function dap()
                        --             return require "dap"
                        --         end
                        --         return dap().terminate()
                        --     end,
                        --     description = "Dap: terminate",
                        -- },

                        --  +----------------------------------------------------------+
                        --    Step-in, step-out, step-over
                        --    For definition of these, check: https://stackoverflow.com/questions/3580715/what-is-the-difference-between-step-into-and-step-over-in-a-debugger

                        {
                            "<s-right>",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().step_into()
                            end,
                            description = "Dap: step-into",
                        },

                        {
                            "<s-left>",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().step_out()
                            end,
                            description = "Dap: step-out",
                        },
                        {
                            "<s-down>",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().step_over()
                            end,
                            description = "Dap: step-over",
                        },
                    },
                },
            }
        end,
        dependencies = {
            { "rcarriga/nvim-dap-ui" },
            { "theHamsta/nvim-dap-virtual-text" },
            { "mfussenegger/nvim-dap-python" },
            { "leoluz/nvim-dap-go" },
            { "mxsdev/nvim-dap-vscode-js" },
            {
                "microsoft/vscode-js-debug",
                build = "npm install --legacy-peer-deps && npm run compile",
            },
        },
        config = function()
            local function configure_debuggers()
                require("r.plugins.debug.servers.python").setup()
                require("r.plugins.debug.servers.lua").setup()
                require("r.plugins.debug.servers.javascript").setup()

                vim.api.nvim_create_autocmd("FileType", {
                    pattern = "dap-repl",
                    callback = function()
                        require("dap.ext.autocompl").attach()
                    end,
                })
            end

            local function dap_UI(dapui, dap)
                dapui.setup {
                    -- expand_lines = fn.has "nvim-0.7",
                    mappings = {
                        expand = { "<CR>", "<2-LeftMouse>" },
                        open = "o",
                        remove = "d",
                        edit = "e",
                        repl = "r",
                        toggle = "t",
                    },
                    layouts = {
                        {
                            elements = {
                                -- Elements can be strings or table with id and size keys.
                                { id = "scopes", size = 0.25 },
                                "breakpoints",
                                "stacks",
                                "watches",
                            },
                            size = 40, -- 40 columns
                            position = "right",
                        },
                        {
                            elements = {
                                "repl",
                                "console",
                            },
                            size = 0.25, -- 25% of total lines
                            position = "bottom",
                        },
                    },
                    floating = {
                        max_height = nil, -- These can be integers or a float between 0 and 1.
                        max_width = nil, -- Floats will be treated as percentage of your screen.
                        border = border.rectangle, -- Border style. Can be "single", "double" or "rounded"
                        mappings = {
                            close = { "q", "<Esc>" },
                        },
                    },
                    windows = { indent = 1 },
                    render = {
                        max_type_length = nil, -- Can be integer or nil.
                    },
                }

                local exclusions = { "dart" }

                dap.listeners.after.event_initialized["dapui_config"] = function(
                )
                    if vim.tbl_contains(exclusions, vim.bo.filetype) then
                        return
                    end
                    require("dapui").open()
                    vim.api.nvim_exec_autocmds(
                        "User",
                        { pattern = "DapStarted" }
                    )
                end

                dap.listeners.before.event_terminated["dapui_config"] = function(
                )
                    require("dapui").close()
                end

                dap.listeners.before.event_exited["dapui_config"] = function()
                    require("dapui").close()
                end
            end

            -------------------------------------------------------------------
            -- Setup
            -------------------------------------------------------------------

            local present_dapui, dapui = pcall(require, "dapui")
            local present_dap, dap = pcall(require, "dap")
            local present_virtual_text, dap_vt =
                pcall(require, "nvim-dap-virtual-text")
            if
                not present_dapui
                or not present_dap
                or not present_virtual_text
            then
                return
            end

            dap_vt.setup {
                enabled = true, -- enable this plugin (the default)
                enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                show_stop_reason = true, -- show stop reason when stopped for exceptions
                commented = false, -- prefix virtual text with comment string
                only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
                all_references = false, -- show virtual text on all all references of the variable (not only definitions)
                filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
                -- Experimental Features:
                virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
                all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
                virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
            }

            highlight.plugin("dap", {
                { DapBreakpoint = { fg = palette.light_red } },
                { DapStopped = { fg = palette.green } },
            })

            configure_debuggers()
            fn.sign_define {
                {
                    name = "DapBreakpoint",
                    text = icons.dap.breakpoint,
                    texthl = "DapBreakpoint",
                    linehl = "",
                    numhl = "",
                },
                {
                    name = "DapStopped",
                    text = icons.dap.breakpoint_stoped,
                    texthl = "DapStopped",
                    linehl = "",
                    numhl = "",
                },
            }

            -- Setup DAP UI harus dicall paling bawah
            dap_UI(dapui, dap)
        end,
    },
}
