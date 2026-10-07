-- local AgendaMode = {
--   FAST = "fast",
--   SLOW = "slow",
-- }
--
-- local agenda_mode = AgendaMode.FAST
--
-- local function setup_agenda(pattern)
--   local Orgmode = RUtils.notes.setup_orgmode()
--   Orgmode.setup {
--     org_agenda_files = pattern,
--   }
-- end
--
-- local function refresh_agenda_files(force_slow)
--   if force_slow then
--     agenda_mode = AgendaMode.SLOW
--   else
--     agenda_mode = (agenda_mode == AgendaMode.FAST) and AgendaMode.SLOW or AgendaMode.FAST
--   end
--
--   local is_fast = agenda_mode == AgendaMode.FAST
--
--   setup_agenda(is_fast and "~/Dropbox/neorg/**/*" or "~/Dropbox/neorg/orgmode/**/*.org")
--
--   return is_fast
-- end

return {
  -- CALENDAR.NVIM
  {
    "wsdjeg/calendar.nvim",
    cmd = "Calendar",
  },
  -- ORG.NVIM
  {
    "xheisenbugx/org.nvim",
    -- event = "VeryLazy",
    main = "org",
    -- dependencies = {
    --   {
    --     "lukas-reineke/headlines.nvim",
    --     ft = { "org" },
    --     opts = {
    --       markdown = {
    --         headline_highlights = false,
    --         codeblock_highlight = false,
    --         quote_highlight = false,
    --         bullet_highlights = false,
    --       },
    --       org = {
    --         headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6" },
    --         codeblock_highlight = "CodeBlock",
    --         dash_highlight = "Dash",
    --         dash_string = "-",
    --         doubledash_highlight = "DoubleDash",
    --         doubledash_string = "=",
    --         quote_highlight = "@markup.quote.markdown",
    --         quote_string = "┃",
    --         fat_headlines = false,
    --         fat_headline_upper_string = "▃",
    --         fat_headline_lower_string = "🬂",
    --       },
    --     },
    --   },
    -- },
    -- lazy = false,
    opts = {
      org_directory = { string.format("%s/orgmode", RUtils.config.path.wiki_path) },
      -- org_directory = "~/org",

      -- org_files = { string.format("%s/orgmode/**/*", RUtils.config.path.wiki_path) },
      agenda_files = { string.format("%s/**/*", RUtils.config.path.wiki_path) },

      default_notes_file = RUtils.file.get_agenda_path "/orgmode/gtd/refile.org",

      -- hide_emphasis_markers = true,

      -- src_preserve_indentation = true,
      -- adapt_indentation = true,

      indent_mode = false,
      -- default_notes_file = "~/org/refile.org",
      ui = {
        --- Conceal link brackets and show only descriptions (org-link-descriptive).
        conceal_links = true,
        --- Hide *, /, _, =, ~, + around emphasized text (org-hide-emphasis-markers).
        hide_emphasis_markers = true,

        imenu_depth = 5,

        indent_mode = false,
        -- indent_mode = true,
      },
      --
      mappings = {
        disable_all = false,
        prefix = "<LocalLeader>a",
        global = {
          agenda = "<prefix>a",
          capture = "<prefix>c",
          store_link = "<prefix>ls",
          goto_heading = "<prefix>g",
          clock_goto = "<prefix>xj",
          clock_out = "<prefix>xo",
          clock_cancel = "<prefix>xq",
        },
        org = {
          help = "g?",
          -- visibility
          cycle = "<Tab>",
          global_cycle = "<S-Tab>",
          -- context / links
          context_action = { "<C-c><C-c>", "<prefix><CR>" },
          open_at_point = { "<CR>", "gx", "<prefix>o" },
          -- structure
          meta_return = "<M-CR>",
          meta_shift_return = "<M-S-CR>",
          insert_heading = "<prefix>ih",
          insert_todo_heading = "<prefix>it",
          insert_subheading = "<prefix>is",
          insert_drawer = "<prefix>id",
          insert_structure_template = "<prefix>ib",
          insert_footnote = "<prefix>if",
          promote_heading = "<<",
          demote_heading = ">>",
          promote_subtree = "<s",
          demote_subtree = ">s",
          meta_left = "<M-Left>",
          meta_right = "<M-Right>",
          meta_up = "<M-Up>",
          meta_down = "<M-Down>",
          shift_meta_left = "<C-c><M-H>",
          shift_meta_right = "<C-c><M-L>",
          shift_meta_up = "<C-c><M-K>",
          shift_meta_down = "<C-c><M-J>",
          move_subtree_up = "<prefix>K",
          move_subtree_down = "<prefix>J",
          copy_subtree = "<prefix>hy",
          cut_subtree = "<prefix>hd",
          paste_subtree = "<prefix>hp",
          clone_subtree = "<prefix>hc",
          sort = "<prefix>hs",
          narrow_subtree = "<prefix>hn",
          toggle_comment = "<prefix>hC",
          toggle_archive_tag = "<prefix>hA",
          toggle_heading = "<prefix>*",
          toggle_item = "<prefix>-",
          emphasize = "<prefix>E",
          mark_element = "<prefix>v",
          narrow_block = "<prefix>nb",
          narrow_element = "<prefix>ne",
          goto_parent = "g{",
          next_heading = "<M-n>",
          prev_heading = "<M-p>",
          next_sibling = "][",
          prev_sibling = "[]",
          buffer_goto = "<prefix>.",
          -- todo / priority / tags / properties
          todo_next = "cit",
          todo_prev = "ciT",
          shift_right = "<S-Right>",
          shift_left = "<S-Left>",
          todo_select = "<prefix>T",
          shift_up = "<S-Up>",
          shift_down = "<S-Down>",
          increment = "<C-a>",
          decrement = "<C-x>",
          priority = "<prefix>,",
          set_tags = "<prefix>t",
          set_property = "<prefix>p",
          delete_property = "<prefix>P",
          id_get_create = "<prefix>lI",
          -- dates
          schedule = "<prefix>s",
          deadline = "<prefix>d",
          timestamp = "<prefix>i.",
          timestamp_inactive = "<prefix>i!",
          -- lists
          toggle_checkbox = "<C-Space>",
          update_statistics = "<prefix>#",
          cycle_bullet = "<prefix>hb",
          -- clock
          clock_in = "<prefix>xi",
          clock_out = "<prefix>xo",
          clock_cancel = "<prefix>xq",
          clock_goto = "<prefix>xj",
          set_effort = "<prefix>xe",
          inc_effort = "<prefix>xE",
          clock_modify_effort = "<prefix>xm",
          clock_resolve = "<prefix>xz",
          clock_report = "<prefix>xr",
          clock_display = "<prefix>xd",
          link_preview = "<prefix>xv",
          link_preview_refresh = "<prefix>xV",
          latex_preview = "<prefix>xl",
          dblock_update = "<prefix>xu",
          dblock_update_all = "<prefix>xU",
          column_view = "<prefix>C",
          -- links
          insert_link = "<prefix>li",
          store_link = "<prefix>ls",
          toggle_link_display = "<prefix>lt",
          next_link = "<prefix>ln",
          prev_link = "<prefix>lp",
          insert_last_stored_link = "<prefix>lL",
          insert_all_links = "<prefix>lA",
          id_goto = "<prefix>lg",
          id_copy = "<prefix>ly",
          -- refile / archive / attach
          refile = "<prefix>r",
          refile_copy = "<prefix>R",
          archive_subtree = "<prefix>$",
          attach = "<prefix>A",
          -- search / export
          sparse_tree = "<prefix>/",
          export = "<prefix>e",
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
          edit_special = "<prefix>'",
          babel_execute = "<prefix>be",
          babel_execute_buffer = "<prefix>bb",
          babel_execute_subtree = "<prefix>bs",
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
          agenda = "<C-c>a",
          capture = "<C-c>c",
          store_link = "<C-c>l",
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
          priority = "<C-c>,",
          set_tags = "<C-c><C-q>",
          set_property = "<C-c><C-x>p",
          set_property_and_value = "<C-c><C-x>P",
          toggle_tags_groups = "<C-c><C-x>q",
          toggle_ordered = "<C-c><C-x>o",
          add_note = "<C-c><C-z>",
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
          clock_report = "<C-c><C-x><C-r>",
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
          archive_subtree = { "<C-c>$", "<C-c><C-x><C-s>", "<C-c><C-x><C-a>" },
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
          export = "<C-c><C-e>",
          edit_special = "<C-c>'",
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
          babel_execute = { "<C-c><C-v>e", "<C-c><C-v><C-e>" },
          babel_execute_buffer = { "<C-c><C-v>b", "<C-c><C-v><C-b>" },
          babel_execute_subtree = { "<C-c><C-v>s", "<C-c><C-v><C-s>" },
          babel_tangle = { "<C-c><C-v>t", "<C-c><C-v><C-t>" },
          babel_remove_result = "<C-c><C-v>k",
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
        },
        agenda = {
          quit = "q",
          quit_kill = "Q",
          exit = "x",
          redo = "r",
          redo_all = "gr", -- Emacs: g (a Vim prefix key)
          later = "f",
          earlier = "b",
          today = ".",
          goto_date = "gd", -- Emacs: j (kept free for motion)
          day_view = "vd",
          week_view = "vw",
          fortnight_view = "vt",
          month_view = "vm",
          year_view = "vy",
          reset_view = "v<Space>",
          -- goto = "<TAB>",
          switch_to = "<CR>",
          show = "<Space>",
          show_scroll_down = "<BS>",
          recenter = "L",
          delete_other_windows = "o",
          follow_mode = { "F", "vf" },
          todo = { "t", "<C-c><C-t>" },
          todo_next = "<C-S-Right>",
          todo_prev = "<C-S-Left>",
          priority = { ",", "<C-c>," },
          priority_up = { "+", "<S-Up>" },
          priority_down = { "-", "<S-Down>" },
          set_tags = { ":", "<C-c><C-q>", "<C-c><C-c>" },
          show_tags = "T",
          set_property = "<C-c><C-x>p",
          schedule = { "<C-c><C-s>", "s" },
          deadline = { "<C-c><C-d>", "d" },
          date_later = { "<S-Right>", "<C-c><C-x><Right>" },
          date_earlier = { "<S-Left>", "<C-c><C-x><Left>" },
          date_prompt = ">",
          clock_in = { "I", "<C-c><C-x><C-i>" },
          clock_out = { "O", "<C-c><C-x><C-o>" },
          clock_cancel = { "X", "<C-c><C-x><C-x>" },
          clock_goto = { "J", "<C-c><C-x><C-j>" },
          attach = "<C-c><C-a>",
          set_effort = { "e", "<C-c><C-x>e" },
          timer = ";",
          timer_stop = "<C-c><C-x>_",
          restriction_lock = "<C-c><C-x><",
          remove_restriction_lock = "<C-c><C-x>>",
          refile = { "<C-c><C-w>", "R" },
          archive = { "$", "<C-c>$", "<C-c><C-x><C-s>" },
          archive_default = { "a", "<C-c><C-x><C-a>" },
          archive_sibling = "<C-c><C-x>A",
          toggle_archive_tag = "<C-c><C-x>a",
          kill = "<C-k>",
          open_link = "<C-c><C-o>",
          add_note = { "z", "<C-c><C-z>" },
          log_mode = { "l", "vl" },
          log_all_mode = "vL",
          clockcheck_mode = "vc",
          clockreport_mode = { "C", "vR" },
          entry_text_mode = { "E", "vE" },
          archives_mode = "va",
          archives_files_mode = "vA",
          inactive_mode = "v[",
          time_grid = { "G", "vG" },
          toggle_deadlines = { "!", "v!" },
          dim_blocked = "#",
          filter = "/",
          filter_tag = "\\",
          filter_category = "<",
          filter_regexp = "=",
          filter_effort = "_",
          filter_top_headline = "^",
          filter_remove = "|",
          limit = "~",
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
          save_all = "<C-x><C-s>",
          capture = "K", -- Emacs: k (kept free for motion)
          export = "<C-x><C-w>",
          help = "g?",
        },
        capture = {
          finalize = { "<C-c><C-c>", "<prefix>w" },
          kill = { "<C-c><C-k>", "<prefix>k" },
          refile = { "<C-c><C-w>", "<prefix>r" },
        },
        edit_src = {
          save_exit = { "<C-c>'", "<prefix>'" },
          abort = { "<C-c><C-k>", "<prefix>k" },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = { org = { inherit_defaults = true, "org" } },
        providers = { org = { name = "Org", module = "org.completion.blink" } },
      },
    },
  },
  -- ORGMODE
  -- {
  --   "nvim-orgmode/orgmode",
  --   event = "VeryLazy",
  --   ft = { "org" },
  --   dependencies = {
  --     "akinsho/org-bullets.nvim",
  --     "folke/snacks.nvim", -- Required for image rendering.
  --     "danilshvalov/org-modern.nvim",
  --     {
  --       "lukas-reineke/headlines.nvim",
  --       ft = { "org" },
  --       opts = {
  --         markdown = {
  --           headline_highlights = false,
  --           codeblock_highlight = false,
  --           quote_highlight = false,
  --           bullet_highlights = false,
  --         },
  --         org = {
  --           headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6" },
  --           codeblock_highlight = "CodeBlock",
  --           dash_highlight = "Dash",
  --           dash_string = "-",
  --           doubledash_highlight = "DoubleDash",
  --           doubledash_string = "=",
  --           quote_highlight = "@markup.quote.markdown",
  --           quote_string = "┃",
  --           fat_headlines = false,
  --           fat_headline_upper_string = "▃",
  --           fat_headline_lower_string = "🬂",
  --         },
  --       },
  --     },
  --   },
  --   keys = {
  --     { "<LocalLeader>qv", "", desc = "view/jump to date", ft = { "orgagenda" } },
  --     { "<LocalLeader>qs", "", desc = "set edit date/schedule/note/codeblock", ft = { "orgagenda", "org" } },
  --     { "<LocalLeader>qsp", "", desc = "priority", ft = { "orgagenda", "org" } },
  --     { "<LocalLeader>qsc", "", desc = "clock", ft = { "orgagenda", "org" } },
  --     { "<LocalLeader>qx", "", desc = "export", ft = { "org" } },
  --
  --     { "<LocalLeader>af", "", desc = "find/grep" },
  --     { "<LocalLeader>ac", "", desc = "create note/capture" },
  --
  --     {
  --       "<LocalLeader>aa",
  --       function()
  --         refresh_agenda_files(true)
  --         RUtils.notes.setup_orgmode().action "agenda.prompt"
  --       end,
  --       desc = "Note: open agenda [orgmode]",
  --     },
  --
  --     -- TEST Command
  --     {
  --       "<Leader>oo",
  --       RUtils.notes.auto_remote_repeater_todo,
  --       desc = "Note: open item heading in tab",
  --       ft = "orgagenda",
  --     },
  --     {
  --       "<CR>",
  --       function()
  --         local imlazy = require "imlazy"
  --
  --         local ft_allowed = { "org", "orgagenda" }
  --
  --         if not vim.tbl_contains(ft_allowed, vim.bo.filetype) then
  --           return
  --         end
  --         local orgagenda_tbl
  --         if vim.bo.filetype == ft_allowed[2] then
  --           orgagenda_tbl = require("orgmode.config.mappings").agenda
  --         elseif vim.bo.filetype == ft_allowed[1] then
  --           orgagenda_tbl = require("orgmode.config.mappings").org
  --         end
  --
  --         local orgagenda_list_mappings = {}
  --         for name, entry in pairs(orgagenda_tbl) do
  --           local lua_code = entry.handler:match "^<[Cc]md>(.*)<[Cc][Rr]>$"
  --
  --           orgagenda_list_mappings[#orgagenda_list_mappings + 1] = {
  --             fn_name = name,
  --             fun = function()
  --               if lua_code then
  --                 vim.cmd(lua_code)
  --               end
  --             end,
  --           }
  --         end
  --
  --         imlazy.menu(orgagenda_list_mappings)
  --       end,
  --       desc = "Note: menu commands [orgmode]",
  --       ft = { "orgagenda", "org" },
  --     },
  --   },
  --   opts = function()
  --     local Menu = require "org-modern.menu"
  --     return {
  --       ui = {
  --         input = { use_vim_ui = true }, -- menggunakan vim.ui.input nvim, jadi snacks.nvim yang handle nya
  --         menu = {
  --           handler = function(data)
  --             Menu:new({
  --               window = {
  --                 margin = { 1, 0, 1, 0 },
  --                 padding = { 0, 1, 0, 1 },
  --                 title_pos = "center",
  --                 border = "single",
  --                 zindex = 1000,
  --               },
  --               icons = {
  --                 separator = "➜",
  --               },
  --             }):open(data)
  --           end,
  --         },
  --       },
  --
  --       org_agenda_files = string.format("%s/orgmode/**/*.org", RUtils.config.path.wiki_path),
  --       org_default_notes_file = RUtils.file.get_agenda_path "/orgmode/gtd/refile.org",
  --
  --       org_todo_keywords = {
  --         "LEARNING(l)", -- task untuk jadwal learning
  --         "PROGRESS(p)", -- task yang sedang dikerjakan
  --         "WAITING(n)", -- task yang akan dialankan setelah 'progress' task selesai
  --         "CHECK(c)", -- task yang boleh dikerjakan saat free-time
  --         "HBD(b)",
  --         "TODO(t)",
  --         -- "STATUS(s)", -- task yang dikerjakan tapi bukan project, seperti belajar, baca buku, dsb
  --         "|",
  --         "DONE(d)",
  --       },
  --       org_todo_keyword_faces = {
  --         CHECK = ":foreground blue :background royalblue :weight bold :slant normal",
  --         NEXT = ":foreground brightmagenta :background darkmagenta :weight bold :slant normal",
  --         TODO = ":foreground red :weight bold :slant normal",
  --         HBD = ":foreground white :background blue :weight bold :slant normal",
  --         -- STATUS = ":foreground black :background darkcyan :weight bold :slant normal",
  --         DONE = ":foreground gray :weight bold :slant normal",
  --
  --         PROGRESS = ":foreground white :background red :weight bold :slant italic",
  --         LEARNING = ":foreground black :background darkyellow :weight bold :slant normal",
  --       },
  --       org_indent_mode_turns_off_org_adapt_indentation = false,
  --       org_agenda_skip_scheduled_if_done = true,
  --       org_hide_emphasis_markers = true,
  --       org_agenda_use_time_grid = false,
  --       org_agenda_remove_tags = true,
  --       org_capture_templates = {
  --         t = {
  --           description = "Todo",
  --           template = "* TODO %? \n  SCHEDULED: %T\n\n\tDescribe:\n\n\tCode Error:\n\n\tExpected:\n",
  --           -- headline = "Another herading",
  --           target = RUtils.file.get_agenda_path "/orgmode/gtd/refile.org",
  --         },
  --         d = {
  --           description = "Dotfiles",
  --           template = "* TODO %? \t\t\t\t\t:config:\n  SCHEDULED: %T",
  --           target = RUtils.file.get_agenda_path "/orgmode/gtd/refile.org",
  --         },
  --         i = {
  --           description = "Inbox",
  --           template = "* TODO %? \n  SCHEDULED: %t\n\n\tDescribe:\n",
  --           target = RUtils.file.get_agenda_path "/orgmode/gtd/inbox.org",
  --         },
  --         l = {
  --           description = "Link",
  --           template = "* TODO %?\n  SCHEDULED: %t\n  %a\n\n\tDescribe:\n",
  --           target = RUtils.file.get_agenda_path "/orgmode/gtd/inbox.org",
  --         },
  --         j = {
  --           description = "Journal",
  --           template = "\n** %<%Y-%m-%d> %<%A>\n*** %U\n\n%?",
  --           target = RUtils.file.get_agenda_path "/orgmode/journal/journal.org",
  --         },
  --         -- b = {
  --         --   description = "URL bookmarks",
  --         --   template = "* RAPIKAN: %? \n  SCHEDULED: %t\n\n\tWhat about this URL:\n\n\tURL:\n",
  --         --   target = RUtils.file.get_agenda_path "/orgmode/bookmarks/urls.org",
  --         -- },
  --         -- k = {
  --         --     description = "Markdown",
  --         --     template = "\n* TODO %? \n  SCHEDULED: %t",
  --         --     target = RUtils.file.get_agenda_path "/orgmode/gtd/base.md",
  --         --     filetype = "markdown",
  --         -- },
  --       },
  --       win_split_mode = "float",
  --       org_agenda_min_height = 2,
  --       org_agenda_custom_commands = {
  --         -- "c" is the shortcut that will be used in the prompt
  --         c = {
  --           description = "Task for edit dotfiles (nvim, emacs, and stuff)", -- Description shown in the prompt for the shortcut
  --           types = {
  --             {
  --               type = "tags_todo", -- Type can be agenda | tags | tags_todo
  --               -- match = "config", -- Type can be agenda | tags | tags_todo
  --               match = '+PRIORITY="A"', --Same as providing a "Match:" for tags view <leader>oa + m, See: https://orgmode.org/manual/Matching-tags-and-properties.html
  --               org_agenda_overriding_header = "⭐ Dotfiles: High priority todo",
  --               org_agenda_todo_ignore_deadlines = "far", -- Ignore all deadlines that are too far in future (over org_deadline_warning_days). Possible values: all | near | far | past | future
  --               org_agenda_remove_tags = false,
  --               -- org_agenda_sorting_strategy = "",
  --             },
  --             {
  --               type = "tags",
  --               match = "config",
  --               org_agenda_overriding_header = "🔧 Dotfiles: Some broken configs..",
  --               org_agenda_remove_tags = false,
  --               -- org_agenda_todo_ignore_scheduled = "near",
  --             },
  --             -- {
  --             --   type = "agenda",
  --             --   org_agenda_overriding_header = "Whole week overview",
  --             --   -- org_agenda_tag_filter_preset = { "personal" },
  --             --   org_agenda_span = "week", -- 'week' is default, so it's not necessary here, just an example
  --             --   org_agenda_start_on_weekday = 1, -- Start on Monday
  --             --   org_agenda_remove_tags = true, -- Do not show tags only for this view
  --             -- },
  --           },
  --         },
  --         L = {
  --           description = "LEARNING",
  --           types = {
  --             -- {
  --             --   type = "tags_todo",
  --             --   org_agenda_overriding_header = "LEARNING todos",
  --             --   org_agenda_category_filter_preset = "todos", -- Show only headlines from `todos` category. Same value providad as when pressing `/` in the Agenda view
  --             --   org_agenda_sorting_strategy = { "todo-state-up", "priority-down" }, -- See all options available on org_agenda_sorting_strategy
  --             -- },
  --             {
  --               type = "agenda",
  --               org_agenda_overriding_header = "Learning: Whole week overview",
  --               org_agenda_tag_filter_preset = "learning",
  --               -- org_agenda_span = "week", -- 'week' is default, so it's not necessary here, just an example
  --               org_agenda_start_on_weekday = 1, -- Start on Monday
  --               -- org_agenda_remove_tags = true, -- Do not show tags only for this view
  --             },
  --             -- {
  --             --   type = "agenda",
  --             --   org_agenda_overriding_header = "Personal projects agenda",
  --             --   org_agenda_files = { "~/my-projects/**/*" }, -- Can define files outside of the default org_agenda_files
  --             -- },
  --             -- {
  --             --   type = "tags",
  --             --   org_agenda_overriding_header = "Personal projects notes",
  --             --   org_agenda_files = { "~/my-projects/**/*" },
  --             --   org_agenda_tag_filter_preset = "NOTES-REFACTOR", -- Show only headlines with NOTES tag that does not have a REFACTOR tag. Same value providad as when pressing `/` in the Agenda view
  --             -- },
  --           },
  --         },
  --         w = {
  --           description = "Work",
  --           types = {
  --             {
  --               type = "tags_todo",
  --               org_agenda_overriding_header = "My personal todos",
  --               org_agenda_category_filter_preset = "todos", -- Show only headlines from `todos` category. Same value providad as when pressing `/` in the Agenda view
  --               org_agenda_sorting_strategy = { "todo-state-up", "priority-down" }, -- See all options available on org_agenda_sorting_strategy
  --             },
  --             {
  --               type = "agenda",
  --               org_agenda_overriding_header = "Personal projects agenda",
  --               org_agenda_files = { "~/my-projects/**/*" }, -- Can define files outside of the default org_agenda_files
  --             },
  --             {
  --               type = "tags",
  --               org_agenda_overriding_header = "Personal projects notes",
  --               org_agenda_files = { "~/my-projects/**/*" },
  --               org_agenda_tag_filter_preset = "NOTES-REFACTOR", -- Show only headlines with NOTES tag that does not have a REFACTOR tag. Same value providad as when pressing `/` in the Agenda view
  --             },
  --           },
  --         },
  --       },
  --       mappings = {
  --         disable_all = false,
  --         prefix = "<LocalLeader>a",
  --         global = {
  --           org_capture = "<LocalLeader>ac",
  --           org_agenda = "<LocalLeader>aa",
  --         },
  --         agenda = {
  --           org_agenda_day_view = "<LocalLeader>qvd",
  --           org_agenda_week_view = "<LocalLeader>qvw",
  --           org_agenda_month_view = "<LocalLeader>qvm",
  --           org_agenda_year_view = "<LocalLeader>qvy",
  --           org_agenda_later = "f",
  --           org_agenda_earlier = "b",
  --           org_agenda_goto_today = "~",
  --           org_agenda_goto = { "<TAB>" },
  --           org_agenda_open_at_point = "<Leader>oe",
  --           org_agenda_goto_date = "<LocalLeader>qvD",
  --           org_agenda_switch_to = "<S-CR>",
  --           org_agenda_todo = "<LocalLeader>qst",
  --           org_agenda_set_effort = "<LocalLeader>qse",
  --           org_agenda_clock_in = "<LocalLeader>qsci",
  --           org_agenda_clock_out = "<LocalLeader>qsco",
  --           org_agenda_clock_goto = "<LocalLeader>qscg",
  --           org_agenda_clock_cancel = "<LocalLeader>qscc",
  --           org_agenda_clockreport_mode = "<LocalLeader>qscR", -- buat report clock
  --           org_agenda_priority = "<LocalLeader>qspP",
  --           org_agenda_priority_up = "g]",
  --           org_agenda_priority_down = "g[",
  --           org_agenda_archived = "<LocalLeader>qA",
  --           org_agenda_refile = "<LocalLeader>qR",
  --           org_agenda_add_note = "<LocalLeader>qsn",
  --           org_agenda_set_tags = "<LocalLeader>qsg",
  --           org_agenda_toggle_archive_tag = "<LocalLeader>qsG",
  --           org_agenda_deadline = "<LocalLeader>qsd",
  --           org_agenda_schedule = "<LocalLeader>qss",
  --           org_agenda_preview = "K",
  --           org_agenda_filter = "<LocalLeader>qf",
  --           org_agenda_redo = "R",
  --           org_agenda_quit = { "<Leader>bk", "<Leader><Tab>" },
  --           org_agenda_show_help = "g?",
  --         },
  --         capture = {
  --           org_capture_finalize = { "<CR>", "<C-s>" },
  --           org_capture_refile = "<Leader>bR",
  --           org_capture_kill = { "q", "<C-q>", "<Leader>bk", "<Leader><Tab>" },
  --           org_capture_show_help = "g?",
  --         },
  --         note = {
  --           org_note_finalize = { "<CR>", "<C-s>" },
  --           org_note_kill = { "q", "<C-q>", "<Leader>bk" },
  --         },
  --         org = {
  --           org_timestamp_up_day = "<Up>",
  --           org_timestamp_down_day = "<Down>",
  --           org_timestamp_up = "<C-PageUp>",
  --           org_timestamp_down = "<C-PageDown>",
  --           org_todo = "<LocalLeader>qst",
  --           org_todo_prev = "<LocalLeader>qsT",
  --           org_toggle_heading = "<LocalLeader>quh",
  --           org_next_visible_heading = "<a-n>",
  --           org_previous_visible_heading = "<a-p>",
  --           org_forward_heading_same_level = "]]",
  --           org_backward_heading_same_level = "[[",
  --           outline_up_heading = "g{",
  --           org_insert_heading_respect_content = "i<CR>",
  --           org_insert_todo_heading = "iT",
  --           org_insert_todo_heading_respect_content = "<C-t>",
  --           org_cycle = "zr",
  --           org_global_cycle = "ZR",
  --           org_clock_in = "<LocalLeader>qsci",
  --           org_clock_out = "<LocalLeader>qsco",
  --           org_clock_cancel = "<LocalLeader>qscc",
  --           org_clock_goto = "<LocalLeader>qscg",
  --           org_priority = "<LocalLeader>qspP",
  --           org_priority_up = "g]",
  --           org_priority_down = "g[",
  --           org_do_promote = "<S-Left>",
  --           org_do_demote = "<S-Right>",
  --           org_promote_subtree = "<C-Left>",
  --           org_demote_subtree = "<C-Right>",
  --           org_move_subtree_up = "<S-Up>",
  --           org_move_subtree_down = "<S-Down>",
  --           org_set_tags_command = "<LocalLeader>qsg",
  --           org_refile = "<LocalLeader>qR",
  --           org_insert_link = "<Leader>il",
  --           org_store_link = "<Leader>iL",
  --           org_time_stamp = "<Leader>it",
  --           org_time_stamp_inactive = "<Leader>id",
  --           org_toggle_timestamp_type = "<LocalLeader>qut",
  --           org_deadline = "<LocalLeader>qsd",
  --           org_schedule = "<LocalLeader>qss",
  --           org_set_effort = "<LocalLeader>qse",
  --           org_add_note = "<LocalLeader>qsn",
  --           org_export = "<LocalLeader>qx",
  --           org_babel_tangle = "bt",
  --           -- Gunanya buat edit contents dalam block code di beda buffer,
  --           -- cara: ini work ketika cursor berada di dalam block code
  --           org_edit_special = "<LocalLeader>qsE",
  --           org_archive_subtree = "<LocalLeader>qA",
  --           org_toggle_archive_tag = "<LocalLeader>qsG",
  --           org_toggle_checkbox = "<C-c>",
  --           org_open_at_point = { "<Leader>oe" },
  --           org_meta_return = "<s-CR>", -- Add heading, item or row (context-dependent)
  --           org_return = "<a-w>",
  --           org_show_help = "g?",
  --         },
  --       },
  --     }
  --   end,
  --   config = function(_, opts)
  --     local orgmode = require "orgmode"
  --     orgmode.setup(opts)
  --
  --     require("org-bullets").setup {
  --       concealcursor = true, -- If false then when the cursor is on a line underlying characters are visible
  --       symbols = {
  --         headlines = { "◉", "○", "✸", "✿" },
  --         checkboxes = {
  --           half = { "", "OrgTSCheckboxHalfChecked" },
  --           done = { "✓", "OrgDone" },
  --           todo = { "˟", "OrgTODO" },
  --         },
  --       },
  --     }
  --
  --     RUtils.map.augroup("OrgmodeReloads", {
  --       event = { "BufWritePost" },
  --       pattern = { "*.org" },
  --       command = function()
  --         local bufnr = vim.fn.bufnr "orgagenda" or -1
  --         if bufnr > -1 then
  --           RUtils.notes.setup_orgmode().agenda:redo()
  --         end
  --       end,
  --     })
  --   end,
  -- },
  -- -- org blink source
  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   dependencies = { "nvim-orgmode/orgmode", "saghen/blink.compat" },
  --   opts = {
  --     sources = {
  --       per_filetype = {
  --         org = { "buffer", "path", "orgmode", "snippets" },
  --       },
  --       providers = {
  --         orgmode = {
  --           name = "Orgmode",
  --           module = "orgmode.org.autocompletion.blink",
  --           fallbacks = { "buffer" },
  --         },
  --       },
  --     },
  --   },
  -- },
  -- -- ORG-SUPER-AGENDA
  -- {
  --   "hamidi-dev/org-super-agenda.nvim",
  --   ft = { "org" },
  --   keys = {
  --     {
  --       "<Localleader>aA",
  --       function()
  --         -- fix error "buffer name already exists"
  --         for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  --           if vim.api.nvim_buf_is_valid(buf) then
  --             local bufname = vim.fn.bufname(buf)
  --             if bufname == "Org Super Agenda" then
  --               vim.api.nvim_buf_delete(buf, { force = true })
  --             end
  --           end
  --         end
  --
  --         vim.cmd "OrgSuperAgenda"
  --       end,
  --       desc = "Note: open agenda orgmode [org-super-agenda]",
  --     },
  --   },
  --   opts = {
  --     org_files = { string.format("%s/orgmode/**/*", RUtils.config.path.wiki_path) },
  --     org_directories = { string.format("%s/orgmode", RUtils.config.path.wiki_path) },
  --
  --     -- TODO states + their quick filter keymaps and highlighting
  --     -- Optional: add `shortcut` field to override the default key (first letter)
  --     todo_states = {
  --       {
  --         name = "TODO",
  --         keymap = "ot",
  --         color = "#FF5555",
  --         strike_through = false,
  --         fields = { "filename", "todo", "headline", "priority", "date", "tags" },
  --       },
  --       {
  --         name = "PROGRESS",
  --         keymap = "op",
  --         color = "#FFAA00",
  --         strike_through = false,
  --         fields = { "filename", "todo", "headline", "priority", "date", "tags" },
  --       },
  --       {
  --         name = "WAITING",
  --         keymap = "ow",
  --         color = "#BD93F9",
  --         strike_through = false,
  --         fields = { "filename", "todo", "headline", "priority", "date", "tags" },
  --       },
  --       {
  --         name = "LEARNING",
  --         keymap = "ol",
  --         color = "#278dc8",
  --         strike_through = false,
  --         fields = { "filename", "todo", "headline", "priority", "date", "tags" },
  --       },
  --       {
  --         name = "DONE",
  --         keymap = "od",
  --         color = "#50FA7B",
  --         strike_through = true,
  --         fields = { "filename", "todo", "headline", "priority", "date", "tags" },
  --       },
  --     },
  --
  --     -- Agenda keymaps (inline comments explain each)
  --     keymaps = {
  --       filter_reset = "<Leader>sR", -- reset all filters
  --       toggle_other = "<Leader>qvo", -- toggle catch-all "Other" section
  --       filter = "<LocalLeader>qf", -- live filter (exact text)
  --       filter_fuzzy = "<LocalLeader>qF", -- live filter (fuzzy)
  --       filter_query = "<LocalLeader>qQ", -- advanced query input
  --       undo = "u", -- undo last change
  --       reschedule = "<Leader>qss", -- set/change SCHEDULED
  --       set_deadline = "<Leader>qsd", -- set/change DEADLINE
  --       cycle_todo = "t", -- cycle TODO state
  --       set_state = "<Leader>qst", -- set state directly (st, sd, etc.) or show menu
  --       reload = "<Leader>R", -- refresh agenda
  --       refile = "<Leader>qR", -- refile via Telescope/org-telescope
  --       hide_item = "x", -- hide current item
  --       preview = "P", -- preview headline content
  --       reset_hidden = "X", -- clear hidden list
  --       toggle_duplicates = "D", -- duplicate items may appear in multiple groups
  --       cycle_view = "<LocalLeader>qvv", -- switch view (classic/compact)
  --     },
  --
  --     -- Window/appearance
  --     window = {
  --       width = 0.8,
  --       height = 0.7,
  --       border = "rounded",
  --       title = "Org Super Agenda",
  --       title_pos = "center",
  --       margin_left = 0,
  --       margin_right = 0,
  --       fullscreen_border = "none", -- border style when using fullscreen
  --     },
  --
  --     -- Group definitions (order matters; first match wins unless allow_duplicates=true)
  --     groups = {
  --       {
  --         name = "📅 Today",
  --         matcher = function(i)
  --           return i.scheduled and i.scheduled:is_today() and not i:has_tag "personal" and i.todo_state ~= "DONE"
  --         end,
  --         sort = { by = "priority", order = "desc" },
  --       },
  --       {
  --         name = "☠️ Deadlines",
  --         matcher = function(i)
  --           return i.deadline and i.todo_state ~= "DONE" and not i:has_tag "personal"
  --         end,
  --         sort = { by = "deadline", order = "asc" },
  --       },
  --       {
  --         name = "⭐ Important",
  --         matcher = function(i)
  --           return i.priority == "A" and (i.deadline or i.scheduled) and i.todo_state ~= "DONE"
  --         end,
  --         sort = { by = "date_nearest", order = "asc" },
  --       },
  --       {
  --         name = "🕒 Tomorrow",
  --         matcher = function(i)
  --           return i.scheduled and i.scheduled:days_from_today() == 1 and not i:has_tag "personal"
  --         end,
  --       },
  --       {
  --         name = "⏳ Overdue",
  --         matcher = function(i)
  --           return i.todo_state ~= "DONE"
  --             and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
  --             and not i:has_tag "personal"
  --         end,
  --         sort = { by = "date_nearest", order = "asc" },
  --       },
  --       {
  --         name = "🏠 Habit & Workout Today",
  --         matcher = function(i)
  --           return i.scheduled and i.scheduled:is_today() and i:has_tag "personal" and i.todo_state ~= "DONE"
  --         end,
  --         sort = { by = "priority", order = "desc" },
  --       },
  --       {
  --         name = "⏳ Overdue Habit & Workout",
  --         matcher = function(i)
  --           return i.todo_state ~= "DONE"
  --             and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
  --             and i:has_tag "personal"
  --         end,
  --         sort = { by = "date_nearest", order = "asc" },
  --       },
  --       {
  --         name = "💼 Work",
  --         matcher = function(i)
  --           return i:has_tag "work"
  --         end,
  --       },
  --       {
  --         name = "🔧 Fix",
  --         matcher = function(i)
  --           return i:has_tag "error"
  --         end,
  --       },
  --       {
  --         name = "📆 Upcoming",
  --         matcher = function(i)
  --           local days = require("org-super-agenda.config").get().upcoming_days or 10
  --           local d1 = i.deadline and i.deadline:days_from_today()
  --           local d2 = i.scheduled and i.scheduled:days_from_today()
  --           return (d1 and d1 >= 0 and d1 <= days)
  --             or (d2 and d2 >= 0 and d2 <= days) and not i:has_tag "personal" and i.todo_state ~= "DONE"
  --         end,
  --         sort = { by = "date_nearest", order = "asc" },
  --       },
  --     },
  --
  --     -- Defaults & behavior
  --     upcoming_days = 10,
  --     hide_empty_groups = true, -- drop blank sections
  --     keep_order = false, -- keep original org order (rarely useful)
  --     allow_duplicates = false, -- if true, an item can live in multiple groups
  --     group_format = "* %s", -- group header format
  --     other_group_name = "Other",
  --     show_other_group = false, -- show catch-all section
  --     show_tags = true, -- draw tags on the right
  --     show_filename = true, -- include [filename]
  --     heading_max_length = 70,
  --     persist_hidden = false, -- keep hidden items across reopen
  --     view_mode = "classic", -- 'classic' | 'compact'
  --
  --     classic = {
  --       heading_order = { "filename", "todo", "priority", "headline" },
  --       short_date_labels = false,
  --       inline_dates = true,
  --     },
  --     compact = { filename_min_width = 10, label_min_width = 12 },
  --
  --     -- Global fallback sort for groups that omit `sort`
  --     group_sort = { by = "date_nearest", order = "asc" },
  --
  --     -- Popup mode: run in a persistent tmux session for instant access
  --     popup_mode = {
  --       enabled = false,
  --       hide_command = nil, -- e.g., "tmux detach-client"
  --     },
  --
  --     debug = false,
  --   },
  -- },
  -- OBSIDIAN.NVIM (disabled)
  {
    "obsidian-nvim/obsidian.nvim",
    enabled = false,
    version = "*", -- recommended, use latest release instead of latest commit
    cmd = "Obsidian",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
    opts = {
      dir = RUtils.config.path.wiki_path, -- no need to call 'vim.fn.expand' here
      legacy_commands = false,
      link = { style = "markdown" },
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
      picker = {
        name = "fzf-lua",
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
      frontmatter = {
        func = function(note)
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
      },
      -- note_frontmatter_func = function(note) end,
      ui = {
        enable = false, -- set to false to disable all additional syntax features
      },
      -- follow_url_func = function(url)
      --   vim.fn.jobstart { "open", url }
      -- end,
      footer = {
        enabled = false,
        format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
        hl_group = "Comment",
        separator = string.rep("-", 80),
      },
    },

    config = function(_, opts)
      require("obsidian").setup(opts)
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
  -- SNIPRUN (disabled)
  {
    "michaelb/sniprun",
    enabled = false,
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
