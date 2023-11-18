local fn, cmd, fmt = vim.fn, vim.cmd, string.format

local highlight = require "r.config.highlights"

local Util = require "r.utils"

local function format_title(str, icon, icon_hl)
  return {
    { " " },
    { (icon and icon .. " " or ""), icon_hl or "Boolean" },
    { str, "FzfLuaTitle" },
    { " " },
  }
end

local function dropdown(opts)
  opts = opts or { winopts = {} }
  local title = vim.tbl_get(opts, "winopts", "title") ---@type string?
  if title and type(title) == "string" then
    opts.winopts.title = format_title(title)
  end
  return vim.tbl_deep_extend("force", {
    prompt = require("r.config").icons.misc.dots,
    fzf_opts = { ["--layout"] = "reverse" },
    winopts = {
      title_pos = opts.winopts.title and "center" or nil,
      height = 0.70,
      width = 0.60,
      row = 0.1,
      preview = {
        hidden = "hidden",
        layout = "vertical",
        vertical = "up:50%",
      },
    },
  }, opts)
end

local function cursor_dropdown(opts)
  local height = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    height = height - 1
  end

  local vim_width = vim.o.columns
  local vim_height = height

  local widthc = math.floor(vim_width / 2 + 8)
  local heightc = math.floor(vim_height / 2 - 5)

  return dropdown(vim.tbl_deep_extend("force", {
    winopts_fn = {
      width = widthc,
      height = heightc,
    },
    winopts = {
      row = 1,
      relative = "cursor",
      height = 0.33,
      width = widthc / (widthc + vim_width - 10),
    },
  }, opts))
end

