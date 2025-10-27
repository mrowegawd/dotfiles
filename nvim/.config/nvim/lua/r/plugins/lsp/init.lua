return {
  -- NVIM-LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
    },
    opts_extend = { "servers.*.keys" },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          -- virtual_text = {
          --   spacing = 4,
          --   source = "if_many",
          --   prefix = "■", -- "●"
          -- },
          virtual_text = false,
          severity_sort = true,
          virtual_lines = false,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = RUtils.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = RUtils.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = RUtils.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = RUtils.config.icons.diagnostics.Info,

              -- If you want to disable the sign column for diagnostics, uncomment these
              -- [vim.diagnostic.severity.ERROR] = "",
              -- [vim.diagnostic.severity.WARN] = "",
              -- [vim.diagnostic.severity.HINT] = "",
              -- [vim.diagnostic.severity.INFO] = "",
            },
            numhl = {
              [vim.diagnostic.severity.ERROR] = "DiagnosticsErrorNumHl",
              [vim.diagnostic.severity.WARN] = "DiagnosticsWarnNumHl",
              [vim.diagnostic.severity.HINT] = "DiagnosticsHintNumHl",
              [vim.diagnostic.severity.INFO] = "DiagnosticsInfoNumHl",
            },
          },
          float = {
            header = "",
            title = {
              { "  ", "DiagnosticFloatTitleIcon" },
              { "Problems ", "DiagnosticFloatTitle" },
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = false,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = true,
        },
        -- Enable this to enable the builtin LSP folding on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the folds.
        folds = {
          enabled = false,
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        -- Sets the default configuration for an LSP client (or all clients if the special name "*" is used).
        ---@alias lazyvim.lsp.Config vim.lsp.Config|{mason?:boolean, enabled?:boolean, keys?:LazyKeysLspSpec[]}
        ---@type table<string, lazyvim.lsp.Config|boolean>
        servers = {
          -- configuration for all lsp servers
          ["*"] = {
            capabilities = {
              workspace = {
                fileOperations = {
                  didRename = true,
                  willRename = true,
                },
              },
            },
            -- stylua: ignore
            keys = {
              --  +----------------------------------------------------------+
              --  LSP Core
              --  +----------------------------------------------------------+
              { "<Leader>ld",RUtils.map.lsp.wrap_location_method(vim.lsp.buf.definition), has = "definition", desc = "LSP: definitions", },
              { "<Leader>lr", vim.lsp.buf.references, desc = "LSP: references", nowait = true },
              { "<Leader>lI", vim.lsp.buf.implementation, desc = "LSP: goto implementation" },
              { "<Leader>ly", vim.lsp.buf.type_definition, desc = "LSP: goto type Definition" },
              { "<Leader>lh", RUtils.map.lsp.toggle_words, desc = "LSP: toggle words references", },
              { "<Leader>lD",RUtils.map.lsp.wrap_location_method(vim.lsp.buf.definition, true), has = "definition", desc = "LSP: definitions (vsplit)", },

              { "<Leader>clf", function() Snacks.picker.lsp_config() end, desc = "LSP: LSP Info" },

              --  +----------------------------------------------------------+
              --  Hover and SignatureHelp
              --  +----------------------------------------------------------+
              { "K", function() return vim.lsp.buf.hover() end, desc = "LSP: Hover" },
              { "gK", function() RUtils.hover_eldoc.hover_in_split() end, desc = "LSP: show hover (split) [hover_eglot]", },
              { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "LSP: signature help (insert)", has = "signatureHelp" },

              --  +----------------------------------------------------------+
              --  Code Actions
              --  +----------------------------------------------------------+
              { "<Leader>cA", RUtils.lsp.action.source, desc = "Action: source action lsp", has = "codeAction" },
              {
                "<Leader>ca",
                function()
                  if vim.bo[0].filetype == "rust" then
                    return vim.cmd.RustLsp "codeAction"
                  end
                  if RUtils.has "tiny-code-action.nvim" then
                    ---@diagnostic disable-next-line: missing-parameter
                    return require("tiny-code-action").code_action()
                  end
                end,
                mode = { "n", "x" },
                has = "codeAction",
                desc = "Action: source action",
              },
              { "<Leader>cc", vim.lsp.codelens.run, desc = "Action: run codelens", mode = { "n", "x" }, has = "codeLens" },
              { "<Leader>cC", vim.lsp.codelens.refresh, desc = "Action: codelens refresh", mode = { "n" }, has = "codeLens" },

              --  +----------------------------------------------------------+
              --  Renaming
              --  +----------------------------------------------------------+
              { "<Leader>cR", function() Snacks.rename.rename_file() end, desc = "Action: rename file", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
              { "<Leader>cr", vim.lsp.buf.rename, desc = "Action: rename", has = "rename" },

              --  +----------------------------------------------------------+
              --  Jump to Word References
              --  +----------------------------------------------------------+
              { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight", desc = "LSP: next reference"  },
              { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight", desc = "LSP: prev reference"  },

              --  +----------------------------------------------------------+
              --  Diagnostics
              --  +----------------------------------------------------------+
              { "dn", RUtils.map.lsp.diagnostic_goto(true), desc = "Diagnostic: next item" },
              { "dp", RUtils.map.lsp.diagnostic_goto(false), desc = "Diagnostic: prev item" },
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
            },
          },
          stylua = { enabled = false },
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
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
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = vim.schedule_wrap(function(_, opts)
      -- setup autoformat
      RUtils.format.register(RUtils.lsp.formatter())

      -- disable default keybindings
      for _, bind in ipairs { "grn", "gra", "gri", "grr", "gO", "grt" } do
        vim.keymap.del("n", bind)
      end
      vim.keymap.del("s", "<C-s>")

      -- setup keymaps
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and server_opts.keys then
          require("r.keymaps.lsp").set({ name = server ~= "*" and server or nil }, server_opts.keys)
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- folds
      if opts.folds.enabled then
        Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
          if RUtils.set_default("foldmethod", "expr") then
            RUtils.set_default("foldexpr", "v:lua.vim.lsp.foldexpr()")
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      -- diagnostics
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = function(diagnostic)
          local icons = RUtils.config.icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
          return "●"
        end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      if opts.capabilities then
        RUtils.deprecate("lsp-config.opts.capabilities", "Use lsp-config.opts.servers['*'].capabilities instead")
        opts.servers["*"] = vim.tbl_deep_extend("force", opts.servers["*"] or {}, {
          capabilities = opts.capabilities,
        })
      end

      if opts.servers["*"] then
        vim.lsp.config("*", opts.servers["*"])
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason = RUtils.has "mason-lspconfig.nvim"
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      local mason_exclude = {} ---@type string[]

      ---@return boolean? exclude automatic setup
      local function configure(server)
        if server == "*" then
          return false
        end
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]

        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, sopts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts) -- configure the server
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup {
          ensure_installed = vim.list_extend(install, RUtils.opts("mason-lspconfig.nvim").ensure_installed or {}),
          automatic_enable = { exclude = mason_exclude },
        }
      end
    end),
  },
  -- MASON NVIM
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<Leader>cm", "<cmd>Mason<cr>", desc = "Action: open Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  -- LAZYDEV
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    dependencies = {
      { "justinsgithub/wezterm-types", lazy = true },
    },
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = require("lazy.core.config").options.root .. "/lazy.nvim", words = { "LazyVim" } },
        -- { path = "LazyVim", words = { "LazyVim" } },
        -- { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
}
