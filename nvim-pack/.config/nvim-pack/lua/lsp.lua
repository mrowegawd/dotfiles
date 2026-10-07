local add = require("vim-pack").add

local UtilKey = require "utils.map"
local IconDiagnostic = require("icons").diagnostics

add {
  { src = "mason-org/mason.nvim" },
  { src = "mason-org/mason-lspconfig.nvim" },
  { src = "WhoIsSethDaniel/mason-tool-installer.nvim" },
  {
    src = "neovim/nvim-lspconfig",
    setup = false,
    on_setup = function()
      require("mason").setup()

      require("mason-lspconfig").setup()

      require("mason-tool-installer").setup {
        ensure_installed = {
          "lua_ls",
          "stylua",

          "cbfmt",
          "markdownlint-cli2",
          "markdown-toc",
          "cspell",
        },
      }

      local diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        severity_sort = true,
        virtual_lines = false,
        -- prefix = "icons",
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = IconDiagnostic.Error,
            [vim.diagnostic.severity.WARN] = IconDiagnostic.Warn,
            [vim.diagnostic.severity.HINT] = IconDiagnostic.Hint,
            [vim.diagnostic.severity.INFO] = IconDiagnostic.Info,
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticsErrorNumHl",
            [vim.diagnostic.severity.WARN] = "DiagnosticsWarnNumHl",
            [vim.diagnostic.severity.HINT] = "DiagnosticsHintNumHl",
            [vim.diagnostic.severity.INFO] = "DiagnosticsInfoNumHl",
          },
        },
      }

      -- Uncomment this if you want to add this virtual_text on diagnostics
      -- if type(diagnostics.virtual_text) == "table" and diagnostics.virtual_text.prefix == "icons" then
      --   ---@diagnostic disable-next-line: inject-field
      --   diagnostics.virtual_text.prefix = function(diagnostic)
      --     for d, icon in pairs(IconDiagnostic) do
      --       if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
      --         return icon
      --       end
      --     end
      --     return "●"
      --   end
      -- end
      vim.diagnostic.config(diagnostics)

      -- disable default keybindings
      for _, bind in ipairs { "grn", "gra", "gri", "grr", "gO", "grt" } do
        vim.keymap.del("n", bind)
      end
      vim.keymap.del("s", "<C-s>")
      vim.keymap.del("i", "<C-s>")

      local keys = {
        --  +----------------------------------------------------------+
        --  LSP Core
        --  +----------------------------------------------------------+
        {
          "<Leader>ld",
          function()
            -- if vim.tbl_contains({ "markdown", "org" }, vim.bo.filetype) then
            --   RUtils.notes.open_item_heading_default()
            -- else
            vim.cmd "Trouble lsp_definitions toggle focus=true auto_refresh=false"
            -- end
          end,
          has = "definition",
          { desc = "LSP: definitions [trouble]" },
        },
        {
          "<Leader>lv",
          function()
            -- if vim.tbl_contains({ "markdown", "org" }, vim.bo.filetype) then
            --   RUtils.notes.open_item_heading_vsplit()
            -- else
            vim.cmd "Trouble lsp_definitions toggle focus=true auto_refresh=false open_mode=vsplit"
            -- end
          end,
          has = "definition",
          { desc = "LSP: definitions vsplit [trouble]" },
        },
        {
          "<Leader>lt",
          "<CMD>Trouble lsp_type_definitions toggle focus=true auto_refresh=false<CR>",
          has = "definition",
          { desc = "LSP: type definitions [trouble]" },
        },
        {
          "<Leader>lR",
          "<CMD>Trouble lsp toggle focus=true auto_refresh=false<CR>",
          { desc = "LSP: lsp stuff [trouble]", nowait = true },
        },
        {
          "<Leader>lr",
          "<CMD>Trouble lsp_references toggle focus=true auto_refresh=false<CR>",
          { desc = "LSP: references [trouble]", nowait = true },
        },

        --  +----------------------------------------------------------+
        --  Hover and SignatureHelp
        --  +----------------------------------------------------------+
        {
          "K",
          function()
            vim.lsp.buf.hover()
          end,
          { desc = "LSP: Hover" },
        },
        {
          "<Leader>la",
          function()
            require("utils.hover_eldoc").toggle_auto_hover()
          end,
          { desc = "LSP: show hover (split) [hover_eglot]" },
        },

        --  +----------------------------------------------------------+
        --  Code Actions
        --  +----------------------------------------------------------+
        -- { "<Leader>cA", RUtils.lsp.action.source, desc = "Action: source action LSP", has = "codeAction" },
        {
          "<Leader>ca",
          function()
            if vim.bo[0].filetype == "rust" then
              return vim.cmd.RustLsp "codeAction"
            end
            if require("utils.plugin").has_module "tiny-code-action.nvim" then
              return require("tiny-code-action").code_action {}
            end
          end,
          mode = { "n", "x" },
          has = "codeAction",
          { desc = "Action: source action" },
        },
        -- {
        --   "<Leader>luc",
        --   function()
        --     local code_lens_enabled = not vim.lsp.codelens.is_enabled()
        --     vim.lsp.codelens.enable(code_lens_enabled)
        --
        --     Log.info(tostring(code_lens_enabled))
        --   end,
        --   desc = "Action: toggle codelens",
        --   mode = { "n", "x" },
        --   has = "codeLens",
        -- },

        --  +----------------------------------------------------------+
        --  Renaming
        --  +----------------------------------------------------------+
        -- {
        --   "<Leader>cR",
        --   function()
        --     Snacks.rename.rename_file()
        --   end,
        --   desc = "Action: rename file",
        --   mode = { "n" },
        --   has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
        -- },
        {
          "<Leader>cr",
          function()
            -- -- local ok = require("utils.plugin").has_module("inc_rename", "inc-rename.nvim")
            -- local ok, inc_rename = pcall(require, "inc_rename")
            -- if not ok then
            --   return vim.lsp.buf.rename()
            -- end
            -- return ":" .. inc_rename.default_config.cmd_name .. " " .. vim.fn.expand "<cword>"
            vim.lsp.buf.rename()
          end,
          has = "rename",
          { desc = "Action: rename" },
        },

        --  +----------------------------------------------------------+
        --  Diagnostics
        --  +----------------------------------------------------------+
        { "dn", UtilKey.lsp.diagnostic_goto(1), { desc = "Diagnostic: next item" } },
        { "dp", UtilKey.lsp.diagnostic_goto(-1), { desc = "Diagnostic: prev item" } },
        {
          "dP",
          function()
            vim.diagnostic.open_float { scope = "line", border = "rounded" }
          end,
          { desc = "Diagnostic: open float peek" },
        },
      }

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      }

      local names = vim.tbl_keys(servers) ---@type string[]
      table.sort(names)
      for _, server in ipairs(names) do
        local server_opts = servers[server]
        vim.lsp.config(server, server_opts)

        if type(server_opts) == "table" and keys then
          UtilKey.lsp.set_keymaps({ name = server ~= "*" and server or nil }, keys)
        end
      end

      -- Set up LSP servers.
      -- vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      --   once = true,
      --   callback = function()
      --     -- Extend neovim's client capabilities with the completion ones.
      --     vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
      --
      --     -- local servers = vim
      --     --   .iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
      --     --   :map(function(file)
      --     --     return vim.fn.fnamemodify(file, ":t:r")
      --     --   end)
      --     --   :totable()
      --     -- vim.lsp.enable(servers)
      --   end,
      -- })

      -- HACK: Override buf_request to ignore notifications from LSP servers that don't implement a method.
      local buf_request = vim.lsp.buf_request
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.buf_request = function(bufnr, method, params, handler)
        return buf_request(bufnr, method, params, handler, function() end)
      end
    end,
  },
}
