local highlight, icons, fn, border =
    as.highlight, as.ui.icons, vim.fn, as.ui.border
local palette = as.ui.palette

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

                        {
                            "<Localleader>db",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().toggle_breakpoint()
                            end,
                            description = "Dap: breakpoint (toggle)",
                        },
                        {
                            "<Localleader>dB",
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
                            "<Localleader>dq",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().send_to_qf()
                            end,
                            description = "Dap: get lists breakpoint on qf",
                        },
                        {
                            "<Localleader><c-b>",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().clear_breakpoints()
                            end,
                            description = "Dap: clear all breakpoints",
                        },
                        {
                            "<Localleader>dc",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().continue()
                            end,
                            description = "Dap: continue",
                        },
                        {
                            "<Localleader>d$",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().run_last()
                            end,
                            description = "Dap: last debug",
                        },
                        {
                            "<Localleader>de",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().eval()
                            end,
                            description = "Dap: evaluate",
                        },
                        {
                            "<Localleader>dr",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().repl.toggle(nil, "botright split")
                            end,
                            description = "Dap: toggle REPL",
                        },
                        {
                            "<Localleader>ds",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().session()
                            end,
                            description = "Dap: get session",
                        },
                        {
                            "<Localleader>dd",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().disconnect()
                            end,
                            description = "Dap: disconnect",
                        },
                        {
                            "<Localleader>dQ",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().close()
                            end,
                            description = "Dap: quit",
                        },
                        {
                            "<Localleader>dx",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().terminate()
                            end,
                            description = "Dap: terminate",
                        },

                        {
                            "<Localleader>de",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().step_out()
                            end,
                            description = "Dap: step-out",
                        },
                        {
                            "<Localleader>di",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().step_into()
                            end,
                            description = "Dap: step-into",
                        },
                        {
                            "<Localleader>do",
                            function()
                                local function dap()
                                    return require "dap"
                                end
                                return dap().step_over()
                            end,
                            description = "Dap: step-over",
                        },

                        {
                            "<Localleader>dU",
                            function()
                                return require("dapui").toggle()
                            end,
                            description = "Dapui: toggle UI (dapui)",
                        },
                    },
                },
            }
        end,
        dependencies = {
            { "rcarriga/nvim-dap-ui" },
            -- { "nvim-telescope/telescope-dap.nvim" },
            {
                "theHamsta/nvim-dap-virtual-text",
                config = function()
                    require("nvim-dap-virtual-text").setup { all_frames = true }
                end,
            },

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

            local function dap_UI(dap)
                require("dapui").setup {
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
            local dap = require "dap" -- Dap must be loaded before the signs can be tweaked

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

            dap_UI(dap) -- setup UI dap harus paling bawah

            -- DON'T automatically stop at exceptions
            -- dap.defaults.fallback.exception_breakpoints = {}
        end,
    },
}
