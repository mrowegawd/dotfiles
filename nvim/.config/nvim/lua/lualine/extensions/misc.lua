local M = {}

local fmt, api, hg = string.format, vim.api, as.highlight

-- local clock = function()
--     return " " .. os.date "%H:%M"
-- end

local function qflabel()
    return as.is_loclist() and "Location List" or "Quickfix List"
end

local function title()
    if vim.bo.filetype ~= "qf" then
        return ""
    end

    if as.is_loclist() then
        return vim.fn.getloclist(0, { title = 0 }).title
    end

    return fmt(
        "[ID %s] [Title %s]",
        vim.fn.getqflist({ id = 0 }).id,
        vim.fn.getqflist({ title = 0 }).title
    )
end

local term_plugins = function()
    local ft_buf =
        api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype")
    if ft_buf == "toggleterm" then
        local terms = require "toggleterm.terminal"
        local count_term = terms.get_all()
        if #count_term > 0 then
            return fmt(
                "   |   No.%s of ﬑ %s ",
                as.toggle_number,
                #count_term
            )
        end
    elseif ft_buf == "BufTerm" then
        return "bufterm"
    else
        return ""
    end
end

local function label()
    local ft = {
        ["NvimTree"] = "file Manager",
        ["Outline"] = "outline",
        ["TelescopePrompt"] = "telescope prompt",
        ["aerial"] = "aerial",
        ["alpha"] = "",
        ["fugitive"] = "fugitive status",
        ["floggraph"] = "floggraph",
        ["Trouble"] = "trouble",
        ["neo-tree"] = "file Manager",
        ["qf"] = qflabel,
        ["toggleterm"] = term_plugins,
        ["BufTerm"] = term_plugins,
        ["undotree"] = "undotree",
        ["orgagenda"] = "orgagenda",
        ["OverseerList"] = "overseer list",

        ["dap-repl"] = "dap-repl",
        ["dapui_breakpoints"] = "dapui_breakpoints",
        ["dapui_console"] = "dapui_console",
        ["dapui_scopes"] = "dapui_scopes",
        ["dapui_stacks"] = "dapui_stacks",
        ["dapui_watches"] = "dapui_watches",
    }

    local set_label = ft[vim.bo.filetype]

    local fmt_string = ""
    if set_label then
        if type(set_label) == "function" then
            local cat_string = set_label()
            if type(cat_string) == "string" then
                fmt_string = cat_string
            end
        else
            -- vim.notify(set_label)
            fmt_string = set_label
        end
    end

    fmt_string = "  " .. string.upper(fmt_string)

    return fmt_string
end

M.sections = {
    lualine_c = {},
    lualine_x = {
        {
            label,
            color = {
                bg = hg.get("Directory", "fg"),
                fg = hg.get("Normal", "bg"),
                gui = "bold",
            },
        },
        {
            title,
            color = {
                fg = hg.get("Normal", "bg"),
                bg = hg.get("Title", "fg"),
                gui = "bold",
            },
        },
        -- { clock, color = { fg = "white", gui = "bold" } },
    },
}

M.inactive_sections = {
    lualine_c = {},
    lualine_x = {

        {
            label,
            color = {
                fg = hg.get("LineNr", "fg"),
                bg = hg.get("Normal", "bg"),
            },
        },
    },
}

M.filetypes = {
    "NvimTree",
    "Outline",
    "TelescopePrompt",
    "aerial",
    "dap-repl",
    "dapui_breakpoints",
    "dapui_console",
    "dapui_scopes",
    "Trouble",
    "dapui_stacks",
    "dapui_watches",
    "floaterm",
    "fugitive",
    "neo-tree",
    "qf",
    "quickfix",
    "floggraph",
    "OverseerList",
    "toggleterm",
    "BufTerm",
    "undotree",
    "orgagenda",
}

return M
