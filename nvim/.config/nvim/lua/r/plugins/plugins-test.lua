local local_dev = true
if local_dev then
  return {}
end

local cmd = vim.cmd

-------------------------------------------------------------------------------
-- NOTE: Just do some testing for new nvim plugin
-------------------------------------------------------------------------------

local Highlight = require "r.config.highlights"

local api = vim.api
local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local ignore_fts_session = { "gitcommit", "gitrebase", "alpha", "norg", "org", "orgmode", "conf", "markdown" }

local set_icons = function(icons_name)
  return icons_name .. " "
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
  -- REST.NVIM (disabled)
  {
    "rest-nvim/rest.nvim",
    enabled = false,
    ft = "http",
    cmd = { "Rest" },
    keys = { { "<Leader>rr", "<CMD>Rest run<CR>", desc = "Open(rest-nvim): execute HTTP request" } },
    opts = { skip_ssl_verification = true },
    config = function(_, opts)
      require("rest-nvim").setup(opts)
    end,
  },
  -- NEORG (disabled)
  {
    "nvim-neorg/neorg",
    enabled = false,
    cmd = "Neorg",
    ft = "norg",
    version = "*",
    -- build = ":Neorg sync-parsers", -- This is the important bit!
    -- keys = {
    -- {
    --   "<Localleader>fL",
    --   function()
    --     RUtils.maim.insert "test.png"
    --   end,
    -- },
    -- {
    --   "<Localleader>fo",
    --   function()
    --     if vim.bo.filetype == "norg" then
    --       return cmd [[Neorg return]]
    --     else
    --       return cmd [[Neorg workspace wiki]]
    --     end
    --   end,
    --   desc = "Note: open neorg workspace [fzflua]",
    -- },
    -- {
    --   "<Localleader>ff",
    --   function()
    --     cmd [[Lazy load neorg]]
    --
    --     return fzf_lua.files {
    --       prompt = "  ",
    --       cwd = RUtils.config.path.wiki_path,
    --       rg_glob = true,
    --       file_ignore_patterns = { "%.md$", "%.json$", "%.org$" },
    --       winopts = {
    --         -- fullscreen = true,
    --         title = RUtils.fzflua.format_title("[Neorg] Files", " "),
    --       },
    --     }
    --   end,
    --   desc = "Note: find neorg files [fzflua]",
    -- },
    -- {
    --   "<Localleader>fg",
    --   function()
    --     cmd [[Lazy load neorg]]
    --     return fzf_lua.live_grep_glob {
    --       prompt = "  ",
    --       cwd = RUtils.config.path.wiki_path,
    --       rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.norg" ]],
    --       winopts = {
    --         title = RUtils.fzflua.format_title("[Neorg] Grep", " "),
    --       },
    --     }
    --   end,
    --   desc = "Note: live grep neorg files [fzflua]",
    -- },
    -- },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-neorg/neorg-telescope",
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "laher/neorg-exec",
    },
    config = function(_, opts)
      RUtils.cmd.augroup("ManageNoteMappingNeorg", {
        event = { "FileType" },
        pattern = { "norg" },
        command = function()
          require("r.keymaps.note").neorg_mappings_ft(api.nvim_get_current_buf())
        end,
      })

      RUtils.cmd.augroup("SetNorgFoldLevel", {
        event = { "FileType" },
        pattern = { "norg" },
        command = "setlocal foldlevel=0",
      })
      require("neorg").setup(opts)

      -- local path_img = "test.png"
      --
      -- local invoke_screenshot_to_neorg = function(output_path, title)
      --   title = title or "image"
      --   local maim = require "maim"
      --
      --   local command_output = maim.invoke_screenshot(path_img)
      --   -- invoke_screenshot(output_path)
      --   -- local image_markdown = "![" .. title .. "](" .. output_path .. ")"
      --   local image_neorg = ".image" .. command_output
      --
      --   if next(command_output) ~= nil then
      --     vim.notify("Could not write to " .. output_path)
      --     vim.notify(command_output)
      --     return
      --   end
      --
      --   if not vim.fn.exists(output_path) then
      --     vim.notify("could not locate " .. output_path .. " but the command looked successful")
      --     return
      --   end
      --
      --   vim.cmd("normal A" .. image_neorg)
      -- end
      --
      -- RUtils.cmd.create_command("MaimNeorg", invoke_screenshot_to_neorg(), { desc = "Maim: put image (neorg)" })
    end,
    opts = function()
      -- local invoke_screenshot = function(output_path)
      --   assert(output_path ~= nil, "output_path must be a provided")
      --   assert(type(output_path) == "string", "output_path must be a string")
      --
      --   local executable = "maim"
      --   local file_options = "-s"
      --
      --   local current_buffer = vim.api.nvim_buf_get_name(0)
      --   local current_directory = vim.fs.dirname(current_buffer)
      --   output_path = utils.get_current_buffer_directory(output_path, current_buffer, current_directory)
      --
      --   local command = executable .. " " .. file_options .. " " .. output_path
      --   -- vim.notify(command, 'debug')
      --
      --   return vim.fn.systemlist(command)
      -- end

      return {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {
            config = {
              init_open_folds = "never", -- dont let neorg set the fold
              icons = {
                code_block = {
                  width = "content",
                  conceal = true,
                },
              },
            },
          },
          ["core.ui"] = {},
          ["core.summary"] = {},
          ["external.exec"] = {
            config = {
              -- default_metadata = {
              --   enabled = false,
              --   env = {
              --     NEORG: "rocks"
              --   },
              lang_cmds = {
                rust = {
                  cmd = "rustc ${0} -o ./a.out && ./a.out && rm ./a.out",
                  type = "compiled",
                  main_wrap = [[
                ${1}
                ]],
                },
                go = {
                  cmd = "goimports -w ${0} && NO_COLOR=1 go run ${0}",
                  type = "compiled",
                  main_wrap = [[
                ${1} ]],
                },
              },
            },
          },
          ["core.highlights"] = {
            config = {
              highlights = {
                markup = {
                  bold = { [""] = "+Boolean" },
                  verbatim = { [""] = "+CodeLine1", delimiter = "+NonText" },
                },
              },
              dim = {
                tags = {
                  ranged_verbatim = {
                    code_block = {
                      reference = "CodeBlock1",
                      affect = "background",
                    },
                  },
                },
                markup = {
                  verbatim = {
                    reference = "CodeLine1",
                  },
                },
              },
            },
          },
          ["core.export"] = {},
          ["core.export.markdown"] = { config = { extensions = "all" } },
          ["core.dirman"] = {
            config = {
              workspaces = {
                gtd = fmt("%s/gtd", RUtils.config.path.wiki_path),
                wiki = RUtils.config.path.wiki_path,
                wikis = RUtils.config.path.wiki_path .. "/test",
              },
              index = "index.norg", -- The name of the main (root) .norg file
            },
          },
          ["core.esupports.metagen"] = {
            config = {
              type = "auto",
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
              name = "[Norg]",
            },
          },
          ["core.integrations.nvim-cmp"] = {},
          -- ["core.integrations.telescope"] = {},
          ["core.keybinds"] = {
            config = {
              default_keybinds = false,
              hook = function(keybinds)
                -- EXAMPLE ================================================
                -- Unmaps any Neorg key from the `norg` mode
                -- keybinds.unmap("norg", "n", "gtd")

                -- Binds the `gtd` key in `norg` mode to execute `:echo 'Hello'`
                -- keybinds.map("norg", "n", "gtd", "<cmd>echo 'Hello!'<CR>")

                -- Want to move one keybind into the other? `remap_key` moves the data of the
                -- first keybind to the second keybind, then unbinds the first keybind.
                -- keybinds.remap_key("norg", "n", "<C-c>", "<Leader>t")

                -- Remap unbinds the current key then rebinds it to have a different action
                -- associated with it.
                -- The following is the equivalent of the `unmap` and `map` calls you saw above:
                --
                -- Sometimes you may simply want to rebind the Neorg action something is bound to
                -- versus remapping the entire keybind. This remap is essentially the same as if you
                -- did `keybinds.remap("norg", "n", "<C-c>, "<cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_done<CR>")
                -- keybinds.remap_event(
                --     "norg",
                --     "n",
                --     "<C-c>",
                --     "core.norg.qol.todo_items.todo.task_done"
                -- )
                -- ========================================================

                keybinds.remap_event("norg", "n", "<Leader>oo", "core.esupports.hop.hop-link")
                -- keybinds.remap_event("norg", "n", "<M-CR>", "core.esupports.hop.hop-link", "vsplit")

                -- go next heading fold
                keybinds.remap_event("norg", "n", "<a-n>", "core.integrations.treesitter.next.heading")
                -- go prev heading fold
                keybinds.remap_event("norg", "n", "<a-p>", "core.integrations.treesitter.previous.heading")

                keybinds.remap_event("norg", "n", "<C-c>", "core.qol.todo_items.todo.task_cycle")

                -- keybinds.remap_event("norg", "n", "<right>", "core.promo.promote")
                -- keybinds.remap_event("norg", "n", "<left>", "core.promo.demote")
                keybinds.map("norg", "n", "<right>", "<cmd>Neorg keybind norg core.promo.promote nested<CR>", {})
                keybinds.map("norg", "n", "rl", "<cmd>Neorg exec cursor<CR>", {})
                keybinds.map("norg", "n", "<left>", "<cmd>Neorg keybind norg core.promo.demote nested<CR>", {})
                --
              end,
            },
          },
        },
      }
    end,
  },
  -- ORG-ROAM (disabled)
  {
    "chipsenkbeil/org-roam.nvim",
    ft = "org",
    tag = "0.1.0",
    enabled = false,
    dependencies = {
      {
        "nvim-orgmode/orgmode",
        -- tag = "0.3.4",
      },
    },
    config = function()
      require("org-roam").setup {
        directory = RUtils.config.path.wiki_path,
      }
    end,
  },
  -- NVIM-TRANSPARENT (disabled)
  {
    "xiyaowong/nvim-transparent",
    enabled = false,
    cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
    cond = vim.g.neovide == nil,
    opts = {
      extra_groups = { -- table/string: additional groups that should be cleared
        -- In particular, when you set it to 'all', that means all available groups

        -- example of akinsho/nvim-bufferline.lua
        "BufferLineTabClose",
        "BufferlineBufferSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        "BufferLineIndicatorSelected",

        "Normal",
      },
      exclude_groups = { "Folded" }, -- table: groups you don't want to clear
    },
    config = function(_, opts)
      require("transparent").setup(opts)
    end,
  },
  -- QFENTER (disabled)
  {
    "yssl/QFEnter",
    enabled = false,
    -- ft = { "qf" },
    event = "VeryLazy",
    init = function()
      -- vim.g.qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
      -- vim.g.qfenter_keymap.vopen = ['<Leader><CR>']
      -- vim.g.qfenter_keymap.hopen = ['<Leader><Space>']
      -- vim.g.qfenter_keymap.topen = ['<Leader><Tab>']

      vim.g.qfenter_keymap = {
        open = {
          "<CR>",
          "<2-LeftMouse>",
        },

        hopen = {
          "<Leader><CR>",
        },

        vopen = {
          "<Leader><Space>",
        },
      }
    end,
  },
  -- NVIM-BQF (disabled)
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    enabled = false,
    dependencies = {
      {
        "junegunn/fzf",
        build = function()
          vim.fn["fzf#install"]()
        end,
      },
    },

    opts = function()
      Highlight.plugin("NvimBqfC", {
        { BqfPreviewFloat = { link = "NormalFloat" } },
      })
      return {
        preview = {
          auto_preview = false,
          show_title = true,
          wrap = true,
          winblend = 0,
          win_height = 25,
          win_vheight = 25,
          buf_label = true,
          should_preview_cb = nil,
        },
        -- make `drop` and `tab drop` to become preferred
        func_map = {
          drop = "",
          openc = "",
          split = "<C-s>",
          vsplit = "<C-v>",
          tabdrop = "<C-t>",
          tabc = "",
          tab = "",
          ptogglemode = "p",
          ptoggleauto = "P",
          ptoggleitem = "",
          pscrollup = "<a-Up>",
          pscrolldown = "<a-Down>",
          prevfile = "",
          nextfile = "",
          sclear = "z<Tab>",
          filter = "zn",
          filterr = "zN",
          fzffilter = "zf",
        },
        filter = {
          fzf = {
            action_for = {
              ["ctrl-s"] = "split",
              ["ctrl-t"] = "tab drop",
            },
            extra_opts = {
              "+i",
              "--bind",
              "ctrl-o:toggle-all",
              "--prompt",
              "> ",
            },
          },
        },
      }
    end,
  },
  -- LSPSAGA (disabled)
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    enabled = false,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function(_, opts)
      Highlight.plugin("LspsagaCustomHi", {
        -- { SagaBorder = { link = "NormalFloat" } },
        { SagaTitle = { bg = "red", fg = "black", bold = true } },
        { SagaFileName = { link = "Directory" } },
        -- { SagaFinderFName = { bg = { from = "Boolean", attr = "fg" }, fg = { from = "Normal", attr = "bg" } } },
        -- { SagaFolderName = { link = "Directory" } },
        -- { SagaNormal = { link = "Pmenu" } },
      })

      require("lspsaga").setup(opts)
    end,
    opts = {
      ui = {
        border = "rounded",
        devicon = true,
        foldericon = true,
        title = true,
        expand = "⊞",
        collapse = "⊟",
        code_action = "💡",
        lines = { "┗", "┣", "┃", "━", "┏" },
        kind = nil,
        button = { "", "" },
        imp_sign = "󰳛 ",
      },
      diagnostic = {
        keys = {
          exec_action = "o",
          quit = "q",
          expand_or_jump = "<CR>",
          quit_in_show = { "q", "<ESC>" },
        },
      },
      code_action = {
        keys = {
          quit = "q",
          exec = "<CR>",
        },
      },
      lightbulb = {
        enable = false,
        enable_in_insert = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
      },
      scroll_preview = {
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
      },
      finder = {
        max_height = 0.8,
        left_width = 0.7,
        keys = {
          jump_to = "o",
          edit = { "e", "<CR>" },
          vsplit = "<c-v>",
          split = "<c-s>",
          tabe = "<c-t>",
          quit = {
            "q",
            "<ESC>",
            "<leader><TAB>",
            "<c-c>",
            "<c-l>",
            "<c-h>",
          },
        },
      },
      definition = {
        edit = "e",
        vsplit = "<C-v>",
        split = "<C-s>",
        tabe = "<C-t>",
        quit = "q",
      },
      rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = true,
      },
      symbol_in_winbar = {
        enable = false,
        ignore_patterns = {},
        separator = " ",
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = true,
      },
      outline = {
        win_position = "right",
        win_with = "",
        layout = "normal", -- normal, layout
        win_width = 30,
        auto_preview = true,
        detail = true,
        auto_close = true,
        close_after_jump = false,
        max_height = 0.5,
        left_width = 0.3,
        keys = {
          expand_or_jump = "o",
          quit = "q",
        },
      },
      callhierarchy = {
        keys = {
          edit = "e",
          vsplit = "s",
          split = "i",
          tabe = "t",
          jump = "o",
          quit = "q",
          expand_collapse = "u",
        },
      },
    },
  },
  -- PAREN-HINT (disabled)
  {
    "briangwaltney/paren-hint.nvim",
    event = "BufReadPost",
    enabled = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("paren-hint").setup {
        highlight = "MyParentHint",
        -- excluded filetypes
        excluded_filetypes = {
          "lspinfo",
          "packer",
          "norg",
          "org",
          "markdown",
          "checkhealth",
          "help",
          "man",
          "gitcommit",
          "TelescopePrompt",
          "TelescopeResults",
          "",
        },
      }
    end,
  },
  -- YANKYYANK.NVIM (disabled)
  {
    "gbprod/yanky.nvim",
    enabled = false,
    dependencies = not RUtils.is_win() and { "kkharji/sqlite.lua" } or {},
    opts = {
      highlight = { timer = 250 },
      ring = { storage = RUtils.is_win() and "shada" or "sqlite" },
    },
    keys = {
        -- stylua: ignore
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Misc(yank): Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Misc(yank): Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Misc(yank): Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Misc(yank): Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Misc(yank): Put yanked text before selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Misc(yank): Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Misc(yank): Cycle backward through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Misc(yank): Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Misc(yank): Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Misc(yank): Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Misc(yank): Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Misc(yank): Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Misc(yank): Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Misc(yank): Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Misc(yank): Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Misc(yank): Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Misc(yank): Put before applying a filter" },
    },
  },
  -- GKEEP (disabled; plugin di tinggalkan oleh author nya sendiri karena lack
  -- of API dari google sendiri)
  {
    -- Check and run: `python3 -m pip install gkeepapi keyring`
    "stevearc/gkeep.nvim", -- ga bisa dipake lagi? Karana `checkhealth gkeep` aja error!
    enabled = false,
    event = "BufReadPre gkeep://*",
    build = "UpdateRemotePlugins",
    cmd = { "GkeepToggle", "GkeepOpen" },
    opts = true,
  },
  -- CCC (disabled)
  {
    "uga-rosa/ccc.nvim",
    enabled = false,
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle" },
    config = function()
      local ccc = require "ccc"
      ccc.setup {
        highlighter = {
          auto_enable = true,
          excludes = {
            "dart",
            "lazy",
            "orgagenda",
            "org",
            "NeogitStatus",
            "toggleterm",
          },
        },
      }
    end,
  },
  -- MINI.INDENTSCOPE (disabled)
  {
    "echasnovski/mini.indentscope",
    enabled = false,
    version = "*",
    main = "mini.indentscope",
    event = { "VeryLazy" },
    config = function(_, opts)
      Highlight.plugin("mini.indentscopeUi", {
        theme = {
          ["*"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 1 } } },
          },
          ["catppuccin-latte"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = -0.3 } } },
          },
          ["farout"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 2.5 } } },
          },
          ["ayu"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 2.5 } } },
          },
          ["nord"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 0.8 } } },
          },
          ["vscode_modern"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 0.8 } } },
          },
          ["flexoki"] = {
            { MiniIndentscopeSymbol = { fg = { from = "Normal", attr = "bg", alter = 2 } } },
          },
        },
      })
      require("mini.indentscope").setup(opts)

      RUtils.cmd.augroup("DetachMiniIndentScope", {
        event = { "FileType" },
        pattern = {
          "DiffviewFiles",
          "NeogitCommitMessage",
          "calendar",
          "NeogitPopup",
          "NeogitStatus",
          "NvimTree",
          "Outline",
          "TelescopePrompt",
          "TelescopeResults",
          "alpha",
          "checkhealth",
          "dashboard",
          "fzf",
          "gitcommit",
          "help",
          "lazy",
          "lspinfo",
          "make",
          "man",
          "markdown",
          "mason",
          "neorg",
          "norg",
          "org",
          "orgagenda",
          "sagafinder",
          "trouble",
        },
        command = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    opts = {
      symbol = "┊",
      mappings = {
        goto_top = "<leader>k",
        goto_bottom = "<leader>j",
      },
      options = {
        try_as_border = true,
      },
      draw = {
        animation = function()
          return 0
        end,
      },
    },
  },
  -- ILLUMINATE (disabled)
  {
    "RRethy/vim-illuminate",
    enabled = false,
    event = "LazyFile",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    -- stylua: ignore
    keys = {
      { "<a-q>", function() require("illuminate").goto_next_reference(nil) end, desc = "LSP: go next reference [vim-illuminate]" },
      { "<a-Q>", function() require("illuminate").goto_prev_reference(nil) end, desc = "LSP: go prev reference [vim-illuminate]" },
    },
    config = function()
      require("illuminate").configure {
        filetypes_denylist = {
          "NeogitStatus",
          "Outline",
          "TelescopePrompt",
          "fugitiveblame",
          "blame",
          "DiffviewFiles",
          "Trouble",
          "alpha",
          "dirvish",
          "fugitive",
          "NvimTree",
          "gitcommit",
          "markdown",
          "lazy",
          "neo-tree",
          "dashboard",
          "orgagenda",
          "aerial",
          "outline",
          "sagafinder",
          "qf",
        },
      }
    end,
  },
  -- INDENTMINI (disabled)
  {
    "nvimdev/indentmini.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      Highlight.plugin("indentmini", {
        theme = {
          ["*"] = {
            { IndentLine = { fg = { from = "Normal", attr = "bg", alter = 0.5 } } },
            { IndentLineCurrent = { fg = { from = "Normal", attr = "bg", alter = 3.5 } } },
          },
        },
      })
      require("indentmini").setup {
        char = "┊",
        exclude = {
          "DiffviewFiles",
          "NeogitCommitMessage",
          "calendar",
          "neo-tree",
          "NeogitPopup",
          "NeogitStatus",
          "NvimTree",
          "Outline",
          "TelescopePrompt",
          "TelescopeResults",
          "alpha",
          "checkhealth",
          "dashboard",
          "fzf",
          "gitcommit",
          "help",
          "lazy",
          "lspinfo",
          "make",
          "man",
          "markdown",
          "mason",
          "neorg",
          "norg",
          "org",
          "orgagenda",
          "sagafinder",
          "trouble",
        },
      } -- use default config
    end,
  },
  -- GENTAGS (disabled)
  {
    "linrongbin16/gentags.nvim",
    enabled = false,
    event = "VeryLazy",
    cond = vim.fn.executable "ctags" == 1,
    opts = true,
  },
  -- MINI.SESSIONS
  {
    "echasnovski/mini.sessions",
    enabled = false,
    version = "*",
    event = "BufReadPre",
    keys = {
      {
        "<Leader>ss",
        function()
          RUtils.session.save_ses()
        end,
        desc = "Misc: save session [mini.session]",
      },

      {
        "<Leader>sl",
        function()
          RUtils.session.load_ses()
        end,
        desc = "Misc: restore last session [mini.session]",
      },
    },
    opts = {
      autoread = false,
      autowrite = false,
    },
  },
  -- COMMAND-COMPLETION
  {
    "smolck/command-completion.nvim",
    enabled = false,
    -- event = { "CmdlineEnter" },
    config = function()
      require("command-completion").setup {
        border = "single", -- What kind of border to use, passed through directly to `nvim_open_win()`,
        -- see `:help nvim_open_win()` for available options (e.g. 'single', 'double', etc.)
        max_col_num = 5, -- Maximum number of columns to display in the completion window
        min_col_width = 20, -- Minimum width of completion window columns
        use_matchfuzzy = true, -- Whether or not to use `matchfuzzy()` (see `:help matchfuzzy()`)
        -- to order completion results
        highlight_selection = true, -- Whether or not to highlight the currently
        -- selected item, not sure why this is an option tbh
        highlight_directories = true, -- Whether or not to higlight directories with
        -- the Directory highlight group (`:help hl-Directory`)
        tab_completion = true, -- Whether or not tab completion on displayed items is enabled
      }
    end,
  },
  -- GLANCE
  {
    "DNLHC/glance.nvim",
    enabled = false,
    event = { "LspAttach", "VeryLazy" },
    cmd = { "Glance" },
    opts = function()
      local actions = require("glance").actions
      return {
        -- height = 18, -- Height of the window
        zindex = 100,
        preview_win_opts = { relativenumber = false, wrap = false },
        theme = { enable = true, mode = "darken" },
        folds = {
          fold_closed = "",
          fold_open = "",
          folded = true, -- Automatically fold list on startup
        },
        -- -- Taken from https://github.com/DNLHC/glance.nvim#hooks
        -- -- Don't open glance when there is only one result and it is
        -- -- located in the current buffer, open otherwise
        -- hooks = {
        --   ---@diagnostic disable-next-line: unused-local
        --   before_open = function(results, open, jump, method)
        --     local uri = vim.uri_from_bufnr(0)
        --     if #results == 1 then
        --       local target_uri = results[1].uri or results[1].targetUri
        --
        --       if target_uri == uri then
        --         jump(results[1])
        --       else
        --         open(results)
        --       end
        --     else
        --       open(results)
        --     end
        --   end,
        -- },
        mappings = {
          list = {
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["<c-v>"] = actions.jump_vsplit,
            ["<c-s>"] = actions.jump_split,
            ["<c-t>"] = actions.jump_tab,
            ["<c-n>"] = actions.next_location,
            ["<c-p>"] = actions.previous_location,
            ["<a-n>"] = actions.next_location,
            ["<a-p>"] = actions.previous_location,
            ["h"] = actions.close_fold,
            ["l"] = actions.open_fold,
            ["p"] = actions.enter_win "preview",
            ["<C-l>"] = "",
            ["<C-h>"] = "",
            ["<C-j>"] = "",
            ["<C-k>"] = "",
          },
          preview = {
            ["ql"] = actions.close,
            ["p"] = actions.enter_win "list",
            ["<c-n>"] = actions.next_location,
            ["<c-p>"] = actions.previous_location,
            ["<a-n>"] = actions.next_location,
            ["<a-p>"] = actions.previous_location,
            ["C-l"] = "",
            ["<C-h>"] = "",
            ["<C-j>"] = "",
            ["<C-k>"] = "",
          },
        },
      }
    end,
  },
  -- OUTLINE.NVIM (false)
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineFocus", "OutlineClose" },
    enabled = false,
    keys = {
      {
        "<Localleader>oa",
        function()
          if not is_outline_opened then
            is_outline_opened = true
            vim.cmd.Outline()
          else
            is_outline_opened = false
            vim.cmd.OutlineClose()
          end
        end,
        desc = "Misc: toggle open/close outline window [outline]",
      },
      {
        "<Localleader>O",
        function()
          if vim.bo.filetype ~= "Outline" then
            local outline_win = RUtils.cmd.windows_is_opened { "Outline" }
            if outline_win.found then
              vim.cmd.OutlineFocus()
            end
          end
        end,
        desc = "Misc: move cursor to outline window [outline]",
      },
      {
        "<Localleader>oA",
        function()
          if vim.tbl_contains({ "norg", "org", "markdown", "orgagenda" }, vim.bo[0].filetype) then
            return
          end

          if vim.bo[0].filetype == "outline" then
            vim.cmd "wincmd w"
          end

          local outline_providers_selected = { "all" }

          for key, icon in pairs(RUtils.config.icons.kinds) do
            table.insert(outline_providers_selected, icon .. " " .. key)
          end

          fzf_lua.fzf_exec(outline_providers_selected, {
            prompt = "  ",
            no_esc = true,
            fzf_opts = { ["--layout"] = "reverse" },
            winopts_fn = {
              width = widthc,
              height = heightc,
            },
            winopts = {
              title = "[Outline] filter symbols",
              row = 1,
              relative = "cursor",
              height = 0.33,
              width = widthc / (widthc + vim_width - 10),
            },
            actions = {
              ["default"] = function(selected, _)
                local sel = {}
                for word in selected[1]:gmatch "%w+" do
                  table.insert(sel, word)
                end
                local selection = sel[1]

                if selection ~= nil and type(selection) == "string" then
                  local opts_outline = RUtils.opts "outline.nvim"
                  local outline = get_outline()

                  local outline_win = RUtils.cmd.windows_is_opened { "Outline" }
                  if outline_win.found then
                    outline.close_outline()
                  end

                  vim.cmd "e "
                  if selection == "all" then
                    opts_outline.symbols.filter = nil
                  else
                    opts_outline.symbols.filter = { selection }
                  end
                  outline.setup(opts_outline)

                  vim.schedule(function()
                    outline.open_outline()
                  end)
                end
              end,
            },
          })
        end,
        desc = "Misc: change filter kind [outline]",
      },
    },
    opts = function()
      RUtils.disable_ctrl_i_and_o("NoOutline", { "Outline" })
      Highlight.plugin("OutlineAuHi", {
        theme = {
          ["*"] = {
            {
              OutlineCurrent = {
                fg = { from = "ErrorMsg", attr = "fg", alter = -0.3 },
                bg = "NONE",
              },
            },
            {
              OutlineDetails = {
                fg = { from = "Comment", attr = "fg", alter = -0.5 },
                bg = "NONE",
              },
            },
            {
              OutlineFoldMarker = {
                fg = { from = "FoldColumn", attr = "fg", alter = 0.2 },
                bg = "NONE",
              },
            },
            {
              OutlineGuides = {
                fg = { from = "FoldColumn", attr = "fg", alter = -0.1 },
                bg = "NONE",
              },
            },
            {
              OutlineLineno = {
                bg = "NONE",
              },
            },
          },
          ["onedark"] = {
            {
              OutlineDetails = {
                fg = { from = "Comment", attr = "fg", alter = 0.05 },
                bg = "NONE",
              },
            },
            {
              OutlineGuides = {
                fg = { from = "FoldColumn", attr = "fg", alter = 0.1 },
                bg = "NONE",
              },
            },
          },
          ["solarized-osaka"] = {
            {
              OutlineGuides = {
                fg = { from = "FoldColumn", attr = "fg", alter = 0.2 },
                bg = "NONE",
              },
            },
          },
          ["selenized"] = {
            {
              OutlineDetails = {
                fg = { from = "Comment", attr = "fg", alter = 0.1 },
                bg = "NONE",
              },
            },
            {
              OutlineCurrent = {
                fg = { from = "Error", attr = "fg", alter = -0.1 },
                bg = "NONE",
              },
            },
            {
              OutlineGuides = {
                fg = { from = "FoldColumn", attr = "fg" },
                bg = "NONE",
              },
            },
          },
          ["miasma"] = {
            {
              OutlineDetails = {
                fg = { from = "Comment", attr = "fg", alter = -0.2 },
                bg = "NONE",
              },
            },
            {
              OutlineGuides = {
                fg = { from = "FoldColumn", attr = "fg", alter = 0.05 },
                bg = "NONE",
              },
            },
            {
              OutlineCurrent = {
                fg = { from = "ErrorMsg", attr = "fg", alter = 0.5 },
              },
            },
          },
        },
      })

      local kind = RUtils.config.icons.kinds

      return {
        outline_window = {
          position = "right",
          winhl = "Normal:Normal,EndOfBuffer:None,NonText:Normal",
          focus_on_open = false,
        },
        symbols = {
          filter = nil,
          -- icons = RUtils.config.icons.kinds,
          icons = {
            File = { icon = kind.File, hl = "Identifier" },
            Module = { icon = kind.Module, hl = "Include" },
            Namespace = { icon = kind.Namespace, hl = "Include" },
            Package = { icon = kind.Package, hl = "Include" },
            Class = { icon = kind.Class, hl = "Type" },
            Method = { icon = kind.Method, hl = "Function" },
            Property = { icon = kind.Property, hl = "Identifier" },
            Field = { icon = kind.Field, hl = "Identifier" },
            Constructor = { icon = kind.Constructor, hl = "Special" },
            Enum = { icon = kind.Enum, hl = "Type" },
            Interface = { icon = kind.Interface, hl = "Type" },
            Function = { icon = kind.Function, hl = "Function" },
            Variable = { icon = kind.Variable, hl = "Constant" },
            Constant = { icon = kind.Constant, hl = "Constant" },
            String = { icon = kind.String, hl = "String" },
            Number = { icon = kind.number, hl = "Number" },
            Boolean = { icon = kind.Boolean, hl = "Boolean" },
            Array = { icon = kind.Array, hl = "Constant" },
            Object = { icon = kind.Object, hl = "Type" },
            Key = { icon = kind.Key, hl = "Type" },
            Null = { icon = kind.Null, hl = "Type" },
            EnumMember = { icon = kind.EnumNumber, hl = "Identifier" },
            Struct = { icon = kind.Struct, hl = "Structure" },
            Event = { icon = kind.Event, hl = "Type" },
            Operator = { icon = kind.Operator, hl = "Identifier" },
            TypeParameter = { icon = kind.TypeParameter, hl = "Identifier" },
            Component = { icon = kind.Component, hl = "Function" },
            Fragment = { icon = "󰅴", hl = "Constant" },

            TypeAlias = { icon = kind.TypeAlias, hl = "Type" },
            Parameter = { icon = kind.Parameter, hl = "Identifier" },
            StaticMethod = { icon = kind.StaticMethod, hl = "Function" },
            Macro = { icon = kind.Macro, hl = "Function" },
          },
          --
        },
        preview_window = {
          live = true,
          winhl = "NormalFloat:NormalFloat",
        },
        -- These keymaps can be a string or a table for multiple keys.
        -- Set to `{}` to disable. (Using 'nil' will fallback to default keys)
        keymaps = {
          show_help = "?",
          close = { "<Esc>", "q", "<Leader><TAB>" },
          goto_location = { "<Cr>", "o" },
          peek_location = {},
          goto_and_close = {},
          restore_location = {},
          hover_symbol = {},
          toggle_preview = { "P", "p" },
          rename_symbol = {},
          code_actions = {},
          fold = "h",
          fold_toggle = { "<tab>", "za" },
          fold_toggle_all = "<S-tab>",
          unfold = "l",
          fold_all = { "zm", "zM" },
          unfold_all = { "zO", "zR" },
          fold_reset = "<space><space>",
          down_and_goto = "<a-n>",
          up_and_goto = "<a-p>",
        },
      }
    end,
  },
  -- VISTA.NVIM
  {
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    enabled = function()
      if RUtils.config.lsp_style == "coc" then
        return true
      end
      return false
    end,
    config = function()
      vim.g.vista_icon_indent = { "╰─▸ ", "├─▸ " }
    end,
  },
  -- VIM-TMUX-NAVIGATOR (disabled)
  {
    "christoomey/vim-tmux-navigator",
    enabled = false,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
    keys = {
      -- TmuxNavigatePrevious
      {
        "<a-k>",
        "<cmd>TmuxNavigateUp<CR>",
        desc = "Winav(vim-tmux-navigator): move up",
      },
      {
        "<a-j>",
        "<cmd>TmuxNavigateDown<CR>",
        desc = "Winav(vim-tmux-navigator): move down",
      },
      {
        "<a-h>",
        "<cmd>TmuxNavigateLeft<CR>",
        desc = "Winav(vim-tmux-navigator): move left",
      },
      {
        "<a-l>",
        "<cmd>TmuxNavigateRight<CR>",
        desc = "Winav(vim-tmux-navigator): move right",
      },

      -- RESIZE
      {
        "<a-K>",
        "<cmd>resize +2<CR>",
        desc = "Winav: resize up",
      },
      {
        "<a-J>",
        "<cmd>resize -2<CR>",
        desc = "Winav: resize down",
      },

      {
        "<a-H>",
        "<cmd>vertical resize -2<CR>",
        desc = "Winav: resize left",
      },
      {
        "<a-L>",
        "<cmd>vertical resize +2<CR>",
        desc = "Winav: resize right",
      },
    },
  },
  -- NVIM-SURROUND (disabled)
  {
    "kylechui/nvim-surround",
    enabled = false,
    event = "BufReadPost",
    version = "*",
    keys = {
      "<Leader>s", -- how to use it: ysiw, yd<brackets>, yc<brackets>
      "<Leader>ss",
      "<Leader>sS",
      "<Leader>sc",
      "<Leader>sd",
      { "s", "S", remap = true, mode = { "x" } },
      -- { "<C-v>s", mode = { "i" } },
      -- { "<C-v>S", mode = { "i" } },
    },
    config = function()
      local input = require("nvim-surround.input").get_input
      require("nvim-surround").setup {
        keymaps = {
          insert = "<C-v>s",
          insert_line = "<C-v>S",
          visual = "S",
          visual_line = "gS",
          normal = "<space>s",
          normal_cur = "<space>ss",
          normal_line = "<space>sS",
          normal_cur_line = "<space>SS",
          delete = "<space>sd",
          change = "<space>sc",
          change_line = "<space>sC",
        },
        -- Configuration here, or leave empty to use defaults
        aliases = {
          ["d"] = { "{", "[", "(", "<", '"', "'", "`" }, -- any delimiter
          ["b"] = { "{", "[", "(", "<" }, -- bracket
          ["p"] = { "(" },
        },
        surrounds = {
          ["f"] = {
            change = {
              target = "^.-([%w_.]+!?)()%(.-%)()()$",
              replacement = function()
                local result = input "Enter the function name: "
                if result then
                  return { { result }, { "" } }
                end
              end,
            },
          },
          ["g"] = {
            add = function()
              local result = require("nvim-surround.config").get_input "Enter the generic name: "
              if result then
                return {
                  { result .. "<" },
                  { ">" },
                }
              end
            end,
            find = "[%w_]-<.->",
            delete = "^([%w_]-<)().-(>)()$",
          },
          ["G"] = {
            add = function()
              local result = require("nvim-surround.config").get_input "Enter the generic name: "
              if result then
                return {
                  { result .. "<" },
                  { ">" },
                }
              end
            end,
            find = "[%w_]-<.->",
            delete = "^([%w_]-<)().-(>)()$",
          },
        },
        move_cursor = false,
      }
    end,
  },
  -- MINI.COMMENT (disabled)
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    enabled = vim.fn.has "nvim-0.10" == 0,
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  -- TMUX.NVIM (disabled)
  {
    "aserowy/tmux.nvim",
    enabled = false,
    keys = {
      {
        "<a-k>",
        "<cmd>lua require('tmux').move_top()<CR>",
        desc = "Winav(tmux): move up",
      },
      {
        "<a-j>",
        "<cmd>lua require('tmux').move_bottom()<CR>",
        desc = "Winav(tmux): move down",
      },
      {
        "<a-h>",
        "<cmd>lua require('tmux').move_left()<CR>",
        desc = "Winav(tmux): move left",
      },
      {
        "<a-l>",
        "<cmd>lua require('tmux').move_right()<CR>",
        desc = "Winav(tmux): move right",
      },

      -- RESIZE
      {
        "<a-K>",
        function()
          return require("tmux").resize_top()
        end,
        desc = "Winav(tmux): resize up",
      },
      {
        "<a-J>",
        function()
          return require("tmux").resize_bottom()
        end,
        desc = "Winav(tmux): resize down",
      },

      {
        "<a-H>",
        function()
          return require("tmux").resize_left()
        end,
        desc = "Winav(tmux): resize left",
      },
      {
        "<a-L>",
        function()
          return require("tmux").resize_right()
        end,
        desc = "Winav(tmux): resize right",
      },
    },
    config = function(_, opts)
      require("tmux").setup(opts)
    end,
    opts = {
      -- copy_sync = {
      -- enables copy sync. by default, all registers are synchronized.
      -- to control which registers are synced, see the `sync_*` options.
      --   enable = false,
      -- },
      navigation = {
        -- cycles to opposite pane while navigating into the border
        -- cycle_navigation = false,
        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = false,
        -- prevents unzoom tmux when navigating beyond vim border
        persist_zoom = false,
      },
      resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = false,
        -- sets resize steps for x axis
        resize_step_x = 4,

        -- sets resize steps for y axis
        resize_step_y = 4,
      },
    },
  },
  -- OIL (disabled)
  {
    "stevearc/oil.nvim",
    enabled = false,
    keys = {
      {
        "<Leader>e",
        function()
          -- if vim.bo[0].filetype == "neo-tree" then
          --   return cmd [[q]]
          -- end
          -- RUtils.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, false)
          -- if vim.bo[0].filetype == "norg" then
          --   return cmd "Neotree toggle "
          -- end
          require("oil").open()
          -- return cmd "Neotree toggle reveal"
        end,
        desc = "Misc: open oil [oil.nvim] ",
      },
    },
    opts = {
      default_file_explorer = false,
      use_default_keymaps = false,
      delete_to_trash = true,
      keymaps = {
        ["?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-v>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<Esc>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["I"] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    },
    -- config = function(_, opts)
    --   local oil = require "oil"
    --   oil.setup(opts)
    --   vim.keymap.set("n", "<leader>pv", oil.open, { desc = "Open directory view" })
    -- end,
    -- cond = not_vscode,
  },
  -- NVIM-TREE (disabled)
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    cmd = { "NvimTreeToggle", "NvimTreeClose", "NvimTreeFindFileToggle" },
    -- init = function()
    --   RUtils.disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })
    -- end,
    keys = {
      {
        "<Leader>e",
        function()
          --   if vim.bo[0].filetype == "neo-tree" then
          --     return cmd [[q]]
          --   end
          --   RUtils.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, false)
          --   if vim.bo[0].filetype == "norg" then
          --     return cmd "Neotree toggle "
          --   end
          return cmd "NvimTreeToggle"
        end,
        desc = "Misc: open toggle [nvimtree]",
      },
      -- {
      --   "<Leader>ge",
      --   function()
      --     -- if vim.bo[0].filetype == "neo-tree" then
      --     --   return cmd [[q]]
      --     -- end
      --     return cmd "NvimTreeFindFileToggle"
      --   end,
      --   desc = "Misc: open file explore [neotree]",
      -- },
      {
        "<Leader>E",
        function()
          return cmd "NvimTreeFindFileToggle"
        end,
        desc = "Misc: find file toggle [neotree]",
      },
    },
    dependencies = {
      "mrbjarksen/neo-tree-diagnostics.nvim",
      "nvim-lua/plenary.nvim",
      -- {
      --   "ten3roberts/window-picker.nvim",
      --   name = "window-picker",
      --   config = function()
      --     local picker = require "window-picker"
      --     picker.setup()
      --     picker.pick_window = function()
      --       return picker.select({ hl = "WindowPicker", prompt = "Pick window: " }, function(winid)
      --         return winid or nil
      --       end)
      --     end
      --   end,
      -- },
    },

    config = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      -- vim.g.loaded_netrw = 0
      -- vim.g.loaded_netrwPlugin = 0
      -- vim.g.loaded_netrw = 0
      -- vim.g.loaded_netrwPlugin = 0

      vim.g.loaded_netrw = 0
      vim.g.loaded_netrwPlugin = 0

      local function on_attach(bufnr)
        local tree_api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set("n", "<C-]>", tree_api.tree.change_root_to_node, opts "CD")
        vim.keymap.set("n", "<space-e>", tree_api.node.open.replace_tree_buffer, opts "Open: In Place")
        vim.keymap.set("n", "<C-k>", tree_api.node.show_info_popup, opts "Info")
        vim.keymap.set("n", "<C-r>", tree_api.fs.rename_sub, opts "Rename: Omit Filename")
        vim.keymap.set("n", "<C-t>", tree_api.node.open.tab, opts "Open: New Tab")
        vim.keymap.set("n", "<C-v>", tree_api.node.open.vertical, opts "Open: Vertical Split")
        vim.keymap.set("n", "<C-s>", tree_api.node.open.horizontal, opts "Open: Horizontal Split")
        vim.keymap.set("n", "<BS>", tree_api.node.navigate.parent_close, opts "Close Directory")
        vim.keymap.set("n", "<CR>", tree_api.node.open.edit, opts "Open")
        vim.keymap.set("n", "<Tab>", tree_api.node.open.preview, opts "Open Preview")
        vim.keymap.set("n", ">", tree_api.node.navigate.sibling.next, opts "Next Sibling")
        vim.keymap.set("n", "<", tree_api.node.navigate.sibling.prev, opts "Previous Sibling")
        vim.keymap.set("n", ".", tree_api.node.run.cmd, opts "Run Command")
        vim.keymap.set("n", "-", tree_api.tree.change_root_to_parent, opts "Up")
        vim.keymap.set("n", "a", tree_api.fs.create, opts "Create")
        vim.keymap.set("n", "bmv", tree_api.marks.bulk.move, opts "Move Bookmarked")
        vim.keymap.set("n", "B", tree_api.tree.toggle_no_buffer_filter, opts "Toggle No Buffer")
        vim.keymap.set("n", "c", tree_api.fs.copy.node, opts "Copy")
        vim.keymap.set("n", "C", tree_api.tree.toggle_git_clean_filter, opts "Toggle Git Clean")
        vim.keymap.set("n", "gp", tree_api.node.navigate.git.prev, opts "Prev Git")
        vim.keymap.set("n", "gn", tree_api.node.navigate.git.next, opts "Next Git")
        vim.keymap.set("n", "d", tree_api.fs.remove, opts "Delete")
        vim.keymap.set("n", "D", tree_api.fs.trash, opts "Trash")
        vim.keymap.set("n", "E", tree_api.tree.expand_all, opts "Expand All")
        vim.keymap.set("n", "e", tree_api.fs.rename_basename, opts "Rename: Basename")
        vim.keymap.set("n", "]e", tree_api.node.navigate.diagnostics.next, opts "Next Diagnostic")
        vim.keymap.set("n", "[e", tree_api.node.navigate.diagnostics.prev, opts "Prev Diagnostic")
        vim.keymap.set("n", "F", tree_api.live_filter.clear, opts "Clean Filter")
        vim.keymap.set("n", "f", tree_api.live_filter.start, opts "Filter")
        vim.keymap.set("n", "g?", tree_api.tree.toggle_help, opts "Help")
        vim.keymap.set("n", "gy", tree_api.fs.copy.absolute_path, opts "Copy Absolute Path")
        vim.keymap.set("n", "H", tree_api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
        vim.keymap.set("n", "I", tree_api.tree.toggle_gitignore_filter, opts "Toggle Git Ignore")
        vim.keymap.set("n", "J", tree_api.node.navigate.sibling.last, opts "Last Sibling")
        -- vim.keymap.set("n", "K", tree_api.node.navigate.sibling.first, opts "First Sibling")
        vim.keymap.set("n", "m", tree_api.marks.toggle, opts "Toggle Bookmark")
        vim.keymap.set("n", "o", tree_api.node.open.edit, opts "Open")
        vim.keymap.set("n", "O", tree_api.node.open.no_window_picker, opts "Open: No Window Picker")
        vim.keymap.set("n", "p", tree_api.fs.paste, opts "Paste")
        vim.keymap.set("n", "P", tree_api.node.navigate.parent, opts "Parent Directory")
        vim.keymap.set("n", "q", tree_api.tree.close, opts "Close")
        vim.keymap.set("n", "r", tree_api.fs.rename, opts "Rename")
        vim.keymap.set("n", "R", tree_api.tree.reload, opts "Refresh")
        vim.keymap.set("n", "s", function()
          vim.cmd [[wincmd p]]
        end, opts "Run System")
        vim.keymap.set("n", "S", tree_api.tree.search_node, opts "Search")
        vim.keymap.set("n", "U", tree_api.tree.toggle_custom_filter, opts "Toggle Hidden")
        vim.keymap.set("n", "W", tree_api.tree.collapse_all, opts "Collapse")
        vim.keymap.set("n", "x", tree_api.fs.cut, opts "Cut")
        vim.keymap.set("n", "y", tree_api.fs.copy.filename, opts "Copy Name")
        vim.keymap.set("n", "Y", tree_api.fs.copy.relative_path, opts "Copy Relative Path")
        vim.keymap.set("n", "<2-LeftMouse>", tree_api.node.open.edit, opts "Open")
        vim.keymap.set("n", "<2-RightMouse>", tree_api.tree.change_root_to_node, opts "CD")
      end

      local nvimtree = require "nvim-tree"
      nvimtree.setup {
        on_attach = on_attach,
        select_prompts = true,
        disable_netrw = false,
        hijack_netrw = true,
        respect_buf_cwd = true,
        actions = {
          open_file = {
            quit_on_open = false,
            window_picker = {
              enable = true,
              picker = "default",
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
        },
        view = {
          preserve_window_proportions = true,
        },
        renderer = {
          indent_markers = {
            enable = false,
          },
          root_folder_modifier = ":t",
          highlight_git = true,
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
            webdev_colors = true,
            git_placement = "after",

            glyphs = {
              default = RUtils.config.icons.documents.unknown,
              symlink = RUtils.config.icons.documents.symlink,
              git = {
                unstaged = RUtils.config.icons.git.added,
                staged = RUtils.config.icons.git.added,
                unmerged = RUtils.config.icons.git.unmerged,
                renamed = RUtils.config.icons.git.rename,
                deleted = RUtils.config.icons.git.removed,
                untracked = RUtils.config.icons.git.untrack,
                ignored = "",
              },
              folder = {
                default = RUtils.config.icons.documents.folder,
                open = RUtils.config.icons.documents.openfolder,
                empty = RUtils.config.icons.documents.emptyfolder,
                empty_open = RUtils.config.icons.documents.emptyopenfolder,
                symlink = RUtils.config.icons.documents.foldersymlink,
              },
            },
          },
        },
        filters = {
          custom = {
            -- ".git", -- folder wiki pada learning/git tidak terbaca kalau tidak di commented
            "node_modules",
            ".cache",
            "__pycache__",
          },
        },
      }
    end,
  },
  -- HOUDINI
  {
    "TheBlob42/houdini.nvim",
    enabled = false,
    config = function()
      require("houdini").setup {
        mappings = { "jk", "kj" },
      }
    end,
  },
  -- HARPOON (disabled)
  {
    "ThePrimeagen/harpoon",
    enabled = false,
    --stylua: ignore
    keys = {
      { "<Leader>ja", function() require("harpoon.mark").add_file() end, desc = "Misc: add file [harpoon]" },
      { "<Leader>jm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Misc(harpoon): file menu" },
      { "<Leader>jc", function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = "Misc(harpoon): command menu" },
      { "<Leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Misc(harpoon): file 1" },
      { "<Leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Misc(harpoon): file 2" },
      -- { "<Leader>3", function() require("harpoon.term").gotoTerminal(1) end, desc = "Terminal 1" },
      -- { "<Leader>4", function() require("harpoon.term").gotoTerminal(2) end, desc = "Terminal 2" },
      -- { "<Leader>5", function() require("harpoon.term").sendCommand(1,1) end, desc = "Command 1" },
      -- { "<Leader>6", function() require("harpoon.term").sendCommand(1,2) end, desc = "Command 2" },
    },
    opts = {
      global_settings = {
        save_on_toggle = true,
        enter_on_sendcmd = true,
      },
    },
  },
  -- CALENDAR
  {
    "itchyny/calendar.vim",
    cmd = { "Calendar" },
    lazy = false,
    config = function()
      RUtils.cmd.create_command("CalendarBelow", function()
        vim.cmd [[ Calendar -view=year -split=horizontal -position=below -height=12 ]]
        vim.cmd [[wincmd J]]
      end, { desc = "Misc: open calendar below [calendar.nvim]" })
    end,
    keys = {
      -- { "<Localleader>oc", "<CMD> Calendar <CR>", desc = "Misc: open calendar [calendar.nvim]" },
      { "<Localleader>oc", "<CMD>CalendarBelow <CR>", desc = "Misc: open calendar [calendar.nvim]" },
    },
  },
  -- MINI.COMPLETION (disabled)
  {
    "echasnovski/mini.completion",
    enabled = false,
    event = "InsertEnter",
    version = "*",
    config = function()
      vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
      vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

      local keys = {
        ["cr"] = vim.api.nvim_replace_termcodes("<CR>", true, true, true),
        ["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
        ["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<C-y><CR>", true, true, true),
      }

      _G.cr_action = function()
        if vim.fn.pumvisible() ~= 0 then
          -- If popup is visible, confirm selected item or add new line otherwise
          local item_selected = vim.fn.complete_info()["selected"] ~= -1
          return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
        else
          -- If popup is not visible, use plain `<CR>`. You might want to customize
          -- according to other plugins. For example, to use 'mini.pairs', replace
          -- next line with `return require('mini.pairs').cr()`
          return keys["cr"]
        end
      end

      vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })

      require("mini.completion").setup {

        -- Delay (debounce type, in ms) between certain Neovim event and action.
        -- This can be used to (virtually) disable certain automatic actions by
        -- set=     -- No need to copy this inside `setup()`. Will be used automaticallyn.ting very high delay time (like 10^7).
        delay = { completion = 100, info = 100, signature = 50 },

        -- Configuration for action windows:
        -- - `height` and `width` are maximum dimensions.
        -- - `border` defines border (as in `nvim_open_win()`).
        window = {
          info = { height = 25, width = 80, border = "none" },
          signature = { height = 25, width = 80, border = "none" },
        },

        -- Way of how module does LSP completion
        lsp_completion = {
          -- `source_func` should be one of 'completefunc' or 'omnifunc'.
          source_func = "omnifunc",

          -- `auto_setup` should be boolean indicating if LSP completion is set up
          -- on every `BufEnter` event.
          auto_setup = false,

          -- `process_items` should be a function which takes LSP
          -- 'textDocument/completion' response items and word to complete. Its
          -- output should be a table of the same nature as input items. The most
          -- common use-cases are custom filtering and sorting. You can use
          -- default `process_items` as `MiniCompletion.default_process_items()`.
          -- process_items = --<function: filters out snippets; sorts by LSP specs>,
        },

        -- Fallback action. It will always be run in Insert mode. To use Neovim's
        -- built-in completion (see `:h ins-completion`), supply its mapping as
        -- string. Example: to use 'whole lines' completion, supply '<C-x><C-l>'.
        -- fallback_action = --<function: like `<C-n>` completion>,

        -- Module mappings. Use `''` (empty string) to disable one. Some of them
        -- might conflict with system mappings.
        mappings = {
          force_twostep = "<C-n>", -- Force two-step completion
          force_fallback = "<A-Space>", -- Force fallback completion
        },

        -- Whether to set Vim's settings for better experience (modifies
        -- `shortmess` and `completeopt`)
        set_vim_settings = true,
      }
    end,
  },
  -- GITHUB NOTIFICATIONS
  { "rlch/github-notifications.nvim" },
  -- GIT-WORKTREE
  {
    "ThePrimeagen/git-worktree.nvim",
    enabled = false,
    opts = true,
    config = function()
      ---@diagnostic disable-next-line: undefined-field
      require("telescope").load_extension "git_worktree"
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    -- keys = {
    --   {
    --     "<leader>gwm",
    --     function()
    --       require("telescope").extensions.git_worktree.git_worktrees()
    --     end,
    --     desc = "Git(git-worktree): manage",
    --   },
    --   {
    --     "<leader>gwc",
    --     function()
    --       require("telescope").extensions.git_worktree.create_git_worktree()
    --     end,
    --     desc = "Git(git-worktree): create",
    --   },
    -- },
  },
  -- MINI.ANIMATE
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    enabled = false,
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs { "Up", "Down" } do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require "mini.animate"
      return {
        resize = {
          timing = animate.gen_timing.linear { duration = 100, unit = "total" },
        },
        scroll = {
          timing = animate.gen_timing.linear { duration = 300, unit = "total" },
          subscroll = animate.gen_subscroll.equal {
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          },
        },
      }
    end,
  },
  -- INCLINE.NVIM (disabled)
  {
    "b0o/incline.nvim",
    enabled = false,
    event = "LazyFile",
    opts = function()
      return {
        highlight = {
          groups = {
            InclineNormal = {
              guifg = RUtils.colortbl.norm_bg,
            },
            InclineNormalNC = {
              guifg = RUtils.colortbl.separator_fg_alt,
              guibg = RUtils.colortbl.norm_bg,
            },
          },
        },
        window = { margin = { vertical = 0, horizontal = 0 } },
        hide = {
          cursorline = true,
          focused_win = false,
          only_win = false,
        },
        ignore = {
          buftypes = "special",
          filetypes = { "alpha", "dashboard", "fzf" },
          floating_wins = true,
          unlisted_buffers = true,
          wintypes = "special",
        },

        render = function(props)
          local function file_modified()
            if props.focused then
              if vim.bo[props.buf].modified then
                return {
                  " " .. RUtils.config.icons.misc.boldclose,
                  guifg = Highlight.get("DiagnosticSignError", "fg"),
                  gui = "bold",
                  guibg = RUtils.colortbl.separator_fg,
                }
              end
            else
              if vim.bo[props.buf].modified then
                return {
                  " " .. RUtils.config.icons.misc.boldclose,
                  guifg = Highlight.get("DiagnosticSignError", "fg"),
                  gui = "bold",
                  guibg = RUtils.colortbl.separator_fg_alt,
                }
              end
            end
          end

          local dirname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":h:t")
          local fnc = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local filename = dirname .. "/" .. fnc

          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          if ft_icon == nil then
            ft_icon = ""
          end

          local modified = vim.api.nvim_get_option_value("modified", { buf = props.buf }) and "bold,italic" or "bold"

          if props.focused then
            return {
              {
                guibg = RUtils.colortbl.separator_fg,
                guifg = RUtils.colortbl.norm_bg,
                RUtils.config.icons.misc.separator_up,
              },
              {
                file_modified(),
              },
              {
                " " .. ft_icon .. " ",
                guifg = ft_color,
                guibg = RUtils.colortbl.separator_fg,
              },
              {
                filename .. " ",
                guibg = RUtils.colortbl.separator_fg,
                gui = modified,
              },
              {
                guifg = RUtils.colortbl.separator_fg,
                RUtils.config.icons.misc.separator_up,
              },
            }
          else
            return {
              {
                guifg = RUtils.colortbl.norm_bg,
                guibg = RUtils.colortbl.separator_fg_alt,
                RUtils.config.icons.misc.separator_up,
              },
              {
                file_modified(),
              },
              {
                " " .. ft_icon .. " ",
                guifg = ft_color,
                guibg = RUtils.colortbl.separator_fg_alt,
              },
              {
                filename .. " ",
                -- guifg = Highlight.tint(Highlight.get("Normal", "fg"), -0.9),
                guifg = RUtils.colortbl.norm_fg,
                guibg = RUtils.colortbl.separator_fg_alt,
                gui = modified,
              },
              {
                guifg = RUtils.colortbl.separator_fg_alt,
                guibg = RUtils.colortbl.norm_bg,
                RUtils.config.icons.misc.separator_up,
              },
            }
          end
        end,
      }
    end,
  },
  -- STATUSCOL
  {
    "luukvbaal/statuscol.nvim",
    event = "BufRead",
    enabled = false,
    opt = function()
      local builtin = require "statuscol.builtin"
      return {
        setopt = true,
        relculright = true,
        segments = {
          {
            sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa", hl = "Comment" },
        },
        -- segments = {
        --   { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        --   { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
        --   {
        --     sign = {
        --       name = { "GitSigns" },
        --       maxwidth = 1,
        --       colwidth = 1,
        --       auto = false,
        --       -- fillcharhl = "StatusColumnSeparator",
        --     },
        --     click = "v:lua.ScSa",
        --   },
        --   { text = { "%s" } },
        -- },
        ft_ignore = {
          "NvimTree",
          "NeogitStatus",
          "NeogitCommitMessage",
          "toggleterm",
          "dapui_scopes",
          "dapui_breakpoints",
          "dapui_stacks",
          "dapui_watches",
          "dapui_console",
          "dap-repl",
          "neotest-summary",
        },
        -- bt_ignore = {
        --   "terminal",
        -- },
      }
    end,
  },
  -- PASTE-IMG (disabled)
  {
    "HakonHarnes/img-clip.nvim",
    enabled = false,
    cmd = "PasteImage",
    opts = true,
    keys = {
      { "<Localleader>P", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
  },
  -- PERSISTED NVIM (disabled)
  {
    "olimorris/persisted.nvim",
    event = "LazyFile",
    enabled = false,
    init = function()
      RUtils.cmd.augroup("PersistedEvents", {
        event = "User",
        pattern = "PersistedSavePre",
        -- Arguments are always persisted in a session and can't be removed using 'sessionoptions'
        -- so remove them when saving a session
        command = function()
          vim.cmd "%argdelete"
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      { "<Leader>sl", function() return vim.cmd.SessionLoadLast() end, { desc = "Misc(persisted): load a session" } },
      { "<Leader>ss", function() vim.cmd.SessionStart() return vim.notify "Sessions persisted: Started.." end, { desc = "Misc(persisted): start a session" } },
    },
    config = function()
      require("persisted").setup {
        autoload = true,
        autosave = true,
        use_git_branch = true,
        ignored_dirs = {
          vim.fn.stdpath "data",
        },
        should_autosave = function()
          for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
            if vim.fn.buflisted(bufnr) == 1 then
              if vim.tbl_contains(ignore_fts_session, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
                vim.api.nvim_buf_delete(bufnr, {})
              end
            end
          end
        end,
      }
    end,
  },
  -- STTUSLINE (disabled)
  {
    "sontungexpt/sttusline",
    enabled = false,
    event = "BufEnter",
    opts = function()
      local component = require "r.plugins.colorthemes.sttusline.components"
      return {
        -- 0 | 1 | 2 | 3
        -- recommended: 3
        laststatus = 3,
        disabled = {
          filetypes = {
            "alpha",
            "dashboard",
            -- "NvimTree",
            -- "lazy",
          },
          buftypes = {
            -- "terminal",
          },
        },
        components = {
          component.mode(),
          component.filename(),
          component.filereadonly(),
          component.branch(),
          component.gitdiff(),
          "%=",
          component.trailing(),
          component.mixindent(),
          "diagnostics",
          component.rootdir(),
          component.lsp_notify(),
          "copilot",
          "encoding",
          "pos-cursor",
          component.linecount(),
          "pos-cursor-progress",
          component.datetime(),
        },
      }
    end,
  },
  -- LUALINE disabled
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local themes = require "r.plugins.colorthemes.lualine.themes"
      local component = require "r.plugins.colorthemes.lualine.components"
      return {
        options = {
          -- theme = "auto",
          theme = themes,

          -- Remove any separators icons
          component_separators = { left = "", right = "" }, -- "", "", "", "", "", ""
          section_separators = { left = "", right = "" },

          disabled_filetypes = {
            statusline = { "alpha", "lazy", "dashboard" },
            winbar = { "help", "alpha", "lazy", "dashboard" },
          },
        },
        sections = {
          lualine_a = { component.mode() },
          lualine_b = {},
          lualine_c = {
            component.filename(),
            component.file_modified(),
            component.branch(),
            component.diff(),
            component.debugger(),
          },
          lualine_x = {
            component.term_akinsho(),
            component.lazy_updates(),
            component.trailing(),
            component.mixindent(),
            component.diagnostics(),
            component.python_env(),
            component.cmp_source(),
            component.get_lsp_client_notify(),
            -- components.noice_status(),
            component.rmux(),
            component.check_loaded_buf(),
            component.overseer(),
            -- components.vmux()
            component.sessions(),
            component.root_dir(),
            component.filetype(),
            component.location_mod(),
            -- components.clock()
          },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "misc" },
      }
    end,
  },
  -- TT.NVIM (disabled)
  {
    "distek/tt.nvim",
    enabled = false,
    keys = {
      {
        "<localleader><localleader>",
        function()
          if vim.bo.filetype == "qf" then
            RUtils.tiling.force_win_close({ "qf" }, false)

            vim.cmd [[wincmd w]]
          end

          return require("tt.terminal"):Toggle()
        end,
        mode = { "n", "t", "v" },
        desc = "Terminal(tt.nvim): toggle",
      },
      {
        "<c-Delete>",
        function()
          if vim.bo.filetype == "qf" then
            RUtils.tiling.force_win_close({ "qf" }, false)

            vim.cmd [[wincmd w]]
          end

          if vim.bo.filetype == "fzf" then
            return
          end

          return require("tt.termlist"):DeleteTermUnderCursor()
        end,
        mode = { "t", "n" },
        desc = "Terminal(tt.nvim): delete",
      },
      {
        "<c-Insert>",
        function()
          if vim.bo.filetype == "qf" then
            RUtils.tiling.force_win_close({ "qf" }, false)

            vim.cmd [[wincmd w]]
          end

          if vim.bo.filetype == "fzf" then
            return
          end

          return require("tt.terminal"):NewTerminal()
        end,
        mode = { "t" },
        desc = "Terminal(tt.nvim): create new terminal",
      },
      {
        "<C-PageDown>",
        function()
          if vim.bo.filetype == "qf" then
            RUtils.tiling.force_win_close({ "qf" }, false)

            vim.cmd [[wincmd w]]
          end

          if vim.bo.filetype == "fzf" then
            return
          end

          return require("tt.terminal"):FocusNext()
        end,
        mode = { "t" },
        desc = "Terminal(tt.nvim): next",
      },

      {
        "<C-PageUp>",
        function()
          if vim.bo.filetype == "qf" then
            RUtils.tiling.force_win_close({ "qf" }, false)

            vim.cmd [[wincmd w]]
          end

          if vim.bo.filetype == "fzf" then
            return
          end

          return require("tt.terminal"):FocusPrevious()
        end,
        mode = { "t" },
        desc = "Terminal(tt.nvim): prev",
      },
    },
    opts = function()
      return {
        termlist = {
          winhighlight = "Normal:ColorColumn,WinBar:WinBar", -- See :h winhighlight - You can change winbar colors as well
          enabled = true,
          side = "right",
          width = 25,
        },
        terminal = {
          winhighlight = "Normal:PanelDarkBackground,WinBar:PanelDarkBackground", -- See :h winhighlight - You can change winbar colors as well
        },
        height = 15,
        -- fixed_height = true,
      }
    end,
  },
  -- BUFTERM (disabled)
  {
    "boltlessengineer/bufterm.nvim",
    cmd = { "BufTermEnter", "BufTermPrev", "BufTermNext" },
    enabled = false,
    keys = {
      {
        "<Leader>rr",
        function()
          -- this will add Terminal to the list (not starting job yet)
          local Terminal = require("bufterm.terminal").Terminal
          local ui = require "bufterm.ui"

          local lfrun = Terminal:new {
            cmd = "lfrun",
            buflisted = false,
            termlisted = false,
          }

          lfrun:spawn()
          return ui.toggle_float(lfrun.bufnr)
        end,
        desc = "Terminal(bufterm): open lfrun",
      },
    },
    dependencies = {
      { "akinsho/nvim-bufferline.lua" },
    },
    config = function()
      require("bufterm").setup {
        save_native_terms = true, -- integrate native terminals from `:terminal` command
        start_in_insert = true, -- start terminal in insert mode
        remember_mode = true, -- remember vi_mode of terminal buffer
        enable_ctrl_w = true, -- use <C-w> for window navigating in terminal mode (like vim8)
        terminal = { -- default terminal settings
          buflisted = false, -- whether to set 'buflisted' option
          fallback_on_exit = true, -- prevent auto-closing window on terminal exit
        },
      }
    end,
  },
  -- EDGY.NVIM (disabled)
  {
    "folke/edgy.nvim",
    enabled = false,
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>uu", function() require("edgy").toggle() end, desc = "Misc(edgy): toggle explore", },
      { "<leader>us", function() require("edgy").select() end, desc = "Misc(edgy): select window" },
      { "<leader>ug", "<CMD> Neotree git_status toggle <CR>",  desc = "Misc(edgy): toggle git_status" },
      { "<leader>ub", "<CMD> Neotree buffers toggle <CR>",     desc = "Misc(edgy): toggle buffers" },
    },
    opts = function()
      local opts = {
        bottom = {
          {
            ft = "toggleterm",
            size = { height = 0.4 },
            ---@diagnostic disable-next-line: unused-local
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "noice",
            size = { height = 0.4 },
            ---@diagnostic disable-next-line: unused-local
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "lazyterm",
            title = "LazyTerm",
            size = { height = 0.4 },
            filter = function(buf)
              return not vim.b[buf].lazyterm_cmd
            end,
          },
          -- "Trouble",
          { ft = "qf", title = "QuickFix" },
          {
            ft = "help",
            size = { height = 20 },
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
          { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
        },
        left = {
          {
            title = "Neo-Tree",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "filesystem"
            end,
            pinned = true,
            open = function()
              vim.api.nvim_input "<esc><space>e"
            end,
            size = { height = 0.5 },
          },
          { title = "Neotest Summary", ft = "neotest-summary" },
          {
            title = "Neo-Tree Git",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "git_status"
            end,
            pinned = true,
            open = "Neotree position=right git_status",
          },
          -- {
          --   title = "Neo-Tree Buffers",
          --   ft = "neo-tree",
          --   filter = function(buf)
          --     return vim.b[buf].neo_tree_source == "buffers"
          --   end,
          --   pinned = true,
          --   open = "Neotree position=top buffers",
          -- },
          "neo-tree",
        },
        keys = {
          -- increase width
          ["<a-L>"] = function(win)
            win:resize("width", 2)
          end,
          -- decrease width
          ["<a-H>"] = function(win)
            win:resize("width", -2)
          end,
          -- increase height
          ["<a-K>"] = function(win)
            win:resize("height", 2)
          end,
          -- decrease height
          ["<a-J>"] = function(win)
            win:resize("height", -2)
          end,
        },
      }
      return opts
    end,
  },
  -- SPECTRE (disabled)
  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre" },
    enabled = false,
    keys = {
      {
        "<Leader><s-f>",
        "<CMD>Spectre<CR>",
        desc = "Misc: open spectre [spectre]",
      },
      {
        "<Leader><s-f>",
        function()
          RUtils.tiling.force_win_close({ "toggleterm", "termlist" }, true)
          return require("spectre").open_visual { select_word = true }
        end,
        desc = "Misc: open spectre with grep on cursor (visual) [spectre]",
        mode = {
          "v",
        },
      },
    },
    opts = function()
      Highlight.plugin("Spectre", {
        {
          TargetKeyword = {
            fg = "DarkYellow",
            bold = true,
            italic = true,
          },
        },
        {
          TargetFileDirectory = {
            bg = "DarkCyan",
            fg = "black",
            bold = true,
          },
        },

        {
          TargetFilename = {
            bg = "Cyan",
            fg = "black",
            bold = true,
          },
        },
        {
          TargetReplace = {
            bg = "Cyan",
            fg = "black",
            italic = true,
          },
        },
      })
      return {
        open_cmd = "noswapfile vnew",
        color_devicons = true,
        live_update = false, -- auto execute search again when you write any file in vim
        line_sep_start = "┌-----------------------------------------",
        result_padding = "¦  ",
        line_sep = "└-----------------------------------------",
        highlight = {
          ui = "String",
          filename = "TargetFilename",
          filedirectory = "TargetFileDirectory",
          search = "TargetKeyword",
          replace = "TargetReplace",
        },
        mapping = {
          ["toggle_line"] = {
            map = "dd",
            cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = "toggle current item",
          },
          ["enter_file"] = {
            map = "<cr>",
            cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
            desc = "goto current file",
          },
          ["send_to_qf"] = {
            map = "<c-q>",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all item to quickfix",
          },
          ["replace_cmd"] = {
            map = "<c-c>",
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = "input replace vim command",
          },
          ["show_option_menu"] = {
            map = "<Leader>o",
            cmd = "<cmd>lua require('spectre').show_options()<CR>",
            desc = "show option",
          },
          ["run_current_replace"] = {
            map = "rc",
            cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
            desc = "replace current line",
          },
          ["run_replace"] = {
            map = "R",
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = "replace all",
          },
          ["change_view_mode"] = {
            map = "<Leader>v",
            cmd = "<cmd>lua require('spectre').change_view()<CR>",
            desc = "change result view mode",
          },
          ["change_replace_sed"] = {
            map = "ts",
            cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
            desc = "use sed to replace",
          },
          ["toggle_live_update"] = {
            map = "tu",
            cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
            desc = "update change when vim write file.",
          },
          ["toggle_ignore_case"] = {
            map = "ti",
            cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
            desc = "toggle ignore case",
          },
          ["toggle_ignore_hidden"] = {
            map = "th",
            cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
            desc = "toggle search hidden",
          },
          -- you can put your mapping here it only use normal mode
        },
        find_engine = {
          -- rg is map with finder_cmd
          ["rg"] = {
            cmd = "rg",
            -- default args
            args = {
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
            },
            options = {
              ["ignore-case"] = {
                value = "--ignore-case",
                icon = "[I]",
                desc = "ignore case",
              },
              ["hidden"] = {
                value = "--hidden",
                desc = "hidden file",
                icon = "[H]",
              },
              -- you can put any rg search option you want here it can toggle with
              -- show_option function
            },
          },
          ["ag"] = {
            cmd = "ag",
            args = {
              "--vimgrep",
              "-s",
            },
            options = {
              ["ignore-case"] = {
                value = "-i",
                icon = "[I]",
                desc = "ignore case",
              },
              ["hidden"] = {
                value = "--hidden",
                desc = "hidden file",
                icon = "[H]",
              },
            },
          },
        },
        replace_engine = {
          ["sed"] = {
            cmd = "sed",
            args = nil,
            options = {
              ["ignore-case"] = {
                value = "--ignore-case",
                icon = "[I]",
                desc = "ignore case",
              },
            },
          },
        },
        default = {
          find = {
            --pick one of item in find_engine
            cmd = "rg",
            options = { "ignore-case", "hidden" },
          },
          replace = {
            --pick one of item in replace_engine
            cmd = "sed",
          },
        },
        replace_vim_cmd = "cdo",
        is_open_target_win = true, --open file on opener window
        is_insert_mode = false, -- start open panel on is_insert_mode
      }
    end,
  },
  -- use edgy's selection window
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = {
      defaults = {
        get_selection_window = function()
          require("edgy").goto_main()
          return 0
        end,
      },
    },
  },
  -- prevent neo-tree from opening files in edgy windows
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = function(_, opts)
      opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
        or { "terminal", "Trouble", "qf", "Outline" }
      table.insert(opts.open_files_do_not_replace_types, "edgy")
    end,
  },
  -- Fix bufferline offsets when edgy is loaded
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function()
      local Offset = require "bufferline.offset"
      if not Offset.edgy then
        local get = Offset.get
        Offset.get = function()
          if package.loaded.edgy then
            local layout = require("edgy.config").layout
            local ret = { left = "", left_size = 0, right = "", right_size = 0 }
            for _, pos in ipairs { "left", "right" } do
              local sb = layout[pos]
              if sb and #sb.wins > 0 then
                local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
                ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
                ret[pos .. "_size"] = sb.bounds.width
              end
            end
            ret.total_size = ret.left_size + ret.right_size
            if ret.total_size > 0 then
              return ret
            end
          end
          return get()
        end
        Offset.edgy = true
      end
    end,
  },
  -- NEOSCROLL.NVIM (disabled)
  {
    "karb94/neoscroll.nvim", -- NOTE: alternative: 'declancm/cinnamon.nvim'
    cond = vim.g.neovide == nil,
    event = "VeryLazy",
    enabled = false,
    opts = {
      hide_cursor = true, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      easing_function = nil, -- Default easing function
      performance_mode = false, -- Disable "Performance Mode" on all buffers.
      mappings = { "<C-d>", "<C-u>", "zt", "zz", "zb" },
      pre_hook = function()
        vim.opt.eventignore:append {
          "WinScrolled",
          "CursorMoved",
        }
      end,
      post_hook = function()
        vim.opt.eventignore:remove {
          "WinScrolled",
          "CursorMoved",
        }
      end,
    },
  },
  -- SMOOTHCURSOR.NVIM
  {
    "gen740/SmoothCursor.nvim",
    event = "BufWinEnter",
    cond = vim.g.neovide == nil,
    enabled = false,
    opts = function()
      return {
        type = "default", -- Cursor movement calculation method, choose "default", "exp" (exponential) or "matrix".

        cursor = "", -- Cursor shape (requires Nerd Font). Disabled in fancy mode.
        texthl = "SmoothCursor", -- Highlight group. Default is { bg = nil, fg = "#FFD400" }. Disabled in fancy mode.
        linehl = nil, -- Highlights the line under the cursor, similar to 'cursorline'. "CursorLine" is recommended. Disabled in fancy mode.

        fancy = {
          enable = true, -- enable fancy mode
          head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil }, -- false to disable fancy head
          body = {
            { cursor = "󰝥", texthl = "SmoothCursorRed" },
            { cursor = "󰝥", texthl = "SmoothCursorOrange" },
            { cursor = "●", texthl = "SmoothCursorYellow" },
            { cursor = "●", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = ".", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
          },
          tail = { cursor = nil, texthl = "SmoothCursor" }, -- false to disable fancy tail
        },

        matrix = { -- Loaded when 'type' is set to "matrix"
          head = {
            -- Picks a random character from this list for the cursor text
            cursor = require "smoothcursor.matrix_chars",
            -- Picks a random highlight from this list for the cursor text
            texthl = {
              "SmoothCursor",
            },
            linehl = nil, -- No line highlight for the head
          },
          body = {
            length = 6, -- Specifies the length of the cursor body
            -- Picks a random character from this list for the cursor body text
            cursor = require "smoothcursor.matrix_chars",
            -- Picks a random highlight from this list for each segment of the cursor body
            texthl = {
              "SmoothCursorGreen",
            },
          },
          tail = {
            -- Picks a random character from this list for the cursor tail (if any)
            cursor = nil,
            -- Picks a random highlight from this list for the cursor tail
            texthl = {
              "SmoothCursor",
            },
          },
          unstop = false, -- Determines if the cursor should stop or not (false means it will stop)
        },

        autostart = true, -- Automatically start SmoothCursor
        always_redraw = true, -- Redraw the screen on each update
        flyin_effect = nil, -- Choose "bottom" or "top" for flying effect
        speed = 25, -- Max speed is 100 to stick with your current position
        intervals = 35, -- Update intervals in milliseconds
        priority = 1, -- Set marker priority
        timeout = 3000, -- Timeout for animations in milliseconds
        threshold = 3, -- Animate only if cursor moves more than this many lines
        disable_float_win = false, -- Disable in floating windows
        enabled_filetypes = nil, -- Enable only for specific file types, e.g., { "lua", "vim" }
        disabled_filetypes = { "fzf", "dashboard", "alpha", "rgflow", "orgagenda" },
      }
    end,
  },
  -- NVIM-IDE (disabled)
  {
    "ldelossa/nvim-ide",
    enabled = false,
    event = "LazyFile",
    config = function()
      local timeline = require "ide.components.timeline"
      local changes = require "ide.components.changes"
      local commits = require "ide.components.commits"
      local branches = require "ide.components.branches"

      require("ide").setup {
        -- log_level = "debug",
        components = {
          -- global_keymaps = {
          --   hide = "h",
          --   details = "P",
          --   details_tab = "p",
          -- },
          TerminalBrowser = {
            hidden = true,
          },
          Commits = {
            keymaps = {
              checkout = "c",
              close = "X",
              collapse = "zc",
              collapse_all = "zM",
              details = "P",
              details_tab = "p",
              diff = "<CR>",
              diff_split = "s",
              diff_tab = "t",
              diff_vsplit = "v",
              expand = "zo",
              help = "?",
              hide = "<C-[>",
              refresh = "r",
            },
          },
        },
        panel_groups = {
          -- explorer = { explorer.Name, outline.Name, bookmarks.Name, callhierarchy.Name, terminalbrowser.Name },
          -- terminal = { terminal.Name },
          git = { changes.Name, commits.Name, timeline.Name, branches.Name },
        },
        workspaces = {
          auto_open = "none",
        },
        panel_sizes = {
          left = 30,
          right = 80,
          bottom = 15,
        },
      }
    end,
  },
  -- NETRW (disabled)
  { "prichrd/netrw.nvim", enabled = false, opts = true },
  -- HYPERSONIC.NVIM (make regex readable) (disabled)
  {
    "tomiis4/Hypersonic.nvim",
    cmd = { "Hypersonic" },
    enabled = false,
    config = true,
  },
  -- OUTPUT-PANEL (disabled)
  {
    "mhanberg/output-panel.nvim",
    event = "VeryLazy",
    enabled = false,
    keys = { { "<Localleader>oo", "<cmd>OutputPanel<CR>", desc = "Misc(outputpanel): open" } },
    config = true,
  },
  -- VIM-TABLE-MODE (disabled)
  {
    "dhruvasagar/vim-table-mode",
    enabled = false,
    ft = {
      "markdown",
      "org",
      "norg",
    },
  },
  -- EPO.NVIM (disabled)
  {
    "nvimdev/epo.nvim",
    -- event = "InsertEnter",
    enabled = false,
    lazy = false,
    -- signatur--[[ e ]]
    init = function()
      vim.opt.completeopt = "menu,menuone,noselect"
    end,
    opts = {
      -- fuzzy match
      fuzzy = false,
      -- increase this value can aviod trigger complete when delete character.
      debounce = 50,
      -- when completion confrim auto show a signature help floating window.
      signature = true,
      -- vscode style json snippet path
      snippet_path = RUtils.config.path.snippet_path .. "/snippets",
      -- border for lsp signature popup, :h nvim_open_win
      signature_border = "rounded",
      -- lsp kind formatting, k is kind string "Field", "Struct", "Keyword" etc.
      -- kind_format = function(k)
      --   return k:lower():sub(1, 1)
      -- end
    },
  },
  -- ULTIMATE-AUTOPAIR (disabled)
  {
    "altermo/ultimate-autopair.nvim",
    enabled = false,
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = true,
  },
  -- LUAPAD (disabled)
  {
    "rafcamlet/nvim-luapad",
    enabled = false,
    cmd = { "Luapad" },
    config = true,
  },
  -- TREESJ (disabled)
  {
    "Wansmer/treesj",
    enabled = false,
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "<leader>rj", "<cmd>TSJToggle<cr>", desc = "Misc(treesj): toggle split/join" },
    },
    config = function()
      require("treesj").setup {
        use_default_keymaps = false,
      }
    end,
  },
  -- COPILOT (disabled)
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    enabled = false,
    config = function()
      require("copilot").setup {}
    end,
  },
  -- FUGITIVE (disabled)
  {
    "tpope/vim-fugitive",
    enabled = false,
    cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
  -- AUTOSESSION.NVIM (disabled)
  {
    "pysan3/autosession.nvim",
    enabled = false,
    cmd = {
      "AutoSession",
      "AutoSessionRestore",
      "AutoSessionSave",
      "AutoSessionAuto",
      "AutoSessionGlobal",
      "AutoSessionDelete",
    },
    event = "VeryLazy",
    opts = {
      restore_on_setup = true,
      warn_on_setup = false,
      autosave_on_quit = true,
    },
  },
  -- GIT ADVANCED SEARCH (disabled)
  {
    "aaronhallaert/advanced-git-search.nvim",
    enabled = false,
    event = "LazyFile",
    dependencies = {
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    init = function()
      vim.api.nvim_create_user_command(
        "DiffCommitLine",
        "lua require('advanced_git_search.fzf').diff_commit_line()",
        { range = true }
      )
    end,
    --stylua: ignore
    keys = {
      { "<Leader>gG", "<CMD>AdvancedGitSearch search_log_content<CR>",      desc = "Git(git-advanced): grep all repo" },
      { "<Leader>gg", "<CMD>AdvancedGitSearch search_log_content_file<CR>", desc = "Git(git-advanced): grep buf repo" },
      { "<Leader>gg", ":'<,'>AdvancedGitSearch diff_commit_line<CR>", mode = "v", desc = "Git(git-advanced): grep buf repo (visual)" },
    },
    opts = {
      diff_plugin = "diffview",
      git_flags = {},
      git_diff_flags = {},
      show_builtin_git_pickers = false,
    },
  },
  -- NVIM-POSSESSION (disabled)
  {
    "gennaro-tedesco/nvim-possession",
    enabled = false,
    event = "BufEnter",
    priority = 100,
    dependencies = {
      "ibhagwan/fzf-lua",
      "nvim-neorg/neorg",
    },
    -- stylua: ignore
    keys = {
      { "<Leader>sl", function() local possession = require "nvim-possession" return possession.list() end, desc = "Misc(possession): load a session" },
      { "<Leader>ss", function() local possession = require "nvim-possession" return possession.new() end, desc = "Misc(possession): start or save a session name" },
      { "<Leader>su", function() local possession = require "nvim-possession" return possession.update() end, desc = "Misc(possession): save a new session or overwrite it" },
    },
    opts = {
      autoload = true, -- whether to autoload sessions in the cwd at startup
      autosave = true, -- whether to autosave loaded sessions before quitting
      autoswitch = {
        enable = false, -- default false
      },
      save_hook = function()
        for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
          if vim.fn.buflisted(bufnr) == 1 then
            if vim.tbl_contains(ignore_fts_session, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
              vim.api.nvim_buf_delete(bufnr, {})
            end
          end
        end
      end,
    },
    config = function(_, opts)
      require("nvim-possession").setup(opts)
    end,
  },
  -- PERSISTENCE (disabled)
  {
    "folke/persistence.nvim",
    enabled = false,
    event = "BufReadPre",
    opts = {

      -- local ignore_fts_session = { "gitcommit", "gitrebase", "alpha", "norg", "org", "orgmode", "conf", "markdown" }
      opts = { options = vim.opt.sessionoptions:get() },
      pre_save = function()
        for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
          if vim.fn.buflisted(bufnr) == 1 then
            if vim.tbl_contains(ignore_fts_session, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
              vim.api.nvim_buf_delete(bufnr, {})
            end
          end
        end
      end,
    },
    -- stylua: ignore
    -- keys = {
    --   { "<Leader>ll", function() require("persistence").load() end, desc = "Misc: restore session [persistence]" },
    --   { "<Leader>lL", function() require("persistence").load { last = true } end, desc = "Misc: restore last session [persistence]" },
    --   { "<Leader>ls", function() require("persistence").stop() end, desc = "Misc: don't save current session [persistence]" },
    -- },
  },
  -- NEOVIM-SESSION-MANAGER (disabled)
  {
    "Shatur/neovim-session-manager",
    enabled = false,
    event = "BufEnter",
    cmd = "SessionManager",
    -- stylua: ignore
    keys = {
      { "<Leader>pl", "<cmd>SessionManager! load_last_session<cr>",
                                                                         { desc =
        "Misc(nvim-session-manager): load a session" }, },
      { "<Leader>ps", "<cmd>SessionManager! save_current_session<cr>",
                                                                         { desc =
        "Misc(nvim-session-manager): save session" }, },
      { "<Leader>pL", "<cmd>SessionManager! load_session<cr>",         { desc =
      "Misc(nvim-session-manager): list session" }, },
    },
    opts = {
      -- autoload_mode = require("session_manager.config").AutoloadMode.Disabled, -- Do not autoload on startup.
      autoload_mode = true, -- Do not autoload on startup.
      autosave_last_session = true, -- Don't auto save session on exit vim.
      autosave_only_in_session = true, -- Allow overriding sessions.
      autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
      autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
        "gitcommit",
        "gitrebase",
        "norg",
        "org",
      },
    },
    config = function(_, opts)
      local session_manager = require "session_manager"
      session_manager.setup(opts)

      -- Auto save session only on write buffer.
      -- This avoid inconsistencies when closing multiple instances of the same session.
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd
      autocmd({ "BufWritePost" }, {
        group = augroup("session_manager_autosave_on_write", { clear = true }),
        callback = function()
          if vim.bo.filetype ~= "git" and not vim.bo.filetype ~= "gitcommit" and not vim.bo.filetype ~= "gitrebase" then
            session_manager.save_current_session()
          end
        end,
      })
    end,
  },
  -- NVIM-GTD (disabled)
  {
    "hrsh7th/nvim-gtd",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      sources = {
        { name = "findup" },
        {
          name = "walk",
          root_markers = {
            ".git",
            ".neoconf.json",
            "Makefile",
            "package.json",
            "tsconfig.json",
          },
          ignore_patterns = { "/node_modules", "/.git" },
        },
        { name = "lsp" },
      },
    },
  },
  -- NVIM-HLSLENS
  {
    "kevinhwang91/nvim-hlslens",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], mode = "n" },
      { "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], mode = "n" },

      -- Fix * and # behavior to respect smartcase
      {
        "*",
        [[:let @/='\v<'.expand('<cword>').'>'<CR>:let v:searchforward=1<CR>:lua require('hlslens').start()<CR>nzv]],
        mode = "n",
      },
      {
        "#",
        [[:let @/='\v<'.expand('<cword>').'>'<CR>:let v:searchforward=0<CR>:lua require('hlslens').start()<CR>nzv]],
        mode = "n",
      },
      {
        "g*",
        [[:let @/='\v'.expand('<cword>')<CR>:let v:searchforward=1<CR>:lua require('hlslens').start()<CR>nzv]],
        mode = "n",
      },
      {
        "g#",
        [[:let @/='\v'.expand('<cword>')<CR>:let v:searchforward=0<CR>:lua require('hlslens').start()<CR>nzv]],
        mode = "n",
      },
    },

    opts = function()
      vim.keymap.set({ "n", "v", "o", "i", "c" }, "<Plug>(StopHL)", 'execute("nohlsearch")[-1]', { expr = true })

      local function stop_hl()
        if vim.v.hlsearch == 0 or vim.api.nvim_get_mode().mode ~= "n" then
          return
        end
        RUtils.cmd.feedkey("<Plug>(StopHL)", "n")
      end

      local function hl_search()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local curr_line = vim.api.nvim_get_current_line()
        local ok, match = pcall(vim.fn.matchstrpos, curr_line, vim.fn.getreg "/", 0)
        if pcall(require, "hlslens") then
          require("hlslens").start()
        end

        if not ok then
          return
        end
        local _, p_start, p_end = unpack(match)
        -- if the cursor is in a search result, leave highlighting on
        if col < p_start or col > p_end then
          stop_hl()
        end
      end

      RUtils.cmd.augroup("VimrcIncSearchHighlight", {
        event = { "CursorMoved" },
        command = function()
          hl_search()
        end,
      }, {
        event = { "InsertEnter" },
        command = function()
          stop_hl()
        end,
      }, {
        event = { "OptionSet" },
        pattern = { "hlsearch" },
        command = function()
          vim.schedule(function()
            vim.cmd.redrawstatus()
          end)
        end,
      }, {
        event = "RecordingEnter",
        command = function()
          vim.o.hlsearch = false
        end,
      }, {
        event = "RecordingLeave",
        command = function()
          vim.o.hlsearch = true
        end,
      })
      return {}
    end,
    config = true,
  },
  -- FIDGET (disabled)
  {
    "j-hui/fidget.nvim",
    enabled = false,
    event = "LazyFile",
    opts = true,
  },
  -- DROPBAR (disabled)
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    enabled = false,
    keys = {
      {
        "<Localleader>od",
        function()
          return require("dropbar.api").pick()
        end,
        desc = "Misc(dropbar): pick",
      },
    },
    init = function()
      Highlight.plugin("DropBar", {
        { DropBarMenuNormalFloat = { inherit = "ColorColumn" } },
        { DropBarIconKindArray = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindBoolean = { bg = { from = "ColorColumn" }, fg = { from = "@booleanj" } } },
        { DropBarIconKindBreakStatement = { bg = { from = "ColorColumn" }, fg = { from = "@error" } } },
        { DropBarIconKindCall = { bg = { from = "ColorColumn" }, fg = { from = "Function" } } },
        { DropBarIconKindCaseStatement = { bg = { from = "ColorColumn" }, fg = { from = "@conditional" } } },
        { DropBarIconKindClass = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindConstant = { bg = { from = "ColorColumn" }, fg = { from = "Constant" } } },
        { DropBarIconKindConstructor = { bg = { from = "ColorColumn" }, fg = { from = "Special" } } },
        { DropBarIconKindContinueStatement = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconKindDeclaration = { bg = { from = "ColorColumn" }, fg = { from = "CmpItemKindSnippet" } } },
        { DropBarIconKindDelete = { bg = { from = "ColorColumn" }, fg = { from = "@error" } } },
        { DropBarIconKindDoStatement = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconKindElseStatement = { bg = { from = "ColorColumn" }, fg = { from = "@conditional" } } },
        { DropBarIconKindEnum = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindEnumMember = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindEvent = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindField = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindFile = { bg = { from = "ColorColumn" }, fg = { from = "Directory" } } },
        { DropBarIconKindFolder = { bg = { from = "ColorColumn" }, fg = { from = "Directory" } } },
        { DropBarIconKindForStatement = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconKindFunction = { bg = { from = "ColorColumn" }, fg = { from = "Function" } } },
        { DropBarIconKindH1Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH1" } } },
        { DropBarIconKindH2Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH2" } } },
        { DropBarIconKindH3Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH3" } } },
        { DropBarIconKindH4Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH4" } } },
        { DropBarIconKindH5Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH5" } } },
        { DropBarIconKindH6Marker = { bg = { from = "ColorColumn" }, fg = { from = "markdownH6" } } },
        { DropBarIconKindIdentifier = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindIfStatement = { bg = { from = "ColorColumn" }, fg = { from = "Conditional" } } },
        { DropBarIconKindInterface = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindKeyword = { bg = { from = "ColorColumn" }, fg = { from = "Keyword" } } },
        { DropBarIconKindList = { bg = { from = "ColorColumn" }, fg = { from = "SpecialChar" } } },
        { DropBarIconKindMacro = { bg = { from = "ColorColumn" }, fg = { from = "Macro" } } },
        { DropBarIconKindMarkdownH1 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH1" } } },
        { DropBarIconKindMarkdownH2 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH2" } } },
        { DropBarIconKindMarkdownH3 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH3" } } },
        { DropBarIconKindMarkdownH4 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH4" } } },
        { DropBarIconKindMarkdownH5 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH5" } } },
        { DropBarIconKindMarkdownH6 = { bg = { from = "ColorColumn" }, fg = { from = "markdownH6" } } },
        { DropBarIconKindMethod = { bg = { from = "ColorColumn" }, fg = { from = "Function" } } },
        { DropBarIconKindModule = { bg = { from = "ColorColumn" }, fg = { from = "LspKindModule" } } },
        { DropBarIconKindNamespace = { bg = { from = "ColorColumn" }, fg = { from = "Include" } } },
        { DropBarIconKindNull = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindNumber = { bg = { from = "ColorColumn" }, fg = { from = "LspKindNumber" } } },
        { DropBarIconKindObject = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindOperator = { bg = { from = "ColorColumn" }, fg = { from = "Identifiern" } } },
        { DropBarIconKindPackage = { bg = { from = "ColorColumn" }, fg = { from = "LspKindModule" } } },
        { DropBarIconKindPair = { bg = { from = "ColorColumn" }, fg = { from = "LspKindString" } } },
        { DropBarIconKindProperty = { bg = { from = "ColorColumn" }, fg = { from = "LspKindProperty" } } },
        { DropBarIconKindReference = { bg = { from = "ColorColumn" }, fg = { from = "LspKindReference" } } },
        { DropBarIconKindRepeat = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconKindScope = { bg = { from = "ColorColumn" }, fg = { from = "LspKindNameSpace" } } },
        { DropBarIconKindSpecifier = { bg = { from = "ColorColumn" }, fg = { from = "Specifier" } } },
        { DropBarIconKindStatement = { bg = { from = "ColorColumn" }, fg = { from = "Statement" } } },
        { DropBarIconKindString = { bg = { from = "ColorColumn" }, fg = { from = "Identifier" } } },
        { DropBarIconKindStruct = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindSwitchStatement = { bg = { from = "ColorColumn" }, fg = { from = "Conditional" } } },
        { DropBarIconKindTerminal = { bg = { from = "ColorColumn" }, fg = { from = "LspKindNumber" } } },
        { DropBarIconKindType = { bg = { from = "ColorColumn" }, fg = { from = "Type" } } },
        { DropBarIconKindTypeParameter = { bg = { from = "ColorColumn" }, fg = { from = "LspKindTypeParameter" } } },
        { DropBarIconKindUnit = { bg = { from = "ColorColumn" }, fg = { from = "LspKindUnit" } } },
        { DropBarIconKindValue = { bg = { from = "ColorColumn" }, fg = { from = "LspKindNumber" } } },
        { DropBarIconKindVariable = { bg = { from = "ColorColumn" }, fg = { from = "LspKindVariable" } } },
        { DropBarIconKindWhileStatement = { bg = { from = "ColorColumn" }, fg = { from = "Repeat" } } },
        { DropBarIconUIIndicator = { bg = { from = "ColorColumn" }, fg = { from = "SpecialChar" } } },
        { DropBarIconUIPickPivot = { bg = { from = "ColorColumn" }, fg = { from = "Error" } } },
        { DropBarIconUISeparator = { bg = { from = "ColorColumn" }, fg = { from = "SpecialChar" } } },
        { DropBarIconUISeparatorMenu = { bg = { from = "ColorColumn" }, fg = { from = "DropBarIconUISeparator" } } },
      })
    end,
    config = function()
      require("dropbar").setup {
        general = {
          update_interval = 100,
          enable = function(buf, win)
            local b, w = vim.bo[buf], vim.wo[win]
            local decor = RUtils.uisec.decorations.decoration_get { ft = b.ft, bt = b.bt, setting = "winbar" }
            return decor ~= nil
              and decor.ft ~= false
              and decor.bt ~= false
              and b.bt == ""
              and not w.diff
              and not vim.api.nvim_win_get_config(win).zindex
              and vim.api.nvim_buf_get_name(buf) ~= ""
          end,
        },
        icons = {
          kinds = {
            use_devicons = false,
            symbols = RUtils.config.icons.kinds,
          },
          ui = {
            bar = {
              separator = set_icons(RUtils.config.icons.misc.arrow_right),
              extends = "…",
            },
            menu = {
              separator = " ",
              indicator = " ",
            },
          },
        },
        bar = {
          sources = function(_, _)
            local sources = require "dropbar.sources"
            return {
              sources.lsp,
            }
          end,
          padding = {
            left = 1,
            right = 1,
          },
          pick = {
            pivots = "abcdefghijklmnopqrstuvwxyz",
          },
          truncate = true,
        },
        menu = {
          -- When on, preview the symbol under the cursor on CursorMoved
          preview = true,
          -- When on, automatically set the cursor to the closest previous/next
          -- clickable component in the direction of cursor movement on CursorMoved
          quick_navigation = true,
          win_configs = {
            border = "shadow",
            col = function(menu)
              return menu.prev_menu and menu.prev_menu._win_configs.width + 1 or 0
            end,
          },
          entry = {
            padding = {
              left = 1,
              right = 1,
            },
          },
          ---@type table<string, string|function|table<string, string|function>>
          keymaps = {
            ["<LeftMouse>"] = function()
              local dropbar_api = require "dropbar.api"
              local menu = dropbar_api.get_current_dropbar_menu()
              if not menu then
                return
              end
              local mouse = vim.fn.getmousepos()
              if mouse ~= nil and mouse.winid ~= menu.win then
                local parent_menu = dropbar_api.get_dropbar_menu(mouse.winid)
                if parent_menu and parent_menu.sub_menu then
                  parent_menu.sub_menu:close()
                end
                if dropbar_api.nvim_win_is_valid(mouse.winid) then
                  dropbar_api.nvim_set_current_win(mouse.winid)
                end
                return
              end
              if mouse ~= nil then
                menu:click_at({ mouse.line, mouse.column }, nil, 1, "l")
              end
            end,
            ["<CR>"] = function()
              local menu = require("dropbar.api").get_current_dropbar_menu()
              if not menu then
                return
              end
              local cursor = vim.api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component then
                menu:click_on(component, nil, 1, "l")
              end
            end,
            ["<c-c>"] = function()
              local dropbar_api = require "dropbar.api"
              local menu = dropbar_api.get_current_dropbar_menu()
              if not menu then
                return
              end
              vim.cmd "q"
            end,
            ["<esc>"] = function()
              local dropbar_api = require "dropbar.api"
              local menu = dropbar_api.get_current_dropbar_menu()
              if not menu then
                return
              end
              vim.cmd "q"
            end,
            ["l"] = function()
              local menu = require("dropbar.api").get_current_dropbar_menu()
              if not menu then
                return
              end
              local cursor = vim.api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component then
                vim.cmd "silent noautocmd update"
                menu:click_on(component, nil, 1, "l")
              end
            end,
            ["h"] = function()
              local menu = require("dropbar.api").get_current_dropbar_menu()
              if not menu then
                return
              end
              vim.cmd "q"
            end,
            ["P"] = function()
              local menu = require("dropbar.api").get_current_dropbar_menu()
              if not menu then
                return
              end

              local cursor = vim.api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component ~= nil then
                local row = component.entry.idx
                local col = component.entry.padding.left + 1

                col = col + component:bytewidth() + component.entry.separator:bytewidth()

                print(tostring(row) .. " " .. tostring(col))
                print(vim.inspect(component))
              end
            end,
          },
        },
      }
    end,
  },
  -- HLARGS (disabled)
  {
    "m-demare/hlargs.nvim",
    enabled = false,
    event = "VeryLazy", --  "UIEnter"
    opts = {
      color = "#ef9062",
      use_colorpalette = true,
      colorpalette = {
        { fg = "#ef9062" },
        { fg = "#3AC6BE" },
        { fg = "#35D27F" },
        { fg = "#EB75D6" },
        { fg = "#E5D180" },
        { fg = "#8997F5" },
        { fg = "#D49DA5" },
        { fg = "#7FEC35" },
        { fg = "#F6B223" },
        { fg = "#F67C1B" },
        { fg = "#DE9A4E" },
        { fg = "#BBEA87" },
        { fg = "#EEF06D" },
        { fg = "#8FB272" },
      },
    },
  },
  -- GARBAGE-DAY (disabled)
  {
    "zeioth/garbage-day.nvim",
    event = "VeryLazy",
    enabled = false,
    dependencies = "neovim/nvim-lspconfig",
    opts = true,
  },
  -- LSP-TIMEOUT.NVIM (disabled)
  {
    "hinell/lsp-timeout.nvim",
    enabled = false,
    event = "LazyFile",
    dependencies = { "neovim/nvim-lspconfig" },
  },
  -- LSP_SIGNATURE.NVIM (disabled)
  {
    -- lsp_signature.nvim [auto params help]
    -- https://github.com/ray-x/lsp_signature.nvim
    "ray-x/lsp_signature.nvim",
    enabled = false,
    event = "LazyFile",
    opts = function()
      -- Apply globals from 1-options.lua
      local is_enabled = vim.g.lsp_signature_enabled
      local round_borders = { border = "rounded" }
      return {

        -- Window mode
        floating_window = is_enabled, -- Display it as floating window.
        hi_parameter = "IncSearch", -- Color to highlight floating window.
        handler_opts = round_borders, -- Window style

        -- Hint mode
        hint_enable = false, -- Display it as hint.
        hint_prefix = "👈 ",

        -- Additionally, you can use <space>ui to toggle inlay hints.
      }
    end,
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  -- BARBAR.NVIM
  {
    "romgrk/barbar.nvim",
    dependencies = {
      { "lewis6991/gitsigns.nvim" },
      -- { "rebelot/kanagawa.nvim" },
    },
    event = "LazyFile",
    enabled = false,
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = function()
      -- local signs = preferences.icons.diagnostics
      return {
        animation = true,
        -- auto_hide = true,
        tabpages = true,
        hide = { extensions = true, inactive = false },
        highlight_visible = true,

        icons = {
          buffer_index = false,
          buffer_number = false,
          button = "×",
          ---Enables / disables diagnostic symbols
          -- diagnostics = {
          --   [vim.diagnostic.severity.ERROR] = { enabled = true, icon = signs.Error },
          --   [vim.diagnostic.severity.WARN] = { enabled = true, icon = signs.Warn },
          --   [vim.diagnostic.severity.INFO] = { enabled = true, icon = signs.Info },
          --   [vim.diagnostic.severity.HINT] = { enabled = true, icon = signs.Hint },
          -- },
          --
          gitsigns = {
            added = { enabled = true, icon = "+" },
            changed = { enabled = true, icon = "~" },
            deleted = { enabled = true, icon = "-" },
          },

          modified = { button = "●" },
          pinned = { button = "", filename = true },

          preset = "slanted",

          alternate = { filetype = { enabled = false } },
          current = { buffer_index = false },
          inactive = { button = "󰒲" },
          visible = { modified = { buffer_number = true } },
        },
      }
    end,
  },
  -- NVIM-SCROLLBAR (disabled)
  {
    "petertriho/nvim-scrollbar",
    enabled = false,
    event = "VimEnter",
    opts = {
      show = true,
      set_highlights = true,
      handle = {
        text = " ",
        color = "#3F4A5A",
        cterm = nil,
        highlight = "CursorColumn",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
      },
      marks = {
        Search = {
          text = { "-", "=" },
          priority = 0,
          color = nil,
          cterm = nil,
          highlight = "Search",
        },
        Error = {
          text = { "-", "=" },
          priority = 1,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
          text = { "-", "=" },
          priority = 2,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
          text = { "-", "=" },
          priority = 3,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
          text = { "-", "=" },
          priority = 4,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
          text = { "-", "=" },
          priority = 5,
          color = nil,
          cterm = nil,
          -- highlight = "Normal",
        },
      },
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "lazy",
      },
      autocmd = {
        render = {
          "BufWinEnter",
          "TabEnter",
          "TermEnter",
          "WinEnter",
          "CmdwinLeave",
          -- "TextChanged",
          "VimResized",
          "WinScrolled",
        },
      },
      handlers = {
        diagnostic = true,
        search = true, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
      },
    },
    -- config = function(_, opts)
    --   require("scrollbar").setup(opts)
    -- end,
  },
  -- BLOCK NVIM (disabled)
  {
    "HampusHauffman/block.nvim",
    enabled = false,
    cmd = { "BlockOn", "BlockOff", "Block" },
    opts = true,
  },
  -- SCROLLEOF (disabled)
  {
    "Aasim-A/scrollEOF.nvim",
    enabled = false,
    opts = {
      pattern = "*",
    },
    config = function(_, opts)
      require("scrollEOF").setup(opts)
    end,
  },
  -- VSCODE-MULTI-CURSOR.NVIM
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("vscode-multi-cursor").setup { -- Config is optional
        -- Whether to set default mappings
        default_mappings = true,
        -- If set to true, only multiple cursors will be created without multiple selections
        no_selection = false,
      }
    end,
    -- cond = not not vim.g.vscode,
  },
  -- MINI ANIMATE
  {
    "echasnovski/mini.animate",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs { "Up", "Down" } do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require "mini.animate"
      return {
        resize = {
          timing = animate.gen_timing.linear { duration = 120, unit = "total" },
        },
        scroll = {
          timing = animate.gen_timing.exponential { duration = 50, unit = "total" },
          subscroll = animate.gen_subscroll.equal {
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1 and total_scroll < 50
            end,
          },
        },
        cursor = {
          subscroll = animate.gen_path.spiral(),
        },
        open = {
          winconfig = animate.gen_winconfig.wipe {
            direction = "from_edge",
          },
        },
        close = {
          winconfig = animate.gen_winconfig.wipe {
            direction = "to_edge",
          },
        },
      }
    end,
  },
  -- EDGY-GROUP
  {
    "lucobellic/edgy-group.nvim",
    event = "VeryLazy",
    enabled = false,
    -- dependencies = { "folke/edgy.nvim" },
    keys = {
      {
        "<leader>el",
        function()
          require("edgy-group").open_group("left", 1)
        end,
        desc = "Edgy Group Next Left",
      },
      {
        "<leader>eh",
        function()
          require("edgy-group").open_group("left", -1)
        end,
        desc = "Edgy Group Prev Left",
      },
    },
    opts = {
      { icon = "", pos = "left", titles = { "Neo-Tree", "Neo-Tree Buffers" } },
      { icon = "", pos = "left", titles = { "Neo-Tree Git" } },
      { icon = "", pos = "left", titles = { "Outline" } },
    },
  },
  -- MINI-SURROUND (disabled)
  {
    "echasnovski/mini.surround",
    enabled = false,
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzc", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
  },
  -- MINI.CLUE (disabled)
  {
    "echasnovski/mini.clue",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      local miniclue = require "mini.clue"

      return {
        window = {
          delay = vim.o.timeoutlen,
          -- Keys to scroll inside the clue window
          scroll_down = "<C-d>",
          scroll_up = "<C-u>",
        },
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "n", keys = "<localleader>" },
          { mode = "x", keys = "<localleader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- `d` key (diagnostic)
          { mode = "n", keys = "d" },
          { mode = "x", keys = "d" },

          -- Marks
          { mode = "n", keys = "m" },
          { mode = "x", keys = "m" },

          { mode = "n", keys = "r" },
          { mode = "x", keys = "r" },

          -- Registers
          -- -- { mode = "n", keys = '"' },
          -- -- { mode = "x", keys = '"' },
          -- -- { mode = "i", keys = "<C-r>" },
          -- -- { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `t` key
          { mode = "n", keys = "t" },
          { mode = "x", keys = "t" },

          -- `s` key
          { mode = "n", keys = "s" },
          { mode = "x", keys = "s" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          -- { mode = "n", keys = "<Leader>c", desc = "+AI" },
          -- { mode = "x", keys = "<Leader>c", desc = "+AI" },
          -- { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
          { mode = "n", keys = "<Leader>d", desc = "+Debug" },
          { mode = "x", keys = "<Leader>d", desc = "+Debug" },
          { mode = "n", keys = "<Leader>a", desc = "+Projectionist" },
          -- { mode = "n", keys = "<Leader>D", desc = "+Database" },
          { mode = "n", keys = "<Leader>f", desc = "+FZFlua" },

          { mode = "n", keys = "<Leader>t", desc = "+Testing" },
          { mode = "n", keys = "<Leader>t", desc = "+Testing" },
          -- { mode = "n", keys = "<Leader>u", desc = "+Edgy" },
          --
          -- { mode = "n", keys = "<Leader>j", desc = "+Harpoon" },
          -- { mode = "n", keys = "<Leader>j", desc = "+Harpoon" },
          --
          { mode = "n", keys = "<Leader>g", desc = "+Git" },
          { mode = "x", keys = "<Leader>g", desc = "+Git" },
          -- { mode = "n", keys = "<Leader>gf", desc = "+FZFgit" },
          -- { mode = "n", keys = "<Leader>gv", desc = "+Diffview" },
          -- { mode = "x", keys = "<Leader>gv", desc = "+Diffview" },
          -- { mode = "n", keys = "<Leader>gt", desc = "+Toggle" },
          --
          -- { mode = "n", keys = "<Leader>l", desc = "+Language" },
          -- { mode = "x", keys = "<Leader>l", desc = "+Language" },
          -- { mode = "n", keys = "gc", desc = "+Coi" },

          -- { mode = "n", keys = "t<CR>", desc = "+Coi" },

          -- { mode = "n", keys = "<Leader>lg", desc = "+Annotation" },
          -- { mode = "n", keys = "<Leader>lx", desc = "+Swap Next" },
          -- { mode = "n", keys = "<Leader>lxf", desc = "+Function" },
          -- { mode = "n", keys = "<Leader>lxp", desc = "+Parameter" },
          -- { mode = "n", keys = "<Leader>lxc", desc = "+Class" },
          -- { mode = "n", keys = "<Leader>lX", desc = "+Swap Previous" },
          -- { mode = "n", keys = "<Leader>lXf", desc = "+Function" },
          -- { mode = "n", keys = "<Leader>lXp", desc = "+Parameter" },
          -- { mode = "n", keys = "<Leader>lXc", desc = "+Class" },
          -- { mode = "n", keys = "<Leader>p", desc = "+Project" },
          -- { mode = "n", keys = "<Leader>q", desc = "+Quit/Session" },
          -- { mode = "x", keys = "<Leader>q", desc = "+Quit/Session" },
          --
          -- { mode = "n", keys = "<Leader>r", desc = "+TaskOrRun" },
          -- { mode = "x", keys = "<Leader>r", desc = "+TaskOrRun" },
          --
          -- { mode = "n", keys = "<Leader>s", desc = "+Sessions" },
          -- { mode = "x", keys = "<Leader>s", desc = "+Sessions" },
          --
          -- { mode = "n", keys = "<Leader>t", desc = "+Testing" },
          -- -- { mode = "n", keys = "<Leader>tN", desc = "+Neotest" },
          --
          -- -- { mode = "n", keys = "<Leader>to", desc = "+Overseer" },
          -- -- { mode = "n", keys = "<Leader>v", desc = "+View" },
          -- { mode = "n", keys = "<Leader>z", desc = "+System" },
          -- { mode = "n", keys = "<Leader>y", desc = "+Surround" },
          --
          -- { mode = "n", keys = "<Localleader>o", desc = "+Open" },
          -- { mode = "n", keys = "<Localleader>q", desc = "+QF" },
          -- { mode = "n", keys = "<Localleader>f", desc = "+Note" },

          -- Submodes
          -- { mode = "n", keys = "<Leader>tNF", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNL", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNa", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNf", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNl", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNn", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNN", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNo", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNs", postkeys = "<Leader>tN" },
          -- { mode = "n", keys = "<Leader>tNS", postkeys = "<Leader>tN" },

          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          -- miniclue.gen_clues.windows {
          --   submode_move = false,
          --   submode_navigate = false,
          --   submode_resize = true,
          -- },
          -- miniclue.gen_clues.z(),
        },
      }
    end,
  },
}
