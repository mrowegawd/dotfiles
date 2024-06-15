local fmt, api = string.format, vim.api
local uv = vim.uv

local Highlight = require "r.settings.highlights"

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

return {
  -- ORGMODE
  {
    "nvim-orgmode/orgmode",
    ft = "org",
    keys = {
      {
        "<Localleader>fA",
        function()
          return RUtils.notes.open_agenda_file_lists()
        end,
        desc = "Note: open agenda file list [orgmode]",
      },
      {
        "<Localleader>fc",
        function()
          require("orgmode").action "capture.prompt"
        end,
        desc = "Note: capture note [orgmode]",
      },
      {
        "<Localleader>fa",
        function()
          require("orgmode").action "agenda.prompt"
        end,
        desc = "Note: open agenda orgmode [orgmode]",
      },
    },
    dependencies = {
      "hrsh7th/nvim-cmp",
      "nvim-treesitter/nvim-treesitter",
      "lukas-reineke/indent-blankline.nvim",
      {
        "akinsho/org-bullets.nvim",
        config = function()
          require("org-bullets").setup {
            concealcursor = true, -- If false then when the cursor is on a line underlying characters are visible
            symbols = {
              headlines = { "◉", "○", "✸", "✿" },
              checkboxes = {
                half = { "", "OrgTSCheckboxHalfChecked" },
                done = { "✓", "OrgDone" },
                todo = { "˟", "OrgTODO" },
              },
            },
          }
        end,
      },
    },
    opts = {
      ui = {
        menu = {
          handler = function(data)
            local items = vim
              .iter(data.items)
              :map(function(i)
                return (i.key and not i.label:lower():match "quit") and i or nil
              end)
              :totable()

            vim.ui.select(items, {
              prompt = fmt(RUtils.config.icons.misc.fire .. " %s ", data.prompt),
              kind = "pojokan",
              format_item = function(item)
                return fmt("%s → %s", item.key, item.label)
              end,
            }, function(choice)
              if not choice then
                return
              end
              if choice.action then
                choice.action()
              end
            end)
          end,
        },
      },
      org_agenda_files = {
        fmt("%s/orgmode/gtd/*", RUtils.config.path.wiki_path),
        fmt("%s/orgmode/bookmarks/*", RUtils.config.path.wiki_path),
        fmt("%s/orgmode/habit/*", RUtils.config.path.wiki_path),
        fmt("%s/orgmode/day-to-remember/*", RUtils.config.path.wiki_path),
        fmt("%s/orgmode/project-todo/**/*", RUtils.config.path.wiki_path),
      },
      org_default_notes_file = fmt("%s/orgmode/gtd/refile.org", RUtils.config.path.wiki_path),
      org_todo_keywords = {
        "TODO(t)",
        "HOLD(h)", -- task yang ditangguhkan, no hint to continue
        "INPROGRESS(i)", -- task yang sedang dikerjakan
        "CHECK(c)", -- task yang boleh dikerjakan saat free-time
        "HBD(b)",
        "|",
        "DONE(d)",
        "",
      },
      org_todo_keyword_faces = {
        CHECK = ":foreground royalblue :weight bold :slant",
        TODO = ":foreground pink :background red :weight bold :slant",
        INPROGRESS = ":foreground magenta :background white :weight bold :slant italic",
        UNTASK = ":foreground deeppink :weight bold",
        HBD = ":foreground magenta :weight bold :slant",
        HOLD = ":foreground gray :weight bold :slant",
        DONE = ":foreground green :weight bold :slant",
        -- NEXT = ":foreground orange :weight bold",
      },
      org_agenda_skip_scheduled_if_done = true,
      org_hide_emphasis_markers = true,
      org_capture_templates = {
        t = {
          description = "Todo",
          template = "* TODO %? \n  SCHEDULED: %T",
          target = RUtils.config.path.wiki_path .. "/orgmode/gtd/refile.org",
        },
        i = {
          description = "Inbox me (Inbox)",
          -- template = "* %?",
          template = "* CHECK %? \n  SCHEDULED: %t",
          target = RUtils.config.path.wiki_path .. "/orgmode/gtd/inbox.org",
        },
        l = {
          description = "Link (Inbox)",
          -- template = "\n* CHECK %?\n  SCHEDULED: %t\n  %a\n\n",
          template = "* CHECK %?\n  SCHEDULED: %t\n  %a\n\n",
          target = RUtils.config.path.wiki_path .. "/orgmode/gtd/inbox.org",
        },
        u = {
          description = "URL bookmarks",
          template = "* RAPIKAN: %? \n  SCHEDULED: %t",
          target = RUtils.config.path.wiki_path .. "/orgmode/bookmarks/urls.org",
        },
        -- j = {
        --     description = "Journal",
        --     template = "\n** %<%Y-%m-%d> %<%A>\n*** %U\n\n%?",
        --     target = RUtils.config.path.wiki_path.. "/orgmode/gtd/journal.org",
        -- },
        -- k = {
        --     description = "Markdown",
        --     template = "\n* TODO %? \n  SCHEDULED: %t",
        --     target = RUtils.config.path.wiki_path .. "/orgmode/gtd/base.md",
        --     filetype = "markdown",
        -- },
      },
      -- win_split_mode = function(name)
      --   local bufnr = vim.api.nvim_create_buf(false, true)
      --   --- Setting buffer name is required
      --   vim.api.nvim_buf_set_name(bufnr, name)
      --   local fill = 0.4
      --   local width = math.floor((vim.o.columns * fill))
      --   local height = math.floor((vim.o.lines * fill))
      --   local row = math.floor((((vim.o.lines - height) / 2) - 1))
      --   local col = math.floor(((vim.o.columns - width) / 2))
      --   vim.api.nvim_open_win(bufnr, true, {
      --     relative = "win",
      --     width = width,
      --     height = height,
      --     row = row,
      --     col = col,
      --     style = "minimal",
      --     border = "rounded",
      --   })
      -- end,

      win_split_mode = { "float", 0.6 },
      -- win_split_mode = "float",
      mappings = {
        disable_all = false,
        prefix = "<Leader>o",
        global = {
          org_capture = "<Localleader>fc",
          org_agenda = "<Localleader>fa",
        },
        agenda = {
          org_agenda_later = "f",
          org_agenda_earlier = "b",
          org_agenda_goto_today = "@",
          org_agenda_day_view = "vd",
          org_agenda_week_view = "vw",
          org_agenda_month_view = "vm",
          org_agenda_year_view = "vy",
          org_agenda_quit = "q",
          org_agenda_switch_to = nil,
          org_agenda_goto = "<TAB>",
          org_agenda_show_help = "?",
          org_agenda_redo = "r",
          org_agenda_goto_date = "cd",
          org_agenda_todo = "ct",
          org_agenda_clock_goto = "<prefix>xj",
          org_agenda_set_effort = "<prefix>xe",
          org_agenda_clock_in = "<prefix>I",
          org_agenda_clock_out = "<prefix>O",
          org_agenda_clock_cancel = "<prefix>C",
          org_agenda_clockreport_mode = "R",
          org_agenda_priority = "<prefix>1",
          org_agenda_priority_up = "<c-Up>",
          org_agenda_priority_down = "<c-Down>",
          org_agenda_archive = "<prefix>$",
          org_agenda_toggle_archive_tag = "<leader>T",
          org_agenda_set_tags = "<leader>t",
          org_agenda_deadline = "<leader>d",
          org_agenda_schedule = "<leader>s",
          org_agenda_filter = "/",
        },
        capture = {
          org_capture_finalize = "<C-c>",
          org_capture_refile = "<Leader>or",
          org_capture_kill = { "q", "<ESC>" },
          org_capture_show_help = "?",
        },
        org = {
          org_refile = "<prefix>r",
          org_timestamp_up = "<c-a>",
          org_timestamp_down = "<c-x>",
          org_change_date = "cd",
          org_todo = "ct",
          org_toggle_checkbox = "<C-c>",
          org_open_at_point = "<prefix>o",
          org_meta_return = "<F12>", -- Add heading, item or row
          org_return = "<F11>",
          -- org_global_cycle = "<a-o>",
          -- org_cycle = "<BS>",
          -- org_cycle = "<TAB>",
          org_cycle = "<BS>",
          org_global_cycle = "<S-TAB>",
          org_archive_subtree = "<prefix>$",
          org_set_tags_command = "<Leader>t",
          org_toggle_archive_tag = "<Leader>T",

          org_next_visible_heading = "<a-n>",
          org_previous_visible_heading = "<a-p>",

          org_toggle_heading = "<leader>o*",
          org_show_help = "?",
          org_timestamp_up_day = "<PageUp>",
          org_timestamp_down_day = "<PageDown>",

          org_priority = "<prefix>,",
          org_priority_up = "<c-Up>",
          org_priority_down = "<c-Down>",

          org_todo_prev = "ciT",
          org_edit_special = [[<prefix>']],

          org_do_promote = "<<",
          org_do_demote = ">>",
          org_promote_subtree = "<left>",
          org_demote_subtree = "<right>",

          org_insert_heading_respect_content = "<prefix>ih", -- Add new headling after current heading block with same level
          org_insert_todo_heading = "<prefix>iT", -- Add new todo headling right after current heading with same level
          org_insert_todo_heading_respect_content = "<prefix>it", -- Add new todo headling after current heading block on same level
          org_move_subtree_up = "<S-UP>",
          org_move_subtree_down = "<S-DOWN>",
          org_export = "<leader>a",
          org_forward_heading_same_level = "]]",
          org_backward_heading_same_level = "[[",
          outline_up_heading = "g{",
          org_time_stamp = "<prefix>it",
          org_time_stamp_inactive = "<prefix>iT",
          org_deadline = "<leader>d",
          org_schedule = "<leader>s",
          org_clock_in = "<prefix>I",
          org_clock_out = "<prefix>O",
          org_clock_cancel = "<prefix>C",
          org_clock_goto = "<prefix>xj",
          org_set_effort = "<prefix>xe",
        },
      },
    },
    config = function(_, opts)
      Highlight.plugin("Org_HiCus", {
        theme = {
          ["miasma"] = {
            { OrgAgendaScheduled = { fg = { from = "LineNr", attr = "fg", alter = 1 } } },
          },
        },
      })

      local orgmode = require "orgmode"
      orgmode.setup(opts)
    end,
  },
  -- CALENDAR
  {
    "renerocksai/calendar-vim",
    cmd = "Calendar",
    init = function()
      vim.g.calendar_mark = "bottom"
      vim.g.calendar_keys = {
        goto_next_month = "<a-n>",
        goto_prev_month = "<a-p>",
        goto_today = "~",
        redisplay = "r",
      }

      Highlight.plugin("CalendarVim", {
        {
          CalToday = {
            bg = { from = "GitSignsChange", attr = "fg" },
            fg = { from = "Normal", attr = "bg" },
            bold = true,
          },
        },
      })
    end,
    keys = {
      -- { "<Localleader>oc", "<CMD> Calendar <CR>", desc = "Misc: open calendar [calendar.nvim]" },
      {
        "<Localleader>oc",
        function()
          vim.cmd [[Calendar]]
          vim.cmd "vertical resize +20"
        end,
        desc = "Misc: open calendar [calendar-nvim]",
      },
    },
  },
  -- IMAGE
  {
    "3rd/image.nvim",
    ft = { "markdown", "norg", "oil", "octo" },
    enabled = function()
      if vim.g.neovide then
        return false
      end
      return true
    end,
    build = function()
      local has_magick = pcall(require, "magick")
      if not has_magick and vim.fn.executable "luarocks" == 1 then
        local is_mac = uv.os_uname().sysname == "Darwin"
        if is_mac then
          vim.fn.system "luarocks --lua-dir=$(brew --prefix)/opt/lua@5.1 --lua-version=5.1 install magick"
        else
          vim.fn.system "luarocks --local --lua-version=5.1 install magick"
        end
        if vim.v.shell_error ~= 0 then
          vim.notify("Error installing magick with luarocks", vim.log.levels.WARN)
        end
      end
    end,
    opts = {
      backend = "ueberzug",
      editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = true,
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
    },
    config = function(_, opts)
      -- Requirements (linux):
      -- sudo apt-get install libmagickwand-dev
      -- sudo apt-get install libgraphicsmagick1-dev
      local has_magick = pcall(require, "magick")
      if has_magick then
        require("image").setup(opts)
      end
    end,
  },
  -- OBSIDIAN.NVIM
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   fmt("BufReadPre %s", RUtils.config.path.wiki_path),
    --   fmt("BufNewFile %s", RUtils.config.path.wiki_path),
    -- },
    cmd = { "ObsidianDailies" },
    keys = {
      {
        "<Localleader>fg",
        function()
          return fzf_lua.live_grep_glob {
            prompt = "  ",
            cwd = RUtils.config.path.wiki_path,
            rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.md" ]],
            winopts = {
              title = RUtils.fzflua.format_title(
                "Obsidian > Grep",
                RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope3),
                "GitSignsChange"
              ),
            },
          }
        end,
        desc = "Note: live grep notes [obsidian]",
      },
      {
        "<Localleader>fg",
        function()
          local viz = RUtils.cmd.get_visual_selection { strict = true }
          if viz then
            return fzf_lua.grep {
              prompt = "  ",
              query = string.format("%s", viz.selection),
              -- no_esc = true,
              rg_glob = true,
              cwd = RUtils.config.path.wiki_path,
              rg_opts = [[--column --line-number --hidden --ignore-case --smart-case -g "*.md" ]],
              winopts = {
                title = RUtils.fzflua.format_title(
                  "Obsidian > Grep",
                  RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.telescope3),
                  "GitSignsChange"
                ),
              },
            }
          end
        end,
        desc = "Note: live grep notes (visual) [obsidian]",
        mode = "v",
      },
      {
        "<Localleader>ff",
        function()
          return fzf_lua.files {
            prompt = "   ",
            cwd = RUtils.config.path.wiki_path,
            file_ignore_patterns = { "%.norg$", "%.json$", "%.org$", "%.png$" },
            rg_opts = [[--column --type=md --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]],

            winopts = {
              -- fullscreen = true,
              title = RUtils.fzflua.format_title(
                "Obsidian > Note files",
                RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.bookmark),
                "GitSignsChange"
              ),
            },
          }
        end,
        desc = "Note: find note files [obsidian]",
      },
      {
        "<Localleader>fn",
        ":ObsidianNew ",
        desc = "Note: create new note [obsidian]",
      },
      {
        "<Localleader>fN",
        "<CMD>ObsidianDailies<CR>",
        desc = "Note: open create new note dailies [obsidian]",
      },
      {
        "<Localleader>fl",
        function()
          RUtils.markdown.find_note_by_tag()
        end,
        desc = "Note: find note by tags [obsidian]",
      },
      {
        "<Localleader>fT",
        function()
          RUtils.markdown.find_global_titles()
        end,
        desc = "Note: search title global [obsidian]",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
      "3rd/image.nvim",
    },
    opts = {
      dir = RUtils.config.path.wiki_path, -- no need to call 'vim.fn.expand' here

      workspaces = {
        {
          name = "obsidian",
          path = "~/Dropbox/neorg",
        },

        {
          name = "work",
          path = "~/Dropbox/neorg/work",
        },
      },

      daily_notes = {
        folder = "Drafts",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%d-%m-%Y",
        -- date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = "%B %-d, %Y",
      },

      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        local time = os.date("%Y-%m-%d", os.time() - 86400)
        return tostring(time) .. "_" .. suffix
      end,

      picker = {
        name = "fzf-lua",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },

      preferred_link_style = "markdown",

      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
          for k, v in pairs(note.metadata) do
            print(k, v)
            out[k] = v
          end
        end
        return out
      end,

      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      mappings = {
        ["<c-c>"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },

      follow_url_func = function(url)
        vim.fn.jobstart { "open", url }
      end,
    },

    config = function(_, opts)
      require("obsidian").setup(opts)

      RUtils.cmd.augroup("ManageNoteMappingMarkdown", {
        event = { "FileType" },
        pattern = { "markdown" },
        command = function()
          require("r.keymaps.note").neorg_mappings_ft(api.nvim_get_current_buf())
        end,
      })
    end,
  },
  -- HEADLINES.NVIM
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
    opts = function()
      Highlight.plugin("headlines", {
        theme = {
          ["*"] = {
            { Dash = { bg = "NONE", bold = true } },
            { CodeBlock = { bg = { from = "Normal", attr = "bg", alter = 0.2 } } },
            -- {
            --   Headline1 = {
            --     bg = "#332F46",
            --     fg = { from = "PreProc", attr = "fg", alter = 1 },
            --     bold = true,
            --   },
            -- },
            -- {
            --   Headline2 = {
            --     bg = "#3F2F46",
            --     fg = { from = "PreProc", attr = "fg", alter = 0.8 },
            --     bold = true,
            --   },
            -- },
            --
            -- {
            --   Headline3 = {
            --     bg = "#462F42",
            --     fg = { from = "PreProc", attr = "fg", alter = 0.6 },
            --     bold = true,
            --   },
            -- },
            -- {
            --
            --   Headline4 = {
            --     bg = "#462F37",
            --     fg = { from = "PreProc", attr = "fg", alter = 0.4 },
            --     bold = true,
            --   },
            -- },
            -- {
            --   Headline5 = {
            --     bg = "#46332F",
            --     fg = { from = "PreProc", attr = "fg", alter = 0.2 },
            --     bold = true,
            --   },
            -- },
            -- {
            --   Headline6 = {
            --     -- bg = { from = "Normal", attr = "bg" },
            --     bg = "#463F2F",
            --     -- bg = { from = "Normal", attr = "bg", alter = -0.2 },
            --     fg = { from = "PreProc", attr = "fg", alter = 0 },
            --     bold = true,
            --   },
            -- },
          },
        },
      })
      return {
        org = { headline_highlights = false },
        norg = { headline_highlights = false, codeblock_highlight = false },
        markdown = {
          -- headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5" },
          headline_highlights = false,
          -- fat_headline_lower_string = "▔",
          codeblock_highlight = "CodeBlock1",
        },
        fat_headline_lower_string = "▔",
      }
    end,
  },
}
