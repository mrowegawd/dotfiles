local fmt, diagnostic = string.format, vim.diagnostic

local icons = as.ui.icons
local lsp_utils = require "r.plugins.lspconfig.lsp.utils"

--
-- local ufo_config_handler = require("r.utils").ufo_handler

-- local function get_python_path(workspace)
--     -- Use activated virtualenv.
--     if vim.env.VIRTUAL_ENV then
--         return util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
--     end
--
--     -- Check for a poetry.lock file
--     local crmatch = vim.fn.glob(util.path.join(workspace, "poetry.lock"))
--     if crmatch ~= "" then
--         local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
--         return util.path.join(venv, "bin", "python")
--     end
--
--     -- Find and use virtualenv from pipenv in workspace directory.
--     local match = vim.fn.glob(util.path.join(workspace, "Pipfile"))
--     if match ~= "" then
--         local venv = vim.fn.trim(
--             vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv")
--         )
--         return util.path.join(venv, "bin", "python")
--     end
--
--     -- Fallback to system Python.
--     return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
-- end
--
-- M.servers = {
--     eslint = {
--         settings = {
--             codeAction = {
--                 disableRuleComment = {
--                     enable = true,
--                     location = "separateLine",
--                 },
--                 showDocumentation = {
--                     enable = true,
--                 },
--             },
--             codeActionOnSave = {
--                 enable = false,
--                 mode = "all",
--             },
--             format = true,
--             nodePath = "",
--             onIgnoredFiles = "off",
--             packageManager = "npm",
--             quiet = false,
--             rulesCustomizations = {},
--             run = "onType",
--             useESLintClass = false,
--             validate = "on",
--             workingDirectory = {
--                 mode = "location",
--             },
--         },
--     },
--     cssls = {
--         settings = {
--             css = {
--                 lint = {
--                     unknownAtRules = "ignore",
--                 },
--             },
--             scss = {
--                 lint = {
--                     unknownAtRules = "ignore",
--                 },
--             },
--         },
--         on_attach = function(client)
--             client.server_capabilities.documentFormattingProvider = true
--             client.server_capabilities.documentRangeFormattingProvider = true
--         end,
--     },
--     rust_analyzer = {
--         settings = {
--             ["rust-analyzer"] = {
--                 cargo = {
--                     allFeatures = true,
--                     loadOutDirsFromCheck = true,
--                     runBuildScripts = true,
--                 },
--                 -- Add clippy lints for Rust.
--                 checkOnSave = {
--                     allFeatures = true,
--                     command = "clippy",
--                     extraArgs = { "--no-deps" },
--                 },
--                 procMacro = {
--                     enable = true,
--                     ignored = {
--                         ["async-trait"] = { "async_trait" },
--                         ["napi-derive"] = { "napi" },
--                         ["async-recursion"] = { "async_recursion" },
--                     },
--                 },
--             },
--         },
--         on_attach = function()
--             vim.keymap.set(
--                 "n",
--                 "<C-space>",
--                 require("rust-tools").hover_actions.hover_actions
--                 -- { buffer = bufnr }
--             )
--             -- Code action groups
--             vim.keymap.set(
--                 "n",
--                 "<Leader>a",
--                 require("rust-tools").code_action_group.code_action_group
--                 -- { buffer = bufnr }
--             )
--         end,
--     },
--     taplo = {
--         keys = {
--             {
--                 "K",
--                 function()
--                     if
--                         vim.fn.expand "%:t" == "Cargo.toml"
--                         and require("crates").popup_available()
--                     then
--                         require("crates").show_popup()
--                     else
--                         vim.lsp.buf.hover()
--                     end
--                 end,
--                 desc = "Show Crate Documentation",
--             },
--         },
--     },
--     html = {},
--     jsonls = {
--         on_new_config = function(new_config)
--             new_config.settings.json.schemas = new_config.settings.json.schemas
--                 or {}
--             vim.list_extend(
--                 new_config.settings.json.schemas,
--                 require("schemastore").json.schemas()
--             )
--         end,
--         settings = {
--             json = {
--                 format = {
--                     enable = true,
--                 },
--                 validate = { enable = true },
--             },
--         },
--     },
--     sqlls = {},
--     bashls = {},
--     vimls = {},
--     ansiblels = {},
--     terraformls = {},
--     pyright = {
--         on_init = function(client)
--             client.config.settings.python.pythonPath =
--                 get_python_path(client.config.root_dir)
--         end,
--     },
--     ruff_lsp = {},
--     prosemd_lsp = {},
--     docker_compose_language_service = {},
--     graphql = {
--         on_attach = function(client)
--             -- Disable workspaceSymbolProvider because this prevents
--             -- searching for symbols in typescript files which this server
--             -- is also enabled for.
--             -- @see: https://github.com/nvim-telescope/telescope.nvim/issues/964
--             client.server_capabilities.workspaceSymbolProvider = false
--         end,
--     },
--     -- sourcekit = {
--     --     filetypes = { "swift", "objective-c", "objective-cpp" },
--     -- },
--     yamlls = {
--         settings = {
--             yaml = {
--                 customTags = {
--                     "!reference sequence", -- necessary for gitlab-ci.yaml files
--                 },
--             },
--         },
--     },
-- }

