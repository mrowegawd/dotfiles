if not as then
    return
end

if as.use_navigator_ray_x then
    return
end

local lsp, fn, fmt = vim.lsp, vim.fn, string.format
local diagnostic = vim.diagnostic

local L = vim.lsp.log_levels

-- local icons = as.ui.icons
local augroup = as.augroup

if vim.env.DEVELOPING then
    vim.lsp.set_log_level(L.DEBUG)
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                    RELATED LOCATIONS                     │
--  ╰──────────────────────────────────────────────────────────╯
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

--  ╭──────────────────────────────────────────────────────────╮
--  │                         MAPPINGS                         │
--  ╰──────────────────────────────────────────────────────────╯
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

--  ╭──────────────────────────────────────────────────────────╮
--  │                    LSP SETUP/TEARDOWN                    │
--  ╰──────────────────────────────────────────────────────────╯
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

--  ╭──────────────────────────────────────────────────────────╮
--  │                     SEMANTIC TOKENS                      │
--  ╰──────────────────────────────────────────────────────────╯

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

--  ╭──────────────────────────────────────────────────────────╮
--  │                       AUTOCOMMANDS                       │
--  ╰──────────────────────────────────────────────────────────╯

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

-- local __save_win_positions = function(bufnr)
--     if bufnr == nil or bufnr == 0 then
--         bufnr = api.nvim_get_current_buf()
--     end
--     local win_positions = {}
--     for _, winid in ipairs(api.nvim_list_wins()) do
--         if api.nvim_win_get_buf(winid) == bufnr then
--             api.nvim_win_call(winid, function()
--                 local view = vim.fn.winsaveview()
--                 table.insert(win_positions, { winid, view })
--             end)
--         end
--     end
--
--     return function()
--         for _, pair in ipairs(win_positions) do
--             local winid, view = unpack(pair)
--             api.nvim_win_call(winid, function()
--                 pcall(vim.fn.winrestview, view)
--             end)
--         end
--     end
-- end

local function setup_autocommands(client, buf)
    if client.server_capabilities[provider.FORMATTING] then
        augroup(("LspFormatting%d"):format(buf), {
            event = "BufWritePre",
            buffer = buf,
            desc = "LSP: Format on save",
            ---@diagnostic disable-next-line: unused-local
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
                        if vim.bo[buf].filetype == "norg" then
                            return
                        end
                        -- This is custom format async that i can use it now
                        -- check [textDocument/apply_formatting] at line :357
                        vim.bo[buf].modifiable = false -- Prevent me from changing the buffer.
                        vim.b[buf].write_after_format = true -- Tell apply_formatting to save the buffer afterwards
                        pcall(vim.lsp.buf.format, { async = true }) -- Call the formatting function for the LSP
                    end
                end
            end,
        })
    end

    if client.server_capabilities[provider.CODELENS] then
        augroup(("LspCodeLens%d"):format(buf), {
            event = { "BufEnter", "InsertLeave", "BufWritePost" },
            desc = "LSP: Code Lens",
            buffer = buf,
            -- call via vimscript so that errors are silenced
            command = "silent! lua vim.lsp.codelens.refresh()",
        })
    end

    -- Enable inlay_hint
    if client.server_capabilities.inlayHintProvider then
        if require("r.utils").show_inlayhinst() then
            vim.lsp.buf.inlay_hint(buf, true)
        end
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

-- Add buffer local mappings, autocommands etc for attaching servers
-- this runs for each client because they have different capabilities so each time one
-- attaches it might enable autocommands or mappings that the previous client did not support
local function on_attach(client, bufnr)
    setup_autocommands(client, bufnr)
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

--  ╭──────────────────────────────────────────────────────────╮
--  │                          SIGNS                           │
--  ╰──────────────────────────────────────────────────────────╯
-- -@param opts {highlight: string, icon: string}
-- local function sign(opts)
--     fn.sign_define(opts.highlight, {
--         text = opts.icon,
--         texthl = opts.highlight,
--         -- numhl = opts.highlight .. "Nr" or nil,
--         -- culhl = opts.highlight .. "CursorNr" or nil,
--         -- linehl = opts.highlight .. "Line" or nil,
--     })
-- end
--
-- sign { highlight = "DiagnosticSignError", icon = icons.diagnostics.error }
-- sign { highlight = "DiagnosticSignWarn", icon = icons.diagnostics.warn }
-- sign { highlight = "DiagnosticSignInfo", icon = icons.diagnostics.info }
-- sign { highlight = "DiagnosticSignHint", icon = icons.diagnostics.hint }

