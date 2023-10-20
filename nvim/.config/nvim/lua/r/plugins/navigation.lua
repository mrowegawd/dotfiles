local cmd = vim.cmd

local highlight = require "r.config.highlights"
local Util = require "r.utils"

return {
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    init = function()
      Util.disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })
    end,
    keys = {
      {
        "<Leader>e",
        function()
          Util.tiling.force_win_close({ "OverseerList", "undotree", "aerial" }, false)
          return cmd "Neotree toggle"
        end,
        desc = "Misc(neotree): open File explore",
      },
      {
        "<Leader>E",
        function()
          Util.tiling.force_win_close({ "OverseerList", "undotree", "aerial" }, false)
          return cmd "Neotree reveal toggle"
        end,
        desc = "Misc(neotree): open find file on File Explore",
      },
    },
    dependencies = {
      "mrbjarksen/neo-tree-diagnostics.nvim",
      "nvim-lua/plenary.nvim",
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
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = { ".DS_Store" },
          },
          window = {
            mappings = {
              ["H"] = "toggle_hidden",
              ["<leader>ff"] = "fuzzy_finder",
              ["gf"] = "filter_on_submit",
              ["<C-x>"] = "clear_filter",
              ["gp"] = "prev_git_modified",
              ["gn"] = "next_git_modified",
              ["gd"] = "fuzzy_finder_directory",
              --["/"] = "filter_as_you_type", -- this was the default until v1.28
              -- ["D"] = "fuzzy_sorter_directory",
              -- ["/"] = "noop",
            },
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
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
        git_status = {
          window = {
            mappings = {
              ["ga"] = "git_add_file",
              ["gA"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "noop",
              ["gn"] = "noop",
              ["gg"] = "noop",
              ["i"] = "show_file_details",
              -- ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
              ["o"] = "noop",
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
          },
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
            -- ["<c-s>"] = "split_with_window_picker",
            -- ["<c-v>"] = "vsplit_with_window_picker",
            ["<c-s>"] = "open",
            ["<c-v>"] = "open",
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

      local function on_move(data)
        Util.lsp.on_rename(data.source, data.destination)
      end

      local events = require "neo-tree.events"
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })

      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
  -- EDGY.NVIM
  {
    "folke/edgy.nvim",
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
