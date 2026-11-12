local add_on_event = require("vim-pack").add_on_event

local lazy = require("utils.plugin").require_lazy

local ConfigPath = lazy("config").path
local UtilKey = lazy "utils.map"

add_on_event("UIEnter", {
  {
    src = "xheisenbugx/org.nvim",
    opts = function()
      local H = lazy "utils.highlights"
      H.plugin("org.nvim", {
        theme = {
          ["*"] = {

            { OrgBold = { bg = "NONE" } },
            { OrgCheckbox = { bg = "NONE", reverse = false } },
            { OrgQuoteBlock = { inherit = "@markup.quote.markdown" } },

            { OrgStatistic = { fg = { from = "Error", attr = "fg" }, bg = "NONE" } },
            {
              OrgDone = {
                fg = { from = "Comment", attr = "fg" },
                bg = "NONE",
              },
            },
            {
              OrgTodo = {
                bg = {
                  from = "Error",
                  attr = "fg",
                  transparency = 0.5,
                  color = { from = "NormalNote", attr = "bg" },
                },
                fg = { from = "Normal", attr = "fg" },
                bold = true,
              },
            },

            { OrgTable = { bg = "NONE" } },

            {
              OrgBlockDelimiter = {
                fg = {
                  from = "CodeBlock",
                  attr = "bg",
                  alter = 2,
                  transparency = 0.5,
                  color = { from = "NormalNote", attr = "bg" },
                },
              },
            },

            {
              OrgContext = {
                bg = {
                  from = "NormalNote",
                  attr = "bg",
                  alter = 1,
                  transparency = 0.25,
                  color = { from = "NormalNote", attr = "bg" },
                  combine = { from = "Boolean", attr = "fg", alter = 0.2 },
                  combine_mode = "mix",
                  combine_intensity = 0.1,
                },
              },
            },

            {
              OrgContextBottom = {
                underline = true,
                reverse = false,
                sp = {
                  from = "OrgContext",
                  attr = "bg",
                  alter = 1,
                  transparency = 0.4,
                  color = { from = "OrgContext", attr = "bg" },
                },
              },
            },

            {
              OrgAgendaDate = {
                fg = { from = "Directory", attr = "fg" },
                bg = {
                  from = "Directory",
                  attr = "fg",
                  alter = 0.2,
                  transparency = 0.1,
                  color = { from = "NormalNote", attr = "bg" },
                },
              },
            },

            {
              OrgAgendaDateToday = {
                fg = { from = "String", attr = "fg" },
                bg = {
                  from = "String",
                  attr = "fg",
                  alter = 0.2,
                  transparency = 0.08,
                  color = { from = "NormalNote", attr = "bg" },
                },
                underline = true,
                reverse = false,
                bold = true,
              },
            },

            {
              OrgAgendaDateWeekend = {
                fg = { from = "Error", attr = "fg", alter = 0.5 },
                bg = {
                  from = "Error",
                  attr = "fg",
                  alter = 0.2,
                  transparency = 0.1,
                  color = { from = "NormalNote", attr = "bg" },
                },
              },
            },

            {
              OrgAgendaClocking = {
                fg = { from = "Boolean", attr = "fg", alter = 0.5 },
                bg = {
                  from = "Boolean",
                  attr = "fg",
                  alter = 0.2,
                  transparency = 0.1,
                  color = { from = "NormalNote", attr = "bg" },
                },
              },
            },
          },
        },
      })

      local codeblock_bg = H.get("CodeBlock", "bg")
      local codeblocktext_bg = H.get("CodeBlockFiletypeText", "bg")
      local codeblockjson_bg = H.get("CodeBlockFiletypeJson", "bg")
      local codeblockDb_bg = H.get("CodeBlockFiletypeDb", "bg")

      local mappings = {
        { "<Localleader>af", group = "find" },
        { "<localleader>ac", group = "capture:task/links" },
        { "<localleader>as", group = "set:deadline/schedule/clock" },
        { "<localleader>asc", group = "set:clock" },
        { "<localleader>au", group = "toggle" },
      }

      local whichkey = lazy "which-key"
      whichkey.add(mappings)

      local UtilAugroup = lazy("utils.map").augroup

      UtilAugroup("Org.nvim", {
        event = "FileType",
        pattern = "orgagenda",
        command = function(ev)
          whichkey.add {
            { "<Localleader>aF", group = "filter/sort", buffer = ev.buf },
            { "<Localleader>as", group = "set:deadline/schedule/clock", buffer = ev.buf },
            { "<Localleader>asc", group = "set:clock", buffer = ev.buf },
            { "<Localleader>ase", group = "set:effort", buffer = ev.buf },
            { "<Localleader>asm", group = "set:timer", buffer = ev.buf },
            { "<Localleader>asp", group = "set:property", buffer = ev.buf },
            { "<Localleader>au", group = "toggle", buffer = ev.buf },
            { "<Localleader>av", group = "view", buffer = ev.buf },
            { "<Localleader>ar", group = "refile", buffer = ev.buf },
            { "<Localleader>ail", group = "links", buffer = ev.buf },
          }

          UtilKey.nnoremap("<C-c>xr", function()
            lazy("utils.note").auto_remote_repeater_todo_org_nvim { match = "workout|habit|homework", by_time = true }
          end, { desc = "Exec: automatically close repeater TODOs", remap = true, force = true })
        end,
      }, {
        event = "FileType",
        pattern = "org",
        command = function(ev)
          whichkey.add {
            { "<Localleader>aF", group = "filter/sort", buffer = ev.buf },
            { "<Localleader>as", group = "set:deadline/schedule/clock", buffer = ev.buf },
            { "<Localleader>asc", group = "set:clock", buffer = ev.buf },
            { "<Localleader>asc", group = "set:clock", buffer = ev.buf },
            { "<Localleader>ase", group = "set:effort", buffer = ev.buf },
            { "<Localleader>asp", group = "set:property", buffer = ev.buf },
            { "<Localleader>au", group = "set:toggle", buffer = ev.buf },
            { "<Localleader>ar", group = "refile", buffer = ev.buf },
            { "<Localleader>ao", group = "open:narrow", buffer = ev.buf },
          }
        end,
      })

      return {
        picker = "fzf-lua",
        picker_opts = { winopts = {} },
        picker_keys = { split = "<C-s>", vsplit = "<C-v>", tab = "<C-t>", qflist = "<c-q>" },

        org_directory = ConfigPath.wiki_path,
        agenda_files = { string.format("%s/orgmode/**/**/*.org", ConfigPath.wiki_path) },
        default_notes_file = string.format("%s/orgmode/gtd/refile.org", ConfigPath.wiki_path),

        extensions = {
          roam = { directory = ConfigPath.wiki_path },
          review = {},
          super_agenda = {
            groups = {
              { name = "Important", priority = "A" },
              { name = "Today", time_grid = true, date = "today" },
              { name = "Due soon", deadline = "future", order = 2 },
              { name = "Work", tag = { "work", "office" }, order = 1 },
              -- { discard = { tag = "someday" } },
              { auto_category = true, order = 9 },
            },
          },
        },

        -- NOTE: this is just a test of custom_commands in the agenda.
        agenda = {
          custom_commands = {
            b = {
              description = "Agenda with no -homework",
              types = {
                { type = "agenda", span = "day", header = "Hari Ini" },
                { type = "todo", match = "-workout", header = "Semua Tugas Aktif" },
              },
            },
          },
        },

        refile = {
          max_level = 2,
          include_current_file = true,
          use_outline_path = "file",
        },
        log_done = true,
        ui = {
          images = {
            actual_width = false,
            startup = false,
            max_width = "window",
            max_height = 30,
            backend = "auto",
          },
          context = { enabled = true },
          hide_emphasis_markers = true,
          fontify_quote_and_verse_blocks = true,
          fontify_done_headline = true,
          fontify_todo_headline = true,
          src_block_faces = {
            python = { bg = codeblock_bg },
            bash = { bg = codeblock_bg },
            make = { bg = codeblock_bg },
            rust = { bg = codeblock_bg },
            ini = { bg = codeblock_bg },
            sql = { bg = codeblockDb_bg },
            java = { bg = codeblock_bg },
            text = { bg = codeblocktext_bg },
            vim = { bg = codeblocktext_bg },
            tmux = { bg = codeblockjson_bg },
            css = { bg = codeblock_bg },
            scss = { bg = codeblock_bg },
            cpp = { bg = codeblock_bg },
            html = { bg = codeblock_bg },
            json = { bg = codeblockjson_bg },
            yaml = { bg = codeblockjson_bg },
            conf = { bg = codeblock_bg },
            http = { bg = codeblock_bg },
            cfg = { bg = codeblock_bg },
            lua = { bg = codeblock_bg },
            php = { bg = codeblock_bg },
            go = { bg = codeblock_bg },
            c = { bg = codeblock_bg },
            ruby = { bg = codeblock_bg },
            jsx = { bg = codeblock_bg },
            typescript = { bg = codeblock_bg },
            javascript = { bg = codeblock_bg },
            tsx = { bg = codeblock_bg },
            toml = { bg = codeblock_bg },
          },
        },
        mappings = {
          disable_all = false,
          prefix = "<Localleader>a",
          global = {
            agenda = "<prefix>a",
            capture = "<prefix>cc",
            store_link = "<prefix>cl",
            goto_heading = "<prefix>fh",
            clock_goto = "<prefix>scj",
            clock_out = "<prefix>sco",
            clock_cancel = "<prefix>scC",
          },
          org = {
            help = "g?",
            -- visibility
            cycle = "<Tab>",
            global_cycle = "<S-Tab>",
            -- context / links
            context_action = { "<C-c><C-c>", "<prefix><CR>" },
            open_at_point = { "<CR>", "<Leader>ld", "<Leader>lv" },
            open_at_mouse = "<MiddleMouse>",
            find_file_at_mouse = "<RightMouse>",
            -- structure
            meta_return = "<M-CR>",
            meta_shift_return = "<M-S-CR>",
            insert_heading = "<prefix>ih",
            insert_todo_heading = "<prefix>it",
            insert_subheading = "<prefix>is",
            insert_drawer = "<prefix>id",
            insert_structure_template = "<prefix>ib",
            insert_footnote = "<prefix>if",
            cite_insert = "<prefix>i@",
            promote_heading = "<<",
            demote_heading = ">>",
            promote_subtree = "<prefix>H",
            demote_subtree = "<prefix>L",
            meta_left = { "<M-Left>" },
            meta_right = { "<M-Right>" },
            meta_up = { "<M-Up>" },
            meta_down = { "<M-Down>" },
            shift_meta_left = "<C-c><c-h>",
            shift_meta_right = "<C-c><c-l>",
            shift_meta_up = "<C-c><M-K>",
            shift_meta_down = "<C-c><M-J>",
            move_subtree_up = "<prefix>K",
            move_subtree_down = "<prefix>J",
            copy_subtree = "<prefix>hy",
            cut_subtree = "<prefix>hx",
            paste_subtree = "<prefix>hp",
            yank = "p", -- org-yank: folds / adjusts pasted subtrees
            yank_before = "P",
            clone_subtree = "<prefix>hc",
            sort = "<prefix>Fs",
            narrow_subtree = "<prefix>oo",
            toggle_comment = "<prefix>uc",
            toggle_archive_tag = "<prefix>hA",
            toggle_heading = "<prefix>*",
            toggle_item = "<prefix>-",
            emphasize = "<prefix>E",
            mark_element = "<prefix>v",
            narrow_block = "<prefix>ob",
            narrow_element = "<prefix>oe",
            goto_parent = "g{",
            next_heading = "<M-n>",
            prev_heading = "<M-p>",
            next_sibling = "][",
            prev_sibling = "[]",
            buffer_goto = "<prefix>.",
            imenu = "gO", -- like gO in help and markdown buffers
            -- todo / priority / tags / properties
            todo_next = "cit",
            todo_prev = "ciT",
            shift_right = "<S-Right>",
            shift_left = "<S-Left>",
            todo_select = "<prefix>st",
            shift_up = "<S-Up>",
            shift_down = "<S-Down>",
            increment = "<prefix><C-a>",
            decrement = "<prefix><C-x>",
            priority = "<prefix>spp",
            set_tags = "<prefix>sg",
            set_property = "<prefix>spa",
            delete_property = "<prefix>spC",
            id_get_create = "<prefix>si",
            -- dates
            schedule = "<prefix>ss",
            deadline = "<prefix>sd",
            timestamp = "<prefix>i.",
            timestamp_inactive = "<prefix>i!",
            -- lists
            toggle_checkbox = "<C-Space>",
            update_statistics = "<prefix>#",
            cycle_bullet = "<prefix>hb",
            -- clock
            clock_in = "<prefix>sci",
            clock_out = "<prefix>sco",
            clock_cancel = "<prefix>scC",
            clock_goto = "<prefix>scj",
            set_effort = "<prefix>see",
            inc_effort = "<prefix>sei",
            clock_modify_effort = "<prefix>scm",
            clock_resolve = "<prefix>scz",
            clock_report = "<prefix>scr",
            clock_display = "<prefix>scd",
            link_preview = "<prefix>xv",
            link_preview_refresh = "<prefix>xV",
            latex_preview = "<prefix>xl",
            dblock_update = "<prefix>xu",
            dblock_update_all = "<prefix>xU",
            column_view = "<prefix>C",
            -- links
            insert_link = "<prefix>ili",
            store_link = "<prefix>ils",
            toggle_link_display = "<prefix>ilt",
            next_link = "<prefix>iln",
            prev_link = "<prefix>ilp",
            insert_last_stored_link = "<prefix>ilL",
            insert_all_links = "<prefix>ilA",
            id_goto = "<prefix>ilg",
            id_copy = "<prefix>ily",
            -- refile / archive / attach
            refile = "<prefix>rr",
            refile_copy = "<prefix>rc",
            archive_subtree = "<prefix>$",
            attach = "<prefix>A",
            -- search / export
            sparse_tree = "<prefix>/",
            export = "<prefix>xE",
            -- tables
            table_create = "<prefix>Tc",
            table_insert_hline = "<prefix>T-",
            table_recalc = "<prefix>Tf",
            table_sort = "<prefix>Ts",
            table_insert_row = "<prefix>Tr",
            table_delete_row = "<prefix>TR",
            table_insert_column = "<prefix>Ti",
            table_delete_column = "<prefix>TI",
            table_copy_down = "<S-CR>",
            table_transpose = "<prefix>Tt",
            table_rotate_marks = "<prefix>T#",
            -- babel
            edit_special = "<prefix>e",
            babel_execute = "<prefix>xx",
            babel_execute_buffer = "<prefix>xb",
            babel_execute_subtree = "<prefix>xs",
            babel_tangle = "<prefix>bt",
            babel_remove_result = "<prefix>bk",
            babel_next_block = "<prefix>bn",
            babel_prev_block = "<prefix>bp",
            babel_tangle_file = "<prefix>bf",
            babel_expand = "<prefix>bv",
            babel_view_info = "<prefix>bI",
            babel_check = "<prefix>bc",
            babel_insert_header_arg = "<prefix>bj",
            babel_goto_named = "<prefix>bg",
            babel_goto_named_result = "<prefix>br",
            babel_goto_head = "<prefix>bu",
            babel_open_result = "<prefix>bo",
            babel_demarcate = "<prefix>bd",
            babel_lob_ingest = "<prefix>bi",
            babel_load_in_session = "<prefix>bl",
            babel_switch_to_session = "<prefix>bz",
            babel_switch_to_session_with_code = "<prefix>bZ",
            babel_kill_session = "<prefix>bK",
            babel_cancel = "<prefix>bC",
            babel_sha1_hash = "<prefix>ba",
            babel_describe_bindings = "<prefix>bh",
            babel_mark_block = "<prefix>bm",
            babel_do_key_sequence = "<prefix>bx",
          },
          --- Insert-mode mappings inside org buffers.
          org_insert = {
            meta_return = "<M-CR>",
            --- table: next field; empty headline / item: cycle its level
            insert_tab = "<Tab>",
            table_prev_field = "<S-Tab>",
            table_next_row = "<CR>",
            table_copy_down = "<S-CR>",
          },
          --- Emacs Org keys (org-mode-map), on top of the Vim-style keys above.
          --- Set a section to `false` to disable it, or an entry to `false` to
          --- drop one key.
          emacs_global = {
            agenda = false,
            capture = false,
            store_link = false,
          },
          emacs = {
            -- structure
            insert_heading = "<C-CR>",
            insert_todo_heading = "<C-S-CR>",
            ctrl_c_ret = "<C-c><CR>",
            ctrl_c_star = "<C-c>*",
            table_recalc_buffer = false, -- also C-u C-u C-c * in a table
            ctrl_c_minus = "<C-c>-",
            ctrl_c_caret = "<C-c>^",
            toggle_comment = "<C-c>;",
            insert_structure_template = "<C-c><C-,>",
            insert_drawer = "<C-c><C-x>d",
            insert_footnote = "<C-c><C-x>f",
            cite_insert = "<C-c><C-x>@",
            emphasize = "<C-c><C-x><C-f>",
            clone_subtree = "<C-c><C-x>c",
            copy_special = "<C-c><C-x><M-w>",
            cut_special = "<C-c><C-x><C-w>",
            paste_special = "<C-c><C-x><C-y>",
            mark_subtree = "<C-c>@",
            indirect_subtree = "<C-c><C-x>b",
            -- elements (M-h org-mark-element is taken by meta_left)
            forward_element = "<M-}>",
            backward_element = "<M-{>",
            up_element = "<C-c><C-^>",
            down_element = "<C-c><C-_>",
            transpose_element = "<C-M-t>",
            next_block = "<C-c><M-f>",
            previous_block = "<C-c><M-b>",
            toggle_fixed_width = "<C-c>:",
            list_make_subtree = "<C-c><C-*>",
            toggle_radio_button = "<C-c><C-x><C-r>",
            toggle_pretty_entities = "<C-c><C-x>\\",
            inlinetask_insert = "<C-c><C-x>t",
            -- visibility
            show_branches = "<C-c><C-k>",
            show_children = "<C-c><Tab>",
            reveal = "<C-c><C-r>",
            force_cycle_archived = "<C-c><C-Tab>",
            copy_visible = "<C-c><C-x>v",
            -- motion
            next_heading = "<C-c><C-n>",
            prev_heading = "<C-c><C-p>",
            next_sibling = "<C-c><C-f>",
            prev_sibling = "<C-c><C-b>",
            goto_parent = "<C-c><C-u>",
            buffer_goto = "<C-c><C-j>",
            -- todo / priority / tags / properties
            todo = "<C-c><C-t>",
            todo_next_sequence = "<C-S-Right>",
            todo_prev_sequence = "<C-S-Left>",
            priority = "<C-c><C-p>",
            set_tags = "<C-c><C-g>",
            set_property = "<C-c><C-x>p",
            set_property_and_value = "<C-c><C-x>P",
            toggle_tags_groups = "<C-c><C-x>q",
            toggle_ordered = "<C-c><C-x>o",
            add_note = { "<prefix>sn", "<C-c><C-z>" },
            -- dates
            schedule = "<C-c><C-s>",
            deadline = "<C-c><C-d>",
            timestamp = "<C-c>.",
            timestamp_inactive = "<C-c>!",
            toggle_time_stamp_overlays = "<C-c><C-x><C-t>",
            date_today = "<C-c><",
            goto_calendar = "<C-c>>",
            evaluate_time_range = "<C-c><C-y>",
            -- lists
            toggle_checkbox = "<C-c><C-x><C-b>",
            update_statistics = "<C-c>#",
            -- clock / effort / dynamic blocks
            clock_in = { "<C-c><C-x><C-i>", "<C-c><C-x><Tab>" },
            clock_in_last = "<C-c><C-x><C-x>",
            clock_out = "<C-c><C-x><C-o>",
            clock_cancel = "<C-c><C-x><C-q>",
            clock_goto = "<C-c><C-x><C-j>",
            -- no key in Emacs: C-c C-x C-r is org-toggle-radio-button (above);
            -- insert a clocktable with <C-c><C-x>x or <prefix>xr
            clock_report = false,
            clock_display = "<C-c><C-x><C-d>",
            link_preview = "<C-c><C-x><C-v>",
            link_preview_refresh = "<C-c><C-x><C-M-v>",
            latex_preview = "<C-c><C-x><C-l>",
            set_effort = "<C-c><C-x>e",
            inc_effort = "<C-c><C-x>E",
            clock_modify_effort = "<C-c><C-x><C-e>",
            clock_resolve = "<C-c><C-x><C-z>",
            shift_control_up = "<C-S-Up>",
            shift_control_down = "<C-S-Down>",
            dblock_update = "<C-c><C-x><C-u>",
            column_view = "<C-c><C-x><C-c>",
            insert_columnview = "<C-c><C-x>i",
            insert_dblock = "<C-c><C-x>x",
            -- timers
            timer_start = "<C-c><C-x>0",
            timer_stop = "<C-c><C-x>_",
            timer_pause = "<C-c><C-x>,",
            timer_insert = "<C-c><C-x>.",
            timer_item = "<C-c><C-x>-",
            timer_countdown = "<C-c><C-x>;",
            -- feeds
            feed_update_all = "<C-c><C-x>g",
            feed_goto_inbox = "<C-c><C-x>G",
            -- links
            insert_link = "<C-c><C-l>",
            open_link_or_entry = "<C-c><C-o>",
            insert_last_stored_link = "<C-c><M-l>",
            insert_all_links = "<C-c><C-M-l>",
            mark_ring_goto = "<C-c>&",
            next_link = "<C-c><C-x><C-n>",
            prev_link = "<C-c><C-x><C-p>",
            -- refile / archive / attach / agenda files
            refile = "<C-c><C-w>",
            refile_copy = "<C-c><M-w>",
            refile_reverse = "<C-c><C-w><C-w>",
            archive_subtree = { "<C-c>$", "<C-c><C-x><C-s>" },
            archive_subtree_default = "<C-c><C-x><C-a>",
            toggle_archive_tag = "<C-c><C-x>a",
            archive_to_sibling = "<C-c><C-x>A",
            attach = "<C-c><C-a>",
            agenda_file_to_front = "<C-c>[",
            agenda_file_remove = "<C-c>]",
            cycle_agenda_files = { "<C-'>", "<C-,>" },
            agenda_set_restriction_lock = "<C-c><C-x><",
            agenda_remove_restriction_lock = "<C-c><C-x>>",
            -- search / export / special
            sparse_tree = "<C-c>/",
            tags_sparse_tree = "<C-c>\\",
            export = "<prefix>xE",
            edit_special = "<prefix>e",
            -- tables
            table_create = "<C-c>|",
            table_formula = "<C-c>=",
            table_edit_field = "<C-c>`",
            table_sum = "<C-c>+",
            table_blank_field = "<C-c><Space>",
            table_coordinates = "<C-c>}",
            table_field_info = "<C-c>?",
            table_rotate_marks = "<C-#>",
            table_formula_debugger = "<C-c>{",
            table_ascii_plot = '<C-c>"a',
            table_plot = '<C-c>"g',
            table_el = "<C-c>~",
            -- babel (C-c C-v)
            babel_execute = "<prefix>xx",
            babel_execute_buffer = "<prefix>xb",
            babel_execute_subtree = "<prefix>xs",
            babel_tangle = { "<C-c><C-v>t", "<C-c><C-v><C-t>" },
            babel_remove_result = "<C-c><C-v>K",
            babel_next_block = { "<C-c><C-v>n", "<C-c><C-v><C-n>" },
            babel_prev_block = { "<C-c><C-v>p", "<C-c><C-v><C-p>" },
            babel_tangle_file = { "<C-c><C-v>f", "<C-c><C-v><C-f>" },
            babel_expand = { "<C-c><C-v>v", "<C-c><C-v><C-v>" },
            babel_view_info = "<C-c><C-v>I",
            babel_check = { "<C-c><C-v>c", "<C-c><C-v><C-c>" },
            babel_insert_header_arg = { "<C-c><C-v>j", "<C-c><C-v><C-j>" },
            babel_goto_named = "<C-c><C-v>g",
            babel_goto_named_result = { "<C-c><C-v>r", "<C-c><C-v><C-r>" },
            babel_goto_head = { "<C-c><C-v>u", "<C-c><C-v><C-u>" },
            babel_open_result = { "<C-c><C-v>o", "<C-c><C-v><C-o>" },
            babel_demarcate = { "<C-c><C-v>d", "<C-c><C-v><C-d>" },
            babel_lob_ingest = { "<C-c><C-v>i", "<C-c><C-v><Tab>" },
            babel_load_in_session = { "<C-c><C-v>l", "<C-c><C-v><C-l>" },
            babel_switch_to_session = "<C-c><C-v><C-z>",
            babel_switch_to_session_with_code = "<C-c><C-v>z",
            babel_sha1_hash = { "<C-c><C-v>a", "<C-c><C-v><C-a>" },
            babel_describe_bindings = "<C-c><C-v>h",
            babel_mark_block = "<C-c><C-v><C-M-h>",
            babel_do_key_sequence = { "<C-c><C-v>x", "<C-c><C-v><C-x>" },
          },
          --- Insert-mode Emacs keys.
          emacs_insert = {
            insert_heading = "<C-CR>",
            insert_todo_heading = "<C-S-CR>",
          },
          text_objects = {
            inner_heading = "ih",
            around_heading = "ah",
            inner_subtree = "ir",
            around_subtree = "ar",
            inner_element = "ie",
            around_element = "ae",
            inner_item = "i-",
            around_item = "a-",
            inner_cell = "ic",
            around_cell = "ac",
            inner_row = "iR",
            around_row = "aR",
            inner_column = "iC",
            around_column = "aC",
            inner_link = "iL",
            around_link = "aL",
            inner_timestamp = "id",
            around_timestamp = "ad",
          },
          agenda = {
            quit = "q",
            quit_kill = "Q",
            exit = "x",
            redo = "<C-c>R",
            redo_all = "gr", -- Emacs: g (a Vim prefix key)
            later = "f",
            earlier = "b",
            today = "~",
            goto_date = "<prefix>vD", -- Emacs: j (kept free for motion)
            day_view = "<prefix>vd",
            week_view = "<prefix>vw",
            fortnight_view = "<prefix>vt",
            month_view = "<prefix>vm",
            year_view = "<prefix>vy",
            reset_view = "<prefix>vR",
            ["goto"] = "o",
            switch_to = "<CR>",
            show = "<Tab>",
            show_scroll_down = "<BS>",
            show_1 = false, -- Emacs: unbound
            cycle_show = false, -- Emacs: unbound
            goto_mouse = "<MiddleMouse>", -- Emacs: mouse-2
            show_mouse = "<RightMouse>", -- Emacs: mouse-3
            recenter = "L",
            delete_other_windows = "<Leader>bK",
            follow_mode = "<prefix>uF",
            tree_to_indirect_buffer = "<C-c><C-x>b",
            todo = { "<prefix>st", "<C-c><C-t>" },
            todo_yesterday = false, -- Emacs: unbound
            todo_next = "<C-S-Right>",
            todo_prev = "<C-S-Left>",
            priority = { "<prefix>spp" },
            priority_up = { "+", "<S-Up>" },
            priority_down = { "-", "<S-Down>" },
            set_tags = { "<prefix>sg", "<C-c><C-g>" },
            show_tags = "<prefix>ug",
            set_property = "<prefix>spa",
            schedule = { "<C-c><C-s>", "<prefix>ss" },
            deadline = { "<C-c><C-d>", "<prefix>sd" },
            date_later = { "<S-Right>", "<C-c><C-x><Right>" },
            date_earlier = { "<S-Left>", "<C-c><C-x><Left>" },
            -- Emacs: unbound (C-u / C-u C-u <S-Right>, here counts 4 / 16)
            date_later_hours = false,
            date_earlier_hours = false,
            date_later_minutes = false,
            date_earlier_minutes = false,
            date_prompt = ">",
            clock_in = { "<prefix>sci", "<C-c><C-x><C-i>" },
            clock_out = { "<prefix>sco", "<C-c><C-x><C-o>" },
            clock_cancel = { "<prefix>scC", "<C-c><C-x><C-x>" },
            clock_goto = { "<prefix>scj", "<C-c><C-x><C-j>" },
            attach = "<C-c><C-a>",
            set_effort = { "<prefix>see", "<C-c><C-x>e" },
            timer = "<prefix>smm",
            timer_stop = "<prefix>smC",
            restriction_lock = "<C-c><C-x><",
            remove_restriction_lock = "<C-c><C-x>>",
            refile = "<prefix>rr",
            archive = { "<C-c>$", "<C-c><C-x><C-s>" },
            archive_default = "<prefix>sA",
            archive_default_confirm = "<prefix>sa",
            archive_sibling = "<C-c><C-x>A",
            toggle_archive_tag = "<C-c><C-x>a",
            kill = "<C-k>",
            open_link = "<C-c><C-o>",
            add_note = { "<prefix>sn", "<C-c><C-z>" },
            log_mode = "<prefix>ul",
            log_all_mode = "<prefix>uL",
            clockcheck_mode = "<prefix>scm",
            clockreport_mode = "<prefix>scr",
            entry_text_mode = "<prefix>ut",
            archives_mode = "va",
            archives_files_mode = "vA",
            inactive_mode = "v[",
            time_grid = "vG", -- Emacs: G (kept free for motion)
            toggle_deadlines = { "!", "v!" },
            toggle_diary = "D",
            diary_entry = "i", -- org-agenda-diary-entry (also in Visual mode)
            toggle_habits_display = "vh", -- Emacs: K (capture here)
            toggle_habits = false, -- Emacs: unbound
            dim_blocked = "#",
            filter = "<prefix>Ff",
            filter_tag = "<prefix>Fg",
            filter_category = "<prefix>Fc",
            filter_regexp = "<prefix>Fr",
            filter_effort = "<prefix>Fe",
            filter_top_headline = "<prefix>Ft",
            filter_remove = "<prefix>FC",
            -- limit = "<prefix>Fsl",
            limit = false, -- di disabled dulu sementara, karena prefix>Fsl itu prefix>Fs untuk sort
            query_add = "[",
            query_subtract = "]",
            query_add_re = "{",
            query_subtract_re = "}",
            mark = "m",
            unmark = "u",
            unmark_all = "U",
            toggle_mark = "<M-m>",
            mark_all = "*",
            toggle_mark_all = "<M-*>",
            mark_regexp = "%",
            bulk_action = "B",
            next_item = "n",
            prev_item = "p",
            next_date_line = "<C-c><C-n>",
            prev_date_line = "<C-c><C-p>",
            forward_block = "<C-Down>",
            backward_block = "<C-Up>",
            drag_line_forward = "<M-Down>",
            drag_line_backward = "<M-Up>",
            append = "A",
            columns = "<C-c><C-x><C-c>",
            calendar = "c",
            convert_date = "gC", -- Emacs: C (the clock report here)
            phases_of_moon = "M",
            sunrise_sunset = "S",
            holidays = "H",
            save_all = "<C-x><C-s>",
            undo = { "<C-_>", "<C-/>", "<C-x>u" }, -- org-agenda-undo (Emacs undo keys)
            capture = "K", -- Emacs: k (kept free for motion)
            export = "<C-x><C-w>",
            help = "g?",
            show_flagging_note = "?",
            mobile_pull = "<C-c><C-x><CR>g",
            mobile_push = "<C-c><C-x><CR>p",
          },
          capture = {
            finalize = { "<C-c><C-c>", "<prefix>w" },
            kill = { "<C-c><C-k>", "<prefix>k" },
            refile = { "<C-c><C-w>", "<prefix>rr" },
          },
          edit_src = {
            save_exit = { "<C-c><C-C>", "<prefix>w" },
            abort = { "<C-c><C-k>", "<prefix>k" },
            -- the block has a :session: send the buffer (Visual: the lines) to it
            -- (org-src-associate-babel-session)
            send_to_session = { "<C-c><C-s>" },
          },
          --- Keys of the Beamer mode (org-beamer-mode-map), only while it is on.
          beamer = {
            beamer_select_environment = "<C-c><C-b>",
          },
        },
      }
    end,
  },
})
