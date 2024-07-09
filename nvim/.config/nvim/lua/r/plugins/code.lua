local Highlight = require "r.settings.highlights"

local callme = 0

local function get_cmp()
  local ok_cmp, cmp = pcall(require, "cmp")
  return ok_cmp and cmp or {}
end

return {
  -- COC.NVIM (disabled)
  {
    "neoclide/coc.nvim",
    version = "*",
    branch = "release",
    enabled = false,
    config = function()
      -- https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.lua
      local keyset = vim.keymap.set

      -- Autocomplete
      function _G.check_back_space()
        local col = vim.fn.col "." - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
      end

      -- Use Tab for trigger completion with characters ahead and navigate
      -- NOTE: There's always a completion item selected by default, you may want to enable
      -- no select by setting `"suggest.noselect": true` in your configuration file
      -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
      -- other plugins before putting this into your config
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

      keyset(
        "i",
        "<TAB>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
        opts
      )
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

      -- Make <CR> to accept selected completion item or notify coc.nvim to format
      -- <C-g>u breaks current undo, please make your own choice
      -- keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
      keyset("i", "<c-y>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
      keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Use <c-j> to trigger snippets
      keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")

      -- Use <c-space> to trigger completion
      keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

      -- Use `[g` and `]g` to navigate diagnostics
      -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
      keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
      keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

      -- GoTo code navigation
      keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
      keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand "<cword>"
        if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command("h " .. cw)
        elseif vim.api.nvim_eval "coc#rpc#ready()" then
          vim.fn.CocActionAsync "doHover"
        else
          vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
        end
      end
      keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold",
      })

      -- Symbol renaming
      keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

      -- Formatting selected code
      keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
      keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

      -- Setup formatexpr specified filetype(s)
      vim.api.nvim_create_autocmd("FileType", {
        group = "CocGroup",
        pattern = "typescript,json",
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = "Setup formatexpr specified filetype(s).",
      })

      -- Update signature help on jump placeholder
      vim.api.nvim_create_autocmd("User", {
        group = "CocGroup",
        pattern = "CocJumpPlaceholder",
        command = "call CocActionAsync('showSignatureHelp')",
        desc = "Update signature help on jump placeholder",
      })

      -- Apply codeAction to the selected region
      -- Example: `<leader>aap` for current paragraph
      local opts = { silent = true, nowait = true }
      keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
      keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

      -- Remap keys for apply code actions at the cursor position.
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
      -- Remap keys for apply source code actions for current file.
      keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
      -- Apply the most preferred quickfix action on the current line.
      keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

      -- Remap keys for apply refactor code actions.
      keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

      -- Map function and class text objects
      -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
      keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
      keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

      -- Remap <C-f> and <C-b> to scroll float windows/popups
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

      -- Use CTRL-S for selections ranges
      -- Requires 'textDocument/selectionRange' support of language server
      keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
      keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- " Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

      -- Add (Neo)Vim's native statusline support
      -- NOTE: Please see `:h coc-status` for integrations with external plugins that
      -- provide custom statusline: lightline.vim, vim-airline
      vim.opt.statusline:prepend "%{coc#status()}%{get(b:,'coc_current_function','')}"

      -- Mappings for CoCList
      -- code actions and coc stuff
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true }
      -- Show all diagnostics
      keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
      -- Manage extensions
      keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
      -- Show commands
      keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
      -- Find symbol of current document
      keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
      -- Search workspace symbols
      keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
      -- Do default action for next item
      keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
      -- Do default action for previous item
      keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
      -- Resume latest coc list
      keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
    end,
  },
  -- NVIM-CMP
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdLineEnter" },
    dependencies = {
      "davidsierradz/cmp-conventionalcommits",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "lukas-reineke/cmp-under-comparator",
      "rcarriga/cmp-dap",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function()
      local cmp = require "cmp"
      local defaults = require "cmp.config.default"()

      local function styldoc(is_border_set)
        is_border_set = is_border_set or false

        local opts = {
          border = "",
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          col_offset = -3, -- To fit lspkind icon
          side_padding = 1, -- One character margin
        }
        if is_border_set then
          opts.border = RUtils.config.icons.border.line
          opts.winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None"
        end
        return opts
      end

      local function get_lsp_completion_context(completion, source)
        local ok, source_name = pcall(function()
          return source.source.client.config.name
        end)
        if not ok then
          return nil
        end
        if source_name == "tsserver" then
          return completion.detail
        elseif source_name == "gopls" then
          return completion.detail
        elseif source_name == "rust_analyzer" then
          return completion.detail
        elseif source_name == "zls" then
          return completion.detail
        elseif source_name == "lua_ls" then
          return completion.detail
        end
      end
      return {
        auto_brackets = { "lua" }, -- configure any filetype to auto add brackets
        enabled = function()
          local disabled = false
          disabled = disabled or (RUtils.cmd.get_option "buftype" == "prompt")
          disabled = disabled or (RUtils.cmd.get_option "buftype" == "terminal")
          disabled = disabled or (RUtils.cmd.get_option "filetype" == "")
          disabled = disabled or (vim.fn.reg_recording() ~= "")
          disabled = disabled or (vim.fn.reg_executing() ~= "")
          return not disabled
        end,
        window = {
          completion = cmp.config.window.bordered(styldoc()),
          documentation = cmp.config.window.bordered(styldoc(true)),
        },
        completion = { completeopt = "menuone,noinsert,noselect" },
        -- completeopt = { "menu", "menuone", "noinsert", "noselect" },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          buffer = 1,
          rg = 1,
          path = 1,
        },
        experimental = {
          ghost_text = true,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local label_width = 30
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, label_width)

            if truncated_label ~= label then
              item.abbr = truncated_label .. "…"
            elseif string.len(label) < label_width then
              local padding = string.rep(" ", label_width - string.len(label))
              item.abbr = label .. padding
            end

            -- print(entry.source.name)
            local item_kind = item.kind
            if item_kind == nil then -- remove duplicate
              return {}
            end

            item.menu = item_kind
              .. " "
              .. (
                ({
                  -- nvim_lsp = "[LSP]",
                  obsidian = "[OBSIDIAN]",
                  obsidian_new = "[OBSIDIAN]",
                  nvim_lua = "[LUA]",
                  emoji = "[EMOJI]",
                  path = "[PATH]",
                  neorg = "[NEORG]",
                  dictionary = "[DIC]",
                  noice_popupmenu = "[Noice]",
                  -- buffer = "[BUF]",

                  spell = "[SPELL]",
                  -- codeium = "[Copilot]",
                  orgmode = "[ORG]",
                  norg = "[NORG]",
                  rg = "[RG]",
                  -- cmdline = "[CMD]",
                  git = "[GIT]",
                })[entry.source.name] or ""
              )

            local hlkind = ("CmpItemKind%s"):format(item_kind)
            item.menu_hl_group = hlkind

            local kind = RUtils.config.icons.kinds
            if kind[item.kind] then
              item.kind = kind[item.kind]
            end

            local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
            if completion_context ~= nil and completion_context ~= "" then
              item.menu = item.menu .. completion_context
            end

            -- local widths = {
            --   abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
            --   menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            -- }
            --
            -- for key, width in pairs(widths) do
            --   if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
            --     item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
            --   end
            -- end

            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end,
        },
        sorting = defaults.sorting,
        preselect = cmp.PreselectMode.None,
        mapping = {
          ["<C-r>"] = cmp.mapping(function(_)
            if callme == 0 then
              callme = 1
              cmp.complete {}
            elseif callme == 1 then
              callme = 0
              cmp.complete {
                config = {
                  sources = {
                    {
                      name = "buffer",
                      option = {
                        get_bufnrs = function()
                          return vim.tbl_filter(function(buf)
                            return vim.fn.buflisted(buf) == 1 and vim.fn.bufloaded(buf) == 1
                          end, vim.api.nvim_list_bufs())
                        end,
                      },
                    },
                  },
                },
              }
            end
          end, {
            "i",
            "s",
          }),
          ["<C-j>"] = cmp.mapping(function()
            local cmps = get_cmp()

            if cmps.visible() then
              cmps.select_next_item { behavior = "Select" }
            else
              cmps.complete {}
            end
          end, { "i" }),
          ["<C-k>"] = cmp.mapping(function()
            local cmps = get_cmp()
            if cmps.visible() then
              cmps.select_prev_item { behavior = "Select" }
            end
          end, { "i" }),
          -- WARN: cmp sometimes not triggering, check this issue
          -- https://github.com/hrsh7th/nvim-cmp/issues/1692
          -- https://github.com/hrsh7th/nvim-cmp/issues/1692#issuecomment-1855795126
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-g>"] = cmp.mapping(function()
            require("fzf-lua").complete_file {
              cmd = "rg --files --hidden",
              winopts = { preview = { hidden = "nohidden" } },
            }
          end, { "i" }),
          -- ["<C-n>"] = cmp.config.disable,
          -- ["<C-p>"] = cmp.config.disable,
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
          ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
          ["<C-y>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
          ["<C-e>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        sources = { -- remember: do not use `group_index`,
          {
            name = "nvim_lsp",
            entry_filter = function(entry)
              return cmp.lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            end,
          },
          { name = "path" },
          { name = "emoji" },
          { name = "orgmode" },
          { name = "vim-dadbod-completion" },
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.tbl_filter(function(buf)
                  return vim.fn.buflisted(buf) == 1 and vim.fn.bufloaded(buf) == 1
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      }
    end,
    main = "r.utils.cmp",
  },
  -- LUASNIP
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    build = (not RUtils.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
          opts.snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          }
          table.insert(opts.sources, { name = "luasnip" })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function()
      local luasnip = require "luasnip"

      require("luasnip.loaders.from_vscode").lazy_load {
        paths = RUtils.config.path.snippet_path,
      }

      luasnip.filetype_extend("python", { "django" })
      luasnip.filetype_extend("django-html", { "html" })
      luasnip.filetype_extend("htmldjango", { "html" })

      luasnip.filetype_extend("javascript", { "html" })
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("typescript", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html", "react" })

      luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    end,
  },
  -- NVIM-CMP Keys
  {
    "nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require "cmp"

      opts.mapping = vim.tbl_deep_extend("force", {}, opts.mapping, {
        ["<Tab>"] = cmp.mapping {
          i = function(fallback)
            if cmp.visible() then
              cmp.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              }
            elseif require("luasnip").expand_or_jumpable() then
              require("luasnip").jump(1)
            else
              fallback()
            end
          end,
          s = function(fallback)
            if require("luasnip").expand_or_jumpable() then
              require("luasnip").jump(1)
            else
              fallback()
            end
          end,
        },
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  -- MINI.PAIRS
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      RUtils.mini.pairs(opts)
    end,
    keys = {
      {
        "<Leader>up",
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            RUtils.warn("Disabled auto pairs", { title = "Option" })
          else
            RUtils.info("Enabled auto pairs", { title = "Option" })
          end
        end,
        desc = "Toggle: auto pairs [mini.pairs]",
      },
    },
  },
  -- LAZYDEV
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        -- { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  -- LIVIT_META
  {
    -- Manage libuv types with lazy. Plugin will never be loaded
    "Bilal2453/luvit-meta",
    lazy = true,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "lazydev", group_index = 0 })
    end,
  },
  -- COMMENTS-TS-CONTEXT
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
    init = function()
      if vim.fn.has "nvim-0.10" == 1 then
        vim.schedule(function()
          local get_option = vim.filetype.get_option
          vim.filetype.get_option = function(filetype, option)
            return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
              or get_option(filetype, option)
          end
        end)
      end
    end,
  },
  -- TS-COMMENTS
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = true,
    enabled = vim.fn.has "nvim-0.10" == 1,
  },
  -- SCRATCH
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    cmd = { "Scratch", "ScratchOpen" },
    opts = {
      scratch_file_dir = vim.fn.stdpath "cache" .. "/scratch.nvim", -- where your scratch files will be put
      filetypes = { "lua", "js", "sh", "ts", "go", "txt", "md", "rs" }, -- you can simply put filetype here
    },
    keys = {
      {
        "<Localleader>oS",
        "<CMD>Scratch<CR>",
        desc = "Misc: select filetype for scratch buffer [scratch]",
      },
      {
        "<Localleader>os",
        "<CMD>ScratchOpen<CR>",
        desc = "Misc: open scratch buffer [scratch]",
      },
    },
  },
  -- SESSION_KEYS (disabled)
  {
    "shmerl/session-keys",
    enabled = false,
    config = function()
      local session_keys = require "session-keys"
      session_keys.sessions.dap = {
        -- stylua: ignore
        n = { -- mode 'n'
          -- { lhs = "<F9>", rhs = function() require("dap").toggle_breakpoint() end },

          { lhs = "<c-h>", rhs = function() require("dap").continue() end },
          { lhs = "<c-j>", rhs = function() require("dap").step_over() end },
          { lhs = "<c-l>", rhs = function() require("dap").step_into() end },
          { lhs = "<c-k>", rhs = function() require("dap").up() end },
          { lhs = "<c-o>", rhs = function() require("dap").step_out() end },

          -- { lhs = "<F8>", rhs = function() require("dap").disconnect() end },
          -- { lhs = "<F20>", rhs = function() require("dap").terminate() end },

          -- { lhs = "<F17>", rhs = function() require("dap").run_last() end },
          --
          -- { lhs = "<F7>", rhs = function() require("dap").pause() end },
          -- { lhs = "<F29>", rhs = function() require("dap").reverse_continue() end },
          -- { lhs = "<F22>", rhs = function() require("dap").step_back() end },
        },
      }
    end,
  },
  -- KULALA
  {
    "mistweaverco/kulala.nvim",
    event = "VeryLazy",
  },
  -- OVERSEER.NVIM
  {
    "stevearc/overseer.nvim", -- Task runner and job management
    cmd = {
      "OverseerToggle",
      "OverseerOpen",
      "OverseerInfo",
      "OverseerRun",
      "OverseerBuild",
      "OverseerClose",
      "OverseerLoadBundle",
      "OverseerSaveBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerDebugParser",
    },
    keys = {
      {
        "rr",
        function()
          return vim.cmd "OverseerToggle!"
        end,
        desc = "Task: toggle [overseer]",
      },
      {
        "rf",
        function()
          return vim.cmd "OverseerRun"
        end,
        desc = "Task: run [overseer]",
      },
      {
        "rd",
        function()
          return vim.cmd "OverseerDebugParser"
        end,
        desc = "Task: run [overseer]",
      },
    },

    opts = {
      templates = { "builtin", "user" },
      component_aliases = {
        log = {
          {
            type = "echo",
            level = vim.log.levels.WARN,
          },
          {
            type = "file",
            filename = "overseer.log",
            level = vim.log.levels.DEBUG,
          },
        },
      },
      task_list = {
        default_detail = 1,
        direction = "bottom",
        min_height = 15,
        max_height = 15,
        bindings = {
          ["<S-tab>"] = "ScrollOutputUp",
          ["<tab>"] = "ScrollOutputDown",
          ["q"] = function()
            vim.cmd "OverseerClose"
          end,
          -- ["<c-k>"] = false,
          -- ["<c-j>"] = false,
        },
      },
    },
    config = function(_, opts)
      require("overseer").setup(opts)

      vim.api.nvim_create_user_command("OverseerDebugParser", 'lua require("overseer").debug_parser()', {})
    end,
  },
  -- NVIM-COVERAGE
  {
    "andythigpen/nvim-coverage", -- Display test coverage information
    dependencies = "nvim-lua/plenary.nvim",
    cmd = {
      "Coverage",
      "CoverageSummary",
      "CoverageLoad",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
    },
    config = function()
      require("coverage").setup {
        highlights = {
          covered = { fg = "green" },
          uncovered = { fg = "red" },
        },
      }

      Highlight.plugin("coverage_hi", {
        { CoverageCovered = { bg = { from = "ColorColumn", attr = "bg" } } },
        { CoveragePartial = { bg = { from = "ColorColumn", attr = "bg" } } },
        { CoverageUncovered = { bg = { from = "ColorColumn", attr = "bg" } } },
        { CoverageSummaryFail = { bg = { from = "ColorColumn", attr = "bg" } } },
      })
    end,
  },
  -- RUNMUX
  {
    -- "mrowegawd/runmux",
    dir = "~/.local/src/nvim_plugins/rmux",
    cmd = { "RmuxEDITConfig" },
    dependencies = {
      "stevearc/overseer.nvim",
    },
    keys = {
      { "rF", "<Cmd> RmuxRunFile <CR>", desc = "Tasks: run task" },
      -- { "rp", "<Cmd> RmuxREPL <CR>", desc = "Tasks: open pane window REPL (if the language has any)" },

      { "rl", "<Cmd> RmuxSendline <CR>", desc = "Tasks: send line" },
      { "rl", "<Cmd> RmuxSendVisualSelection <CR>", desc = "Tasks: send range line (visual)", mode = { "v" } },

      -- { "rc", "<Cmd> RmuxSendInterrupt <CR>", desc = "Tasks: send interrupt signal to targeted pane" },
      -- { "rC", "<Cmd> RmuxSendInterruptAll <CR>", desc = "Tasks: send interrupt signal to all targeted pane" },

      -- { "rt", "<Cmd> RmuxTargetPane <CR>", desc = "Tasks: change target pane" },

      { "rC", "<Cmd> RmuxKillAllPanes <CR>", desc = "Tasks: kill all panes" },
      { "rg", "<Cmd> RmuxGrepErr <CR>", desc = "Tasks: grep problem from targeted pane" },

      { "re", "<Cmd> RmuxEDITConfig <CR>", desc = "Tasks: edit rmuxrc.json" },
      { "rE", "<Cmd> RmuxREDITConfig <CR>", desc = "Tasks: load global rmuxrc.json" },
      { "rS", "<Cmd> RmuxSHOWConfig <CR>", desc = "Tasks: show setup config" },

      -- { "<a-f>", "<Cmd> RmuxToggleTerm <CR>", desc = "Tasks: open rmux toggle terminal" },
    },
    opts = {
      base = {
        file_rc = ".rmuxrc.json",
        setnotif = true,
        auto_run_tasks = true,
        tbl_opened_panes = {},
        run_with = "auto", -- mux, tt, wez, toggleterm
      },
    },
    config = function(_, opts)
      require("rmux").setup(opts)
    end,
  },
  -- REFACTORING
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>r", "", desc = "Refactor: open", mode = { "n", "v" } },
      {
        "<leader>rs",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = "v",
        desc = "Refactor: select (visual) [refactoring]",
      },
      {
        "<leader>ri",
        function()
          require("refactoring").refactor "Inline Variable"
        end,
        mode = { "n", "v" },
        desc = "Refactor: inline variable [refactoring]",
      },
      {
        "<leader>rb",
        function()
          require("refactoring").refactor "Extract Block"
        end,
        desc = "Refactor: extract block [refactoring]",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Block To File"
        end,
        desc = "Refactor: extract block to file [refactoring]",
      },
      {
        "<leader>rP",
        function()
          require("refactoring").debug.printf { below = false }
        end,
        desc = "Refactor: debug print [refactoring]",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var { normal = true }
        end,
        desc = "Refactor: debug print variable [refactoring]",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup {}
        end,
        desc = "Refactor: debug cleanup [refactoring]",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Function"
        end,
        mode = "v",
        desc = "Refactor: extract function [refactoring]",
      },
      {
        "<leader>rF",
        function()
          require("refactoring").refactor "Extract Function To File"
        end,
        mode = "v",
        desc = "Refactor: extract function to file (visual) [refactoring]",
      },
      {
        "<leader>rx",
        function()
          require("refactoring").refactor "Extract Variable"
        end,
        mode = "v",
        desc = "Refactor: extract variable (visual) [refactoring]",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var()
        end,
        mode = "v",
        desc = "Refactor: debug print variable [refactoring]",
      },
    },
    opts = {
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
      show_success_message = true, -- shows a message with information about the refactor on success
      -- i.e. [Refactor] Inlined 3 variable occurrences
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
      if RUtils.has "telescope.nvim" then
        RUtils.on_load("telescope.nvim", function()
          require("telescope").load_extension "refactoring"
        end)
      end
    end,
  },
}
