if not as then
    return
end

if as.use_navigator_ray_x then
    return
end

local lsp, fn, api, fmt = vim.lsp, vim.fn, vim.api, string.format
local diagnostic = vim.diagnostic

local L = vim.lsp.log_levels

local icons = as.ui.icons
local augroup = as.augroup

if vim.env.DEVELOPING then
    vim.lsp.set_log_level(L.DEBUG)
end

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
---@enum
local provider = {
    HOVER = "hoverProvider",
    RENAME = "renameProvider",
    CODELENS = "codeLensProvider",
    CODEACTIONS = "codeActionProvider",
    FORMATTING = "documentFormattingProvider",
    REFERENCES = "documentHighlightProvider",
    DEFINITION = "definitionProvider",
}

local __save_win_positions = function(bufnr)
    if bufnr == nil or bufnr == 0 then
        bufnr = vim.api.nvim_get_current_buf()
    end
    local win_positions = {}
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(winid) == bufnr then
            vim.api.nvim_win_call(winid, function()
                local view = vim.fn.winsaveview()
                table.insert(win_positions, { winid, view })
            end)
        end
    end

    return function()
        for _, pair in ipairs(win_positions) do
            local winid, view = unpack(pair)
            vim.api.nvim_win_call(winid, function()
                pcall(vim.fn.winrestview, view)
            end)
        end
    end
end

local function setup_autocommands(client, buf)
    if client.server_capabilities[provider.FORMATTING] then
        augroup(("LspFormatting%d"):format(buf), {
            event = "BufWritePre",
            buffer = buf,
            desc = "LSP: Format on save",
            command = function(args)
                if
                    not vim.g.formatting_disabled
                    and not vim.b[buf].formatting_disabled
                then
                    local clients = vim.tbl_filter(
                        function(c)
                            return c.server_capabilities[provider.FORMATTING]
                        end,
                        lsp.get_active_clients {
                            buffer = buf,
                        }
                    )

                    if #clients >= 1 then
                        local restore = __save_win_positions(0)
                        vim.lsp.buf.format { timeout_ms = 500, bufnr = args.buf }
                        restore()
                    end
                end
            end,
        })
    end

    if client.server_capabilities[provider.CODELENS] then
        augroup(("LspCodeLens%d"):format(buf), {
            event = { "BufEnter", "InsertLeave", "BufWritePost" },
            -- event = { "BufEnter", "InsertLeave" },
            desc = "LSP: Code Lens",
            buffer = buf,
            -- call via vimscript so that errors are silenced
            command = function()
                vim.lsp.codelens.refresh()
            end,
        })
    end

    -- if current nvim version supports inlay hints, enable them
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.buf.inlay_hint(buf, true)
    end

    --     if client.server_capabilities[provider.REFERENCES] then
    --         augroup(("LspReferences%d"):format(buf), {
    --             event = { "CursorHold", "CursorHoldI" },
    --             buffer = buf,
    --             desc = "LSP: References",
    --             command = function()
    --                 lsp.buf.document_highlight()
    --             end,
    --         }, {
    --             event = "CursorMoved",
    --             desc = "LSP: References Clear",
    --             buffer = buf,
    --             command = function()
    --                 lsp.buf.clear_references()
    --             end,
    --         })
    --     end
end

----------------------------------------------------------------------------------------------------
--  Related Locations
----------------------------------------------------------------------------------------------------
-- This relates to:
-- 1. https://github.com/neovim/neovim/issues/19649#issuecomment-1327287313
-- 2. https://github.com/neovim/neovim/issues/22744#issuecomment-1479366923
-- neovim does not currently correctly report the related locations for diagnostics.
-- NOTE: once a PR for this is merged delete this workaround

local function show_related_locations(diag)
    local related_info = diag.relatedInformation
    if not related_info or #related_info == 0 then
        return diag
    end
    for _, info in ipairs(related_info) do
        diag.message = ("%s\n%s(%d:%d)%s"):format(
            diag.message,
            fn.fnamemodify(vim.uri_to_fname(info.location.uri), ":p:."),
            info.location.range.start.line + 1,
            info.location.range.start.character + 1,
            not as.falsy(info.message) and (": %s"):format(info.message) or ""
        )
    end
    return diag
