local api = vim.api
local lsp = vim.lsp
local lspconfig = require "lspconfig"
-- local format = require("modules.completion.format")

local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

function _G.reload_lsp()
    lsp.stop_client(lsp.get_active_clients())
    vim.cmd([[edit]])
end

function _G.open_lsp_log()
    local path = lsp.get_log_path()
    vim.cmd("edit " .. path)
end

vim.cmd("command! -nargs=0 LspLog call v:lua.open_lsp_log()")
vim.cmd("command! -nargs=0 LspRestart call v:lua.reload_lsp()")

lsp.handlers["textDocument/publishDiagnostics"] =
    lsp.with(
    lsp.diagnostic.on_publish_diagnostics,
    {
        -- Enable underline, use default values
        underline = true,
        -- Enable virtual text, override spacing to 4
        virtual_text = true,
        signs = {
            enable = true,
            prefix = "»",
            spacing = 4,
            priority = 20
        },
        -- Disable a feature
        update_in_insert = false,
        severity_sort = true
    }
)

-- taken from: https://gist.github.com/tjdevries/ccbe3b79bd918208f2fa8dfe15b95793
lsp.diagnostic.get_virtual_text_chunks_for_line = function(bufnr, line, line_diagnostics)
    if #line_diagnostics == 0 then
        return nil
    end

    local line_length = #(vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or "")
    local get_highlight = lsp.diagnostic._get_severity_highlight_name

    -- Create a little more space between virtual text and contents
    local virt_texts = {{string.rep(" ", 80 - line_length)}}

    for i = 1, #line_diagnostics - 1 do
        table.insert(virt_texts, {"■", get_highlight(line_diagnostics[i].severity)})
    end
    local last = line_diagnostics[#line_diagnostics]
    -- TODO(ashkan) use first line instead of subbing 2 spaces?

    -- TODO(tjdevries): Allow different servers to be shown first somehow?
    -- TODO(tjdevries): Display server name associated with these?
    if last.message then
        table.insert(
            virt_texts,
            {
                string.format("■ %s", last.message:gsub("\r", ""):gsub("\n", "  ")),
                get_highlight(last.severity)
            }
        )

        return virt_texts
    end

    return virt_texts
end

vim.fn.sign_define("LspDiagnosticsSignError", {text = "", texthl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsDefaultHint"})

local enhance_attach = function(client, bufnr)
    -- if client.resolved_capabilities.document_formatting then
    -- -- format.lsp_before_save()
    -- end

    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    require("modules.completion._null_ls").setup()

    require "lsp_signature".on_attach(
        {
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            handler_opts = {
                border = "single"
            }
        }
    )

    if client.name == "typescript" or client.name == "tsserver" then
        local ts = require("nvim-lsp-ts-utils")

        ts.setup(
            {
                disable_commands = false,
                enable_import_on_completion = false,
                import_on_completion_timeout = 5000,
                eslint_bin = "eslint_d", -- use eslint_d if possible!
                eslint_enable_diagnostics = true,
                -- eslint_fix_current = false,
                eslint_enable_disable_comments = true
            }
        )

        ts.setup_client(client)
    end

    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
    vim.api.nvim_command [[augroup END]]
end

-- -- taken from: https://www.reddit.com/r/neovim/comments/jvisg5/lets_talk_formatting_again/
-- vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
--     if err ~= nil or result == nil then
--         return
--     end
--     if not vim.api.nvim_buf_get_option(bufnr, "modified") then
--         local view = vim.fn.winsaveview()
--         vim.lsp.util.apply_text_edits(result, bufnr)
--         vim.fn.winrestview(view)
--         if bufnr == vim.api.nvim_get_current_buf() then
--             vim.api.nvim_command("noautocmd :update")
--         end
--     end
-- end

-- local on_attach = function(client)
--     if client.resolved_capabilities.document_formatting then
--         vim.api.nvim_command [[augroup Format]]
--         vim.api.nvim_command [[autocmd! * <buffer>]]
--         vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
--         vim.api.nvim_command [[augroup END]]
--     end
-- end

-- lspconfig.efm.setup {on_attach = on_attach}

lspconfig.gopls.setup {
    cmd = {"gopls", "--remote=auto"},
    on_attach = enhance_attach,
    capabilities = capabilities,
    init_options = {
        usePlaceholders = true,
        completeUnimported = true
    }
}

lspconfig.sumneko_lua.setup {
    on_attach = enhance_attach,
    cmd = {
        O.default.home .. "/Downloads/lua-language-server/bin/Linux/lua-language-server",
        "-E",
        "-e",
        "LANG=en",
        O.default.home .. "/Downloads/lua-language-server/main.lua"
    },
    settings = {
        Lua = {
            diagnostics = {
                enable = true,
                globals = {"vim", "packer_plugins"}
            },
            runtime = {version = "LuaJIT"},
            workspace = {
                library = vim.list_extend({[vim.fn.expand("$VIMRUNTIME/lua")] = true}, {})
            }
        }
    }
}

lspconfig.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false

        enhance_attach(client)
    end
}

lspconfig.clangd.setup {
    cmd = {
        "clangd",
        "--background-index",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--header-insertion=iwyu"
    }
}

lspconfig.rust_analyzer.setup {
    capabilities = capabilities
}

lspconfig.yamlls.setup {
    settings = {
        yaml = {
            schemas = {
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/eslintrc"] = ".eslintrc.{yml,yaml}",
                ["http://json.schemastore.org/babelrc"] = ".babelrc.{yml,yaml}",
                ["http://json.schemastore.org/stylelintrc"] = ".stylelintrc.{yml,yaml}",
                ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
                ["https://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["https://json.schemastore.org/cloudbuild"] = "*cloudbuild.{yml,yaml}"
            }
        }
    }
}

lspconfig.jsonls.setup {
    settings = {
        json = {
            schemas = {
                {
                    description = "TypeScript compiler configuration file",
                    fileMatch = {"tsconfig.json", "tsconfig.*.json"},
                    url = "http://json.schemastore.org/tsconfig"
                },
                {
                    description = "Lerna config",
                    fileMatch = {"lerna.json"},
                    url = "http://json.schemastore.org/lerna"
                },
                {
                    description = "Babel configuration",
                    fileMatch = {".babelrc.json", ".babelrc", "babel.config.json"},
                    url = "http://json.schemastore.org/lerna"
                },
                {
                    description = "ESLint config",
                    fileMatch = {".eslintrc.json", ".eslintrc"},
                    url = "http://json.schemastore.org/eslintrc"
                },
                {
                    description = "Bucklescript config",
                    fileMatch = {"bsconfig.json"},
                    url = "https://bucklescript.github.io/bucklescript/docson/build-schema.json"
                },
                {
                    description = "Prettier config",
                    fileMatch = {".prettierrc", ".prettierrc.json", "prettier.config.json"},
                    url = "http://json.schemastore.org/prettierrc"
                },
                {
                    description = "Vercel Now config",
                    fileMatch = {"now.json", "vercel.json"},
                    url = "http://json.schemastore.org/now"
                },
                {
                    description = "Stylelint config",
                    fileMatch = {
                        ".stylelintrc",
                        ".stylelintrc.json",
                        "stylelint.config.json"
                    },
                    url = "http://json.schemastore.org/stylelintrc"
                }
            }
        }
    }
}

local servers = {
    "dockerls",
    "bashls",
    "pyright",
    "html"
}

for _, server in ipairs(servers) do
    lspconfig[server].setup {
        on_attach = enhance_attach,
        flags = {
            debounce_text_changes = 150
        }
    }
end
