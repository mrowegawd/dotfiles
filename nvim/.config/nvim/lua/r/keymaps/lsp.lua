local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string|string[], cond?:fun():boolean}
---@alias LazyKeysLsp LazyKeys|{has?:string|string[], cond?:fun():boolean}

local document_highlight_enabled = false
local highlight_augroup = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

local function enable_document_highlight()
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = highlight_augroup,
    callback = function()
      if document_highlight_enabled then
        vim.lsp.buf.document_highlight()
      end
    end,
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = highlight_augroup,
    callback = function()
      vim.lsp.buf.clear_references()
    end,
  })

  document_highlight_enabled = true
  RUtils.info "LSP Document Highlight: ON"
end

local function disable_document_highlight()
  vim.api.nvim_clear_autocmds { group = highlight_augroup }
  vim.lsp.buf.clear_references()
  document_highlight_enabled = false
  RUtils.info "LSP Document Highlight: OFF"
end

local function toggle_document_highlight()
  if document_highlight_enabled then
    disable_document_highlight()
  else
    enable_document_highlight()
  end
end

local diagnostic_goto = function(next, severity)
  local go = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, float = false, count = go }
  end
end

local function all_item_locations_equal(items)
  if #items == 0 then
    return false
  end
  for i = 2, #items do
    local item = items[i]
    if item.bufnr ~= items[1].bufnr or item.filename ~= items[1].filename or item.lnum ~= items[1].lnum then
      return false
    end
  end
  return true
end

local function wrap_location_method(yield, is_vsplit)
  is_vsplit = is_vsplit or false
  return function()
    local from = vim.fn.getpos "."
    yield {
      ---@param t vim.lsp.LocationOpts.OnList
      on_list = function(t)
        local curpos = vim.fn.getpos "."
        if not vim.deep_equal(from, curpos) then
          -- We have moved the cursor since fetching locations, so abort
          return
        end

        if is_vsplit then
          vim.cmd "vsplit"
        end

        if all_item_locations_equal(t.items) then
          -- Mostly copied from neovim source
          local item = t.items[1]
          local b = item.bufnr or vim.fn.bufadd(item.filename)

          -- Save position in jumplist
          vim.cmd "normal! m'"
          -- Push a new item into tagstack
          local tagname = vim.fn.expand "<cword>"
          local tagstack = { { tagname = tagname, from = from } }
          local winid = vim.api.nvim_get_current_win()
          vim.fn.settagstack(vim.fn.win_getid(winid), { items = tagstack }, "t")

          vim.bo[b].buflisted = true
          vim.api.nvim_win_set_buf(winid, b)
          pcall(vim.api.nvim_win_set_cursor, winid, { item.lnum, item.col - 1 })
          vim._with({ win = winid }, function()
            -- Open folds under the cursor
            vim.cmd "normal! zv"
          end)
        else
          vim.fn.setloclist(0, {}, " ", { title = t.title, items = t.items })
          vim.cmd.lopen()
        end
      end,
    }
  end
end

