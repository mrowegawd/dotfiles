local add_local_or_remote = require("vim-pack").add_local_or_remote

local UtilKey = require "utils.map"
local UtilWindow = require "utils.window"
local IconsLSP = require("icons").kinds

local function auto_close_qf_win()
  local qf_win = UtilWindow.windows_is_opened "qf"
  if qf_win.found then
    vim.cmd [[cclose]]
  end
end

add_local_or_remote {
  {
    src = "nvim_plugins/trouble.nvim",
    lazy = true,
    opts = {
      focus = true,
      auto_refresh = false, -- use `R` to refresh it
      win = { position = "bottom", relative = "win" },
      preview = {
        type = "main",
        scratch = false,
      },
      icons = {
        kinds = {
          Array = IconsLSP.Array,
          Boolean = IconsLSP.Boolean,
          Class = IconsLSP.Classs,
          Constant = IconsLSP.Constant,
          Constructor = IconsLSP.Constructor,
          Enum = IconsLSP.Enum,
          EnumMember = IconsLSP.EnumMember,
          Event = IconsLSP.Event,
          Field = IconsLSP.Field,
          File = IconsLSP.File,
          Function = IconsLSP.Function,
          Interface = IconsLSP.Interface,
          Key = IconsLSP.Interface,
          Method = IconsLSP.Key,
          Module = IconsLSP.Method,
          Namespace = IconsLSP.Namespace,
          Null = IconsLSP.Null,
          Number = IconsLSP.Number,
          Object = IconsLSP.Object,
          Operator = IconsLSP.Operator,
          Package = IconsLSP.Package,
          Property = IconsLSP.Property,
          String = IconsLSP.String,
          Struct = IconsLSP.Struct,
          TypeParameter = IconsLSP.TypeParameter,
          Variable = IconsLSP.Variable,
        },
      },
      keys = {
        ["<esc>"] = "cancel",

        q = "close",
        ["<Leader>bk"] = "close",

        r = "refresh",
        R = "toggle_refresh",

        ["<c-s>"] = "jump_split_aboveleft_close",
        -- ["<c-v>"] = "jump_vsplit",

        o = "jump",

        P = "toggle_preview",

        ["<C-a>"] = "fold_toggle",
        ["<TAB>"] = "fold_toggle",

        ["<a-n>"] = "next",
        ["<c-n>"] = "next",
        ["<a-p>"] = "prev",
        ["<c-p>"] = "prev",
      },
    },
  },
}

local load_trouble = function()
  require("vim-pack").load_now "trouble.nvim"
end

UtilKey.nnoremap("<Leader>xr", function()
  load_trouble()
  vim.cmd "Trouble resume"
end, { desc = "Exec: resume [trouble]" })
UtilKey.nnoremap("<Leader>xx", function()
  load_trouble()
  vim.cmd.Trouble()
end, { desc = "Exec: open list builtin [trouble]" })

UtilKey.nnoremap("<Leader>xt", function()
  load_trouble()
  auto_close_qf_win()
  vim.cmd [[Trouble todo toggle filter.buf=0]]
end, { desc = "Exec: check todotrouble curbuf [trouble]" })

UtilKey.nnoremap("<Leader>xT", function()
  load_trouble()
  auto_close_qf_win()
  vim.cmd.TodoTrouble()
end, { desc = "Exec: check global todotrouble [trouble]" })

UtilKey.nnoremap("<Leader>xD", function()
  load_trouble()
  auto_close_qf_win()
  vim.cmd [[Trouble diagnostics toggle]]
end, { desc = "Exec: workspaces diagnostics [trouble]" })
UtilKey.nnoremap("<Leader>xd", function()
  load_trouble()
  auto_close_qf_win()
  vim.cmd [[Trouble diagnostics toggle filter.buf=0]]
end, { desc = "Exec: document diagnostisc [trouble]" })

UtilKey.nnoremap("<Leader>xl", function()
  load_trouble()
  auto_close_qf_win()
  vim.cmd "Trouble loclist toggle"
end, { desc = "Exec: open loclist with [trouble]" })

UtilKey.nnoremap("<Leader>xq", function()
  load_trouble()
  auto_close_qf_win()
  vim.cmd "Trouble qflist toggle"
end, { desc = "Exec: open quickfix (qf) with [trouble]" })
