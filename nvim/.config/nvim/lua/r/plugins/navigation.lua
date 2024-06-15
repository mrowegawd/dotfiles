local Highlight = require "r.settings.highlights"

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local lazyterm = function()
  RUtils.terminal { cwd = RUtils.root() }
end

local toggle_state = false

return {
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = vim.g.neovide ~= nil or not vim.env.TMUX,
    cmd = "Neotree",
    dependencies = {
      "3rd/image.nvim",
      "MunifTanjim/nui.nvim",
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

      local Preview = require "neo-tree.sources.common.preview"
      -- local events = require "neo-tree.events"
      local log = require "neo-tree.log"

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

          fzmark = function()
            local contents = require("project_nvim").get_recent_projects()
            local reverse = {}
            for i = #contents, 1, -1 do
              reverse[#reverse + 1] = contents[i]
            end

            if #reverse == 0 then
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
            end

            return fzf_lua.fzf_exec(reverse, {
              prompt = "   ",
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
              state.commands.open(state)
            end
          end,

          open_lazygit = function()
            RUtils.lazygit.open { ctrl_hjkl = true }
          end,

          open_lazydocker = function()
            RUtils.lazydocker.open { ctrl_hjkl = true }
          end,

          open_terminal = function()
            lazyterm()
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
              ["<a-g>"] = "fzmark",
              ["<a-t>"] = "open_terminal",
              ["<a-G>"] = "open_lazygit",
              ["<a-D>"] = "open_lazydocker",
              ["<Leader>gha"] = "git_add_file",
              ["<Leader>ghA"] = "git_add_all",
              ["<Leader>ghu"] = "git_unstage_file",
              ["<Leader>ghr"] = "git_revert_file",
              ["<Leader>gc"] = "git_commit",
              ["gp"] = "noop",
              ["w"] = "noop",
              ["gn"] = "noop",
              ["gg"] = "noop",
              ["i"] = "show_file_details",
              -- ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
              ["o"] = "child_or_open",
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
            ["<a-g>"] = "fzmark",
            ["<a-t>"] = "open_terminal",
            ["<a-G>"] = "open_lazygit",
            ["<a-D>"] = "open_lazydocker",
            ["<2-LeftMouse>"] = "open",
            ["<a-q>"] = "open_search_cd_and_grep",
            ["l"] = "child_or_open",
            ["h"] = "parent_or_close",
            ["<a-p>"] = {
              "toggle_open_preview",
              config = { use_float = true, use_image_nvim = true },
            },
            ["o"] = "child_or_open",
            ["s"] = "",
            ["t"] = "", -- disabled open tab
            ["P"] = "",
            ["z"] = "",
            ["<c-s>"] = "open_split",
            ["<c-v>"] = "open_vsplit",
            ["<c-t>"] = "open_tabnew",
            ["<esc>"] = "revert_preview",
            ["m"] = "",
            ["w"] = "noop",
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
        { NeoTreeWinSeparator = { link = "WinSeparator" } },
        { NeoTreeTabActive = { bg = { from = "PanelBackground" }, bold = true } },
        { NeoTreeIndentMarker = { fg = { from = "ColorColumn", attr = "bg", alter = 0.2 }, bold = false } },
        { NeoTreeTabInactive = { bg = { from = "PanelDarkBackground", alter = 0.15 }, fg = { from = "Comment" } } },
        { NeoTreeTabSeparatorActive = { inherit = "PanelBackground", fg = { from = "Comment" } } },

        { NeoTreeGitAdded = { link = "GitSignsAdd" } },
        { NeoTreeGitModified = { link = "GitSignsChange" } },
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
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      RUtils.disable_ctrl_i_and_o("NoAerial", { "aerial" })
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
    event = "VeryLazy",
    keys = function()
      local height = vim.o.lines - vim.o.cmdheight
      if vim.o.laststatus ~= 0 then
        height = height - 1
      end

      local function get_aerial()
        local ok_aerial, aerial = pcall(require, "aerial")
        return ok_aerial and aerial or {}
      end

      return {
        {
          "<a-e>",
          function()
            vim.cmd "Neotree toggle"
          end,
          desc = "Misc: open file explore [neotree]",
        },
        -- { TODO: ini error, cause flickring window
        --   "<leader>ue",
        --   function()
        --     require("edgy").toggle()
        --   end,
        --   desc = "Misc: toggle edgy [edgy]",
        -- },
        {
          "<leader>ge",
          function()
            if RUtils.has "neo-tree.nvim" then
              return vim.cmd "Neotree git_status"
            else
              return require("fzf-lua").git_status()
            end
          end,
          desc = "Git: explore git status (callback fzflua) [neotree]",
        },
        {
          "<Localleader>oo",
          function()
            local right_win = "aerial"
            if vim.bo.filetype ~= right_win then
              local outline_win = RUtils.cmd.windows_is_opened { right_win }
              if outline_win.found then
                vim.api.nvim_set_current_win(outline_win.winid)
              end
            elseif vim.bo.filetype == right_win then
              vim.cmd [[wincmd p]]
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

            local opts = {
              title = "[Aerial]",
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
                end,
              },
            }
            RUtils.fzflua.cmd_filter_kind_lsp(opts)
          end,
          desc = "Misc: change filter kind aerial [aerial]",
        },
      }
    end,
    opts = function()
      Highlight.plugin("NeoEdgyHi", {
        -- { WinBar = { bg = RUtils.colortbl.statusline_bg } },
        -- { WinBarNC = { bg = RUtils.colortbl.statusline_bg } },

        { WinBar = { bg = { from = "StatusLine", attr = "bg", alter = -0.1 } } },
        { WinBarNC = { bg = { from = "StatusLine", attr = "bg", alter = -0.1 } } },
        -- { WinBarNC = { bg = RUtils.colortbl.statusline_bg } },

        { EdgyNormal = { bg = "NONE" } },
        {
          EdgyTitle = {
            fg = { from = "Directory", attr = "fg" },
            bold = true,
            bg = { from = "StatusLine", attr = "bg", alter = -0.1 },
          },
        },
        {
          EdgyIcon = {
            bold = true,
            bg = { from = "StatusLine", attr = "bg", alter = -0.1 },
            fg = RUtils.colortbl.statuslinenc_fg,
          },
        },
        { EdgyIconActive = { bold = true, bg = { from = "StatusLine", attr = "bg", alter = -0.1 } } },
        -- { AerialLine = { bg = { from = "MyQuickFixLine", attr = "bg" }, sp = "NONE" } },
      })

      local opts = {
        animate = { enabled = false },
        options = {
          right = { size = 40 },
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
          {
            ft = "noice",
            size = { height = 0.4 },
            ---@diagnostic disable-next-line: unused-local
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          -- {
          --   ft = "lazyterm",
          --   title = "LazyTerm",
          --   size = { height = 0.4 },
          --   filter = function(buf)
          --     return not vim.b[buf].lazyterm_cmd
          --   end,
          -- },
          "Trouble",
          { ft = "qf", title = "QuickFix" },
          {
            ft = "help",
            size = { height = 20 },
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          -- { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
          -- { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
        },
        right = {
          "Trouble",
          {
            ft = "aerial",
            pinned = true,
            open = "Outline",
            title = "Aerial",
          },
        },
        left = {
          -- { title = "Neotest Summary", ft = "neotest-summary" },
          {
            title = "Explorer",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "filesystem"
            end,
            -- pinned = true,
            open = function()
              vim.api.nvim_input "<esc><space>e"
            end,
            size = { height = 0.6 },
          },
          {
            title = "Git Status",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "git_status"
            end,
            -- pinned = true,
            -- open = "Neotree position=right git_status",
          },
          -- {
          --   title = "Neo-Tree Other",
          --   ft = "neo-tree",
          --   filter = function(buf)
          --     return vim.b[buf].neo_tree_source ~= nil
          --   end,
          -- },
        },
        keys = {
          ["<a-H>"] = function(win)
            win:resize("width", 5)
          end,
          ["<a-L>"] = function(win)
            win:resize("width", -5)
          end,
          ["<a-K>"] = function(win)
            win:resize("height", 5)
          end,
          ["<a-J>"] = function(win)
            win:resize("height", -5)
          end,
        },
      }

      -- -- only add neo-tree sources if they are enabled in config
      -- local neotree_opts = RUtils.opts "neo-tree.nvim"
      -- local neotree_sources = { buffers = "top", git_status = "right" }
      --
      -- for source, pos in pairs(neotree_sources) do
      --   if vim.list_contains(neotree_opts.sources, source) then
      --     table.insert(opts.left, 3, {
      --       title = "Neo-Tree " .. source:gsub("_", " "),
      --       ft = "neo-tree",
      --       filter = function(buf)
      --         return vim.b[buf].neo_tree_source == source
      --       end,
      --       pinned = true,
      --       open = "Neotree position=" .. pos .. " " .. source,
      --     })
      --   end
      -- end

      for _, pos in ipairs { "top", "bottom", "left", "right" } do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = "trouble",
          ---@diagnostic disable-next-line: unused-local
          filter = function(_buf, win)
            return vim.w[win].trouble
              and vim.w[win].trouble.position == pos
              and vim.w[win].trouble.type == "split"
              and vim.w[win].trouble.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        })
      end
      return opts
    end,
  },

  -- Fix bufferline offsets when edgy is loaded
  -- {
  --   "akinsho/bufferline.nvim",
  --   optional = true,
  --   opts = function()
  --     local Offset = require "bufferline.offset"
  --     if not Offset.edgy then
  --       local get = Offset.get
  --       Offset.get = function()
  --         if package.loaded.edgy then
  --           local layout = require("edgy.config").layout
  --           local ret = { left = "", left_size = 0, right = "", right_size = 0 }
  --           for _, pos in ipairs { "left", "right" } do
  --             local sb = layout[pos]
  --             if sb and #sb.wins > 0 then
  --               local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
  --               ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
  --               ret[pos .. "_size"] = sb.bounds.width
  --             end
  --           end
  --           ret.total_size = ret.left_size + ret.right_size
  --           if ret.total_size > 0 then
  --             return ret
  --           end
  --         end
  --         return get()
  --       end
  --       Offset.edgy = true
  --     end
  --   end,
  -- },
}
