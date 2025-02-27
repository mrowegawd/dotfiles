local Highlight = require "r.settings.highlights"

return {
  -- QUICKER
  { -- bisa delete range, jangan lupa di 'write' setelah delete range
    "stevearc/quicker.nvim",
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = function()
      Highlight.plugin("Quickerui", {
        { QuickFixLineNr = { fg = { from = "LineNr", attr = "fg", alter = 0.3 } } },
      })
      return {
        borders = {
          vert = "│",
        },
      }
    end,
  },
  -- QFSILET
  {
    dir = "~/.local/src/nvim_plugins/qfsilet",
    -- event = "FileType qf",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      save_dir = RUtils.config.path.wiki_path .. "/orgmode/project-todo",
      extmarks = {
        qf_sigil = RUtils.config.icons.misc.marks,
        qf_sign_hl = { fg = "red" },
      },
      popup = {
        title_local = "TODO LIST",
        title_global = "MESSAGE BOX",
        higroup_title = "FzfLuaPreviewTitle",
      },
      marks = {
        excluded = {
          buftypes = {},
          filetypes = {
            "DiffviewFiles",
            "NeogitCommitMessage",
            "NeogitPopup",
            "NeogitStatus",
            "NvimTree",
            "Outline",
            "TelescopePrompt",
            "TelescopeResults",
            "alpha",
            "calendar",
            "checkhealth",
            "dashboard",
            "fugitive",
            "fzf",
            "gitcommit",
            "help",
            "lazy",
            "lspinfo",
            "man",
            "mason",
            "neo-tree",
            "orgagenda",
            "sagafinder",
            "trouble",
          },
        },
      },
      keymap = {
        todo = {
          add_todo = "mt",
        },
        marks = {
          next_mark = "<Leader>wn",
          prev_mark = "<Leader>wp",
        },
      },
    },
  },
}