end

local handler = lsp.handlers["textDocument/publishDiagnostics"]
---@diagnostic disable-next-line: duplicate-set-field
lsp.handlers["textDocument/publishDiagnostics"] = function(
    err,
    result,
    ctx,
    config
)
    result.diagnostics = vim.tbl_map(show_related_locations, result.diagnostics)
    handler(err, result, ctx, config)
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//
-- local function prev_diagnostic(lvl)
--     return function()
--         diagnostic.goto_prev { float = true, severity = { min = lvl } }
--     end
-- end
-- local function next_diagnostic(lvl)
--     return function()
--         diagnostic.goto_next { float = true, severity = { min = lvl } }
--     end
-- end

---Setup mapping when an lsp attaches to a buffer
local function setup_mappings(client, bufnr)
    local legendary_installed, legendary =
        as.safe_require("legendary", { silent = true })
    if legendary_installed then
        if legendary_installed then
            if as.use_search_telescope then
                legendary.keymaps(
                    require("r.mappings").lsp_keymaps_lspsaga(client, bufnr)
                )
            else
                legendary.keymaps(require("r.mappings").lsp_keymaps())
            end

            legendary.commands(require("r.mappings").lsp_commands())
        end
    end
end

-----------------------------------------------------------------------------//
-- LSP SETUP/TEARDOWN
-----------------------------------------------------------------------------//
--- A set of custom overrides for specific lsp clients
--- This is a way of adding functionality for specific lsps
--- without putting all this logic in the general on_attach function
local client_overrides = {
    tsserver = {
        semantic_tokens = function(bufnr, client, token)
            if
                token.type == "variable"
                and token.modifiers["local"]
                and not token.modifiers.readonly
            then
                lsp.semantic_tokens.highlight_token(
                    token,
                    bufnr,
                    client.id,
                    "@danger"
                )
            end
        end,
    },
}

local function setup_semantic_tokens(client, bufnr)
    local overrides = client_overrides[client.name]
    if not overrides or not overrides.semantic_tokens then
        return
    end
    augroup(fmt("LspSemanticTokens%s", client.name), {
        event = "LspTokenUpdate",
        buffer = bufnr,
        desc = fmt("Configure the semantic tokens for the %s", client.name),
        command = function(args)
            overrides.semantic_tokens(args.buf, client, args.data.token)
        end,
    })
end

local function adjust_formatting_capabilities(client, bufnr)
    if not pcall(require, "null-ls") then
        return
    end
    local sources = require "null-ls.sources"
    local methods = require "null-ls.methods"
    local null_ls_client = require("null-ls.client").get_client()
    if
        not null_ls_client
        or not vim.lsp.buf_is_attached(bufnr, null_ls_client.id)
    then
        return
    end
    local formatters =
        sources.get_available(vim.bo[bufnr].filetype, methods.FORMATTING)
    if vim.tbl_isempty(formatters) then
        return
    end
    if client.id == null_ls_client.id then
        -- We're attaching a null-ls client. If it has a formatter, disable
        -- formatting on all prior clients
        local clients = vim.lsp.get_active_clients { bufnr = bufnr }
        for _, other_client in ipairs(clients) do
            if other_client.id ~= client.id then
                other_client.server_capabilities.documentFormattingProvider =
                    nil
                other_client.server_capabilities.documentRangeFormattingProvider =
                    nil
            end
        end
    else
        client.server_capabilities.documentFormattingProvider = nil
        client.server_capabilities.documentRangeFormattingProvider = nil
    end
end

-- Add buffer local mappings, autocommands etc for attaching servers
-- this runs for each client because they have different capabilities so each time one
-- attaches it might enable autocommands or mappings that the previous client did not support
local function on_attach(client, bufnr)
    setup_autocommands(client, bufnr)
    adjust_formatting_capabilities(client, bufnr)
    setup_mappings(client, bufnr)
    setup_semantic_tokens(client, bufnr)

    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

