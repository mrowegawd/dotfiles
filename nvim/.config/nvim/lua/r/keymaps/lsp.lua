local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local M = {}

M._keys = nil

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity, float = false }
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
    { "gO", fzf_lua.lsp_outgoing_calls, desc = "LSP: outgoing calls [fzflua]" },
    { "gI", fzf_lua.lsp_incoming_calls, desc = "LSP: incoming calls [fzflua]" },
    { "K", vim.lsp.buf.hover, desc = "LSP: show hover" },
    {
      "<leader>cR",
      RUtils.lsp.rename_file,
      desc = "LSP: rename file",
      mode = { "n" },
      has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
    },
    {
      "<a-q>",
      function()
        RUtils.lsp.words.jump(vim.v.count1)
      end,
      has = "documentHighlight",
      desc = "LSP: next word reference",
    },
    {
      "<a-Q>",
      function()
        RUtils.lsp.words.jump(-vim.v.count1)
      end,
      has = "documentHighlight",
      desc = "LSP: prev word reference",
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
      "dP",
      function()
        vim.diagnostic.open_float { scope = "line", border = "rounded", focusable = true }
      end,
      desc = "Diagnostic: preview",
    },
    --  +----------------------------------------------------------+
    --  LSP commands
    --  +----------------------------------------------------------+
    {
      "gff",
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
            RUtils.toggle.inlay_hints()
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
          run_refresh_symbol_useage = function()
            require("symbol-usage").refresh()
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
          { winopts = { title = RUtils.config.icons.misc.smiley .. "LSP", row = row, col = col } }
        )
      end,
      desc = "LSP: list commands of lsp",
    },
  }

  if vim.bo[0].filetype == "rust" then
    M._keys[#M._keys + 1] = {
      "<Leader>ca",
      function()
        vim.cmd.RustLsp "codeAction"
      end,
      desc = "LSP: code action [rustaceanvim]",
      buffer = vim.api.nvim_get_current_buf(),
    }
  else
    M._keys[#M._keys + 1] = { "<Leader>ca", vim.lsp.buf.code_action, has = "codeAction", desc = "LSP: code action" }
  end

  if RUtils.has "inc-rename.nvim" then
    M._keys[#M._keys + 1] = {
      "<F2>",
      function()
        local inc_rename = require "inc_rename"
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
      end,
      expr = true,
      desc = "LSP: rename [inc-rename]",
      has = "rename",
    }
  elseif RUtils.has "lspsaga.nvim" then
    M._keys[#M._keys + 1] = { "<F2>", "<CMD> Lspsaga rename <CR>", desc = "LSP: rename [lspsaga]", has = "rename" }
  else
    M._keys[#M._keys + 1] = { "<F2>", vim.lsp.buf.rename, desc = "LSP: rename", has = "rename" }
  end

  -- if RUtils.has "lsp_signature.nvim" then
  --   M._keys[#M._keys + 1] = {
  --     "go",
  --     function()
  --       require("lsp_signature").toggle_float_win()
  --     end,
  --     desc = "LSP: toggle [lsp-signature]",
  --     has = "signatureHelp",
  --   }
  -- end

  return M._keys
end

function M.on_attach(client, buffer)
  RUtils.map.on_attach(client, buffer, M.get())
end

return M
