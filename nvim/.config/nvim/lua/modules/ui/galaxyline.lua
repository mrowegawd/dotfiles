local gl = require("galaxyline")
local colors = require("modules.ui._colors").nm
local i = require("modules.ui._colors").icon
local num = require("modules.ui._colors").num
local condition = require("galaxyline.condition")
local gls = gl.section

gl.short_line_list = {"NvimTree", "vista", "dbui", "packer"}
local testcol = "#0e1111"

local GalaxyBG = function(item, col)
    vim.api.nvim_command("hi Galaxy" .. item .. " guibg=" .. col)
end

local GalaxyHi = function(item, colorfg, colorbg)
    vim.api.nvim_command("hi Galaxy" .. item .. " guifg=" .. colorfg .. " guibg=" .. colorbg)
end

local buffer_not_empty = function()
    if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
        return true
    end
    return false
end

local vim, lsp, api = vim, vim.lsp, vim.api

local get_nvim_lsp_diagnostic = function(diag_type)
    if vim.tbl_isempty(lsp.buf_get_clients(0)) then
        return ""
    end

    local active_clients = lsp.get_active_clients()

    if active_clients then
        local count = 0

        for _, client in ipairs(active_clients) do
            count = count + lsp.diagnostic.get_count(api.nvim_get_current_buf(), diag_type, client.id)
        end

        if count ~= 0 then
            return count
        end
    end
end

local has_diagnostics = function()
    local c = 0
    if not vim.tbl_isempty(lsp.buf_get_clients(0)) then
        if get_nvim_lsp_diagnostic("Error") ~= nil and get_nvim_lsp_diagnostic("Error") > 0 then
            c = c + get_nvim_lsp_diagnostic("Error")
        end
        if get_nvim_lsp_diagnostic("Warning") ~= nil and get_nvim_lsp_diagnostic("Warning") > 0 then
            c = c + get_nvim_lsp_diagnostic("Warning")
        end
        if get_nvim_lsp_diagnostic("Hint") ~= nil and get_nvim_lsp_diagnostic("Hint") > 0 then
            c = c + get_nvim_lsp_diagnostic("Hint")
        end
        if get_nvim_lsp_diagnostic("Information") ~= nil and get_nvim_lsp_diagnostic("Information") > 0 then
            c = c + get_nvim_lsp_diagnostic("Information")
        end
    end
    if c > 0 then
        return true
    else
        return false
    end
end

local filetype_seperator = function()
    if has_diagnostics() and vim.bo.filetype == "" then
        GalaxyHi("FiletTypeSeperator", testcol, colors.blue)
        return ""
    else
        GalaxyHi("FiletTypeSeperator", colors.blue, testcol)
        return i.slant.Right
    end
end

local testme = function()
    local mode = {
        c = {i.mode.c, colors.red},
        ce = {i.mode.c, colors.red},
        cv = {i.mode.c, colors.red},
        i = {i.mode.i, colors.yellow},
        ic = {i.mode.i, colors.yellow},
        n = {i.mode.n, colors.red},
        no = {i.mode.n, colors.red},
        r = {i.mode.r, colors.cyan},
        rm = {i.mode.r, colors.cyan},
        R = {i.mode.r, colors.violet},
        Rv = {i.mode.r, colors.violet},
        s = {i.mode.s, colors.orange},
        S = {i.mode.s, colors.orange},
        t = {i.mode.t, colors.blue},
        V = {i.mode.v, colors.blue},
        v = {i.mode.v, colors.blue},
        ["r?"] = {i.mode.r, colors.cyan},
        [""] = {"🅢 ", colors.orange},
        [""] = {" ", colors.blue},
        ["!"] = {"! ", colors.red}
    }

    local n = (function()
        if num[vim.fn.bufnr("%")] ~= nil then
            return num[vim.fn.bufnr("%")]
        else
            return vim.fn.bufnr("%")
        end
    end)()

    -- vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)

    local vimMode = mode[vim.fn.mode()]
    if mode[vim.fn.mode()] ~= nil then
        GalaxyBG("ViMode", vimMode[2])
        return "   " .. vimMode[1] .. " | " .. n .. "  "
    else
        GalaxyBG("ViMode", "error")
        return "  ? | " .. n .. "  "
    end
