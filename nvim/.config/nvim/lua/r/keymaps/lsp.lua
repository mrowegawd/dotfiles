local M = {}

M._keys = nil

local diagnostic_goto = function(next, severity)
  local go = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, float = false, count = go }
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
        vim.lsp.buf.signature_help { border = RUtils.config.icons.border.line }
      end,
      has = "signatureHelp",
      desc = "LSP: signature help",
    },
    {
      "K",
      function()
        vim.lsp.buf.hover {
          border = "single",
          title = {
            { " Hover ", "DiagnosticFloatTitle" },
          },
        }
      end,
      desc = "LSP: show hover [noice]",
    },
    {
      "gD",
      function()
        vim.cmd [[vsplit]]
        fzf_lua.lsp_definitions { jump1 = true, ignore_current_line = true }
      end,
      has = "definition",
      desc = "LSP: definitions [fzflua]",
    },

    {
      "<a-q>",
      function()
        if RUtils.has "snacks.nvim" then
          Snacks.words.jump(-vim.v.count1)
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
          Snacks.words.jump(vim.v.count1)
        end
      end,
      has = "documentHighlight",
      cond = function()
        return Snacks.words.is_enabled()
      end,
      desc = "LSP: prev word reference",
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
      "gI",
      function()
        if RUtils.has "telescope.nvim" then
          vim.cmd [[Telescope hierarchy incoming_calls]]
        else
          fzf_lua.lsp_incoming_calls()
        end
      end,
      desc = "LSP: incoming calls [fzflua]",
    },
    {
      "gO",
      function()
        if RUtils.has "telescope.nvim" then
          vim.cmd [[Telescope hierarchy outgoing_calls]]
        else
          fzf_lua.lsp_outgoing_calls()
        end
      end,
      desc = "LSP: outgoing calls [fzflua]",
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
        return new_value
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
      desc = "LSP: list command of lsp",
    },
  }

  if vim.bo[0].filetype == "rust" then
    M._keys[#M._keys + 1] = {
      "<Leader>ca",
      function()
        vim.cmd.RustLsp "codeAction"
      end,
      desc = "Action: code action [rustaceanvim]",
      buffer = vim.api.nvim_get_current_buf(),
    }
  elseif RUtils.has "tiny-code-action.nvim" then
    M._keys[#M._keys + 1] = {
      "<Leader>ca",
      require("tiny-code-action").code_action,
      has = "codeAction",
      desc = "Action: code action [tiny-code-action]",
    }
  else
    M._keys[#M._keys + 1] = { "<Leader>ca", vim.lsp.buf.code_action, has = "codeAction", desc = "Action: code action" }
  end

  if RUtils.has "inc-rename.nvim" then
    M._keys[#M._keys + 1] = {
      "<Leader>cr",
      function()
        local inc_rename = require "inc_rename"
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
      end,
      expr = true,
      desc = "Action: rename [inc-rename]",
      has = "rename",
    }
  elseif RUtils.has "lspsaga.nvim" then
    M._keys[#M._keys + 1] =
      { "<Leader>cr", "<CMD> Lspsaga rename <CR>", desc = "Action: rename [lspsaga]", has = "rename" }
  else
    M._keys[#M._keys + 1] = { "<Leader>cr", vim.lsp.buf.rename, desc = "Action: rename", has = "rename" }
  end

  if RUtils.has "glance.nvim" then
    M._keys[#M._keys + 1] = {
      "grr",
      "<CMD>Glance references<CR>",
      has = "references",
      desc = "LSP: references [glance]",
    }
  else
    M._keys[#M._keys + 1] = {
      "grr",
      function()
        fzf_lua.lsp_references()
      end,
      has = "references",
      desc = "LSP: references [fzflua]",
    }
  end

  if RUtils.has "glance.nvim" then
    M._keys[#M._keys + 1] = {
      "gd",
      "<CMD>Glance definitions<CR>",
      has = "definition",
      desc = "LSP: definitions [glance]",
    }
  else
    M._keys[#M._keys + 1] = {
      "gd",
      function()
        fzf_lua.lsp_definitions { jump1 = true }
      end,
      desc = "LSP: definitions [fzflua]",
      has = "definition",
    }
  end

  if RUtils.has "glance.nvim" then
    M._keys[#M._keys + 1] = {
      "gt",
      "<CMD>Glance type_definitions<CR>",
      desc = "LSP: type definitions [glance]",
    }
  else
    M._keys[#M._keys + 1] = {
      "gt",
      function()
        require("telescope.builtin").lsp_type_definitions { reuse_win = true }
      end,
      desc = "LSP: type definitions",
    }
  end

  if RUtils.has "goto-preview" then
    M._keys[#M._keys + 1] = { "gP", require("goto-preview").goto_preview_definition, desc = "LSP: peek [goto-preview]" }
  else
    M._keys[#M._keys + 1] = {
      "gP",
      function()
        fzf_lua.lsp_definitions {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = {
            title = RUtils.fzflua.format_title("LSP: Peek [fzflua]", RUtils.config.icons.misc.lsp),
            relative = "editor",
            backdrop = 60,
            height = 0.80,
            width = 0.60,
            row = 0.50,
            col = 0.50,
            preview = {
              vertical = "up:80%", -- up|down:size
              layout = "vertical", -- horizontal|vertical|flex
            },
          },
        }
      end,
      has = "signatureHelp",
      desc = "LSP: peek [fzflua]",
    }
  end

  return M._keys
end

function M.on_attach(client, buffer)
  RUtils.map.on_attach(client, buffer, M.get())
end

return M
