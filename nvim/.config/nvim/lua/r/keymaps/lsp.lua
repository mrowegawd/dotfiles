local diagnostic = vim.diagnostic
local Util = require "r.utils"

local M = {}

M._keys = nil

function M.get()
  if M._keys then
    return M._keys
  end

  -- stylua: ignore
  M._keys = {
    --  +----------------------------------------------------------+
    --  LSP Stuff
    --  +----------------------------------------------------------+
    { "K", "<CMD> Lspsaga hover_doc ++silent<CR>", desc = "LSP(lspsaga): hover" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<c-s>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
    { "gd", "<CMD> Lspsaga goto_definition<CR>", desc = "LSP(lspsaga): definitions", has = "definition" },
    -- { "gr", "<cmd>FzfLua lsp_finder<cr>", desc = "LSP(fzflua): finder" },
    { "gr", "<cmd> Lspsaga finder<cr>", desc = "LSP(lspsaga): references" },
    { "gT", [[<cmd>lua require('fzf-lua').lsp_typedefs()<cr>]], desc = "LSP(fzflua): peek type definitions" },
    { "gO", [[<cmd>lua require('fzf-lua').lsp_outgoing_calls()<cr>]], desc = "LSP(fzflua): outgoing calls" },
    { "gI", [[<cmd>lua require('fzf-lua').lsp_incoming_calls()<cr>]], desc = "LSP(fzflua): incoming calls" },
    -- { "gy", function() require("telescope.builtin").lsp_type_definitions { reuse_win = true } end, desc = "Goto T[y]pe Definition" },
    -- { "gs", "<CMD>FzfLua lsp_document_symbols<CR>", desc = "LSP(fzflua): document symbols" },
    -- { "gS", "<CMD>FzfLua lsp_workspace_symbols<CR>", desc = "LSP(fzflua): workspaces symbols" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "LSP: codeAction" },
    {
      "<leader>cA",
      function()
        vim.lsp.buf.code_action {
          context = {
            only = {
              "source",
            },
            diagnostics = {},
          },
        }
      end,
      desc = "Source Action",
      has = "codeAction",
    },

    --  +----------------------------------------------------------+
    --  Toggle
    --  +----------------------------------------------------------+
    { "gt", function ()
      local function check_current_ft(fts)
        local ft = vim.bo[0].filetype
        if vim.tbl_contains(fts, ft) then
          return true
        end
        return false
      end

      local ft_ts = {"typescriptreact", "typescript"}

      local newCmds = {}
      if check_current_ft(ft_ts) then
        table.insert(newCmds, {
          run_TSC = function ()
            vim.cmd [[TSC]]
          end,
          run_organize_imports = function ()
            vim.cmd [[TSToolsOrganizeImports]]
          end,
          run_sort_imports = function ()
            vim.cmd [[TSToolsSortImports]]
          end,
          run_remove_unused_imports = function ()
            vim.cmd [[TSToolsRemoveUnusedImports]]
          end,
          run_tstool_fixall = function ()
            vim.cmd [[TSToolsFixAll]]
          end,
          run_missing_imports = function ()
            vim.cmd [[TSToolsAddMissingImports]]
          end
        })
      elseif check_current_ft({"go"}) then
        table.insert(newCmds, {
          run_gogenerate = function ()
            vim.cmd [[GoGenerate %]]
          end,
          run_gomod_tidy = function ()
            vim.cmd [[GoMod tidy]]
          end

        })

      end

      local defaultCmds = vim.tbl_deep_extend("force",
        {
          toggle_diagnostics = function()
            Util.toggle.diagnostics()
          end,
          toggle_codelens = function()
            Util.toggle.codelens()
          end,
          toggle_semantic_tokens = function()
            Util.toggle.semantic_tokens()
          end,
          toggle_inlay_hint= function()
            if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
              Util.toggle.inlay_hints()
            else
              Util.warn("This LSP does not support for inlay_hint", { title = "LSP" })
            end
          end,
          toggle_number = function()
            Util.toggle.number()
          end,
          toggle_format_lspbuffer = function()
            Util.format.toggle(true)
          end,
          toggle_format_lspallbuf = function()
            Util.format.toggle()
          end,
          run_format_lspinfo = function()
            vim.cmd [[LazyFormatInfo]]
          end,
          run_format = function()
            vim.cmd [[LazyFormat]]
          end}, unpack(newCmds) or {})

      local col, row = Util.fzflua.rectangle_win_pojokan()
      Util.fzflua.send_cmds ( defaultCmds, { winopts = { title = require("r.config").icons.misc.smiley .. "LSP", row = row, col = col } } )
    end, desc = "LSP: commands of lsp" },

    --  +----------------------------------------------------------+
    --  Diagnostics
    --  +----------------------------------------------------------+
    { "dn", function() diagnostic.goto_next { float = false } end, desc = "LSP(diagnostic): next item" },
    { "dp", function() diagnostic.goto_prev { float = false } end, desc = "LSP(diagnostic): prev item" },
    { "dP", function() vim.diagnostic.open_float({ scope = "line", border = "rounded", focusable = true }) end, desc = "LSP(diagnostic): preview" },
    { "dq",
      function()
        if #vim.diagnostic.get() == 0 then
          return Util.info("Document its clean", { title= "Diagnostics" } )
        end
        vim.cmd "Trouble document_diagnostics"
      end,
      desc = "LSP(diagnostic): sending to qf",
    },
    { "dQ",
      function()
        if #vim.diagnostic.get() == 0 then
          return Util.info("Document its clean", { title= "Diagnostics" } )
        end
        vim.cmd "Trouble workspace_diagnostics"
      end,
      desc = "LSP(diagnostic): sending to qf",
    },
  }

  if Util.has "nvim-gtd" then
    M._keys[#M._keys + 1] = {
      "gD",
      function()
        require("gtd").exec { command = "split" }
      end,
      desc = "LSP(gtd): goto definitions (split)",
    }
  else
    M._keys[#M._keys + 1] = { "gD", vim.lsp.buf.declaration, desc = "LSP: goto declaration" }
  end

  if Util.has "goto-preview" then
    M._keys[#M._keys + 1] =
      { "gP", require("goto-preview").goto_preview_definition, desc = "LSP(goto-preview): preview definitions" }
  elseif Util.has "lspsaga.nvim" then
    M._keys[#M._keys + 1] = { "gP", "<cmd>Lspsaga peek_definition<cr>", desc = "LSP[lspsaga]", has = "rename" }
  end

  if Util.has "inc-rename.nvim" then
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
  elseif Util.has "lspsaga.nvim" then
    M._keys[#M._keys + 1] = { "gR", "<CMD> Lspsaga rename <CR>", desc = "LSP(lspsaga): rename", has = "rename" }
  else
    M._keys[#M._keys + 1] = { "gR", vim.lsp.buf.rename, desc = "LSP: rename", has = "rename" }
  end
  return M._keys
end

function M.on_attach(client, buffer)
  Util.map.on_attach(client, buffer, M.get())
end

return M
