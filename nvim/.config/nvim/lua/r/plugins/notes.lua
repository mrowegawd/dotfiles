local fmt, cmd, api = string.format, vim.cmd, vim.api

local function format_title(str, icon, icon_hl)
  return {
    { " " },
    { (icon and icon .. " " or ""), icon_hl or "DevIconDefault" },
    { str, "Bold" },
    { " " },
  }
end

return {
  -- NEORG
  {
    "nvim-neorg/neorg",
    cmd = "Neorg",
    ft = "norg",
    build = ":Neorg sync-parsers", -- This is the important bit!
    init = function()
      as.augroup("ManageNotesNeorg", {
        event = { "FileType" },
        pattern = { "norg" },
        command = function()
          require("r.mappings.utils.notes").neorg_mappings_ft(api.nvim_get_current_buf())
        end,
      })
    end,
    keys = {
      {
        "<Localleader>fo",
        function()
          if vim.bo.filetype == "norg" then
            return cmd [[Neorg return]]
          else
            return cmd [[Neorg workspace wiki]]
          end
        end,
        desc = "Note(neorg): open neorg workspace",
      },

      {
        "<Localleader>ff",
        function()
          cmd [[Lazy load neorg]]

          if as.use_search_telescope then
            -- TELESCOPE-MENUFACTURE
            return require("telescope").extensions.menufacture.find_files {
              cwd = as.wiki_path,
              prompt_title = "Find Neorg Wiki Files",
              theme = "cursor",
            }
          end

          return require("fzf-lua").files {
            prompt = "  ",
            cwd = as.wiki_path,
            rg_glob = true,
            file_ignore_patterns = { "%.md$", "%.json$", "%.org$" },
            winopts = {
              fullscreen = true,
              title = format_title("[Neorg] Files", " "),
            },
          }
        end,
        desc = "Note(fzflua): find neorg files",
      },
      {
        "<Localleader>fg",
        function()
          cmd [[Lazy load neorg]]

          if as.use_search_telescope then
            -- TELESCOPE-MENUFACTURE
            return require("telescope").extensions.menufacture.live_grep {
              cwd = as.wiki_path,
              prompt_title = "Live Grep Neorg Wiki",
              vimgrep_arguments = {
                "rg",
                "--follow",
                "--hidden",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--trim", -- remove indentation
                "-g",
                "*.norg",
                "-g",
                "*.org",
                "-g",
                "!config/",
                "-g",
                "!.obsidian/",
              },
            }
          end
          return require("fzf-lua").live_grep_glob {
            prompt = "  ",
            cwd = as.wiki_path,
            winopts = {
              fullscreen = false,

              title = format_title("[Neorg] Grep", " "),
              -- preview = {
              --   vertical = "up:45%",
              --   horizontal = "right:60%",
              --   layout = "vertical",
              -- },
            },
            -- cmd = "rg --follow hidden no-heading with-filename line-number column smart-case trim -- remove indentation -g *.norg -g *.org -g !config/ -g !.obsidian/",
          }
        end,
        desc = "Note(fzflua): live grep neorg files",
      },
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-neorg/neorg-telescope",
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "laher/neorg-exec",
    },
    opts = {
      -- configure_parsers = true,
      load = {
        ["core.defaults"] = {},
        -- ["core.concealer"] = {
        --   -- config = {
        --   --   icon_preset = "diamond",
        --   --   fold = true,
        --   --   dim_code_blocks = {
        --   --     padding = { left = 2, right = 2 },
        --   --     width = "content",
        --   --   },
        --   -- },
        -- },
        ["core.concealer"] = {
          config = {
            dim_code_blocks = { width = "content", content_only = true, adaptive = true, conceal = false },
          },
        },
        ["core.ui"] = {},
        ["core.summary"] = {},
        ["external.exec"] = {
          config = {
            -- default_metadata = {
            --   enabled = false,
            --   env = {
            --     NEORG: "rocks"
            --   },
            lang_cmds = {
              rust = {
                cmd = "rustc ${0} -o ./a.out && ./a.out && rm ./a.out",
                type = "compiled",
                main_wrap = [[
                ${1}
                ]],
              },
              go = {
                cmd = "goimports -w ${0} && NO_COLOR=1 go run ${0}",
                type = "compiled",
                main_wrap = [[
                ${1} ]],
              },
            },
          },
        },
        ["core.highlights"] = {
          config = {
            -- highlights = {
            --     headings = {
            --         ["1"] = {
            --             title = "+NeorgCodeBlock",
            --         },
            --     },
            -- },
            dim = {
              tags = {
                ranged_verbatim = {
                  code_block = {
                    reference = "CodeBlock1",
                    -- percentage = 20,
                    affect = "background",
                  },
                },
              },

              markup = { -- hi code line
                verbatim = {
                  reference = "ErrorMsg",
                  percentage = 50,
                },

                -- inline_comment = {
                --     reference = "Normal",
                --     percentage = 90,
                -- },
              },
            },
          },
          -- },
        },
        ["core.export"] = {},
        ["core.export.markdown"] = { config = { extensions = "all" } },
        ["core.dirman"] = {
          config = {
            workspaces = {
              gtd = fmt("%s/gtd", as.wiki_path),
              wiki = as.wiki_path,
            },
          },
        },
        ["core.esupports.metagen"] = {
          config = {
            type = "auto",
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        -- ["core.integrations.telescope"] = {},
        ["core.keybinds"] = {
          config = {
            default_keybinds = false,
            hook = function(keybinds)
              -- EXAMPLE ================================================
              -- Unmaps any Neorg key from the `norg` mode
              -- keybinds.unmap("norg", "n", "gtd")

              -- Binds the `gtd` key in `norg` mode to execute `:echo 'Hello'`
              -- keybinds.map("norg", "n", "gtd", "<cmd>echo 'Hello!'<CR>")

              -- Want to move one keybind into the other? `remap_key` moves the data of the
              -- first keybind to the second keybind, then unbinds the first keybind.
              -- keybinds.remap_key("norg", "n", "<C-Space>", "<Leader>t")

              -- Remap unbinds the current key then rebinds it to have a different action
              -- associated with it.
              -- The following is the equivalent of the `unmap` and `map` calls you saw above:
              --
              -- Sometimes you may simply want to rebind the Neorg action something is bound to
              -- versus remapping the entire keybind. This remap is essentially the same as if you
              -- did `keybinds.remap("norg", "n", "<C-Space>, "<cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_done<CR>")
              -- keybinds.remap_event(
              --     "norg",
              --     "n",
              --     "<C-Space>",
              --     "core.norg.qol.todo_items.todo.task_done"
              -- )
              -- ========================================================

              keybinds.remap_event("norg", "n", "<TAB>", "core.esupports.hop.hop-link")
              keybinds.remap_event("norg", "n", "<M-CR>", "core.esupports.hop.hop-link", "vsplit")

              -- go next heading fold
              keybinds.remap_event("norg", "n", "<a-n>", "core.integrations.treesitter.next.heading")
              -- go prev heading fold
              keybinds.remap_event("norg", "n", "<a-p>", "core.integrations.treesitter.previous.heading")

              keybinds.remap_event("norg", "n", "<C-c>", "core.qol.todo_items.todo.task_cycle")

              -- keybinds.remap_event("norg", "n", "<right>", "core.promo.promote")
              -- keybinds.remap_event("norg", "n", "<left>", "core.promo.demote")
              keybinds.map("norg", "n", "<right>", "<cmd>Neorg keybind norg core.promo.promote nested<CR>", {})
              keybinds.map("norg", "n", "rl", "<cmd>Neorg exec cursor<CR>", {})
              keybinds.map("norg", "n", "<left>", "<cmd>Neorg keybind norg core.promo.demote nested<CR>", {})
              --
            end,
          },
        },
      },
    },
  },
  -- ORGMODE
  {
    "nvim-orgmode/orgmode",
    ft = "org",
    keys = {
      {
        "<Localleader>fO",
        function()
          return require("r.utils").EditOrgTodo()
        end,
        desc = "Note(orgmode): directly edit todos org",
      },
      -- "<localleader>fa",
    },

    dependencies = {
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
    config = function()
      local orgmode = require "orgmode"

      orgmode.setup_ts_grammar()

      orgmode.setup {
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
                prompt = fmt(" %s ", data.prompt),
                kind = "orgmode",
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
        win_split_mode = "float",
        org_agenda_files = {
          fmt("%s/orgmode/gtd/*", as.wiki_path),
          fmt("%s/orgmode/journal/homeclean/*", as.wiki_path),
          fmt("%s/orgmode/journal/HBD/*", as.wiki_path),
        },
        org_default_notes_file = fmt("%s/orgmode/gtd/refile.org", as.wiki_path),
        org_todo_keywords = {
          "TODO(t)",
          "NEXT(n)",
          "CHECK(c)",
          "UNTASK(o)",
          "HBD(b)",
          "HOLD(h)",
          "INPROGRESS(p)",
          "|",
          "DONE(d)",
        },
        org_todo_keyword_faces = {
          CHECK = ":foreground royalblue :weight bold :slant italic",
          TODO = ":foreground pink :weight bold :slant italic",
          INPROGRESS = ":foreground red :weight bold :slant italic",
          UNTASK = ":foreground deeppink :weight bold",
          HBD = ":foreground magenta :weight bold :slant italic",
          HOLD = ":foreground gray :weight bold :slant italic",
          DONE = ":foreground green :weight bold :slant italic",
          NEXT = ":foreground orange :weight bold",
        },
        -- win_split_mode = "20split",
        org_agenda_skip_scheduled_if_done = true,
        org_agenda_templates = {
          t = {
            description = "Todo",
            -- template = "\n* TODO %? \n  SCHEDULED: %t",
            template = "* TODO %? \n  SCHEDULED: %t",
            target = as.wiki_path .. "/orgmode/gtd/refile.org",
          },

          i = {
            description = "Inbox (someday)",
            template = "* %?",
            target = as.wiki_path .. "/orgmode/gtd/inbox.org",
          },
          l = {
            description = "Link",
            -- template = "\n* CHECK %?\n  SCHEDULED: %t\n  %a\n\n",
            template = "* CHECK %?\n  SCHEDULED: %t\n  %a\n\n",
            target = as.wiki_path .. "/orgmode/gtd/inbox.org",
          },
          c = {
            description = "Check",
            -- template = "\n* CHECK %? \n  SCHEDULED: %t",
            template = "* CHECK %? \n  SCHEDULED: %t",
            target = as.wiki_path .. "/orgmode/gtd/inbox.org",
          },
          -- j = {
          --     description = "Journal",
          --     template = "\n** %<%Y-%m-%d> %<%A>\n*** %U\n\n%?",
          --     target = as.wiki_path.. "/orgmode/gtd/journal.org",
          -- },
          -- k = {
          --     description = "Markdown",
          --     template = "\n* TODO %? \n  SCHEDULED: %t",
          --     target = as.wiki_path .. "/orgmode/gtd/base.md",
          --     filetype = "markdown",
          -- },
        },

        -- win_split_mode = function(name)
        --     local bufnr = vim.api.nvim_create_buf(false, true)
        --     --- Setting buffer name is required
        --     vim.api.nvim_buf_set_name(bufnr, name)
        --     local fill = 0.8
        --     local width = math.floor((vim.o.columns * fill))
        --     local height = math.floor((vim.o.lines * fill))
        --     local row = math.floor((((vim.o.lines - height) / 2) - 1))
        --     local col = math.floor(((vim.o.columns - width) / 2))
        --     vim.api.nvim_open_win(bufnr, true, {
        --         relative = "editor",
        --         width = width,
        --         height = height,
        --         row = row,
        --         col = col,
        --         style = "minimal",
        --         border = "rounded",
        --     })
        -- end,

        mappings = {
          disable_all = false,
          prefix = "<leader>",
          global = {
            org_capture = "<Localleader>fc",
            org_agenda = "<localleader>fa",
          },
          agenda = {
            org_agenda_later = "f",
            org_agenda_earlier = "b",
            org_agenda_goto_today = "~",
            org_agenda_day_view = "vd",
            org_agenda_week_view = "vw",
            org_agenda_month_view = "vm",
            org_agenda_year_view = "vy",
            org_agenda_quit = { "q", "<esc>" },
            org_agenda_goto = { "<TAB>", "<cr>" },
            org_agenda_show_help = "?",
            org_agenda_redo = "r",
            org_agenda_goto_date = "cid",
            org_agenda_todo = "cit",
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
            org_capture_kill = "q",
            org_capture_show_help = "?",
          },
          org = {
            org_refile = "<c-i>",
            org_timestamp_up = "<c-a>",
            org_timestamp_down = "<c-x>",
            org_change_date = "cid",
            org_todo = "cit",
            org_toggle_checkbox = "<C-c>",
            org_open_at_point = "<TAB>",
            org_cycle = "za",
            org_meta_return = "<F12>", -- Add heading, item or row
            org_return = "<F11>",
            org_global_cycle = "<c-space>",
            org_archive_subtree = "<prefix>$",
            org_set_tags_command = "<Leader>t",
            org_toggle_archive_tag = "<Leader>T",
            org_next_visible_heading = "<down>",
            org_previous_visible_heading = "<up>",
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

        notifications = {
          reminder_time = { 0, 1, 5, 10 },
          repeater_reminder_time = { 0, 1, 5, 10 },
          deadline_warning_reminder_time = { 0, 5 },
          cron_notifier = function(tasks)
            for _, task in ipairs(tasks) do
              local title = fmt("%s (%s)", task.category, task.humanized_duration)
              local subtitle = fmt("%s %s %s", string.rep("*", task.level), task.todo, task.title)
              local date = fmt("%s: %s", task.type, task.time:to_string())
              -- local subtitle = string.format(
              --     "%s %s %s",
              --     string.rep("*", task.level),
              --     task.todo,
              --     task.title
              -- )

              if vim.fn.executable "dunstify" == 1 then
                vim.uv.spawn("dunstify", {
                  args = {
                    fmt("--icon=%s/.config/dunst/bell.png", as.home),
                    fmt("%s\n%s %s", title, subtitle, date),
                    -- fmt("%s", subtitle),
                  },
                })
              end

              if vim.fn.executable "mpv" == 1 then
                vim.uv.spawn("mpv", {
                  args = {
                    "--audio-display=no",
                    fmt("%s/.config/dunst/notif-me.wav", as.home),
                    "--volume=50",
                  },
                })
              end

              -- Linux
              -- if vim.fn.executable "notify-send" == 1 then
              --     vim.uv.spawn("notify-send", {
              --         args = {
              --             string.format("%s\n%s\n%s", title, subtitle, date),
              --         },
              --     })
              -- end

              -- -- MacOS
              -- if vim.fn.executable "terminal-notifier" == 1 then
              --     vim.uv.spawn("terminal-notifier", {
              --         args = {
              --             "-title",
              --             title,
              --             "-subtitle",
              --             subtitle,
              --             "-message",
              --             date,
              --         },
              --     })
              -- end
            end
          end,
        },
      }
    end,
  },
  -- VIM-TABLE-MODE
  {
    "dhruvasagar/vim-table-mode",
    ft = {
      "markdown",
      "org",
      "norg",
    },
  },
  -- HEADLINES.NVIM
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "org", "norg" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("headlines").setup {
        org = { headline_highlights = false },
        norg = {
          headline_highlights = false,
          codeblock_highlight = false,
        },
        markdown = { headline_highlights = false },
      }
    end,
  },
  -- CALENDAR
  {
    "itchyny/calendar.vim",
    cmd = { "Calendar" },
  },
}