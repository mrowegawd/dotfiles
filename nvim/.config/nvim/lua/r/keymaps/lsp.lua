local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local M = {}

M._keys = nil

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity, float = false }
    -- go { severity = severity }
  end
end

function M.get()
  if M._keys then
    return M._keys
  end

  M._keys = {
    --  +----------------------------------------------------------+
    --  LSP Stuff
    --  +----------------------------------------------------------+
    { "<c-s>", vim.lsp.buf.signature_help, mode = "i", has = "signatureHelp", desc = "LSP: signature help" },
    { "gO", fzf_lua.lsp_outgoing_calls, desc = "LSP(fzflua): outgoing calls" },
    { "gI", fzf_lua.lsp_incoming_calls, desc = "LSP(fzflua): incoming calls" },
    {
      "gP",
      function()
        vim.cmd [[Lspsaga peek_definition]]
      end,
      desc = "LSP(goto-preview): preview definitions",
    },
    {
      "K",
      function()
        if vim.fn.has "nvim-0.10" == 0 and vim.bo[0].keywordprg ~= ":help" then
          vim.lsp.buf.hover()
        end
      end,
      desc = "LSP: show hover",
    },
    -- { "gd", vim.lsp.buf.definition, desc = "LSP: definition" },
    { "gd", "<CMD>Glance definitions<CR>", desc = "LSP(glance): definition" },
    {
      "gD",
      function()
        RUtils.lsp.definitions(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf(), function(ret)
          local what = {
            idx = "$",
            items = ret,
            title = "LSP definitions ref",
          }
          vim.fn.setqflist({}, " ", what)
          vim.cmd [[copen]]
        end, "lsp_definitions")
      end,
      desc = "LSP: definition ref",
    },
    {
      "gt",
      function()
        RUtils.lsp.type_definitions(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf(), function(ret)
          local what = {
            idx = "$",
            items = ret,
            title = "LSP type definition",
          }
          vim.fn.setqflist({}, " ", what)
          vim.cmd [[copen]]
        end)
      end,
      desc = "LSP: type definition",
    },
    {
      "gr",
      function()
        -- RUtils.lsp.references(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf(), function(ret)
        --   local what = {
        --     idx = "$",
        --     items = ret,
        --     title = "LSP references",
        --   }
        --   vim.fn.setqflist({}, " ", what)
        --   vim.cmd [[copen]]
        -- end, "lsp_references")
        vim.cmd [[Glance references]]
      end,
      desc = "LSP(glance): references",
    },
    {
      "<Leader>ll",
      function()
        if RUtils.has "symbol-usage.nvim" then
          require("symbol-usage").refresh()
        else
          vim.lsp.codelens.refresh { bufnr = 0 }
        end
      end,
      desc = "LSP(symbol-usage): codelens refresh",
    },
    {
      "<Leader>lL",
      function()
        if RUtils.has "symbol-usage.nvim" then
          require("symbol-usage").refresh()
          require("symbol-usage").toggle()
          vim.lsp.codelens.refresh { bufnr = 0 }
        end
      end,
      desc = "LSP(symbol-usage): codelens toggle",
    },
    --  +----------------------------------------------------------+
    --  Diagnostics
    --  +----------------------------------------------------------+
    {
      "dn",
      diagnostic_goto(true),
      desc = "LSP(diagnostic): next item",
    },
    {
      "dp",
      diagnostic_goto(false),
      desc = "LSP(diagnostic): prev item",
    },
    {
      "dP",
      function()
        vim.diagnostic.open_float { scope = "line", border = "rounded", focusable = true }
      end,
      desc = "LSP(diagnostic): preview",
    },
    {
      "dl",
      function()
        RUtils.toggle.diagnostics()
      end,
      desc = "LSP(diagnostic): toggle",
    },
    {
      "df",
      function()
        if #vim.diagnostic.get(0) == 0 then
          return RUtils.info("Diagnostics buffer is clean", { title = "" })
        end

        local items = {}
        if vim.diagnostic then
          local diags = vim.diagnostic.get(0)
          for _, item in ipairs(diags) do
            table.insert(items, RUtils.lsp.process_item(item))
          end
        end

        local what = {
          idx = "$",
          items = items,
          title = "Document diagnostics",
        }
        vim.fn.setqflist({}, " ", what)
        vim.cmd [[copen]]
      end,
      desc = "LSP(diagnostic): document diagnostics",
    },
    {
      "dF",
      function()
        local items = {}
        if vim.diagnostic then
          local diags = vim.diagnostic.get()
          for _, item in ipairs(diags) do
            table.insert(items, RUtils.lsp.process_item(item))
          end
        end

        local what = {
          idx = "$",
          items = items,
          title = "Workspaces diagnostics",
        }
        vim.fn.setqflist({}, " ", what)
        vim.cmd [[copen]]
      end,
      desc = "LSP(diagnostic): workspace diagnostics",
    },
    --  +----------------------------------------------------------+
    --  LSP commands
    --  +----------------------------------------------------------+
    {
      "gf",
      function()
        local function check_current_ft(fts)
          local ft = vim.bo[0].filetype
          if vim.tbl_contains(fts, ft) then
            return true
          end
          return false
        end

        local ft_ts = { "typescriptreact", "typescript" }

        local newCmds = {}
        if check_current_ft(ft_ts) then
          table.insert(newCmds, {
            run_TSC = function()
              vim.cmd [[TSC]]
            end,
            run_organize_imports = function()
              vim.cmd [[TSToolsOrganizeImports]]
            end,
            run_sort_imports = function()
              vim.cmd [[TSToolsSortImports]]
            end,
            run_remove_unused_imports = function()
              vim.cmd [[TSToolsRemoveUnusedImports]]
            end,
            run_tstool_fixall = function()
              vim.cmd [[TSToolsFixAll]]
            end,
            run_missing_imports = function()
              vim.cmd [[TSToolsAddMissingImports]]
            end,
          })
        elseif check_current_ft { "go" } then
          table.insert(newCmds, {
            run_gogenerate = function()
              vim.cmd [[GoGenerate %]]
            end,
            run_gomod_tidy = function()
              vim.cmd [[GoMod tidy]]
            end,
          })
        end

        local defaultCmds = vim.tbl_deep_extend("force", {
          toggle_diagnostics = function()
            RUtils.toggle.diagnostics()
          end,
          toggle_codelens = function()
            RUtils.toggle.codelens()
          end,
          toggle_semantic_tokens = function()
            RUtils.toggle.semantic_tokens()
          end,
          toggle_inlay_hint = function()
            if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
              RUtils.toggle.inlay_hints()
            else
              RUtils.warn("This LSP does not support for inlay_hint", { title = "LSP" })
            end
          end,
          toggle_number = function()
            RUtils.toggle.number()
          end,
          toggle_format_lspbuffer = function()
            RUtils.format.toggle(true)
          end,
          toggle_format_lspallbuf = function()
            RUtils.format.toggle()
          end,
          run_format_lspinfo = function()
            vim.cmd [[LazyFormatInfo]]
          end,
          run_format = function()
            vim.cmd [[LazyFormat]]
          end,
        }, unpack(newCmds) or {})

        local col, row = RUtils.fzflua.rectangle_win_pojokan()
        RUtils.fzflua.send_cmds(
          defaultCmds,
          { winopts = { title = require("r.config").icons.misc.smiley .. "LSP", row = row, col = col } }
        )
      end,
      desc = "LSP: commands of lsp",
    },
  }

  if vim.bo[0].filetype == "rust" then
    M._keys[#M._keys + 1] = {
      "<Leader>ca",
      function()
        vim.cmd.RustLsp "codeAction"
      end,
      desc = "LSP(rustaceanvim): code action",
      buffer = vim.api.nvim_get_current_buf(),
    }
  else
    M._keys[#M._keys + 1] = { "<Leader>ca", vim.lsp.buf.code_action, has = "codeAction", desc = "LSP: code action" }
  end

  if RUtils.has "inc-rename.nvim" then
    M._keys[#M._keys + 1] = {
      "gR",
      function()
        local inc_rename = require "inc_rename"
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
      end,
      expr = true,
      desc = "LSP(inc-rename): rename",
      has = "rename",
    }
  elseif RUtils.has "lspsaga.nvim" then
    M._keys[#M._keys + 1] = { "gR", "<CMD> Lspsaga rename <CR>", desc = "LSP(lspsaga): rename", has = "rename" }
  else
    M._keys[#M._keys + 1] = { "gR", vim.lsp.buf.rename, desc = "LSP: rename", has = "rename" }
  end

  return M._keys
end

function M.on_attach(client, buffer)
  RUtils.map.on_attach(client, buffer, M.get())
end

return M
