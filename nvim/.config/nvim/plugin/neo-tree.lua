local add = require("vim-pack").add

local ConfigPath = require("config").path
local UtilKey = require "utils.map"
local UtilFilexplorer = require "utils.fileexplorer-bookmark"

local Log = require "utils.log"
local toggle_state = false

add {
  { src = "nvim-lua/plenary.nvim", setup = false },
  { src = "MadKuntilanak/nui.nvim", setup = false },
  { src = "nvim-tree/nvim-web-devicons", setup = false },
  {
    src = "nvim-neo-tree/neo-tree.nvim",
    version = vim.version.range "3",
    lazy = true,
    opts = function()
      UtilKey.disable_ctrl_i_and_o("NoOutline", { "Outline" })

      local Preview = require "neo-tree.sources.common.preview"

      local H = require "utils.highlights"
      H.plugin("NeoTreeHi", {
        theme = {
          ["*"] = {
            { NeoTreeDirectoryName = { inherit = "Directory" } },
            { NeoTreeNormal = { inherit = "PanelSideBackground" } },
            { NeoTreeNormalNC = { inherit = "PanelSideBackground" } },
            { NeoTreeCursorLine = { inherit = "HoveredCursorline" } },
            { NeoTreeRootName = { inherit = "PanelSideRootName" } },
            { NeoTreeStatusLine = { inherit = "PanelSideStusLine" } },
            { NeoTreeWinSeparator = { inherit = "PanelSideWinSeparator" } },
            { NeoTreeDimText = { bg = "None" } },
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
                bg = { from = "Comment", attr = "fg", alter = -0.1 },
                bold = true,
              },
            },

            { NeoTreeIndentMarker = { fg = { from = "OutlineGuides", attr = "fg" }, bold = false } },
            { NeoTreeTabSeparatorActive = { inherit = "PanelSideNormal", fg = { from = "Comment" } } },

            { NeoTreeGitAdded = { inherit = "GitSignsAdd" } },
            { NeoTreeGitModified = { inherit = "GitSignsChange" } },
            {
              NeoTreeTabSeparatorInactive = {
                inherit = "NeoTreeTabInactive",
                fg = { from = "PanelSideDarkBackground", attr = "bg" },
              },
            },

            {
              NeoTreeFloatNormal = {
                inherit = "NormalFloat",
                bg = { from = "Comment", attr = "fg", alter = -0.6 },
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
                fg = { from = "Comment", attr = "fg", alter = 2 },
                bg = { from = "NeoTreeFloatNormal", attr = "bg" },
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
        buffers = {
          leave_dirs_open = true,
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
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
              ["<C-n>"] = "next_git_modified",
              ["<C-p>"] = "prev_git_modified",
            },
            fuzzy_finder_mappings = {
              ["<a-n>"] = "move_cursor_down",
              ["<a-p>"] = "move_cursor_up",
            },
          },
        },

        default_component_configs = {
          indent = {
            indent_size = 2.5,
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
            local dropbox_path = ConfigPath.dropbox_path
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
              actions = {
                ["default"] = {
                  fn = function(e)
                    vim.cmd.cd(e[1])
                  end,
                },
              },
            })
          end,

          bookmark_cycle_save = function(state)
            UtilFilexplorer.ensure_files()

            local cwd = state.path
            local list = UtilFilexplorer.read_bookmarks()

            for _, v in ipairs(list) do
              local normalize_path_v = UtilFilexplorer.normalize_path(v)
              local normalize_path_cwd = UtilFilexplorer.normalize_path(cwd)
              if normalize_path_v == normalize_path_cwd then
                Log.warn(string.format("Already bookmarked:\n%s", normalize_path_cwd))
                return
              end
            end

            local normalize_cwd = UtilFilexplorer.normalize_path(cwd)
            table.insert(list, normalize_cwd)
            UtilFilexplorer.write_bookmarks(list)
            Log.warn(string.format("Bookmark saved (%d total):\n%s", #list, normalize_cwd))
          end,

          bookmark_cycle_pick = function()
            UtilFilexplorer.ensure_files()
            local list_bookmarks = UtilFilexplorer.read_bookmarks()
            local opts = {
              actions = {
                ["default"] = {
                  fn = function(selection)
                    if not selection then
                      return
                    end
                    UtilFilexplorer.jump_to(selection[1])
                  end,
                },
                ["ctrl-x"] = {
                  fn = function(selection, opts)
                    if not selection then
                      return
                    end
                    list_bookmarks = UtilFilexplorer.read_bookmarks()

                    local newlist = {}
                    for _, list in pairs(list_bookmarks) do
                      if list ~= selection[1] then
                        table.insert(newlist, list)
                      end
                    end

                    UtilFilexplorer.write_bookmarks(newlist)
                    Log.info("delete `" .. selection[1] .. "`, reload this pick")

                    require("fzf-lua").resume(opts)
                  end,
                  noclose = true,
                  desc = "del-item-bookmark",
                  header = "del-item-bookmark",
                },
              },
            }
            require("fzf-lua").fzf_exec(list_bookmarks, opts)
          end,

          bookmark_cycle_cycle = function()
            UtilFilexplorer.ensure_files()
            local list = UtilFilexplorer.read_bookmarks()

            if #list == 0 then
              Log.warn "No bookmarks yet. Use save to add one."
              return
            end

            local idx = UtilFilexplorer.read_index()
            idx = (idx % #list) + 1 -- next, wrap around
            UtilFilexplorer.write_index(idx)

            local target = list[idx]
            local basename_target = UtilFilexplorer.normalize_path(target)

            Log.info(string.format("[%d/%d] %s", idx, #list, basename_target))
            UtilFilexplorer.jump_to(target)
          end,

          open_cwd_in_terminal = function(state)
            local node = state.tree:get_node()
            require("utils.terminal").open_terminal_in_filetree(node.path)
          end,

          toggle_previewer_user = function(state)
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
                  require("fzf-lua").live_grep {
                    actions = {
                      ["default"] = {
                        fn = function(e)
                          if not e or #e == 0 then
                            return
                          end

                          local sel = require("utils.cmd").__strip_str(e[1])
                          if not sel then
                            return
                          end

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
                        end,
                      },
                    },
                  }
                end)
              end

              if choice == cmds[2] then
                vim.cmd "wincmd l"
                require("fzf-lua").files {
                  actions = {
                    ["default"] = {
                      fn = function(e)
                        if not e or #e == 0 then
                          return
                        end
                        local sel = require("utils.cmd").__strip_str(e[1])
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
            ["oc"] = "noop",
            ["od"] = "noop",
            ["og"] = "noop",
            ["om"] = "noop",
            ["on"] = "noop",
            ["os"] = "noop",
            ["ot"] = "noop",
            ["f"] = "noop",
            ["/"] = "noop",

            ["<C-a>cc"] = { "order_by_created", nowait = false },
            ["<C-a>cd"] = { "order_by_diagnostics", nowait = false },
            ["<C-a>cg"] = { "order_by_git_status", nowait = false },
            ["<C-a>cm"] = { "order_by_modified", nowait = false },
            ["<C-a>cn"] = { "order_by_name", nowait = false },
            ["<C-a>cs"] = { "order_by_size", nowait = false },
            ["<C-a>ct"] = { "order_by_type", nowait = false },

            ["<C-a>fd"] = "fuzzy_finder_directory",
            ["<C-a>fg"] = "fuzzy_finder",
            ["<C-a>fs"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
            ["<C-a>ff"] = "filter_on_submit",
            ["<C-a>fc"] = "clear_filter",
            ["<C-a>fx"] = "clear_filter",

            ["<a-b>"] = "bookmark_cycle_pick",
            ["b"] = "bookmark_cycle_save",
            ["B"] = "bookmark_cycle_cycle",

            ["<a-o>"] = "fzmark",
            ["K"] = "show_file_details",

            ["P"] = {
              "toggle_previewer_user",
              config = { use_float = true, use_image_nvim = true },
            },

            ["<Leader>os"] = "open_split",
            ["<Leader>ov"] = "open_vsplit",

            ["<a-T>"] = "open_cwd_in_terminal",

            ["<S-Tab>"] = "invert_selection",
            ["<C-c>"] = "clear_selection",
            ["<Tab>"] = "select",

            ["zM"] = "close_all_nodes",
            ["zc"] = "close_node",
            ["zR"] = "expand_all_subnodes",
            ["zO"] = "expand_all_nodes",
            ["o"] = "open",

            ["th"] = "prev_source",
            ["tl"] = "next_source",

            ["mc"] = { "order_by_created", nowait = false },
            ["mg"] = { "order_by_git_status", nowait = false },
            ["md"] = { "order_by_diagnostics", nowait = false },
            ["mm"] = { "order_by_modified", nowait = false },
            ["mn"] = { "order_by_name", nowait = false },
            ["ms"] = { "order_by_size", nowait = false },
            ["mt"] = { "order_by_type", nowait = false },

            ["g?"] = "show_help",
          },
        },
      }
    end,
  },
}

local load_neotree = function()
  require("vim-pack").load_now "neo-tree.nvim"
end

UtilKey.nnoremap("<a-e>", function()
  load_neotree()
  require("utils.layout").toggle_sidebar("neo-tree", function()
    vim.cmd "Neotree toggle"
  end)
end, { desc = "Open: file explore [neotree]" })
