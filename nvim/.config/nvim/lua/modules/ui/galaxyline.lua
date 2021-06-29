local gl = require("galaxyline")
local colors = require("modules.ui._colors").nm
local i = require("modules.ui._colors").icon
-- local i = require("modules.ui._colors").icon
local condition = require("galaxyline.condition")
local gls = gl.section

gl.short_line_list = {"NvimTree", "vista", "dbui", "packer"}

ViMode = require("modules.ui.statusline.vmode").vmode
SeparatorVmode = require("modules.ui.statusline.vmode").separatorVmode
GitBranch = {
    function()
        return "  "
    end,
    "GitBranch"
}
RightSeparator = {
    function()
        return " " .. i.thin.Right .. " "
    end
}

LeftSeparator = {
    function()
        return " " .. i.thin.Left .. " "
    end
}

MoctSeparator = {
    function()
        return " " .. i.slant.Left
    end
}

FileName = {
    function()
        return "  "
    end,
    "FileName"
}

gls.left[1] = {
    ViMode = {
        provider = ViMode,
        highlight = {colors.bg, colors.green}
    }
}

gls.left[2] = {
    SeparatorVmode = {
        provider = SeparatorVmode,
        highlight = {colors.fg, colors.bg}
    }
}

gls.left[3] = {
    FileName = {
        provider = FileName,
        condition = condition.buffer_not_empty,
        -- separator = i.slant.Left,
        -- separator_highlight = {colors.bg, testcol},
        highlight = {colors.magenta, colors.bg, "bold"}
    }
}

gls.left[4] = {
    RightSeparator = {
        provider = RightSeparator,
        highlight = {colors.fg, colors.bg}
    }
}

gls.left[5] = {
    GitBranch = {
        provider = GitBranch,
        condition = function()
            return condition.check_git_workspace()
        end,
        highlight = {colors.fg, colors.bg}
    }
}

gls.left[6] = {
    DiffAdd = {
        provider = "DiffAdd",
        condition = condition.hide_in_width,
        icon = "  ",
        highlight = {colors.green, colors.bg}
    }
}
gls.left[7] = {
    DiffModified = {
        provider = "DiffModified",
        condition = condition.hide_in_width,
        icon = " 柳",
        highlight = {colors.orange, colors.bg}
    }
}
gls.left[8] = {
    DiffRemove = {
        provider = "DiffRemove",
        condition = condition.hide_in_width,
        icon = "  ",
        highlight = {colors.red, colors.bg}
    }
}

gls.left[9] = {
    DiagnosticError = {
        provider = "DiagnosticError",
        icon = "  ",
        highlight = {colors.red, colors.bg}
    }
}
gls.right[10] = {
    DiagnosticWarn = {
        provider = "DiagnosticWarn",
        icon = "  ",
        highlight = {colors.yellow, colors.bg}
    }
}

gls.right[11] = {
    DiagnosticHint = {
        provider = "DiagnosticHint",
        icon = "  ",
        highlight = {colors.cyan, colors.bg}
    }
}

gls.right[12] = {
    DiagnosticInfo = {
        provider = "DiagnosticInfo",
        icon = "  ",
        highlight = {colors.blue, colors.bg}
    }
}

gls.right[13] = {
    FileEncode = {
        provider = "FileEncode",
        condition = condition.hide_in_width,
        separator = " ",
        separator_highlight = {"NONE", colors.bg},
        highlight = {colors.green, colors.bg, "bold"}
    }
}

gls.right[14] = {
    FileFormat = {
        provider = "FileFormat",
        condition = condition.hide_in_width,
        separator = " ",
        separator_highlight = {"NONE", colors.bg},
        highlight = {colors.green, colors.bg, "bold"}
    }
}

gls.right[15] = {
    LeftSeparator = {
        provider = LeftSeparator,
        highlight = {colors.fg, colors.bg}
    }
}

gls.right[16] = {
    ShowLspClient = {
        provider = "GetLspClient",
        condition = function()
            local tbl = {["dashboard"] = true, [""] = true}
            if tbl[vim.bo.filetype] then
                return false
            end
            return true
        end,
        icon = "   ",
        highlight = {colors.yellow, colors.bg, "bold"}
    }
}

