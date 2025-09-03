local wezterm = require "wezterm"
local act = wezterm.action

return {
  copy_mode = {
    {
      key = "Escape",
      mods = "NONE",
      action = act.Multiple {
        act.ClearSelection,
        act.CopyMode "ClearPattern",
        act.CopyMode "Close",
      },
    },
    { key = "q", mods = "NONE", action = act.CopyMode "Close" },
    { key = "c", mods = "CTRL", action = act.CopyMode "Close" },
    -- move cursor
    { key = "h", mods = "NONE", action = act.CopyMode "MoveLeft" },
    { key = "LeftArrow", mods = "NONE", action = act.CopyMode "MoveLeft" },
    { key = "j", mods = "NONE", action = act.CopyMode "MoveDown" },
    { key = "DownArrow", mods = "NONE", action = act.CopyMode "MoveDown" },
    { key = "k", mods = "NONE", action = act.CopyMode "MoveUp" },
    { key = "UpArrow", mods = "NONE", action = act.CopyMode "MoveUp" },
    { key = "l", mods = "NONE", action = act.CopyMode "MoveRight" },
    { key = "RightArrow", mods = "NONE", action = act.CopyMode "MoveRight" },
    -- move word
    { key = "RightArrow", mods = "ALT", action = act.CopyMode "MoveForwardWord" },
    { key = "f", mods = "ALT", action = act.CopyMode "MoveForwardWord" },
    { key = "\t", mods = "NONE", action = act.CopyMode "MoveForwardWord" },
    { key = "w", mods = "NONE", action = act.CopyMode "MoveForwardWord" },
    { key = "LeftArrow", mods = "ALT", action = act.CopyMode "MoveBackwardWord" },
    { key = "b", mods = "ALT", action = act.CopyMode "MoveBackwardWord" },
    { key = "\t", mods = "SHIFT", action = act.CopyMode "MoveBackwardWord" },
    { key = "b", mods = "NONE", action = act.CopyMode "MoveBackwardWord" },
    {
      key = "e",
      mods = "NONE",
      action = act {
        Multiple = {
          act.CopyMode "MoveRight",
          act.CopyMode "MoveForwardWord",
          act.CopyMode "MoveLeft",
        },
      },
    },
    -- move start/end
    { key = "0", mods = "NONE", action = act.CopyMode "MoveToStartOfLine" },
    { key = "\n", mods = "NONE", action = act.CopyMode "MoveToStartOfNextLine" },
    { key = "$", mods = "SHIFT", action = act.CopyMode "MoveToEndOfLineContent" },
    { key = "$", mods = "NONE", action = act.CopyMode "MoveToEndOfLineContent" },
    { key = "e", mods = "CTRL", action = act.CopyMode "MoveToEndOfLineContent" },
    { key = "m", mods = "ALT", action = act.CopyMode "MoveToStartOfLineContent" },
    { key = "^", mods = "SHIFT", action = act.CopyMode "MoveToStartOfLineContent" },
    { key = "^", mods = "NONE", action = act.CopyMode "MoveToStartOfLineContent" },
    { key = "a", mods = "CTRL", action = act.CopyMode "MoveToStartOfLineContent" },
    -- visual mode
    { key = "v", mods = "NONE", action = act.CopyMode { SetSelectionMode = "Cell" } },
    { key = "V", mods = "NONE", action = act.CopyMode { SetSelectionMode = "Line" } },
    { key = "v", mods = "CTRL", action = act.CopyMode { SetSelectionMode = "Block" } },

    -- copy
    {
      key = "y",
      mods = "NONE",
      action = act {
        Multiple = {
          act { CopyTo = "ClipboardAndPrimarySelection" },
          act.CopyMode "Close",
        },
      },
    },
    {
      key = "y",
      mods = "SHIFT",
      action = act {
        Multiple = {
          act.CopyMode { SetSelectionMode = "Cell" },
          act.CopyMode "MoveToEndOfLineContent",
          act { CopyTo = "ClipboardAndPrimarySelection" },
          act.CopyMode "Close",
        },
      },
    },
    -- scroll
    { key = "G", mods = "SHIFT", action = act.CopyMode "MoveToScrollbackBottom" },
    { key = "G", mods = "NONE", action = act.CopyMode "MoveToScrollbackBottom" },
    { key = "g", mods = "NONE", action = act.CopyMode "MoveToScrollbackTop" },
    { key = "H", mods = "NONE", action = act.CopyMode "MoveToViewportTop" },
    { key = "H", mods = "SHIFT", action = act.CopyMode "MoveToViewportTop" },
    { key = "M", mods = "NONE", action = act.CopyMode "MoveToViewportMiddle" },
    { key = "M", mods = "SHIFT", action = act.CopyMode "MoveToViewportMiddle" },
    { key = "L", mods = "NONE", action = act.CopyMode "MoveToViewportBottom" },
    { key = "L", mods = "SHIFT", action = act.CopyMode "MoveToViewportBottom" },
    { key = "o", mods = "NONE", action = act.CopyMode "MoveToSelectionOtherEnd" },
    { key = "O", mods = "NONE", action = act.CopyMode "MoveToSelectionOtherEndHoriz" },
    { key = "O", mods = "SHIFT", action = act.CopyMode "MoveToSelectionOtherEndHoriz" },
    { key = "y", mods = "CTRL", action = act.CopyMode { MoveByPage = -0.2 } },
    { key = "e", mods = "CTRL", action = act.CopyMode { MoveByPage = 0.2 } },
    { key = "u", mods = "CTRL", action = act.CopyMode { MoveByPage = -0.5 } },
    { key = "d", mods = "CTRL", action = act.CopyMode { MoveByPage = 0.5 } },
    { key = "b", mods = "CTRL", action = act.CopyMode { MoveByPage = -0.8 } },
    { key = "f", mods = "CTRL", action = act.CopyMode { MoveByPage = 0.8 } },
    { key = "PageUp", mods = "NONE", action = act.CopyMode "PageUp" },
    { key = "PageDown", mods = "NONE", action = act.CopyMode "PageDown" },
    {
      key = "Enter",
      mods = "NONE",
      action = act.CopyMode "ClearSelectionMode",
    },
    -- search
    { key = "/", mods = "NONE", action = act.Search "CurrentSelectionOrEmptyString" },
    { key = "g", mods = "CTRL", action = act.Search "CurrentSelectionOrEmptyString" },
    {
      key = "n",
      mods = "NONE",
      action = act.Multiple {
        act.CopyMode "NextMatch",
        act.CopyMode "ClearSelectionMode",
      },
    },
    {
      key = "N",
      mods = "SHIFT",
      action = act.Multiple {
        act.CopyMode "PriorMatch",
        act.CopyMode "ClearSelectionMode",
      },
    },
  },
  search_mode = {
    { key = "Escape", mods = "NONE", action = act.CopyMode "Close" },
    {
      key = "Enter",
      mods = "NONE",
      action = act.Multiple {
        act.CopyMode "ClearSelectionMode",
        act.ActivateCopyMode,
      },
    },
    { key = "p", mods = "CTRL", action = act.CopyMode "PriorMatch" },
    { key = "n", mods = "CTRL", action = act.CopyMode "NextMatch" },
    { key = "r", mods = "CTRL", action = act.CopyMode "CycleMatchType" },
    { key = "/", mods = "NONE", action = act.CopyMode "ClearPattern" },
    { key = "u", mods = "CTRL", action = act.CopyMode "ClearPattern" },
    { key = "w", mods = "CTRL", action = act.CopyMode "ClearPattern" },
  },
}
