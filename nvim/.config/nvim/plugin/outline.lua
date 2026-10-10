local add_local_or_remote = require("vim-pack").add_local_or_remote

local kind = require("icons").kinds
local UtilKey = require "utils.map"

local Log = require "utils.log"

local _outline_follow_state = nil

add_local_or_remote {
  {
    -- src = "MadKuntilanak/outline.nvim",
    src = "nvim_plugins/outline.nvim",
    lazy = true,
    opts = {
      outline_window = {
        position = "left",
        winhl = "Normal:Normal,EndOfBuffer:None,NonText:Normal,CursorLine:FloatCursorline",
        focus_on_open = false,
        show_cursorline = true,
        hide_cursor = false,
        width = 20,
      },
      frozen_indicator = {
        -- icon = "🔒",
        row_offset = 1,
        winhl = "Normal:PanelBottomNormal,FloatBorder:PanelBottomNormal",
        anchor = "NE",
      },
      references = {
        marker = " 󰆽",
        marker_hl = "DiagnosticWarn",
        icon = "󰌹 ",
        icon_hl = "Error",
      },
      symbols = {
        filter = nil,
        icons = {
          File = { icon = kind.File, hl = "LspKindFile" },
          Module = { icon = kind.Module, hl = "LspKindModule" },
          Namespace = { icon = kind.Namespace, hl = "LspKindNamespace" },
          Package = { icon = kind.Package, hl = "LspKindPackage" },
          Class = { icon = kind.Class, hl = "Type" }, -- INI BELUM!
          Method = { icon = kind.Method, hl = "LspKindMethod" },
          Property = { icon = kind.Property, hl = "LspKindProperty" },
          Field = { icon = kind.Field, hl = "LspKindField" },
          Constructor = { icon = kind.Constructor, hl = "LspKindConstructor" },
          Enum = { icon = kind.Enum, hl = "LspKindEnum" },
          Interface = { icon = kind.Interface, hl = "LspKindInterface" },
          Function = { icon = kind.Function, hl = "LspKindFunction" },
          Variable = { icon = kind.Variable, hl = "LspKindVariable" },
          Constant = { icon = kind.Constant, hl = "LspKindConstant" },
          String = { icon = kind.String, hl = "LspKindString" },
          Number = { icon = kind.number, hl = "LspKindNumber" },
          Boolean = { icon = kind.Boolean, hl = "LspKindBoolean" },
          Array = { icon = kind.Array, hl = "LspKindObject" },
          Object = { icon = kind.Object, hl = "LspKindObject" },
          Key = { icon = kind.Key, hl = "LspKindKey" },
          Null = { icon = kind.Null, hl = "LspKindNull" },
          EnumMember = { icon = kind.EnumNumber, hl = "LspKindEnumMember" },
          Struct = { icon = kind.Struct, hl = "LspKindStruct" },
          Event = { icon = kind.Event, hl = "LspKindEvent" },
          Operator = { icon = kind.Operator, hl = "LspKindOperator" },
          TypeParameter = { icon = kind.TypeParameter, hl = "LspKindTypeParameter" },
          Component = { icon = kind.Component, hl = "Function" }, -- INI BELUM
          Fragment = { icon = "󰅴", hl = "Constant" }, -- INI BELUM

          TypeAlias = { icon = kind.TypeAlias, hl = "Type" },
          Parameter = { icon = kind.Parameter, hl = "Identifier" },
          StaticMethod = { icon = kind.StaticMethod, hl = "Function" },
          Macro = { icon = kind.Macro, hl = "Function" },
        },
      },
      preview_window = {
        live = true,
        auto_preview = false,
        winhl = "NormalFloat:NormalFloat",
      },
      picker = "fzf-lua", -- fzf-lua, telescope
      keymaps = {
        show_help = "g?",
        close = { "q", "<Leader><Tab>", "<leader>bk" },
        goto_location = { "<CR>", "o" },
        peek_location = "<a-k>",
        goto_and_close = {},
        restore_location = "~",
        unfold = "zo",
        fold_toggle = { "<S-tab>", "<Tab>", "za" },
        fold = "zc",
        fold_all = "zM",
        unfold_all = { "zO", "zR" },
        fold_reset = "<space><space>",
        cycle_fold_depth = "zb",
        toggle_preview = "P",
        rename_symbol = {},
        code_actions = {},
        hover_symbol = "K",
        next_ref_node = "<c-n>",
        prev_ref_node = "<c-p>",
        down_and_jump = "<a-n>",
        up_and_jump = "<a-p>",

        open_in_vsplit = "<Leader>ov",
        open_in_split = "<Leader>os",
        open_in_tab = "<Leader>ot",
        open_in_float = "<Leader>oP",
      },
    },
  },
}

local load_outline = function()
  require("vim-pack").load_now "outline.nvim"
end

UtilKey.disable_ctrl_i_and_o("NoOutline", { "Outline" })

UtilKey.nnoremap("<Leader>oa", function()
  load_outline()
  require("utils.layout").toggle_sidebar("Outline", function()
    vim.cmd.Outline()
  end)
end, { desc = "Open: outline window [outline]" })

UtilKey.nnoremap("<Leader>oA", function()
  load_outline()
  vim.cmd.OutlineFloat()
end, { desc = "Open: outline float window [outline]" })

vim.api.nvim_create_user_command("OutlineToggleFollow", function()
  load_outline()
  local cfg = require "outline.config"
  local o = cfg.o

  if _outline_follow_state == nil then
    _outline_follow_state = {
      highlight_hovered_item = o.outline_items.highlight_hovered_item,
      auto_set_cursor = o.outline_items.auto_set_cursor,
      auto_unfold_hovered = o.symbol_folding.auto_unfold.hovered,
      auto_unfold_hover = o.symbol_folding.auto_unfold_hover,
    }
    o.outline_items.highlight_hovered_item = false
    o.outline_items.auto_set_cursor = false
    o.symbol_folding.auto_unfold.hovered = false
    o.symbol_folding.auto_unfold_hover = false

    Log.info "Outline: follow disabled"
  else
    o.outline_items.highlight_hovered_item = _outline_follow_state.highlight_hovered_item
    o.outline_items.auto_set_cursor = _outline_follow_state.auto_set_cursor
    o.symbol_folding.auto_unfold.hovered = _outline_follow_state.auto_unfold_hovered
    o.symbol_folding.auto_unfold_hover = _outline_follow_state.auto_unfold_hover
    _outline_follow_state = nil

    Log.info "Outline: follow enabled"
  end
end, {})
