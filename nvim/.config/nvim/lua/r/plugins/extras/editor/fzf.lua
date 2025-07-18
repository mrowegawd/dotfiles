-- local picker = {
--   name = "fzf",
--   commands = {
--     files = "files",
--   },
--
--   ---@param command string
--   ---@param opts? FzfLuaOpts
--   open = function(command, opts)
--     opts = opts or {}
--     if opts.cmd == nil and command == "git_files" and opts.show_untracked then
--       opts.cmd = "git ls-files --exclude-standard --cached --others"
--     end
--     return require("fzf-lua")[command](opts)
--   end,
-- }
-- if not RUtils.pick.register(picker) then
--   return {}
-- end

-- local function symbols_filter(entry, ctx)
--   if ctx.symbols_filter == nil then
--     ctx.symbols_filter = LazyVim.config.get_kind_filter(ctx.bufnr) or false
--   end
--   if ctx.symbols_filter == false then
--     return true
--   end
--   return vim.tbl_contains(ctx.symbols_filter, entry.kind)
-- end

local rg_opts =
  "--column --hidden --line-number --no-heading --ignore-case --smart-case --color=always --max-columns=4096 --colors 'match:fg:178' -e "
local fd_opts = [[--color never --type f --hidden --follow --exclude .git --exclude '*.pyc' --exclude '*.pytest_cache']]