return {
  -- HARPOON
  {
    "ThePrimeagen/harpoon",
    --stylua: ignore
    keys = {
      { "<Leader>ja", function() require("harpoon.mark").add_file() end, desc = "Misc(harpoon): add file" },
      { "<Leader>jm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Misc(harpoon): file menu" },
      { "<Leader>jc", function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = "Misc(harpoon): command menu" },
      { "<Leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Misc(harpoon): file 1" },
      { "<Leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Misc(harpoon): file 2" },
      -- { "<Leader>3", function() require("harpoon.term").gotoTerminal(1) end, desc = "Terminal 1" },
      -- { "<Leader>4", function() require("harpoon.term").gotoTerminal(2) end, desc = "Terminal 2" },
      -- { "<Leader>5", function() require("harpoon.term").sendCommand(1,1) end, desc = "Command 1" },
      -- { "<Leader>6", function() require("harpoon.term").sendCommand(1,2) end, desc = "Command 2" },
    },
    opts = {
      global_settings = {
        save_on_toggle = true,
        enter_on_sendcmd = true,
      },
    },
  },
  -- FLASH.NVIM
  {
    "folke/flash.nvim",
    event = "LazyFile",
    opts = function()
      highlight.plugin("flash.nvim", {
        { FlashMatch = { bg = { from = "ErrorMsg", attr = "fg", alter = 3 }, bold = true } },
        {
          FlashLabel = {
            fg = { from = "ErrorMsg", attr = "fg", alter = 0.1 },
            bg = "NONE",
            bold = true,
            strikethrough = false,
          },
        },
        { FlashCursor = { bg = { from = "ColorColumn", attr = "bg", alter = 5 }, bold = true } },
      })
      return {
        modes = {
          char = {
            keys = { "f", "F" },
          },
          search = { enabled = false },
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { [[\]], mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Misc(flash)" },
      -- { "<c-s>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Misc(flash): treesitter" },
      -- { "r", mode = "o", function() require("flash").remote() end, desc = "Misc(flash): remote" },
      -- { "<c-s>", function() require("flash").toggle() end, mode = { "c" }, desc = "Misc(flash): toggle search" },
    },
  },
  -- NVIM-HLSLENS (disabled)
  {
    "kevinhwang91/nvim-hlslens",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      vim.keymap.set({ "n", "v", "o", "i", "c" }, "<Plug>(StopHL)", 'execute("nohlsearch")[-1]', { expr = true })

      local function stop_hl()
        if vim.v.hlsearch == 0 or vim.api.nvim_get_mode().mode ~= "n" then
          return
        end
        Util.cmd.feedkey("<Plug>(StopHL)", "n")
      end

      local function hl_search()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local curr_line = vim.api.nvim_get_current_line()
        local ok, match = pcall(fn.matchstrpos, curr_line, fn.getreg "/", 0)
        if pcall(require, "hlslens") then
          require("hlslens").start()
        end

        if not ok then
          return
        end
        ---@diagnostic disable-next-line: deprecated
        local _, p_start, p_end = unpack(match)
        -- if the cursor is in a search result, leave highlighting on
        if col < p_start or col > p_end then
          stop_hl()
        end
      end

      Util.cmd.augroup("VimrcIncSearchHighlight", {
        event = { "CursorMoved" },
        command = function()
          hl_search()
        end,
      }, {
        event = { "InsertEnter" },
        command = function()
          stop_hl()
        end,
      }, {
        event = { "OptionSet" },
        pattern = { "hlsearch" },
        command = function()
          vim.schedule(function()
            cmd.redrawstatus()
          end)
        end,
      }, {
        event = "RecordingEnter",
        command = function()
          vim.o.hlsearch = false
        end,
      }, {
        event = "RecordingLeave",
        command = function()
          vim.o.hlsearch = true
        end,
      })
      return {}
    end,
    config = true,
  },
  -- FZF-LUA
  {
    "ibhagwan/fzf-lua",
    version = false, -- fzflua did only one release, so use HEAD for now
    cmd = "Fzflua",
    dependencies = {
      "sindrets/diffview.nvim",
      "nvim-tree/nvim-web-devicons",
      "onsails/lspkind.nvim",
    },
    -- stylua: ignore
    keys = {
      { "<Leader>ff", "<cmd>FzfLua files<cr>", desc = "Fzflua: find files", mode = { "n", "v" } },

      { "sf", "<CMD>FzfLua buffers<CR>", desc = "WinNav(fzflua): open" },
      { "sg", "<CMD>FzfLua blines<CR>", desc = "WinNav(fzfLua): live_grep on curbuf" },
      { "sG", "<CMD>FzfLua lines<CR>", desc = "WinNav(fzflua): live_grep on buffers" },
      { "so", "<CMD>FzfLua oldfiles<CR>", desc = "WinNav(Fzflua): oldfiles" },

      { "<Leader>fC", "<CMD>FzfLua commands<CR>", desc = "Fzflua: commands" },
      { "<Leader>fh", "<CMD>FzfLua help_tags<CR>", desc = "Fzflua: help tags" },
      { "<Leader>fl", "<CMD>FzfLua resume<CR>", desc = "Fzflua: resume (last search)" },
      { "<Leader>fg", "<CMD>FzfLua live_grep_glob<CR>", desc = "Fzflua: live grep" },
      { "<Leader>fg", "<CMD>FzfLua grep_visual<CR>", desc = "Fzflua: live grep (visual)", mode = { "v" } },
      { "<Leader>fc", "<CMD>FzfLua changes<CR>", desc = "Fzflua: changes" },
      { "<Leader>fj", "<CMD>FzfLua jumps<CR>", desc = "Fzflua: jumps" },
      { "<Leader>fm", "<CMD>FzfLua marks<CR>", desc = "Fzflua: marks" },
      { "<Leader>f=", "<CMD>FzfLua spell_suggest<CR>", desc = "Fzflua: spell" },
      { "<Leader>fH", [[<CMD>FzfLua search_history reverse_search=true<CR>]], desc = "Fzflua: search-history" },
      {
        "<Leader>fk",
        function()
          return require("fzf-lua").keymaps {
            winopts = {
              preview = {
                title = format_title("Keymaps", " "),
                vertical = "up:45%",
                horizontal = "right:30%",
                layout = "flex",
              },
            },
          }
        end,
        desc = "Fzflua: keymaps",
      },
      {
        "<Leader>fo",
        function()
          return require("fzf-lua").files {
            prompt = "  ",
            winopts = { title = format_title("Dotfiles", "󰈙") },
            cwd = "~/moxconf/development/dotfiles",
          }
        end,
        desc = "Fzflua: dotfiles",
      },
      -- {
      --   "<Leader>fF",
      --   function()
      --     local plugins_directory = vim.fn.stdpath "data" .. "/lazy"
      --     return require("fzf-lua").files {
      --       prompt = "  ",
      --       winopts = { title = format_title("Plugin Files", "󰈙") },
      --       cwd = plugins_directory,
      --     }
      --   end,
      --   desc = "Fzflua: plugin files",
      -- },
      -- {
      --   "<Leader>fG",
      --   function()
      --     return require("fzf-lua").live_grep_glob({
      --       prompt = "  ",
      --       winopts = { title = format_title("GrepHidden", "󰈭") },
      --       filter = [[rg --invert-match "node_modules|dist|lib|.git|package-lock.json|LICENSES.txt|LICENSES.json"]]
      --     })
      --   end,
      --   desc = "Fzflua: live grep ignore hidden",
      -- },
      -- {
      --   "<Leader>fG",
      --   function()
      --     return require("fzf-lua").grep_visual({
      --       filter = [[rg --invert-match "node_modules|dist|lib|.git|package-lock.json|LICENSES.txt|LICENSES.json"]]
      --     })
      --   end,
      --   desc = "Fzflua: live grep ignore hidden (visual)",
      --   mode = {"v"}
      -- },
      { "<Leader>fQ", [[<CMD>lua require("fzf-lua").quickfix({prompt = "    " })<CR>]], desc = "Fzflua(qf): select qf list" },
      {
        "<Leader>fq",
        function()
          local path = require "fzf-lua.path"

          local qf_items = fn.getqflist()

          local qf_ntbl = {}
          for _, qf_item in pairs(qf_items) do
            table.insert(qf_ntbl, path.relative(vim.api.nvim_buf_get_name(qf_item.bufnr), vim.uv.cwd()))
          end

          local pcmd = [[rg --column --line-number -i --hidden --no-heading --color=always --smart-case {q} ]]
            .. table.concat(qf_ntbl, " ")

          return require("fzf-lua").live_grep {
            prompt = "  ",
            winopts = { title = format_title("[QF] Grep", " ") },
            cmd = pcmd,
          }
        end,
        desc = "Fzflua(qf): grep qf items",
      },
    },
    opts = function()
      local actions = require "fzf-lua.actions"
      local path = require "fzf-lua.path"

      return {
        winopts_fn = function()
          local win_height = math.ceil(vim.api.nvim_get_option "lines" * 0.5)
          local win_width = math.ceil(vim.api.nvim_get_option "columns" * 1)
          local col = math.ceil((vim.api.nvim_get_option "columns" - win_width) * 1)
          local row = math.ceil((vim.api.nvim_get_option "lines" - win_height) * 1 - 3)
          return {
            width = win_width,
            height = win_height,
            row = row,
            col = col,
          }
        end,
        fzf_opts = {
          ["--ansi"] = "",
          ["--info"] = "inline",
          ["--height"] = "100%",
          ["--layout"] = "reverse",
          ["--border"] = "none",
          ["--no-separator"] = "",
          -- ["--ansi"] = "",
          -- ["--info"] = "default",
          -- ["--layout"] = "default",
          -- ["--reverse"] = false,
          -- ["--border"] = "none",
        },
        keymap = {
          builtin = {
            ["<F1>"] = "toggle-help",
            ["<F3>"] = "toggle-preview",
            ["<F4>"] = "toggle-fullscreen",
            -- ["<c-w>"] = "toggle-preview-wrap",
            -- ["<F5>"] = "toggle-preview-ccw",
            ["<c-j>"] = "toggle-preview-cw",
            ["<c-k>"] = "toggle-preview-ccw",
            ["<c-d>"] = "preview-page-down",
            ["<c-u>"] = "preview-page-up",
          },
          fzf = {
            -- fzf '--bind=' options
            ["ctrl-z"] = "abort",
            -- ["ctrl-u"]      = "unix-line-discard",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
          },
        },
        actions = {
          files = {
            -- providers that inherit these actions:
            --   files, git_files, git_status, grep, lsp
            --   oldfiles, quickfix, loclist, tags, btags
            --   args
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["ctrl-q"] = actions.file_sel_to_qf,
          },
          buffers = {
            -- providers that inherit these actions:
            --   buffers, tabs, lines, blines
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
        },
        -- PROVIDER SETUP
        files = {
          -- debug = true, -- jangan lupa: untuk check `rg opt`
          prompt = "  ",
          cwd_prompt = false,
          winopts = { title = format_title("Files", "") },
          -- find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
          fzf_opts = {
            ["--header"] = [[Ctrl-g:'grep by directory',Ctrl-h:'toggle hidden']],
          },
          fd_opts = [[--color never --type f --hidden --follow ]]
            .. [[--exclude .git --exclude '*.pyc']]
            .. [[ --exclude '*.ttf' --exclude '*.png' --exclude '*.otf']],
          actions = {
            ["default"] = function(selected, opts)
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
            ["ctrl-y"] = function(selected, _)
              local slice_num_str = selected[1]:match ".*\xe2\x80\x82()"
              local pth = selected[1]:sub(slice_num_str)
              vim.fn.setreg([[+]], pth)

              Util.info("copy: " .. pth, { title = "Path" })

              require("fzf-lua").actions.resume()
            end,
            ["ctrl-h"] = function(_, args)
              if args.cmd:find "--hidden" then
                args.cmd = args.cmd:gsub("--hidden", "", 1)
                if args.cmd:find "--no-ignore" then
                  args.cmd = args.cmd:gsub("--no-ignore", "", 1)
                end
              else
                args.cmd = args.cmd .. " --hidden --no-ignore"
              end

              require("fzf-lua").files {
                cmd = args.cmd,
                winopts = { title = format_title("Files hidden", "󰈙") },
              }
            end,
            ["ctrl-g"] = function(_, args)
              if args.cmd:find "--type f" then
                args.cmd = args.cmd:gsub("--type f", "", 1)
                args.cmd:gsub("%s*\\*$", "")
                args.cmd = args.cmd .. " --type d"
                args.winopts = {
                  preview = { hidden = "hidden" },
                  title = format_title("Grep on directory", ""),
                }
              elseif args.cmd:find "--type d" then
                args.cmd = args.cmd:gsub("--type d", "", 1)
                args.cmd:gsub("%s*\\*$", "")
                args.cmd = args.cmd .. " --type f"
                args.winopts = {
                  preview = { hidden = "nohidden" },
                }
              end
              require("fzf-lua").files {
                cmd = args.cmd,
                winopts = args.winopts,
              }
            end,
          },
        },
        git = {
          files = {
            prompt = "  ",
            winopts = { title = format_title("Git Files", "") },
            cmd = "git ls-files --exclude-standard",
            multiprocess = true, -- run command in a separate process
            git_icons = true, -- show git icons?
            file_icons = true, -- show file icons?
            color_icons = true, -- colorize file|git icons
          },
          status = {
            prompt = "  ",
            winopts = { title = format_title("Git Status", "") },
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            actions = {
              -- actions inherit from 'actions.files' and merge
              ["right"] = { actions.git_unstage, actions.resume },
              ["left"] = {
                actions.git_stage,
                actions.resume,
              },
            },
          },
          commits = {
            prompt = "  ",
            preview = "git show --pretty='%Cred%H%n%Cblue%an <%ae>%n%C(yellow)%cD%n%Cgreen%s' --color {1}",
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            winopts = { title = format_title("", "Commits") },
            fzf_opts = {
              ["--header"] = [[Ctrl-o:'hash on browser',Ctrl-y:'copy hash',Ctrl-i:'open hash diff',Ctrl-x:'open hash diff buffer']],
            },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["right"] = actions.git_checkout,
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]

                vim.api.nvim_command(":GBrowse " .. commit_hash)

                Util.info("Browse commit hash: " .. commit_hash, { title = "FZFGit" })
              end,
              ["ctrl-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]
                vim.fn.setreg("+", commit_hash)

                Util.info("Hash: " .. commit_hash .. " copied", { title = "FZFGit" })

                require("fzf-lua").actions.resume()
              end,
              ["ctrl-i"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]
                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash

                vim.api.nvim_command(cmdmsg)

                Util.info("Open all diff " .. commit_hash, { title = "FZFGit" })
              end,
              ["ctrl-x"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]
                local filename = Util.fzf_diffview.git_relative_path(vim.api.nvim_get_current_buf())

                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash .. " -- " .. filename

                vim.api.nvim_command(cmdmsg)

                Util.info("Diff hash " .. commit_hash .. " with current file \n" .. filename, { title = "FZFGit" })
              end,
            },
          },
          bcommits = {
            -- debug = true,
            prompt = "  ",
            preview = "git diff --color {1}~1 {1} -- <file>",
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            winopts = {
              title = format_title("", "Buffer Commits"),
            },
            fzf_opts = {
              ["--header"] = [[Ctrl-o:'open browser',Ctrl-y:'copy hash',Ctrl-i:'open commit diff',Ctrl-x:'open curdiff']],
            },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]

                Util.info("Browse commit hash: " .. commit_hash, { title = "FZFGit" })

                vim.api.nvim_command(":GBrowse " .. commit_hash)
              end,
              ["ctrl-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]
                vim.fn.setreg("+", commit_hash)

                Util.info("Hash: " .. commit_hash .. " copied", { title = "FZFGit" })

                require("fzf-lua").actions.resume()
              end,
              ["ctrl-i"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]
                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash

                vim.api.nvim_command(cmdmsg)

                Util.info("Open all diff " .. commit_hash, { title = "FZFGit" })
              end,
              ["ctrl-x"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]
                local filename = Util.fzf_diffview.git_relative_path(vim.api.nvim_get_current_buf())

                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash .. " -- " .. filename

                vim.api.nvim_command(cmdmsg)

                Util.info("Compare diff " .. commit_hash .. " with current file \n" .. filename, { title = "FZFGit" })
              end,
            },
          },
          branches = {
            prompt = "  ",
            cmd = "git branch --all --color",
            preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
            winopts = {
              title = format_title("Branches", ""),
              height = 0.3,
              row = 0.4,
            },
            actions = {
              ["default"] = actions.git_switch,
            },
          },
          -- stash = {
          --     prompt = "  ",
          --     cmd = "git --no-pager stash list",
          --     preview = "git --no-pager stash show --patch --color {1}",
          --     winopts = {
          --         title = format_title("Stash", ""),
          --     },
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
          -- },
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
          -- debug = true, -- jangan lupa: untuk check `rg opt`, use debug
          prompt = " ",
          winopts = { title = format_title("Grep", " ") },
          grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
          rg_opts = "--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096",
          -- fzf_opts = { ["--header"] = [[Ctrl-q:'grep match',Ctrl-h:'toggle hidden',Ctrl-f:'mode files']] },
          no_header = true, -- disable default header
          actions = {
            -- ["ctrl-g"] = { actions.grep_lgrep },
            ["ctrl-h"] = function(_, args)
              local toggle = 1

              args.rg_opts =
                "--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096"

              if toggle == 1 then
                args.rg_opts =
                  "--column --hidden --no-ignore --no-heading --ignore-case -g !.git --smart-case --color=always --max-columns=4096"
                toggle = 0
              else
                toggle = 1
              end
              require("fzf-lua").live_grep_glob {
                rg_opts = args.rg_opts,
                winopts = { title = format_title("Grep hidden", " ") },
              }
            end,
            ["ctrl-q"] = function(_, args)
              if args.cmd:find "--fixed-strings" then
                args.cmd = args.cmd:gsub("--fixed-strings", "", 1)
              else
                args.cmd = args.cmd .. " --fixed-strings"
              end

              local tbl_ops = {
                cmd = args.cmd,
                winopts = { title = format_title("Grep match", " ") },
              }

              if args.cwd ~= nil then
                tbl_ops = vim.tbl_deep_extend("force", {}, tbl_ops, { cwd = args.cwd })
              end
              require("fzf-lua").live_grep_glob(tbl_ops)
            end,
            ["ctrl-y"] = function()
              require("fzf-lua").fzf_exec({}, {
                fzf_opts = {
                  ["--preview"] = vim.fn.shellescape [[cat <<EOF 
Keybindings:
  TAB           Toggle selection.
  ctrl-q        Grep match.
  ctrl-h        Toggle hidden.
  ctrl-o        Mode files (Fzflua files).
  ctrl-y        Show keybindings
                  ]],
                },
                winopts = {
                  title = format_title("Grep Show Keybindings", " "),
                  preview = { layout = "horizontal", hoizontal = "right:99%" },
                },

                actions = {
                  ["ctrl-y"] = function()
                    require("fzf-lua").live_grep_glob()
                  end,
                },
              })
            end,
            ["ctrl-o"] = function()
              require("fzf-lua").files {}
            end,
          },
        },
        args = {
          prompt = "  ",
          files_only = true,
          -- actions inherit from 'actions.files' and merge
          actions = {
            ["ctrl-x"] = { actions.arg_del, actions.resume },
          },
        },
        oldfiles = {
          winopts = { title = format_title("History", "") },
          cwd_only = true,
          stat_file = true, -- verify files exist on disk
          include_current_session = false, -- include bufs from current session
        },
        buffers = {
          winopts = { title = format_title("Buffers", "󰈙") },
          cwd = nil, -- buffers list for a given dir
          fzf_opts = {
            ["--delimiter"] = "' '",
            ["--with-nth"] = "-1..",
          },
        },
        highlights = {
          prompt = "  ",
          winopts = { title = format_title "Highlights" },
        },
        helptags = {
          prompt = "  ",
          winopts = { title = format_title("Help", "󰋖") },
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
            ["--delimiter"] = "'[\\):]'",
            ["--with-nth"] = "2..",
          },
        },
        lines = {
          prompt = "  ",
          winopts = { title = format_title("Lines", " ") },
          fzf_opts = {
            -- do not include bufnr in fuzzy matching
            -- tiebreak by line no.
            ["--delimiter"] = "'[\\]:]'",
            ["--nth"] = "2..",
            ["--tiebreak"] = "index",
            ["--tabstop"] = "1",
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
        blines = {
          prompt = "  ",
          no_header = true, -- hide grep|cwd header?
          no_header_i = true, -- hide interactive header?
          winopts = {
            title = format_title("Blines", " "),
          },
          fzf_opts = {
            -- Cara menghilangkan filepath
            -- https://github.com/ibhagwan/fzf-lua/issues/228#issuecomment-983262485
            ["--delimiter"] = "'[\\]:]'",
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
            ["--delimiter"] = "'[\\]:]'",
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
            title = format_title("[QF]", "󰈙"),
          },
          file_icons = true,
          git_icons = true,
        },
        quickfix_stack = {
          winopts = {
            title = format_title("[QF]", "󰈙"),
          },
          marker = ">", -- current list marker
        },
        lsp = {
          cwd_only = true,
          symbols = {
            symbol_style = 1,
            symbol_icons = require("r.config").icons.kinds,
            fzf_opts = {
              ["--reverse"] = false,
              ["--scrollbar"] = "▓",
            },
            winopts = {
              title = format_title("Symbols", " "),
            },
          },
          code_actions = cursor_dropdown {
            winopts = {
              title = format_title("Code Actions", "󰌵", "@type"),
            },
          },
          finder = {
            prompt = "  ",
            winopts = {
              title = format_title("LSP Finder", " "),
            },
          },
        },
        diagnostics = {
          prompt = "  ",
          winopts = { title = format_title("Diagnostics", "", "DiagnosticError") },
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
          -- actions inherit from 'actions.files' and merge
          actions = { ["default"] = actions.complete_insert },
          -- previewer hidden by default
          winopts = { preview = { hidden = "hidden" } },
        },
      }
    end,
    config = function(_, opts)
      local function augroup(name, fnc)
        fnc(vim.api.nvim_create_augroup(name, { clear = true }))
      end

      augroup("FzfluaFixMaps", function(g)
        vim.api.nvim_create_autocmd("FileType", {
          group = g,
          pattern = "fzf",
          callback = function(e)
            vim.keymap.set("t", "<C-t>", "<C-t>", { buffer = e.buf, silent = true })
            vim.keymap.set("t", "<C-h>", "<C-h>", { buffer = e.buf, silent = true })
            vim.keymap.set("t", "<C-c>", "<Esc>", { buffer = e.buf, silent = true })
            vim.keymap.set("t", "<C-g>", "<C-g>", { buffer = e.buf, silent = true })
            vim.keymap.set("i", "<C-c>", "<Esc>", { buffer = e.buf, silent = true })
          end,
        })
      end)
      require("fzf-lua").setup(opts)
    end,
  },
  -- FZF
  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },
  -- TELESCOPE
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    keys = {
      -- { "<Leader>ff", "<cmd>Telescope corrode<cr>", desc = "Telescope: find files", mode = { "n", "v" } },
      { "df", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "LSP(diagnostic): telescope bufnr diagnostics" },
      { "dF", "<cmd>Telescope diagnostics<cr>", desc = "LSP(diagnostic): telescope all diagnostics" },
      -- { "<Leader>fg", "<cmd>Telescope live_grep_args<cr>", desc = "Telescope: live grep" },
      { "<Leader>fF", "<cmd>Telescope lazy<cr>", desc = "Telescope: plugin files" },
      { "<Leader>fu", "<cmd>Telescope undo<cr>", desc = "Telescope: undo" },
      -- {
      --   "gs",
      --   function()
      --     require("telescope.builtin").lsp_document_symbols {
      --       symbols = require("r.config").get_kind_filter(),
      --     }
      --   end,
      --   desc = "Telescope (lsp): goto symbol",
      -- },
      -- {
      --   "gS",
      --   function()
      --     require("telescope.builtin").lsp_dynamic_workspace_symbols {
      --       symbols = require("r.config").get_kind_filter(),
      --     }
      --   end,
      --   desc = "Telescope(lsp): goto symbol (Workspace)",
      -- },
      -- { "sf", "<CMD>Telescope buffers<CR>", desc = "Telescope: find buffers" },
      -- { "<Leader>fk", "<CMD>Telescope keymaps<CR>", desc = "Telescope: keymaps" },
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
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", enabled = vim.fn.executable "make" == 1 },
      "nvim-telescope/telescope-symbols.nvim",
      "debugloop/telescope-undo.nvim", -- Visualise undotree
      "nvim-telescope/telescope-live-grep-args.nvim",
      "tsakirist/telescope-lazy.nvim",
      "nvim-telescope/telescope-dap.nvim",
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
              ["<c-c>"] = actions.close,

              -- ["<c-o>"] = trouble.open_with_trouble,

              ["<s-down>"] = actions.cycle_history_next,
              ["<s-up>"] = actions.cycle_history_prev,

              ["<c-f>"] = actions.results_scrolling_up,
              ["<c-b>"] = actions.results_scrolling_down,

              ["<c-l>"] = false,

              ["<a-a>"] = actions.toggle_all,

              ["<CR>"] = stopinsert(actions.select_default),
              ["<C-s>"] = stopinsert(actions.select_horizontal),
              ["<C-v>"] = stopinsert(actions.select_vertical),
              ["<C-t>"] = stopinsert(actions.select_tab),

              ["<c-r>"] = actions.to_fuzzy_refine,
              ["<F1>"] = actions.which_key, -- keys from pressing <C-/>

              ["<c-j>"] = layout_actions.cycle_layout_next,
              ["<c-k>"] = layout_actions.cycle_layout_prev,

              ["<F4>"] = layout_actions.cycle_layout_next,
              ["<F3>"] = layout_actions.toggle_preview,

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
            layout_config = { height = 18, width = 0.5 },
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
          undo = themes.get_ivy {},
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
      telescope.load_extension "harpoon"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "lazy"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "undo"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "live_grep_args"
      ---@diagnostic disable-next-line: undefined-field
      telescope.load_extension "dap"

      local corrode_cfg = require "telescope._extensions.corrode.config"
      corrode_cfg.values = { theme = "ivy" }
    end,
  },
  -- SPECTRE
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      {
        "<Leader><s-f>",
        function()
          Util.tiling.force_win_close({ "toggleterm", "termlist" }, true)
          return require("spectre").open()
        end,
        desc = "Misc(spectre): open",
      },
      {
        "<Leader><s-f>",
        function()
          Util.tiling.force_win_close({ "toggleterm", "termlist" }, true)
          return require("spectre").open_visual { select_word = true }
        end,
        desc = "Misc(spectre): open (visual)",
        mode = {
          "v",
        },
      },
    },
    opts = function()
      highlight.plugin("Spectre", {
        {
          TargetKeyword = {
            fg = "DarkYellow",
            bold = true,
            italic = true,
          },
        },
        {
          TargetFileDirectory = {
            bg = "DarkCyan",
            fg = "black",
            bold = true,
          },
        },

        {
          TargetFilename = {
            bg = "Cyan",
            fg = "black",
            bold = true,
          },
        },
        {
          TargetReplace = {
            bg = "Cyan",
            fg = "black",
            italic = true,
          },
        },
      })
      return {
        open_cmd = "noswapfile vnew",
        color_devicons = true,
        live_update = false, -- auto excute search again when you write any file in vim
        line_sep_start = "┌-----------------------------------------",
        result_padding = "¦  ",
        line_sep = "└-----------------------------------------",
        highlight = {
          ui = "String",
          filename = "TargetFilename",
          filedirectory = "TargetFileDirectory",
          search = "TargetKeyword",
          replace = "TargetReplace",
        },
        mapping = {
          ["toggle_line"] = {
            map = "dd",
            cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = "toggle current item",
          },
          ["enter_file"] = {
            map = "<cr>",
            cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
            desc = "goto current file",
          },
          ["send_to_qf"] = {
            map = "<c-q>",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all item to quickfix",
          },
          ["replace_cmd"] = {
            map = "<c-c>",
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = "input replace vim command",
          },
          ["show_option_menu"] = {
            map = "<Leader>o",
            cmd = "<cmd>lua require('spectre').show_options()<CR>",
            desc = "show option",
          },
          ["run_current_replace"] = {
            map = "rc",
            cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
            desc = "replace current line",
          },
          ["run_replace"] = {
            map = "R",
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = "replace all",
          },
          ["change_view_mode"] = {
            map = "<Leader>v",
            cmd = "<cmd>lua require('spectre').change_view()<CR>",
            desc = "change result view mode",
          },
          ["change_replace_sed"] = {
            map = "ts",
            cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
            desc = "use sed to replace",
          },
          ["toggle_live_update"] = {
            map = "tu",
            cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
            desc = "update change when vim write file.",
          },
          ["toggle_ignore_case"] = {
            map = "ti",
            cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
            desc = "toggle ignore case",
          },
          ["toggle_ignore_hidden"] = {
            map = "th",
            cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
            desc = "toggle search hidden",
          },
          -- you can put your mapping here it only use normal mode
        },
        find_engine = {
          -- rg is map with finder_cmd
          ["rg"] = {
            cmd = "rg",
            -- default args
            args = {
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
            },
            options = {
              ["ignore-case"] = {
                value = "--ignore-case",
                icon = "[I]",
                desc = "ignore case",
              },
              ["hidden"] = {
                value = "--hidden",
                desc = "hidden file",
                icon = "[H]",
              },
              -- you can put any rg search option you want here it can toggle with
              -- show_option function
            },
          },
          ["ag"] = {
            cmd = "ag",
            args = {
              "--vimgrep",
              "-s",
            },
            options = {
              ["ignore-case"] = {
                value = "-i",
                icon = "[I]",
                desc = "ignore case",
              },
              ["hidden"] = {
                value = "--hidden",
                desc = "hidden file",
                icon = "[H]",
              },
            },
          },
        },
        replace_engine = {
          ["sed"] = {
            cmd = "sed",
            args = nil,
            options = {
              ["ignore-case"] = {
                value = "--ignore-case",
                icon = "[I]",
                desc = "ignore case",
              },
            },
          },
        },
        default = {
          find = {
            --pick one of item in find_engine
            cmd = "rg",
            options = { "ignore-case", "hidden" },
          },
          replace = {
            --pick one of item in replace_engine
            cmd = "sed",
          },
        },
        replace_vim_cmd = "cdo",
        is_open_target_win = true, --open file on opener window
        is_insert_mode = false, -- start open panel on is_insert_mode
      }
    end,
  },
  -- TODO-COMMENTS
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    keys = {
      {
        "<Leader>rt",
        function()
          return cmd(fmt("TodoQuickFix cwd=%s", fn.expand "%:p"))
        end,
        desc = "Misc(todocomment): find todo comment curbuf",
        mode = {
          "n",
          "v",
        },
      },
      {
        "<Leader>rT",
        fmt("<CMD>TodoQuickFix cwd=%s<CR>", fn.getcwd()),
        desc = "Misc(todocomment): find all todo comments on repo",
      },
    },
    opts = {
      signs = {
        enable = true, -- show icons in the sign column
        priority = 8,
      },
      keywords = {
        FIX = {
          icon = " ", -- used for the sign, and search results
          -- can be a hex color, or a named color
          -- named colors definitions follow below
          color = "error",
          -- a set of other keywords that all map to this FIX keywords
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          -- signs = false -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        WARN = {
          icon = " ",
          color = "warning",
          alt = { "WARNING" },
        },
        -- NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
      merge_keywords = false, -- wheather to merge custom keywords with defaults
      highlight = {
        -- highlights before the keyword (typically comment characters)
        before = "", -- "fg", "bg", or empty
        -- highlights of the keyword
        -- wide is the same as bg, but also highlights the colon
        keyword = "wide", -- "fg", "bg", "wide", or empty
        -- highlights after the keyword (TODO text)
        after = "fg", -- "fg", "bg", or empty
        -- pattern can be a string, or a table of regexes that will be checked
        -- vim regex
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true, -- highlight only inside comments using treesitter
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors
      -- a list of hex colors or highlight groups
      -- will use the first valid one
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
      },
      -- rg_rege = {
      --     "--color=always",
      --     "--no-heading",
      --     "--follow",
      --     "--hidden",
      --     "--with-filename",
      --     "--line-number",
      --     "--column",
      --     "-g",
      --     "!node_modules/**",
      --     "-g",
      --     "!.git/**",
      -- },
      search = {
        command = "rg",

        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):\s]], -- ripgrep regex
      },
    },
  },
  -- DRESSING
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      -- vim.ui.input = function(...)
      --   require("lazy").load { plugins = { "dressing.nvim" } }
      --   return vim.ui.input(...)
      -- end
    end,
    opts = {
      input = { enabled = false },
      select = {
        -- priority: use fzf_lua first before anything else
        backend = { "fzf_lua", "builtin" },
        builtin = {
          border = require("r.config").icons.border.rectangle,
          min_height = 10,
          win_options = { winblend = 10 },
          mappings = { n = { ["q"] = "Close" } },
        },
        get_config = function(opts)
          opts.prompt = opts.prompt and opts.prompt:gsub(":", "")
          if opts.kind == "codeaction" then
            return {
              backend = "fzf_lua",
              fzf_lua = cursor_dropdown {
                prompt = "  ",
                winopts = { title = opts.prompt, relative = "cursor" },
              },
            }
          end
          if opts.kind == "orgmode" then
            return {
              backend = "nui",
              nui = {
                position = "97%",
                border = { style = require("r.config").icons.border.rectangle },
                min_width = vim.o.columns - 2,
              },
            }
          end
          return {
            backend = "fzf_lua",
            fzf_lua = dropdown {
              winopts = { title = opts.prompt, height = 0.33, row = 0.5 },
            },
          }
        end,
        nui = {
          min_height = 10,
          win_options = {
            winhighlight = table.concat({
              "Normal:Italic",
              "FloatBorder:PickerBorder",
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
}
