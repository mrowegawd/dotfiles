local fn, cmd, fmt = vim.fn, vim.cmd, string.format

local highlight = require "r.config.highlights"

local Util = require "r.utils"

local root_patterns = { ".git", "lua" }

local function format_title(str, icon, icon_hl)
  return {
    { " " },
    { (icon and icon .. " " or ""), icon_hl or "SagaTitle" },
    { str, "Bold" },
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
  return dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      row = 1,
      relative = "cursor",
      height = 0.33,
      width = 0.25,
    },
  }, opts))
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
local function get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

local function telescope_util(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      opts.attach_mappings = function(_, map)
        map("i", "<a-c>", function()
          local action_state = require "telescope.actions.state"
          local line = action_state.get_current_line()
          telescope_util(
            params.builtin,
            vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
          )()
        end)
        return true
      end
    end

    require("telescope.builtin")[builtin](opts)
  end
end

return {
  -- HARPOON
  {
    "ThePrimeagen/harpoon",
    --stylua: ignore
    keys = {
      { "<Leader>ja", function() require("harpoon.mark").add_file() end,            desc = "Misc(harpoon): add file" },
      -- { "<Leader>jm", function() require("harpoon.ui").toggle_quick_menu() end,     desc = "Misc(harpoon): file menu" },
      { "<Leader>jm", "<CMD> Telescope harpoon marks <CR>",                         desc = "Misc(harpoon): file menu" },
      { "<Leader>jc", function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = "Misc(harpoon): command menu" },
      { "<Leader>1",  function() require("harpoon.ui").nav_file(1) end,             desc = "Misc(harpoon): file 1" },
      { "<Leader>2",  function() require("harpoon.ui").nav_file(2) end,             desc = "Misc(harpoon): file 2" },
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
    enabled = false,
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          search = { trigger = ";" },
        },
        char = {
          -- Jika key tidak di set disini, efek key akan di ignore
          keys = { "f", "F", "t", "T" },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Misc(flash)" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Misc(flash): treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Misc(flash): remote" },
      { "<c-s>", function() require("flash").toggle() end, mode = { "c" }, desc = "Misc(flash): toggle search",
      },
    },
  },
  -- NVIM-HLSLENS
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
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
    keys = {
      { "<Leader>ff", "<cmd>FzfLua files<cr>", desc = "Fzflua: find files" },
      { "<Leader>bf", "<CMD>FzfLua buffers<CR>", desc = "Buffer(Fzflua): open" },
      {
        "<Leader>bg",
        "<CMD>FzfLua blines<CR>",
        desc = "Buffer(FzfLua): live_grep on curbuf",
      },
      {
        "<Leader>bG",
        "<CMD>FzfLua lines<CR>",
        desc = "Buffer(Fzflua): live_grep on buffers",
      },
      { "<Leader>fC", "<CMD>FzfLua commands<CR>", desc = "Fzflua: commands" },
      {
        "<Leader>bo",
        "<CMD>FzfLua oldfiles<CR>",
        desc = "Buffer(Fzflua): oldfiles",
      },
      { "<Leader>fo", "<CMD>FzfLua files cwd=~/moxconf/development/dotfiles<CR>", desc = "Fzflua: dotfiles" },
      { "<Leader>fh", "<CMD>FzfLua help_tags<CR>", desc = "Fzflua: help tags" },
      {
        "<Leader>fl",
        "<CMD>FzfLua resume<CR>",
        desc = "Fzflua: resume (last search)",
      },
      { "<Leader>fg", "<CMD>FzfLua live_grep_glob<CR>", desc = "Fzflua: live grep" },
      {
        "<Leader>fg",
        "<CMD>FzfLua grep_visual<CR>",
        desc = "Fzflua: live grep (visual)",
        mode = {
          "v",
        },
      },
      { "<Leader>fc", "<CMD>FzfLua changes<CR>", desc = "Fzflua: changes" },
      { "<Leader>fj", "<CMD>FzfLua jumps<CR>", desc = "Fzflua: jumps" },
      { "<Leader>fm", "<CMD>FzfLua marks<CR>", desc = "Fzflua: marks" },
      { "<Leader>f=", "<CMD>FzfLua spell_suggest<CR>", desc = "Fzflua: spell" },
      { "<Leader>f<c-f>", [[<CMD>FzfLua search_history reverse_search=true<CR>]], desc = "Fzflua: search-history" },
      {
        "<Leader>fk",
        function()
          return require("fzf-lua").keymaps {
            winopts = {
              preview = {
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
        "<Leader>fF",
        function()
          local plugins_directory = vim.fn.stdpath "data" .. "/lazy"

          return require("fzf-lua").files {
            prompt = "Plugins❯ ",
            cwd = plugins_directory,
            prompt_title = "Find plugin files",
          }
        end,
        desc = "Fzflua: plugin files",
      },
      {
        "<Leader>fQ",
        [[<CMD>lua require("fzf-lua").quickfix({prompt = "    " })<CR>]],
        desc = "fzflua(qf): select qf list",
      },
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
            -- debug = true,
            winopts = {
              title = format_title("[QF] Grep", " "),
              height = 0.85,
              width = 0.90,
              -- preview = {
              --   vertical = "up:60%",
              --   horizontal = "left:60%",
              --   layout = "flex",
              -- },
            },
            cmd = pcmd,
          }
        end,
        desc = "fzflua(qf): grep qf items",
      },
      -- {
      --   "<Leader>bf",
      --   function()
      --     return require("fzf-lua").buffers {
      --       winopts = {
      --         split = "botright new",
      --         preview = { hidden = "hidden" },
      --         -- width = 0.5,
      --         -- height = 0.33,
      --       },
      --     }
      --   end,
      --   desc = "Buffer(Fzflua): open",
      -- },
      -- {
      --   "<c-v>",
      --   function()
      --     return require("fzf-lua").complete_path {
      --       winopts = {
      --         relative = "cursor",
      --         height = 0.33,
      --         width = 0.33,
      --       },
      --       cmd = "fd --color never --type f --hidden --follow",
      --     }
      --   end,
      --   mode = { "i" },
      --   desc = "Fzflua: complete path",
      -- },
    },
    config = function()
      local actions = require "fzf-lua.actions"
      local path = require "fzf-lua.path"

      require("fzf-lua").setup {
        winopts = {
          split = "botright new | resize 25",
        },
        fzf_opts = {
          ["--ansi"] = "",
          ["--info"] = "inline",
          ["--height"] = "100%",
          ["--layout"] = "reverse",
          ["--border"] = "none",

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
          find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
          fd_opts = [[--color never --type f --hidden --follow ]]
            .. [[--exclude .git --exclude node_modules --exclude '*.pyc']]
            .. [[ --exclude '*.ttf' --exclude '*.png' --exclude '*.otf']],
          actions = {
            ["default"] = function(selected, opts)
              local selected_item = selected[1]
              local status, entry = pcall(path.entry_to_file, selected_item, opts, opts.force_uri)

              local file_or_dir = vim.uv.fs_stat(entry.path)

              if file_or_dir and status and file_or_dir.type == "file" then
                require("fzf-lua").actions.file_edit(selected, opts)
              else
                require("fzf-lua").live_grep {
                  fzf_opts = {
                    ["--reverse"] = false,
                  },
                  -- winopts = {
                  --   title = format_title(entry.path, "  "),
                  --   preview = {
                  --     vertical = "up:45%",
                  --     horizontal = "right:60%",
                  --     layout = "vertical",
                  --   },
                  -- },
                  cwd = entry.path,
                }
              end
            end,
            ["ctrl-x"] = function(_, args)
              -- local winopts = {
              --   preview = { hidden = "nohidden" },
              --   title = format_title("Files", ""),
              --   split = "botright new",
              -- }
              if args.cmd:find "--type f" then
                args.cmd = args.cmd:gsub("--type f", "", 1)
                args.cmd:gsub("%s*\\*$", "")
                args.cmd = args.cmd .. " --type d"
                args.winopts = {
                  preview = { hidden = "hidden" },
                }
              elseif args.cmd:find "--type d" then
                args.cmd = args.cmd:gsub("--type d", "", 1)
                args.cmd:gsub("%s*\\*$", "")
                args.cmd = args.cmd .. " --type f"
                args.winopts = {
                  preview = { hidden = "nohidden" },
                  title = format_title("Files", ""),
                  -- title = format_title("Files", ""),
                  -- split = "botright new",
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
            cmd = "git ls-files --exclude-standard",
            winopts = { title = format_title("Git Files", "") },
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
            actions = {
              ["default"] = actions.git_buf_edit,
              ["right"] = actions.git_checkout,
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,

              -- Open hash on browser
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]

                vim.api.nvim_command(":GBrowse " .. commit_hash)

                Util.info("Open browser commit hash: " .. commit_hash, { title = "FZFGit" })
              end,
              -- Copy hash to clipboard
              ["ctrl-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]

                vim.fn.setreg("+", commit_hash)
                vim.fn.setreg("*", commit_hash)

                Util.info("Commit hash: " .. commit_hash .. " copied", { title = "FZFGit" })
              end,
              -- Open all diff for req commit
              ["ctrl-i"] = function(selected, _)
                local selection = selected[1]

                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]

                local cmdmsg = ":DiffviewOpen -uno " .. commit_hash

                vim.api.nvim_command(cmdmsg)

                Util.info("Open all diff " .. commit_hash, "FZFGit")
              end,
              -- Open diff current modified
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
          bcommits = {
            prompt = "  ",
            -- debug = true,
            preview = "git diff --color {1}~1 {1} -- <file>",
            preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
            winopts = {
              title = format_title("", "Buffer Commits"),
            },
            actions = {
              ["default"] = actions.git_buf_edit,
              ["ctrl-s"] = actions.git_buf_split,
              ["ctrl-v"] = actions.git_buf_vsplit,
              ["ctrl-t"] = actions.git_buf_tabedit,

              ["ctrl-y"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]

                vim.fn.setreg("+", commit_hash)
                vim.fn.setreg("*", commit_hash)

                Util.info("Commit hash: " .. commit_hash .. " copied", { title = "FZFGit" })
              end,
              ["ctrl-o"] = function(selected, _)
                local selection = selected[1]
                local commit_hash = Util.fzf_diffview.split_string(selection, " ")[1]

                Util.info("Open browser commit hash: " .. commit_hash, { title = "FZFGit" })

                vim.api.nvim_command(":GBrowse " .. commit_hash)
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
          -- prompt = "Rg❯ ",
          -- prompt = prompt,
          -- prompt = " ",
          prompt = " ",
          winopts = {
            title = format_title("Grep", " "),
            -- split = "botright new",
            -- preview = {
            --   vertical = "up:45%",
            --   horizontal = "left:65%",
            --   layout = "flex",
            -- },
          },
          input_prompt = "Grep For❯ ",
          grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
          rg_opts = "--column --line-number -i --hidden --no-heading --color=always --smart-case --max-columns=4096",

          -- fzf_opts = {
          --   ["--info"] = "default", -- hidden OR inline:⏐
          --   -- ["--reverse"] = true,
          --   ["--layout"] = "reverse",
          --   ["--scrollbar"] = "▓",
          --   -- ['--ellipsis'] = icons.misc.ellipsis,
          -- },
          rg_glob = false, -- default to glob parsing?
          glob_flag = "--iglob", -- for case sensitive globs use '--glob'
          glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
          actions = {
            -- actions inherit from 'actions.files' and merge
            -- this action toggles between 'grep' and 'live_grep'
            ["ctrl-g"] = { actions.grep_lgrep },
            ---@diagnostic disable-next-line: unused-local
            ["ctrl-y"] = function(_, opts)
              print "not implementation yet"
            end,
          },
        },
        args = {
          prompt = "Args❯ ",
          files_only = true,
          -- actions inherit from 'actions.files' and merge
          actions = {
            ["ctrl-x"] = { actions.arg_del, actions.resume },
          },
        },
        oldfiles = {
          -- prompt = prompt,
          prompt = "  ",
          cwd_only = true,
          stat_file = true, -- verify files exist on disk
          winopts = { title = format_title("History", "") },
          include_current_session = false, -- include bufs from current session
        },
        buffers = {
          prompt = "  ",
          winopts = { title = format_title("Buffers", "󰈙") },
          -- previewer = "bat", -- uncomment to override previewer
          file_icons = true, -- show file icons?
          color_icons = true, -- colorize file|git icons
          sort_lastused = true, -- sort buffers() by last used
          cwd_only = false, -- buffers for the cwd only
          cwd = nil, -- buffers list for a given dir
          fzf_opts = {
            ["--delimiter"] = "' '",
            ["--with-nth"] = "-1..",
          },
        },
        tabs = {
          prompt = "Tabs❯ ",
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
          -- previewer = "bat", -- uncomment to override previewer
          -- prompt = "Lines❯ ",
          prompt = "  ",
          show_unlisted = false, -- exclude 'help' buffers
          no_term_buffers = true, -- exclude 'term' buffers

          winopts = {
            split = false,
            title = format_title("Lines", " "),
            -- split = "botright new",
            -- preview = {
            --   vertical = "left:45%",
            --   horizontal = "up:60%",
            --   layout = "flex",
            -- },
          },
          fzf_opts = {
            -- do not include bufnr in fuzzy matching
            -- tiebreak by line no.
            ["--reverse"] = false,
            ["--delimiter"] = "'[\\]:]'",
            ["--nth"] = "2..",
            ["--tiebreak"] = "index",
            ["--tabstop"] = "1",
            ["--layout"] = "default",
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
          -- previewer = "bat", -- uncomment to override previewer
          -- prompt = "BLines❯ ",
          prompt = "  ",
          show_unlisted = true, -- include 'help' buffers
          no_term_buffers = false, -- include 'term' buffers
          no_header = true, -- hide grep|cwd header?
          no_header_i = true, -- hide interactive header?

          winopts = {
            split = false,
            title = format_title("Blines", " "),
            preview = {
              vertical = "down:45%",
              horizontal = "right:60%",
              layout = "flex",
            },
          },
          fzf_opts = {
            -- Cara menghilangkan filepath
            -- https://github.com/ibhagwan/fzf-lua/issues/228#issuecomment-983262485
            ["--delimiter"] = "'[\\]:]'",
            ["--with-nth"] = "3..",
            ["--tiebreak"] = "index",
            ["--tabstop"] = "1",
            ["--reverse"] = false,
            ["--layout"] = "default",
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
          prompt = "Tags❯ ",
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
          prompt = "BTags❯ ",
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
          -- actions inherit from 'actions.files'
        },
        colorschemes = {
          prompt = "Colorschemes❯ ",
          live_preview = true, -- apply the colorscheme on preview?
          actions = { ["default"] = actions.colorscheme },
          winopts = { height = 0.55, width = 0.30 },
        },
        quickfix = {
          prompt = "  ",
          winopts = {
            title = format_title("[QF]", " "),
          },
          file_icons = true,
          git_icons = true,
        },
        quickfix_stack = {
          prompt = "  ",
          winopts = {
            title = format_title("[QF]", " "),
          },
          marker = ">", -- current list marker
        },
        lsp = {
          cwd_only = true,
          -- winopts = {
          --   preview = {
          --     -- vertical = "up:65%",
          --     -- horizontal = "left:65%",
          --     -- split = "botright new",
          --     -- layout = "flex",
          --   },
          -- },
          symbols = {
            prompt = "  ",
            symbol_style = 1,
            symbol_icons = require("r.config").icons.kinds,
            fzf_opts = {
              ["--reverse"] = false,
              ["--scrollbar"] = "▓",
            },
            winopts = {
              title = format_title("Symbols", " "),
              -- split = "botright new",
              -- preview = {
              --   -- vertical = "down:45%",
              --   -- horizontal = "left:60%",
              --   -- layout = "flex",
              -- },
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
              -- preview = {
              --   vertical = "down:100%",
              --   horizontal = "up:65%",
              --   -- layout = "flex",
              -- },
            },
          },
        },
        diagnostics = {
          prompt = "Diagnostics❯ ",
          cwd_only = false,
          file_icons = true,
          git_icons = false,
          diag_icons = true,
          icon_padding = "", -- add padding for wide diagnostics signs
          -- winopts = {
          --   preview = {
          --     vertical = "up:65%",
          --     horizontal = "right:45%",
          --     layout = "vertical",
          --   },
          -- },
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
      require("fzf-lua").register_ui_select()
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
      { "df", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "LSP(diagnostic): telescope bufnr diagnostics" },
      { "dF", "<cmd>Telescope diagnostics<cr>", desc = "LSP(diagnostic): telescope all diagnostics" },
      {
        "gs",
        function()
          require("telescope.builtin").lsp_document_symbols {
            symbols = require("r.config").get_kind_filter(),
          }
        end,
        desc = "Telescope (lsp): goto symbol",
      },
      {
        "gS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols {
            symbols = require("r.config").get_kind_filter(),
          }
        end,
        desc = "Telescope(lsp): goto symbol (Workspace)",
      },
      -- { "<Leader>bf", "<CMD>Telescope buffers<CR>", desc = "Telescope: find buffers" },
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
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable "make" == 1,
        config = function()
          Util.on_load("telescope.nvim", function()
            require("telescope").load_extension "fzf"
            require("telescope").load_extension "grepqf"
            require("telescope").load_extension "harpoon"
            require("telescope").load_extension "file_browser"
            require("telescope").load_extension "live_grep_args"
            require("telescope").load_extension "menufacture"
          end)
        end,
      },
      "nvim-telescope/telescope-symbols.nvim",
      "molecule-man/telescope-menufacture",
      "debugloop/telescope-undo.nvim", -- Visualise undotree
      "nvim-telescope/telescope-live-grep-args.nvim",
      "tsakirist/telescope-lazy.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "benfowler/telescope-luasnip.nvim",
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
          borderchars = {
            "─",
            "│",
            "─",
            "│",
            "┌",
            "┐",
            "┘",
            "└",
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<c-c>"] = actions.close,

              -- ["<c-o>"] = trouble.open_with_trouble,

              ["<s-down>"] = actions.cycle_history_next,
              ["<s-up>"] = actions.cycle_history_prev,

              ["<c-f>"] = actions.results_scrolling_up,
              ["<c-b>"] = actions.results_scrolling_down,

              ["<a-a>"] = actions.toggle_all,

              ["<CR>"] = stopinsert(actions.select_default),
              ["<C-s>"] = stopinsert(actions.select_horizontal),
              ["<C-v>"] = stopinsert(actions.select_vertical),
              ["<C-t>"] = stopinsert(actions.select_tab),

              ["<c-r>"] = actions.to_fuzzy_refine,
              ["<F1>"] = actions.which_key, -- keys from pressing <C-/>

              ["<F6>"] = layout_actions.cycle_layout_next,
              ["<F4>"] = layout_actions.toggle_preview,

              ["<hh>"] = function()
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
          highlights = {
            theme = "ivy",
          },
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
          file_browser = {
            theme = "ivy",
            mappings = {
              i = {
                ["<CR>"] = stopinsert(actions.select_default),
                ["<C-x>"] = stopinsert(actions.select_horizontal),
                ["<C-v>"] = stopinsert(actions.select_vertical),
                ["<C-t>"] = stopinsert(actions.select_tab),
              },
            },
          },
          persisted = dropdown {},
          live_grep_args = {
            auto_quoting = false, -- enable/disable auto-quoting
          },
        },
      }
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
          Util.tiling.force_win_close({}, true)
          return require("spectre").open()
        end,
        desc = "Misc(spectre): open",
      },
      {
        "<Leader><s-f>",
        function()
          Util.tiling.force_win_close({}, true)
          return require("spectre").open_visual { select_word = true }
        end,
        desc = "Misc(spectre): open (visual)",
        mode = {
          "v",
        },
      },
    },
    opts = function()
      Util.cmd.augroup("SpectreClose", {
        event = { "FileType" },
        pattern = { "spectre_panel" },
        command = [[setlocal nofoldenable | nnoremap <buffer>q <cmd>q<CR>]],
      })

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
            map = "<leader>o",
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
            map = "<leader>v",
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
}
