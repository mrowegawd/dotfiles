local _outline_follow_state = nil
local toggle_state = false

return {
  -- OIL.NVIM
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    keys = {
      { "<LocalLeader>qv", "", desc = "view", ft = { "oil" } },

      {
        "<Leader>oo",
        function()
          local right_win = { "trouble", "aerial", "Outline", "neo-tree", "snacks_notif_history", "ErgoTerm" }
          if vim.tbl_contains(right_win, vim.bo.filetype) then
            ---@diagnostic disable-next-line: undefined-field
            RUtils.warn "This filetype is excluded and cannot be opened in oil.nvim"
            return
          end

          vim.cmd "Oil"
        end,
        desc = "Open: focus file explorer [oil]",
      },
      {
        "<Leader>oO",
        function()
          require("oil").open(vim.fn.getcwd())
        end,
        desc = "Open: file explorer [oil]",
      },
    },
    dependencies = {
      "benomahony/oil-git.nvim",
    },
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = false,
      watch_for_changes = true,
      win_options = {
        concealcursor = "n",
      },
      keymaps = {
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["~"] = { "<cmd>edit $HOME<CR>", mode = "n", desc = "Open CWD" },

        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },

        ["<Leader>y"] = { "actions.copy_to_system_clipboard", mode = { "n", "v" } },
        ["<Leader>p"] = "actions.paste_from_system_clipboard",
        ["<Leader>t"] = "actions.open_terminal",
        ["<a-t>"] = "actions.open_terminal",

        ["P"] = "actions.preview",
        ["H"] = { "actions.toggle_hidden", mode = "n" },

        ["<Leader>cd"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },

        ["<a-o>"] = {
          function()
            local reverse = {}
            local dropbox_path = RUtils.config.path.dropbox_path
            local path_fzmark = dropbox_path .. "/data.programming.forprivate/marked-pwd"

            local cat_fzmark = vim.api.nvim_exec2("!cat " .. path_fzmark, { output = true })
            if cat_fzmark.output ~= nil then
              local res = vim.split(cat_fzmark.output, "\n")
              for index = 2, #res - 1 do
                if #res[index] > 1 then
                  reverse[#reverse + 1] = res[index]
                end
              end
            end

            return require("fzf-lua").fzf_exec(reverse, {
              prompt = RUtils.fzflua.padding_prompt(),
              winopts = {
                title = RUtils.fzflua.format_title("FzMark", "󰈙"),
              },
              actions = {
                ["default"] = function(e)
                  if not e then
                    return
                  end

                  vim.cmd.cd(e[1])
                  require("oil").open(e[1])
                end,
              },
            })
          end,
        },
        ["<a-g>"] = {
          function()
            ---@diagnostic disable-next-line: undefined-global
            Snacks.lazygit()
          end,
        },
        ["<a-d>"] = {
          function()
            RUtils.terminal.lazydocker()
          end,
        },

        ["<Leader><Leader>"] = {
          function()
            local dir = require("oil").get_current_dir()
            if vim.api.nvim_win_get_config(0).relative ~= "" then
              vim.api.nvim_win_close(0, true)
            end
            local fzf_lua = RUtils.cmd.reqcall "fzf-lua"
            fzf_lua.files { cwd = dir }
          end,
          desc = "[F]ind [F]iles in dir",
        },
        ["<Leader>fg"] = {
          function()
            local dir = require("oil").get_current_dir()
            if vim.api.nvim_win_get_config(0).relative ~= "" then
              vim.api.nvim_win_close(0, true)
            end
            local fzf_lua = RUtils.cmd.reqcall "fzf-lua"
            fzf_lua.live_grep { cwd = dir }
          end,
          desc = "[F]ind by [G]rep in dir",
        },
        ["<LocalLeader>qvp"] = {
          desc = "Toggle detail view",
          callback = function()
            local oil = require "oil"
            local config = require "oil.config"
            if #config.columns == 1 then
              oil.set_columns { "icon", "permissions", "size", "mtime" }
            else
              oil.set_columns { "icon" }
            end
          end,
        },
      },
      view_options = {
        show_hidden = true,
      },
    },
    config = function(_, opts)
      local oil = require "oil"
      oil.setup(opts)

      -- local p = require "p"
      -- local ftplugin = p.require "ftplugin"
      -- ftplugin.set("oil", {
      --   callback = function(bufnr)
      --     vim.api.nvim_buf_create_user_command(bufnr, "Save", function(params)
      --       oil.save { confirm = not params.bang }
      --     end, {
      --       desc = "Save oil changes with a preview",
      --       bang = true,
      --     })
      --     vim.api.nvim_buf_create_user_command(bufnr, "OpenTerminal", function(params)
      --       require("oil.adapters.ssh").open_terminal()
      --     end, {
      --       desc = "Open the debug terminal for ssh connections",
      --     })
      --   end,
      -- })
    end,
  },
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- cond = vim.g.neovide ~= nil or not vim.env.TMUX,
    cmd = "Neotree",
    keys = {
      {
        "<a-e>",
        function()
          RUtils.layout.toggle_sidebar("neo-tree", function()
            vim.cmd "Neotree toggle"
          end)
        end,
        desc = "Misc: open file explore [neotree]",
      },
      {
        "<Leader>OO",
        function()
          ---@diagnostic disable-next-line: undefined-field
          RUtils.info(vim.inspect(RUtils.layout.debug()))
        end,
        desc = "Misc: open file explore [neotree]",
      },
    },

    dependencies = {
      "MadKuntilanak/nui.nvim",
      "mrbjarksen/neo-tree-diagnostics.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      RUtils.map.disable_ctrl_i_and_o("NoNeoTree", { "neo-tree" })

      local Preview = require "neo-tree.sources.common.preview"

      local H = require "r.settings.highlights"
      H.plugin("NeoTreeHi", {
        theme = {
          ["*"] = {
            { Directory = { inherit = "Directory" } },
            { NeoTreeNormal = { inherit = "PanelSideBackground" } },
            { NeoTreeNormalNC = { inherit = "PanelSideBackground" } },
            { NeoTreeCursorLine = { inherit = "HoveredCursorline" } },
            { NeoTreeRootName = { inherit = "PanelSideRootName" } },
            { NeoTreeStatusLine = { inherit = "PanelSideStusLine" } },
            { NeoTreeWinSeparator = { inherit = "PanelSideWinSeparator" } },
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

            { NeoTreeIndentMarker = { fg = { from = "OutlineGuides", attr = "fg" }, bold = false } },
            { NeoTreeTabSeparatorActive = { inherit = "PanelSideNormal", fg = { from = "Comment" } } },

            -- { NeoTreeGitAdded = { inherit = "GitSignsAdd" } },
            -- { NeoTreeGitModified = { inherit = "GitSignsChange" } },
            {
              NeoTreeTabSeparatorInactive = {
                inherit = "NeoTreeTabInactive",
                fg = { from = "PanelSideDarkBackground", attr = "bg" },
              },
            },

            {
              NeoTreeFloatNormal = {
                inherit = "NormalFloat",
                bg = { from = "NormalFloat", attr = "bg", alter = 0.2 },
              },
            },
            {
              NeoTreeFloatBorder = {
                fg = { from = "NeoTreeFloatNormal", attr = "bg" },
                bg = { from = "NeoTreeFloatNormal", attr = "bg" },
              },
            },
            {
              NeoTreeTitleBar = {
                inherit = "NeoTreeFloatNormal",
                fg = { from = "NeoTreeFloatNormal", attr = "bg", alter = 1 },
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
              ["<C-n>"] = "next_git_modified",
              ["<C-p>"] = "prev_git_modified",
            },
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
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
              for index = 2, #res - 1 do
                if #res[index] > 1 then
                  reverse[#reverse + 1] = res[index]
                end
              end
            end

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

          bookmark_cycle_save = function(state)
            RUtils.fileexplorer.ensure_files()

            local cwd = state.path
            local list = RUtils.fileexplorer.read_bookmarks()

            for _, v in ipairs(list) do
              local normalize_path_v = RUtils.fileexplorer.normalize_path(v)
              local normalize_path_cwd = RUtils.fileexplorer.normalize_path(cwd)
              if normalize_path_v == normalize_path_cwd then
                ---@diagnostic disable-next-line: undefined-field
                RUtils.warn(string.format("Already bookmarked:\n%s", normalize_path_cwd))
                return
              end
            end

            local normalize_cwd = RUtils.fileexplorer.normalize_path(cwd)
            table.insert(list, normalize_cwd)
            RUtils.fileexplorer.write_bookmarks(list)
            RUtils.warn(string.format("Bookmark saved (%d total):\n%s", #list, normalize_cwd))
          end,

          bookmark_cycle_pick = function()
            RUtils.fileexplorer.ensure_files()

            local list_bookmarks = RUtils.fileexplorer.read_bookmarks()

            local opts = {
              winopts = { title = RUtils.fzflua.format_title("Pick/Delete Bookmark", "") },
              fzf_opts = { ["--header"] = [[^x:delete]] },
              actions = {
                ["default"] = function(selection)
                  if not selection then
                    return
                  end
                  RUtils.fileexplorer.jump_to(selection[1])
                end,
                ["ctrl-x"] = function(selection)
                  if not selection then
                    return
                  end
                  list_bookmarks = RUtils.fileexplorer.read_bookmarks()

                  local newlist = {}
                  for _, list in pairs(list_bookmarks) do
                    if list ~= selection[1] then
                      table.insert(newlist, list)
                    end
                  end

                  RUtils.fileexplorer.write_bookmarks(newlist)
                  ---@diagnostic disable-next-line: undefined-field
                  RUtils.info("delete `" .. selection[1] .. "`, reload this pick")
                  require("fzf-lua").actions.resume()
                end,
              },
            }
            require("fzf-lua").fzf_exec(list_bookmarks, RUtils.fzflua.open_dock_bottom(opts))
          end,

          bookmark_cycle_cycle = function()
            RUtils.fileexplorer.ensure_files()
            local list = RUtils.fileexplorer.read_bookmarks()

            if #list == 0 then
              ---@diagnostic disable-next-line: undefined-field
              RUtils.warn "No bookmarks yet. Use save to add one."
              return
            end

            local idx = RUtils.fileexplorer.read_index()
            idx = (idx % #list) + 1 -- next, wrap around
            RUtils.fileexplorer.write_index(idx)

            local target = list[idx]
            local basename_target = RUtils.fileexplorer.normalize_path(target)
            ---@diagnostic disable-next-line: undefined-field
            RUtils.info(string.format("[%d/%d] %s", idx, #list, basename_target))
            RUtils.fileexplorer.jump_to(target)
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
              local filename = node.name
              local modify = vim.fn.fnamemodify

              local file_extension = modify(filename, ":e")

              if file_extension == "pdf" then
                if os.getenv "TERMINAL" == "kitty" then
                  print(filename)
                end
                return
              end

              state.commands.open(state)
            end
          end,

          open_cwd_in_terminal = function()
            RUtils.terminal.open_terminal_in_filetree(RUtils.root())
          end,

          toggle_previewer = function(state)
            if state.use_image_nvim then
              if vim.g.neovide then
                state.use_image_nvim = false
              end
            end
            local node = state.tree:get_node()

            ---@param process_name string
            local function kill_process_by_name(process_name)
              os.execute(
                "pkill -15 -x "
                  .. process_name
                  .. " >/dev/null 2>&1 || true\n"
                  .. "sleep 0.15\n"
                  .. "pkill -9 -x "
                  .. process_name
                  .. " >/dev/null 2>&1 || true"
              )
            end

            if vim.tbl_contains({ "mp3", "mp4", "gif", "mkv", "avi" }, node.ext) and node.path then
              kill_process_by_name "mpv"
              os.execute(
                "nohup mpv --really-quiet --autofit=600x600 --geometry=-15-60 '" .. node.path .. "' >/dev/null 2>&1 &"
              )
              return
            end

            if vim.tbl_contains({ "pdf" }, node.ext) and node.path then
              kill_process_by_name "zathura"
              os.execute("nohup zathura '" .. node.path .. "' >/dev/null 2>&1 &")
              return
            end

            if vim.tbl_contains({ "jpg", "jpeg", "png" }, node.ext) and node.path then
              kill_process_by_name "sxiv"
              os.execute('nohup sxiv "' .. node.path .. '" >/dev/null 2>&1 &')
              return
            end

            if not toggle_state then
              toggle_state = true
              Preview.show(state)
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
              ["gg"] = "noop",
              ["w"] = "noop",

              ["<Leader>gsa"] = "git_add_file",
              ["<Leader>gsA"] = "git_add_all",
              ["<Leader>gsu"] = "git_unstage_file",
              ["<Leader>gsr"] = "git_revert_file",

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
            ["l"] = "noop",
            ["e"] = "noop",
            ["t"] = "noop", -- disabled open tab
            ["m"] = "noop",

            ["<a-B>"] = "bookmark_cycle_pick",
            ["b"] = "bookmark_cycle_save",
            ["B"] = "bookmark_cycle_cycle",

            ["<a-o>"] = "fzmark",
            ["K"] = "show_file_details",
            ["<a-G>"] = "open_search_cd_and_grep",

            ["<2-LeftMouse>"] = "open",
            ["<BS>"] = "parent_or_close",
            ["o"] = "child_or_open",
            ["P"] = {
              "toggle_previewer",
              config = { use_float = true, use_image_nvim = true },
            },

            ["<c-s>"] = "open_split",
            ["<c-v>"] = "open_vsplit",

            ["<a-T>"] = "open_cwd_in_terminal",

            ["<ESC>"] = "revert_preview",

            ["<Tab>"] = "toggle_node",
            ["<S-Tab>"] = "close_node",

            ["zM"] = "close_all_nodes",
            ["zc"] = "close_node",
            ["zR"] = "expand_all_subnodes",
            ["zO"] = "expand_all_nodes",

            ["gh"] = "prev_source",
            ["gl"] = "next_source",

            ["mc"] = { "order_by_created", nowait = false },
            ["mg"] = { "order_by_git_status", nowait = false },
            ["md"] = { "order_by_diagnostics", nowait = false },
            ["mm"] = { "order_by_modified", nowait = false },
            ["mn"] = { "order_by_name", nowait = false },
            ["ms"] = { "order_by_size", nowait = false },
            ["mt"] = { "order_by_type", nowait = false },

            [","] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },

            ["g?"] = "show_help",
          },
        },
      }
    end,
    config = function(_, opts)
      local function on_move(data)
        ---@diagnostic disable-next-line: undefined-global
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
          RUtils.layout.open_outline_safely("aerial", function()
            vim.cmd.AerialToggle()
          end, true)
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
                    end

                    -- Force it to reload
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
      RUtils.map.disable_ctrl_i_and_o("NoAerial", { "aerial" })

      local vim_width = vim.o.columns
      vim_width = math.floor(vim_width / 2 - 45)

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
    -- "MadKuntilanak/outline.nvim",
    dir = "~/.local/src/nvim_plugins/outline.nvim",
    keys = {
      {
        "<Leader>oa",
        function()
          RUtils.layout.open_outline_safely("Outline", function()
            vim.cmd.Outline()
          end)
        end,
        desc = "Open: outline window [outline]",
      },
      {
        "<a-n>",
        function()
          RUtils.map.feedkey "<Down>"
        end,
        ft = "Outline",
        desc = "Open: go next [outline]",
      },
      {
        "<a-p>",
        function()
          RUtils.map.feedkey "<Up>"
        end,
        ft = "Outline",
        desc = "Open: go down [outline]",
      },
    },
    opts = function()
      -- RUtils.map.disable_ctrl_i_and_o("NoOutline", { "Outline" })
      local kind = RUtils.config.icons.kinds

      vim.api.nvim_create_user_command("OutlineToggleFollow", function()
        local cfg = require "outline.config"
        local o = cfg.o

        if _outline_follow_state == nil then
          -- Save state dan disable
          _outline_follow_state = {
            highlight_hovered_item = o.outline_items.highlight_hovered_item,
            auto_set_cursor = o.outline_items.auto_set_cursor,
            auto_unfold_hovered = o.symbol_folding.auto_unfold.hovered,
            auto_unfold_hover = o.symbol_folding.auto_unfold_hover,
          }
          o.outline_items.highlight_hovered_item = false
          o.outline_items.auto_set_cursor = false
          o.symbol_folding.auto_unfold.hovered = false
          o.symbol_folding.auto_unfold_hover = false
          ---@diagnostic disable-next-line: undefined-field
          RUtils.info "Outline: follow disabled"
        else
          -- Restore state
          o.outline_items.highlight_hovered_item = _outline_follow_state.highlight_hovered_item
          o.outline_items.auto_set_cursor = _outline_follow_state.auto_set_cursor
          o.symbol_folding.auto_unfold.hovered = _outline_follow_state.auto_unfold_hovered
          o.symbol_folding.auto_unfold_hover = _outline_follow_state.auto_unfold_hover
          _outline_follow_state = nil
          ---@diagnostic disable-next-line: undefined-field
          RUtils.info "Outline: follow enabled"
        end
      end, {})
      return {
        outline_window = {
          position = "left",
          winhl = "Normal:Normal,EndOfBuffer:None,NonText:Normal,CursorLine:FloatCursorline",
          focus_on_open = false,
          show_cursorline = true,
          hide_cursor = false,
          width = 20,
        },
        frozen_indicator = {
          -- icon = "🔒",
          row_offset = 1,
          winhl = "Normal:PanelBottomNormal,FloatBorder:PanelBottomNormal",
        },
        symbols = {
          filter = nil,
          icons = {
            File = { icon = kind.File, hl = "LspKindFile" },
            Module = { icon = kind.Module, hl = "LspKindModule" },
            Namespace = { icon = kind.Namespace, hl = "LspKindNamespace" },
            Package = { icon = kind.Package, hl = "LspKindPackage" },
            Class = { icon = kind.Class, hl = "Type" }, -- INI BELUM!
            Method = { icon = kind.Method, hl = "LspKindMethod" },
            Property = { icon = kind.Property, hl = "LspKindProperty" },
            Field = { icon = kind.Field, hl = "LspKindField" },
            Constructor = { icon = kind.Constructor, hl = "LspKindConstructor" },
            Enum = { icon = kind.Enum, hl = "LspKindEnum" },
            Interface = { icon = kind.Interface, hl = "LspKindInterface" },
            Function = { icon = kind.Function, hl = "LspKindFunction" },
            Variable = { icon = kind.Variable, hl = "LspKindVariable" },
            Constant = { icon = kind.Constant, hl = "LspKindConstant" },
            String = { icon = kind.String, hl = "LspKindString" },
            Number = { icon = kind.number, hl = "LspKindNumber" },
            Boolean = { icon = kind.Boolean, hl = "LspKindBoolean" },
            Array = { icon = kind.Array, hl = "LspKindObject" },
            Object = { icon = kind.Object, hl = "LspKindObject" },
            Key = { icon = kind.Key, hl = "LspKindKey" },
            Null = { icon = kind.Null, hl = "LspKindNull" },
            EnumMember = { icon = kind.EnumNumber, hl = "LspKindEnumMember" },
            Struct = { icon = kind.Struct, hl = "LspKindStruct" },
            Event = { icon = kind.Event, hl = "LspKindEvent" },
            Operator = { icon = kind.Operator, hl = "LspKindOperator" },
            TypeParameter = { icon = kind.TypeParameter, hl = "LspKindTypeParameter" },
            Component = { icon = kind.Component, hl = "Function" }, -- INI BELUM
            Fragment = { icon = "󰅴", hl = "Constant" }, -- INI BELUM

            TypeAlias = { icon = kind.TypeAlias, hl = "Type" },
            Parameter = { icon = kind.Parameter, hl = "Identifier" },
            StaticMethod = { icon = kind.StaticMethod, hl = "Function" },
            Macro = { icon = kind.Macro, hl = "Function" },
          },
        },
        preview_window = {
          live = true,
          auto_preview = false,
          winhl = "NormalFloat:NormalFloat",
        },
        picker = "fzf-lua", -- fzf-lua, telescope
        -- These keymaps can be a string or a table for multiple keys.
        -- Set to `{}` to disable. (Using 'nil' will fallback to default keys)
        keymaps = {
          show_help = "g?",
          close = { "q", "<Leader><Tab>" },
          goto_location = { "<CR>", "o" },
          peek_location = {},
          goto_and_close = {},
          restore_location = "~",
          hover_symbol = {},
          toggle_preview = { "P" },
          rename_symbol = {},
          code_actions = {},
          unfold = "zo",
          fold_toggle = { "<S-tab>", "<Tab>", "za" },
          fold = "zc",
          fold_all = "zM",
          unfold_all = { "zO", "zR" },
          fold_reset = "<space><space>",

          down_and_jump = { "<c-n>" },
          up_and_jump = { "<c-p>" },

          -- filter_symbols = "<space><space>",
        },
      }
    end,
  },
}