end

local testjo = function()
    local mode_color = {
        c = colors.red,
        ce = colors.red,
        cv = colors.red,
        i = colors.yellow,
        ic = colors.yellow,
        n = colors.red,
        no = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        R = colors.violet,
        Rv = colors.violet,
        s = colors.orange,
        S = colors.orange,
        t = colors.red,
        V = colors.blue,
        v = colors.blue,
        ["r?"] = colors.cyan,
        [""] = colors.orange,
        [""] = colors.blue,
        ["!"] = colors.red
    }

    local m_color = "error"

    if mode_color[vim.fn.mode()] ~= nil then
        m_color = mode_color[vim.fn.mode()]
    end

    if not buffer_not_empty() or vim.bo.filetype == "dashboard" then
        GalaxyHi("ViModeSeperator", m_color, colors.green)
    else
        GalaxyHi("ViModeSeperator", m_color, testcol)
    end

    return i.slant.Right
end

gls.left[1] = {
    ViMode = {
        provider = testme,
        highlight = {testcol, colors.green}
    }
}

gls.left[2] = {
    RainbowRed = {
        provider = testjo,
        highlight = {colors.red, testcol}
    }
}
-- gls.left[3] = {
--     FileSize = {
--         provider = "FileSize",
--         condition = condition.buffer_not_empty,
--         highlight = {colors.fg, testcol}
--     }
-- }

gls.left[3] = {
    FileName = {
        provider = {
            function()
                return "  "
            end,
            "FileName"
        },
        condition = condition.buffer_not_empty,
        separator = i.slant.Left,
        separator_highlight = {colors.bg, testcol},
        highlight = {colors.magenta, testcol, "bold"}
    }
}

-- gls.left[5] = {
--     FileIcon = {
--         provider = "FileIcon",
--         condition = condition.buffer_not_empty,
--         highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, colors.bg}
--     }
-- }

-- gls.left[5] = {
--     LineInfo = {
--         provider = "LineColumn",
--         separator_highlight = {"NONE", colors.bg},
--         highlight = {colors.fg, colors.bg}
--     }
-- }

-- gls.left[6] = {
--     PerCent = {
--         provider = "LinePercent",
--         separator_highlight = {"NONE", colors.bg},
--         highlight = {colors.fg, colors.bg, "bold"}
--     }
-- }

gls.left[8] = {
    DiagnosticError = {
        provider = "DiagnosticError",
        icon = "  ",
        highlight = {colors.red, colors.bg}
    }
}
gls.left[9] = {
    DiagnosticWarn = {
        provider = "DiagnosticWarn",
        icon = "  ",
        highlight = {colors.yellow, colors.bg}
    }
}

gls.left[10] = {
    DiagnosticHint = {
        provider = "DiagnosticHint",
        icon = "  ",
        highlight = {colors.cyan, colors.bg}
    }
}

gls.left[11] = {
    DiagnosticInfo = {
        provider = "DiagnosticInfo",
        icon = "  ",
        highlight = {colors.blue, colors.bg}
    }
}

gls.mid[1] = {
    ShowLspClient = {
        provider = "GetLspClient",
        condition = function()
            local tbl = {["dashboard"] = true, [""] = true}
            if tbl[vim.bo.filetype] then
                return false
            end
            return true
        end,
        icon = " LSP:",
        highlight = {colors.yellow, colors.bg, "bold"}
    }
}

gls.right[1] = {
    FileEncode = {
        provider = "FileEncode",
        condition = condition.hide_in_width,
        separator = " ",
        separator_highlight = {"NONE", colors.bg},
        highlight = {colors.green, colors.bg, "bold"}
    }
}

gls.right[2] = {
    FileFormat = {
        provider = "FileFormat",
        condition = condition.hide_in_width,
        separator = " ",
        separator_highlight = {"NONE", colors.bg},
        highlight = {colors.green, colors.bg, "bold"}
    }
}

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

gls.right[8] = {
    RainbowBlue = {
        provider = function()
            return " ▊"
        end,
        highlight = {colors.blue, colors.bg}
    }
}

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
