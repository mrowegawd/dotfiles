local add_on_event = require("vim-pack").add_on_event

local UtilKey = require "utils.map"

add_on_event({ "UIEnter" }, {
  {
    src = "dlyongemallo/diffview.nvim",
    lazy = true,
    opts = function()
      local actions = require "diffview.actions"

      local H = require "utils.highlights"
      H.plugin("DiffviewHiCol", {
        theme = {
          ["*"] = {
            { DiffviewDiffAdd = { inherit = "diffAdded" } },
            { DiffviewDiffChange = { inherit = "diffChanged" } },
            { DiffViewDiffDelete = { inherit = "diffRemoved" } },

            { DiffviewDiffText = { inherit = "DiffText" } },

            { DiffviewStatusAdded = { inherit = "GitSignsAdd", bg = "NONE" } },
            { DiffviewStatusModified = { inherit = "GitSignsChange", bg = "NONE" } },
            { DiffviewStatusRenamed = { inherit = "GitSignsDelete", bg = "NONE" } },
            { DiffviewStatusUnmerged = { inherit = "GitSignsDelete", bg = "NONE" } },
            { DiffviewStatusUntracked = { inherit = "GitSignsAdd", bg = "NONE" } },
            { DiffviewStatusDeleted = { inherit = "GitSignsDelete", bg = "NONE" } },

            { DiffviewHash = { fg = { from = "diffAdded", attr = "fg" } } },
            { DiffviewNonText = { fg = { from = "WinSeparator", attr = "fg", alter = 0.1 } } },

            { DiffviewFilePanelCounter = { fg = { from = "Directory", attr = "fg", alter = -0.3 } } },
            { DiffviewFilePanelDeletions = { inherit = "DiffviewStatusDeleted" } },
            { DiffviewFilePanelInsertions = { inherit = "DiffviewStatusAdded" } },

            -- NOTE: DiffviewDiffAddAsDelete gives the left panel (old version) a red
            -- tint even when the underlying git status is "added". This makes it clear
            -- that the content is absent in the old version without using diffRemoved
            -- directly (which would make the two indistinguishable).
            {
              DiffviewDiffAddAsDelete = {
                fg = {
                  from = "diffRemoved",
                  attr = "fg",
                  alter = 0.5,
                },
                bg = {
                  from = "diffRemoved",
                  attr = "fg",
                  alter = 0.1,
                  transparency = 0.3,
                  color = { from = "Normal", attr = "bg" },
                },
              },
            },

            {
              DiffviewFilePanelPath = {
                inherit = "String",
                fg = { from = "String", attr = "fg", transparency = 0.7, color = { from = "Directory", attr = "fg" } },
              },
            },
            { DiffviewFilePanelFileName = { fg = { from = "DiffviewFilePanelPath", attr = "fg", alter = 0.2 } } },

            {
              DiffviewReference = {
                inherit = "diffRemoved",
                fg = { from = "GitSignsDelete", attr = "fg", alter = 0.1 },
                bold = true,
              },
            },

            {
              DiffviewFilePanelSelected = {
                inherit = "Type",
                fg = { from = "Type", attr = "fg", alter = 0.15 },
                -- opacity: blend toward Normal.bg at 15% source visibility
                bg = { from = "Type", attr = "fg", opacity = 0.15 },
              },
            },
          },
        },
      })

      return {
        enhanced_diff_hl = true,
        diff_binaries = false, -- Show diffs for binaries
        hooks = {
          ---@diagnostic disable-next-line: unused-local
          diff_buf_win_enter = function(bufnr, winid, ctx)
            -- Turn off cursor line for diffview windows because of bg conflict
            -- https://github.com/neovim/neovim/issues/9800
            vim.wo[winid].culopt = "number"

            -- clear the lsp autocmd that highlights the word under the cursor
            pcall(vim.api.nvim_clear_autocmds, {
              group = "kickstart-lsp-highlight",
              buffer = bufnr,
            })

            -- turn off gitsigns inline diff
            ---@diagnostic disable-next-line: param-type-mismatch
            pcall(vim.cmd, "Gitsigns toggle_linehl false")
            ---@diagnostic disable-next-line: param-type-mismatch
            pcall(vim.cmd, "Gitsigns toggle_word_diff false")

            -- clear highlights
            vim.cmd "nohl"

            -- HACK: turn off inlay hints, but diffview is triggering the lsp
            -- to renable them even if they were off (re-editing the buffer?)
            -- add a 100ms delay to make sure they're off. gross.
            vim.defer_fn(function()
              local wins = vim.api.nvim_tabpage_list_wins(0)
              for _, win in ipairs(wins) do
                local buf = vim.api.nvim_win_get_buf(win)
                vim.lsp.inlay_hint.enable(false, { bufnr = buf })
              end
            end, 500)
          end,
        },
        view = {
          default = { disable_diagnostics = true },
          file_history = { disable_diagnostics = true },
        },
        key_bindings = {
          disable_defaults = true, -- Disable the default key bindings
          --stylua: ignore
          view = {
            { "n", "gn", actions.select_next_entry, { desc = "Git: open the diff for the next file [diffview-view]" }, },
            { "n", "gp", actions.select_prev_entry, { desc = "Git: open the diff for the previous filet[diffview-view]" } },

            { "n", "[F", actions.select_first_entry, { desc = "Git: open the diff for the first file [diffview-view]" } },
            { "n", "]F", actions.select_last_entry, { desc = "Git: open the diff for the last file [diffview-view]" } },

            { "n", "h", false },

            --  ─────────────────────────────[ EDIT FILE ]─────────────────────────────
            { "n", "<Leader>oe", actions.goto_file_edit, { desc = "Git: open in prev tab [diffview-view]" } },
            { "n", "<Leader>os", actions.goto_file_split, { desc = "Git: open in split [diffview-view]" } },
            { "n", "<Leader>ot", actions.goto_file_tab, { desc = "Git: open in newtab [diffview-view]" } },

            { "n", "<Leader>oo", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-view]" } },
            { "n", "<Leader>oO", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-view]" } },

            --  ───────────────────────────[ GIT CONFLICT ]────────────────────────
            { "n", "<S-Down>", actions.next_conflict, { desc = "Git: next conflict [diffview-view]" } },
            { "n", "<S-Up>", actions.prev_conflict, { desc = "Git: prev conflict [diffview-view]" } },

            { "n", "<a-1>", actions.conflict_choose "ours", { desc = "Git: choose OURS conflict [diffview-view]" } },
            { "n", "<a-3>", actions.conflict_choose "theirs", { desc = "Git: choose THEIRS conflict [diffview-view]" }, },
            { "n", "<a-0>", actions.conflict_choose "base", { desc = "Git: choose BASE (kosong) conflict [diffview-view]" } },
            { "n", "<a-2>", actions.conflict_choose "all", { desc = "Git: choose BOTH conflict [diffview-view]" } },

            { "n", "<LocalLeader>qcN", actions.conflict_choose "none", { desc = "Git: delete region conflict [diffview-view]" } },
            { "n", "<LocalLeader>qcA", actions.conflict_choose_all "none", { desc = "Git: delete all region conflict [diffview-view]" }, },

            --  ───────────────────────────────[ MISC ]────────────────────────────
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle through available layouts [diffview-view]" } },
          },
          --stylua: ignore
          file_panel = {
            { "n", "j", actions.next_entry, { desc = "Git: cursor down [diffview-panel]" }, },
            { "n", "k", actions.prev_entry, { desc = "Git: cursor up [diffview-panel]" }, },

            { "n", "<down>", actions.next_entry, { desc = "Git: cursor down (alternative) [diffview-panel]" }, },
            { "n", "<up>", actions.prev_entry, { desc = "Git: cursor up (alternative) [diffview-panel]" }, },

            { "n", "o", actions.select_entry, { desc = "Git: open entry [diffview-panel]" }, },
            { "n", "<CR>", actions.select_entry, { desc = "Git: open entry (alternative) [diffview-panel]" }, },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Git: open entry (alternative-back) [diffview-panel]" }, },

            { "n", "h", false },

            --  ──────────────────[ STAGE, UNSTAGE, COMMIT MESSAGE ]───────────────
            { "n", "s", actions.toggle_stage_entry, { desc = "Git: stage / unstage [diffview-panel]" }, },
            { "n", "u", actions.toggle_stage_entry, { desc = "Git: stage / unstage [diffview-panel]" }, },
            { "n", "cc", "<Cmd>Git commit <bar> wincmd J<CR>", { desc = "Git: commit message [diffview-panel]" }, },
            { "n", "ca", "<Cmd>Git commit --amend <bar> wincmd J<CR>", { desc = "Git: amend the last commit with fugitive [diffview-panel]" }, },

            { "n", "P", actions.open_commit_log, { desc = "Git: preview commit detail [diffview-panel]" } },

            --  ──────────────────────────────[ SCROLL ]───────────────────────────
            { "n", "<PageUp>", actions.scroll_view(-0.25), { desc = "Git: scroll view up [diffview-panel]" } },
            { "n", "<PageDown>", actions.scroll_view(0.25), { desc = "Git: scroll view down [diffview-panel]" } },

            { "n", "<a-n>", actions.select_next_entry, { desc = "Git: next select entry [diffview-panel]" }, },
            { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-panel]" }, },
            { "n", "gn", actions.select_next_entry, { desc = "Git: next select entry [diffview-panel]" }, },
            { "n", "gp", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-panel]" }, },

            { "n", "gg", false },
            { "n", "G", false},

            --  ─────────────────────────────[ EDIT FILE ]─────────────────────────────
            { "n", "<Leader>oe", actions.goto_file_edit, { desc = "Git: open in prev tab [diffview-panel]" }, },
            { "n", "<Leader>os", actions.goto_file_split, { desc = "Git: open in split [diffview-panel]" }, },
            { "n", "<Leader>ot", actions.goto_file_tab, { desc = "Git: open in newtab [diffview-panel]" }, },

            { "n", "R", actions.refresh_files, { desc = "Git: update stats and entries in the file list [diffview-panel]" }, },

            --  ──────────────────[ OPEN FILE MANAGER FOR DIFFVIEW ]───────────────
            { "n", "<Leader>oo", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-panel]" }, },
            { "n", "<Leader>oO", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-panel]" } },

            --  ───────────────────────────────[ FOLD ]────────────────────────────
            { "n", "<C-a>", actions.toggle_fold, { desc = "Git: toggle fold [diffview-panel]" } },
            { "n", "za", actions.toggle_fold, { desc = "Git: toggle fold (alternative) [diffview-panel]" } },
            { "n", "<tab>", actions.toggle_fold, { desc = "Git: toggle fold (alternative-back) [diffview-panel]" } },

            { "n", "zo", actions.open_fold, { desc = "Git: expand fold [diffview-panel]" } },

            { "n", "zR", actions.open_all_folds, { desc = "Git: open all folds [diffview-panel]" } },
            { "n", "zO", actions.open_all_folds, { desc = "Git: open all folds (alternative) [diffview-panel]" } },

            { "n", "zm", actions.close_all_folds, { desc = "Git: close all folds [diffview-panel]" } },
            { "n", "zc", actions.close_all_folds, { desc = "Git: close all folds (alternative) [diffview-panel]" } },
            { "n", "<s-tab>", actions.close_all_folds, { desc = "Git: close all folds (alternative-back) [diffview-panel]" }, },

            --  ───────────────────────────[ GIT CONFLICT ]────────────────────────
            { "n", "<S-Down>", actions.next_conflict, { desc = "Git: next git conflict [diffview-panel]" } },
            { "n", "<S-Up>", actions.prev_conflict, { desc = "Git: prev git conflict [diffview-panel]" } },

            { "n", "<a-1>", actions.conflict_choose_all "ours", { desc = "Git: choose ALL OURS conflict [diffview-panel]" }, },
            { "n", "<a-3>", actions.conflict_choose_all "theirs", { desc = "Git: choose ALL THEIRS conflict [diffview-panel]" }, },
            { "n", "<a-0>", actions.conflict_choose_all "base", { desc = "Git: choose ALL BASE conflict [diffview-panel]" }, },
            { "n", "<a-2>", actions.conflict_choose_all "all", { desc = "Git: choose ALL BOTH conflict [diffview-panel]" }, },

            { "n", "<LocalLeader>qcD", actions.conflict_choose_all "none", { desc = "Git: delete all region conflict [diffview-panel]" }, },

            --  ───────────────────────────────[ MISC ]────────────────────────────
            { "n", "g?", actions.help "file_panel", { desc = "Git: open the help panel [diffview-panel]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle available layouts [diffview-panel]" } },
            { "n", "i", actions.listing_style, { desc = "Git: toggle between 'list' and 'tree' views [diffview-panel]" }, },
          },
          --stylua: ignore
          file_history_panel = {
            { "n", "j", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview-history]" }, },
            { "n", "<down>", actions.next_entry, { desc = "Git: bring the cursor to the next file entry [diffview-history]" }, },

            { "n", "<up>", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview-history]" }, },
            { "n", "k", actions.prev_entry, { desc = "Git: bring the cursor to the previous file entry [diffview-history]" }, },

            { "n", "o", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },
            { "n", "<CR>", actions.select_entry, { desc = "Git: open the diff for the selected entry [diffview-history]" }, },

            { "n", "h", false },

            { "n", "<Leader>goo", actions.open_in_diffview, { desc = "Git: open the entry under the cursor in a diffview [diffview-history]" }, },
            { "n", "<Leader>gy", actions.copy_hash, { desc = "Git: copy the commit hash of the entry under the cursor [diffview-history]" }, },
            { "n", "P", actions.open_commit_log, { desc = "Git: show or preview commit details [diffview-history]" } },

            { "n", "X", actions.restore_entry, { desc = "Git: restore file to the state from the selected entry [diffview-history]" }, },

            --  ───────────────────────────────[ FOLD ]────────────────────────────
            { "n", "<C-a>", actions.toggle_fold, { desc = "Git: toggle fold [diffview-history]" } },
            { "n", "za", actions.toggle_fold, { desc = "Git: toggle fold (alternative) [diffview-history]" } },
            { "n", "<tab>", actions.toggle_fold, { desc = "Git: toggle fold (alternative-back) [diffview-history]" } },

            { "n", "zc", actions.close_all_folds, { desc = "Git: close all folds [diffview-history]" } },
            { "n", "zm", actions.close_all_folds, { desc = "Git: close all folds (alternative) [diffview-history]" } },
            { "n", "<s-tab>", actions.close_all_folds, { desc = "Git: close all folds (alternative-back) [diffview-history]" }, },

            { "n", "zR", actions.open_all_folds, { desc = "Git: open all folds [diffview-history]" } },
            { "n", "zO", actions.open_all_folds, { desc = "Git: open all folds (alternative) [diffview-history]" } },

            --  ──────────────────────────────[ SCROLL ]───────────────────────────
            { "n", "<PageUp>", actions.scroll_view(-0.25), { desc = "Git: scroll view up [diffview-history]" } },
            { "n", "<PageDown>", actions.scroll_view(0.25), { desc = "Git: scroll view down [diffview-history]" } },

            { "n", "<a-n>", actions.select_next_entry, { desc = "Git: next select entry [diffview-history]" } },
            { "n", "<a-p>", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-history]" }, },
            { "n", "gn", actions.select_next_entry, { desc = "Git: next select entry [diffview-history]" } },
            { "n", "gp", actions.select_prev_entry, { desc = "Git: prev select entry [diffview-history]" }, },


            { "n", "gg", false },
            { "n", "G", false},

            --  ─────────────────────────────[ EDIT FILE ]─────────────────────────────
            { "n", "<Leader>oe", actions.goto_file_edit, { desc = "Git: open in prev tab [diffview-history]" }, },
            { "n", "<Leader>os", actions.goto_file_split, { desc = "Git: open in split [diffview-view]" } },
            { "n", "<Leader>ot", actions.goto_file_tab, { desc = "Git: open in newtab [diffview-history]" } },

            --  ──────────────────[ OPEN FILE MANAGER FOR DIFFVIEW ]───────────────
            { "n", "<Leader>oo", actions.focus_files, { desc = "Git: bring focus to the file panel [diffview-history]" } },
            { "n", "<Leader>oO", actions.toggle_files, { desc = "Git: toggle the file panel [diffview-history]" } },

            --  ───────────────────────────────[ MISC ]────────────────────────────
            { "n", "g?", actions.help "file_history_panel", { desc = "Git: open the help panel [diffview-history]" } },
            { "n", "g!", actions.options, { desc = "Git: open the option panel [diffview-history]" } },
            { "n", "<F4>", actions.cycle_layout, { desc = "Git: cycle available layouts [diffview-history]" } },
          },
        },
      }
    end,
    on_setup = function()
      UtilKey.disable_ctrl_i_and_o("NoDiffview", { "DiffviewFiles", "DiffviewFileHistory" })

      UtilKey.nnoremap("<Leader>goo", function()
        vim.cmd.DiffviewOpen()
      end, { desc = "Git: DiffviewOpen [diffview]" })

      UtilKey.nnoremap("<Leader>goh", function()
        vim.cmd.DiffviewFileHistory()
      end, { desc = "Git: DiffviewFileHistory repo [diffview]" })

      UtilKey.xnoremap("<Leader>gl", function()
        local function exit_visual_mode()
          -- Exit visual mode, otherwise `getpos` will return postion of the last visual selection
          local ESC_FEEDKEY = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
          vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)
          vim.api.nvim_feedkeys("gv", "x", false)
          vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)
        end

        local function get_visual_selection_info()
          exit_visual_mode()

          local _, start_row, start_col, _ = unpack(vim.fn.getpos "'<")
          local _, end_row, end_col, _ = unpack(vim.fn.getpos "'>")
          start_row = start_row - 1
          end_row = end_row - 1

          return {
            start_row = start_row,
            start_col = start_col,
            end_row = end_row,
            end_col = end_col,
          }
        end

        local v = get_visual_selection_info()
        local file = vim.fn.expand "%"
        -- DiffviewFileHistory --follow -L{range_start},{range_end}:{file}
        local str_cmds = string.format("DiffviewFileHistory --follow -L%s,%s:%s", v.start_row + 1, v.end_row + 1, file)
        vim.cmd(str_cmds)
      end, { desc = "Git: DiffviewFileHistory line (visual) [diffview]" })
    end,
  },
})
