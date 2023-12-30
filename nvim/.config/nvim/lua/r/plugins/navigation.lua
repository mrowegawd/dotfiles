local cmd = vim.cmd

local highlight = require "r.config.highlights"
local Util = require "r.utils"
local Icon = require("r.config").icons

return {
  -- NVIM-TREE
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    cmd = { "NvimTreeToggle", "NvimTreeClose", "NvimTreeFindFileToggle" },
    -- init = function()
    --   Util.disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })
    -- end,
    keys = {
      {
        "<Leader>e",
        function()
          --   if vim.bo[0].filetype == "neo-tree" then
          --     return cmd [[q]]
          --   end
          --   Util.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, false)
          --   if vim.bo[0].filetype == "norg" then
          --     return cmd "Neotree toggle "
          --   end
          return cmd "NvimTreeToggle"
        end,
        desc = "Misc(nvimtree): open toggle",
      },
      -- {
      --   "<Leader>ge",
      --   function()
      --     -- if vim.bo[0].filetype == "neo-tree" then
      --     --   return cmd [[q]]
      --     -- end
      --     return cmd "NvimTreeFindFileToggle"
      --   end,
      --   desc = "Misc(neotree): open File explore",
      -- },
      {
        "<Leader>E",
        function()
          return cmd "NvimTreeFindFileToggle"
        end,
        desc = "Misc(nvimtree): find file toggle",
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

    config = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      -- vim.g.loaded_netrw = 0
      -- vim.g.loaded_netrwPlugin = 0
      -- vim.g.loaded_netrw = 0
      -- vim.g.loaded_netrwPlugin = 0

      vim.g.loaded_netrw = 0
      vim.g.loaded_netrwPlugin = 0

      local function on_attach(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts "CD")
        vim.keymap.set("n", "<space-e>", api.node.open.replace_tree_buffer, opts "Open: In Place")
        vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts "Info")
        vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts "Rename: Omit Filename")
        vim.keymap.set("n", "<C-t>", api.node.open.tab, opts "Open: New Tab")
        vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts "Open: Vertical Split")
        vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts "Open: Horizontal Split")
        vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts "Close Directory")
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts "Open")
        vim.keymap.set("n", "<Tab>", api.node.open.preview, opts "Open Preview")
        vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts "Next Sibling")
        vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts "Previous Sibling")
        vim.keymap.set("n", ".", api.node.run.cmd, opts "Run Command")
        vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts "Up")
        vim.keymap.set("n", "a", api.fs.create, opts "Create")
        vim.keymap.set("n", "bmv", api.marks.bulk.move, opts "Move Bookmarked")
        vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts "Toggle No Buffer")
        vim.keymap.set("n", "c", api.fs.copy.node, opts "Copy")
        vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts "Toggle Git Clean")
        vim.keymap.set("n", "gp", api.node.navigate.git.prev, opts "Prev Git")
        vim.keymap.set("n", "gn", api.node.navigate.git.next, opts "Next Git")
        vim.keymap.set("n", "d", api.fs.remove, opts "Delete")
        vim.keymap.set("n", "D", api.fs.trash, opts "Trash")
        vim.keymap.set("n", "E", api.tree.expand_all, opts "Expand All")
        vim.keymap.set("n", "e", api.fs.rename_basename, opts "Rename: Basename")
        vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts "Next Diagnostic")
        vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts "Prev Diagnostic")
        vim.keymap.set("n", "F", api.live_filter.clear, opts "Clean Filter")
        vim.keymap.set("n", "f", api.live_filter.start, opts "Filter")
        vim.keymap.set("n", "g?", api.tree.toggle_help, opts "Help")
        vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts "Copy Absolute Path")
        vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts "Toggle Git Ignore")
        vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts "Last Sibling")
        -- vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts "First Sibling")
        vim.keymap.set("n", "m", api.marks.toggle, opts "Toggle Bookmark")
        vim.keymap.set("n", "o", api.node.open.edit, opts "Open")
        vim.keymap.set("n", "O", api.node.open.no_window_picker, opts "Open: No Window Picker")
        vim.keymap.set("n", "p", api.fs.paste, opts "Paste")
        vim.keymap.set("n", "P", api.node.navigate.parent, opts "Parent Directory")
        vim.keymap.set("n", "q", api.tree.close, opts "Close")
        vim.keymap.set("n", "r", api.fs.rename, opts "Rename")
        vim.keymap.set("n", "R", api.tree.reload, opts "Refresh")
        vim.keymap.set("n", "s", function()
          vim.cmd [[wincmd p]]
        end, opts "Run System")
        vim.keymap.set("n", "S", api.tree.search_node, opts "Search")
        vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts "Toggle Hidden")
        vim.keymap.set("n", "W", api.tree.collapse_all, opts "Collapse")
        vim.keymap.set("n", "x", api.fs.cut, opts "Cut")
        vim.keymap.set("n", "y", api.fs.copy.filename, opts "Copy Name")
        vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts "Copy Relative Path")
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts "Open")
        vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts "CD")
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
              default = Icon.documents.unknown,
              symlink = Icon.documents.symlink,
              git = {
                unstaged = Icon.git.added,
                staged = Icon.git.added,
                unmerged = Icon.git.unmerged,
                renamed = Icon.git.rename,
                deleted = Icon.git.removed,
                untracked = Icon.git.untrack,
                ignored = "",
              },
              folder = {
                default = Icon.documents.folder,
                open = Icon.documents.openfolder,
                empty = Icon.documents.emptyfolder,
                empty_open = Icon.documents.emptyopenfolder,
                symlink = Icon.documents.foldersymlink,
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
  -- OIL (disabled)
  {
    "stevearc/oil.nvim",
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<Leader>e",
        function()
          -- if vim.bo[0].filetype == "neo-tree" then
          --   return cmd [[q]]
          -- end
          -- Util.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, false)
          -- if vim.bo[0].filetype == "norg" then
          --   return cmd "Neotree toggle "
          -- end
          require("oil").open()
          -- return cmd "Neotree toggle reveal"
        end,
        desc = "Misc(oil): open",
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
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- enabled = false,
    cmd = "Neotree",
    init = function()
      Util.disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })
    end,
    keys = {
      {
        "<Leader>e",
        function()
          local neotree_opened = false
          for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr "$")) do
            if vim.fn.getwinvar(winnr, "&syntax") == "neo-tree" then
              neotree_opened = true
            end
          end

          if neotree_opened then
            if vim.bo[0].filetype == "neo-tree" then
              return vim.cmd [[q]]
            end
            return cmd "Neotree reveal"
          else
            if vim.bo[0].filetype == "neo-tree" then
              return vim.cmd [[q]]
            end
            return cmd "Neotree"
          end
        end,
        desc = "Misc(neotree): open File explore",
      },
      {
        "<Leader>ge",
        function()
          if vim.bo[0].filetype == "neo-tree" then
            return cmd [[q]]
          end
          return cmd "Neotree git_status"
        end,
        desc = "Misc(neotree): open File explore",
      },
      {
        "<Leader>E",
        function()
          Util.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, false)
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
        async_directory_scan = "never", -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
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
          hijack_netrw_behavior = "open_default",
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
              -- ["<leader>ff"] = "fuzzy_finder",
              -- ["<Leader>ff"] = "filter_on_submit",
              -- ["gd"] = "fuzzy_finder_directory",
              -- ["<C-x>"] = "clear_filter",
              ["gp"] = "prev_git_modified",
              ["gn"] = "next_git_modified",
              --["/"] = "filter_as_you_type", -- this was the default until v1.28
              -- ["D"] = "fuzzy_sorter_directory",
              -- ["/"] = "noop",
            },
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            -- expander_collapsed = "",
            -- expander_expanded = "",
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
        },

        commands = {
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
            ["s"] = "",
            ["z"] = "noop",
            -- ["<CR>"] = "child_or_open",
            -- ["<c-s>"] = "split_with_window_picker",
            -- ["<c-v>"] = "vsplit_with_window_picker",
            ["<c-s>"] = "open_split",
            ["<c-v>"] = "open_vsplit",
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

      highlight.plugin("NeoTree", {
        { NeoTreeNormal = { link = "PanelBackground" } },
        { NeoTreeNormalNC = { link = "PanelBackground" } },
        { NeoTreeCursorLine = { link = "CursorLine" } },
        { NeoTreeRootName = { underline = false } },
        { NeoTreeStatusLine = { link = "PanelStusLine" } },
        { NeoTreeGitModified = { bg = "NONE" } },
        { NeoTreeTabActive = { bg = { from = "PanelBackground" }, bold = true } },
        { NeoTreeIndentMarker = { fg = { from = "ColorColumn", attr = "bg", alter = 0.2 }, bold = false } },
        { NeoTreeTabInactive = { bg = { from = "PanelDarkBackground", alter = 0.15 }, fg = { from = "Comment" } } },
        { NeoTreeTabSeparatorActive = { inherit = "PanelBackground", fg = { from = "Comment" } } },
        {
          NeoTreeTabSeparatorInactive = {
            inherit = "NeoTreeTabInactive",
            fg = { from = "PanelDarkBackground", attr = "bg" },
          },
        },
      })

      vim.g.neo_tree_remove_legacy_commands = 1
    end,
  },
}
