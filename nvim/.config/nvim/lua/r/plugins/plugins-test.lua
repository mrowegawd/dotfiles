local local_dev = true
if local_dev then
  return {}
end

local cmd = vim.cmd

-------------------------------------------------------------------------------
-- NOTE: Just do some testing for new nvim plugin
-------------------------------------------------------------------------------

local Highlight = require "r.config.highlights"
local Util = require "r.utils"
local Icon = require("r.config").icons
local api = vim.api
local fzf_lua = Util.cmd.reqcall "fzf-lua"

local ignore_fts_session = { "gitcommit", "gitrebase", "alpha", "norg", "org", "orgmode", "conf", "markdown" }

local set_icons = function(icons_name)
  return icons_name .. " "
end

return {
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
  -- FLASH.NVIM
  {
    "folke/flash.nvim",
    enabled = false,
    opts = function()
      Highlight.plugin("flash.nvim", {
        {
          FlashMatch = {
            bg = "white",
            fg = "black",
            bold = true,
          },
        },
        {
          FlashLabel = {
            bg = { from = "Normal", attr = "bg", alter = -0.1 },
            fg = { from = "ErrorMsg", attr = "fg" },
            bold = true,
            strikethrough = false,
          },
        },
        { FlashCursor = { bg = { from = "ColorColumn", attr = "bg", alter = 5 }, bold = true } },
      })
      return {
        modes = {
          char = {
            keys = { "F", "t", "T", ";" }, -- remove "," from keys
          },
          search = {
            enabled = false,
          },
        },
        jump = {
          nohlsearch = true,
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "f", function() require("flash").jump() end, mode = { "n", "x", "o" }, },
      -- { "S", function() require("flash").treesitter() end, mode = { "o", "x" } },
      -- { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
      -- { "<c-s>", function() require("flash").toggle() end, mode = { "c" }, desc = "Toggle Flash Search" },
      -- { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Flash Treesitter Search" },
    },
  },

  -- AERIAL (disabled)
  {
    "stevearc/aerial.nvim",
    event = "LazyFile",
    enabled = false,
    init = function()
      Util.disable_ctrl_i_and_o("NoAerial", { "aerial" })

      api.nvim_create_autocmd("FileType", {
        pattern = { "aerial" },
        callback = function()
          vim.keymap.set("n", "zM", function()
            local aerial = require "aerial"
            return aerial.tree_close_all()
          end, {
            buffer = api.nvim_get_current_buf(),
          })
          vim.keymap.set("n", "zO", function()
            local aerial = require "aerial"
            return aerial.tree_open_all()
          end, {
            buffer = api.nvim_get_current_buf(),
          })
        end,
      })
    end,
    keys = function()
      local function get_aerial()
        local ok_aerial, aerial = pcall(require, "aerial")
        return ok_aerial and aerial or {}
      end

      local height = vim.o.lines - vim.o.cmdheight
      if vim.o.laststatus ~= 0 then
        height = height - 1
      end

      local vim_width = vim.o.columns
      local vim_height = height

      local widthc = math.floor(vim_width / 2 + 8)
      local heightc = math.floor(vim_height / 2 - 5)

      return {
        {
          "<Localleader>oa",
          function()
            Util.tiling.force_win_close({}, true)
            vim.cmd [[AerialToggle right]]
            -- if vim.bo[0].filetype == "aerial" then
            --   vim.cmd [[wincmd L]]
            -- end
          end,
          desc = "Misc(aerial): toggle",
        },
        {
          "<Localleader>oA",
          function()
            if vim.bo[0].filetype == "norg" then
              return
            end

            local aerial_selected = {
              "Class",
              "Constructor",
              "Object",
              "Enum",
              "Function",
              "Interface",
              "Variable",
              "Module",
              "Method",
              "Struct",
              "all",
            }
            fzf_lua.fzf_exec(aerial_selected, {
              prompt = "  ",
              no_esc = true,
              fzf_opts = { ["--layout"] = "reverse" },
              winopts_fn = {
                width = widthc,
                height = heightc,
              },
              winopts = {
                title = "[Aerial] Change filter kind",
                row = 1,
                relative = "cursor",
                height = 0.33,
                width = widthc / (widthc + vim_width - 10),
              },
              actions = {
                ["default"] = function(selected, _)
                  local selection = selected[1]
                  if selection ~= nil and type(selection) == "string" then
                    local opts_aerial = Util.opts "aerial.nvim"
                    local aerial = get_aerial()
                    aerial.close()

                    local path = vim.fn.expand "%:p"
                    vim.cmd [[bd]]
                    vim.cmd("e " .. path)
                    if selection == "all" then
                      opts_aerial.filter_kind = false
                    else
                      opts_aerial.filter_kind = { selection }
                    end
                    aerial.setup(opts_aerial)
                    aerial.open()
                  end
                end,
              },
            })
          end,
          desc = "Misc(aerial): change filter kind",
        },
      }
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      ---@diagnostic disable-next-line: undefined-field
      require("telescope").load_extension "aerial"

      local vim_width = vim.o.columns
      vim_width = math.floor(vim_width / 2 - 30)
      return {
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        layout = { min_width = vim_width },
        -- fold code from tree (overwrites treesitter foldexpr)
        manage_folds = false,
        show_guides = true,
        guides = {
          mid_item = "├╴",
          last_item = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
        whitespace = "  ",
        filter_kind = false,
        icons = Icons.kinds,
        keymaps = {
          -- ["o"] = "actions.jump",
          ["o"] = "actions.scroll",
          -- ["]y"] = "actions.next",
          -- ["[y"] = "actions.prev",
          ["<a-n>"] = "actions.down_and_scroll",
          ["<a-p>"] = "actions.up_and_scroll",
          -- ["<a-n>"] = "actions.next",
          -- ["<a-p>"] = "actions.prev",
          -- ["zM"] = "actions.tree_close_all",
          ["{"] = false,
          ["}"] = false,
          ["[["] = false,
          ["]]"] = false,
          ["zM"] = false,
          ["zO"] = false,
        },
      }
    end,
  },
  -- VISTA.NVIM
  {
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    enabled = function()
      if require("r.config").lsp_style == "coc" then
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
        desc = "WinNav(vim-tmux-navigator): move up",
      },
      {
        "<a-j>",
        "<cmd>TmuxNavigateDown<CR>",
        desc = "WinNav(vim-tmux-navigator): move down",
      },
      {
        "<a-h>",
        "<cmd>TmuxNavigateLeft<CR>",
        desc = "WinNav(vim-tmux-navigator): move left",
      },
      {
        "<a-l>",
        "<cmd>TmuxNavigateRight<CR>",
        desc = "WinNav(vim-tmux-navigator): move right",
      },

      -- RESIZE
      {
        "<a-K>",
        "<cmd>resize +2<CR>",
        desc = "WinNav: resize up",
      },
      {
        "<a-J>",
        "<cmd>resize -2<CR>",
        desc = "WinNav: resize down",
      },

      {
        "<a-H>",
        "<cmd>vertical resize -2<CR>",
        desc = "WinNav: resize left",
      },
      {
        "<a-L>",
        "<cmd>vertical resize +2<CR>",
        desc = "WinNav: resize right",
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
        desc = "WinNav(tmux): move up",
      },
      {
        "<a-j>",
        "<cmd>lua require('tmux').move_bottom()<CR>",
        desc = "WinNav(tmux): move down",
      },
      {
        "<a-h>",
        "<cmd>lua require('tmux').move_left()<CR>",
        desc = "WinNav(tmux): move left",
      },
      {
        "<a-l>",
        "<cmd>lua require('tmux').move_right()<CR>",
        desc = "WinNav(tmux): move right",
      },

      -- RESIZE
      {
        "<a-K>",
        function()
          return require("tmux").resize_top()
        end,
        desc = "WinNav(tmux): resize up",
      },
      {
        "<a-J>",
        function()
          return require("tmux").resize_bottom()
        end,
        desc = "WinNav(tmux): resize down",
      },

      {
        "<a-H>",
        function()
          return require("tmux").resize_left()
        end,
        desc = "WinNav(tmux): resize left",
      },
      {
        "<a-L>",
        function()
          return require("tmux").resize_right()
        end,
        desc = "WinNav(tmux): resize right",
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
  -- NVIM-TREE (disabled)
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
  -- CALENDAR
  {
    "itchyny/calendar.vim",
    cmd = { "Calendar" },
    lazy = false,
    keys = {
      { "<Localleader>oc", "<CMD> Calendar <CR>", desc = "Misc(calendar): open" },
    },
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
      { "<Leader>ja", function() require("harpoon.mark").add_file() end, desc = "Misc(harpoon): add file" },
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
    opts = {},
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
    opts = {},
    keys = {
      { "<Localleader>P", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
  },
  -- TROUBLE.NVIM (disabled)
  {
    "folke/trouble.nvim",
    enabled = false,
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      { "<Localleader>tt", "<CMD>TroubleToggle<CR>", desc = "Misc(trouble): toggle", mode = { "n", "v" } },
      { "<Leader>q", "<CMD>TroubleToggle quickfix<CR>", desc = "Misc(trouble): quickfix", mode = { "n", "v" } },
    },
    opts = function()
      Highlight.plugin("trouble", {
        { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn" } } },
        { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError" } } },
        { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint" } } },
        { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
        { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
        { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
        { TroubleIndent = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
        { TroubleLocation = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg" } } },
        { TroubleFoldIcon = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
        {
          TroubleCount = {
            bg = { from = "WinSeparator", attr = "fg", alter = 0.1 },
            fg = { from = "DiagnosticSignError", attr = "fg", alter = 0.1 },
          },
        },
      })
      return {
        auto_open = false,
        use_diagnostic_signs = true, -- en
        action_keys = {
          -- map to {} to remove a mapping, for example:
          -- close = {},
          close = { "q", "<leader><Tab>" }, -- close the list
          cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
          refresh = "r", -- manually refresh
          jump = "o", -- jump to the diagnostic or open / close folds
          open_split = { "<c-s>" }, -- open buffer in new split
          open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
          open_tab = { "<c-t>" }, -- open buffer in new tab
          jump_close = "<cr>", -- jump to the diagnostic and close the list
          toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
          toggle_preview = "p", -- toggle auto_preview
          hover = "K", -- opens a small popup with the full multiline message
          preview = "p", -- preview the diagnostic location
          close_folds = { "zM", "zm" }, -- close all folds
          open_folds = { "zR", "zr" }, -- open all folds
          toggle_fold = { "zA", "za" }, -- toggle fold of current file
          previous = "k", -- previous item
          next = "j", -- next item
        },
      }
    end,
  },
  -- PERSISTED NVIM (disabled)
  {
    "olimorris/persisted.nvim",
    event = "LazyFile",
    enabled = false,
    init = function()
      Util.cmd.augroup("PersistedEvents", {
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
      { "<Leader>pl", function() return vim.cmd.SessionLoadLast() end, { desc = "Misc(persisted): load a session" } },
      { "<Leader>ps", function() vim.cmd.SessionStart() return vim.notify "Sessions persisted: Started.." end, { desc = "Misc(persisted): start a session" } },
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
  -- MINI.CLUE (disabled)
  {
    "echasnovski/mini.clue",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      -- local map_leader = function(suffix, rhs, desc)
      --   vim.keymap.set({ "n", "x" }, "<Leader>" .. suffix, rhs, { desc = desc })
      -- end
      -- map_leader("w", "<cmd>update!<CR>", "Save")
      -- map_leader("qq", require("utils").quit, "Quit")
      -- map_leader("qt", "<cmd>tabclose<cr>", "Close Tab")
      -- map_leader("sc", require("utils.coding").cht, "Cheatsheets")
      -- map_leader("so", require("utils.coding").stack_overflow, "Stack Overflow")

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
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- { mode = "n", keys = "r" },
          -- { mode = "x", keys = "r" },

          -- Registers
          -- { mode = "n", keys = '"' },
          -- { mode = "x", keys = '"' },
          -- { mode = "i", keys = "<C-r>" },
          -- { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          { mode = "n", keys = "<Leader>a", desc = "+AI" },
          { mode = "x", keys = "<Leader>a", desc = "+AI" },
          { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
          { mode = "n", keys = "<Leader>d", desc = "+Debug" },
          { mode = "x", keys = "<Leader>d", desc = "+Debug" },
          { mode = "n", keys = "<Leader>D", desc = "+Database" },
          { mode = "n", keys = "<Leader>f", desc = "+FZFlua" },
          { mode = "n", keys = "<Leader>u", desc = "+Edgy" },

          { mode = "n", keys = "<Leader>j", desc = "+Harpoon" },
          { mode = "n", keys = "<Leader>j", desc = "+Harpoon" },

          { mode = "n", keys = "<Leader>g", desc = "+Git" },
          { mode = "x", keys = "<Leader>g", desc = "+Git" },
          { mode = "n", keys = "<Leader>gf", desc = "+FZFgit" },
          { mode = "n", keys = "<Leader>gv", desc = "+Diffview" },
          { mode = "x", keys = "<Leader>gv", desc = "+Diffview" },
          { mode = "n", keys = "<Leader>gt", desc = "+Toggle" },

          { mode = "n", keys = "<Leader>l", desc = "+Language" },
          { mode = "x", keys = "<Leader>l", desc = "+Language" },
          -- { mode = "n", keys = "gc", desc = "+Coi" },

          -- { mode = "n", keys = "<Leader>lg", desc = "+Annotation" },
          -- { mode = "n", keys = "<Leader>lx", desc = "+Swap Next" },
          -- { mode = "n", keys = "<Leader>lxf", desc = "+Function" },
          -- { mode = "n", keys = "<Leader>lxp", desc = "+Parameter" },
          -- { mode = "n", keys = "<Leader>lxc", desc = "+Class" },
          -- { mode = "n", keys = "<Leader>lX", desc = "+Swap Previous" },
          -- { mode = "n", keys = "<Leader>lXf", desc = "+Function" },
          -- { mode = "n", keys = "<Leader>lXp", desc = "+Parameter" },
          -- { mode = "n", keys = "<Leader>lXc", desc = "+Class" },
          { mode = "n", keys = "<Leader>p", desc = "+Project" },
          { mode = "n", keys = "<Leader>q", desc = "+Quit/Session" },
          { mode = "x", keys = "<Leader>q", desc = "+Quit/Session" },

          { mode = "n", keys = "<Leader>r", desc = "+TaskOrRun" },
          { mode = "x", keys = "<Leader>r", desc = "+TaskOrRun" },

          { mode = "n", keys = "<Leader>s", desc = "+Sessions" },
          { mode = "x", keys = "<Leader>s", desc = "+Sessions" },

          { mode = "n", keys = "<Leader>t", desc = "+Testing" },
          -- { mode = "n", keys = "<Leader>tN", desc = "+Neotest" },

          -- { mode = "n", keys = "<Leader>to", desc = "+Overseer" },
          -- { mode = "n", keys = "<Leader>v", desc = "+View" },
          { mode = "n", keys = "<Leader>z", desc = "+System" },
          { mode = "n", keys = "<Leader>y", desc = "+Surround" },

          { mode = "n", keys = "<Localleader>o", desc = "+Open" },
          { mode = "n", keys = "<Localleader>q", desc = "+QF" },
          { mode = "n", keys = "<Localleader>f", desc = "+Note" },

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
          miniclue.gen_clues.windows {
            submode_move = false,
            submode_navigate = false,
            submode_resize = true,
          },
          miniclue.gen_clues.z(),
        },
      }
    end,
  },
  -- STTUSLINE (disabled)
  {
    "sontungexpt/sttusline",
    enabled = false,
    event = "BufEnter",
    de1endencies = {
      "nvim-tree/nvim-web-devicons",
    },
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
            Util.tiling.force_win_close({ "qf" }, false)

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
            Util.tiling.force_win_close({ "qf" }, false)

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
            Util.tiling.force_win_close({ "qf" }, false)

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
            Util.tiling.force_win_close({ "qf" }, false)

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
            Util.tiling.force_win_close({ "qf" }, false)

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
  { "prichrd/netrw.nvim", enabled = false, opts = {} },
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
  -- OVERSEER.NVIM (disabled)
  {
    "stevearc/overseer.nvim", -- Task runner and job management
    enabled = false,
    -- cmd = {
    --   "OverseerToggle",
    --   "OverseerOpen",
    --   "OverseerInfo",
    --   "OverseerRun",
    --   "OverseerBuild",
    --   "OverseerClose",
    --   "OverseerLoadBundle",
    --   "OverseerSaveBundle",
    --   "OverseerDeleteBundle",
    --   "OverseerRunCmd",
    --   "OverseerQuickAction",
    --   "OverseerTaskAction",
    -- },
    init = function()
      -- Util.cmd.augroup("RunOverseerTasks", {
      --   event = { "FileType" },
      --   pattern = as.lspfiles,
      --   command = function()
      --     -- vim.keymap.set("n", "<F4>", function()
      --     --   local overseer = require "overseer"
      --     --   local tasks = overseer.list_tasks {
      --     --     recent_first = true,
      --     --   }
      --     --
      --     --   if vim.tbl_isempty(tasks) then
      --     --     return vim.notify("No tasks found", vim.log.levels.WARN)
      --     --   else
      --     --     return overseer.run_action(tasks[1], "restart")
      --     --   end
      --     -- end, {
      --     --   desc = "Task(overseer): run or restart the task",
      --     --   buffer = api.nvim_get_current_buf(),
      --     -- })
      --
      --     vim.keymap.set("n", "<F1>", function()
      --       if vim.bo.filetype ~= "OverseerList" then
      --         return cmd "OverseerRun"
      --       end
      --       return cmd "OverseerQuickAction"
      --     end, {
      --       desc = "Task(overseer): run quick action",
      --       buffer = api.nvim_get_current_buf(),
      --     })
      --   end,
      -- })
    end,
    -- keys = {
    --   {
    --     "rt",
    --     function()
    --       Util.tiling.force_win_close({ "neo-tree", "undotree" }, false)
    --       return cmd "OverseerToggle!"
    --     end,
    --     desc = "Task(overseer): toggle",
    --   },
    -- },
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
        min_height = 25,
        max_height = 25,
        bindings = {
          ["<S-tab>"] = "ScrollOutputUp",
          ["<tab>"] = "ScrollOutputDown",
          ["q"] = function()
            vim.cmd "OverseerClose"
          end,
          ["<c-k>"] = false,
          ["<c-j>"] = false,
        },
      },
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
      snippet_path = vim.env.HOME .. "/Dropbox/friendly-snippets/snippets",
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
    opts = {},
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
      { "<Leader>pl", function() local possession = require "nvim-possession" return possession.list() end, desc = "Misc(possession): load a session" },
      { "<Leader>ps", function() local possession = require "nvim-possession" return possession.new() end, desc = "Misc(possession): start or save a session name" },
      { "<Leader>pu", function() local possession = require "nvim-possession" return possession.update() end, desc = "Misc(possession): save a new session or overwrite it" },
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
  -- RESESSION (disabled)
  {
    "stevearc/resession.nvim",
    event = "LazyFile",
    -- stylua: ignore
    keys = {
      { "<Leader>sl", function() require("resession").load() end, desc = "Misc(resession): load from the list" },
      { "<Leader>sd", function() require("resession").delete() end, desc = "Misc(resession): delete" },
      { "<Leader>ss", function() require("resession").save() end, desc = "Misc(resession): save" },
      { "<Leader>sr", function() require("resession").load(nil, {reset = false}) end, desc = "Misc(resession): save without reset" },
    },
    opts = {
      autosave = {
        enabled = true,
        notify = false,
      },
      -- extensions = {
      --   oil = {},
      -- },
    },
    config = function(_, opts)
      local resession = require "resession"
      local aug = vim.api.nvim_create_augroup("StevearcResession", {})
      resession.setup(opts)

      vim.api.nvim_create_user_command("SessionDetach", function()
        resession.detach()
      end, {})

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
          end
        end,
      })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = aug,
        callback = function()
          resession.save "last"
        end,
      })
    end,
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
        Util.cmd.feedkey("<Plug>(StopHL)", "n")
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

      Util.cmd.augroup("VimrcIncSearchHighlight", {
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
    opts = {},
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dropbar").setup {
        general = {
          update_interval = 100,
          enable = function(buf, win)
            local b, w = vim.bo[buf], vim.wo[win]
            local decor = Util.uisec.decoration_get { ft = b.ft, bt = b.bt, setting = "winbar" }
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
            symbols = require("r.config").icons.kinds,
          },
          ui = {
            bar = {
              separator = set_icons(require("r.config").icons.misc.arrow_right),
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
    opts = {},
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
  -- INCRENAME (disabled)
  {
    "smjonas/inc-rename.nvim",
    enabled = false,
    opts = {
      show_message = false,
      hl_group = "MyQuickFixLineEnter", -- the highlight group used for highlighting the identifier's new name
      preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancel
    },
  },
  -- BARBAR.NVIM
  {
    "romgrk/barbar.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
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
    opts = {},
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
  -- MINI-SURROUND
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
}
