local function clock()
    return " " .. os.date("%H:%M")
end

local function lsp_progress()
    local messages = vim.lsp.util.get_progress_messages()
    if #messages == 0 then
        return
    end
    local status = {}
    for _, msg in pairs(messages) do
        table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
    end
    local spinners = {"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"}
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    return table.concat(status, " | ") .. " " .. spinners[frame + 1]
end

local filename_dir = function()
    local basename = vim.fn.expand("%:t")

    if vim.bo.readonly == true then
        basename = basename .. "%#WarningMsg#" .. " "
    end
    if vim.bo.modified == true then
        basename = basename .. " ..✘"
    end

    return basename
end

vim.cmd([[autocmd User LspProgressUpdate let &ro = &ro]])

require("lualine").setup(
    {
        options = {
            icons_enabled = true,
            -- theme = "solarized",
            component_separators = {"", ""},
            section_separators = {"", ""},
            disabled_filetypes = {}
        },
        sections = {
            lualine_a = {"mode"},
            lualine_b = {"branch"},
            lualine_c = {{"diagnostics", sources = {"nvim_lsp"}}, filename_dir},
            lualine_x = {"filetype", lsp_progress},
            lualine_y = {"progress"},
            lualine_z = {"location", clock}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {{filename_dir, path = 0}},
            lualine_x = {"location"},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        extensions = {"quickfix", "nvim-tree", "fugitive"}
    }
)
