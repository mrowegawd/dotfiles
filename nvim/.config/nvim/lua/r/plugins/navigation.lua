local Highlight = require "r.settings.highlights"

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

return {
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = vim.g.neovide ~= nil or vim.env.TMUX,
    cmd = "Neotree",
    -- keys = {
    --   {
    --     "<Leader>ge",
    --     function()
    --       if vim.bo[0].filetype == "neo-tree" then
    --         return cmd [[q]]
    --       end
    --       return cmd "Neotree git_status"
    --     end,
    --     desc = "Misc: open file explore [neotree]",
    --   },
    -- },
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
      RUtils.disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })

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
              Highlight.set("Cursor", { blend = 100 })
            end,
          },
          {
            event = "neo_tree_buffer_leave",
            handler = function()
              Highlight.set("Cursor", { blend = 0 })
            end,
          },
          {
            event = "neo_tree_window_after_close",
            handler = function()
              Highlight.set("Cursor", { blend = 0 })
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
              ["<Leader>gha"] = "git_add_file",
              ["<Leader>ghA"] = "git_add_all",
              ["<Leader>ghu"] = "git_unstage_file",
              ["<Leader>ghr"] = "git_revert_file",
              ["<Leader>gc"] = "git_commit",
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
            ["h"] = "parent_or_close",
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
        RUtils.lsp.on_rename(data.source, data.destination)
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

      Highlight.plugin("NeoTree", {
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
  -- AERIAL
  {
    "stevearc/aerial.nvim",
    event = "LazyFile",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      RUtils.disable_ctrl_i_and_o("NoAerial", { "aerial" })
      Highlight.plugin("AerialAuHi", {
        theme = {
          ["*"] = {
            {
              OutlineCurrent = {
                fg = { from = "ErrorMsg", attr = "fg", alter = -0.3 },
                bg = "NONE",
              },
            },
            -- {
            --   OutlineDetails = {
            --     fg = { from = "Comment", attr = "fg", alter = -0.5 },
            --     bg = "NONE",
            --   },
            -- },
            -- {
            --   OutlineFoldMarker = {
            --     fg = { from = "FoldColumn", attr = "fg", alter = 0.2 },
            --     bg = "NONE",
            --   },
            -- },
            -- {
            --   OutlineGuides = {
            --     fg = { from = "FoldColumn", attr = "fg", alter = -0.1 },
            --     bg = "NONE",
            --   },
            -- },
            -- {
            --   OutlineLineno = {
            --     bg = "NONE",
            --   },
            -- },
          },
          -- ["onedark"] = {
          --   {
          --     OutlineDetails = {
          --       fg = { from = "Comment", attr = "fg", alter = 0.05 },
          --       bg = "NONE",
          --     },
          --   },
          --   {
          --     OutlineGuides = {
          --       fg = { from = "FoldColumn", attr = "fg", alter = 0.1 },
          --       bg = "NONE",
          --     },
          --   },
          -- },
          -- ["solarized-osaka"] = {
          --   {
          --     OutlineGuides = {
          --       fg = { from = "FoldColumn", attr = "fg", alter = 0.2 },
          --       bg = "NONE",
          --     },
          --   },
          -- },
          -- ["selenized"] = {
          --   {
          --     OutlineDetails = {
          --       fg = { from = "Comment", attr = "fg", alter = 0.1 },
          --       bg = "NONE",
          --     },
          --   },
          --   {
          --     OutlineCurrent = {
          --       fg = { from = "Error", attr = "fg", alter = -0.1 },
          --       bg = "NONE",
          --     },
          --   },
          --   {
          --     OutlineGuides = {
          --       fg = { from = "FoldColumn", attr = "fg" },
          --       bg = "NONE",
          --     },
          --   },
          -- },
          -- ["miasma"] = {
          --   {
          --     OutlineDetails = {
          --       fg = { from = "Comment", attr = "fg", alter = -0.2 },
          --       bg = "NONE",
          --     },
          --   },
          --   {
          --     OutlineGuides = {
          --       fg = { from = "FoldColumn", attr = "fg", alter = 0.05 },
          --       bg = "NONE",
          --     },
          --   },
          --   {
          --     OutlineCurrent = {
          --       fg = { from = "ErrorMsg", attr = "fg", alter = 0.5 },
          --     },
          --   },
          -- },
        },
      })

      -- ---@diagnostic disable-next-line: undefined-field
      -- require("telescope").load_extension "aerial"

      local vim_width = vim.o.columns
      vim_width = math.floor(vim_width / 2 - 30)

      return {
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        layout = { min_width = vim_width },
        show_guides = true,
        guides = {
          mid_item = "├╴",
          last_item = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
        manage_folds = false,
        link_tree_to_folds = false,
        highlight_mode = "full_width",
        link_folds_to_tree = false,
        filter_kind = false,
        icons = RUtils.config.icons.kinds,
        keymaps = {
          ["<a-n>"] = "actions.down_and_scroll",
          ["<a-p>"] = "actions.up_and_scroll",
          ["{"] = false,
          ["o"] = "actions.jump",
          ["}"] = false,
          ["[["] = false,
          ["]]"] = false,
        },
      }
    end,
  },
  -- EDGY.NVIM
  {
    "folke/edgy.nvim",
    keys = function()
      local height = vim.o.lines - vim.o.cmdheight
      if vim.o.laststatus ~= 0 then
        height = height - 1
      end

      local function get_aerial()
        local ok_aerial, aerial = pcall(require, "aerial")
        return ok_aerial and aerial or {}
      end

      local vim_width = vim.o.columns
      local vim_height = height

      local widthc = math.floor(vim_width / 2 + 8)
      local heightc = math.floor(vim_height / 2 - 5)
      return {
        {
          "<a-e>",
          function()
            local neotree_opened = false
            for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr "$")) do
              if vim.fn.getwinvar(winnr, "&syntax") == "neo-tree" then
                neotree_opened = true
              end
            end

            if neotree_opened then
              if vim.bo[0].filetype == "neo-tree" then
                return vim.cmd [[wincmd p]]
              end
              return vim.cmd "Neotree"
            else
              return vim.cmd "Neotree"
            end
          end,
          desc = "Misc: open file explore [neotree]",
        },
        {
          "<leader>ge",
          function()
            return vim.cmd "Neotree git_status"
          end,
          desc = "Git: open file explore for git status [neotree]",
        },
        {
          "<Localleader>O",
          function()
            local right_win = "aerial"
            if vim.bo.filetype ~= right_win then
              local outline_win = RUtils.cmd.windows_is_opened { right_win }
              if outline_win.found then
                vim.api.nvim_set_current_win(outline_win.winid)
              end
            end
          end,
          desc = "Misc: move cursor to outline window [outline]",
        },
        {
          "<Localleader>oa",
          function()
            vim.cmd [[AerialToggle right]]
          end,
          desc = "Misc: toggle aerial [aerial]",
        },
        {
          "<Localleader>oA",
          function()
            if vim.bo[0].filetype == "norg" then
              return
            end

            local aerial_provider_selected = { "all" }

            for key, icon in pairs(RUtils.config.icons.kinds) do
              table.insert(aerial_provider_selected, icon .. " " .. key)
            end

            fzf_lua.fzf_exec(aerial_provider_selected, {
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
                  local sel = {}
                  for word in selected[1]:gmatch "%w+" do
                    table.insert(sel, word)
                  end
                  local selection = sel[1]

                  if selection ~= nil and type(selection) == "string" then
                    local opts_aerial = RUtils.opts "aerial.nvim"
                    local aerial = get_aerial()
                    local outline_win = RUtils.cmd.windows_is_opened { "aerial" }
                    if outline_win.found then
                      vim.cmd [[AerialToggle]]
                      -- outline.close_outline()
                    end

                    -- we must reload
                    vim.cmd "e "
                    if selection == "all" then
                      opts_aerial.filter_kind = false
                    else
                      opts_aerial.filter_kind = { selection }
                    end
                    aerial.setup(opts_aerial)
                    vim.schedule(function()
                      aerial.open()
                    end)
                  end
                end,
              },
            })
          end,
          desc = "Misc: change filter kind aerial [aerial]",
        },
      }
    end,
    opts = function()
      Highlight.plugin("NeoEdgyHi", {
        { WinBar = { bg = "NONE" } },
        { EdgyNormal = { bg = "NONE" } },
        { WinBarNC = { bg = "NONE" } },
        { EdgyTitle = { fg = { from = "Boolean", attr = "fg" }, bold = true } },
      })

      return {
        animate = { enabled = false },
        wo = {
          -- Setting to `true`, will add an edgy winbar.
          -- Setting to `false`, won't set any winbar.
          -- Setting to a string, will set the winbar to that string.
          winbar = true,
          winfixwidth = true,
          winfixheight = false,
          winhighlight = "WinBar:Normal,Normal:Normal",
          spell = false,
          signcolumn = "no",
        },
        bottom = {
          -- {
          --   ft = "toggleterm",
          --   size = { height = 0.4 },
          --   ---@diagnostic disable-next-line: unused-local
          --   filter = function(buf, win)
          --     return vim.api.nvim_win_get_config(win).relative == ""
          --   end,
          -- },
          -- {
          --   ft = "noice",
          --   size = { height = 0.4 },
          --   ---@diagnostic disable-next-line: unused-local
          --   filter = function(buf, win)
          --     return vim.api.nvim_win_get_config(win).relative == ""
          --   end,
          -- },
          -- {
          --   ft = "lazyterm",
          --   title = "LazyTerm",
          --   size = { height = 0.4 },
          --   filter = function(buf)
          --     return not vim.b[buf].lazyterm_cmd
          --   end,
          -- },
          -- "Trouble",
          -- { ft = "qf", title = "QuickFix" },
          -- {
          --   ft = "help",
          --   size = { height = 20 },
          --   -- don't open help files in edgy that we're editing
          --   filter = function(buf)
          --     return vim.bo[buf].buftype == "help"
          --   end,
          -- },
          -- { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
          -- { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
        },
        right = {
          -- {
          --   ft = "Outline",
          --   pinned = true,
          --   open = "Outline",
          --   size = {
          --     width = 0.2,
          --   },
          -- },
          {
            ft = "aerial",
            pinned = true,
            open = "Outline",
            size = {
              width = 0.2,
            },
          },
        },
        left = {
          -- { title = "Neotest Summary", ft = "neotest-summary" },
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
            size = { height = 0.6 },
          },
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
          -- "neo-tree",
        },
        keys = {
          -- increase width
          ["<a-H>"] = function(win)
            win:resize("width", 2)
          end,
          -- decrease width
          ["<a-L>"] = function(win)
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
    end,
  },
}
