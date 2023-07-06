local highlight, icons, fn, border =
    as.highlight, as.ui.icons, vim.fn, as.ui.border

local palette = as.ui.palette

return {
    -- NVIM DAP
    {
        "mfussenegger/nvim-dap",
        keys = {

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
                desc = "Debug(dap): breakpoint (toggle)",
            },
            -- {
            --     "<localleader>dL",
            --     function()
            --         require("dap").set_breakpoint(
            --             nil,
            --             nil,
            --             fn.input "Log point message: "
            --         )
            --     end,
            --     desc = "Debug(dap): log breakpoint",
            -- },
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
                desc = "Debug(dap): breakpoint with condition",
            },

            {
                "<localleader>dC",
                function()
                    local function dap()
                        return require "dap"
                    end
                    return dap().clear_breakpoints()
                end,
                desc = "Debug(dap): clear all breakpoints",
            },

            --  +----------------------------------------------------------+
            --    DAP commands
            {

                "<localleader>dc",
                function()
                    if as.isDebugRunning then
                        local function dap()
                            return require "dap"
                        end
                        return dap().continue()
                    else
                        as.warn("Run debug with: <localleader>dd", "DAP")
                    end
                end,
                desc = "Debug(dap): continue or start debugging",
            },

            {
                "<localleader>dR",
                function()
                    require("dap").run_to_cursor()
                end,
                desc = "Debug(dap): Run to Cursor",
            },
            {
                "<localleader>dl",
                function()
                    local function dap()
                        return require "dap"
                    end
                    return dap().run_last()
                end,
                desc = "Debug(dap): run last",
            },
            {
                "<localleader>de",
                function()
                    local function dap()
                        return require "dap"
                    end
                    return dap().eval()
                end,
                desc = "Debug(dap): evaluate",
            },
            -- {
            --     "<localleader>dr",
            --     function()
            --         local function dap()
            --             return require "dap"
            --         end
            --         return dap().repl.toggle(nil, "botright split")
            --     end,
            --     desc = "Dap: toggle REPL",
            -- },
            {
                "<localleader>dS",
                function()
                    local function dap()
                        return require "dap"
                    end
                    return print(dap().session())
                end,
                desc = "Debug(dap): get session",
            },

            --  +----------------------------------------------------------+
            --    UI DAP

            {
                "<localleader>dt",
                function()
                    return require("dapui").toggle()
                end,
                desc = "Debug(dapui): toggle UI (dapui)",
            },

            {
                "<localleader>dr",
                function()
                    return require("dapui").open { reset = true }
                end,
                desc = "Debug(dapui): Reset UI (dapui)",
            },

            --  +----------------------------------------------------------+
            --    Close and run debug

            {
                "<localleader>dd",
                function()
                    if not as.isDebugRunning then
                        local function dap()
                            return require "dap"
                        end
                        as.isDebugRunning = true
                        return dap().continue()
                    else
                        local function dap()
                            return require "dap"
                        end
                        as.isDebugRunning = false
                        return dap().disconnect()
                    end
                end,
                desc = "Debug(dap): disconnect",
            },
            {
                "<localleader>dq",
                function()
                    if as.isDebugRunning then
                        local function dap()
                            return require "dap"
                        end
                        as.isDebugRunning = false
                        return dap().close()
                    end
                end,
                desc = "Debug(dap): quit",
            },
            -- {
            --     "<localleader>dx",
            --     function()
            --         local function dap()
            --             return require "dap"
            --         end
            --         return dap().terminate()
            --     end,
            --     desc = "Dap: terminate",
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
                desc = "Debug(dap): step-into",
            },

            {
                "<s-left>",
                function()
                    local function dap()
                        return require "dap"
                    end
                    return dap().step_out()
                end,
                desc = "Debug(dap): step-out",
            },
            {
                "<s-down>",
                function()
                    local function dap()
                        return require "dap"
                    end
                    return dap().step_over()
                end,
                desc = "Debug(dap): step-over",
            },
        },
        dependencies = {
            { "rcarriga/nvim-dap-ui" },
            { "theHamsta/nvim-dap-virtual-text" },
            { "LiadOz/nvim-dap-repl-highlights", opts = {} },

            { "jbyuki/one-small-step-for-vimkind" }, -- debug for lua
        },
        opts = {
            setup = {
                osv = function(_, _)
                    local dap = require "dap"
                    dap.configurations.lua = {
                        {
                            type = "nlua",
                            request = "attach",
                            name = "Attach to running Neovim instance",
                            host = function()
                                local value = vim.fn.input "Host [127.0.0.1]: "
                                if value ~= "" then
                                    return value
                                end
                                return "127.0.0.1"
                            end,
                            port = function()
                                local val =
                                    tonumber(vim.fn.input("Port: ", "8086"))
                                assert(val, "Please provide a port number")
                                return val
                            end,
                        },
                    }

                    dap.adapters.nlua = function(callback, config)
                        callback {
                            type = "server",
                            host = config.host,
                            port = config.port,
                        }
                    end
                end,
            },
        },
        config = function(plugin, opts)
            highlight.plugin("dap", {
                { DapBreakpoint = { fg = palette.light_red } },
                { DapStopped = { fg = palette.green } },
            })

            -- vim.api.nvim_create_autocmd("FileType", {
            --     pattern = "dap-repl",
            --     callback = function()
            --         require("dap.ext.autocompl").attach()
            --     end,
            -- })

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
            -- dap_UI(dapui, dap)

            -- for name, sign in pairs(icons.dap) do
            --     sign = type(sign) == "table" and sign or { sign }
            --     vim.fn.sign_define("Dap" .. name, {
            --         text = sign[1],
            --         texthl = sign[2] or "DiagnosticInfo",
            --         linehl = sign[3],
            --         numhl = sign[3],
            --     })
            -- end

            require("nvim-dap-virtual-text").setup {
                commented = true,
            }

            local dap, dapui = require "dap", require "dapui"
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

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- set up debugger
            for k, _ in pairs(opts.setup) do
                opts.setup[k](plugin, opts)
            end
        end,
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            automatic_setup = true,
            handlers = {},
            ensure_installed = {},
        },
    },
}