local M = {}

local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

local function lsp_init()
    local signs = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
    }
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(
            sign.name,
            { texthl = sign.name, text = sign.text, numhl = sign.name }
        )
    end

    local config = {
        -- float = {
        --     focusable = true,
        --     style = "minimal",
        --     border = "rounded",
        -- },

        diagnostic = {

            virtual_text = true and {
                spacing = 1,
                prefix = "",
                format = function(d)
                    return fmt("%s %s", icons.misc.circle, d.message)
                end,
            },
            signs = {
                active = signs,
            },
            underline = false,
            update_in_insert = false,
            severity_sort = true,
            float = {
                max_width = max_width,
                max_height = max_height,
                title = "",
                -- title = {
                --     { "  ", "DiagnosticFloatTitleIcon" },
                --     { "Problems  ", "DiagnosticFloatTitle" },
                -- },
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = function(diag)
                    local level = diagnostic.severity[diag.severity]
                    local prefix = fmt("%s ", icons.diagnostics[level:lower()])
                    return prefix,
                        "Diagnostic" .. level:gsub("^%l", string.upper)
                end,
            },
        },
    }

    -- Diagnostic configuration
    vim.diagnostic.config(config.diagnostic)

    -- Hover configuration
    -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)

    -- Signature help configuration
    -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

function M.setup(_, opts)
    ---@diagnostic disable-next-line: unused-local
    lsp_utils.on_attach(function(client, bufnr)
        -- local legendary_installed, legendary =
        --     as.safe_require("legendary", { silent = true })
        -- if legendary_installed then
        --     if legendary_installed then
        --         legendary.keymaps(require("r.mappings").lsp_keymaps())
        --
        --         legendary.commands(require("r.mappings").lsp_commands())
        --     end
        -- end
    end)

    lsp_init() -- diagnostics, handlers

    local servers = opts.servers
    local capabilities = lsp_utils.capabilities()

    local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
            capabilities = capabilities,
        }, servers[server] or {})

        if opts.setup[server] then
            if opts.setup[server](server, server_opts) then
                return
            end
        elseif opts.setup["*"] then
            if opts.setup["*"](server, server_opts) then
                return
            end
        end
        require("lspconfig")[server].setup(server_opts)
    end

    -- Add bun for Node.js-based servers
    -- local lspconfig_util = require "lspconfig.util"
    -- local add_bun_prefix = require("plugins.lsp.bun").add_bun_prefix
    -- lspconfig_util.on_setup = lspconfig_util.add_hook_before(lspconfig_util.on_setup, add_bun_prefix)

    -- get all the servers that are available thourgh mason-lspconfig
    local have_mason, mlsp = pcall(require, "mason-lspconfig")
    local all_mslp_servers = {}
    if have_mason then
        all_mslp_servers = vim.tbl_keys(
            require("mason-lspconfig.mappings.server").lspconfig_to_package
        )
    end

    local ensure_installed = {} ---@type string[]
    for server, server_opts in pairs(servers) do
        if server_opts then
            server_opts = server_opts == true and {} or server_opts
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if
                server_opts.mason == false
                or not vim.tbl_contains(all_mslp_servers, server)
            then
                setup(server)
            else
                ensure_installed[#ensure_installed + 1] = server
            end
        end
    end

    if have_mason then
        mlsp.setup { ensure_installed = ensure_installed }
        mlsp.setup_handlers { setup }
    end
end

return M