return {
  -- FZF-LUA
  {
    "ibhagwan/fzf-lua",
    version = false,
    cmd = "FzfLua",
    dependencies = {
      "tpope/vim-fugitive",
      {
        "mangelozzi/nvim-rgflow.lua",
        opts = {
          default_trigger_mappings = false,
          default_ui_mappings = false,
          cmd_flags = rg_opts,
          mappings = {
            ui = {
              -- Normal mode maps
              n = {
                ["<CR>"] = "start", -- With the ui open, start a search with the current parameters
                ["<ESC>"] = "close", -- With the ui open, discard and close the UI window
                ["q"] = "close", -- With the ui open, start a search with the current parameters (from insert mode)
                ["?"] = "show_rg_help", -- Show the rg help in a floating window, which can be closed with q or <ESC> or the usual <C-W><C-C>
                ["<BS>"] = "nop", -- No operation
                ["<C-^>"] = "nop", -- No operation
                ["<C-6>"] = "nop", -- No operation
              },
              -- Insert mode maps
              i = {
                ["<cr>"] = "nop", -- With the ui open, start a search with the current parameters (from insert mode)
                ["<c-j>"] = "auto_complete", -- Start autocomplete if PUM not visible, if visible use own hotkeys to select an option
                ["<C-n>"] = "nop", -- Start autocomplete if PUM not visible, if visible use own hotkeys to select an option
                -- ["<C-P>"] = "auto_complete", -- Start autocomplete if PUM not visible, if visible use own hotkeys to select an option
              },
            },
          },
          colors = { RgFlowInputPattern = { link = "GitSignsAdd", bold = true } },
        },
      },
    },
    --stylua: ignore
    keys = {
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
      { "<c-h>", "<Left>", ft = "fzf", mode = "t", nowait = true },
      { "<c-c>", "<esc>", ft = "fzf", mode = "t", nowait = true },

      { "tf", function() require("fzf-lua").tabs() end, desc = "Tab: select tabs [fzflua]" },

      -- Buffers
      {
        "<Leader>bf",
        function()
          require("fzf-lua").buffers {
            winopts = function()
              local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
              local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

              local win_height = math.ceil(lines / 2)
              local win_width = math.ceil(columns / 2)
              local col = math.ceil((win_width / 2))
              local row = math.ceil((win_height / 2))
              return {
                title = RUtils.fzflua.format_title("Buffers", "󰈙"),
                title_pos = "center",
                width = win_width,
                height = win_height,
                row = row,
                col = col,
                backdrop = 60,
                preview = {
                  vertical = "down:55%", -- up|down:size
                  horizontal = "right:45%", -- right|left:size
                  hidden = "hidden",
                },
              }
            end,
          }
        end,
        desc = "Buffer: select buffers [fzflua]",
      },

      { "<Leader>ff", function() require("fzf-lua").files() end, desc = "Picker: find files [fzflua]", mode = { "n", "v" } },

      { "<Leader>bg", function() require("fzf-lua").blines { fzf_colors = { ["bg+"] = { "bg", "CursorLine" } } } end, desc = "Buffer: live grep on curbuf [fzflua]" },
      {
        "<Leader>bg",
        function()
          local visual_selection = RUtils.cmd.get_visual_selection { strict = true }

          -- Kita harus membuat simulasi cursor itu harus keluar dari visual mode dengan memakai mapping <esc> 
          -- lalu dikombinasikan dengan memakai `vim.schedule`.
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)
          vim.schedule(function()
            if not visual_selection or not visual_selection.selection or visual_selection.selection == "" then
              ---@diagnostic disable-next-line: undefined-field
              RUtils.warn("cannot execute: an error occurred..?", { title ="Fzflua Blines" } )
              return
            end
            require("fzf-lua").blines { query = visual_selection.selection, fzf_colors = { ["bg+"] = { "bg", "CursorLine" } } }
          end)
        end,
        desc = "Buffer: live grep on curbuf (visual) [fzflua]",
        mode = { "v" },
      },
      { "<Leader>bG", function() require("fzf-lua").lines { fzf_colors = { ["bg+"] = { "bg", "CursorLine" } } } end, desc = "Buffer: live grep on buffers [fzflua]" },
      { "<Leader>bG", function() require("fzf-lua").lines { query = vim.fn.expand "<cword>", fzf_colors = { ["bg+"] = { "bg", "CursorLine" } } } end, desc = "Buffer: live grep on buffers (visual) [fzflua]", mode = { "v" } },
      { "<Leader>fc", function() require("fzf-lua").command_history() end, desc = "Picker: history commands [fzflua]" },
      { "<Leader>fC", function() require("fzf-lua").commands() end, desc = "Picker: commands [fzflua]" },
      { "<Leader>fa", function() require("fzf-lua").autocmds() end, desc = "Picker: automcds [fzflua]" },
      { "<Leader>fO", function() require("fzf-lua").oldfiles() end, desc = "Picker: recent files (history buffer) [fzflua]" },
      { "<Leader>fL", function() require("fzf-lua").resume() end, desc = "Picker: resume (last search) [fzfua]" },
      { "<Leader>fM", function() require("fzf-lua").man_pages() end, desc = "Picker: man pages [fzflua]" },
      { "<Leader>fh", function() require("fzf-lua").search_history() end, desc = "Picker: search history [fzflua]" },
      { "<Leader>fH", function() require("fzf-lua").help_tags() end, desc = "Picker: help [fzflua]" },
      { "<Leader>fk", function() require("fzf-lua").keymaps() end, desc = "Picker: keymaps [fzflua]" },

      -- Jump To
      { "<Leader>jm", function() require("fzf-lua").marks() end, desc = "JumpTo: marks [fzflua]" },
      { "<Leader>jj", function() require("fzf-lua").jumps() end, desc = "JumpTo: jumps [fzflua]" },

      { "z=", function() require("fzf-lua").spell_suggest() end, desc = "Picker: spell suggest [fzflua]" },

      -- LSP
      { "gs", "<CMD>FzfLua lsp_document_symbols<CR>", desc = "LSP: document symbols [fzflua]" },
      { "gS", "<CMD>FzfLua lsp_live_workspace_symbols<CR>", desc = "LSP: workspaces symbols [fzflua]" },

      -- Diagnostics
      { "df", "<CMD>FzfLua diagnostics_document<CR>", desc = "Diagnostic: document [fzflua]" },

      -- Grep
      { "<Leader>fg", function() require("fzf-lua").live_grep_glob() end, desc = "Picker: live grep [fzflua]" },
      { "<Leader>fG", function() require("fzf-lua").grep() end, desc = "Picker: grep [fzflua]" },
      -- { "<Leader>fG",
      --   function()
      --     require("fzf-lua").live_grep_glob {
      --       cwd = vim.fn.expand "%:p:h",
      --       winopts = {
      --         title = RUtils.fzflua.format_title(
      --           "Grep current cwd: " .. vim.fn.expand "%:p:h",
      --           RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope2)
      --         ),
      --         width = 0.90,
      --         height = 0.90,
      --         row = 0.50,
      --         col = 0.50,
      --         preview = {
      --           vertical = "down:40%", -- up|down:size
      --           horizontal = "up:60%", -- right|left:size
      --         },
      --       },
      --     }
      --   end,
      --   desc = "Picker: live grep on current cwd [fzflua]",
      -- },
      { "<Leader>fg", function() require("fzf-lua").grep_visual() end, desc = "Picker: live grep (visual) [fzflua]", mode = { "v" } },
      {
        "<Leader>fw",
        function()
          require("fzf-lua").grep_cword {
            winopts = {
              title = RUtils.fzflua.format_title(
                "Grep word",
                RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope2)
              ),
              width = 0.90,
              height = 0.90,
              row = 0.50,
              col = 0.50,
              preview = {
                vertical = "down:40%", -- up|down:size
                horizontal = "up:60%", -- right|left:size
              },
            },
          }
        end,
        desc = "Picker: grep word [fzflua]",
      },
      {
        "<Leader>fw",
        function()
          require("fzf-lua").grep_visual {
            winopts = {
              title = RUtils.fzflua.format_title(
                "Grep word visual",
                RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope2)
              ),
              width = 0.95,
              height = 0.90,
              row = 0.50,
              col = 0.50,
              preview = {
                vertical = "down:40%", -- up|down:size
                horizontal = "up:60%", -- right|left:size
              },
            },
          }
        end,
        desc = "Picker: grep word visual [fzflua]",
        mode = { "v" },
      },

      -- Git
      { "<Leader>gs", function() require("fzf-lua").git_status() end, desc = "Git: status [fzflua]", },
      { "<Leader>gS", function() require("fzf-lua").git_stash() end, desc = "Git: stash [fzflua]", },
      { "<Leader>gc", function() require("fzf-lua").git_bcommits() end, desc = "Git: buffer commits [fzflua]", },
      { "<Leader>gC", function() require("fzf-lua").git_commits() end, desc = "Git: repo commits [fzflua]", },

      {
        "<Leader>fz",
        function()
          require("fzf-lua").files {
            prompt = RUtils.fzflua.default_title_prompt(),
            winopts = { title = RUtils.fzflua.format_title("Main Themes", "󰈙") },
            cwd_prompt = false,
            no_header = false, -- disable default header
            cwd = "~/.config/miscxrdb/xresource-theme",
            actions = {
              ["default"] = function(selected)
                local slice_num_str = selected[1]:match ".*\xe2\x80\x82()"
                local pth = selected[1]:sub(slice_num_str)
                local script_path = vim.fn.expand "$HOME" .. "/.config/rofi/menu/_themes setup " .. pth
                vim.cmd [[ChangeMasterTheme]]
                vim.cmd([[!bash ]] .. script_path)
              end,
            },
          }
        end,
        desc = "Picker: select themes [fzflua]",
      },

      {
        "<Leader>fH",
        function()
          local sel = RUtils.cmd.get_visual_selection { strict = true }
          if sel then
            local selection = RUtils.cmd.strip_whitespace(sel.selection)
            local _, err = pcall(function()
              vim.cmd("h " .. selection)
            end)

            if err then
              ---@diagnostic disable-next-line: undefined-field
              RUtils.warn(selection .. " -> Not found ", { title = "FzfLua Help" })
            end
          end
        end,
        mode = { "v" },
        desc = "Picker: help (visual) [fzflua]",
      },
      {
        "<Leader>fo",
        function()
          return require("fzf-lua").files {
            prompt = RUtils.fzflua.default_title_prompt(),
            winopts = { title = RUtils.fzflua.format_title("Dotfiles", "󰈙") },
            cwd = "~/moxconf/development/dotfiles",
          }
        end,
        desc = "Picker: dotfiles [fzflua]",
      },
      {
        "<Leader>fF",
        function()
          local plugins_directory = vim.fn.stdpath "data" .. "/lazy"
          return require("fzf-lua").files {
            prompt = RUtils.fzflua.default_title_prompt(),
            winopts = { title = RUtils.fzflua.format_title("Plugin Files", "󰈙") },
            cwd = plugins_directory,
          }
        end,
        desc = "Picker: plugin files [fzflua]",
      },
    },
    opts = function()
      local actions = require "fzf-lua.actions"
      local extend_title = RUtils.fzflua.extend_title_fzf { cwd = "" }

      local img_previewer ---@type string[]?
      for _, v in ipairs {
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "ueberzug", args = {} },
        { cmd = "viu", args = { "-b" } },
        -- local pdf_preview_command = vim.fn.executable "pdftotext" == 1
        --     and { "pdftotext", "-l", "10", "-nopgbrk", "-nodiag", "-q", "<file>", "-" }
      } do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return {
        winopts = function()
          local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
          local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

          local win_height = math.ceil(lines * 0.5)
          local win_width = math.ceil(columns * 1)
          local col = math.ceil((columns - win_width) * 1)
          local row = math.ceil((lines - win_height) * 1 - 3)
          return {
            title_pos = "left",
            width = win_width,
            height = win_height,
            row = row,
            col = col,
            backdrop = 100,
            preview = {
              vertical = "down:55%", -- up|down:size
              horizontal = "right:45%", -- right|left:size
            },
          }
        end,
        hls = { cursor = "CurSearch" },
        fzf_colors = {
          ["fg"] = { "fg", "FzfLuaFilePart" },
          ["bg"] = { "bg", "FzfLuaNormal" },
          ["hl"] = { "fg", "FzfLuaFzfMatchFuzzy" },
          ["fg+"] = { "fg", "FzfLuaFilePart" },
          ["bg+"] = { "bg", "FzfLuaSel" },
          ["hl+"] = { "fg", "FzfLuaFzfMatch" },
          ["info"] = { "fg", "FzfLuaHeaderText" },
          ["prompt"] = { "fg", "Conditional" },
          ["pointer"] = { "fg", "Keyword" },
          ["marker"] = { "fg", "KeywordMatch" },
          ["spinner"] = { "fg", "Label" },
          ["header"] = { "fg", "FzfLuaHeaderText" },
          ["gutter"] = { "bg", "FzfLuaBorder" },
          ["border"] = { "fg", "FzfLuaBorder" },
        },
        previewers = {
          builtin = {
            treesitter = { context = false }, -- disable treesitter-context
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
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

            ["<c-u>"] = "preview-page-up",
            ["<c-d>"] = "preview-page-down",

            ["<c-Up>"] = "preview-page-up",
            ["<c-Down>"] = "preview-page-down",
          },
          fzf = {
            ["alt-a"] = "toggle-all",

            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",

            -- ["ctrl-dp"] = "preview-page-up",
            -- ["ctrl-down"] = "preview-page-down",
          },
        },
        defaults = {
          copen = RUtils.cmd.quickfix.copen,
          lopen = RUtils.cmd.quickfix.lopen,
        },
        fzf_opts = {
          ["--no-separator"] = "",
          ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-history",
        }, -- remove separator line
        files = {
          -- debug = true,
          prompt = RUtils.fzflua.default_title_prompt(),
          cwd_prompt = false,
          no_header = true, -- disable default header
          winopts = { title = RUtils.fzflua.format_title("Files", "") },
          -- check define header (cara lain): https://github.com/ibhagwan/fzf-lua/issues/1351
          fzf_opts = { ["--header"] = [[^r:rgflow  ^y:copypath  ^q:ignore  ^o:hidden]] },
          fd_opts = fd_opts,
          git_icons = false,
          formatter = "path.filename_first",
          actions = {
            ["alt-l"] = actions.file_sel_to_ll,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
            ["ctrl-o"] = actions.toggle_hidden,
            ["ctrl-q"] = actions.toggle_ignore,
            -- ["ctrl-s"] = actions.toggle_ignore,
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
            ["ctrl-r"] = function(_, args)
              require("rgflow").open(require("fzf-lua").config.__resume_data.last_query, args.fd_opts, args.cwd, {
                custom_start = function(pattern, flags, path)
                  args.cwd = path
                  args.rg_opts = flags
                  args.cmd = "fd" .. " " .. flags
                  args.query = pattern
                  return require("fzf-lua").files {
                    query = args.query,
                    cwd = args.cwd,
                    cmd = args.cmd,
                    rg_opts = args.rg_opts,
                    winopts = {
                      title = RUtils.fzflua.format_title("Files: RgFlow", ""),
                    },
                  }
                end,
              })
            end,
            ["ctrl-y"] = function(selected, _)
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
            prompt = RUtils.fzflua.default_title_prompt(),
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
          status = {
            prompt = RUtils.fzflua.default_title_prompt(),
            winopts = {
              title = RUtils.fzflua.format_title("Git Status", ""),
              title_pos = "left",
            },
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            actions = {
              -- actions inherit from 'actions.files' and merge
              -- ["right"] = { actions.git_unstage, actions.resume },
              -- ["left"] = {
              --   actions.git_stage,
              --   actions.resume,
              -- },
              ["left"] = false,
              ["right"] = false,
              ["alt-l"] = actions.file_sel_to_ll,
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
              ["ctrl-s"] = { actions.git_stage_unstage, actions.resume },
              ["ctrl-x"] = { actions.git_reset, actions.resume },
            },
          },
          commits = {
            prompt = RUtils.fzflua.default_title_prompt(),
            no_header = true, -- disable default header
            preview = "git show --pretty='%Cred%H%n%Cblue%an <%ae>%n%C(yellow)%cD%n%Cgreen%s' --color {1}",
            cmd = "git log --color --pretty=format:'%C(blue)%h%Creset "
              .. "%Cred(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            winopts = { title = RUtils.fzflua.format_title("Commits", ""), title_pos = "left" },
            fzf_opts = { ["--header"] = [[^r:compare  ^g:grep  ^x:historycommit  ^y:copyhash  ^o:browser]] },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["alt-l"] = actions.file_sel_to_ll,
              ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,
              ["ctrl-g"] = function()
                require("fzf-lua").fzf_live(function(query)
                  return RUtils.fzf_diffview.git_log_content_finder(query, nil)
                end, RUtils.fzf_diffview.opts_diffview_log("repo", "Grep log history"))
              end,
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]

                ---@diagnostic disable-next-line: undefined-field
                RUtils.info("Browse commit hash: " .. commit_hash, { title = "FZFGit" })

                vim.cmd("GBrowse " .. commit_hash)
              end,
              ["ctrl-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                RUtils.fzf_diffview.copy_to_clipboard(commit_hash)

                require("fzf-lua").actions.resume()
              end,
              ["ctrl-x"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]

                local cmdmsg = "DiffviewOpen -uno " .. "HEAD.." .. commit_hash .. "~1"
                vim.cmd(cmdmsg)

                ---@diagnostic disable-next-line: undefined-field
                RUtils.info("Diffopen: HEAD~1.." .. commit_hash .. "~1", { title = "FZFGit" })
              end,
              ["ctrl-r"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                -- With gitsigns
                local gitsigns = require "gitsigns"
                gitsigns.diffthis(commit_hash)

                -- With vim-fugitive
                -- local cmdmsg = "Gvdiffsplit " .. commit_hash
                -- vim.cmd(cmdmsg)

                -- With diffview
                -- local cmdmsg = "DiffviewOpen -uno " .. commit_hash
                -- local cmdmsg = "Gvdiffsplit " .. commit_hash
                -- vim.cmd(cmdmsg)

                ---@diagnostic disable-next-line: undefined-field
                RUtils.info("Compare diff: current commit --> " .. commit_hash, { title = "FZFGit" })
              end,
            },
          },
          bcommits = {
            -- debug = true,
            prompt = RUtils.fzflua.default_title_prompt(),
            no_header = true, -- disable default header
            preview = "git diff --color {1}~1 {1} -- <file>",
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            cmd = "git log --color --pretty=format:'%C(blue)%h%Creset "
              .. "%Cred(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset' {file}",
            winopts = { title = RUtils.fzflua.format_title("BCommits", ""), title_pos = "left" },
            fzf_opts = { ["--header"] = [[^r:compare  ^g:grep  ^x:historycommit  ^y:copyhash  ^o:browser]] },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["alt-l"] = actions.file_sel_to_ll,
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-t"] = actions.git_buf_tabedit,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-g"] = function()
                local bufnr = vim.fn.bufnr()
                require("fzf-lua").fzf_live(function(query)
                  return RUtils.fzf_diffview.git_log_content_finder(query, bufnr)
                end, RUtils.fzf_diffview.opts_diffview_log("curbuf", "Grep text in log Bcommits", bufnr))
              end,
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]

                ---@diagnostic disable-next-line: undefined-field
                RUtils.info("Browse commit hash: " .. commit_hash, { title = "FZFGit" })

                vim.cmd("GBrowse " .. commit_hash)
              end,
              ["ctrl-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                RUtils.fzf_diffview.copy_to_clipboard(commit_hash)

                require("fzf-lua").actions.resume()
              end,
              ["ctrl-x"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                local filename = RUtils.fzf_diffview.git_relative_path(vim.api.nvim_get_current_buf())

                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash .. " -- " .. filename
                vim.cmd(cmdmsg)
                ---@diagnostic disable-next-line: undefined-field
                RUtils.info("Diffopen: " .. commit_hash .. " -- ", { title = "FZFGit" })
              end,
              ["ctrl-r"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                -- With gitsigns
                local gitsigns = require "gitsigns"
                gitsigns.diffthis(commit_hash)

                -- With vim-fugitive
                -- local cmdmsg = "Gvdiffsplit " .. commit_hash
                -- vim.cmd(cmdmsg)

                -- With diffview
                -- local cmdmsg = "DiffviewOpen -uno " .. commit_hash
                -- local cmdmsg = "Gvdiffsplit " .. commit_hash
                -- vim.cmd(cmdmsg)

                ---@diagnostic disable-next-line: undefined-field
                RUtils.info("Compare diff: current commit --> " .. commit_hash, { title = "FZFGit" })
              end,
            },
          },
          branches = {
            prompt = RUtils.fzflua.default_title_prompt(),
            cmd = "git branch --all --color",
            preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
            winopts = {
              title = RUtils.fzflua.format_title("Branches", ""),
              title_pos = "left",
              height = 0.3,
              row = 0.4,
            },
            actions = {
              ["default"] = actions.git_switch,
              ["alt-l"] = actions.file_sel_to_ll,
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
            },
          },
          stash = {
            prompt = RUtils.fzflua.default_title_prompt(),
            winopts = {
              title = RUtils.fzflua.format_title("Stash", ""),
              title_pos = "left",
            },
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
        grep = {
          -- debug = true,
          prompt = RUtils.fzflua.default_title_prompt(),
          no_header = true, -- disable default header
          rg_opts = rg_opts,
          fzf_opts = { ["--header"] = [[^r:rgflow  ^g:lgrep  ^x:grepcwd  ^q:ignore  ^o:hidden]] },
          -- NOTE: multiline requires fzf >= v0.53 and is ignored otherwise
          -- multiline = 1, -- Display as: PATH:LINE:COL\nTEXT
          -- multiline = 2, -- Display as: PATH:LINE:COL\nTEXT\n
          formatter = "path.filename_first",
          multiprocess = true,
          winopts = {
            title = RUtils.fzflua.format_title(
              "Grep",
              RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope2)
            ),
            width = 0.90,
            height = 0.90,
            row = 0.50,
            col = 0.50,
            preview = {
              vertical = "down:40%", -- up|down:size
              horizontal = "up:60%", -- right|left:size
            },
          },
          actions = {
            ["ctrl-q"] = actions.toggle_ignore,
            ["ctrl-o"] = actions.toggle_hidden,
            -- ["ctrl-o"] = function(_, opts)
            --   actions.toggle_opt(opts, "hidden")
            --   actions.toggle_opt(opts, "no_ignore")
            -- end,
            ["ctrl-x"] = function()
              require("fzf-lua").files {
                fd_opts = [[--color=never --type d --type l --exclude .git]],
                winopts = {
                  title = RUtils.fzflua.format_title(
                    "Select folder for grep",
                    RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope2)
                  ),
                },
                formatter = false, -- disable setting "path first"
                actions = {
                  ["default"] = function(selected)
                    local paths = {}
                    local path_str = ""
                    if #selected > 1 then
                      for _, sel in pairs(selected) do
                        if #sel > 0 then
                          local slice_num_str = sel:match ".*\xe2\x80\x82()"
                          local path = sel:sub(slice_num_str)
                          table.insert(paths, path)
                        end
                      end
                    else
                      local slice_num_str = selected[1]:match ".*\xe2\x80\x82()"
                      path_str = selected[1]:sub(slice_num_str)
                    end

                    local opts = {}

                    local title_path
                    if #paths > 1 then
                      title_path = "[ " .. table.concat(paths, ", ") .. " ]"
                      opts.rg_opts = "--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 "
                        .. table.concat(paths, " ")
                        .. " -e "
                      print(opts.rg_opts)
                    else
                      opts.cwd = path_str
                      title_path = path_str
                    end

                    opts.winopts = {
                      title = RUtils.fzflua.format_title(
                        "Grep: " .. title_path,
                        RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope2)
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
            ["alt-l"] = actions.file_sel_to_ll,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
            ["ctrl-r"] = function(_, args)
              require("rgflow").open(require("fzf-lua").config.__resume_data.last_query, args.rg_opts, args.cwd, {
                custom_start = function(pattern, flags, path)
                  args.cwd = path
                  args.rg_opts = flags
                  args.cmd = "rg" .. " " .. flags
                  args.query = pattern
                  return require("fzf-lua").live_grep_glob {
                    query = args.query,
                    cwd = args.cwd,
                    cmd = args.cmd,
                    rg_opts = args.rg_opts,
                    winopts = {
                      title = RUtils.fzflua.format_title(
                        "Live Grep: RgFlow",
                        RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope2)
                      ),
                    },
                  }
                end,
              })
            end,
          },
        },
        args = {
          prompt = RUtils.fzflua.default_title_prompt(),
          files_only = true,
          actions = {
            ["ctrl-x"] = { actions.arg_del, actions.resume },
            ["alt-l"] = actions.file_sel_to_ll,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
          },
        },
        jumps = { prompt = RUtils.fzflua.default_title_prompt() },
        marks = { prompt = RUtils.fzflua.default_title_prompt() },
        builtin = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Builtin", RUtils.config.icons.misc.tools) },
        },
        commands = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Commands", RUtils.config.icons.misc.tools) },
        },
        command_history = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("History Commands", RUtils.config.icons.misc.tools) },
        },
        oldfiles = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Recent Files", "") },
          fzf_opts = { ["--header"] = [[^o:oldfiles-all  ^r:oldfiles-current]] },
          cwd_only = true,
          stat_file = true, -- verify files exist on disk
          include_current_session = false, -- include bufs from current session
          actions = {
            ["ctrl-o"] = function()
              require("fzf-lua").oldfiles { cwd_only = false }
            end,
            ["ctrl-r"] = function()
              require("fzf-lua").oldfiles { cwd_only = true }
            end,
          },
        },
        buffers = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Buffers", "󰈙") },
          cwd = nil, -- buffers list for a given dir
          fzf_opts = { ["--with-nth"] = "-1.." },
          actions = {
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-l"] = actions.file_sel_to_ll,
            ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
          },
        },
        highlights = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Highlights", RUtils.config.icons.misc.circle) },
        },
        helptags = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Help", "󰋖") },
        },
        tabs = {
          prompt = RUtils.fzflua.default_title_prompt(),
          tab_title = "Tab",
          tab_marker = "<<",
          file_icons = true, -- show file icons?
          color_icons = true, -- colorize file|git icons
          actions = {
            -- actions inherit from 'actions.buffers' and merge
            ["default"] = actions.buf_switch,
            ["alt-l"] = actions.file_sel_to_ll,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
            ["ctrl-x"] = { actions.buf_del, actions.resume },
          },
          fzf_opts = {
            -- hide tabnr
            -- ["--delimiter"] = "'[\\):]'",
            ["--with-nth"] = "2..",
          },
        },
        lines = {
          prompt = RUtils.fzflua.default_title_prompt(),
          fzf_opts = {
            -- do not include bufnr in fuzzy matching
            -- tiebreak by line no.
            -- ["--delimiter"] = "'[\\]:]'",
            ["--nth"] = "2..",
            ["--tiebreak"] = "index",
            ["--tabstop"] = "1",
          },
          winopts = {
            title = RUtils.fzflua.format_title("Lines", ""),
            height = 0.90,
            width = 0.90,
            col = 0.50,
            row = 0.50,
            preview = { vertical = "down:40%", horizontal = "up:50%" },
          },
          -- actions inherit from 'actions.buffers' and merge
          actions = {
            ["default"] = actions.buf_edit_or_qf,

            ["alt-l"] = actions.file_sel_to_ll,
            ["alt-q"] = actions.buf_sel_to_qf,
            ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },

            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
        },
        keymaps = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = {
            title = RUtils.fzflua.format_title("Keymaps", " "),
            height = 0.90,
            width = 0.90,
            col = 0.50,
            row = 0.50,
            preview = { vertical = "up:40%", horizontal = "down:40%" },
          },
        },
        autocmds = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = {
            title = RUtils.fzflua.format_title("Autocmds", " "),
            height = 0.90,
            width = 0.90,
            col = 0.50,
            row = 0.50,
            preview = { vertical = "up:30%", horizontal = "up:50%" },
          },
        },
        blines = {
          prompt = RUtils.fzflua.default_title_prompt(),
          no_header = true, -- hide grep|cwd header?
          no_header_i = true, -- hide interactive header?
          winopts = {
            title = RUtils.fzflua.format_title("Blines", ""),
            height = 0.90,
            width = 0.90,
            col = 0.50,
            row = 0.50,
            preview = { vertical = "down:40%", horizontal = "up:50%" },
          },
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

            ["alt-l"] = actions.buf_sel_to_ll,
            ["alt-q"] = actions.buf_sel_to_qf,
            ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },

            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
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
        colorschemes = {
          prompt = RUtils.fzflua.default_title_prompt(),
          live_preview = true, -- apply the colorscheme on preview?
          actions = { ["default"] = actions.colorscheme },
          winopts = { title = RUtils.fzflua.format_title("Colorscheme", RUtils.config.icons.misc.plus) },
        },
        quickfix = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = {
            title = RUtils.fzflua.format_title("[QF]", "󰈙"),
          },
          file_icons = true,
          git_icons = true,
        },
        quickfix_stack = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = {
            title = RUtils.fzflua.format_title("[QF]", "󰈙"),
          },
          marker = ">", -- current list marker
        },
        lsp = {
          cwd_only = true,
          winopts = function()
            local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
            local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

            local win_height = math.ceil(lines * 0.65)
            local win_width = math.ceil(columns * 2)
            return {
              -- title = RUtils.fzflua.format_title("Finder", RUtils.config.icons.misc.lsp),
              width = win_width,
              height = win_height,
              row = 0.50,
              preview = {
                vertical = "down:45%", -- up|down:size
                horizontal = "left:55%", -- right|left:size
              },
            }
          end,
          actions = {
            ["alt-l"] = actions.file_sel_to_ll,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-t"] = actions.file_tabedit,
          },
          symbols = {
            prompt = RUtils.fzflua.default_title_prompt(),
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
            winopts = {
              title = extend_title.title,
              fullscreen = false,
              height = 0.85,
              width = 0.90,
              row = 0.50,
              col = 0.50,
              backdrop = 60,
            },
            fzf_opts = {
              ["--header"] = [[^x:filter  ^r:workspace-symbols]],
              ["--reverse"] = false,
            },
            actions = {
              ["alt-l"] = actions.file_sel_to_ll,
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
              ["ctrl-g"] = actions.grep_lgrep,
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
                RUtils.fzflua.cmd_filter_kind_lsp(opts)
              end,
              ["ctrl-r"] = function()
                local cwd = vim.loop.cwd()
                local extend_title_cs = RUtils.fzflua.extend_title_fzf({ cwd = cwd }, "Workspace Symbols")

                require("fzf-lua").lsp_workspace_symbols {
                  cwd = cwd,
                  winopts = { title = extend_title_cs.title, fullscreen = false },
                }
              end,
            },
          },
          code_actions = RUtils.fzflua.cursor_dropdown {
            prompt = RUtils.fzflua.default_title_prompt(),
            winopts = {
              title = RUtils.fzflua.format_title("Code Actions", "󰌵", "@type"),
            },
          },
          finder = {
            prompt = RUtils.fzflua.default_title_prompt(),
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
            winopts = function()
              local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
              local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

              local win_height = math.ceil(lines * 0.65)
              local win_width = math.ceil(columns * 2)
              return {
                title = RUtils.fzflua.format_title("Finder", ""),
                width = win_width,
                height = win_height,
                row = 0.50,
                preview = {
                  vertical = "down:45%", -- up|down:size
                  horizontal = "left:55%", -- right|left:size
                },
              }
            end,
            actions = {
              ["alt-l"] = actions.file_sel_to_ll,
              ["alt-q"] = actions.file_sel_to_qf,
              ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
              ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
            },
          },
        },
        diagnostics = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Diagnostics", "") },
          cwd_only = false,
          file_icons = true,
          git_icons = false,
          diag_icons = true,
          icon_padding = "", -- add padding for wide diagnostics signs
          actions = {
            ["alt-l"] = actions.file_sel_to_ll,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-Q"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_qf },
            ["alt-L"] = { prefix = "select-all+accept", fn = require("fzf-lua").actions.file_sel_to_ll },
          },
        },
        complete_path = {
          prompt = RUtils.fzflua.default_title_prompt(),
          cmd = nil, -- default: auto detect fd|rg|find
          actions = { ["default"] = actions.complete_insert },
        },
        complete_file = {
          cmd = nil, -- default: auto detect rg|fd|find
          file_icons = true,
          color_icons = true,
          git_icons = false,
          actions = { ["default"] = actions.complete_insert },
          winopts = { preview = { hidden = "hidden" } },
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
          -- vim.keymap.set("t", "<c-w>", "<c-w>", { buffer = buf, nowait = true })
        end,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "mangelozzi/nvim-rgflow.lua", "saghen/blink.compat" },
    opts = { sources = { per_filetype = { rgflow = { "buffer", "path" } } } },
  },
}
