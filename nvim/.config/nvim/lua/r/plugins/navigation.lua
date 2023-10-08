local cmd, highlight, fn, icons = vim.cmd, as.highlight, vim.fn, as.ui.icons

return {
  -- OIL.NVIM (disabled)
  {
    "stevearc/oil.nvim", -- File manager
    opts = {
      keymaps = {
        -- ["<C-c>"] = false,
        -- ["<C-s>"] = "actions.save",
        ["q"] = "actions.close",
        ["H"] = "actions.toggle_hidden",
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["<bs>"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
      },
      buf_options = {
        buflisted = false,
      },
      float = {
        border = "none",
      },
      skip_confirm_for_simple_edits = true,
    },
    keys = {
      {
        "<localleader>e",
        function()
          require("oil").toggle_float "."
        end,
        desc = "Misc(oil): open File Explorer",
      },
      {
        "<localleader>E",
        function()
          require("oil").toggle_float()
        end,
        desc = "Misc(oil): open File Explorer to current file",
      },
    },
  },
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VimEnter",
    init = function()
      require("r.utils").disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })
      vim.api.nvim_create_autocmd("BufEnter", {
        desc = "Load NeoTree if entering a directory",
        callback = function(args)
          if fn.isdirectory(vim.api.nvim_buf_get_name(args.buf)) > 0 then
            require("lazy").load { plugins = { "neo-tree.nvim" } }
            vim.api.nvim_del_autocmd(args.id)
          end
        end,
      })
    end,
    keys = {
      {
        "<Leader>E",
        function()
          require("r.utils.tiling").force_win_close({ "OverseerList", "undotree", "aerial" }, false)
          return cmd "Neotree toggle"
        end,
        desc = "Misc(neotree): open File explore",
      },
      {
        "<Leader>e",
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
      {
        "ten3roberts/window-picker.nvim",
        name = "window-picker",
        config = function()
          local picker = require "window-picker"
          picker.setup()
          picker.pick_window = function()
            return picker.select({ hl = "WindowPicker", prompt = "Pick window: " }, function(winid)
              return winid or nil
            end)
          end
        end,
      },
    },
    config = function()
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

      local symbols = require("lspkind").symbol_map
      local lsp_kinds = as.ui.lsp.highlights

      require("neo-tree").setup {
        sources = { "filesystem", "git_status", "document_symbols" },
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
            ["<c-c>"] = "clear_filter",

            ["zM"] = "close_all_nodes",
            ["zO"] = "expand_all_nodes",
            ["gh"] = "prev_source",
            ["gl"] = "next_source",
          },
        },
      }
    end,
  },
  -- NVIM-TREE (disabled)
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    cmd = {
      "NvimTreeToggle",
      "NvimTreeClose",
      "NvimTreeFindFileToggle",
    },
    config = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- set termguicolors to enable highlight groups
      vim.opt.termguicolors = true

      local nvimtree = require "nvim-tree"

      local options = {
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        sort_by = "case_sensitive",
        select_prompts = true,
        view = {
          adaptive_size = true,
          mappings = {
            list = {
              { key = "u", action = "dir_up" },
              {
                key = { "<CR>", "<2-LeftMouse>", "l" },
                action = "edit",
                mode = "n",
              },
              {
                key = { "<2-RightMouse>", "<C-}>" },
                action = "cd",
              },
              { key = "<C-v>", action = "vsplit" },
              { key = "<C-s>", action = "split" },
              { key = "<C-t>", action = "tabnew" },
              -- { key = "<", action = "prev_sibling" },
              -- { key = ">", action = "next_sibling" },
              { key = "P", action = "parent_node" },
              { key = "<BS>", action = "close_node" },
              { key = "<S-CR>", action = "close_node" },
              { key = "<S-l>", action = "close_node" },
              { key = "<Tab>", action = "preview" },
              -- { key = "K", action = "first_sibling" },
              -- { key = "J", action = "last_sibling" },
              { key = "I", action = "toggle_ignored" },
              { key = "H", action = "toggle_dotfiles" },
              { key = "R", action = "refresh" },
              { key = "a", action = "create" },
              { key = "d", action = "remove" },
              { key = "r", action = "rename" },
              { key = "<C-r>", action = "full_rename" },
              { key = "x", action = "cut" },
              { key = "c", action = "copy" },
              { key = "p", action = "paste" },
              { key = "y", action = "copy_name" },
              { key = "Y", action = "copy_path" },
              { key = "gy", action = "copy_absolute_path" },
              { key = "<", action = "dir_up" },
              { key = "q", action = "close" },
              { key = "g?", action = "toggle_help" },
              { key = "gp", action = "prev_git_item" },
              { key = "gn", action = "next_git_item" },
              -- ["<CR>"] = ":YourVimFunction()<cr>",
              -- ["u"] = ":lua require'some_module'.some_function()<cr>",
            },
          },
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
        disable_netrw = false,
        hijack_netrw = true,
        respect_buf_cwd = true,
      }

      nvimtree.setup(options)
    end,
  },
}
