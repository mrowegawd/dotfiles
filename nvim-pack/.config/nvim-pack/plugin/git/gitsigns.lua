local add_on_event = require("vim-pack").add_on_event

local solid_bar = require("icons").misc.vertical_bar
local dashed_bar = require("icons").misc.dashed_bar

local UtilWindow = require "utils.window"

-- Adds git related signs to the gutter, as well as utilities for managing changes.
add_on_event({ "BufReadPost", "BufNewFile" }, {
  {
    src = "lewis6991/gitsigns.nvim",
    opts = function()
      return {
        signs = {
          add = { text = solid_bar },
          untracked = { text = solid_bar },
          change = { text = solid_bar },
          delete = { text = solid_bar },
          topdelete = { text = solid_bar },
          changedelete = { text = solid_bar },
        },
        signs_staged = {
          add = { text = dashed_bar },
          untracked = { text = dashed_bar },
          chane = { text = dashed_bar },
          delete = { text = dashed_bar },
          topdelete = { text = dashed_bar },
          changedelete = { text = dashed_bar },
        },
        preview_config = { border = "rounded" },
        current_line_blame = true,
        gh = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc, silent = true })
          end

          -- Hunk
          map("n", "<Leader>gs", gs.stage_hunk, "Git: stage [gitsigns]")
          map("x", "<Leader>gs", function()
            local from, to = vim.fn.line ".", vim.fn.line "v"
            if from > to then
              from, to = to, from
            end
            gs.stage_hunk { from, to }
          end, "Git: stage (visual) [gitsigns]")
          map("n", "<Leader>gr", gs.reset_hunk, "Git: reset [gitsigns]")
          map("x", "<Leader>gr", function()
            local from, to = vim.fn.line ".", vim.fn.line "v"
            if from > to then
              from, to = to, from
            end
            gs.reset_hunk { from, to }
          end, "Git: reset (visual) [gitsigns]")
          map("n", "<Leader>gu", gs.undo_stage_hunk, "Git: undo [gitsigns]")
          map("n", "<Leader>gS", gs.stage_buffer, "Git: stage buffer [gitsigns]")
          map("n", "<Leader>gR", gs.reset_buffer, "Git: reset buffer [gitsigns]")

          map("n", "<Leader>gb", gs.blame_line, "Git: blame line [gitsigns]")
          map("n", "<Leader>gB", gs.blame, "Git: blame [gitsigns]")

          -- Hunk preview
          map("n", "<Leader>gp", gs.preview_hunk_inline, "Git: preview hunk inline [gitsigns]")
          map("x", "<Leader>gp", gs.preview_hunk_inline, "Git: preview hunk inline [gitsigns]")
          map("n", "<Leader>gP", gs.preview_hunk, "Git: preview hunk infloat [gitsigns]")
          map("x", "<Leader>gP", gs.preview_hunk, "Git: preview hunk infloat [gitsigns]")

          vim.api.nvim_create_user_command("GitToggleDelete", function()
            gs.toggle_deleted()
          end, { desc = "Git: toggle diff changes [gitsigns]" })
          vim.api.nvim_create_user_command("GitToggleWordDiff", function()
            gs.toggle_word_diff()
          end, { desc = "Git: toggle word diff [gitsigns]" })
          vim.api.nvim_create_user_command("GitToggleLineHl", function()
            gs.toggle_linehl()
          end, { desc = "Git: toggle linehl [gitsigns]" })

          local function auto_close_trouble_win()
            local trouble_win = UtilWindow.windows_is_opened "trouble"
            vim.schedule(function()
              if trouble_win.found then
                vim.api.nvim_set_current_win(trouble_win.winid)
              end
            end)
          end

          map("n", "<Leader>xG", function()
            gs.setqflist "all"
            auto_close_trouble_win()
          end, "Exec: collect all git hunks in trouble (qf) [gitsigns] [trouble]")
          map("n", "<Leader>xg", function()
            gs.setqflist()
            auto_close_trouble_win()
          end, "Exec: collect git hunks curbuf in trouble (qf) [gitsigns] [trouble]")
        end,
      }
    end,
  },
})
