-- local ufo_config_handler = require("r.utils").ufo_handler

local util = require "lspconfig/util"

local M = {}

local function get_python_path(workspace)
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    end

    -- Check for a poetry.lock file
    local crmatch = vim.fn.glob(util.path.join(workspace, "poetry.lock"))
    if crmatch ~= "" then
        local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
        return util.path.join(venv, "bin", "python")
    end

    -- Find and use virtualenv from pipenv in workspace directory.
    local match = vim.fn.glob(util.path.join(workspace, "Pipfile"))
    if match ~= "" then
        local venv = vim.fn.trim(
            vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv")
        )
        return util.path.join(venv, "bin", "python")
    end

    -- Fallback to system Python.
    return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

M.servers = {
    tailwindcss = {
        init_options = {
            userLanguages = {
                eelixir = "html-eex",
                eruby = "erb",
            },
        },
        on_attach = function(client, bufnr)
            if client.server_capabilities.colorProvider then
                require("lsp/utils/documentcolors").buf_attach(bufnr)
                require("colorizer").attach_to_buffer(bufnr, {
                    mode = "background",
                    css = true,
                    names = false,
                    tailwind = false,
                })
            end
        end,
        filetypes = {
            "html",
            "mdx",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "svelte",
        },
        settings = {
            tailwindCSS = {
                lint = {
                    cssConflict = "warning",
                    invalidApply = "error",
                    invalidConfigPath = "error",
                    invalidScreen = "error",
                    invalidTailwindDirective = "error",
                    invalidVariant = "error",
                    recommendedVariantOrder = "warning",
                },
                experimental = {
                    classRegex = {
                        "tw`([^`]*)",
                        'tw="([^"]*)',
                        'tw={"([^"}]*)',
                        "tw\\.\\w+`([^`]*)",
                        "tw\\(.*?\\)`([^`]*)",
                        { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                        { "classnames\\(([^)]*)\\)", "'([^']*)'" },
                        { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                    },
                },
                validate = true,
            },
        },
    },
    eslint = {
        settings = {
            codeAction = {
                disableRuleComment = {
                    enable = true,
                    location = "separateLine",
                },
                showDocumentation = {
                    enable = true,
                },
            },
            codeActionOnSave = {
                enable = false,
                mode = "all",
            },
            format = true,
            nodePath = "",
            onIgnoredFiles = "off",
            packageManager = "npm",
            quiet = false,
            rulesCustomizations = {},
            run = "onType",
            useESLintClass = false,
            validate = "on",
            workingDirectory = {
                mode = "location",
            },
        },
    },
    cssls = {
        settings = {
            css = {
                lint = {
                    unknownAtRules = "ignore",
                },
            },
            scss = {
                lint = {
                    unknownAtRules = "ignore",
                },
            },
        },
        on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = true
            client.server_capabilities.documentRangeFormattingProvider = true
        end,
    },
    html = {},
    jsonls = {
        on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas
                or {}
            vim.list_extend(
                new_config.settings.json.schemas,
                require("schemastore").json.schemas()
            )
        end,
        settings = {
            json = {
                format = {
                    enable = true,
                },
                validate = { enable = true },
            },
        },
    },
    sqlls = {},
    bashls = {},
    vimls = {},
    ansiblels = {},
    terraformls = {},
    pyright = {
        on_init = function(client)
            client.config.settings.python.pythonPath =
                get_python_path(client.config.root_dir)
        end,
    },
    ruff_lsp = {},
    prosemd_lsp = {},
    docker_compose_language_service = {},
    graphql = {
        on_attach = function(client)
            -- Disable workspaceSymbolProvider because this prevents
            -- searching for symbols in typescript files which this server
            -- is also enabled for.
            -- @see: https://github.com/nvim-telescope/telescope.nvim/issues/964
            client.server_capabilities.workspaceSymbolProvider = false
        end,
    },
    --- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    gopls = {
        settings = {
            gopls = {
                gofumpt = true,
                codelenses = {
                    generate = true,
                    gc_details = false,
                    test = true,
                    tidy = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                analyses = {
                    unusedparams = true,
                },
                semanticTokens = true,
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-node_modules" },
            },
        },
    },
    -- sourcekit = {
    --     filetypes = { "swift", "objective-c", "objective-cpp" },
    -- },
    yamlls = {
        settings = {
            yaml = {
                customTags = {
                    "!reference sequence", -- necessary for gitlab-ci.yaml files
                },
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                codeLens = { enable = true },
                hint = {
                    enable = true,
                    arrayIndex = "Disable",
                    setType = true,
                    paramName = "Disable",
                },
                format = { enable = false },
                diagnostics = {
                    globals = {
                        "vim",
                        "P",
                        "describe",
                        "it",
                        "as",
                        "before_each",
                        "after_each",
                        "packer_plugins",
                        "pending",
                    },
                },
                completion = {
                    keywordSnippet = "Replace",
                    callSnippet = "Replace",
                },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    },
}

---Get the configuration for a specific language server
---@param name string?
---@return table<string, any>?
M.setup = function(name)
    local config = name and M.servers[name] or {}

    if not config then
        return
    end

    if type(config) == "function" then
        config = config()
    end

    local ok, cmp_nvim_lsp = as.pcall(require, "cmp_nvim_lsp")

    if ok then
        config.capabilities = cmp_nvim_lsp.default_capabilities()
    end

    config.capabilities =
        vim.tbl_deep_extend("keep", config.capabilities or {}, {
            workspace = {
                didChangeWatchedFiles = { dynamicRegistration = true },
            },
            textDocument = {
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                },
            },
        })

    -- require("ufo").setup {
    --     fold_virt_text_handler = ufo_config_handler,
    --     close_fold_kinds = { "imports" },
    -- }

    return config
end

return M