gls.right[17] = {
    MoctSeparator = {
        provider = MoctSeparator,
        highlight = {colors.fg, colors.bg}
    }
}

gls.right[18] = {
    LineInfo = {
        provider = "LineColumn",
        highlight = {colors.bg, colors.fg}
    }
}

gls.right[19] = {
    PerCent = {
        provider = "LinePercent",
        highlight = {colors.bg, colors.fg, "bold"}
    }
}
--     FileSize = {
--         provider = "FileSize",
--         condition = condition.buffer_not_empty,
--         highlight = {colors.fg, testcol}
--     }
-- }

-- gls.left[3] = {
--     FileName = {
--         provider = {
--             function()
--                 return "  "
--             end,
--             "FileName"
--         },
--         condition = condition.buffer_not_empty,
--         separator = i.slant.Left,
--         separator_highlight = {colors.bg, testcol},
--         highlight = {colors.magenta, testcol, "bold"}
--     }
-- }

-- gls.mid[1] = {
--     ShowLspClient = {
--         provider = "GetLspClient",
--         condition = function()
--             local tbl = {["dashboard"] = true, [""] = true}
--             if tbl[vim.bo.filetype] then
--                 return false
--             end
--             return true
--         end,
--         icon = " LSP:",
--         highlight = {colors.yellow, colors.bg, "bold"}
--     }
-- }

-- gls.right[1] = {
--     FileEncode = {
--         provider = "FileEncode",
--         condition = condition.hide_in_width,
--         separator = " ",
--         separator_highlight = {"NONE", colors.bg},
--         highlight = {colors.green, colors.bg, "bold"}
--     }
-- }

-- gls.right[2] = {
--     FileFormat = {
--         provider = "FileFormat",
--         condition = condition.hide_in_width,
--         separator = " ",
--         separator_highlight = {"NONE", colors.bg},
--         highlight = {colors.green, colors.bg, "bold"}
--     }
-- }

-- gls.right[3] = {
--     GitIcon = {
--         provider = function()
--             return "  "
--         end,
--         condition = condition.check_git_workspace,
--         separator = " ",
--         separator_highlight = {"NONE", colors.bg},
--         highlight = {colors.violet, colors.bg, "bold"}
--     }
-- }

-- gls.right[4] = {
--     GitBranch = {
--         provider = {
--             function()
--                 return "  "
--             end,
--             "GitBranch"
--         },
--         -- taken from: https://github.com/mnabila/nvimrc/blob/master/lua/plugins/galaxyline.lua#L35
--         condition = function()
--             return condition.check_git_workspace() and condition.hide_in_width()
--         end,
--         highlight = {colors.violet, colors.bg, "bold"}
--     }
-- }

-- gls.right[5] = {
--     DiffAdd = {
--         provider = "DiffAdd",
--         condition = condition.hide_in_width,
--         icon = "  ",
--         highlight = {colors.green, colors.bg}
--     }
-- }
-- gls.right[6] = {
--     DiffModified = {
--         provider = "DiffModified",
--         condition = condition.hide_in_width,
--         icon = " 柳",
--         highlight = {colors.orange, colors.bg}
--     }
-- }
-- gls.right[7] = {
--     DiffRemove = {
--         provider = "DiffRemove",
--         condition = condition.hide_in_width,
--         icon = "  ",
--         highlight = {colors.red, colors.bg}
--     }
-- }

-- gls.right[8] = {
--     RainbowBlue = {
--         provider = function()
--             return " ▊"
--         end,
--         highlight = {colors.blue, colors.bg}
--     }
-- }

gls.short_line_left[1] = {
    BufferType = {
        provider = "FileTypeName",
        separator = " ",
        separator_highlight = {"NONE", colors.bg},
        highlight = {colors.blue, colors.bg, "bold"}
    }
}

gls.short_line_left[2] = {
    SFileName = {
        provider = "SFileName",
        condition = condition.buffer_not_empty,
        highlight = {colors.fg, colors.bg, "bold"}
    }
}

gls.short_line_right[1] = {
    BufferIcon = {
        provider = "BufferIcon",
        highlight = {colors.fg, colors.bg}
    }
}
