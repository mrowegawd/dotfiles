return {
  -- CALENDAR.NVIM
  {
    "wsdjeg/calendar.nvim",
    cmd = "Calendar",
  },
  -- ORGMODE
  {
    "nvim-orgmode/orgmode",
    -- event = "LazyFile",
    ft = "org",
    cmd = "Org",
    dependencies = {
      "akinsho/org-bullets.nvim",
      "danilshvalov/org-modern.nvim",
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
      -- { "<Leader>mv", "", desc = "view", ft = { "orgagenda", "org" } },
      -- { "<Leader>md", "", desc = "date/schedule", ft = { "orgagenda", "org" } },
      -- { "<Leader>mp", "", desc = "priority", ft = { "orgagenda", "org" } },
      { "<Leader>ma", "", desc = "add/priority/clock/set todo", ft = { "orgagenda", "org" } },
      { "<Leader>map", "", desc = "priority", ft = { "orgagenda", "org" } },
      { "<Leader>mac", "", desc = "clock", ft = { "orgagenda", "org" } },
      { "<Leader>mv", "", desc = "view", ft = { "orgagenda", "org" } },
      { "<Leader>me", "", desc = "edit date/schedule/codeblock", ft = { "orgagenda", "org" } },
      { "<Leader>mx", "", desc = "export/exec", ft = { "orgagenda", "org" } },

      { "<Leader>mr", "", desc = "remove/redo", ft = "org" },
      { "<Leader>mu", "", desc = "toggle", ft = "org" },
      { "<Leader>mb", "", desc = "buffer", ft = "org" },
      { "<Leader>mf", "", desc = "find/title/links", ft = "org" },

      { "<Leader>nd", "", desc = "date/navigate by date" },
      { "<Leader>nf", "", desc = "find/grep" },
      { "<Leader>nc", "", desc = "create note/capture" },

      {
        "<Leader>nft",
        RUtils.notes.filter_by_tags,
        desc = "Note: find notes by tags",
      },

      {
        "<Leader>nff",
        RUtils.notes.find_files_notes,
        desc = "Note: find notes files",
      },

      {
        "<Leader>nfg",
        RUtils.notes.live_grep,
        desc = "Note: live grep",
      },

      {
        "<c-v>",
        RUtils.notes.open_item_heading_vsplit,
        desc = "Note: open item heading in vsplit",
        ft = "orgagenda",
      },
      {
        "<c-s>",
        RUtils.notes.open_item_heading_split,
        desc = "Note: open item heading in split",
        ft = "orgagenda",
      },
      {
        "<c-t>",
        RUtils.notes.open_item_heading_tab,
        desc = "Note: open item heading in tab",
        ft = "orgagenda",
      },
      -- {
      --   "<Leader>ncc",
      --   function()
      --     require("orgmode").action "capture.prompt"
      --   end,
      --   desc = "Note: capture note [orgmode]",
      -- },
      {
        "<Leader>na",
        function()
          require("orgmode").action "agenda.prompt"
        end,
        desc = "Note: open agenda orgmode [orgmode]",
      },
      -- {
      --   "<Leader>nft",
      --   function()
      --     RUtils.markdown.find_local_titles()
      --     vim.cmd "normal! zRzz"
      --   end,
      --   desc = "Note: jump local title [orgmode]",
      --   ft = "org",
      -- },
      -- {
      --   "<Leader>nfT",
      --   function()
      --     RUtils.markdown.find_global_titles()
      --     vim.cmd "normal! zRzz"
      --   end,
      --   desc = "Note: jump global title [orgmode]",
      --   ft = "org",
      -- },
    },
    opts = function()
      -- local Highlight = require "r.settings.highlights"
      -- local done_hi = Highlight.get("Comment", "fg")
      -- local bg_hi = Highlight.darken(Highlight.get("Normal", "bg"), 0.4, Highlight.get("KeywordMatch", "fg"))
      -- local todo_fg = Highlight.get("KeywordMatch", "fg")
      local Menu = require "org-modern.menu"
      return {
        -- ui = {
        --   input = { use_vim_ui = true }, -- menggunakan vim.ui.input nvim, jadi snacks.nvim yang handle nya
        --   agenda = { preview_window = { border = RUtils.config.icons.border.line }, focusable = false },
        --   menu = {
        --     handler = function(data)
        --       local items = vim
        --         .iter(data.items)
        --         :map(function(i)
        --           return (i.key and not i.label:lower():match "quit") and i or nil
        --         end)
        --         :totable()
        --
        --       vim.ui.select(items, {
        --         prompt = string.format(RUtils.config.icons.misc.fire .. " %s ", data.prompt),
        --         kind = "pojokan",
        --         format_item = function(item)
        --           return string.format("%s → %s", item.key, item.label)
        --         end,
        --       }, function(choice)
        --         if not choice then
        --           return
        --         end
        --         if choice.action then
        --           choice.action()
        --         end
        --       end)
        --     end,
        --   },
        -- },
        ui = {
          input = { use_vim_ui = true }, -- menggunakan vim.ui.input nvim, jadi snacks.nvim yang handle nya
          menu = {
            handler = function(data)
              Menu:new({
                window = {
                  margin = { 1, 0, 1, 0 },
                  padding = { 0, 1, 0, 1 },
                  title_pos = "center",
                  border = "single",
                  zindex = 1000,
                },
                icons = {
                  separator = "➜",
                },
              }):open(data)
            end,
          },
        },
        org_agenda_files = {
          -- Mobilephone
          -- string.format("%s/orgmode/gym/*", RUtils.config.path.wiki_path),
          -- string.format("%s/orgmode/habit/*", RUtils.config.path.wiki_path),

          -- Notes
          string.format("%s/**/*", RUtils.config.path.wiki_path),

          -- Todo/Task
          -- string.format("%s/orgmode/gtd/*", RUtils.config.path.wiki_path),
          -- string.format("%s/orgmode/bookmarks/*", RUtils.config.path.wiki_path),
          -- string.format("%s/orgmode/day-to-remember/*", RUtils.config.path.wiki_path),
          -- string.format("%s/orgmode/project-todo/**/*", RUtils.config.path.wiki_path),
          -- string.format("%s/orgmode/nvim-plugin/qfbookmark/**/*", RUtils.config.path.wiki_path),
        },
        org_default_notes_file = string.format("%s/orgmode/gtd/refile.org", RUtils.config.path.wiki_path),
        org_todo_keywords = {
          "TODO(t)",
          "LEARNING(l)", -- task untuk jadwal learning
          "PROGRESS(p)", -- task yang sedang dikerjakan
          "WAITING(n)", -- task yang akan dialankan setelah 'progress' task selesai
          -- "CHECK(c)", -- task yang boleh dikerjakan saat free-time
          "HBD(b)",
          -- "STATUS(s)", -- task yang dikerjakan tapi bukan project, seperti belajar, baca buku, dsb
          "|",
          "DONE(d)",
        },
        org_todo_keyword_faces = {
          -- CHECK = ":foreground blue :background royalblue :weight bold :slant normal",
          NEXT = ":foreground brightmagenta :background darkmagenta :weight bold :slant normal",
          TODO = ":foreground red :weight bold :slant normal",
          HBD = ":foreground black :background pink :weight bold :slant normal",
          -- STATUS = ":foreground black :background darkcyan :weight bold :slant normal",
          DONE = ":foreground gray :weight bold :slant normal",

          PROGRESS = ":foreground white :background red :weight bold :slant italic",
          LEARNING = ":foreground black :background darkyellow :weight bold :slant normal",
        },
        org_agenda_skip_scheduled_if_done = true,
        org_hide_emphasis_markers = true,
        org_agenda_use_time_grid = false,
        org_priority_highest = "A",
        org_priority_default = "A",
        org_priority_lowest = "C",
        org_capture_templates = {
          t = {
            description = "Todo",
            template = "* TODO %? \n  SCHEDULED: %T\n\n\tDescribe:\n\n\tCode Error:\n\n\tExpected:\n",
            -- headline = "Another herading",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/refile.org",
          },
          -- d = "dotfiles",
          d = {
            description = "Dotfiles",
            template = "* TODO %? \t\t\t\t\t:config:\n  SCHEDULED: %T",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/refile.org",
          },
          i = {
            description = "Inbox",
            template = "* TODO %? \n  SCHEDULED: %t\n\n\tDescribe:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/inbox.org",
          },
          l = {
            description = "Link",
            template = "* TODO %?\n  SCHEDULED: %t\n  %a\n\n\tDescribe:\n",
            target = RUtils.config.path.wiki_path .. "/orgmode/gtd/inbox.org",
          },
          b = {
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
        org_agenda_custom_commands = {
          -- "c" is the shortcut that will be used in the prompt
          c = {
            description = "Task for edit dotfiles (nvim, emacs, and stuff)", -- Description shown in the prompt for the shortcut
            types = {
              {
                type = "tags_todo", -- Type can be agenda | tags | tags_todo
                -- match = "config", -- Type can be agenda | tags | tags_todo
                match = '+PRIORITY="A"', --Same as providing a "Match:" for tags view <leader>oa + m, See: https://orgmode.org/manual/Matching-tags-and-properties.html
                org_agenda_overriding_header = "⭐ Dotfiles: High priority todo",
                org_agenda_todo_ignore_deadlines = "far", -- Ignore all deadlines that are too far in future (over org_deadline_warning_days). Possible values: all | near | far | past | future
                org_agenda_remove_tags = false,
                -- org_agenda_sorting_strategy = "",
              },
              {
                type = "tags",
                match = "config",
                org_agenda_overriding_header = "🔧 Dotfiles: Some broken configs..",
                org_agenda_remove_tags = false,
                -- org_agenda_todo_ignore_scheduled = "near",
              },
              -- {
              --   type = "agenda",
              --   org_agenda_overriding_header = "Whole week overview",
              --   -- org_agenda_tag_filter_preset = { "personal" },
              --   org_agenda_span = "week", -- 'week' is default, so it's not necessary here, just an example
              --   org_agenda_start_on_weekday = 1, -- Start on Monday
              --   org_agenda_remove_tags = true, -- Do not show tags only for this view
              -- },
            },
          },
          L = {
            description = "LEARNING",
            types = {
              -- {
              --   type = "tags_todo",
              --   org_agenda_overriding_header = "LEARNING todos",
              --   org_agenda_category_filter_preset = "todos", -- Show only headlines from `todos` category. Same value providad as when pressing `/` in the Agenda view
              --   org_agenda_sorting_strategy = { "todo-state-up", "priority-down" }, -- See all options available on org_agenda_sorting_strategy
              -- },
              {
                type = "agenda",
                org_agenda_overriding_header = "Learning: Whole week overview",
                org_agenda_tag_filter_preset = "learning",
                -- org_agenda_span = "week", -- 'week' is default, so it's not necessary here, just an example
                org_agenda_start_on_weekday = 1, -- Start on Monday
                -- org_agenda_remove_tags = true, -- Do not show tags only for this view
              },
              -- {
              --   type = "agenda",
              --   org_agenda_overriding_header = "Personal projects agenda",
              --   org_agenda_files = { "~/my-projects/**/*" }, -- Can define files outside of the default org_agenda_files
              -- },
              -- {
              --   type = "tags",
              --   org_agenda_overriding_header = "Personal projects notes",
              --   org_agenda_files = { "~/my-projects/**/*" },
              --   org_agenda_tag_filter_preset = "NOTES-REFACTOR", -- Show only headlines with NOTES tag that does not have a REFACTOR tag. Same value providad as when pressing `/` in the Agenda view
              -- },
            },
          },
          w = {
            description = "Work",
            types = {
              {
                type = "tags_todo",
                org_agenda_overriding_header = "My personal todos",
                org_agenda_category_filter_preset = "todos", -- Show only headlines from `todos` category. Same value providad as when pressing `/` in the Agenda view
                org_agenda_sorting_strategy = { "todo-state-up", "priority-down" }, -- See all options available on org_agenda_sorting_strategy
              },
              {
                type = "agenda",
                org_agenda_overriding_header = "Personal projects agenda",
                org_agenda_files = { "~/my-projects/**/*" }, -- Can define files outside of the default org_agenda_files
              },
              {
                type = "tags",
                org_agenda_overriding_header = "Personal projects notes",
                org_agenda_files = { "~/my-projects/**/*" },
                org_agenda_tag_filter_preset = "NOTES-REFACTOR", -- Show only headlines with NOTES tag that does not have a REFACTOR tag. Same value providad as when pressing `/` in the Agenda view
              },
            },
          },
        },
        mappings = {
          disable_all = false,
          prefix = "<Leader>c",
          global = {
            org_capture = "<Leader>ncc",
            org_agenda = "<Leader>na",
          },
          agenda = {
            -- Views
            org_agenda_day_view = "<Leader>mvd",
            org_agenda_week_view = "<Leader>mvw",
            org_agenda_month_view = "<Leader>mvm",
            org_agenda_year_view = "<Leader>mvy",

            -- Navigation
            org_agenda_later = "f",
            org_agenda_earlier = "b",
            org_agenda_goto_today = "~",
            org_agenda_goto = { "<CR>", "o" },
            org_agenda_goto_date = "<Leader>ndd",
            org_agenda_open_at_point = "<Leader>mo",

            org_agenda_switch_to = "<TAB>",

            -- Todo Effort
            org_agenda_todo = "<Leader>mat",
            org_agenda_set_effort = "<Leader>mae",

            -- Clock
            org_agenda_clock_in = "<Leader>maci",
            org_agenda_clock_out = "<Leader>maco",
            org_agenda_clock_goto = "<Leader>macg",
            org_agenda_clock_cancel = "<Leader>macc",

            org_agenda_clockreport_mode = "<Leader>macr", -- buat report clock

            -- Priority
            org_agenda_priority = "<Leader>mapP",
            org_agenda_priority_up = "<c-k>",
            org_agenda_priority_down = "<c-j>",

            org_agenda_archive = "<Leader>mA",

            --- Tags, Refile / Notes
            org_agenda_set_tags = "<Leader>mag",
            org_agenda_refile = "<Leader>mR",
            org_agenda_add_note = "<Leader>man",

            org_agenda_toggle_archive_tag = "<Leader>maA",

            org_agenda_deadline = "<Leader>med",
            org_agenda_schedule = "<Leader>mes",

            org_agenda_preview = "K",

            -- Misc
            org_agenda_filter = "<Leader>sf",
            org_agenda_redo = "R",
            org_agenda_quit = { "<Leader>bk" },
            org_agenda_show_help = "?",
          },
          capture = {
            org_capture_finalize = { "<C-c>", "<C-s>" },
            org_capture_refile = "<Leader>mR",
            org_capture_kill = { "q", "<C-q>", "<Leader>bk" },
            org_capture_show_help = "?",
          },
          note = {
            org_note_finalize = { "<C-c>", "<C-s>" },
            org_note_kill = { "q", "<C-q>" },
          },
          org = {
            -- Timestamp
            org_timestamp_up_day = "<Up>",
            org_timestamp_down_day = "<Down>",
            org_timestamp_up = "<C-PageUp>",
            org_timestamp_down = "<C-PageDown>",

            -- Todo / Heading
            org_todo = "<Leader>mat",
            org_todo_prev = "<Leader>maT",
            org_toggle_heading = "<Leader>muh",

            -- Navigation
            org_next_visible_heading = "<a-n>",
            org_previous_visible_heading = "<a-p>",
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
            org_clock_in = "<Leader>maci",
            org_clock_out = "<Leader>maco",
            org_clock_cancel = "<Leader>macc",
            org_clock_goto = "<Leader>macg",

            -- Priority
            org_priority = "<Leader>mapP",
            org_priority_up = "<Leader>mapn",
            org_priority_down = "<Leader>mapp",

            -- Promote / Demote
            org_do_promote = "<c-h>",
            org_do_demote = "<c-l>",
            org_promote_subtree = "<S-Left>",
            org_demote_subtree = "<S-Right>",

            -- Move subtree
            org_move_subtree_up = "<c-k>",
            org_move_subtree_down = "<c-j>",

            -- Tags / Refile / Notes
            org_set_tags_command = "<Leader>mag",
            org_refile = "<Leader>mR",

            -- Links
            org_insert_link = "<Leader>il",
            org_store_link = "<Leader>iL",

            -- Timestamp Insert
            org_time_stamp = "<Leader>it",
            org_time_stamp_inactive = "<Leader>id",
            org_toggle_timestamp_type = "<Leader>mut",

            -- Insert Deadline or Schedule
            org_deadline = "<Leader>med",
            org_schedule = "<Leader>mes",
            org_set_effort = "<Leader>mae",
            org_add_note = "<Leader>man",

            -- Export / Babel
            org_export = "<Leader>mxe",
            org_babel_tangle = "bt",

            -- Gunanya buat edit contents dalam block code di beda buffer,
            -- cara: masuk ke block code (begin_src), lalu combine mapping ini,
            -- jika selesi :wq
            org_edit_special = "<Leader>meE",

            -- set current node to archived
            org_archive_subtree = "<Leader>mA",
            org_toggle_archive_tag = "<Leader>mut",

            org_toggle_checkbox = "<C-c>",
            org_open_at_point = { "<Leader>ld", "<Leader>mo" },

            org_meta_return = "<s-CR>", -- Add heading, item or row (context-dependent)
            org_return = "<a-w>",

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

      local set_cr_mapping = function()
        vim.keymap.set("i", "<s-CR>", '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
          silent = true,
          buffer = true,
        })
      end

      RUtils.map.augroup("ManageNoteMappingOrg", {
        event = { "FileType" },
        pattern = { "org" },
        command = function()
          require("r.keymaps.note").neorg_mappings_ft(vim.api.nvim_get_current_buf())
          set_cr_mapping()
        end,
      }, {
        event = { "BufWritePost" },
        pattern = { "*.org" },
        command = function()
          local bufnr = vim.fn.bufnr "orgagenda" or -1
          if bufnr > -1 then
            require("orgmode").agenda:redo()
          end
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
  -- ORG-ROAM
  {
    "chipsenkbeil/org-roam.nvim",
    event = "LazyFile",
    opts = {
      directory = string.format("%s/orgmode/org_roam_files", RUtils.config.path.wiki_path),
      -- org_files = {
      --   "~/another_org_dir",
      --   "~/some/folder/*.org",
      --   "~/a/single/org_file.org",
      -- },

      bindings = {
        ---Adjusts the prefix for every keybinding. Can be used in keybindings with <prefix>.
        prefix = "<Leader>m",
        add_alias = "<prefix>aa", ---Adds an alias to the node under cursor.
        add_origin = "<prefix>ao", ---Adds an origin to the node under cursor.

        capture = "<Leader>ncC", ---Opens org-roam capture window.

        complete_at_point = "<prefix>.", ---Completes the node under cursor.

        find_node = "<Leader>nfr", ---Finds node and moves to it.

        goto_next_node = "<S-Right>",
        goto_prev_node = "<S-Left>",

        insert_node = "<Leader>ii", ---Inserts node at cursor position.
        insert_node_immediate = "<Leader>iI", ---Inserts node at cursor position without opening capture buffer.

        quickfix_backlinks = "<prefix>q", ---Opens the quickfix menu for backlinks to the current node under cursor.

        remove_alias = "<prefix>ra", ---Removes an alias from the node under cursor.
        remove_origin = "<prefix>ro", ---Removes the origin from the node under cursor.

        toggle_roam_buffer = "<Leader>mbb", ---Toggles the org-roam node-view buffer for the node under cursor.
        toggle_roam_buffer_fixed = "<Leader>mbB", ---Toggles a fixed org-roam node-view buffer for a selected node.
      },

      extensions = {
        ---Settings tied to the dailies extension.
        ---@class org-roam.config.extensions.Dailies
        dailies = {
          ---Path to the directory within the org-roam directory where
          ---daily entries will be stored.
          ---@type string
          directory = "daily",

          ---Bindings associated with org-roam dailies functionality.
          ---@class org-roam.config.extensions.dailies.Bindings
          bindings = {
            capture_date = "<Leader>ncD",
            capture_today = "<Leader>nct",
            capture_tomorrow = "<Leader>ncw",
            capture_yesterday = "<Leader>ncy",

            ---Navigate to dailies note directory.
            find_directory = "<Leader>nE",

            ---Navigate to specific date's note.
            goto_date = "<Leader>ndD",

            ---Navigate to the next/prev by date's note
            goto_next_date = "<Leader>ndn",
            goto_prev_date = "<Leader>ndp",

            ---Navigate to today/tomorrow/yesterday
            goto_today = "<Leader>ndt",
            goto_tomorrow = "<Leader>ndw",
            goto_yesterday = "<Leader>ndy",
          },

          templates = {
            d = {
              description = "Daily journal note, stored per year and date",
              template = "%?",
              target = "%<%Y>/%<%Y-%m-%d>.org",
            },
          },

          ---Settings tied to org-roam dailies user interface.
          ---@class org-roam.config.extensions.dailies.UserInterface
          ui = {
            ---Settings tied to org-roam dailies calendar user interface.
            ---@class org-roam.config.extensions.dailies.ui.Calendar
            calendar = {
              ---Highlight group to apply to a date that already has a note.
              ---@type string
              hl_date_exists = "WarningMsg",
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("org-roam").setup(opts)
    end,
  },
  -- ORG-SUPER-AGENDA
  {
    "hamidi-dev/org-super-agenda.nvim",
    event = "LazyFile",
    keys = {
      {
        "<Leader>nA",
        function()
          -- fix error "buffer name already exists"
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) then
              local bufname = vim.fn.bufname(buf)
              if bufname == "Org Super Agenda" then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end
          end

          vim.cmd "OrgSuperAgenda"
        end,
        desc = "Note: open agenda orgmode [org-super-agenda]",
      },
    },
    opts = {
      org_files = {
        string.format("%s/orgmode/gtd/*", RUtils.config.path.wiki_path),
        string.format("%s/orgmode/bookmarks/*", RUtils.config.path.wiki_path),
        string.format("%s/orgmode/day-to-remember/*", RUtils.config.path.wiki_path),
        string.format("%s/orgmode/project-todo/**/*", RUtils.config.path.wiki_path),
        string.format("%s/orgmode/nvim-plugin/qfbookmark/**/*", RUtils.config.path.wiki_path),
      },
      org_directories = {
        string.format("%s/orgmode", RUtils.config.path.wiki_path),
      },
      exclude_files = {},
      exclude_directories = {},

      -- TODO states + their quick filter keymaps and highlighting
      -- Optional: add `shortcut` field to override the default key (first letter)
      todo_states = {
        {
          name = "TODO",
          keymap = "ot",
          color = "#FF5555",
          strike_through = false,
          fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        },
        {
          name = "PROGRESS",
          keymap = "op",
          color = "#FFAA00",
          strike_through = false,
          fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        },
        {
          name = "WAITING",
          keymap = "ow",
          color = "#BD93F9",
          strike_through = false,
          fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        },
        {
          name = "LEARNING",
          keymap = "ol",
          color = "#278dc8",
          strike_through = false,
          fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        },
        {
          name = "DONE",
          keymap = "od",
          color = "#50FA7B",
          strike_through = true,
          fields = { "filename", "todo", "headline", "priority", "date", "tags" },
        },
      },

      -- Agenda keymaps (inline comments explain each)
      keymaps = {
        filter_reset = "<Leader>sR", -- reset all filters
        toggle_other = "<Leader>mvo", -- toggle catch-all "Other" section
        filter = "of", -- live filter (exact text)
        filter_fuzzy = "<Leader>sf", -- live filter (fuzzy)
        filter_query = "<Leader>sF", -- advanced query input
        undo = "u", -- undo last change
        reschedule = "<Leader>mes", -- set/change SCHEDULED
        set_deadline = "<Leader>med", -- set/change DEADLINE
        cycle_todo = "t", -- cycle TODO state
        set_state = "<Leader>mat", -- set state directly (st, sd, etc.) or show menu
        reload = "R", -- refresh agenda
        refile = "<Leader>mR", -- refile via Telescope/org-telescope
        hide_item = "x", -- hide current item
        preview = "P", -- preview headline content
        reset_hidden = "X", -- clear hidden list
        toggle_duplicates = "D", -- duplicate items may appear in multiple groups
        cycle_view = "<Leader>mvv", -- switch view (classic/compact)
      },

      -- Window/appearance
      window = {
        width = 0.8,
        height = 0.7,
        border = "rounded",
        title = "Org Super Agenda",
        title_pos = "center",
        margin_left = 0,
        margin_right = 0,
        fullscreen_border = "none", -- border style when using fullscreen
      },

      -- Group definitions (order matters; first match wins unless allow_duplicates=true)
      groups = {
        {
          name = "📅 Today",
          matcher = function(i)
            return i.scheduled and i.scheduled:is_today() and not i:has_tag "personal" and i.todo_state ~= "DONE"
          end,
          sort = { by = "priority", order = "desc" },
        },
        {
          name = "☠️ Deadlines",
          matcher = function(i)
            return i.deadline and i.todo_state ~= "DONE" and not i:has_tag "personal"
          end,
          sort = { by = "deadline", order = "asc" },
        },
        {
          name = "⭐ Important",
          matcher = function(i)
            return i.priority == "A" and (i.deadline or i.scheduled) and i.todo_state ~= "DONE"
          end,
          sort = { by = "date_nearest", order = "asc" },
        },
        {
          name = "🕒 Tomorrow",
          matcher = function(i)
            return i.scheduled and i.scheduled:days_from_today() == 1 and not i:has_tag "personal"
          end,
        },
        {
          name = "⏳ Overdue",
          matcher = function(i)
            return i.todo_state ~= "DONE"
              and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
              and not i:has_tag "personal"
          end,
          sort = { by = "date_nearest", order = "asc" },
        },
        {
          name = "🏠 Habit & Workout Today",
          matcher = function(i)
            return i.scheduled and i.scheduled:is_today() and i:has_tag "personal" and i.todo_state ~= "DONE"
          end,
          sort = { by = "priority", order = "desc" },
        },
        {
          name = "⏳ Overdue Habit & Workout",
          matcher = function(i)
            return i.todo_state ~= "DONE"
              and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
              and i:has_tag "personal"
          end,
          sort = { by = "date_nearest", order = "asc" },
        },
        {
          name = "💼 Work",
          matcher = function(i)
            return i:has_tag "work"
          end,
        },
        {
          name = "🔧 Fix",
          matcher = function(i)
            return i:has_tag "error"
          end,
        },
        {
          name = "📆 Upcoming",
          matcher = function(i)
            local days = require("org-super-agenda.config").get().upcoming_days or 10
            local d1 = i.deadline and i.deadline:days_from_today()
            local d2 = i.scheduled and i.scheduled:days_from_today()
            return (d1 and d1 >= 0 and d1 <= days)
              or (d2 and d2 >= 0 and d2 <= days) and not i:has_tag "personal" and i.todo_state ~= "DONE"
          end,
          sort = { by = "date_nearest", order = "asc" },
        },
      },

      -- Defaults & behavior
      upcoming_days = 10,
      hide_empty_groups = true, -- drop blank sections
      keep_order = false, -- keep original org order (rarely useful)
      allow_duplicates = false, -- if true, an item can live in multiple groups
      group_format = "* %s", -- group header format
      other_group_name = "Other",
      show_other_group = false, -- show catch-all section
      show_tags = true, -- draw tags on the right
      show_filename = true, -- include [filename]
      heading_max_length = 70,
      persist_hidden = false, -- keep hidden items across reopen
      view_mode = "classic", -- 'classic' | 'compact'

      classic = {
        heading_order = { "filename", "todo", "priority", "headline" },
        short_date_labels = false,
        inline_dates = true,
      },
      compact = { filename_min_width = 10, label_min_width = 12 },

      -- Global fallback sort for groups that omit `sort`
      group_sort = { by = "date_nearest", order = "asc" },

      -- Popup mode: run in a persistent tmux session for instant access
      popup_mode = {
        enabled = false,
        hide_command = nil, -- e.g., "tmux detach-client"
      },

      debug = false,
    },
  },
  -- OBSIDIAN.NVIM
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    cmd = "Obsidian",
    ft = "markdown",
    keys = {
      -- {
      --   "<Leader>nfg",
      --   function()
      --     local fzf_lua = RUtils.cmd.reqcall "fzf-lua"
      --     return fzf_lua.live_grep_glob {
      --       prompt = RUtils.fzflua.padding_prompt(),
      --       cwd = RUtils.config.path.wiki_path,
      --       rg_opts = [[--column --hidden --line-number --no-heading --ignore-case --smart-case --color=always --colors 'match:fg:178' --max-columns=4096 -g "*.md" ]],
      --       -- rg_opts = [[--column --hidden --line-number --no-heading --ignore-case --smart-case --color=always --colors 'match:fg:178' --max-columns=4096 -g "*.org" ]],
      --       winopts = {
      --         title = RUtils.fzflua.format_title(
      --           "Obsidian > Grep",
      --           RUtils.strip_whitespaces(RUtils.config.icons.misc.telescope3)
      --         ),
      --       },
      --     }
      --   end,
      --   desc = "Note: grep [obsidian]",
      -- },
      {
        "<Leader>nfg",
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
      -- {
      --   "<Leader>nfe",
      --   function()
      --     local fzf_lua = RUtils.cmd.reqcall "fzf-lua"
      --     return fzf_lua.files {
      --       prompt = RUtils.fzflua.padding_prompt(),
      --       cwd = RUtils.config.path.wiki_path,
      --       file_ignore_patterns = { "%.norg$", "%.json$", "%.org$", "%.png$" },
      --       -- file_ignore_patterns = { "%.norg$", "%.json$", "%.md$", "%.png$" },
      --       rg_opts = [[--column --type=md --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 --colors 'match:fg:178' ]],
      --
      --       winopts = {
      --         -- fullscreen = true,
      --         title = RUtils.fzflua.format_title(
      --           "Obsidian > Note files",
      --           RUtils.strip_whitespaces(RUtils.config.icons.misc.bookmark)
      --         ),
      --       },
      --     }
      --   end,
      --   desc = "Note: find note files [obsidian]",
      -- },
      -- {
      --   "<Leader>nN",
      --   ":ObsidianNew ",
      --   desc = "Note: create new note [obsidian]",
      -- },
      -- {
      --   "<Leader>nn",
      --   ":ObsidianToday<CR>",
      --   desc = "Note: add note today [obsidian]",
      -- },
      {
        "<Leader>mo",
        function()
          RUtils.cmd.open_with "go to file"
        end,
        desc = "Note: follow link [obsidian]",
        ft = "markdown",
      },
      -- {
      --   "<Leader>nd",
      --   "<CMD>ObsidianDailies<CR>",
      --   desc = "Note: open and select daily note [obsidian]",
      -- },
      -- {
      --   "<Leader>nft",
      --   function()
      --     RUtils.markdown.find_local_titles()
      --     vim.cmd "normal! zRzz"
      --   end,
      --   desc = "Note: jump local title [obsidian]",
      --   ft = "markdown",
      -- },
      {
        "<Leader>nfT",
        function()
          RUtils.markdown.find_global_titles()
          vim.cmd "normal! zRzz"
        end,
        desc = "Note: jump global title [obsidian]",
        ft = "markdown",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
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
      attachments = {
        img_text_func = function(path)
          local name = vim.fs.basename(tostring(path))
          local encoded_name = require("obsidian.util").urlencode(name)
          return string.format("![%s](%s)", name, encoded_name)
        end,
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