augroup("LspSetupCommands", {
    event = "LspAttach",
    desc = "setup the language server autocommands",
    command = function(args)
        local client = lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end
        on_attach(client, args.buf)
        local overrides = client_overrides[client.name]
        if not overrides or not overrides.on_attach then
            return
        end
        overrides.on_attach(client, args.buf)
    end,
}, {
    event = "DiagnosticChanged",
    desc = "Update the diagnostic locations",
    command = function(args)
        diagnostic.setloclist { open = false }
        if #args.data.diagnostics == 0 then
            vim.cmd "silent! lclose"
        end
    end,
}, {
    event = "CursorHold",
    desc = "Show diagnostic on float mode",
    command = function()
        if require("r.utils").show_diagnostics() then
            vim.schedule(vim.diagnostic.open_float)
        end
    end,
})
-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
-- command("LspFormat", function()
--     lsp.buf.format { bufnr = 0, async = false }
-- end)

-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//
---@param opts {highlight: string, icon: string}
local function sign(opts)
    fn.sign_define(opts.highlight, {
        text = opts.icon,
        texthl = opts.highlight,
        -- numhl = opts.highlight .. "Nr" or nil,
        -- culhl = opts.highlight .. "CursorNr" or nil,
        -- linehl = opts.highlight .. "Line" or nil,
    })
end

sign { highlight = "DiagnosticSignError", icon = icons.diagnostics.error }
sign { highlight = "DiagnosticSignWarn", icon = icons.diagnostics.warn }
sign { highlight = "DiagnosticSignInfo", icon = icons.diagnostics.info }
sign { highlight = "DiagnosticSignHint", icon = icons.diagnostics.hint }
-----------------------------------------------------------------------------//
-- Handler Overrides
-----------------------------------------------------------------------------//
-- This section overrides the default diagnostic handlers for signs and virtual text so that only
-- the most severe diagnostic is shown per line

--- The custom namespace is so that ALL diagnostics across all namespaces can be aggregated
--- including diagnostics from plugins
local ns = api.nvim_create_namespace "severe-diagnostics"

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- see `:help vim.diagnostic`
---@param callback fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
---@return fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
local function max_diagnostic(callback)
    return function(_, bufnr, diagnostics, opts)
        local max_severity_per_line = as.fold(function(diag_map, d)
            local m = diag_map[d.lnum]
            if not m or d.severity < m.severity then
                diag_map[d.lnum] = d
            end
            return diag_map
        end, diagnostics, {})
        callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
    end
end

local signs_handler = diagnostic.handlers.signs
diagnostic.handlers.signs = vim.tbl_extend("force", signs_handler, {
    show = max_diagnostic(signs_handler.show),
    hide = function(_, bufnr)
        signs_handler.hide(ns, bufnr)
    end,
})
-----------------------------------------------------------------------------//
-- Diagnostic Configuration
-----------------------------------------------------------------------------//
local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

diagnostic.config {
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    signs = true,
    virtual_text = true and {
        spacing = 1,
        prefix = "",
        format = function(d)
            return fmt("%s %s", icons.misc.circle, d.message)
        end,
    },
    float = {
        max_width = max_width,
        max_height = max_height,
        border = {
            { "┌", "ErrorMsg" },
            { "─", "ErrorMsg" },
            { "┐", "ErrorMsg" },
            { "│", "ErrorMsg" },
            { "┘", "ErrorMsg" },
            { "─", "ErrorMsg" },
            { "└", "ErrorMsg" },
            { "│", "ErrorMsg" },
        },
        title = {
            { "  ", "DiagnosticFloatTitleIcon" },
            { "Problems  ", "DiagnosticFloatTitle" },
        },
        focusable = true,
        scope = "cursor",
        source = "if_many",
        prefix = function(diag)
            local level = diagnostic.severity[diag.severity]
            local prefix = fmt("%s ", icons.diagnostics[level:lower()])
            return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
        end,
    },
}
