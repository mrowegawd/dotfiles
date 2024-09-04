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
    { "gk", require("noice.lsp").hover, desc = "LSP: show hover [noice]" },
    -- { "gk", vim.lsp.buf.hover, desc = "LSP: show hover [noice]" },
    { "gK", vim.lsp.buf.signature_help, desc = "LSP: signature help", has = "signatureHelp" },
    { "gD", vim.lsp.buf.declaration, desc = "LSP: declaration" },
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
    { "<Leader>cA", RUtils.lsp.action.source, desc = "Action: source action", has = "codeAction" },
    {
      "<Leader>cR",
      RUtils.lsp.rename_file,
      has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
      desc = "Action: rename file",
    },
    {
      "gI",
      function()
        require("fzf-lua").lsp_incoming_calls()
      end,
      desc = "LSP: incoming calls [fzflua]",
    },
    {
      "gO",
      function()
        require("fzf-lua").lsp_outgoing_calls()
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
      desc = "Action: code action [rustaceanvim]",
      buffer = vim.api.nvim_get_current_buf(),
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
        require("fzf-lua").lsp_finder()
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
        require("fzf-lua").lsp_definitions {
          jump_to_single_result = true,
          jump_to_single_result_action = require("fzf-lua.actions").file_vsplit,
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = {
            title = RUtils.fzflua.format_title("Definitions", ""),
            -- relative = "cursor",
          },
          winopts_fn = function()
            local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
            local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

            local win_height = math.ceil(lines * 0.65)
            local win_width = math.ceil(columns * 2)
            return {
              width = win_width,
              height = win_height,
              row = 13,
              preview = {
                vertical = "down:45%", -- up|down:size
                horizontal = "left:55%", -- right|left:size
              },
            }
          end,
        }
      end,
      desc = "LSP: definitions [fzflua]",
      has = "definition",
    }
  end

  if RUtils.has "glance.nvim" then
    M._keys[#M._keys + 1] = {
      "gi",
      "<CMD>Glance implementations<CR>",
      desc = "LSP: implementations [glance]",
    }
  else
    M._keys[#M._keys + 1] = {
      "gi",
      function()
        require("telescope.builtin").lsp_implementations { reuse_win = true }
      end,
      desc = "LSP: implementations",
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

  -- if RUtils.has "lsp_signature.nvim" then
  --   M._keys[#M._keys + 1] = {
  --     "<c-s>",
  --     function()
  --       require("lsp_signature").toggle_float_win()
  --     end,
  --     mode = "i",
  --     has = "signatureHelp",
  --     desc = "LSP: toggle signature help [lsp-signature]",
  --   }
  -- else
  --   M._keys[#M._keys + 1] =
  --     { "<c-s>", vim.lsp.buf.signature_help, mode = "i", has = "signatureHelp", desc = "LSP: signature help" }
  -- end

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