--  ╭──────────────────────────────────────────────────────────╮
--  │                    HANDLER OVERRIDES                     │
--  ╰──────────────────────────────────────────────────────────╯

--  ------------------------------------------------------------
--  [diagnostic.handlers]
--  ------------------------------------------------------------

-- TODO: something wrong with this functions, investigate this later
-- 1. When diagnostic updated, nvim got hang for sec
-- 2. Got some wierd behaviour, i can't exit from nvim

-- -- This section overrides the default diagnostic handlers for signs and virtual text so that only
-- -- the most severe diagnostic is shown per line
--
-- --- The custom namespace is so that ALL diagnostics across all namespaces can be aggregated
-- --- including diagnostics from plugins
-- local ns = api.nvim_create_namespace "severe-diagnostics"
--
-- --- Restricts nvim's diagnostic signs to only the single most severe one per line
-- --- see `:help vim.diagnostic`
-- ---@param callback fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
-- ---@return fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
-- local function max_diagnostic(callback)
--     return function(_, bufnr, diagnostics, opts)
--         local max_severity_per_line = as.fold(function(diag_map, d)
--             local m = diag_map[d.lnum]
--             if not m or d.severity < m.severity then
--                 diag_map[d.lnum] = d
--             end
--             return diag_map
--         end, diagnostics, {})
--         callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
--     end
-- end
--
-- local signs_handler = diagnostic.handlers.signs
-- diagnostic.handlers.signs = vim.tbl_extend("force", signs_handler, {
--     show = max_diagnostic(signs_handler.show),
--     hide = function(_, bufnr)
--         signs_handler.hide(ns, bufnr)
--     end,
-- })

--  ------------------------------------------------------------
--  [textDocument/formatting]
--  ------------------------------------------------------------

--  Taken from: https://www.reddit.com/r/neovim/comments/14iqm8t/my_setup_for_responsive_immutable_formatting/

local function apply_formatting(bufnr, result, client_id)
    local util = require "vim.lsp.util"
    vim.bo[bufnr].modifiable = true -- Make the buffer modifiable again
    if not result then
        return
    end
    local client = vim.lsp.get_client_by_id(client_id)
    util.apply_text_edits(result, bufnr, client.offset_encoding) -- Apply changes from LSP
    if vim.b[bufnr].write_after_format then
        vim.cmd(
            "let buf = bufnr('%') | exec '"
                .. bufnr
                .. "bufdo :noa w' | exec 'b' buf"
        )
    end -- Save the buffer if formatting was requested during saving (make sure to not trigger formatting again)
    vim.b[bufnr].write_after_format = nil
end

vim.lsp.handlers["textDocument/formatting"] = function(_, result, ctx, _)
    apply_formatting(ctx.bufnr, result, ctx.client_id)
end

--  ╭──────────────────────────────────────────────────────────╮
--  │                 DIAGNOSTIC CONFIGURATION                 │
--  ╰──────────────────────────────────────────────────────────╯
-- local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
-- local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)
--
-- diagnostic.config {
--     underline = true,
--     update_in_insert = false,
--     severity_sort = true,
--     signs = true,
--     virtual_text = false and {
--         spacing = 1,
--         prefix = "",
--         format = function(d)
--             return fmt("%s %s", icons.misc.circle, d.message)
--         end,
--     },
--     float = {
--         max_width = max_width,
--         max_height = max_height,
--         -- border = {
--         --     { "┌", "ErrorMsg" },
--         --     { "─", "ErrorMsg" },
--         --     { "┐", "ErrorMsg" },
--         --     { "│", "ErrorMsg" },
--         --     { "┘", "ErrorMsg" },
--         --     { "─", "ErrorMsg" },
--         --     { "└", "ErrorMsg" },
--         --     { "│", "ErrorMsg" },
--         -- },
--
--         border = {
--             { "┌" },
--             { "─" },
--             { "┐" },
--             { "│" },
--             { "┘" },
--             { "─" },
--             { "└" },
--             { "│" },
--         },
--         title = {
--             { "  ", "DiagnosticFloatTitleIcon" },
--             { "Problems  ", "DiagnosticFloatTitle" },
--         },
--         focusable = false,
--         scope = "cursor",
--         source = "if_many",
--         prefix = function(diag)
--             local level = diagnostic.severity[diag.severity]
--             local prefix = fmt("%s ", icons.diagnostics[level:lower()])
--             return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
--         end,
--     },
-- }
