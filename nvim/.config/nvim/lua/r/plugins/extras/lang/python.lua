return {
    -- NVIM-TREESITTER
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(
                opts.ensure_installed,
                { "python", "ninja", "rst", "toml" }
            )
        end,
    },
    -- NULL-LS.NVIM
    {
        "jose-elias-alvarez/null-ls.nvim",
        opts = function(_, opts)
            local nls = require "null-ls"
            table.insert(opts.sources, nls.builtins.formatting.black)

            -- PYTHON
            -- nls.builtins.diagnostics.pylint,
            -- nls.builtins.diagnostics.mypy,
            -- nls.builtins.formatting.isort,
            -- nls.builtins.formatting.black,
        end,
    },
    -- MASON.NVIM
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(
                opts.ensure_installed,
                { "debugpy", "black", "ruff" }
            )
        end,
    },
    -- NVIM-LSPCONFIG"
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                autoImportCompletions = true,
                                typeCheckingMode = "off",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "openFilesOnly", -- "openFilesOnly" or "openFilesOnly"
                                stubPath = vim.fn.stdpath "data"
                                    .. "/lazy/python-type-stubs/stubs",
                            },
                        },
                    },
                },
                ruff_lsp = {},
            },
            setup = {
                ruff_lsp = function()
                    local lsp_utils = require "r.plugins.lspconfig.lsp.utils"
                    lsp_utils.on_attach(function(client, _)
                        if client.name == "ruff_lsp" then
                            -- Disable hover in favor of Pyright
                            client.server_capabilities.hoverProvider = false
                        end
                    end)
                end,
                pyright = function(_, _)
                    local lsp_utils = require "r.plugins.lspconfig.lsp.utils"
                    lsp_utils.on_attach(function(client, buffer)
                        if client.name == "pyright" then
                            vim.keymap.set("n", "<leader>tC", function()
                                require("dap-python").test_class()
                            end, {
                                buffer = buffer,
                                desc = "Testing: debug Class",
                            })
                            vim.keymap.set("n", "<leader>tM", function()
                                require("dap-python").test_method()
                            end, {
                                buffer = buffer,
                                desc = "Testing: debug Method",
                            })
                            vim.keymap.set("v", "<leader>tS", function()
                                require("dap-python").debug_selection()
                            end, {
                                buffer = buffer,
                                desc = "Testing: debug selection",
                            })
                        end
                    end)
                end,
            },
        },
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = {
            "nvim-neotest/neotest-python",
        },
        opts = {
            adapters = {
                ["neotest-python"] = {
                    -- Here you can specify the settings for the adapter, i.e.
                    runner = "pytest",
                    -- python = ".venv/bin/python",
                },
            },
        },
    },
    -- NVIM-DAP
    {
        "mfussenegger/nvim-dap",
        dependencies = { "mfussenegger/nvim-dap-python" },
        opts = {
            setup = {
                debugpy = function(_, _)
                    require("dap-python").setup("python", {})
                    table.insert(require("dap").configurations.python, {
                        type = "python",
                        request = "attach",
                        connect = {
                            port = 5678,
                            host = "127.0.0.1",
                        },
                        mode = "remote",
                        name = "container attach debug",
                        cwd = vim.fn.getcwd(),
                        pathmappings = {
                            {
                                localroot = function()
                                    return vim.fn.input(
                                        "local code folder > ",
                                        vim.fn.getcwd(),
                                        "file"
                                    )
                                end,
                                remoteroot = function()
                                    return vim.fn.input(
                                        "container code folder > ",
                                        "/",
                                        "file"
                                    )
                                end,
                            },
                        },
                    })
                end,
            },
        },
    },
    --         ╭──────────────────────────────────────────────────────────╮
    --         │                         Related                          │
    --         ╰──────────────────────────────────────────────────────────╯
    -- VENV-SELECTOR
    {
        "linux-cultist/venv-selector.nvim",
        enabled = false,
        event = "VeryLazy",
        config = function()
            local venv = require "venv-selector.venv"
            local venv_selector = require "venv-selector"

            venv_selector.setup {
                search = false,
                notify_user_on_activate = false,
            }

            _G.Venv = {}

            local function auto_poetry_venv()
                if vim.env.VIRTUAL_ENV then
                    if vim.b.poetry_venv == vim.env.VIRTUAL_ENV then
                        -- Active venv is equal to current so there is nothing to do
                        return
                    elseif
                        vim.b.poetry_venv == nil
                        and next(_G.Venv.active_venv) ~= nil
                        and vim.tbl_contains(
                            _G.Venv.active_venv.project_files,
                            vim.api.nvim_buf_get_name(0)
                        )
                    then
                        -- Current file belongs to the project of the active env then simply
                        -- set the buffer cache variable since we can reuse the existing venv
                        vim.b.poetry_venv = _G.Venv.active_venv.venv_path
                        return
                    else
                        venv_selector.deactivate_venv()
                        _G.Venv.active_venv = {}
                    end
                end

                -- Save working dir and cd to window cwd (lcd) to ensure system call works
                local lwd = vim.uv.cwd()
                vim.cmd "lcd %:p:h"

                -- If there is no active venv look for one (but just once)
                if vim.b.poetry_venv == nil then
                    local poetry_path =
                        vim.fn.trim(vim.fn.system "poetry env info --path")
                    if vim.v.shell_error ~= 1 then
                        vim.b.poetry_venv = poetry_path
                        -- Also store (cache) project root and all py files in the project
                        local project_root = vim.fn.fnamemodify(
                            vim.fn.findfile(
                                "pyproject.toml",
                                vim.fn.getcwd() .. ";"
                            ),
                            ":p:h"
                        )
                        local py_files = vim.fs.find(function(name)
                            return name:match ".*%.py$"
                        end, {
                            limit = math.huge,
                            type = "file",
                            path = project_root,
                        })
                        _G.Venv.active_venv = {
                            project_root = project_root,
                            project_files = py_files,
                            venv_path = poetry_path,
                        }
                    else
                        vim.b.poetry_venv = "none"
                    end
                end

                -- Actually activate the venv if it exists/was found
                if vim.b.poetry_venv ~= "none" then
                    local path = {}
                    path.value = vim.b.poetry_venv
                    venv.set_venv_and_system_paths(path)
                    venv.cache_venv(path)
                end
                vim.cmd("lcd " .. lwd)
            end

            -- Auto-activate
            vim.api.nvim_create_autocmd({ "BufEnter" }, {
                group = vim.api.nvim_create_augroup(
                    "poetry_venv_auto",
                    { clear = true }
                ),
                pattern = { "*.py" },
                callback = function()
                    if not string.match(vim.fn.expand "%:p", ".git/") then
                        auto_poetry_venv()
                    end
                end,
            })
        end,
        dependencies = {
            -- for DAP support
            "mfussenegger/nvim-dap-python",
        },
    },
}
