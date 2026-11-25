local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy
local UtilKey = lazy "utils.map"
local UtilPopup = lazy "utils.popup"

add {
  {
    src = "CoreyKaylor/diffbandit.nvim",
    lazy = true,
    opts = function()
      -- local H = lazy "utils.highlights"
      -- H.plugin("DiffviewHiCol", {
      --   theme = {
      --     ["*"] = {
      --       { DiffBanditAdd = { inherit = "diffAdded", fg = "NONE" } },
      --       { DiffBanditSignAdd = { inherit = "DiffBanditAdd" } },
      --       { DiffBanditConnectorAdd = { inherit = "DiffBanditAdd" } },
      --
      --       { DiffBanditSignChange = { inherit = "diffChanged", fg = "NONE" } },
      --       { DiffBanditChangeLeft = { inherit = "DiffBanditSignChange" } },
      --       { DiffBanditChangeRight = { inherit = "DiffBanditSignChange" } },
      --       { DiffBanditConnectorChange = { inherit = "DiffBanditSignChange" } },
      --       { DiffBanditLineNumberRightChange = { inherit = "DiffBanditSignChange" } },
      --       { DiffBanditLineNumberLeftChange = { inherit = "DiffBanditSignChange" } },
      --
      --       { DiffBanditChangeEmphasis = { inherit = "DiffText" } },
      --       --
      --       -- { DiffBanditDelete = { inherit = "diffRemoved" } },
      --       -- { DiffBanditConnectorDelete = { inherit = "diffRemoved" } },
      --     },
      --   },
      -- })
      return {
        git = {
          file_keys = {
            next = "gn",
            prev = "gp",
          },
          panel = {
            staged_indicator = {
              unstaged = "□",
              partial = "◧",
              staged = "▣",
            },
            keys = {
              toggle_stage = "<Leader>gs",
              focus_diff = "<CR>",
              focus_panel = "<Leader>op",
              focus_commit = "cc",
              file_actions = "<Leader>ca",
              toggle_amend = "<Leader>gA",
              refresh = "<C-x>R",
              toggle_panel = "<Leader>oo",
              close = "<Leader>bk",
            },
          },
        },
        folder = {
          keys = {
            open = "<CR>",
            alternate_open = "o",
            toggle_expand = "<TAB>",
            alternate_toggle_expand = "za",
            expand_all = "zR",
            collapse_all = "zM",
            next_diff = "<C-n>",
            prev_diff = "<C-p",
            refresh = "<C-x>R",
            filter = "<C-x>F",
            -- close = { "q", "<Leader>bk" },
            close = "<Leader>bk",
          },
        },
        actions = {
          keys = {
            toggle_stage = "<Leader>gs",
            apply_left = ">>",
            apply_right = "<<",
            undo = "<Leader>gr",
          },
        },
        merge = {
          keys = {
            next_conflict = "<C-x><C-n>",
            prev_conflict = "<C-x><C-p>",
            accept_local = "<C-x>c1",
            accept_remote = "<C-x>c3",
            accept_both = "<C-x>c2",
            apply_non_conflicting = "gA",
            focus_panel = "<Leader>op",
            snap = "]s",
            toggle_panel = "<Leader>oo",
            toggle_local = "gzh",
            toggle_remote = "gzl",
            show_all = "gza",
            -- close = { "q", "<Leader>bk" },
            close = "<Leader>bk",
          },
        },
      }
    end,
  },
}

local load_diffbandit = function()
  lazy("vim-pack").load_now "diffbandit.nvim"
end

local jc = {}

UtilKey.nnoremap("<Leader>gdB", function()
  load_diffbandit()
  local cmds = table.concat(jc, " ")
  vim.cmd("DiffBanditBuffers " .. cmds)
  UtilPopup.close()
  jc = {}
end, { desc = "Git: compare buffers [diffbandit]" })

UtilKey.nnoremap("<Leader>gdb", function()
  load_diffbandit()

  local buf = vim.api.nvim_get_current_buf()
  UtilPopup.open("float", { "current " .. buf })
  jc[#jc + 1] = buf
end, { desc = "Git: asdf [diffbandit]" })

UtilKey.nnoremap("<Leader>gdl", function()
  load_diffbandit()
  vim.cmd.DiffBanditGitLog()
end, { desc = "Git: open log [diffbandit]" })

UtilKey.nnoremap("<Leader>gdo", function()
  load_diffbandit()
  vim.cmd.DiffBanditGit()
end, { desc = "Git: open git [diffbandit]" })
