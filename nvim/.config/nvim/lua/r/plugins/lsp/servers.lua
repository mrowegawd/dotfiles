local M = {}

M.servers = {
    ansiblels = {},
    sqlls = {},
    eslint = {},
    -- ccls = {},
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

    bashls = {},
    vimls = {},
    terraformls = {},
    marksman = {},
    pyright = {},
    -- bufls = {},
    prosemd_lsp = {},
    docker_compose_language_service = {},
    vtsls = {
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },
    -- tsserver = {
    --     settings = {
    --         typescript = {
    --             inlayHints = {
    --                 includeInlayParameterNameHints = "all",
    --                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    --                 includeInlayFunctionParameterTypeHints = true,
    --                 includeInlayVariableTypeHints = false,
    --                 includeInlayPropertyDeclarationTypeHints = true,
    --                 includeInlayFunctionLikeReturnTypeHints = true,
    --                 includeInlayEnumMemberValueHints = true,
    --             },
    --         },
    --         javascript = {
    --             inlayHints = {
    --                 includeInlayParameterNameHints = "all",
    --                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    --                 includeInlayFunctionParameterTypeHints = true,
    --                 includeInlayVariableTypeHints = false,
    --                 includeInlayPropertyDeclarationTypeHints = true,
    --                 includeInlayFunctionLikeReturnTypeHints = true,
    --                 includeInlayEnumMemberValueHints = true,
    --             },
    --         },
    --     },
    -- },
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
                -- runtime = {
                -- path = path,
                -- version = "LuaJIT",
                -- },
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

    -- config.on_attach = function(client, bufnr)
    --     local legendary_installed, legendary =
    --         as.safe_require("legendary", { silent = true })
    --     if legendary_installed then
    --         if legendary_installed then
    --             legendary.keymaps(
    --                 require("config.mappings").lsp_keymaps(client, bufnr)
    --             )
    --
    --             legendary.commands(
    --                 require("config.commands").lsp_commands(client, bufnr)
    --             )
    --         end
    --     end
    -- end

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
    return config
end

return M
