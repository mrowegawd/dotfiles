local uncolor_themes = { "zenburn" }
local match_color = "yellow"
if vim.tbl_contains(uncolor_themes, vim.g.colorscheme) then
  match_color = "214"
end

local rg_opts = "--column "
  .. "--hidden "
  .. "--line-number "
  .. "--no-heading "
  .. "--ignore-case "
  .. "--smart-case "
  .. "--color=always "
  .. "--max-columns=4096 "
  .. "--colors 'match:fg:"
  .. match_color
  .. "' "
  .. "-e "

local fd_opts = "--color never "
  .. "--type f "
  .. "--hidden "
  .. "--follow "
  .. "--exclude .git --exclude '*.pyc' --exclude '*.pytest_cache'"

return {
  -- FZF-LUA
  {
    "ibhagwan/fzf-lua",
    version = false,
    cmd = "FzfLua",
    dependencies = {
      "tpope/vim-fugitive",
    },
    --stylua: ignore
    keys = {
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
      { "<c-h>", "<Left>", ft = "fzf", mode = "t", nowait = true },
      { "<c-c>", "<esc>", ft = "fzf", mode = "t", nowait = true },

      { "tf", function() require("fzf-lua").tabs() end, desc = "Tab: select tabs [fzflua]" },

      { "<Leader><Leader>", function() require("fzf-lua").files() end, desc = "Picker: find files [fzflua]", mode = { "n", "x" } },
      { "<Leader>fh", function() require("fzf-lua").command_history() end, desc = "Picker: history commands [fzflua]" },
      { "<Leader>fH", function() require("fzf-lua").search_history() end, desc = "Picker: search history [fzflua]" },
      { "<Leader>fc", function() require("fzf-lua").commands() end, desc = "Picker: commands [fzflua]" },
      { "<Leader>fA", function() require("fzf-lua").autocmds() end, desc = "Picker: automcds [fzflua]" },
      { "<Leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Picker: recent files (history buffer) [fzflua]" },
      { "<Leader>fl", function() require("fzf-lua").resume() end, desc = "Picker: resume (last search) [fzfua]" },

      { "<Leader>hm", function() require("fzf-lua").man_pages() end, desc = "Help: man pages [fzflua]" },
      { "<Leader>hB", function() require("fzf-lua").keymaps() end, desc = "Help: show global keymaps [fzflua]" },
      {
        "<Leader>fz",
        function()
          require("fzf-lua").files( RUtils.fzflua.open_dock_bottom ({
            winopts = { title = RUtils.fzflua.format_title("Main Themes", "󰈙"), preview = { hidden = true } },
            no_header = false, -- disable default header
            cwd = "~/.config/miscxrdb/xresource-theme",
            actions = {
              ["default"] = function(selected)
                local colorscheme = selected[1]
                local script_path = vim.fn.expand "$HOME" .. "/.config/rofi/menu/_themes setup " .. colorscheme
                vim.cmd [[ChangeMasterTheme]]
                vim.cmd([[!bash ]] .. script_path)
              end,
            },
          }))
        end,
        desc = "Picker: select colorschemes [fzflua]",
      },

      { "<Leader>hh", function() require("fzf-lua").help_tags() end, desc = "Help: nvim [fzflua]" },
      {
        "<Leader>hh",
        function()
          local sel = RUtils.get_visual_selection { strict = true }
          if sel then
            local selection = RUtils.strip_whitespaces(sel.selection)
            local _, err = pcall(function()
              vim.cmd("h " .. selection)
            end)

            if err then
              ---@diagnostic disable-next-line: undefined-field
              RUtils.warn(selection .. " -> Not found ", { title = "FzfLua Help" })
            end
          end
        end,
        mode = { "x" },
        desc = "Help: nvim (visual) [fzflua]",
      },
      {
        "<Leader>fo",
        function()
          return require("fzf-lua").files {
            winopts = { title = RUtils.fzflua.format_title("Dotfiles", "󰈙") },
            cwd = "~/moxconf/development/dotfiles",
          }
        end,
        desc = "Picker: dotfiles [fzflua]",
      },
      {
        "<Leader>fF",
        function()
          return require("fzf-lua").files {
            winopts = { title = RUtils.fzflua.format_title("Plugin Files", "󰈙") },
            cwd = vim.fn.stdpath "data" .. "/lazy",
          }
        end,
        desc = "Picker: plugin files [fzflua]",
      },

      -- Search
      { "<Leader>sB", function() require("fzf-lua").lines() end, desc = "Search: all buffers [fzflua]", mode = { "n", "x" } },
      { "<Leader>sb", function() require("fzf-lua").blines() end, desc = "Search: buffers [fzflua]" },
      {
        "<Leader>sb",
        function()
          local visual_selection = RUtils.get_visual_selection { strict = true }
          RUtils.map.feedkey("<Esc>" )
          vim.schedule(function()
            if not visual_selection or not visual_selection.selection or visual_selection.selection == "" then
              ---@diagnostic disable-next-line: undefined-field
              RUtils.warn("cannot execute: an error occurred..?", { title = "Fzflua Blines" })
              return
            end
            require("fzf-lua").blines {
              query = visual_selection.selection,
            }
          end)
        end,
        desc = "Search: buffers (visual) [fzflua]",
        mode = { "x" },
      },

      { "<Leader>sm", function() require("fzf-lua").marks() end, desc = "Search: marks [fzflua]" },
      { "<Leader>sj", function() require("fzf-lua").jumps() end, desc = "Search: jumps [fzflua]" },

      { "z=", function() require("fzf-lua").spell_suggest() end, desc = "Picker: spell suggest [fzflua]" },

      -- Diagnostics
      { "df", "<CMD>FzfLua diagnostics_document<CR>", desc = "Diagnostic: document [fzflua]" },

      -- Grep
      { "<Leader>fg", function() require("fzf-lua").live_grep_glob() end, desc = "Picker: live grep [fzflua]" },
      { "<Leader>fG", function() require("fzf-lua").grep() end, desc = "Picker: grep [fzflua]" },
      { "<Leader>fg", function() require("fzf-lua").grep_visual() end, desc = "Picker: live grep (visual) [fzflua]", mode = { "x" } },
      {
        "<Leader>fw",
        function()
          local fzf_cword = require("fzf-lua.utils").rg_escape(vim.fn.expand "<cword>")
          require("fzf-lua").grep_cword { winopts = { title = string.format("Grep cword >> %s", fzf_cword) } }
        end,
        desc = "Picker: grep word [fzflua]",
      },
      {
        "<Leader>fw",
        function()
          local fzf_visual = require("fzf-lua.utils").get_visual_selection()
          require("fzf-lua").grep_visual { winopts = { title = string.format("Grep word visual >> %s", fzf_visual) } }
        end,
        desc = "Picker: grep word visual [fzflua]",
        mode = { "x" },
      },

      -- Git
      { "<c-c>gs", function() require("fzf-lua").git_status() end, desc = "Git: status [fzflua]" },
      { "<c-c>gS", function() require("fzf-lua").git_stash() end, desc = "Git: stash [fzflua]" },

      { "<c-c>gd", "<CMD>DFile<CR>", desc = "Git: diff [fzflua]" },

      { "<c-c>gl", function() require("fzf-lua").git_bcommits() end, desc = "Git: commit buffer [fzflua]" },
      { "<c-c>gL", function() require("fzf-lua").git_commits() end, desc = "Git: commit repo [fzflua]" },

      { "<c-c>gD", function() RUtils.git.trace_file_event() end, desc = "Git: track commit for renamed or file deleted [fzflua]" },
      { "<c-c>gf", function() RUtils.git.select_file_different_branch() end, desc = "Git: find files branch [fzflua]" },

      { "<Leader>fs", "<CMD>FzfLua lsp_document_symbols<CR>", desc = "Picker: symbols [fzflua]" },
      { "<Leader>fS", "<CMD>FzfLua lsp_workspace_symbols<CR>", desc = "Picker: workspaces symbols [fzflua]" },
    },
    opts = function()
      local actions = require "fzf-lua.actions"
      local extend_title = RUtils.fzflua.extend_title_fzf { cwd = "" }

      ---@diagnostic disable: missing-fields
      ---@type fzf-lua.config.Base
      return {
        __HLS = {
          cursor = "CurSearch",
        },
        -- fzf_colors = {
        --   ["fg"] = { "fg", "FzfLuaFilePart" },
        --   ["bg"] = { "bg", "FzfLuaNormal" },
        --   ["hl"] = { "fg", "FzfLuaFzfMatchFuzzy" },
        --   ["fg+"] = { "fg", "FzfLuaSel" },
        --   ["bg+"] = { "bg", "FzfLuaSel" },
        --   ["hl+"] = { "fg", "FzfLuaFzfMatch" },
        --   ["info"] = { "fg", "FzfLuaHeaderText" },
        --   ["prompt"] = { "fg", "Conditional" },
        --   ["pointer"] = { "fg", "Keyword" },
        --   ["marker"] = { "fg", "MarkerFzflua" },
        --   ["spinner"] = { "fg", "Label" },
        --   ["header"] = { "fg", "FzfLuaHeaderText" },
        --   ["gutter"] = { "bg", "FzfLuaBorder" },
        --   ["border"] = { "fg", "FzfLuaBorder" },
        -- },
        previewers = {
          builtin = {
            snacks_image = { enabled = true },
            treesitter = { enabled = true, context = false }, -- disable treesitter-context
          },
        },
        keymap = {
          builtin = {
            ["<F1>"] = "toggle-help",
            ["<F3>"] = "toggle-fullscreen",
            ["<F4>"] = "toggle-preview-cw",

            ["<F5>"] = "toggle-preview",

            ["<PageDown>"] = "preview-page-down",
            ["<PageUp>"] = "preview-page-up",

            ["<c-u>"] = "preview-up",
            ["<c-d>"] = "preview-down",

            ["<c-Up>"] = "preview-up",
            ["<c-Down>"] = "preview-down",

            -- ["<Tab>"] = "toggle+down",
            -- ["<s-Tab>"] = "toggle+up",
          },
          fzf = {
            ["alt-a"] = "toggle-all",

            -- ["ctrl-d"] = "preview-page-down",
            -- ["ctrl-u"] = "preview-page-up",
          },
        },
        defaults = {
          cwd_prompt = false,
          no_header_i = true, -- hide interactive header?
          copen = RUtils.qf.copen,
          lopen = RUtils.qf.lopen,

          git_icons = false,
          file_icons = false,
        },
        winopts = {
          backdrop = 100,
        },
        fzf_opts = {
          ["--no-separator"] = "",
          ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-history",
        }, -- remove separator line
        files = RUtils.fzflua.open_dock_bottom {
          winopts = { title = RUtils.fzflua.format_title("Files", "") },
          -- check define header (cara lain): https://github.com/ibhagwan/fzf-lua/issues/1351
          fzf_opts = { ["--header"] = [[^r:grugfar  a-c:copypath  ^o:peek  ^x:selectcwd  ^z:hidden  ^q:ignore]] },
          line_query = true, -- now we can use "example_file:32"
          fd_opts = fd_opts,
          git_icons = false,
          -- formatter = "path.filename_first",
          actions = {
            ["default"] = function(selected, opts)
              local path = require "fzf-lua.path"
              local selected_item = selected[1]
              local status, entry = pcall(path.entry_to_file, selected_item, opts, opts.force_uri)

              if entry.path ~= nil then
                local file_or_dir = vim.uv.fs_stat(entry.path)

                if file_or_dir and status and file_or_dir.type == "file" then
                  require("fzf-lua").actions.file_edit(selected, opts)
                else
                  require("fzf-lua").live_grep {
                    fzf_opts = { ["--reverse"] = false },
                    cwd = entry.path,
                  }
                end
              end
            end,

            ["ctrl-z"] = actions.toggle_hidden,
            ["ctrl-q"] = actions.toggle_ignore,

            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-v"] = actions.file_sel_to_ll,
            ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },

            ["ctrl-x"] = function()
              require("fzf-lua").files {
                fd_opts = [[--color=never --type d --type l --exclude .git]],
                winopts = {
                  title = RUtils.fzflua.format_title(
                    "Select folder for files",
                    RUtils.strip_whitespaces(RUtils.config.icons.misc.telescope2)
                  ),
                },
                actions = {
                  ["default"] = function(selected)
                    local paths = {}
                    local path_str = ""
                    if #selected > 1 then
                      for _, sel in pairs(selected) do
                        if #sel > 0 then
                          table.insert(paths, sel)
                        end
                      end
                    else
                      path_str = selected[1]
                    end

                    local opts = {}

                    local title_path
                    if #paths > 1 then
                      title_path = "[ " .. table.concat(paths, ", ") .. " ]"
                      opts.cmd = "rg --hidden --files " .. table.concat(paths, " ")
                    else
                      opts.cwd = path_str
                      title_path = path_str
                    end

                    opts.winopts = {
                      title = RUtils.fzflua.format_title(
                        "Path: " .. title_path,
                        RUtils.strip_whitespaces(RUtils.config.icons.misc.telescope2)
                      ),
                    }

                    opts.rg_glob = false
                    opts.no_esc = true

                    return require("fzf-lua").files(opts)
                  end,
                },
              }
            end,

            ["ctrl-o"] = function(...)
              local P = require "overlook.peek"
              P.peek_fzflua(...)
            end,
            ["ctrl-r"] = function(selected)
              local paths = {}
              if #selected > 1 then
                for _, file in pairs(selected) do
                  if not RUtils.check_tbl_element(paths, file) then
                    paths[#paths + 1] = file
                  end
                end
              else
                table.insert(paths, selected[1])
              end

              local grug = require "grug-far"
              grug.open {
                prefills = {
                  search = "",
                  replacement = "",
                  filesFilter = "",
                  flags = "--hidden -i",
                  paths = table.concat(paths, "  "),
                },
              }
            end,
            ["alt-c"] = function(selected, _)
              local slice_num_str = selected[1]:match ".*\xe2\x80\x82()"
              local pth = selected[1]:sub(slice_num_str)
              vim.fn.setreg([[+]], pth)

              ---@diagnostic disable-next-line: undefined-field
              RUtils.info(pth .. " copied to clipboard", { title = "Path Copy" })

              require("fzf-lua").actions.resume()
            end,
          },
        },
        git = {
          files = {
            winopts = {
              title = RUtils.fzflua.format_title("Git Files", ""),
              title_pos = "left",
            },
            cmd = "git ls-files --exclude-standard",
            multiprocess = true, -- run command in a separate process
            git_icons = true, -- show git icons?
            file_icons = true, -- show file icons?
            color_icons = true, -- colorize file|git icons
          },
          status = RUtils.fzflua.open_dock_bottom {
            no_header_i = false,
            winopts = { title = RUtils.fzflua.format_title("Git Status", "") },
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            fzf_opts = { ["--multi"] = true },
            actions = {
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["alt-v"] = actions.file_sel_to_ll,
              ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },

              ["left"] = false,
              ["right"] = false,

              ["ctrl-s"] = { actions.git_stage_unstage, actions.resume },
              ["ctrl-x"] = { actions.git_reset, actions.resume },
            },
          },
          commits = RUtils.fzflua.git_open_fullscreen_vertical {
            no_header = true, -- disable default header
            -- preview = "git show --pretty='%Cred%H%n%Cblue%an <%ae>%n%C(yellow)%cD%n%Cgreen%s' --color {1}",
            -- cmd = "git log --color --pretty=format:'%C(blue)%h%Creset "
            --   .. "%Cred(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
            -- preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            winopts = { title = RUtils.fzflua.format_title("Commits", "") },
            fzf_opts = {
              ["--header"] = [[^g:grep  a-c:copyhash  ^b:browser  ^r:compare  ^q:checkall  ^o:diffviewopen  ^z:fugitive]],
              ["--no-multi"] = false,
            },
            actions = {
              ["default"] = actions.git_buf_edit,

              ["alt-q"] = RUtils.fzf_diffview.git_open_to_qf "Commits Hash",
              ["alt-Q"] = { prefix = "toggle-all", fn = RUtils.fzf_diffview.git_open_to_qf "Commits Hash All" },
              ["alt-v"] = RUtils.fzf_diffview.git_open_to_qf "Commits Hash",
              ["alt-V"] = { prefix = "toggle-all", fn = RUtils.fzf_diffview.git_open_to_qf "Commits Hash" },

              ["ctrl-r"] = RUtils.fzf_diffview.git_open_with_compare_hash(),
              ["ctrl-o"] = RUtils.fzf_diffview.git_open_with_diffview(),
              ["ctrl-z"] = RUtils.fzf_diffview.git_open_with_fugitive(),
              ["ctrl-q"] = RUtils.fzf_diffview.git_check_all_changed_by_commit(),

              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,

              ["ctrl-b"] = RUtils.fzf_diffview.git_open_with_browser(),
              ["ctrl-g"] = RUtils.fzf_diffview.git_grep_log(),

              ["alt-c"] = RUtils.fzf_diffview.git_copy_to_clipboard_or_yank(),
            },
          },
          bcommits = RUtils.fzflua.git_open_fullscreen_vertical {
            -- debug = true,
            no_header = true, -- disable default header
            -- preview = "git diff --color {1}~1 {1} -- <file>",
            -- preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            -- cmd = "git log --color --pretty=format:'%C(blue)%h%Creset "
            --   .. "%Cred(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset' {file}",
            winopts = { title = RUtils.fzflua.format_title("BCommits", "") },
            fzf_opts = {
              ["--header"] = [[^g:grep  a-c:copyhash  ^b:browser  ^r:compare  ^q:checkall  ^o:diffviewopen  ^z:fugitive]],
              ["--no-multi"] = false,
            },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["alt-v"] = RUtils.fzf_diffview.git_open_to_qf "BCommits Hash",
              ["alt-V"] = { prefix = "toggle-all", fn = RUtils.fzf_diffview.git_open_to_qf "BCommits Hash" },
              ["alt-q"] = RUtils.fzf_diffview.git_open_to_qf "BCommits Hash",
              ["alt-Q"] = { prefix = "toggle-all", fn = RUtils.fzf_diffview.git_open_to_qf "BCommits Hash All" },
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-t"] = actions.git_buf_tabedit,
              ["ctrl-v"] = actions.git_buf_vsplit,

              ["ctrl-r"] = RUtils.fzf_diffview.git_open_with_compare_hash(),
              ["ctrl-o"] = RUtils.fzf_diffview.git_open_with_diffview(),
              ["ctrl-z"] = RUtils.fzf_diffview.git_open_with_fugitive(),
              ["ctrl-q"] = RUtils.fzf_diffview.git_check_all_changed_by_commit(),

              ["ctrl-b"] = RUtils.fzf_diffview.git_open_with_browser(),
              ["ctrl-g"] = RUtils.fzf_diffview.git_grep_log(),

              ["alt-c"] = RUtils.fzf_diffview.git_copy_to_clipboard_or_yank(),
            },
          },
          branches = RUtils.fzflua.open_center_small_wide {
            cmd = "git branch --all --color",
            preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
            winopts = { title = RUtils.fzflua.format_title("Branches", "") },
            actions = {
              ["default"] = actions.git_switch,
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["alt-v"] = actions.file_sel_to_ll,
              ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },
            },
          },
          stash = RUtils.fzflua.open_dock_bottom {
            no_header_i = false,
            winopts = { title = RUtils.fzflua.format_title("Stash", "") },
          },
          icons = {
            ["M"] = { icon = "M", color = "yellow" },
            ["D"] = { icon = "D", color = "red" },
            ["A"] = { icon = "A", color = "green" },
            ["R"] = { icon = "R", color = "yellow" },
            ["C"] = { icon = "C", color = "yellow" },
            ["T"] = { icon = "T", color = "magenta" },
            ["?"] = { icon = "?", color = "magenta" },
            -- override git icons?
            -- ["M"]        = { icon = "★", color = "red" },
            -- ["D"]        = { icon = "✗", color = "red" },
            -- ["A"]        = { icon = "+", color = "green" },
          },
        },
        grep = RUtils.fzflua.open_center_big {
          -- debug = true,
          no_header = true, -- disable default header
          rg_opts = rg_opts,
          fzf_opts = { ["--header"] = [[^r:grugfar  ^g:lgrep  ^o:peek  ^x:selectcwd  ^z:hidden  ^q:ignore]] },
          -- NOTE: multiline requires fzf >= v0.53 and is ignored otherwise
          -- multiline = 1, -- Display as: PATH:LINE:COL\nTEXT
          -- multiline = 2, -- Display as: PATH:LINE:COL\nTEXT\n
          -- formatter = "path.filename_first",
          multiprocess = true,
          winopts = {
            title = RUtils.fzflua.format_title("Grep", RUtils.strip_whitespaces(RUtils.config.icons.misc.telescope2)),
          },
          actions = {
            ["ctrl-z"] = actions.toggle_hidden,
            ["ctrl-q"] = actions.toggle_ignore,

            ["alt-v"] = actions.file_sel_to_ll,
            ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },

            ["ctrl-x"] = function()
              require("fzf-lua").files {
                fd_opts = [[--color=never --type d --type l --exclude .git]],
                winopts = {
                  title = RUtils.fzflua.format_title(
                    "Select folder for grep",
                    RUtils.strip_whitespaces(RUtils.config.icons.misc.telescope2)
                  ),
                },
                actions = {
                  ["default"] = function(selected)
                    local paths = {}
                    local path_str = ""
                    if #selected > 1 then
                      for _, sel in pairs(selected) do
                        if #sel > 0 then
                          table.insert(paths, sel)
                        end
                      end
                    else
                      path_str = selected[1]
                    end

                    local opts = {}

                    local title_path
                    if #paths > 1 then
                      title_path = "[ " .. table.concat(paths, ", ") .. " ]"
                      opts.rg_opts = "--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 "
                        .. table.concat(paths, " ")
                        .. " -e "
                    else
                      opts.cwd = path_str
                      title_path = path_str
                    end

                    opts.winopts = {
                      title = RUtils.fzflua.format_title(
                        "Grep: " .. title_path,
                        RUtils.strip_whitespaces(RUtils.config.icons.misc.telescope2)
                      ),
                      width = 0.80,
                      height = 0.80,
                      row = 0.50,
                      col = 0.50,
                      preview = {
                        vertical = "down:55%", -- up|down:size
                        horizontal = "up:45%", -- right|left:size
                      },
                    }

                    opts.rg_glob = false
                    opts.no_esc = true

                    return require("fzf-lua").live_grep_glob(opts)
                  end,
                },
              }
            end,
            ["ctrl-o"] = function(...)
              local P = require "overlook.peek"
              P.peek_fzflua(...)
            end,
            ["ctrl-r"] = function(selected)
              local paths = {}
              if #selected > 1 then
                for _, file in pairs(selected) do
                  if not RUtils.check_tbl_element(paths, file) then
                    paths[#paths + 1] = file
                  end
                end
              else
                table.insert(paths, selected[1])
              end

              local grug = require "grug-far"
              grug.open {
                prefills = {
                  search = "",
                  replacement = "",
                  filesFilter = "",
                  flags = "--hidden -i",
                  paths = table.concat(paths, "  "),
                },
              }
            end,
          },
        },
        args = {
          prompt = RUtils.fzflua.padding_prompt(),
          files_only = true,
          actions = {
            ["ctrl-x"] = { actions.arg_del, actions.resume },
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-v"] = actions.file_sel_to_ll,
            ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },
          },
        },
        jumps = RUtils.fzflua.open_center_big_vertical {},
        marks = RUtils.fzflua.open_center_big_vertical {},
        builtin = RUtils.fzflua.open_dock_bottom {
          winopts = { title = RUtils.fzflua.format_title("Builtin", RUtils.config.icons.misc.tools) },
        },
        commands = RUtils.fzflua.open_dock_bottom {
          winopts = {
            title = RUtils.fzflua.format_title("Commands", RUtils.config.icons.misc.tools),
            preview = { hidden = true },
          },
        },
        command_history = RUtils.fzflua.open_dock_bottom {
          winopts = {
            title = RUtils.fzflua.format_title("History Commands", RUtils.config.icons.misc.tools),
            preview = { hidden = true },
          },
        },
        search_history = RUtils.fzflua.open_dock_bottom {
          winopts = {
            title = RUtils.fzflua.format_title("Search history", RUtils.config.icons.misc.indent),
            preview = { hidden = true },
          },
        },
        oldfiles = RUtils.fzflua.open_dock_bottom {
          winopts = { title = RUtils.fzflua.format_title("Recent Files", "") },
          fzf_opts = { ["--header"] = [[^o:oldfiles-all  ^r:oldfiles-current]] },
          cwd_only = true,
          stat_file = true, -- verify files exist on disk
          include_current_session = false, -- include bufs from current session
          actions = {
            ["ctrl-o"] = function()
              local opts = {
                cwd_only = false,
                winopts = {
                  title = RUtils.fzflua.format_title("Global Recent Files", "󰈙"),
                  preview = { hidden = false },
                },
              }
              require("fzf-lua").oldfiles(opts)
            end,
            ["ctrl-r"] = function()
              require("fzf-lua").oldfiles { cwd_only = true }
            end,
          },
        },
        buffers = RUtils.fzflua.open_center_medium {
          winopts = { title = RUtils.fzflua.format_title("Buffers", "󰈙") },
          cwd = nil, -- buffers list for a given dir
          actions = {
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-v"] = actions.file_sel_to_ll,
            ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },
            ["ctrl-o"] = function(...)
              local P = require "overlook.peek"
              P.peek_fzflua(...)
            end,
          },
        },
        highlights = {
          winopts = { title = RUtils.fzflua.format_title("Highlights", RUtils.config.icons.misc.circle) },
        },
        helptags = RUtils.fzflua.open_center_big_vertical {
          winopts = { title = RUtils.fzflua.format_title("Help", "󰋖") },
        },
        tabs = {
          tab_title = "Tab",
          tab_marker = "<<",
          file_icons = true, -- show file icons?
          color_icons = true, -- colorize file|git icons
          actions = {
            -- actions inherit from 'actions.buffers' and merge
            ["default"] = actions.buf_switch,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-v"] = actions.file_sel_to_ll,
            ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },
            ["ctrl-x"] = { actions.buf_del, actions.resume },
          },
          fzf_opts = {
            -- hide tabnr
            -- ["--delimiter"] = "'[\\):]'",
            ["--with-nth"] = "2..",
          },
        },
        lines = RUtils.fzflua.open_fullscreen_vertical {
          fzf_opts = {
            -- do not include bufnr in fuzzy matching
            -- tiebreak by line no.
            -- ["--delimiter"] = "'[\\]:]'",
            ["--nth"] = "2..",
            ["--tiebreak"] = "index",
            ["--tabstop"] = "1",
          },
          winopts = { title = RUtils.fzflua.format_title("Lines", "") },
          -- actions inherit from 'actions.buffers' and merge
          actions = {
            ["default"] = actions.buf_edit_or_qf,

            ["alt-q"] = actions.buf_sel_to_qf,
            ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-v"] = actions.file_sel_to_ll,
            ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },

            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
        },
        blines = RUtils.fzflua.open_fullscreen_vertical {
          no_header = true, -- hide grep|cwd header?
          winopts = { title = RUtils.fzflua.format_title("Blines", "") },
          fzf_opts = {
            -- Cara menghilangkan filepath
            -- https://github.com/ibhagwan/fzf-lua/issues/228#issuecomment-983262485
            -- ["--delimiter"] = "[:]",
            ["--with-nth"] = "3..",
            ["--tiebreak"] = "index",
            ["--tabstop"] = "1",
            -- ["--reverse"] = false,
            -- ["--layout"] = "default",
          },
          -- actions inherit from 'actions.buffers' and merge
          actions = {
            ["default"] = actions.buf_edit_or_qf,

            ["alt-q"] = actions.buf_sel_to_qf,
            ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-v"] = actions.buf_sel_to_ll,
            ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },

            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
        },
        keymaps = RUtils.fzflua.open_center_big {
          winopts = { title = RUtils.fzflua.format_title("Keymaps", " ") },
          show_details = false,
        },
        autocmds = RUtils.fzflua.open_center_big {
          winopts = { title = RUtils.fzflua.format_title("Autocmds", " ") },
        },
        tags = {
          ctags_file = nil, -- auto-detect from tags-option
          multiprocess = true,
          file_icons = true,
          git_icons = true,
          color_icons = true,
          -- 'tags_live_grep' options, `rg` prioritizes over `grep`
          rg_opts = "--no-heading --color=always --smart-case",
          grep_opts = "--color=auto --perl-regexp",
          actions = {
            -- actions inherit from 'actions.files' and merge
            -- this action toggles between 'grep' and 'live_grep'
            ["ctrl-g"] = actions.grep_lgrep,
          },
          no_header = false, -- hide grep|cwd header?
          no_header_i = false, -- hide interactive header?
        },
        btags = {
          ctags_file = nil, -- auto-detect from tags-option
          ctags_autogen = false, -- dynamically generate ctags each call
          multiprocess = true,
          file_icons = true,
          git_icons = true,
          color_icons = true,
          rg_opts = "--no-heading --color=always",
          grep_opts = "--color=auto --perl-regexp",
          fzf_opts = {
            -- ["--delimiter"] = "'[\\]:]'",
            ["--with-nth"] = "2..",
            ["--tiebreak"] = "index",
          },
        },
        colorschemes = RUtils.fzflua.open_dock_bottom {
          live_preview = true, -- apply the colorscheme on preview?
          actions = { ["default"] = actions.colorscheme },
          winopts = { title = RUtils.fzflua.format_title("Colorscheme", RUtils.config.icons.misc.plus) },
        },
        quickfix = RUtils.fzflua.open_dock_bottom {
          winopts = { title = RUtils.fzflua.format_title("[QF]", "󰈙") },
          file_icons = true,
          git_icons = true,
        },
        loclist = RUtils.fzflua.open_dock_bottom {
          winopts = { title = RUtils.fzflua.format_title("[LF]", "󰈙") },
          file_icons = true,
          git_icons = true,
        },
        quickfix_stack = RUtils.fzflua.open_dock_bottom {
          winopts = { title = RUtils.fzflua.format_title("[QF]", "󰈙") },
          marker = ">", -- current list marker
        },
        lsp = RUtils.fzflua.open_lsp_references {
          cwd_only = true,
          actions = {
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-v"] = actions.file_sel_to_ll,
            ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },

            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-t"] = actions.file_tabedit,
          },
          symbols = RUtils.fzflua.open_center_big_vertical {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false, -- remove spaces
            symbol_style = 1,
            symbol_icons = RUtils.config.icons.kinds,
            async_or_timeout = true,
            exec_empty_query = true,
            winopts = { title = extend_title.title },
            fzf_opts = {
              ["--header"] = [[^o:peek  ^x:filter  ^e:workspace-symbols]],
              ["--reverse"] = false,
            },
            actions = {
              ["alt-v"] = actions.file_sel_to_ll,
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },
              -- ["ctrl-g"] = actions.grep_lgrep,
              ["ctrl-x"] = function()
                local opts = {
                  title = "[LSP Symbols]",
                  actions = {
                    ["default"] = function(selected)
                      local contents = {}
                      if type(selected) == "table" then
                        for _, x in pairs(selected) do
                          for word in x:gmatch "%w+" do
                            contents[#contents + 1] = string.lower(word)
                          end
                        end
                      else
                        for word in selected[1]:gmatch "%w+" do
                          contents[#contents + 1] = string.lower(word)
                        end
                      end

                      require("fzf-lua").lsp_document_symbols {
                        query = table.concat(contents, " "),
                      }
                    end,
                  },
                }
                RUtils.fzflua.open_cmd_filter_kind_lsp(opts)
              end,
              ["ctrl-e"] = function()
                local cwd = vim.loop.cwd()
                local extend_title_cs = RUtils.fzflua.extend_title_fzf({ cwd = cwd }, "Workspace Symbols")

                require("fzf-lua").lsp_workspace_symbols {
                  cwd = cwd,
                  winopts = { title = extend_title_cs.title, fullscreen = false },
                  actions = {
                    ["ctrl-e"] = function(...)
                      require("fzf-lua").lsp_document_symbols(...)
                    end,
                  },
                }
              end,
              ["ctrl-o"] = function(...)
                local P = require "overlook.peek"
                P.peek_fzflua(...)
              end,
            },
          },
          code_actions = RUtils.fzflua.open_lsp_code_action {
            winopts = { title = RUtils.fzflua.format_title("Code Actions", "󰌵") },
          },
          finder = RUtils.fzflua.open_lsp_references {
            async = true,
            silent = true,
            -- providers = {
            --   { "references", prefix = require("fzf-lua").utils.ansi_codes.blue "ref " },
            --   { "definitions", prefix = require("fzf-lua").utils.ansi_codes.green "def " },
            --   { "declarations", prefix = require("fzf-lua").utils.ansi_codes.magenta "decl" },
            --   { "typedefs", prefix = require("fzf-lua").utils.ansi_codes.red "tdef" },
            --   { "implementations", prefix = require("fzf-lua").utils.ansi_codes.green "impl" },
            --   { "incoming_calls", prefix = require("fzf-lua").utils.ansi_codes.cyan "in  " },
            --   { "outgoing_calls", prefix = require("fzf-lua").utils.ansi_codes.yellow "out " },
            -- },
            winopts = { title = RUtils.fzflua.format_title("Finder", "") },
            actions = {
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["alt-v"] = actions.file_sel_to_ll,
              ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },
            },
          },
        },
        diagnostics = RUtils.fzflua.open_center_big_diagnostics {
          winopts = { title = RUtils.fzflua.format_title("Diagnostics", "") },
          cwd_only = false,
          file_icons = true,
          git_icons = false,
          diag_icons = true,
          icon_padding = "", -- add padding for wide diagnostics signs
          actions = {
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-v"] = actions.file_sel_to_ll,
            ["alt-V"] = { prefix = "toggle-all", fn = require("fzf-lua").actions.file_sel_to_ll },
          },
        },
        complete_path = RUtils.fzflua.open_lsp_code_action {
          cmd = "fd " .. fd_opts, -- default: auto detect fd|rg|find
          actions = { ["default"] = actions.complete_insert },
        },
        complete_file = RUtils.fzflua.open_lsp_code_action {
          cmd = "rg " .. rg_opts,
          file_icons = true,
          color_icons = true,
          git_icons = false,
          actions = { ["default"] = actions.complete_insert },
          winopts = { preview = { hidden = false } },
        },
        complete_line = RUtils.fzflua.open_lsp_code_action {
          cmd = "rg " .. rg_opts,
        },
      }
    end,
    config = function(_, opts)
      if vim.g.neovide then
        opts.previewers.builtin.extensions = {
          ["png"] = { "viu", "-b" },
          ["svg"] = { "chafa", "{file}" },
          ["jpg"] = { "" }, -- remove ueberzugpp, neovide cannot support it
        }
      end

      require("fzf-lua").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("FzfSetMap", { clear = true }),
        desc = "Set terminal mappings in fzf buffer.",
        pattern = "fzf",
        callback = function(bufn)
          vim.keymap.set("t", "<F2>", require("fzf-lua").builtin, { buffer = bufn.buf })
          vim.keymap.set("t", "<a-x>", "<a-x>", { buffer = bufn.buf })

          vim.keymap.set("t", "<a-l>", "", { buffer = bufn.buf })
          vim.keymap.set("t", "<a-h>", "", { buffer = bufn.buf })
          vim.keymap.set("t", "<a-j>", "", { buffer = bufn.buf })
          vim.keymap.set("t", "<a-k>", "", { buffer = bufn.buf })
        end,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "<Leader>lF",
              function()
                local function check_current_ft(fts)
                  if vim.tbl_contains(fts, vim.bo[0].filetype) then
                    return true
                  end
                  return false
                end

                local lang_lsp_cmds = {}

                if check_current_ft { "typescriptreact", "typescript" } then
                  table.insert(lang_lsp_cmds, {
                    ["Run TSC"] = function()
                      vim.cmd [[TSC]]
                    end,
                    ["TypescriptLSP - Organizer Imports"] = function()
                      vim.cmd [[TSToolsOrganizeImports]]
                    end,
                    ["TypescriptLSP - Short Imports"] = function()
                      vim.cmd [[TSToolsSortImports]]
                    end,
                    ["TypescriptLSP - Remove Unused imports"] = function()
                      vim.cmd [[TSToolsRemoveUnusedImports]]
                    end,
                    ["TypescriptLSP - Check missing imports"] = function()
                      vim.cmd [[TSToolsAddMissingImports]]
                    end,
                    ["Eslint - Fix all"] = function()
                      vim.cmd [[TSToolsFixAll]]
                    end,
                  })
                end

                if check_current_ft { "go" } then
                  table.insert(lang_lsp_cmds, {
                    ["LSP - Run Gomod"] = function()
                      vim.cmd [[GoGenerate %]]
                    end,
                    ["LSP - Run go tidy"] = function()
                      vim.cmd [[GoMod tidy]]
                    end,
                  })
                end

                if check_current_ft { "python" } then
                  table.insert(lang_lsp_cmds, {
                    ["PythonLSP - Run organize imports"] = function()
                      RUtils.lsp.action["source.organizeImports"]()
                    end,
                    ["Virtualenv - List cmds from uv.nvim"] = function()
                      require("uv").pick_uv_commands()
                    end,
                  })
                end

                local lsp_cmds = vim.tbl_deep_extend("force", {
                  ["Lazy - show format info"] = function()
                    vim.cmd [[LazyFormatInfo]]
                  end,
                  ["LSP - open Mason"] = function()
                    vim.cmd [[Mason]]
                  end,
                  ["LSP - show LSP info (LspInfo)"] = function()
                    vim.cmd [[LspInfo]]
                  end,
                  ["LSP - show LSP log (LspLog)"] = function()
                    vim.cmd [[LspLog]]
                  end,
                  ["LSP - disable LSP client"] = function()
                    vim.cmd [[lsp stop]]
                  end,
                  ["LSP - show LSP's configs"] = function()
                    Snacks.picker.lsp_config()
                  end,
                  ["Diagnostics - disable diagnostics"] = function()
                    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
                  end,
                  ["Diagnostics - toggle diagnostics virtual lines"] = function()
                    local new_value = not vim.diagnostic.config().virtual_lines
                    ---@diagnostic disable-next-line: undefined-field
                    RUtils.info(tostring(new_value), { title = "Diagnostic: virtual_lines" })
                    vim.diagnostic.config { virtual_lines = new_value }
                    return new_value
                  end,
                }, unpack(lang_lsp_cmds) or {})

                table.sort(lsp_cmds)

                RUtils.fzflua.open_cmd_bulk_center(
                  lsp_cmds,
                  { winopts = { title = RUtils.fzflua.format_title("LSP Commands", RUtils.config.icons.misc.lsp) } }
                )
              end,
              desc = "Bulk: LSP commands",
            },
          },
        },
      },
    },
  },
}
