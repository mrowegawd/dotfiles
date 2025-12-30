return {
  -- ORGMODE
  {
    "nvim-orgmode/orgmode",
    event = "LazyFile",
    -- enabled = false,
    -- ft = { "org" },
    -- event = "VeryLazy",
    -- lazy = false,
    dependencies = {
      "akinsho/org-bullets.nvim",
      {
        "lukas-reineke/headlines.nvim",
        ft = { "org" },
        opts = {
          markdown = {
            headline_highlights = false,
            codeblock_highlight = false,
            quote_highlight = false,
            bullet_highlights = false,
          },
          org = {
            headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6" },
            codeblock_highlight = "CodeBlock",
            dash_highlight = "Dash",
            dash_string = "-",
            doubledash_highlight = "DoubleDash",
            doubledash_string = "=",
            quote_highlight = "Quote",
            quote_string = "┃",
            fat_headlines = false,
            fat_headline_upper_string = "▃",
            fat_headline_lower_string = "🬂",
          },
        },
      },
    },
    keys = {
      {
        "<Localleader>aA",
        function()
          return RUtils.notes.open_agenda_file_lists()
        end,
        desc = "Note: open agenda file list [orgmode]",
      },
      {
        "<Localleader>ac",
        function()
          require("orgmode").action "capture.prompt"
        end,
        desc = "Note: capture note [orgmode]",
      },
      {
        "<Localleader>aa",
        function()
          require("orgmode").action "agenda.prompt"
        end,
        desc = "Note: open agenda orgmode [orgmode]",
      },
      {
        "<Localleader>afgO",
        function()
          RUtils.notes.grep_title()
        end,
        desc = "Note: jump global title [orgmode]",
      },
      {
        "<Localleader>afgo",
        function()
          RUtils.notes.grep_title(true)
        end,
        desc = "Note: grep [orgmode]",
      },
    },
    opts = function()
      -- local Highlight = require "r.settings.highlights"
      -- local done_hi = Highlight.get("Comment", "fg")
      -- local bg_hi = Highlight.darken(Highlight.get("Normal", "bg"), 0.4, Highlight.get("KeywordMatch", "fg"))
      -- local todo_fg = Highlight.get("KeywordMatch", "fg")
      return {
        ui = {
          input = { use_vim_ui = true }, -- menggunakan vim.ui.input nvim, jadi snacks.nvim yang handle nya
          agenda = { preview_window = { border = RUtils.config.icons.border.line }, focusable = false },
          menu = {
            handler = function(data)
              local items = vim
                .iter(data.items)
                :map(function(i)
                  return (i.key and not i.label:lower():match "quit") and i or nil
                end)
                :totable()

              vim.ui.select(items, {
                prompt = string.format(RUtils.config.icons.misc.fire .. " %s ", data.prompt),
                kind = "pojokan",
                format_item = function(item)
                  return string.format("%s → %s", item.key, item.label)
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
          -- Mobilephone
          -- fmt("%s/orgmode/gym/*", RUtils.config.path.wiki_path),
          -- fmt("%s/orgmode/habit/*", RUtils.config.path.wiki_path),

          -- Notes
          -- string.format("%s/**/*", RUtils.config.path.wiki_path),

          -- Todo/Task
          string.format("%s/orgmode/gtd/*", RUtils.config.path.wiki_path),
          string.format("%s/orgmode/bookmarks/*", RUtils.config.path.wiki_path),
          string.format("%s/orgmode/day-to-remember/*", RUtils.config.path.wiki_path),
          string.format("%s/orgmode/project-todo/**/*", RUtils.config.path.wiki_path),
          string.format("%s/orgmode/nvim-plugin/qfbookmark/**/*", RUtils.config.path.wiki_path),
        },
        org_default_notes_file = string.format("%s/orgmode/gtd/refile.org", RUtils.config.path.wiki_path),
        org_todo_keywords = {
          "TODO(t)",
          "LEARNING(l)", -- task untuk jadwal learning
          "PROGRESS(p)", -- task yang sedang dikerjakan
          "NEXT(n)", -- task yang akan dialankan setelah 'progress' task selesai
          "CHECK(c)", -- task yang boleh dikerjakan saat free-time
          "HBD(b)",
          "STATUS(s)", -- task yang dikerjakan tapi bukan project, seperti belajar, baca buku, dsb
          "|",
          "DONE(d)",
        },
        org_todo_keyword_faces = {
          CHECK = ":foreground blue :background royalblue :weight bold :slant normal",
          NEXT = ":foreground brightmagenta :background darkmagenta :weight bold :slant normal",
          TODO = ":foreground red :weight bold :slant normal",
          HBD = ":foreground black :background pink :weight bold :slant normal",
          STATUS = ":foreground black :background darkcyan :weight bold :slant normal",
          DONE = ":foreground gray :weight bold :slant normal",

          PROGRESS = ":foreground white :background red :weight bold :slant italic",
          LEARNING = ":foreground black :background darkyellow :weight bold :slant normal",
        },
        org_agenda_skip_scheduled_if_done = true,
        org_hide_emphasis_markers = true,
        org_capture_templates = {
          t = {
            description = "Todo",
            template = "* TODO %? \n  SCHEDULED: %T\n\n\tDescribe:\n\n\tCode Error:\n\n\tExpected:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/refile.org",
          },
          i = {
            description = "Inbox",
            template = "* CHECK %? \n  SCHEDULED: %t\n\n\tDescribe:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/inbox.org",
          },
          l = {
            description = "Link",
            template = "* CHECK %?\n  SCHEDULED: %t\n  %a\n\n\tDescribe:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/inbox.org",
          },
          u = {
            description = "URL bookmarks",
            template = "* RAPIKAN: %? \n  SCHEDULED: %t\n\n\tWhat about this URL:\n\n\tURL:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/bookmarks/urls.org",
          },
          j = {
            description = "Journal",
            template = "\n** %<%Y-%m-%d> %<%A>\n*** %U\n\n%?",
            target = RUtils.config.path.wiki_path .. "/orgmode/journal/journal.org",
          },
          -- k = {
          --     description = "Markdown",
          --     template = "\n* TODO %? \n  SCHEDULED: %t",
          --     target = RUtils.config.path.wiki_path .. "/orgmode/gtd/base.md",
          --     filetype = "markdown",
          -- },
        },
        win_split_mode = { "float", 0.6 },
        mappings = {
          disable_all = false,
          prefix = "<Leader>c",
          global = {
            org_capture = "<Localleader>ac",
            org_agenda = "<Localleader>aa",
          },
          agenda = {
            -- Views
            org_agenda_day_view = "vd",
            org_agenda_week_view = "vw",
            org_agenda_month_view = "vm",
            org_agenda_year_view = "vy",

            -- Navigation
            org_agenda_later = "f",
            org_agenda_earlier = "b",
            org_agenda_goto_today = "~",
            org_agenda_goto = { "<CR>", "o" },
            org_agenda_goto_date = "D",

            org_agenda_switch_to = "<TAB>", -- tidak dipakai?

            -- Todo Effort
            org_agenda_todo = "<Leader>t",
            org_agenda_set_effort = "ie",

            -- Clock
            org_agenda_clock_in = "ci",
            org_agenda_clock_out = "co",
            org_agenda_clock_goto = "cg",
            org_agenda_clock_cancel = "cc",

            org_agenda_clockreport_mode = "cP", -- buat report clock

            -- Priority
            org_agenda_priority = "P",
            org_agenda_priority_up = "<S-up>",
            org_agenda_priority_down = "<S-down>",

            org_agenda_archive = "<F9>", -- tidak terpakai?

            --- Tags, Refile / Notes
            org_agenda_set_tags = "ig",
            org_agenda_refile = "r",
            org_agenda_add_note = "in",

            org_agenda_toggle_archive_tag = "<prefix><F9>",

            org_agenda_deadline = "id",
            org_agenda_schedule = "is",

            -- Misc
            org_agenda_filter = "/",
            org_agenda_redo = "R",
            org_agenda_quit = "q",
            org_agenda_show_help = "?",
          },
          capture = {
            org_capture_finalize = { "<C-c>", "<C-s>" },
            org_capture_refile = "<Leader>or",
            org_capture_kill = { "<Leader><TAB>", "q", "<C-q>" },
            org_capture_show_help = "?",
          },
          note = {
            org_note_finalize = { "<C-c>", "<C-s>" },
            org_note_kill = { "<Leader><TAB>", "q", "<C-q>" },
          },
          org = {
            -- Timestamp
            org_timestamp_up_day = "<Up>",
            org_timestamp_down_day = "<Down>",
            org_timestamp_up = "<C-PageUp>",
            org_timestamp_down = "<C-PageDown>",

            -- Todo / Heading
            org_todo = "<Leader>t",
            org_todo_prev = "<Leader>T",
            org_toggle_heading = "*",

            -- Navigation
            org_next_visible_heading = "<c-n>",
            org_previous_visible_heading = "<c-p>",
            org_forward_heading_same_level = "]]",
            org_backward_heading_same_level = "[[",
            outline_up_heading = "g{",

            -- Insert
            org_insert_heading_respect_content = "i<CR>",
            org_insert_todo_heading = "iT",
            org_insert_todo_heading_respect_content = "<C-t>",

            -- Fold / Cycle
            org_cycle = { "<TAB>", "fc", "oz" },
            org_global_cycle = { "<S-TAB>", "zb" },

            -- Clock
            org_clock_in = "ci",
            org_clock_out = "co",
            org_clock_cancel = "cc",
            org_clock_goto = "cg",

            -- Priority
            org_priority = "P",
            org_priority_up = "<S-Up>",
            org_priority_down = "<S-Down>",

            -- Promote / Demote
            org_do_promote = "<",
            org_do_demote = ">",
            org_promote_subtree = "<a-<>",
            org_demote_subtree = "<a->>",

            -- Move subtree
            org_move_subtree_up = "<a-p>",
            org_move_subtree_down = "<a-n>",

            -- Tags / Refile / Notes
            org_set_tags_command = "ig",
            org_refile = "r",

            -- Links
            org_insert_link = "il",
            org_store_link = "iL",

            -- Timestamp Insert
            org_time_stamp = "it",
            org_time_stamp_inactive = "ii",
            org_toggle_timestamp_type = "iT",

            -- Insert Deadline or Schedule
            org_deadline = "id",
            org_schedule = "is",
            org_set_effort = "ie",
            org_add_note = "in",

            -- Export / Babel
            org_export = "<Leader>fe",
            org_babel_tangle = "bt",

            -- Gunanya buat edit contents dalam block code di beda buffer,
            -- cara: masuk ke block code (begin_src), lalu combine mapping ini,
            -- jika selesi :wq
            org_edit_special = "<prefix>E",

            -- set current node to archived
            org_archive_subtree = "<F9>",
            org_toggle_archive_tag = "<Leader><F9>",

            org_toggle_checkbox = "<C-c>",
            org_open_at_point = { "<Leader>oo", "<Leader>ld" },

            org_meta_return = "<Leader><C-CR>", -- Add heading, item or row (context-dependent)
            org_return = "<F11>",

            org_show_help = "?",
          },
        },
      }
    end,

    config = function(_, opts)
      local orgmode = require "orgmode"
      orgmode.setup(opts)
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

      RUtils.map.augroup("ManageNoteMappingOrg", {
        event = { "FileType" },
        pattern = { "org" },
        command = function()
          require("r.keymaps.note").neorg_mappings_ft(vim.api.nvim_get_current_buf())
        end,
      })
    end,
  },
  -- org blink source
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "nvim-orgmode/orgmode", "saghen/blink.compat" },
    opts = {
      sources = {
        per_filetype = {
          org = { "buffer", "path", "orgmode", "snippets" },
        },
        providers = {
          orgmode = {
            name = "Orgmode",
            module = "orgmode.org.autocompletion.blink",
            fallbacks = { "buffer" },
          },
        },
      },
    },
  },
  -- MD-AGENDA (disabled)
  {
    "zenarvus/md-agenda.nvim",
    enabled = false,
    event = "VeryLazy",
    keys = {
      {
        "<Localleader>aa",
        ":AgendaDashboard<CR>",
        desc = "Note: check task [md-agenda]",
      },
      {
        "<Localleader>aC",
        ":CheckTask<CR>",
        desc = "Note: check task [md-agenda]",
      },

      {
        "is",
        ":TaskScheduled<CR>",
        desc = "Note: insert scheduled date [md-agenda]",
        ft = "markdown",
      },
      {
        "id",
        ":TaskDeadline<CR>",
        desc = "Note: insert deadline date [md-agenda]",
        ft = "markdown",
      },
    },
    opts = {
      --- REQUIRED ---
      agendaFiles = {
        "~/notes/agenda.md",
        "~/notes/habits.md", -- Single Files
        "~/notes/agendafiles/", -- Folders
      },

      --- OPTIONAL ---
      -- Number of days to display on one agenda view page.
      -- Default: 10
      agendaViewPageItems = 10,
      -- Number of days before the deadline to show a reminder for the task in the agenda view.
      -- Default: 30
      remindDeadlineInDays = 30,
      -- Number of days before the scheduled time to show a reminder for the task in the agenda view.
      -- Default: 10
      remindScheduledInDays = 10,
      -- "vertical" or "horizontal"
      -- Default: "horizontal"
      agendaViewSplitOrientation = "horizontal",

      -----

      -- Number of past days to show in the habit view.
      -- Default: 24
      habitViewPastItems = 24,
      -- Number of future days to show in the habit view.
      -- Default: 3
      habitViewFutureItems = 3,
      -- "vertical" or "horizontal"
      -- Default: "horizontal"
      habitViewSplitOrientation = "horizontal",

      -- Custom types that you can use instead of TODO.
      -- Default: {}
      -- The plugin will give an error if you use RGB colors (e.g. #ffffff)
      customTodoTypes = { SOMEDAY = "magenta" }, -- A map of item type and its color

      -- "vertical" or "horizontal"
      -- Default: "horizontal"
      dashboardSplitOrientation = "horizontal",
      -- Set the dashboard view.
      dashboard = {
        {
          "All TODO Items", -- Group name
          {
            -- Item types, e.g., {"TODO", "INFO"}.
            -- Gets the items that match one of the given types. Ignored if empty.
            type = { "TODO" },

            -- List of tags to filter. Use AND/OR conditions.
            -- e.g., {AND = {"tag1", "tag2"}, OR = {"tag1", "tag2"}}. Ignored if empty.
            tags = {},

            -- Both, deadline and scheduled filters can take the same parameters.
            -- "none", "today", "past", "nearFuture", "before-yyyy-mm-dd", "after-yyyy-mm-dd".
            -- Ignored if empty.
            deadline = "",
            scheduled = "",
          },
          -- {...}, Additional filter maps can be added in the same group.
        },
        -- {"Other Group", {...}, ...}
        -- ...
      },

      -- Optional: Change agenda colors.
      tagColor = "blue",
      titleColor = "yellow",

      todoTypeColor = "cyan",
      habitTypeColor = "cyan",
      infoTypeColor = "lightgreen",
      dueTypeColor = "red",
      doneTypeColor = "green",
      cancelledTypeColor = "red",

      completionColor = "lightgreen",
      scheduledTimeColor = "cyan",
      deadlineTimeColor = "red",

      habitScheduledColor = "yellow",
      habitDoneColor = "green",
      habitProgressColor = "lightgreen",
      habitPastScheduledColor = "darkyellow",
      habitFreeTimeColor = "blue",
      habitNotDoneColor = "red",
      habitDeadlineColor = "gray",
    },

    -- Optional: Set keymaps for commands
    -- vim.keymap.set("n", "<Localleader>aC", ":CheckTask<CR>")
    -- vim.keymap.set("n", "<A-c>", ":CancelTask<CR>")
    --
    -- vim.keymap.set("n", "<A-h>", ":HabitView<CR>")
    -- vim.keymap.set("n", "<A-o>", ":AgendaDashboard<CR>")
    -- vim.keymap.set("n", "<A-a>", ":AgendaView<CR>")

    -- Optional: Set a foldmethod to use when folding the logbook entries.
    -- The plugin tries to respect to the user default.
    -- vim.o.foldmethod = "marker" -- "marker", "syntax" or "expr"
    -- Note: When navigating to the buffers with Telescope, "syntax" and "expr" options may not work properly.

    -- Optional: Create a custom agenda view command to only show the tasks with specific tags
    -- vim.api.nvim_create_user_command("WorkAgenda", function()
    --   vim.cmd "AgendaViewWTF work companyA" -- Run the agenda view with tag filters
    -- end, {})
  },
  -- OBSIDIAN.NVIM
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    cmd = "Obsidian",
    ft = "markdown",
    keys = {
      {
        "<Localleader>afgg",
        function()
          local fzf_lua = RUtils.cmd.reqcall "fzf-lua"
          return fzf_lua.live_grep_glob {
            prompt = RUtils.fzflua.padding_prompt(),
            cwd = RUtils.config.path.wiki_path,
            rg_opts = [[--column --hidden --line-number --no-heading --ignore-case --smart-case --color=always --colors 'match:fg:178' --max-columns=4096 -g "*.md" ]],
            winopts = {
              title = RUtils.fzflua.format_title(
                "Obsidian > Grep",
                RUtils.strip_whitespaces(RUtils.config.icons.misc.telescope3)
              ),
            },
          }
        end,
        desc = "Note: grep [obsidian]",
      },
      {
        "<Localleader>afgg",
        function()
          local fzf_lua = RUtils.cmd.reqcall "fzf-lua"
          local viz = RUtils.get_visual_selection { strict = true }
          if viz then
            return fzf_lua.grep {
              prompt = RUtils.fzflua.padding_prompt(),
              query = string.format("%s", viz.selection),
              -- no_esc = true,
              rg_glob = true,
              cwd = RUtils.config.path.wiki_path,
              rg_opts = [[--column --line-number --hidden --ignore-case --color=always --colors 'match:fg:178' --smart-case -g "*.md" ]],
              winopts = {
                title = RUtils.fzflua.format_title(
                  "Obsidian > Grep",
                  RUtils.strip_whitespaces(RUtils.config.icons.misc.telescope3)
                ),
              },
            }
          end
        end,
        desc = "Note: grep (visual) [obsidian]",
        mode = "x",
      },
      {
        "<Localleader>aff",
        function()
          local fzf_lua = RUtils.cmd.reqcall "fzf-lua"
          return fzf_lua.files {
            prompt = RUtils.fzflua.padding_prompt(),
            cwd = RUtils.config.path.wiki_path,
            file_ignore_patterns = { "%.norg$", "%.json$", "%.org$", "%.png$" },
            rg_opts = [[--column --type=md --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 --colors 'match:fg:178' ]],

            winopts = {
              -- fullscreen = true,
              title = RUtils.fzflua.format_title(
                "Obsidian > Note files",
                RUtils.strip_whitespaces(RUtils.config.icons.misc.bookmark)
              ),
            },
          }
        end,
        desc = "Note: find note files [obsidian]",
      },
      {
        "<Localleader>aN",
        ":ObsidianNew ",
        desc = "Note: create new note [obsidian]",
      },
      -- {
      --   "<Localleader>an",
      --   ":ObsidianToday<CR>",
      --   desc = "Note: add note today [obsidian]",
      -- },
      -- {
      --   "<Localleader>ad",
      --   "<CMD>ObsidianDailies<CR>",
      --   desc = "Note: open and select daily note [obsidian]",
      -- },
      {
        "<Localleader>al",
        function()
          RUtils.markdown.find_note_by_tag()
        end,
        desc = "Note: find note by tags [obsidian]",
      },
      {
        "<Localleader>afgt",
        function()
          if vim.bo.filetype ~= "markdown" then
            ---@diagnostic disable-next-line: undefined-field
            RUtils.warn("Cannot continue..\nThis not wiki or markdown file!", { title = "Obsidian" })
            return
          end
          RUtils.markdown.find_local_titles()
          vim.cmd "normal! zRzz"
        end,
        desc = "Note: jump local title [obsidian]",
      },
      {
        "<Localleader>afgT",
        function()
          RUtils.markdown.find_global_titles()
          vim.cmd "normal! zRzz"
        end,
        desc = "Note: jump global title [obsidian]",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      dir = RUtils.config.path.wiki_path, -- no need to call 'vim.fn.expand' here
      workspaces = {
        {
          name = "journal",
          date_format = "%d-%m-%Y %A",
          time_format = "%H:%M",
          path = "~/Dropbox/neorg/journal",
        },
        {
          name = "work",
          path = "~/Dropbox/neorg/work",
        },
      },
      daily_notes = {
        folder = "Drafts",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%B-%d",
        -- date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = "%B %-d, %Y",
      },
      notes_subdir = "journal",
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
        -- Add the title of the note as an alias.
        -- if note and note.title then
        --   note:add_alias(note.title)
        -- end

        local out = {
          id = note.id,
          aliases = note.aliases,
          tags = note.tags,
        }

        local getDate = function(metadata)
          if metadata.create_at then
            return metadata.create_at
          end

          local date = os.date "%Y-%m-%d %H:%M"
          return date
        end

        note.metadata = {
          create_at = getDate(note.metadata),
          last_edited = os.date "%Y-%m-%d %H:%M",
        }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 2,
      },
      ui = {
        enable = false, -- set to false to disable all additional syntax features
      },
      follow_url_func = function(url)
        vim.fn.jobstart { "open", url }
      end,
      footer = {
        enabled = false,
        format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
        hl_group = "Comment",
        separator = string.rep("-", 80),
      },
    },

    config = function(_, opts)
      require("obsidian").setup(opts)

      RUtils.map.augroup("ManageNoteMappingMarkdown", {
        event = { "FileType" },
        pattern = { "markdown" },
        command = function(ctx)
          vim.defer_fn(function()
            require("r.keymaps.note").neorg_mappings_ft(ctx.buf)
          end, 500)
        end,
      })
    end,
  },
  -- KANBAN.NVIM (disabled)
  {
    "viniciusteixeiradias/kanban.nvim",
    enabled = false,
    event = "LazyFile",
    cmd = "Kanban",
    keys = {
      {
        "<Localleader>ac",
        function()
          local kanban = require "kanban"
          kanban.toggle()
        end,
        desc = "Note: toggle kanban [kanban.nvim]",
      },
      {
        "<Localleader>aC",
        function()
          local buffer = vim.api.nvim_get_current_buf()
          local filetype = vim.bo[buffer].filetype
          if filetype ~= "markdown" then
            ---@diagnostic disable-next-line: undefined-field
            RUtils.warn("Invalid filetype! (" .. filetype .. ")")
            return
          end

          local filename = vim.api.nvim_buf_get_name(buffer)
          vim.cmd("Kanban " .. filename)
        end,
        desc = "Note: open kanban under current file [kanban.nvim]",
      },
    },
    opts = function()
      local H = require "r.settings.highlights"
      return {
        file = {
          path = "~/notes/todo.md",
          name = "agenda.md",
          create_if_missing = true,
        },

        -- Highlight colors
        highlights = {
          column_header = { bold = true, fg = H.get("Function", "fg") },
          column_header_active = { bold = true, fg = H.get("Normal", "bg"), bg = H.get("Boolean", "fg") },
          task = { default = true },
          task_active = { fg = H.get("Normal", "bg"), bg = H.get("CurSearch", "bg"), bold = true },
          task_done = { strikethrough = true, fg = H.tint(H.get("Comment", "fg"), 0.5) },
          separator = { fg = H.tint(H.get("FloatBorder", "fg"), 0.15) },
        },
      }
    end,
  },
  -- SUPER-KANBAN (disabled)
  {
    "hasansujon786/super-kanban.nvim",
    enabled = false,
    cmd = "SuperKanban",
    keys = {
      {
        "<Leader>oc",
        "<CMD>SuperKanban open todo.md<CR>",
        desc = "Open: todo kanban [super-kanban.nvim]",
      },
    },
    opts = {
      markdown = {
        notes_dir = RUtils.config.path.wiki_path .. "/kanban-notes",
        list_heading = "h2",
        default_template = {
          "## Backlog\n",
          "## Todo\n",
          "## Work in progress\n",
          "## Completed\n",
          "**Complete**",
        },
      },

      mappings = {
        -- Close board window
        ["q"] = "close",
        -- Show keymap help window
        ["g?"] = "help",

        -- Create card at various positions
        ["gN"] = "create_card_before",
        ["gn"] = "create_card_after",
        ["gK"] = "create_card_top",
        ["gJ"] = "create_card_bottom",

        -- Delete or archive Toggle card checkbox
        ["gD"] = "delete_card",
        ["g<C-t>"] = "archive_card",
        ["<C-t>"] = "toggle_complete",

        -- Sort cards
        ["g."] = "sort_by_due_descending",
        ["g,"] = "sort_by_due_ascending",

        -- Search cards
        ["/"] = "search_card",
        -- Open date picker
        ["zi"] = "pick_date",
        -- Open card note
        ["<cr>"] = "open_note",

        -- List management
        ["zN"] = "create_list_at_begin",
        ["zn"] = "create_list_at_end",
        ["zD"] = "delete_list",
        ["zr"] = "rename_list",

        -- Navigation between cards/lists
        ["<C-k>"] = "jump_up",
        ["<C-j>"] = "jump_down",
        ["<C-h>"] = "jump_left",
        ["<C-l>"] = "jump_right",
        ["gg"] = "jump_top",
        ["G"] = "jump_bottom",
        ["z0"] = "jump_list_begin",
        ["z$"] = "jump_list_end",

        -- Move cards/lists
        ["<A-k>"] = "move_up",
        ["<A-j>"] = "move_down",
        ["<A-h>"] = "move_left",
        ["<A-l>"] = "move_right",
        ["zh"] = "move_list_left",
        ["zl"] = "move_list_right",
      },
    },
  },
  -- SNIPRUN
  {
    "michaelb/sniprun",
    build = "bash install.sh",
    cmd = "SnipRun",
    opts = {
      display = { "Terminal" },
      live_display = { "VirtualTextOk", "TerminalOk" },
      -- selected_interpreters = { "Python3_fifo" },
      -- repl_enable = { "Python3_fifo" },
    },
    keys = {
      {
        "<Leader>rC",
        "<Plug>SnipClose",
        ft = { "markdown", "neorg", "org" },
        desc = "Misc: close [sniprun]",
      },
    },
  },
}
