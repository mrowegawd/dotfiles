local cmd, highlight, icons = vim.cmd, as.highlight, as.ui.icons

return {
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    init = function()
      require("r.utils").disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })
      --   vim.api.nvim_create_autocmd("BufEnter", {
      --     desc = "Load NeoTree if entering a directory",
      --     callback = function(args)
      --       if fn.isdirectory(vim.api.nvim_buf_get_name(args.buf)) > 0 then
      --         require("lazy").load { plugins = { "neo-tree.nvim" } }
      --         vim.api.nvim_del_autocmd(args.id)
      --       end
      --     end,
      --   })
    end,
    keys = {
      {
        "<Leader>e",
        function()
          require("r.utils.tiling").force_win_close({ "OverseerList", "undotree", "aerial" }, false)
          return cmd "Neotree toggle"
        end,
        desc = "Misc(neotree): open File explore",
      },
      {
        "<Leader>E",
        function()
          require("r.utils.tiling").force_win_close({ "OverseerList", "undotree", "aerial" }, false)
          return cmd "Neotree reveal toggle"
        end,
        desc = "Misc(neotree): open find file on File Explore",
      },
    },
    dependencies = {
      "mrbjarksen/neo-tree-diagnostics.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
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
    opts = function()
      local symbols = require("lspkind").symbol_map
      local lsp_kinds = as.ui.lsp.highlights
      return {
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        source_selector = {
          -- winbar = true,
          separator_active = "",
          sources = {
            { source = "filesystem" },
            { source = "git_status" },
            { source = "document_symbols" },
          },
        },
        enable_git_status = true,
        git_status_async = true,
        nesting_rules = {
          ["dart"] = { "freezed.dart", "g.dart" },
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              highlight.set("Cursor", { blend = 100 })
            end,
          },
          {
            event = "neo_tree_buffer_leave",
            handler = function()
              highlight.set("Cursor", { blend = 0 })
            end,
          },
          {
            event = "neo_tree_window_after_close",
            handler = function()
              highlight.set("Cursor", { blend = 0 })
            end,
          },
        },
        filesystem = {
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
          group_empty_dirs = false,
          -- follow_current_file = false,
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = { ".DS_Store" },
          },
          window = {
            mappings = {
              ["/"] = "noop",
              ["g/"] = "fuzzy_finder",
              ["gp"] = "prev_git_modified",
              ["gn"] = "next_git_modified",
              ["H"] = "toggle_hidden",
            },
          },
        },
        default_component_configs = {
          icon = {
            folder_empty = icons.documents.open_folder,
          },
          name = {
            highlight_opened_files = true,
          },
          document_symbols = {
            follow_cursor = true,
            kinds = vim.iter(symbols):fold({}, function(acc, k, v)
              acc[k] = { icon = v, hl = lsp_kinds[k] }
              return acc
            end),
          },
          modified = {
            symbol = icons.misc.circle .. " ",
          },
        },

        commands = {
          system_open = function(state)
            -- TODO: just use vim.ui.open when dropping support for Neovim <0.10
            (vim.ui.open or require("astronvim.utils").system_open)(state.tree:get_node():get_id())
          end,
          parent_or_close = function(state)
            local node = state.tree:get_node()
            if (node.type == "directory" or node:has_children()) and node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,

          child_or_open = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" or node:has_children() then
              if not node:is_expanded() then -- if unexpanded, expand
                state.commands.toggle_node(state)
              else -- if expanded and has children, seleect the next child
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            else -- if not a directory just open it
              state.commands.open(state)
            end
          end,
        },
        window = {
          mappings = {
            ["<2-LeftMouse>"] = "open",
            ["l"] = "child_or_open",
            ["h"] = "close_node",
            ["P"] = {
              "toggle_preview",
              config = { use_float = true },
            },
            ["o"] = "open",
            -- ["<CR>"] = "child_or_open",
            ["<c-s>"] = "split_with_window_picker",
            ["<c-v>"] = "vsplit_with_window_picker",
            ["<esc>"] = "revert_preview",
            -- ["<c-c>"] = "clear_filter",

            ["zM"] = "close_all_nodes",
            ["zO"] = "expand_all_nodes",
            ["gh"] = "prev_source",
            ["gl"] = "next_source",
          },
        },
      }
    end,
    config = function(_, opts)
      highlight.plugin("NeoTree", {
        theme = {
          ["*"] = {
            { NeoTreeNormal = { link = "PanelBackground" } },
            { NeoTreeNormalNC = { link = "PanelBackground" } },
            { NeoTreeCursorLine = { link = "CursorLine" } },
            { NeoTreeRootName = { underline = false } },
            { NeoTreeStatusLine = { link = "PanelSt" } },
            { NeoTreeTabActive = { bg = { from = "PanelBackground" }, bold = true } },
  {
              NeoTreeTabInactive = { bg = { from = "PanelDarkBackground", alter = 0.15 }, fg = { from = "Comment" } },
    },
            { NeoTreeTabSeparatorActive = { inherit = "PanelBackground", fg = { from = "Comment" } } },
              {
              NeoTreeTabSeparatorInactive = {
                inherit = "NeoTreeTabInactive",
                fg = { from = "PanelDarkBackground", attr = "bg" },
              },
            },
          },
          -- NOTE: panel background colours don't get ignored by tint.nvim so avoid using them for now
          horizon = {
            { NeoTreeWinSeparator = { link = "WinSeparator" } },
            { NeoTreeTabActive = { link = "VisibleTab" } },
            { NeoTreeTabSeparatorActive = { link = "VisibleTab" } },
            { NeoTreeTabInactive = { inherit = "Comment", italic = false } },
            { NeoTreeTabSeparatorInactive = { bg = "bg", fg = "bg" } },
          },
        },
      })

      vim.g.neo_tree_remove_legacy_commands = 1

      require("neo-tree").setup(opts)
    end,
  },
  -- EDGY.NVIM
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Misc(edgy): toggle",
      },
      -- stylua: ignore
      { "<leader>uE", function() require("edgy").select() end, desc = "Misc(edgy): select window" },
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
          { ft = "spectre_panel", size = { height = 0.4 } },
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
          {
            title = "Neo-Tree Buffers",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "buffers"
            end,
            pinned = true,
            open = "Neotree position=top buffers",
          },
          "neo-tree",
        },
        keys = {
          -- increase width
          ["<c-Right>"] = function(win)
            win:resize("width", 2)
          end,
          -- decrease width
          ["<c-Left>"] = function(win)
            win:resize("width", -2)
          end,
          -- increase height
          ["<c-Up>"] = function(win)
            win:resize("height", 2)
          end,
          -- decrease height
          ["<c-Down>"] = function(win)
            win:resize("height", -2)
          end,
        },
      }
      -- if as.has "symbols-outline.nvim" then
      --   table.insert(opts.left, {
      --     title = "Outline",
      --     ft = "Outline",
      --     pinned = true,
      --     open = "SymbolsOutline",
      --   })
      -- end
      return opts
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
}
