local toggle_state = false

return {
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- cond = vim.g.neovide ~= nil or not vim.env.TMUX,
    cmd = "Neotree",
    keys = {
      -- sidebar left (neotree)
      {
        "<a-e>",
        function()
          vim.cmd "Neotree toggle right"
        end,
        desc = "Misc: open file explore [neotree]",
      },
      {
        "<Leader>ue",
        function()
          vim.cmd "Neotree toggle right"
        end,
        desc = "Toggle: open file explore [neotree]",
      },

      {
        "<a-W>",
        function()
          local wiki_path = RUtils.config.path.wiki_path
          vim.cmd(string.format("Neotree dir=%s right", wiki_path))
        end,
        desc = "Misc: open file wikis explore [neotree]",
      },
      {
        "<Leader>uE",
        function()
          local wiki_path = RUtils.config.path.wiki_path
          vim.cmd(string.format("Neotree dir=%s right", wiki_path))
        end,
        desc = "Toggle: open file wikis explore [neotree]",
      },
    },

    dependencies = {
      "MunifTanjim/nui.nvim",
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
    opts = function()
      RUtils.disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })

      local Preview = require "neo-tree.sources.common.preview"
      -- local events = require "neo-tree.events"
      local log = require "neo-tree.log"

      local H = require "r.settings.highlights"
      H.plugin("NeoTreeHi", {
        theme = {
          ["*"] = {
            { Directory = { link = "Directory" } },
            { NeoTreeNormal = { link = "PanelSideBackground" } },
            { NeoTreeNormalNC = { link = "PanelSideBackground" } },
            { NeoTreeCursorLine = { link = "HoveredCursorline" } },
            { NeoTreeRootName = { link = "PanelSideRootName" } },
            { NeoTreeStatusLine = { link = "PanelSideStusLine" } },
            { NeoTreeWinSeparator = { link = "PanelSideWinSeparator" } },
            {
              NeoTreeTabActive = {
                fg = { from = "Keyword", attr = "fg" },
                bg = { from = "PanelSideBackground", attr = "bg" },
                bold = true,
              },
            },
            {
              NeoTreeTabInActive = {
                fg = { from = "PanelSideBackground", attr = "bg" },
                bg = { from = "TabLine", attr = "bg", alter = 0.66 },
                bold = true,
              },
            },

            { NeoTreeIndentMarker = { fg = { from = "TroubleIndent", attr = "fg" }, bold = false } },
            { NeoTreeTabSeparatorActive = { inherit = "PanelSideNormal", fg = { from = "Comment" } } },

            { NeoTreeGitAdded = { link = "GitSignsAdd" } },
            { NeoTreeGitModified = { link = "GitSignsChange" } },
            {
              NeoTreeTabSeparatorInactive = {
                inherit = "NeoTreeTabInactive",
                fg = { from = "PanelSideDarkBackground", attr = "bg" },
              },
            },
          },
        },
      })

      return {
        sources = { "filesystem", "git_status", "buffers" },
        source_selector = {
          winbar = true,
          separator_active = "",
          sources = {
            { source = "filesystem" },
            { source = "git_status" },
            { source = "buffers" },
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
              H.set("Cursor", { blend = 100 })
            end,
          },
          {
            event = "neo_tree_buffer_leave",
            handler = function()
              H.set("Cursor", { blend = 0 })
            end,
          },
          {
            event = "neo_tree_window_after_close",
            handler = function()
              H.set("Cursor", { blend = 0 })
            end,
          },
        },
        buffers = {
          leave_dirs_open = true,
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
          -- bind_to_cwd = false,
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
              ["gp"] = "prev_git_modified",
              ["gn"] = "next_git_modified",
              ["<a-p>"] = "prev_git_modified",
              ["<a-n>"] = "next_git_modified",
              -- ["<leader>ff"] = "fuzzy_finder",
              -- ["<Leader>ff"] = "filter_on_submit",
              -- ["gd"] = "fuzzy_finder_directory",
              -- ["<C-x>"] = "clear_filter",
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

          fzmark = function()
            local reverse = {}
            local dropbox_path = RUtils.config.path.dropbox_path
            local path_fzmark = dropbox_path .. "/data.programming.forprivate/marked-pwd"

            local cat_fzmark = vim.api.nvim_exec2("!cat " .. path_fzmark, { output = true })
            if cat_fzmark.output ~= nil then
              local res = vim.split(cat_fzmark.output, "\n")
              -- print(vim.inspect(#res - 1))
              for index = 2, #res - 1 do
                if #res[index] > 1 then
                  reverse[#reverse + 1] = res[index]
                end
              end
            end
            -- end

            return require("fzf-lua").fzf_exec(reverse, {
              prompt = RUtils.fzflua.padding_prompt(),
              winopts = {
                title = RUtils.fzflua.format_title("FzMark", "󰈙"),
              },
              actions = {
                ["default"] = function(e)
                  vim.cmd.cd(e[1])
                end,
              },
            })
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
              -- print(vim.inspect(node:get_id()))
              -- local filepath = node:get_id()
              local filename = node.name
              local modify = vim.fn.fnamemodify

              local file_extension = modify(filename, ":e")

              -- local results = {
              --   filepath,
              --   modify(filepath, ":."),
              --   modify(filepath, ":~"),
              --   filename,
              --   modify(filename, ":r"),
              --   modify(filename, ":e"),
              -- }

              if file_extension == "pdf" then
                if os.getenv "TERMINAL" == "kitty" then
                  print(filename)
                end
                return
              end

              state.commands.open(state)
            end
          end,

          open_lazygit = function()
            Snacks.lazygit()
          end,

          open_lazydocker = function()
            RUtils.terminal.lazydocker()
          end,

          open_terminal = function()
            RUtils.terminal { cwd = RUtils.root() }
          end,

          toggle_open_preview = function(state)
            if state.use_image_nvim then
              if vim.g.neovide then
                state.use_image_nvim = false
              end
            end
            -- toggle_state = false
            local node = state.tree:get_node()

            if not toggle_state then
              if node.ext == "mp4" then
                log.warn(string.format("not allowed to preview ext file: %s", node.ext))
                Preview.hide()
                return
              else
                Preview.show(state)
              end
              toggle_state = true
            else
              toggle_state = false
              Preview.hide()
            end
          end,

          open_search_cd_and_grep = function()
            local cmds = { "Grep string in file", "Search name of file" }
            vim.ui.select(cmds, {
              prompt = "Select commands",
              format_item = function(item)
                return "CMD: " .. item
              end,
            }, function(choice)
              if choice == nil then
                return
              end
              if choice == cmds[1] then
                vim.cmd "wincmd l"
                vim.schedule(function()
                  require("fzf-lua").live_grep_glob {
                    winopts = {
                      title = RUtils.fzflua.format_title(choice, "󰈙"),
                    },
                    actions = {
                      ["default"] = function(e)
                        local sel = RUtils.fzflua.__strip_str(e[1])
                        if sel then
                          local res = vim.split(sel, "\t")

                          local filename = res[1]
                          local slice_text_2 = res[2]

                          local split_text = vim.split(slice_text_2, ":")
                          local path_fdname = split_text[1]
                          local row = split_text[2]
                          local col = split_text[3]

                          filename = path_fdname .. "/" .. filename
                          vim.cmd("e  " .. filename)
                          vim.api.nvim_win_set_cursor(0, { tonumber(row), tonumber(col) })
                        end
                      end,
                    },
                  }
                end)
              end

              if choice == cmds[2] then
                vim.cmd "wincmd l"
                require("fzf-lua").files {
                  winopts = {
                    title = RUtils.fzflua.format_title(choice, "󰈙"),
                  },
                  actions = {
                    ["default"] = function(e)
                      local sel = RUtils.fzflua.__strip_str(e[1])
                      if sel then
                        local res = vim.split(sel, "\t")
                        local filepath = res[2]
                        local filename = res[1]
                        -- TODO: seharusnya dicheck format selection nya apakah
                        -- itu: vidio, pdf, image, dan sebagainya
                        if filepath then
                          local fullname = vim.fn.fnamemodify(filepath .. "/" .. filename, ":.")

                          -- print(filename)

                          vim.cmd("e  " .. fullname)
                          vim.cmd.cd(res[2])
                        end
                      end
                    end,
                  },
                }
              end
            end)
          end,
        },
        git_status = {
          window = {
            mappings = {
              ["<Leader>gha"] = "git_add_file",
              ["<Leader>ghA"] = "git_add_all",
              ["<Leader>ghu"] = "git_unstage_file",
              ["<Leader>ghr"] = "git_revert_file",
              ["w"] = "noop",

              ["gg"] = "noop",
              ["e"] = "child_or_open",

              [","] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },

              ["g?"] = "show_help",
            },
          },
        },

        window = {
          mappings = {
            ["tn"] = "noop",
            ["<space>"] = "noop",
            ["w"] = "noop",

            ["<c-o>"] = "fzmark",
            ["<a-t>"] = "open_terminal",
            ["<a-g>"] = "open_lazygit",
            ["<a-d>"] = "open_lazydocker",

            ["K"] = "show_file_details",

            ["<2-LeftMouse>"] = "open",
            ["<a-q>"] = "open_search_cd_and_grep",
            ["l"] = "child_or_open",
            ["h"] = "parent_or_close",
            ["P"] = {
              "toggle_open_preview",
              config = { use_float = true, use_image_nvim = true },
            },
            ["o"] = "child_or_open",
            ["e"] = "child_or_open",
            -- ["s"] = "filter_on_submit",
            -- ["S"] = "fuzzy_finder_directory",
            ["t"] = "", -- disabled open tab
            ["z"] = "",
            ["<Tab>"] = "toggle_node",
            ["<S-Tab>"] = "close_all_nodes",
            ["<c-s>"] = "open_split",
            ["<c-v>"] = "open_vsplit",
            -- ["<c-t>"] = "open_tabnew",
            ["<esc>"] = "revert_preview",
            ["m"] = "",
            ["zM"] = "close_all_nodes",
            ["zO"] = "expand_all_nodes",
            ["th"] = "prev_source",
            ["tl"] = "next_source",
            ["gh"] = "prev_source",
            ["gl"] = "next_source",
            [",c"] = { "order_by_created", nowait = false },
            [",d"] = { "order_by_diagnostics", nowait = false },
            [",m"] = { "order_by_modified", nowait = false },
            [",n"] = { "order_by_name", nowait = false },
            [",s"] = { "order_by_size", nowait = false },
            [",t"] = { "order_by_type", nowait = false },

            [","] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },

            ["g?"] = "show_help",
          },
        },
      }
    end,
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
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

      vim.g.neo_tree_remove_legacy_commands = 1
    end,
  },
  -- AERIAL (disabled)
  {
    "stevearc/aerial.nvim",
    enabled = false,
    event = "VeryLazy",
    keys = {
      {
        "<Leader>oa",
        function()
          vim.cmd.AerialToggle()
        end,
        desc = "Open: aerial window [aerial]",
      },
      {
        "<Leader>oA",
        function()
          if vim.tbl_contains({ "norg", "org", "orgagenda" }, vim.bo[0].filetype) then
            return
          end

          local opts = {
            title = RUtils.has "aerial.nvim" and "Aerial" or "Outline",
            actions = {
              ["default"] = function(selected, _)
                local sel = {}
                for word in selected[1]:gmatch "%w+" do
                  table.insert(sel, word)
                end
                local selection = sel[1]

                if selection ~= nil and type(selection) == "string" then
                  if RUtils.has "aerial.nvim" then
                    local function get_aerial()
                      local ok_aerial, aerial = pcall(require, "aerial")
                      return ok_aerial and aerial or {}
                    end

                    local opts_aerial = RUtils.opts "aerial.nvim"
                    local aerial = get_aerial()
                    local outline_win = RUtils.cmd.windows_is_opened { "aerial" }
                    if outline_win.found then
                      vim.cmd [[AerialToggle]]
                      -- outline.close_outline()
                    end

                    -- must reload
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

                  if RUtils.has "outline.nvim" then
                    local function get_outline()
                      local ok_aerial, aerial = pcall(require, "outline")
                      return ok_aerial and aerial or {}
                    end

                    local opts_outline = RUtils.opts "outline.nvim"
                    local outline = get_outline()
                    local outline_win = RUtils.cmd.windows_is_opened { "Outline" }
                    if outline_win.found then
                      vim.cmd.Outline()
                    end

                    -- must reload
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
                end
              end,
            },
          }
          RUtils.fzflua.open_cmd_filter_kind_lsp(opts)
        end,
        desc = "Open: filter kind for outline [outline]",
      },
    },
    opts = function()
      RUtils.disable_ctrl_i_and_o("NoAerial", { "aerial" })
      -- require("telescope").load_extension "aerial"

      local vim_width = vim.o.columns
      vim_width = math.floor(vim_width / 2 - 45)
      -- RUtils.info(vim.inspect(vim_width))

      return {
        layout = { min_width = vim_width, max_width = { 40, 0.2 } },
        backends = { "lsp", "markdown", "asciidoc", "man" },
        show_guides = true,
        guides = {
          mid_item = "├╴",
          last_item = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },

        nav = {
          border = "rounded",
          max_height = 0.9,
          min_height = { 10, 0.1 },
          max_width = 0.5,
          min_width = { 0.2, 20 },
          win_opts = {
            cursorline = true,
            winblend = 10,
          },
          -- Jump to symbol in source window when the cursor moves
          autojump = false,
          -- Show a preview of the code in the right column, when there are no child symbols
          preview = true,
          -- Keymaps in the nav window
          keymaps = {
            ["<CR>"] = "actions.jump",
            ["<2-LeftMouse>"] = "actions.jump",
            ["<C-v>"] = "actions.jump_vsplit",
            ["<C-s>"] = "actions.jump_split",
            ["h"] = "actions.left",
            ["l"] = "actions.right",
            ["<C-c>"] = "actions.close",
          },
        },
        -- highlight_mode = "full_width",
        manage_folds = false,
        link_tree_to_folds = false,
        link_folds_to_tree = false,
        icons = RUtils.config.icons.kinds,
        keymaps = {
          ["<a-n>"] = "actions.down_and_scroll",
          ["<a-p>"] = "actions.up_and_scroll",
          ["{"] = false,
          ["<BS>"] = "actions.tree_toggle",
          ["o"] = "actions.jump",
          ["}"] = false,
          ["[["] = false,
          ["]]"] = false,
          ["zm"] = "actions.tree_close_all",
          ["zO"] = "actions.tree_open_all",
        },
      }
    end,
  },
  -- OUTLINE.NVIM
  {
    "MadKuntilanak/outline.nvim",
    -- dir = "~/.local/src/nvim_plugins/outline.nvim",
    branch = "feat/big-updates",
    keys = {
      {
        "<Leader>oa",
        function()
          vim.cmd.Outline()
        end,
        desc = "Open: outline window [outline]",
      },
    },
    opts = function()
      RUtils.disable_ctrl_i_and_o("NoOutline", { "Outline" })
      local kind = RUtils.config.icons.kinds
      return {
        outline_window = {
          position = "right",
          winhl = "Normal:Normal,EndOfBuffer:None,NonText:Normal,CursorLine:FloatCursorline",
          focus_on_open = false,
          show_cursorline = true,
          hide_cursor = false,
        },
        symbols = {
          filter = nil,
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
          auto_preview = false,
          winhl = "NormalFloat:NormalFloat",
        },
        providers = {
          priority = { "lsp", "markdown", "norg" },
        },
        picker = "fzf-lua", -- fzf-lua, telescope
        -- These keymaps can be a string or a table for multiple keys.
        -- Set to `{}` to disable. (Using 'nil' will fallback to default keys)
        keymaps = {
          show_help = "?",
          close = { "q", "<Leader><Tab>" },
          goto_location = { "<Cr>", "o" },
          peek_location = {},
          goto_and_close = {},
          restore_location = {},
          hover_symbol = {},
          toggle_preview = { "P" },
          rename_symbol = {},
          code_actions = {},
          fold = "h",
          fold_toggle = { "<Tab>", "za", "zk", "<c-r>", "<c-a>" },
          fold_toggle_all = "<S-Tab>",
          unfold = "l",
          fold_all = { "zm", "zM" },
          unfold_all = { "zO", "zR" },
          fold_reset = "<space><space>",
          down_and_jump = { "<a-n>", "<c-n>" },
          up_and_jump = { "<a-p>", "<c-p>" },

          -- open_in_vsplit = "<C-v>",
          -- open_in_split = "<C-s>",
          -- open_in_tab = "<C-t>",
          -- open_in_float = "O",

          filter_symbols = "<localleader>f",
        },
      }
    end,
  },
}
