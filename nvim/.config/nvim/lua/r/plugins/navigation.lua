local Highlight = require "r.settings.highlights"
local Util = require "r.utils"
local Icons = require("r.config").icons

local fzf_lua = Util.cmd.reqcall "fzf-lua"
local is_outline_opened = false

local function get_outline()
  local ok_outline, outline = pcall(require, "outline")
  return ok_outline and outline or {}
end

return {
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = vim.g.neovide ~= nil,
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
    --     desc = "Misc(neotree): open File explore",
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
      Util.disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })

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
              ["<Left>"] = "git_add_file",
              ["gA"] = "git_add_all",
              ["<Right>"] = "git_unstage_file",
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
  -- OUTLINE.NVIM
  {
    "hedyhli/outline.nvim",
    event = "LspAttach",
    cmd = "Outline",
    opts = function()
      Util.disable_ctrl_i_and_o("NoOutline", { "Outline" })
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

      local kind = Icons.kinds

      return {
        outline_window = {
          position = "right",
          split_command = nil,
          width = 25,
          winhl = "Normal:Pmenu,EndOfBuffer:None,NonText:Normal",
          -- ¦  winhighlight = "Search:None,EndOfBuffer:None",
          -- ¦  winhighlight = "Search:None,EndOfBuffer:None",
          -- ¦  winhighlight = "Search:None,EndOfBuffer:None",
          focus_on_open = false,
        },
        symbols = {
          filter = nil,
          -- icons = require("r.config").icons.kinds,
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
  -- EDGY.NVIM
  {
    "folke/edgy.nvim",
    keys = function()
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
          desc = "Misc(neotree): open File explore",
        },
        {
          "<Localleader>oa",
          function()
            if not is_outline_opened then
              is_outline_opened = true
            else
              is_outline_opened = false
            end
            vim.cmd.Outline()
          end,
          desc = "Misc(outline): toggle",
        },
        {
          "<Localleader>O",
          function()
            if vim.bo.filetype ~= "Outline" then
              local outline_tbl = { found = false, winbufnr = 0, winnr = 0, winid = 0 }
              for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr "$")) do
                if not vim.tbl_contains({ "incline" }, vim.fn.getwinvar(winnr, "&syntax")) then
                  local winbufnr = vim.fn.winbufnr(winnr)

                  local winid = vim.fn.win_findbuf(winbufnr)[1] -- yang dibutuhkan itu winid (example winid: 1004, 1005)

                  if winbufnr > 0 then
                    local winft = vim.api.nvim_get_option_value("filetype", { buf = winbufnr })

                    if winft == "Outline" then
                      outline_tbl = { found = true, winbufnr = winbufnr, winnr = winnr, winid = winid }
                    end
                  end
                end
              end

              if outline_tbl.found and is_outline_opened then
                -- print(vim.inspect(outline_tbl))
                vim.api.nvim_set_current_win(outline_tbl.winid)
              end
            end
          end,
          desc = "Misc(outline): jump back-to-back",
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

            local aerial_selected = { "all" }

            for key, icon in pairs(Icons.kinds) do
              table.insert(aerial_selected, icon .. " " .. key)
            end

            fzf_lua.fzf_exec(aerial_selected, {
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
                    local opts_outline = Util.opts "outline.nvim"
                    local outline = get_outline()
                    if outline.is_open and is_outline_opened then
                      outline.close_outline()
                    end

                    -- local path = vim.fn.expand "%:p"
                    -- vim.cmd [[close]]
                    -- vim.cmd("e " .. path)
                    if selection == "all" then
                      opts_outline.symbols.filter = nil
                    else
                      opts_outline.symbols.filter = { selection }
                    end
                    outline.setup(opts_outline)

                    vim.schedule(function()
                      outline.open_outline()

                      -- vim.cmd("e " .. path)
                    end)
                  end
                end,
              },
            })
          end,
          desc = "Misc(outline): change filter kind",
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
          {
            ft = "Outline",
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
