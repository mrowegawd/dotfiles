local fmt = string.format

return {
    {
        "nvim-orgmode/orgmode",
        ft = { "org" },
        init = function()
            require("legendary").keymaps {
                {
                    itemgroup = "Notes",
                    description = "Neorg or orgmode",
                    icon = as.ui.icons.misc.note,
                    keymaps = {
                        {
                            "<Localleader>so",
                            function()
                                return require("r.utils").EditOrgTodo()
                            end,
                            description = "Orgmode: directly edit todos org",
                        },
                    },
                },
            }
        end,
        dependencies = {
            {
                "akinsho/org-bullets.nvim",
                ft = { "org" },
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
            orgmode.setup {
                org_agenda_skip_deadline_if_done = true,
                org_src_window_setup = "top 16new",
                org_agenda_min_height = 16,
                org_hide_emphasis_markers = true,
                org_hide_leading_stars = true,
                org_agenda_skip_scheduled_if_done = true,
                org_agenda_files = {
                    fmt("%s/orgmode/gtd/*", as.wiki_path),
                    fmt("%s/orgmode/journal/homeclean/*", as.wiki_path),
                    fmt("%s/orgmode/journal/HBD/*", as.wiki_path),
                },
                org_default_notes_file = fmt(
                    "%s/orgmode/gtd/refile.org",
                    as.wiki_path
                ),
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
                win_split_mode = "20split",
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
                mappings = {
                    disable_all = false,
                    prefix = "<leader>",
                    global = {
                        org_agenda = ",aa",
                        org_capture = ",ac",
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
                        org_refile = "<leader>or",
                        org_timestamp_up = "<C-a>",
                        org_timestamp_down = "<C-x>",
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
                        org_next_visible_heading = "zn",
                        org_previous_visible_heading = "zp",
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
                        org_export = "<prefix>e",
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
                            local title = fmt(
                                "%s (%s)",
                                task.category,
                                task.humanized_duration
                            )
                            local subtitle = fmt(
                                "%s %s %s",
                                string.rep("*", task.level),
                                task.todo,
                                task.title
                            )
                            local date =
                                fmt("%s: %s", task.type, task.time:to_string())
                            -- local subtitle = string.format(
                            --     "%s %s %s",
                            --     string.rep("*", task.level),
                            --     task.todo,
                            --     task.title
                            -- )

                            if vim.fn.executable "dunstify" == 1 then
                                vim.loop.spawn("dunstify", {
                                    args = {
                                        fmt(
                                            "--icon=%s/.config/dunst/bell.png",
                                            as.home
                                        ),
                                        fmt("%s\n%s %s", title, subtitle, date),
                                        -- fmt("%s", subtitle),
                                    },
                                })
                            end

                            if vim.fn.executable "mpv" == 1 then
                                vim.loop.spawn("mpv", {
                                    args = {
                                        "--audio-display=no",
                                        fmt(
                                            "%s/.config/dunst/notif-me.wav",
                                            as.home
                                        ),
                                        "--volume=50",
                                    },
                                })
                            end

                            -- Linux
                            -- if vim.fn.executable "notify-send" == 1 then
                            --     vim.loop.spawn("notify-send", {
                            --         args = {
                            --             string.format("%s\n%s\n%s", title, subtitle, date),
                            --         },
                            --     })
                            -- end

                            -- -- MacOS
                            -- if vim.fn.executable "terminal-notifier" == 1 then
                            --     vim.loop.spawn("terminal-notifier", {
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
}