function M.get()
  local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

  if M._keys then
    return M._keys
  end

  M._keys = {
    --  +----------------------------------------------------------+
    --  LSP Stuff
    --  +----------------------------------------------------------+
    {
      "gk",
      function()
        vim.lsp.buf.signature_help()
      end,
      has = "signatureHelp",
      desc = "LSP: signature help",
    },
    {
      "K",
      function()
        vim.lsp.buf.hover {
          border = "single",
          title = { { " Hover ", "DiagnosticFloatTitle" } },
        }
      end,
      desc = "LSP: show hover [noice]",
    },
    {
      "gK",
      function()
        RUtils.hover_eldoc.hover_in_split()
      end,
      desc = "LSP: show hover (split) [hover_eglot]",
    },
    {
      "<Leader>lD",
      -- wrap_location_method(vim.lsp.buf.declaration),
      wrap_location_method(vim.lsp.buf.definition, true),
      has = "definition",
      desc = "LSP: definitions (vsplit)",
    },
    {
      "<Leader>ld",
      wrap_location_method(vim.lsp.buf.definition),
      has = "definition",
      desc = "LSP: definitions",
    },
    {
      "<Leader>li",
      function()
        -- fzf_lua.lsp_incoming_calls()
        Snacks.picker.lsp_incoming_calls()
      end,
      has = "callHierarchy/incomingCalls",
      desc = "LSP: incoming calls [Snacks]",
    },
    {
      "<Leader>lo",
      function()
        -- fzf_lua.lsp_outgoing_calls()
        Snacks.picker.lsp_outgoing_calls()
      end,
      has = "callHierarchy/outgoingCalls",
      desc = "LSP: outgoing calls [Snacks]",
    },

    {
      "<Leader>lh",
      function()
        toggle_document_highlight()
      end,
      desc = "LSP: document highlight toggle",
    },
    {
      "<Leader>lH",
      function()
        disable_document_highlight()
      end,
      desc = "LSP: document highlight disabled",
    },

    {
      "<Leader>lr",
      function()
        fzf_lua.lsp_references()
      end,
      has = "references",
      desc = "LSP: references [fzflua]",
    },
    {
      "<Leader>le",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "LSP: type definitions [snacks]",
    },

    {
      "<a-q>",
      function()
        if RUtils.has "snacks.nvim" then
          Snacks.words.jump(vim.v.count1)
        end
      end,
      has = "documentHighlight",
      cond = function()
        return Snacks.words.is_enabled()
      end,
      desc = "LSP: next word reference",
    },
    {
      "<a-Q>",
      function()
        if RUtils.has "snacks.nvim" then
          Snacks.words.jump(-vim.v.count1)
        end
      end,
      has = "documentHighlight",
      cond = function()
        return Snacks.words.is_enabled()
      end,
      desc = "LSP: prev word reference",
    },

    {
      "<Leader>ca",
      function()
        if vim.bo[0].filetype == "rust" then
          return vim.cmd.RustLsp "codeAction"
        end
        -- vim.lsp.buf.code_action

        if RUtils.has "tiny-code-action.nvim" then
          ---@diagnostic disable-next-line: missing-parameter
          return require("tiny-code-action").code_action()
        end
      end,
      mode = { "n", "x" },
      has = "codeAction",
      desc = "Action: source action",
    },
    { "<Leader>cA", RUtils.lsp.action.source, desc = "Action: source action", has = "codeAction" },
    {
      "<Leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
      desc = "Action: rename file",
    },
    {
      "<Leader>cc",
      function()
        vim.lsp.codelens.run()
      end,
      desc = "Action: run codelens",
    },
    {
      "<Leader>cC",
      function()
        vim.lsp.codelens.refresh()
      end,
      desc = "Action: codelens refresh",
    },
    {
      "<Leader>cr",
      function()
        local inc_rename = require "inc_rename"
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
      end,
      expr = true,
      has = "rename",
      desc = "Action: rename [inc_rename]",
    },
    --  +----------------------------------------------------------+
    --  Diagnostics
    --  +----------------------------------------------------------+
    {
      "dn",
      diagnostic_goto(true),
      desc = "Diagnostic: next item",
    },
    {
      "dp",
      diagnostic_goto(false),
      desc = "Diagnostic: prev item",
    },
    {
      "<Leader>uD",
      function()
        local new_value = not vim.diagnostic.config().virtual_lines
        ---@diagnostic disable-next-line: undefined-field
        RUtils.info(tostring(new_value), { title = "Diagnostic: virtual_lines" })
        vim.diagnostic.config { virtual_lines = new_value }
      end,
      desc = "Toggle: virtual lines [diagnostic]",
    },
    {
      "dP",
      function()
        vim.diagnostic.open_float { scope = "line", border = "rounded" }
      end,
      desc = "Diagnostic: open float peek",
    },
    --  +----------------------------------------------------------+
    --  LSP commands
    --  +----------------------------------------------------------+
    {
      "<Leader>lf",
      function()
        local function check_current_ft(fts)
          if vim.tbl_contains(fts, vim.bo[0].filetype) then
            return true
          end
          return false
        end

        local lang_lsp_cmds = {}

        if check_current_ft { "typescriptreact", "typescript" } then
          table.insert(lang_lsp_cmds, {
            ["Run TSC"] = function()
              vim.cmd [[TSC]]
            end,
            ["LSP - Organizer Imports"] = function()
              vim.cmd [[TSToolsOrganizeImports]]
            end,
            ["LSP - Short Imports"] = function()
              vim.cmd [[TSToolsSortImports]]
            end,
            ["LSP - Remove Unused imports"] = function()
              vim.cmd [[TSToolsRemoveUnusedImports]]
            end,
            ["Eslint - Fix all"] = function()
              vim.cmd [[TSToolsFixAll]]
            end,
            ["LSP - Check missing imports"] = function()
              vim.cmd [[TSToolsAddMissingImports]]
            end,
          })
        end

        if check_current_ft { "go" } then
          table.insert(lang_lsp_cmds, {
            ["Run Gomod"] = function()
              vim.cmd [[GoGenerate %]]
            end,
            ["Run go tidy"] = function()
              vim.cmd [[GoMod tidy]]
            end,
          })
        end

        local lsp_cmds = vim.tbl_deep_extend("force", {
          ["Lazy - Show format info"] = function()
            vim.cmd [[LazyFormatInfo]]
          end,
          ["LSP - Show info log"] = function()
            vim.cmd [[LspInfo]]
          end,
          ["Diagnostics - Toggle virtual_lines"] = function()
            local new_value = not vim.diagnostic.config().virtual_lines
            ---@diagnostic disable-next-line: undefined-field
            RUtils.info(tostring(new_value), { title = "Diagnostic: virtual_lines" })
            vim.diagnostic.config { virtual_lines = new_value }
            return new_value
          end,
        }, unpack(lang_lsp_cmds) or {})

        RUtils.fzflua.open_cmd_bulk(lsp_cmds, { winopts = { title = RUtils.config.icons.misc.lsp .. "LSP" } })
      end,
      desc = "Bulk: LSP cmds",
    },
  }

  return M._keys
end

function M.on_attach(client, buffer)
  RUtils.map.on_attach(client, buffer, M.get())
end

return M
