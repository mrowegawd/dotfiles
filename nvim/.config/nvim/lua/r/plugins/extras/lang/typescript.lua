local icons = as.ui.icons

return {
    -- NVIM-TREESITTER
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(
                opts.ensure_installed,
                { "javascript", "typescript", "tsx" }
            )
        end,
    },
    -- NULL-LS.NVIM
    {
        "jose-elias-alvarez/null-ls.nvim",
        -- opts = function(_, opts)
        --     table.insert(
        --         opts.sources,
        --         -- require "typescript.extensions.null-ls.code-actions"
        --     )
        -- end,
    },
    -- MASON.NVIM
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "js-debug-adapter" }) -- TODO: To configure debugging
        end,
    },
    -- NVIM-LSPCONFIG"
    {
        "neovim/nvim-lspconfig",
        dependencies = "pmizio/typescript-tools.nvim",
        opts = {
            servers = {
                tsserver = {},
            },
            setup = {
                tsserver = function(_, _)
                    local lsp_utils = require "r.plugins.lspconfig.lsp.utils"
                    lsp_utils.on_attach(function(client, buffer)
                        if client.name == "tsserver" then
                            print "yes"
                            vim.keymap.set(
                                "n",
                                "<leader>co",
                                "TypescriptOrganizeImports",
                                { buffer = buffer, desc = "Organize Imports" }
                            )
                            vim.keymap.set(
                                "n",
                                "<leader>cR",
                                "TypescriptRenameFile",
                                { desc = "Rename File", buffer = buffer }
                            )
                        end
                    end)

                    require("typescript-tools").setup {
                        settings = {
                            tsserver_file_preferences = {
                                includeInlayParameterNameHints = "all",
                                includeCompletionsForModuleExports = true,
                                includeInlayEnumMemberValueHints = true,
                                includeInlayFunctionLikeReturnTypeHints = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayVariableTypeHints = false,
                                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                                quotePreference = "auto",
                            },
                            tsserver_format_options = {
                                allowIncompleteCompletions = false,
                                allowRenameOfImportPath = false,
                            },
                        },
                    }
                    return true
                end,
            },
        },
    },
    -- NVIM-DAP
    {
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function()
            local dap = require "dap"
            if not dap.adapters["pwa-node"] then
                require("dap").adapters["pwa-node"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "node",
                        -- 💀 Make sure to update this path to point to your installation
                        args = {
                            require("mason-registry")
                                .get_package("js-debug-adapter")
                                :get_install_path()
                                .. "/js-debug/src/dapDebugServer.js",
                            "${port}",
                        },
                    },
                }
            end
            for _, language in ipairs { "typescript", "javascript" } do
                if not dap.configurations[language] then
                    dap.configurations[language] = {
                        {
                            type = "pwa-node",
                            request = "launch",
                            name = "Launch file",
                            program = "${file}",
                            cwd = "${workspaceFolder}",
                        },
                        {
                            type = "pwa-node",
                            request = "attach",
                            name = "Attach",
                            processId = require("dap.utils").pick_process,
                            cwd = "${workspaceFolder}",
                        },
                    }
                end
            end
        end,
    },
    --         ╭──────────────────────────────────────────────────────────╮
    --         │                         Related                          │
    --         ╰──────────────────────────────────────────────────────────╯
    -- IMPORT-COST.NVIM
    {
        -- Display javascript import costs inside of neovim
        "barrett-ruth/import-cost.nvim",
        build = "sh install.sh yarn",
        ft = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
        },
        config = true,
    },
    -- TSC.NVIM
    {
        -- Type checking typescript
        "dmmulroy/tsc.nvim",
        cmd = { "TSC" },
        config = function()
            require("tsc").setup()
        end,
    },
    -- PACKAGE-INFO.NVIM
    {
        "vuki656/package-info.nvim",
        event = "BufEnter package.json",
        config = function()
            require("package-info").setup {
                colors = {
                    up_to_date = "#3C4048", -- Text color for up to date package virtual text
                    outdated = "#fc514e", -- Text color for outdated package virtual text
                },
                icons = {
                    enable = true, -- Whether to display icons
                    style = {
                        up_to_date = icons.misc.check, -- Icon for up to date packages
                        outdated = icons.git.remove, -- Icon for outdated packages
                    },
                },
                autostart = true, -- Whether to autostart when `package.json` is opened
                hide_up_to_date = true, -- It hides up to date versions when displaying virtual text
                hide_unstable_versions = true, -- It hides unstable versions from version list e.g next-11.1.3-canary3

                -- Can be `npm` or `yarn`. Used for `delete`, `install` etc...
                -- The plugin will try to auto-detect the package manager based on
                -- `yarn.lock` or `package-lock.json`. If none are found it will use the
                -- provided one,                              if nothing is provided it will use `yarn`
                package_manager = "yarn",
            }
        end,
    },
}
