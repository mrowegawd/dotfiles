local Highlight = require "r.settings.highlights"

local have_make = vim.fn.executable "make" == 1
local have_cmake = vim.fn.executable "cmake" == 1

local rg_opts =
  "--column --hidden --line-number --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -e "
local fd_opts = [[--color never --type f --hidden --follow --exclude .git --exclude '*.pyc']]

local telescope_toggle_fullscreen = true
local telescope_layout_strategy_height = 0

return {
  -- FLASH.NVIM
  {
    "folke/flash.nvim",
    opts = function()
      Highlight.plugin("flash.nvim", {
        {
          FlashMatch = {
            fg = "white",
            bg = "red",
            bold = true,
          },
        },
        {
          FlashLabel = {
            bg = "black",
            fg = "yellow",
            bold = true,
            strikethrough = false,
          },
        },
        { FlashCursor = { bg = { from = "ColorColumn", attr = "bg", alter = 5 }, bold = true } },
      })
      return {
        modes = {
          char = {
            keys = { "F", "T", ";" }, -- remove "," from keys
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
      { "ff", function() require("flash").jump() end, mode = { "n", "x", "o" }, },
      -- { "S", function() require("flash").treesitter() end, mode = { "o", "x" } },
      -- { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
      -- { "<c-s>", function() require("flash").toggle() end, mode = { "c" }, desc = "Toggle Flash Search" },
      -- { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Flash Treesitter Search" },
    },
  },
  -- FZF-LUA
  {
    "ibhagwan/fzf-lua",
    version = false,
    cmd = "FzfLua",
    dependencies = {
      "onsails/lspkind.nvim",
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
          colors = {
            --   RgFlowInputPath = { link = "NormalFloat" },
            --   -- RgFlowInputBg = { link = "NormalFloat" },
            --   -- RgFlowHeadLine = { link = "NormalFloat" },
            --   -- RgFlowInputFlags = { link = "NormalFloat" },
            RgFlowInputPattern = { link = "GitSignsAdd", bold = true },
          },
        },
      },
    },
    --stylua: ignore
    keys = {
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
      { "<c-h>", "<Left>", ft = "fzf", mode = "t", nowait = true },

      { "<c-c>", "<esc>", ft = "fzf", mode = "t", nowait = true },

      { "<a-t>", function() require("fzf-lua").tabs() end, desc = "Fzflua: select tabs" },
      { "fb", function()
        require("fzf-lua").buffers({
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
                hidden = "hidden"
              },
            }
          end,
      }) end, desc = "Fzflua: select buffers" },
      { "<Leader>s", "", desc = "+fzfcustom" },
      { "<Leader>bs", function() require("fzf-lua").blines({ fzf_colors = { ["bg+"] = { "bg", "CursorLine" } } }) end, desc = "Buffer: live grep on curbuf [fzflua", mode = { "n" } },
      { "<Leader>bs", function() require("fzf-lua").blines { query = vim.fn.expand "<cword>", fzf_colors = { ["bg+"] = { "bg", "CursorLine" } } } end, desc = "Buffer: live grep on curbuf (visual) [fzflua]", mode = { "v" } },
      { "<Leader>bS", function() require("fzf-lua").lines({ fzf_colors = { ["bg+"] = { "bg", "CursorLine" } } }) end, desc = "Buffer: live grep on buffers [fzflua]" },
      { "<Leader>bS", function() require("fzf-lua").lines { query = vim.fn.expand "<cword>", fzf_colors = { ["bg+"] = { "bg", "CursorLine" } } } end, desc = "Buffer: live grep on buffers (visual) [fzflua]", mode = { "v" } },
      { "<Leader>sc", function() require("fzf-lua").command_history() end, desc = "Fzflua: command history" },
      { "<Leader>sC", function() require("fzf-lua").commands() end, desc = "Fzflua: commands", mode = "n" },
      { "<Leader>sa", function() require("fzf-lua").autocmds() end, desc = "Fzflua: automcds" },
      { "<Leader>fO", function() require("fzf-lua").oldfiles() end, desc = "Fzflua: recent files (history buffer)" },
      { "z=", function() require("fzf-lua").spell_suggest() end, desc = "Fzflua: spell suggest" },
      { "<Leader>ff", function() require("fzf-lua").files() end, desc = "Fzflua: find files", mode = { "n", "v" } },
      { "gs", "<CMD>FzfLua lsp_document_symbols<CR>", desc = "LSP: document symbols [fzflua]" },
      { "gS", "<CMD>FzfLua lsp_live_workspace_symbols<CR>", desc = "LSP: workspaces symbols [fzflua]" },
      { "<Leader>fl", function() require("fzf-lua").resume() end, desc = "Fzflua: resume (last search)" },
      { "<Leader>fg", function() require("fzf-lua").live_grep_glob() end, desc = "Fzflua: live grep" },
      { "<Leader>fg", function() require("fzf-lua").grep_visual() end, desc = "Fzflua: live grep (visual)", mode = { "v" } },
      { "<Leader>fc", function() require("fzf-lua").changes() end, desc = "Fzflua: changes" },
      { "<Leader>fj", function() require("fzf-lua").jumps() end, desc = "Fzflua: jumps" },
      { "<Leader>fm", function() require("fzf-lua").marks() end, desc = "Fzflua: marks" },
      { "<Leader>fs", function() require("fzf-lua").search_history() end, desc = "Fzflua: search history" },

      { "<Leader>gs", function() require("fzf-lua").git_status() end, desc = "Git: status [fzflua]" },
      { "<Leader>gS", function() require("fzf-lua").git_stash() end, desc = "Git: stash [fzflua]" },
      { "<Leader>gc", function() require("fzf-lua").git_bcommits() end, desc = "Git: buffer commits [fzflua]" },
      { "<Leader>gC", function() require("fzf-lua").git_commits() end, desc = "Git: repo commits [fzflua]" },
      { "<Leader>fM", function() require("fzf-lua").man_pages() end, desc = "Git: man pages [fzflua]" },

      { "<Leader>fh", function() local j = vim.fn.expand "<cword>" require("fzf-lua").help_tags { query = j } end, desc = "Fzflua: help tags" },
      {
        "<Leader>fh",
        function()
          local sel = RUtils.cmd.get_visual_selection { strict = true }
          if sel then
            local selection = RUtils.cmd.strip_whitespace(sel.selection)
            local _, err = pcall(function()
              vim.cmd("h " .. selection)
            end)

            if err then
              RUtils.warn(selection .. " -> Not found ", { title = "FzfLua Help" })
            end
          end
        end,
        mode = { "v" },
        desc = "Fzflua: help tags (visual)",
      },
      {
        "<Leader>fo",
        function()
          return require("fzf-lua").files {
            prompt = "   ",
            winopts = { title = RUtils.fzflua.format_title("Dotfiles", "󰈙") },
            cwd = "~/moxconf/development/dotfiles",
          }
        end,
        desc = "Fzflua: dotfiles",
      },
      {
        "<Leader>fF",
        function()
          local plugins_directory = vim.fn.stdpath "data" .. "/lazy"
          return require("fzf-lua").files {
            prompt = "  ",
            winopts = { title = RUtils.fzflua.format_title("Plugin Files", "󰈙") },
            cwd = plugins_directory,
          }
        end,
        desc = "Fzflua: plugin files",
      },
    },
    opts = function()
      local actions = require "fzf-lua.actions"
      local extend_title = RUtils.fzflua.extend_title_fzf { cwd = "" }

      local img_preview_command = vim.fn.executable "ueberzug" == 1 and { "ueberzug" } or nil
      local html_preview_command = vim.fn.executable "w3m" == 1 and { "w3m", "-dump" } or nil
      local pdf_preview_command = vim.fn.executable "pdftotext" == 1
          and { "pdftotext", "-l", "10", "-nopgbrk", "-nodiag", "-q", "<file>", "-" }
        or nil

      return {
        winopts = function()
          local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
          local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

          local win_height = math.ceil(lines * 0.5)
          local win_width = math.ceil(columns * 1)
          local col = math.ceil((columns - win_width) * 1)
          local row = math.ceil((lines - win_height) * 1 - 3)
          return {
            title_pos = "center",
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
          ["bg"] = { "bg", "NormalFloat" },
          ["hl"] = { "fg", "CmpItemAbbrMatch" },
          ["fg+"] = { "fg", "FzfLuaSel" },
          ["bg+"] = { "bg", "FzfLuaSel" },
          ["hl+"] = { "fg", "CmpItemAbbrMatchFuzzy" },
          ["info"] = { "fg", "FzfLuaHeaderText" },
          ["prompt"] = { "fg", "Conditional" },
          ["pointer"] = { "fg", "Error" },
          ["marker"] = { "fg", "Error" },
          ["spinner"] = { "fg", "Label" },
          ["header"] = { "fg", "FzfLuaHeaderText" },
          ["gutter"] = { "bg", "FloatBorder" },
          ["border"] = { "fg", "FzfLuaBorder" },
        },
        previewers = {
          builtin = {
            treesitter = {
              context = false, -- disable treesitter-context
            },
            extensions = {
              ["html"] = html_preview_command,
              ["jpg"] = img_preview_command,
              ["png"] = img_preview_command,
              ["svg"] = img_preview_command,
              ["pdf"] = pdf_preview_command,
            },
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
          },
          fzf = {
            ["ctrl-a"] = "toggle-all",

            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
          },
        },
        fzf_opts = { ["--no-separator"] = "" }, -- remove separator line
        files = {
          -- debug = true,
          prompt = RUtils.fzflua.default_title_prompt(),
          cwd_prompt = false,
          no_header = true, -- disable default header
          winopts = { title = RUtils.fzflua.format_title("Files", "") },
          fzf_opts = {
            -- check define header (cara lain): https://github.com/ibhagwan/fzf-lua/issues/1351
            ["--header"] = [[ CTRL-R:rgflow  CTRL-Y:copy/yank-path  ALT-G:toggle-ignore  ALT-H:toggle-hidden]],
          },
          fd_opts = fd_opts,
          git_icons = false,
          formatter = "path.filename_first",
          actions = {
            ["alt-g"] = actions.toggle_ignore,
            ["alt-h"] = actions.toggle_hidden,
            ["ctrl-q"] = actions.file_sel_to_qf,
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
                  return require("fzf-lua").files(args)
                end,
              })
            end,
            ["ctrl-y"] = function(selected, _)
              local slice_num_str = selected[1]:match ".*\xe2\x80\x82()"
              local pth = selected[1]:sub(slice_num_str)
              vim.fn.setreg([[+]], pth)

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
              ["ctrl-q"] = actions.file_sel_to_qf,
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
            fzf_opts = {
              ["--header"] = [[ CTRL-O:browser CTRL-Y:copy-hash ALT-D:compare-commit ALT-H:history-commit]],
            },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["ctrl-q"] = actions.file_sel_to_qf,
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]

                RUtils.info("Browse commit hash: " .. commit_hash, { title = "FZFGit" })

                vim.cmd("GBrowse " .. commit_hash)
              end,
              ["ctrl-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                RUtils.fzf_diffview.copy_to_clipboard(commit_hash)

                require("fzf-lua").actions.resume()
              end,
              ["alt-h"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]

                local cmdmsg = "DiffviewOpen -uno " .. "HEAD.." .. commit_hash .. "~1"
                vim.cmd(cmdmsg)

                RUtils.info("Diffopen: HEAD~1.." .. commit_hash .. "~1", { title = "FZFGit" })
              end,
              ["ctrl-g"] = function()
                require("fzf-lua").fzf_live(function(query)
                  return RUtils.fzf_diffview.git_log_content_finder(query, nil)
                end, RUtils.fzf_diffview.opts_diffview_log("repo", "Search Repo Log Content> "))
              end,
              ["alt-d"] = function(selected, _)
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
            winopts = {
              title = RUtils.fzflua.format_title("BCommits", ""),
              title_pos = "left",
            },
            fzf_opts = {
              ["--header"] = [[ CTRL-O:browser CTRL-Y:copy-hash ALT-D:compare-commit ALT-H:history-commit]],
            },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-q"] = actions.file_sel_to_qf,
              ["ctrl-t"] = actions.git_buf_tabedit,
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]

                RUtils.info("Browse commit hash: " .. commit_hash, { title = "FZFGit" })

                vim.cmd("GBrowse " .. commit_hash)
              end,
              ["ctrl-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                RUtils.fzf_diffview.copy_to_clipboard(commit_hash)

                require("fzf-lua").actions.resume()
              end,
              ["alt-h"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                local filename = RUtils.fzf_diffview.git_relative_path(vim.api.nvim_get_current_buf())

                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash .. " -- " .. filename
                vim.cmd(cmdmsg)
                RUtils.info("Diffopen: " .. commit_hash .. " -- ", { title = "FZFGit" })
              end,
              ["ctrl-g"] = function()
                local bufnr = vim.fn.bufnr()
                require("fzf-lua").fzf_live(function(query)
                  return RUtils.fzf_diffview.git_log_content_finder(query, bufnr)
                end, RUtils.fzf_diffview.opts_diffview_log(
                  "curbuf",
                  "Search Curbuf Log Content> ",
                  bufnr
                ))
              end,
              ["alt-d"] = function(selected, _)
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
              ["ctrl-q"] = actions.file_sel_to_qf,
            },
          },
          stash = {
            prompt = RUtils.fzflua.default_title_prompt(),
            --     cmd = "git --no-pager stash list",
            --     preview = "git --no-pager stash show --patch --color {1}",
            winopts = {
              title = RUtils.fzflua.format_title("Stash", ""),
              title_pos = "left",
            },
            --     actions = {
            --         ["default"] = actions.git_stash_apply,
            --         ["ctrl-x"] = {
            --             actions.git_stash_drop,
            --             actions.resume,
            --         },
            --     },
            --     fzf_opts = {
            --         ["--no-multi"] = "",
            --         ["--delimiter"] = "'[:]'",
            --     },
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
          prompt = "   ",
          no_header = true, -- disable default header
          rg_opts = rg_opts,
          fzf_opts = {
            ["--header"] = [[ CTRL-R:rgflow  CTRL-G:lgrep  ALT-G:toggle-ignore  ALT-H:toggle-hidden]],
          },
          -- NOTE: multiline requires fzf >= v0.53 and is ignored otherwise
          -- multiline = 1, -- Display as: PATH:LINE:COL\nTEXT
          -- multiline = 2, -- Display as: PATH:LINE:COL\nTEXT\n
          formatter = "path.filename_first",
          multiprocess = true,
          winopts = function()
            local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
            local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

            local win_height = math.ceil(lines * 0.9)
            local win_width = math.ceil(columns * 1)
            local col = math.ceil((columns - win_width) * 1)
            local row = math.ceil((lines - win_height) * 1 - 3)
            return {
              title = RUtils.fzflua.format_title(
                "Grep",
                RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope2)
              ),
              width = win_width,
              height = win_height,
              row = row,
              col = col,
              preview = {
                vertical = "down:40%", -- up|down:size
                horizontal = "up:60%", -- right|left:size
              },
            }
          end,
          actions = {
            ["alt-g"] = actions.toggle_ignore,
            ["alt-h"] = actions.toggle_hidden,
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-r"] = function(_, args)
              require("rgflow").open(require("fzf-lua").config.__resume_data.last_query, args.rg_opts, args.cwd, {
                custom_start = function(pattern, flags, path)
                  args.cwd = path
                  args.rg_opts = flags
                  args.cmd = "rg" .. " " .. flags
                  args.query = pattern
                  return require("fzf-lua").live_grep_glob(args)
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
            ["ctrl-q"] = actions.file_sel_to_qf,
          },
        },
        builtin = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Builtin", RUtils.config.icons.misc.tools) },
        },
        commands = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Commands", RUtils.config.icons.misc.tools) },
        },
        oldfiles = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Recent Files", "") },
          cwd_only = true,
          stat_file = true, -- verify files exist on disk
          include_current_session = false, -- include bufs from current session
        },
        keymaps = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { preview = { hidden = "hidden" } },
        },
        buffers = {
          prompt = RUtils.fzflua.default_title_prompt(),
          winopts = { title = RUtils.fzflua.format_title("Buffers", "󰈙") },
          cwd = nil, -- buffers list for a given dir
          fzf_opts = {
            -- ["--delimiter"] = "' '",
            ["--with-nth"] = "-1..",
          },
          actions = {
            ["ctrl-q"] = actions.file_sel_to_qf,
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
            ["ctrl-q"] = actions.file_sel_to_qf,
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
          winopts = { title = RUtils.fzflua.format_title("Lines", "") },
          fzf_opts = {
            -- do not include bufnr in fuzzy matching
            -- tiebreak by line no.
            -- ["--delimiter"] = "'[\\]:]'",
            ["--nth"] = "2..",
            ["--tiebreak"] = "index",
            ["--tabstop"] = "1",
          },
          -- actions inherit from 'actions.buffers' and merge
          actions = {
            ["default"] = actions.buf_edit_or_qf,

            ["ctrl-q"] = actions.buf_sel_to_qf,

            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
        },
        blines = {
          prompt = RUtils.fzflua.default_title_prompt(),
          no_header = true, -- hide grep|cwd header?
          no_header_i = true, -- hide interactive header?
          winopts = {
            title = RUtils.fzflua.format_title("Blines", ""),
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
            ["ctrl-q"] = actions.buf_sel_to_qf,

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
          symbols = {
            prompt = RUtils.fzflua.default_title_prompt(),
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
            symbol_style = 1,
            symbol_icons = RUtils.config.icons.kinds,
            -- child_prefix = false, -- remove spaces
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
              ["--header"] = [[ CTRL-X:filter LSP  CTRL-R:workspace-symbols]],
              ["--reverse"] = false,
            },
            actions = {
              ["ctrl-q"] = actions.file_sel_to_qf,
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
            winopts = function()
              local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
              local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

              local win_height = math.ceil(lines * 0.65)
              local win_width = math.ceil(columns * 2)
              return {
                title = RUtils.fzflua.format_title("Finder", ""),
                width = win_width,
                height = win_height,
                row = 13,
                preview = {
                  vertical = "down:45%", -- up|down:size
                  horizontal = "left:55%", -- right|left:size
                },
              }
            end,
            actions = {
              ["ctrl-q"] = actions.file_sel_to_qf,
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
            ["ctrl-q"] = actions.file_sel_to_qf,
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
  -- TELESCOPE
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    keys = {
      -- { "<Leader>ff", "<cmd>Telescope corrode<cr>", desc = "Telescope: find files", mode = { "n", "v" } },
      -- { "df", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Diagnostic: document diagnostics [telescope]" },
      -- { "dF", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostic: workspace diagnostics [telescope]" },
      -- { "<Leader>fg", "<cmd>Telescope live_grep_args<cr>", desc = "Telescope: live grep" },
      -- { "<Leader>fF", "<cmd>Telescope lazy<cr>", desc = "Telescope: plugin files" },
      -- {
      --   "gs",
      --   function()
      --     require("telescope.builtin").lsp_document_symbols {
      --       symbols = RUtils.config.get_kind_filter(),
      --     }
      --   end,
      --   desc = "Telescope (lsp): goto symbol",
      -- },
      -- {
      --   "gS",
      --   function()
      --     require("telescope.builtin").lsp_dynamic_workspace_symbols {
      --       symbols = RUtils.config.get_kind_filter(),
      --     }
      --   end,
      --   desc = "Telescope(lsp): goto symbol (Workspace)",
      -- },
      -- { "sf", "<CMD>Telescope buffers<CR>", desc = "Telescope: find buffers" },
      { "<Leader>fk", "<CMD>Telescope keymaps<CR>", desc = "Telescope: keymaps", mode = { "n", "v" } },
      -- {
      --   "<Leader>sn",
      --   function()
      --     require("telescope").extensions.luasnip.luasnip {}
      --   end,
      --   desc = "Telescope: luasnip list",
      -- },
      {
        "<Localleader><Localleader>",
        "<CMD>Telescope find_files<CR>",
        desc = "Telescope: files",
        mode = { "n", "v" },
      },
      -- { "<Leader>bg", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope: live_grep on buffers" },
      -- { "<Leader>bo", "<CMD>Telescope oldfiles<CR>", desc = "Telescope: oldfiles" },
      -- { "<Leader>fh", "<CMD>Telescope help_tags<CR>", desc = "Telescope: help tags" },
      -- { "<Leader>fC", "<CMD>Telescope commands<CR>", desc = "Telescope: commands" },
      { "<Localleader>fl", "<CMD>Telescope resume<CR>", desc = "Telescope: resume (last search)" },
      -- { "<Leader>f=", "<CMD>Telescope spell_suggest theme=get_cursor<CR>", desc = "Telescope: spell suggest" },
      -- { "<Leader>fF", "<CMD>Telescope lazy theme=ivy<CR>", desc = "Telescope: plugins files" },
      -- {
      --   "<Leader>ff",
      --   function()
      --     return require("telescope").extensions.menufacture.find_files()
      --   end,
      --   desc = "Telescope: find files",
      -- },
      -- {
      --   "<Leader>fg",
      --   function()
      --     return require("telescope").extensions.menufacture.live_grep()
      --   end,
      --   desc = "Telescope-manufacture: live_grep",
      -- },
      -- {
      --   "<Leader>fg",
      --   function()
      --     return require("telescope").extensions.menufacture.grep_string()
      --   end,
      --   desc = "Telescope-manufacture: live_grep (visual)",
      --   mode = { "v" },
      -- },
      --
      -- {
      --   "<Leader>bg",
      --   function(opts)
      --     local builtin = require "telescope.builtin"
      --
      --     opts = opts or {}
      --
      --     local opt = require("telescope.themes").get_ivy {
      --       cwd = opts.dir,
      --       prompt_title = "Live Grep for all Buffers",
      --       grep_open_files = true,
      --       shorten_path = true,
      --       -- sorter = require("telescope.sorters").get_substr_matcher {},
      --     }
      --     return builtin.live_grep(opt)
      --   end,
      --   description = "Telescope: live_grep on buffers",
      -- },
      --
      --         -- {
      --         --     "<Leader>fF",
      --         --     function()
      --         --         local plugins_directory = vim.fn.stdpath "data"
      --         --             .. "/lazy"
      --         --         return require("telescope.builtin").find_files {
      --         --             cwd = plugins_directory,
      --         --             prompt_title = "Find plugin files",
      --         --         }
      --         --     end,
      --         --     description = "Find plugin files",
      --         -- },
      --
      --         -- TELESCOPE-LAZY
      --         {
      --             "<Leader>fF",
      --             "<CMD>Telescope lazy theme=ivy<CR>",
      --             desc = "Telescope-lazy: check plugins dir",
      --         },
      --         -- TELESCOPE-MENUFACTURE
      --         {
      --             "<Leader>ff",
      --             function()
      --                 return require("telescope").extensions.menufacture.find_files()
      --             end,
      --             desc = "Telescope-manufacture: find files",
      --         },
      --
      --
      --         -- TELESCOPE-GREPQF
      --         {
      --             "<Leader>fq",
      --             "<CMD> Telescope grepqf theme=ivy<CR>",
      --             desc = "Telescope-grepqf: live_grep qf items",
      --         },
      --
      --         -- TELESCOPE-SYMBOLS
      --         {
      --             "<Leader>f1",
      --             "<CMD> Telescope symbols theme=ivy<CR>",
      --             desc = "Telescope-symbol: emoji",
      --         },
      --
      --         -- CONDUCT-NVIM
      --         {
      --             "<Leader>fp",
      --             "<CMD>Telescope conduct projects theme=ivy<CR>",
      --             desc = "Telescope-conductt: projects",
      --         },
    },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = have_make and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = have_make or have_cmake,
        config = function(plugin)
          RUtils.on_load("telescope.nvim", function()
            local ok, err = pcall(require("telescope").load_extension, "fzf")
            if not ok then
              local lib = plugin.dir .. "/build/libfzf." .. (RUtils.is_win() and "dll" or "so")
              if not vim.uv.fs_stat(lib) then
                RUtils.warn "`telescope-fzf-native.nvim` not built. Rebuilding..."
                require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                  RUtils.info "Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim."
                end)
              else
                RUtils.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
              end
            end
          end)
        end,
      },
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "benfowler/telescope-luasnip.nvim",
      "fdschmidt93/telescope-corrode.nvim",
    },
    opts = function()
      -- local trouble = require "trouble.providers.telescope"
      local actions = require "telescope.actions"
      local themes = require "telescope.themes"

      local layout_actions = require "telescope.actions.layout"

      -- local foldMaps = function(_, _)
      --     require("telescope.actions.set").select:enhance {
      --         post = function()
      --             vim.cmd.normal { args = { "zx" }, bang = true }
      --         end,
      --     }
      --     return true
      -- end

      ---@param opts table
      local function dropdown(opts)
        return require("telescope.themes").get_dropdown(vim.tbl_extend("keep", opts or {}, {
          borderchars = {
            { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
        }))
      end

      -- Telescope issue: kadang fold nya nge-bug, untuk sementara solusinya check the issue di github
      -- Taken from https://github.com/nvim-telescope/telescope.nvim/issues/559#issuecomment-1311441898
      local function stopinsert(callback)
        return function(prompt_bufnr)
          vim.cmd.stopinsert()
          vim.schedule(function()
            callback(prompt_bufnr)
          end)
        end
      end

      -- local function stopinsert_fb(callback, callback_dir)
      --     return function(prompt_bufnr)
      --         local entry =
      --             require("telescope.actions.state").get_selected_entry()
      --         if entry and not entry.Path:is_dir() then
      --             stopinsert(callback)(prompt_bufnr)
      --         elseif callback_dir then
      --             callback_dir(prompt_bufnr)
      --         end
      --     end
      -- end

      return {
        defaults = {
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          vimgrep_arguments = {
            "rg",
            "--hidden",
            "--follow",
            "--color=never",
            "--column",
            "--line-number",
            "--with-filename",
            "--no-heading",
            "--smart-case",
            "--trim", -- remove indentation
          },
          file_ignore_patterns = {
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.otf",
            "%.ttf",
            "%.DS_Store",
            "^.git/",
            "node%_modules/.*",
            "^site-packages/",
            "%.yarn/.*",
          },
          scroll_strategy = "cycle",
          sorting_strategy = "ascending",
          theme = "ivy",
          layout_config = {
            -- height = 35,
            horizontal = { preview_width = 0.55 },
          },
          layout_strategy = "bottom_pane",
          prompt_prefix = "  ",
          selection_caret = " ",
          cycle_layout_list = { -- digunakan ketika use <c-l>
            "flex",
            "horizontal",
            "vertical",
            "bottom_pane",
            "center",
          },
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          mappings = {
            i = {
              ["<ESC>"] = actions.close,

              ["<C-down>"] = actions.cycle_history_next,
              ["<C-up>"] = actions.cycle_history_prev,

              ["<a-n>"] = actions.results_scrolling_up,
              ["<a-p>"] = actions.results_scrolling_down,

              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,

              ["<C-a>"] = actions.toggle_all,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,

              ["<CR>"] = stopinsert(actions.select_default),
              ["<C-s>"] = stopinsert(actions.select_horizontal),
              ["<C-v>"] = stopinsert(actions.select_vertical),
              ["<C-t>"] = stopinsert(actions.select_tab),

              ["<C-r>"] = actions.to_fuzzy_refine,

              ["<F1>"] = actions.which_key, -- keys from pressing <C-/>
              ["<F4>"] = layout_actions.cycle_layout_next,
              ["<F5>"] = layout_actions.toggle_preview,
              ["<F3>"] = function(prompt_bufnr)
                local action_state = require "telescope.actions.state"
                local picker = action_state.get_current_picker(prompt_bufnr)
                picker.layout_config = picker.layout_config or {}
                picker.layout_config[picker.layout_strategy] = picker.layout_config[picker.layout_strategy] or {}

                if telescope_layout_strategy_height == 0 then
                  telescope_layout_strategy_height = picker.layout_config[picker.layout_strategy].height
                end

                if telescope_toggle_fullscreen then
                  picker.layout_config[picker.layout_strategy].height = 90
                  telescope_toggle_fullscreen = false
                else
                  picker.layout_config[picker.layout_strategy].height = telescope_layout_strategy_height
                  telescope_toggle_fullscreen = true
                end

                picker:full_layout_update()
              end,
            },
            n = {
              ["<ESC>"] = actions.close,
              ["q"] = actions.close,

              ["<C-down>"] = actions.cycle_history_next,
              ["<C-up>"] = actions.cycle_history_prev,

              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,

              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,

              ["<a-n>"] = actions.results_scrolling_up,
              ["<a-p>"] = actions.results_scrolling_down,

              ["<F5>"] = layout_actions.toggle_preview,
              ["<F1>"] = actions.which_key, -- keys from pressing <C-/>
            },
          },
        },
        pickers = {
          highlights = themes.get_ivy {},
          buffers = themes.get_ivy {
            sort_mru = true,
            sort_lastused = true,
            show_all_buffers = true,
            ignore_current_buffer = true,
            previewer = false,
            mappings = {
              i = { ["<c-x>"] = "delete_buffer" },
              n = { ["<c-x>"] = "delete_buffer" },
            },
          },
          oldfiles = dropdown {},
          builtin = themes.get_ivy {},
          filetypes = themes.get_ivy {},
          find_files = themes.get_ivy { hidden = true },
          help_tags = { theme = "ivy" },
          live_grep = themes.get_ivy {
            file_ignore_patterns = { ".git/", "%.svg", "%.lock" },
            max_results = 2000,
          },
          -- current_buffer_fuzzy_find = dropdown {
          --   previewer = false,
          --   shorten_path = false,
          -- },
          diagnostics = dropdown {},
          colorscheme = { enable_preview = true },
          keymaps = dropdown {
            layout_config = { height = 50, width = 0.8 },
          },

          lsp_definitions = themes.get_ivy {},
          lsp_references = {
            sorting_strategy = "descending",
            layout_strategy = "vertical", -- ivy, cursor, dropdown
            theme = "dropdown",
            preview_title = false,
            path_display = { "shorten" },
            prompt_title = "References",
            layout_config = {
              width = 0.80,
              height = 0.80,
              -- preview_width = 0.70,
            },
          },
        },
        extensions = {
          lazy = themes.get_ivy {},
          octo = themes.get_ivy {},
          -- dap = themes.get_ivy {}, -- not working
          live_grep_args = themes.get_ivy {
            auto_quoting = false, -- enable/disable auto-quoting
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TelescopeSetMap", { clear = true }),
        desc = "Set terminal mappings in telescope buffer.",
        pattern = "TelescopePrompt",
        callback = function(bufn)
          vim.keymap.set("i", "<F2>", function()
            vim.cmd "Telescope builtin"
          end, { buffer = bufn.buf })
          vim.keymap.set("t", "<a-x>", "<a-x>", { buffer = bufn.buf })
        end,
      })
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "corrode"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "fzf"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "grepqf"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "live_grep_args"
      -----@diagnostic disable-next-line: undefined-field
      --telescope.load_extension "luasnip"

      local corrode_cfg = require "telescope._extensions.corrode.config"
      corrode_cfg.values = { theme = "ivy" }
    end,
  },
  -- GRUG-FAR.NVIM
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" },
    keys = {
      {
        "<Leader>uF",
        "<CMD>GrugFar<CR>",
        desc = "Misc: open grug [grugfar]",
      },
      {
        "<Leader>uF",
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          }
        end,
        mode = { "v" },
        desc = "Misc: open grug (visual) [grugfar]",
      },
    },
    opts = function()
      local norm = Highlight.get("Directory", "fg")
      local bg = Highlight.tint(norm, -0.6)
      local fg = Highlight.tint(norm, 0.5)
      Highlight.plugin("grugfarHiCo", {
        {
          GrugFarResultsPath = {
            bg = bg,
            fg = fg,
            bold = true,
          },
        },
      })
      return {
        keymaps = {
          replace = { n = "<c-c>" },
          qflist = { n = "<c-q>" },
          syncLocations = { n = "<Localleader>s" },
          syncLine = { n = "<Localleader>l" },
          close = { n = "q" },
          historyOpen = { n = "<Leader>h" },
          historyAdd = { n = "<Leader>A" },
          refresh = { n = "R" },
          gotoLocation = { n = "<enter>" },
          pickHistoryEntry = { n = "<enter>" },
        },
      }
    end,
  },
  -- TODOCOMMENTS
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    cmd = { "TodoTrouble", "TodoTelescope" },
    keys = {
      {
        "<Leader>fT",
        function()
          RUtils.todocomments.search_global {
            title = "Todo Global",
          }
          vim.cmd "normal! zz"
        end,
        desc = "Misc: todo global dir (fzflua) [todo-comments]",
      },
      {
        "<Leader>ft",
        function()
          RUtils.todocomments.search_local {
            title = "Todo Curbuf",
          }
          vim.cmd "normal! zz"
        end,
        desc = "Misc: todo local dir (fzflua) [todo-comments]",
      },
      -- { "<Leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      keywords = {
        FIX = {
          icon = RUtils.config.icons.misc.tools,
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        WARN = {
          icon = RUtils.config.icons.misc.bug,
          color = "warning",
          alt = { "WARNING", "WARN" },
        },
        TODO = { icon = RUtils.config.icons.misc.check_big, color = "info" },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
      -- merge_keywords = false,
      highlight = {
        before = "", -- "fg", "bg", or empty
        keyword = "wide", -- "fg", "bg", "wide", or empty
        after = "fg", -- "fg", "bg", or empty
        pattern = [[.*<(KEYWORDS)*:]],
        comments_only = true, -- highlight only inside comments using treesitter
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      colors = {
        error = { "#DC2626" },
        warning = { "#FBBF24" },
        info = { "#2563EB" },
        hint = { "#10B981" },
        default = { "#7C3AED" },
      },
      search = {
        command = "rg",
        pattern = [[\b(KEYWORDS):\s]], -- ripgrep regex
        args = {
          "--color=never",
          "--no-heading",
          "--follow",
          "--hidden",
          "--with-filename",
          "--line-number",
          "--column",
          "-g",
          "!node_modules/**",
          "-g",
          "!.git/**",
        },
      },
    },
  },
  -- TROUBLE.NVIM
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "gR",
        "<cmd>Trouble lsp_references toggle focus=true<cr>",
        desc = "LSP: references [trouble]",
      },
      -- {
      --   "gi",
      --   "<cmd>Trouble lsp_implementations toggle focus=true win.position=right<cr>",
      --   desc = "LSP: implementations [trouble]",
      -- },
      -- {
      --   "gO",
      --   "<cmd>Trouble lsp_outgoing_calls toggle focus=true win.position=right<cr>",
      --   desc = "LSP: outgoing calls [trouble]",
      -- },
      -- {
      --   "gI",
      --   "<cmd>Trouble lsp_incoming_calls toggle focus=true win.position=right<cr>",
      --   desc = "LSP: incomming calls [trouble]",
      -- },
      -- {
      --   "gt",
      --   "<cmd>Trouble lsp_type_definitions<CR>",
      --   desc = "LSP: type definitions [trouble]",
      -- },
      {
        "<Leader>xD",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end

          vim.cmd [[Trouble diagnostics toggle]]
        end,
        desc = "Diagnostic: workspaces diagnostics [trouble]",
      },
      {
        "<Leader>xd",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd [[Trouble diagnostics toggle filter.buf=0]]
        end,
        desc = "Diagnostic: document diagnostisc [trouble]",
      },
      {
        "<Leader>xl",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd "Trouble loclist toggle"
        end,
        desc = "Qf: open location list with [trouble]",
      },
      {
        "<Leader>xq",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd "Trouble qflist toggle"
        end,
        desc = "Qf: open quickfix list with [trouble]",
      },
    },
    opts = function()
      local icons_lsp = RUtils.config.icons.kinds
      Highlight.plugin("troubleColHi", {
        theme = {
          ["*"] = {
            { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn" } } },
            { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError" } } },
            { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint" } } },
            { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
            { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
            { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },

            { TroubleIndent = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1.5 } } },
            { TroubleIndentLast = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1.5 } } },
            { TroubleIndentFoldClosed = { bg = "NONE" } },

            -- { TroubleFile = { bg = "NONE", fg = { from = "Directory", attr = "fg", alter = 0.1 } } },
            -- { TroubleTextOther = { bg = "NONE", bold = true } },
            -- { TroubleLocation = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg" } } },
            -- { TroubleFoldIcon = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },

            -- Directory
            {
              TroubleDirectory = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
              },
            },
            {
              TroubleFsCount = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
                fg = { from = "Normal", attr = "fg", alter = -0.1 },
              },
            },

            -- LSP
            {
              TroubleLspFilename = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
              },
            },
            {
              TroubleLspCount = {
                bg = { from = "Normal", attr = "bg", alter = 1 },
                fg = { from = "Normal", attr = "fg" },
              },
            },

            -- Diagnostics
            {
              TroubleDiagnosticsBasename = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
              },
            },
            {
              TroubleDiagnosticsCount = {
                bg = { from = "Normal", attr = "bg", alter = 1 },
                fg = { from = "Normal", attr = "fg" },
              },
            },

            -- TodoTrouble
            {
              TroubleTodoFilename = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
              },
            },

            -- QF
            {
              TroubleQfFilename = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
              },
            },
            {
              TroubleQfPos = {
                bg = "NONE",
                fg = { from = "WinSeparator", attr = "fg", alter = 0.4 },
              },
            },
            {
              TroubleQfCount = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
                fg = { from = "Normal", attr = "fg", alter = -0.1 },
              },
            },

            -- Dunno
            {
              TroubleCode = {
                bg = "NONE",
                fg = { from = "ErrorMsg", attr = "fg" },
                underline = false,
              },
            },
          },
          ["lackluster"] = {
            { TroubleIndent = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 5 } } },
            { TroubleIndentLast = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 5 } } },
            { TroubleFoldIcon = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 6 } } },

            { TroubleQfPos = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.4 } } },
            {
              TroubleQfCount = {
                bg = { from = "Normal", attr = "bg", alter = 1.5 },
                fg = { from = "WinSeparator", attr = "fg", alter = 3 },
              },
            },
          },
          ["rose-pine-dawn"] = {
            { TroubleIndent = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
            { TroubleIndentLast = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
            { TroubleFoldIcon = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = -0.1 } } },

            -- Directory
            {
              TroubleDirectory = {
                bg = { from = "Normal", attr = "bg", alter = -0.1 },
              },
            },
            {
              TroubleFsCount = {
                bg = { from = "Normal", attr = "bg", alter = -0.2 },
                fg = { from = "Normal", attr = "fg", alter = -0.1 },
              },
            },

            -- Diagnostics
            {
              TroubleDiagnosticsBasename = {
                bg = { from = "Normal", attr = "bg", alter = -0.1 },
              },
            },
            {
              TroubleDiagnosticsCount = {
                bg = { from = "Normal", attr = "bg", alter = -0.2 },
                fg = { from = "Normal", attr = "fg" },
              },
            },

            -- QF
            {
              TroubleQfFilename = {
                bg = { from = "Normal", attr = "bg", alter = -0.1 },
              },
            },
            { TroubleQfPos = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
            {
              TroubleQfCount = {
                bg = { from = "Normal", attr = "bg", alter = -0.2 },
                fg = { from = "WinSeparator", attr = "fg", alter = 5 },
              },
            },
          },
          ["dawnfox"] = {
            { TroubleIndent = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
            { TroubleIndentLast = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = -0.1 } } },
            { TroubleFoldIcon = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = -0.1 } } },

            -- Directory
            {
              TroubleDirectory = {
                bg = { from = "Normal", attr = "bg", alter = -0.1 },
              },
            },
            {
              TroubleFsCount = {
                bg = { from = "Normal", attr = "bg", alter = -0.2 },
                fg = { from = "Normal", attr = "fg", alter = -0.1 },
              },
            },

            -- Diagnostics
            {
              TroubleDiagnosticsBasename = {
                bg = { from = "Normal", attr = "bg", alter = -0.1 },
              },
            },
            {
              TroubleDiagnosticsCount = {
                bg = { from = "Normal", attr = "bg", alter = -0.2 },
                fg = { from = "Normal", attr = "fg" },
              },
            },

            -- QF
            {
              TroubleQfFilename = {
                bg = { from = "Normal", attr = "bg", alter = -0.1 },
              },
            },
            { TroubleQfPos = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = -0.1 } } },
            {
              TroubleQfCount = {
                bg = { from = "Normal", attr = "bg", alter = -0.2 },
                fg = { from = "WinSeparator", attr = "fg", alter = 5 },
              },
            },
          },
          ["selenized"] = {
            { TroubleIndent = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.5 } } },
            { TroubleIndentLast = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 0.5 } } },
            { TroubleFoldIcon = { bg = "NONE", fg = { from = "Normal", attr = "bg", alter = 1 } } },

            -- Directory
            {
              TroubleDirectory = {
                bg = { from = "Normal", attr = "bg", alter = 0.3 },
              },
            },
            {
              TroubleFsCount = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
                fg = { from = "Normal", attr = "fg", alter = -0.1 },
              },
            },

            -- QF
            {
              TroubleQfFilename = {
                bg = { from = "Normal", attr = "bg", alter = 0.3 },
              },
            },
            {
              TroubleQfPos = {
                bg = "NONE",
                fg = { from = "WinSeparator", attr = "fg", alter = 0.4 },
              },
            },
            {
              TroubleQfCount = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
                fg = { from = "Normal", attr = "fg", alter = -0.1 },
              },
            },

            -- Diagnostics
            {
              TroubleDiagnosticsBasename = {
                bg = { from = "Normal", attr = "bg", alter = 0.3 },
              },
            },
            {
              TroubleDiagnosticsCount = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
                fg = { from = "Normal", attr = "fg" },
              },
            },

            { TroubleQfPos = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
            {
              TroubleQfCount = {
                bg = { from = "Normal", attr = "bg", alter = 1 },
                fg = { from = "WinSeparator", attr = "fg", alter = 5 },
              },
            },
          },
          ["sweetie"] = {
            { TroubleQfPos = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
          },
          ["tender"] = {
            { TroubleQfPos = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
          },
          ["tokyonight-night"] = {
            { TroubleQfPos = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
            {
              TroubleQfCount = {
                bg = { from = "Normal", attr = "bg", alter = 3 },
                fg = { from = "WinSeparator", attr = "fg", alter = 5 },
              },
            },
          },
          ["tokyonight-storm"] = {
            { TroubleQfPos = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
            {
              TroubleQfCount = {
                bg = { from = "Normal", attr = "bg", alter = 1.5 },
                fg = { from = "WinSeparator", attr = "fg", alter = 3 },
              },
            },
          },
        },
      })
      return {
        icons = {
          kinds = {
            Array = icons_lsp.Array,
            Boolean = icons_lsp.Boolean,
            Class = icons_lsp.Classs,
            Constant = icons_lsp.Constant,
            Constructor = icons_lsp.Constructor,
            Enum = icons_lsp.Enum,
            EnumMember = icons_lsp.EnumMember,
            Event = icons_lsp.Event,
            Field = icons_lsp.Field,
            File = icons_lsp.File,
            Function = icons_lsp.Function,
            Interface = icons_lsp.Interface,
            Key = icons_lsp.Interface,
            Method = icons_lsp.Key,
            Module = icons_lsp.Method,
            Namespace = icons_lsp.Namespace,
            Null = icons_lsp.Null,
            Number = icons_lsp.Number,
            Object = icons_lsp.Object,
            Operator = icons_lsp.Operator,
            Package = icons_lsp.Package,
            Property = icons_lsp.Property,
            String = icons_lsp.String,
            Struct = icons_lsp.Struct,
            TypeParameter = icons_lsp.TypeParameter,
            Variable = icons_lsp.Variable,
          },
        },
        keys = {
          ["<esc>"] = "cancel",
          ["q"] = "close",
          ["o"] = "jump",
          ["<c-n>"] = "next",
          ["<c-p>"] = "prev",
        },
      }
    end,
  },
}
