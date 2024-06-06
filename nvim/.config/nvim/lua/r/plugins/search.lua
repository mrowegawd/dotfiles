local Highlight = require "r.settings.highlights"

local have_make = vim.fn.executable "make" == 1
local have_cmake = vim.fn.executable "cmake" == 1

local rg_opts = "--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -e "
local fd_opts = [[--color never --type f --hidden --follow --exclude .git --exclude '*.pyc']]

return {
  -- FLASH.NVIM
  {
    "folke/flash.nvim",
    opts = function()
      Highlight.plugin("flash.nvim", {
        {
          FlashMatch = {
            bg = "white",
            fg = "red",
            bold = true,
          },
        },
        {
          FlashLabel = {
            fg = "black",
            bg = "yellow",
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
  -- FZF-LUA
  {
    "ibhagwan/fzf-lua",
    version = false,
    cmd = "FzfLua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
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
            RgFlowInputPath = { link = "NormalFloat" },
            RgFlowInputBg = { link = "NormalFloat" },
            RgFlowHeadLine = { link = "Error" },
            RgFlowInputFlags = { link = "NormalFloat" },
            RgFlowInputPattern = { link = "GitSignsAdd", bold = true },
          },
        },
      },
    },
    keys = {
      { "sf", require("fzf-lua").buffers, desc = "Fzflua: select buffers" },
      { "sG", require("fzf-lua").lines, desc = "Fzflua: live grep on buffers" },
      { "sH", require("fzf-lua").oldfiles, desc = "Fzflua: history buffer" },
      { "z=", require("fzf-lua").spell_suggest, desc = "Fzflua: spell suggest" },
      { "sg", require("fzf-lua").blines, desc = "FzfLua: live grep on curbuf" },
      {
        "sg",
        function()
          require("fzf-lua").blines { query = vim.fn.expand "<cword>" }
        end,
        desc = "Winav: live grep on curbuf (visual)",
        mode = { "v" },
      },
      {
        "sG",
        function()
          require("fzf-lua").lines { query = vim.fn.expand "<cword>" }
        end,
        desc = "Winav: live grep on buffers (visual) [fzflua]",
        mode = { "v" },
      },
      { "<Leader>ff", require("fzf-lua").files, desc = "Fzflua: find files", mode = { "n", "v" } },
      { "<Leader>fC", require("fzf-lua").commands, desc = "Fzflua: commands", mode = "n" },
      {
        "gs",
        function()
          require("fzf-lua").lsp_document_symbols {
            winopts = {
              fullscreen = false,
            },
          }
        end,
        desc = "LSP: document symbols [fzflua]",
      },
      {
        "gS",
        function()
          require("fzf-lua").lsp_workspace_symbols {
            winopts = {
              fullscreen = true,
            },
          }
        end,
        desc = "LSP: workspace symbols [fzflua]",
      },
      { "<Leader>fl", require("fzf-lua").resume, desc = "Fzflua: resume (last search)" },
      { "<Leader>fL", require("fzf-lua").command_history, desc = "Fzflua: command history" },
      { "<Leader>fg", require("fzf-lua").live_grep_glob, desc = "Fzflua: live grep" },
      { "<Leader>fg", require("fzf-lua").grep_visual, desc = "Fzflua: live grep (visual)", mode = { "v" } },
      { "<Leader>fc", require("fzf-lua").changes, desc = "Fzflua: changes" },
      { "<Leader>fj", require("fzf-lua").jumps, desc = "Fzflua: jumps" },
      { "<Leader>fm", require("fzf-lua").marks, desc = "Fzflua: marks" },
      { "<Leader>fs", require("fzf-lua").search_history, desc = "Fzflua: search history" },
      {
        "<Leader>fh",
        function()
          local j = vim.fn.expand "<cword>"
          require("fzf-lua").help_tags { query = j }
        end,
        desc = "Fzflua: help tags",
      },
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
              RUtils.warn(selection .. "-> Not found ", { title = "FzfLua Help" })
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

      local img_preview_command = vim.fn.executable "ueberzug" == 1 and { "ueberzug" } or nil
      local html_preview_command = vim.fn.executable "w3m" == 1 and { "w3m", "-dump" } or nil
      local pdf_preview_command = vim.fn.executable "pdftotext" == 1
          and { "pdftotext", "-l", "10", "-nopgbrk", "-nodiag", "-q", "<file>", "-" }
        or nil

      return {
        winopts_fn = function()
          local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
          local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

          local win_height = math.ceil(lines * 0.5)
          local win_width = math.ceil(columns * 1)
          local col = math.ceil((columns - win_width) * 1)
          local row = math.ceil((lines - win_height) * 1 - 3)
          return {
            width = win_width,
            height = win_height,
            row = row,
            col = col,
            preview = {
              vertical = "down:55%", -- up|down:size
              horizontal = "right:45%", -- right|left:size
            },
          }
        end,
        fzf_colors = {
          ["fg"] = { "fg", "CmpItemAbbr" },
          ["bg"] = { "bg", "NormalFloat" },
          ["hl"] = { "fg", "CmpItemAbbrMatch" },
          ["fg+"] = { "fg", "PmenuSel" },
          ["bg+"] = { "bg", "PmenuSel" },
          ["hl+"] = { "fg", "CmpItemAbbrMatchFuzzy" },
          ["info"] = { "fg", "PreProc" },
          ["prompt"] = { "fg", "Conditional" },
          ["pointer"] = { "fg", "CmpItemAbbrMatch" },
          ["marker"] = { "fg", "Keyword" },
          ["spinner"] = { "fg", "Label" },
          ["header"] = { "fg", "Comment" },
          ["gutter"] = { "bg", "NormalFloat" },
        },
        previewers = {
          builtin = {
            treesitter = {
              enable = true,
              disable = { "tex", "markdown" },
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
            ["<F2>"] = "toggle-fullscreen",
            ["<F4>"] = "toggle-preview-cw",

            ["<a-p>"] = "toggle-preview",

            ["<c-d>"] = "preview-page-down",
            ["<c-u>"] = "preview-page-up",
          },
          fzf = {
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
          },
        },
        files = {
          -- debug = true,
          prompt = "   ",
          cwd_prompt = false,
          no_header = true, -- disable default header
          winopts = { title = RUtils.fzflua.format_title("Files", "") },
          fzf_opts = { ["--header"] = [[Alt-y: copy/yank path | Alt-e: rgflow]] },
          fd_opts = fd_opts,
          git_icons = false,
          formatter = "path.filename_first",
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
            ["alt-e"] = function(_, args)
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
            ["alt-y"] = function(selected, _)
              local slice_num_str = selected[1]:match ".*\xe2\x80\x82()"
              local pth = selected[1]:sub(slice_num_str)
              vim.fn.setreg([[+]], pth)

              RUtils.info("copy: " .. pth, { title = "Path" })

              require("fzf-lua").actions.resume()
            end,
          },
        },
        git = {
          files = {
            prompt = "   ",
            winopts = { title = RUtils.fzflua.format_title("Git Files", "") },
            cmd = "git ls-files --exclude-standard",
            multiprocess = true, -- run command in a separate process
            git_icons = true, -- show git icons?
            file_icons = true, -- show file icons?
            color_icons = true, -- colorize file|git icons
          },
          status = {
            prompt = "   ",
            winopts = { title = RUtils.fzflua.format_title("Git Status", "", "GitSignsAdd") },
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
              ["ctrl-s"] = { actions.git_stage_unstage, actions.resume },
              ["ctrl-x"] = { actions.git_reset, actions.resume },
            },
          },
          commits = {
            prompt = "   ",
            preview = "git show --pretty='%Cred%H%n%Cblue%an <%ae>%n%C(yellow)%cD%n%Cgreen%s' --color {1}",
            cmd = "git log --color --pretty=format:'%C(blue)%h%Creset "
              .. "%Cred(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            winopts = { title = RUtils.fzflua.format_title("Repo Commits", "", "GitSignsAdd") },
            fzf_opts = {
              ["--header"] = [[Ctrl-o: open browser | Alt-y: hash copy | Ctrl-z: diff commit | Ctrl-x: compare curdiff]],
            },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["right"] = actions.git_checkout,
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]

                vim.api.nvim_command(":GBrowse " .. commit_hash)

                RUtils.info("Browse commit hash: " .. commit_hash, { title = "FZFGit" })
              end,
              ["alt-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                vim.fn.setreg("+", commit_hash)

                RUtils.info("Hash: " .. commit_hash .. " copied", { title = "FZFGit" })

                require("fzf-lua").actions.resume()
              end,
              ["ctrl-z"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash

                vim.api.nvim_command(cmdmsg)

                RUtils.info("All diff " .. commit_hash, { title = "FZFGit: commits" })
              end,
              ["ctrl-x"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                local filename = RUtils.fzf_diffview.git_relative_path(vim.api.nvim_get_current_buf())

                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash .. " -- " .. filename

                vim.api.nvim_command(cmdmsg)

                RUtils.info(
                  "Compare diff " .. commit_hash .. " with current file \n" .. filename,
                  { title = "FZFGit: commits" }
                )
              end,
            },
          },
          bcommits = {
            -- debug = true,
            prompt = "   ",
            preview = "git diff --color {1}~1 {1} -- <file>",
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            cmd = "git log --color --pretty=format:'%C(blue)%h%Creset "
              .. "%Cred(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset' {file}",
            winopts = { title = RUtils.fzflua.format_title("Curbuf Commits", "", "GitSignsAdd") },
            fzf_opts = {
              ["--header"] = [[Ctrl-o: open browser | Alt-y: hash copy | Ctrl-z: diff commit | Ctrl-x: compare curdiff]],
            },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]

                RUtils.info("Browse commit hash: " .. commit_hash, { title = "FZFGit" })

                vim.api.nvim_command(":GBrowse " .. commit_hash)
              end,
              ["alt-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                vim.fn.setreg("+", commit_hash)

                RUtils.info("Hash: " .. commit_hash .. " copied", { title = "FZFGit" })

                require("fzf-lua").actions.resume()
              end,
              ["ctrl-z"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash

                vim.api.nvim_command(cmdmsg)

                RUtils.info("All diff " .. commit_hash, { title = "FZFGit: bcommits" })
              end,
              ["ctrl-x"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = RUtils.fzf_diffview.split_string(selection, " ")[1]
                local filename = RUtils.fzf_diffview.git_relative_path(vim.api.nvim_get_current_buf())

                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash .. " -- " .. filename

                vim.api.nvim_command(cmdmsg)

                RUtils.info(
                  "Compare diff " .. commit_hash .. " with current file \n" .. filename,
                  { title = "FZFGit: bcommits" }
                )
              end,
            },
          },
          branches = {
            prompt = "  ",
            cmd = "git branch --all --color",
            preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
            winopts = {
              title = RUtils.fzflua.format_title("Branches", ""),
              height = 0.3,
              row = 0.4,
            },
            actions = {
              ["default"] = actions.git_switch,
            },
          },
          stash = {
            prompt = "   ",
            --     cmd = "git --no-pager stash list",
            --     preview = "git --no-pager stash show --patch --color {1}",
            winopts = {
              title = RUtils.fzflua.format_title("Stash", "", "GitSignsAdd"),
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
          prompt = "  ",
          no_header = true, -- disable default header
          rg_opts = rg_opts,
          fzf_opts = { ["--header"] = [[Ctrl-g: grep_lgrep | Alt-e: rgflow]] },
          winopts = {
            title = RUtils.fzflua.format_title(
              "Grep",
              RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope2)
            ),
          },
          formatter = "path.filename_first",
          multiprocess = true,
          winopts_fn = function()
            local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
            local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

            local win_height = math.ceil(lines * 0.8)
            local win_width = math.ceil(columns * 1)
            local col = math.ceil((columns - win_width) * 1)
            local row = math.ceil((lines - win_height) * 1 - 3)
            return {
              width = win_width,
              height = win_height,
              row = row,
              col = col,
              preview = {
                vertical = "down:55%", -- up|down:size
                horizontal = "up:45%", -- right|left:size
              },
            }
          end,
          actions = {
            ["ctrl-g"] = { actions.grep_lgrep },
            ["alt-e"] = function(_, args)
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
          prompt = "  ",
          files_only = true,
          actions = {
            ["ctrl-x"] = { actions.arg_del, actions.resume },
          },
        },
        oldfiles = {
          prompt = "   ",
          winopts = { title = RUtils.fzflua.format_title("History", "") },
          cwd_only = true,
          stat_file = true, -- verify files exist on disk
          include_current_session = false, -- include bufs from current session
        },
        keymaps = {
          winopts = { preview = { hidden = "hidden" } },
        },
        buffers = {
          prompt = "   ",
          winopts = { title = RUtils.fzflua.format_title("Buffers", "󰈙") },
          cwd = nil, -- buffers list for a given dir
          fzf_opts = {
            -- ["--delimiter"] = "' '",
            ["--with-nth"] = "-1..",
          },
          actions = {
            ["alt-q"] = { actions.file_sel_to_qf },
          },
        },
        highlights = {
          prompt = "   ",
          winopts = { title = RUtils.fzflua.format_title("Highlights", RUtils.config.icons.misc.circle) },
        },
        helptags = {
          prompt = "   ",
          winopts = { title = RUtils.fzflua.format_title("Help", "󰋖") },
        },
        tabs = {
          prompt = "  ",
          tab_title = "Tab",
          tab_marker = "<<",
          file_icons = true, -- show file icons?
          color_icons = true, -- colorize file|git icons
          actions = {
            -- actions inherit from 'actions.buffers' and merge
            ["default"] = actions.buf_switch,
            ["ctrl-x"] = { actions.buf_del, actions.resume },
          },
          fzf_opts = {
            -- hide tabnr
            -- ["--delimiter"] = "'[\\):]'",
            ["--with-nth"] = "2..",
          },
        },
        lines = {
          prompt = "   ",
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

            -- ["alt-l"] = actions.buf_sel_to_ll,
            ["ctrl-q"] = actions.buf_sel_to_qf,

            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
        },
        blines = {
          prompt = "   ",
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
            ["ctrl-g"] = { actions.grep_lgrep },
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
          live_preview = true, -- apply the colorscheme on preview?
          actions = { ["default"] = actions.colorscheme },
          winopts = { height = 0.55, width = 0.30 },
        },
        quickfix = {
          winopts = {
            title = RUtils.fzflua.format_title("[QF]", "󰈙"),
          },
          file_icons = true,
          git_icons = true,
        },
        quickfix_stack = {
          winopts = {
            title = RUtils.fzflua.format_title("[QF]", "󰈙"),
          },
          marker = ">", -- current list marker
        },
        lsp = {
          cwd_only = true,
          no_action_zz = true,
          symbols = {
            no_action_zz = true,
            symbol_style = 1,
            symbol_icons = RUtils.config.icons.kinds,
            fzf_opts = {
              ["--reverse"] = false,
              -- ["--scrollbar"] = "▓",
            },
            winopts = {
              title = RUtils.fzflua.format_title("Symbols", ""),
            },
          },
          code_actions = RUtils.fzflua.cursor_dropdown {
            winopts = {
              title = RUtils.fzflua.format_title("Code Actions", "󰌵", "@type"),
            },
          },
          finder = {
            prompt = "  ",
            no_action_zz = true,
            winopts = {
              title = RUtils.fzflua.format_title("LSP Finder", ""),
            },
          },
        },
        diagnostics = {
          prompt = "  ",
          winopts = { title = RUtils.fzflua.format_title("Diagnostics", "", "DiagnosticError") },
          cwd_only = false,
          file_icons = true,
          git_icons = false,
          diag_icons = true,
          icon_padding = "", -- add padding for wide diagnostics signs
        },
        complete_path = {
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
      require("fzf-lua").setup(opts)
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
      -- { "<Leader>bg", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope: live_grep on buffers" },
      -- { "<Leader>bo", "<CMD>Telescope oldfiles<CR>", desc = "Telescope: oldfiles" },
      -- { "<Leader>fh", "<CMD>Telescope help_tags<CR>", desc = "Telescope: help tags" },
      -- { "<Leader>fC", "<CMD>Telescope commands<CR>", desc = "Telescope: commands" },
      -- { "<Leader>fl", "<CMD>Telescope resume<CR>", desc = "Telescope: resume (last search)" },
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
      ---@return table
      ---@diagnostic disable-next-line: redefined-local
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
          -- path_display = function(opts, path)
          --     local tail = require("telescope.utils").path_tail(path)
          --     return string.format("%s (%s)", tail, path)
          -- end,
          -- path_display = "smart",
          sorting_strategy = "descending",
          scroll_strategy = "cycle",
          layout_strategy = "flex",
          layout_config = {
            horizontal = { preview_width = 0.55 },
          },
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
              ["<esc>"] = actions.close,
              -- ["<c-c>"] = actions.close,

              -- ["<c-o>"] = trouble.open_with_trouble,

              ["<s-down>"] = actions.cycle_history_next,
              ["<s-up>"] = actions.cycle_history_prev,

              ["<c-f>"] = actions.results_scrolling_up,
              ["<c-b>"] = actions.results_scrolling_down,

              ["<c-u>"] = actions.preview_scrolling_up,
              ["<c-d>"] = actions.preview_scrolling_down,

              -- ["<c-l>"] = false, -- use `false` to disable mapping

              ["<a-a>"] = actions.toggle_all,
              ["<a-q>"] = actions.send_to_qflist + actions.open_qflist,

              ["<CR>"] = stopinsert(actions.select_default),
              ["<C-s>"] = stopinsert(actions.select_horizontal),
              ["<C-v>"] = stopinsert(actions.select_vertical),
              ["<C-t>"] = stopinsert(actions.select_tab),

              ["<c-r>"] = actions.to_fuzzy_refine,
              ["<F1>"] = actions.which_key, -- keys from pressing <C-/>

              ["<F4>"] = layout_actions.cycle_layout_next,
              -- ["<c-h>"] = layout_actions.cycle_layout_prev,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<c-p>"] = layout_actions.toggle_preview,
              ["<a-p>"] = layout_actions.toggle_preview,

              ["<jk>"] = function()
                vim.cmd.stopinsert()
              end,
            },
            n = {
              ["<esc>"] = actions.close,
              ["q"] = actions.close,

              ["<c-f>"] = actions.results_scrolling_up,
              ["<c-b>"] = actions.results_scrolling_down,

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
          -- dap = themes.get_ivy {}, -- not working
          live_grep_args = themes.get_ivy {
            auto_quoting = false, -- enable/disable auto-quoting
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      ---@diagnostic disable-next-line: undefined-field
      telescope.setup(opts)
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "corrode"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "fzf"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "grepqf"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "live_grep_args"
      ---@diagnostic disable-next-line: undefined-field

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
        "<Leader><s-f>",
        "<CMD>GrugFar<CR>",
        desc = "Misc: open grug [grugfar]",
      },
      {
        "<Leader>sf",
        function()
          require("grug-far").grug_far { prefills = { flags = vim.fn.expand "%" } }
        end,
        desc = "Misc: open grug on curbuf [grugfar]",
      },
    },
    opts = {
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
    },
  },
  -- TODOCOMMENTS
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    cmd = { "TodoTrouble", "TodoTelescope" },
    keys = {
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Misc: todo trouble (trouble) [todo-comments]" },
      {
        "<leader>xT",
        "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
        desc = "Misc: search Todo/Fix/Fixme (trouble) [todo-comments]",
      },
      {
        "<leader>sT",
        function()
          RUtils.todocomments.search_global {
            title = "Todo Global",
          }
        end,
        desc = "Misc: todo global dir (fzflua) [todo-comments]",
      },
      {
        "<leader>st",
        function()
          RUtils.todocomments.search_local {
            title = "Todo Curbuf",
          }
        end,
        desc = "Misc: todo local dir (fzflua) [todo-comments]",
      },
      -- { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
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
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
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
  -- DRESSING
  {
    "stevearc/dressing.nvim",
    event = "VimEnter",
    -- init = function()
    --   vim.ui.select = function(...)
    --     require("lazy").load { plugins = { "dressing.nvim" } }
    --     return vim.ui.select(...)
    --   end
    --   vim.ui.input = function(...)
    --     require("lazy").load { plugins = { "dressing.nvim" } }
    --     return vim.ui.input(...)
    --   end
    -- end,
    opts = {
      input = { enabled = true },
      select = {
        -- priority: use fzf_lua first before anything else
        backend = { "fzf_lua", "builtin" },
        builtin = {
          border = RUtils.config.icons.border.line,
          min_height = 10,
          win_options = { winblend = 10 },
          mappings = { n = { ["q"] = "Close" } },
        },
        get_config = function(opts)
          opts.prompt = opts.prompt and opts.prompt:gsub(":", "")
          if opts.kind == "codeaction" then
            return {
              backend = "fzf_lua",
              fzf_lua = RUtils.fzflua.cursor_dropdown {
                prompt = "  ",
                winopts = { title = opts.prompt, relative = "cursor" },
              },
            }
          end
          if opts.kind == "orgmode" then
            return {
              backend = "nui",
              nui = {
                position = "90%",
                border = { style = RUtils.config.icons.border.line },
                min_width = math.floor(vim.o.columns / 2 - 50),
              },
            }
          end
          if opts.kind == "pojokan" then
            local col, row = RUtils.fzflua.rectangle_win_pojokan()
            return {
              backend = "fzf_lua",
              fzf_lua = RUtils.fzflua.cursor_dropdown {
                winopts = {
                  title = opts.prompt,
                  relative = "editor",
                  col = col,
                  row = row,
                },
                prompt = "  ",
              },
            }
          end
          return {
            backend = "fzf_lua",
            fzf_lua = RUtils.fzflua.dropdown {
              winopts = { title = opts.prompt, height = 0.33, row = 0.5 },
            },
          }
        end,
        nui = {
          min_height = 10,
          win_options = {
            winhighlight = table.concat({
              "Normal:Italic",
              "FloatBorder:FloatBorder",
              "FloatTitle:Title",
              "CursorLine:Visual",
            }, ","),
          },
        },
      },
      win_options = {
        winhighlight = "FloatBorder:FzfLuaBorder",
      },
    },
  },
  -- TROUBLE.NVIM
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "gr",
        "<cmd>Trouble lsp_references toggle focus=true win.position=right<cr>",
        desc = "LSP: references [trouble]",
      },
      {
        "gi",
        "<cmd>Trouble lsp_implementations toggle focus=true win.position=right<cr>",
        desc = "LSP: implementations [trouble]",
      },
      {
        "gO",
        "<cmd>Trouble lsp_outgoing_calls toggle focus=true win.position=right<cr>",
        desc = "LSP: outgoing calls [trouble]",
      },
      {
        "gI",
        "<cmd>Trouble lsp_incoming_calls toggle focus=true win.position=right<cr>",
        desc = "LSP: incomming calls [trouble]",
      },
      {
        "gd",
        "<cmd>Trouble lsp_definitions<CR>",
        desc = "LSP: definitions [trouble]",
      },
      {
        "gt",
        "<cmd>Trouble lsp_type_definitions<CR>",
        desc = "LSP: type definitions [trouble]",
      },
      {
        "<leader>xX",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end

          vim.cmd [[Trouble diagnostics toggle]]
        end,
        desc = "Diagnostic: workspaces diagnostic [trouble]",
      },
      {
        "<leader>xx",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd [[Trouble diagnostics toggle filter.buf=0]]
        end,
        desc = "Diagnostic: document diagnostic [trouble]",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "LSP: open symbols with trouble [trouble]",
      },
      {
        "<leader>cS",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP: LSP references/definitions/... [trouble]",
      },
      {
        "<leader>xl",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd "Trouble loclist toggle"
        end,
        desc = "QF: open location list with [trouble]",
      },
      {
        "<leader>xq",
        function()
          local qf_win = RUtils.cmd.windows_is_opened { "qf" }
          if qf_win.found then
            vim.cmd [[cclose]]
          end
          vim.cmd "Trouble qflist toggle"
        end,
        desc = "QF: open quickfix list with [trouble]",
      },
    },
    opts = function()
      local icons_lsp = RUtils.config.icons.kinds
      Highlight.plugin("trouble", {
        { TroubleSignWarning = { bg = "NONE", fg = { from = "DiagnosticSignWarn" } } },
        { TroubleSignError = { bg = "NONE", fg = { from = "DiagnosticSignError" } } },
        { TroubleSignHint = { bg = "NONE", fg = { from = "DiagnosticSignHint" } } },
        { TroubleSignInfo = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
        { TroubleSignOther = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
        { TroubleSignInformation = { bg = "NONE", fg = { from = "DiagnosticSignInfo" } } },
        { TroubleIndent = { bg = "NONE", fg = { from = "FoldColumn", attr = "fg", alter = 0.1 } } },
        { TroubleFile = { bg = "NONE", fg = { from = "Directory", attr = "fg", alter = 0.1 } } },
        { TroubleTextOther = { bg = "NONE", bold = true } },
        { TroubleLocation = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg" } } },
        { TroubleFoldIcon = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },
        { TroubleCode = { bg = "NONE", fg = { from = "WinSeparator", attr = "fg", alter = 0.1 }, underline = false } },
        {
          TroubleDiagnosticsCount = {
            bg = { from = "WinSeparator", attr = "fg", alter = -0.5 },
            fg = { from = "WinSeparator", attr = "fg", alter = 0.1 },
            underline = false,
          },
        },
        {
          TroubleCount = {
            bg = { from = "WinSeparator", attr = "fg", alter = -0.5 },
            fg = { from = "WinSeparator", attr = "fg", alter = 0.1 },
          },
        },
      })
      return {
        auto_open = false,
        auto_close = true, -- automatically close the list when you have no diagnostics
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
          ["<a-n>"] = "next",
          ["<a-p>"] = "prev",
        },
      }
    end,
  },
}
