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
    -- { "K", require("noice.lsp").hover, desc = "LSP: show hover [noice]" },
    {
      "gd",
      function()
        require("telescope.builtin").lsp_definitions { reuse_win = true }
      end,
      desc = "LSP: goto definition",
      has = "definition",
    },
    { "gD", vim.lsp.buf.declaration, desc = "LSP: goto declaration" },
    {
      "gI",
      function()
        require("telescope.builtin").lsp_implementations { reuse_win = true }
      end,
      desc = "LSP: goto implementation",
    },
    {
      "gy",
      function()
        require("telescope.builtin").lsp_type_definitions { reuse_win = true }
      end,
      desc = "LSP: goto type definition",
    },
    { "<leader>cA", RUtils.lsp.action.source, desc = "LSP: source action", has = "codeAction" },
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
        RUtils.lsp.words.jump(vim.v.count1, true)
      end,
      has = "documentHighlight",
      desc = "LSP: next word reference",
    },
    {
      "<a-Q>",
      function()
        RUtils.lsp.words.jump(-vim.v.count1, true)
      end,
      has = "documentHighlight",
      desc = "LSP: prev word reference",
    },
    {
      "<Leader>cc",
      function()
        vim.lsp.codelens.run()
      end,
      desc = "LSP: run codelens",
    },
    {
      "<Leader>cC",
      function()
        vim.lsp.codelens.refresh()
      end,
      desc = "LSP: codelens refresh",
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
          show_info_formatlspinfo = function()
            vim.cmd [[LazyFormatInfo]]
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

  if RUtils.has "lsp_signature.nvim" then
    M._keys[#M._keys + 1] = {
      "<c-s>",
      function()
        require("lsp_signature").toggle_float_win()
      end,
      mode = "i",
      has = "signatureHelp",
      desc = "LSP: toggle signature help [lsp-signature]",
    }
  else
    M._keys[#M._keys + 1] =
      { "<c-s>", vim.lsp.buf.signature_help, mode = "i", has = "signatureHelp", desc = "LSP: signature help" }
  end

  if RUtils.has "goto-preview" then
    M._keys[#M._keys + 1] =
      { "gP", require("goto-preview").goto_preview_definition, desc = "LSP: peek preview definitions [goto-preview]" }
  end

  return M._keys
end

function M.on_attach(client, buffer)
  RUtils.map.on_attach(client, buffer, M.get())
end

return M
