----------------------------------------------------------------------------------------------------
-- Styles
----------------------------------------------------------------------------------------------------

as.ui.palette = {
    green = "#98c379",
    dark_green = "#10B981",
    blue = "#82AAFE",
    dark_blue = "#4e88ff",
    bright_blue = "#51afef",
    teal = "#15AABF",
    pale_pink = "#b490c0",
    magenta = "#c678dd",
    pale_red = "#E06C75",
    light_red = "#c43e1f",
    dark_red = "#be5046",
    dark_orange = "#FF922B",
    bright_yellow = "#FAB005",
    light_yellow = "#e5c07b",
    whitesmoke = "#9E9E9E",
    light_gray = "#626262",
    comment_grey = "#5c6370",
    grey = "#3E4556",
}

as.ui.border = {
    line = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
    rectangle = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
}

as.ui.icons = {
    separators = {
        left_thin_block = " ",
        right_thin_block = "▕",
        vert_bottom_half_block = "▄",
        vert_top_half_block = "▀",
        right_block = "🮉",
        light_shade_block = "░",
    },
    diagnostics = {
        error = " ",
        warn = " ",
        question = " ",
        info = " ",
        hint = " ",
    },
    lsp = {
        error = " ", -- '✗'
        warn = " ",
        info = " ", --  
        hint = " ", --  ⚑
    },
    git = {
        add = " ", -- '',
        mod = " ",
        remove = " ", -- '',
        ignore = " ",
        rename = " ",
        diff = " ",
        repo = " ",
        logo = " ",
        branch = " ",
    },
    dap = {
        breakpoint = " ",
        breakpoint_stoped = " ",
        breakpoint_condition = " ",
        breakpoint_rejected = " ",
    },

    kind = {
        Text = "",
        String = "",
        Number = "",
        Function = "",
        Constructor = "",
        Method = "",
        Field = "",
        -- Variable = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "𝙏",
        Namespace = "󰦮",

        Component = "",
        Fragment = "",
        arrow_right = "",

        Package = "",
        Null = "NULL",
        Boolean = "◩",
        Array = "",
        Object = "",
        stacked = "﬘",
    },

    documents = {
        file = "  ",
        files = "  ",
        folder = "  ",
        open_folder = "  ",
    },
    misc = {
        -- 
        arrow_right = " ",
        block = "▌ ",
        bookmark = " ",
        bug = " ", --  'ﴫ'
        calendar = " ",
        caret_right = " ",
        check = " ",
        chevron_right = " ",
        circle = " ",
        clock = " ",
        close = " ",
        code = " ",
        comment = " ",
        dashboard = "  ",
        double_chevron_right = "» ",
        down = "⇣ ",
        ellipsis = "… ",
        fire = " ",
        gear = " ",
        history = " ",
        indent = "Ξ ",
        lightbulb = " ",
        line = "ℓ ", -- ''
        list = " ",
        lock = " ",
        note = " ",
        package = "  ",
        pencil = " ", -- '',
        plus = " ",
        project = " ",
        question = " ",
        robot = "ﮧh ",
        search = " ",
        shaded_lock = " ",
        sign_in = " ",
        sign_out = " ",
        smiley = "ﲃ ",
        squirrel = " ",
        tab = "⇥ ",
        table = " ",
        telescope = " ",
        terminal = " ",
        tools = " ",
        up = "⇡ ",

        tag = " ",
        watch = " ",
        run_program = "省",
    },
}
as.ui.lsp = {
    colors = {
        error = as.ui.palette.pale_red,
        warn = as.ui.palette.dark_orange,
        hint = as.ui.palette.bright_blue,
        info = as.ui.palette.teal,
    },
    --- This is a mapping of LSP Kinds to highlight groups. LSP Kinds come via the LSP spec
    --- see: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
    highlights = {
        Text = "String",
        Method = "TSMethod",
        Function = "Function",
        Constructor = "TSConstructor",
        Field = "TSField",
        Variable = "TSVariable",
        Class = "TSStorageClass",
        Interface = "Constant",
        Module = "Include",
        Property = "TSProperty",
        Unit = "Constant",
        Value = "Variable",
        Enum = "Type",
        Keyword = "Keyword",
        File = "Directory",
        Reference = "PreProc",
        Constant = "Constant",
        Struct = "Type",
        Snippet = "Label",
        Event = "Variable",
        Operator = "Operator",
        TypeParameter = "Type",
        Namespace = "TSNamespace",
        Package = "Include",
        String = "String",
        Number = "Number",
        Boolean = "Boolean",
        Array = "StorageClass",
        Object = "Type",
        Key = "TSField",
        Null = "ErrorMsg",
        EnumMember = "TSField",
    },
}

----------------------------------------------------------------------------------------------------
-- UI Settings
----------------------------------------------------------------------------------------------------
---@class Decorations {
---@field winbar 'ignore' | boolean
---@field number boolean
---@field statusline 'minimal' | boolean
---@field statuscolumn boolean
---@field colorcolumn boolean | string

---@alias DecorationType 'statuscolumn'|'winbar'|'statusline'|'number'|'colorcolumn'

---@class Decorations
local Preset = {}

---@param o Decorations
function Preset:new(o)
    assert(o, "a preset must be defined")
    self.__index = self
    return setmetatable(o, self)
end

--- WARNING: deep extend does not copy lua meta methods
function Preset:with(o)
    return vim.tbl_deep_extend("force", self, o)
end

---@type table<string, Decorations>
local presets = {
    statusline_only = Preset:new {
        number = false,
        winbar = false,
        colorcolumn = false,
        statusline = true,
        statuscolumn = false,
    },
    minimal_editing = Preset:new {
        number = false,
        winbar = true,
        colorcolumn = false,
        statusline = "minimal",
        statuscolumn = false,
    },
    tool_panel = Preset:new {
        number = false,
        winbar = false,
        colorcolumn = false,
        statusline = "minimal",
        statuscolumn = false,
    },
}

local commit_buffer =
    presets.minimal_editing:with { colorcolumn = "50,72", winbar = false }

local buftypes = {
    ["quickfix"] = presets.tool_panel,
    ["nofile"] = presets.tool_panel,
    ["nowrite"] = presets.tool_panel,
    ["acwrite"] = presets.tool_panel,
    ["terminal"] = presets.tool_panel,
}

--- When searching through the filetypes table if a match can't be found then search
--- again but check if there is matching lua pattern. This is useful for filetypes for
--- plugins like Neogit which have a filetype of Neogit<something>.
local filetypes = as.p_table {
    ["startuptime"] = presets.tool_panel,
    ["checkhealth"] = presets.tool_panel,
    ["log"] = presets.tool_panel,
    ["help"] = presets.tool_panel,
    ["^copilot.*"] = presets.tool_panel,
    ["dapui"] = presets.tool_panel,
    ["minimap"] = presets.tool_panel,
    ["Trouble"] = presets.tool_panel,
    ["tsplayground"] = presets.tool_panel,
    ["list"] = presets.tool_panel,
    ["netrw"] = presets.tool_panel,
    ["flutter.*"] = presets.tool_panel,
    ["NvimTree"] = presets.tool_panel,
    ["undotree"] = presets.tool_panel,
    ["dap-repl"] = presets.tool_panel:with { winbar = "ignore" },
    ["neo-tree"] = presets.tool_panel:with { winbar = "ignore" },
    ["toggleterm"] = presets.tool_panel:with { winbar = "ignore" },
    ["neotest.*"] = presets.tool_panel,
    ["^Neogit.*"] = presets.tool_panel,
    ["query"] = presets.tool_panel,
    ["DiffviewFiles"] = presets.tool_panel,
    ["DiffviewFileHistory"] = presets.tool_panel,
    ["mail"] = presets.statusline_only,
    ["noice"] = presets.statusline_only,
    ["diff"] = presets.statusline_only,
    ["qf"] = presets.statusline_only,
    ["alpha"] = presets.tool_panel:with { statusline = false },
    ["fugitive"] = presets.statusline_only,
    ["startify"] = presets.statusline_only,
    ["man"] = presets.minimal_editing,
    ["org"] = presets.minimal_editing,
    ["norg"] = presets.minimal_editing,
    ["markdown"] = presets.minimal_editing,
    ["himalaya"] = presets.minimal_editing,
    ["orgagenda"] = presets.minimal_editing,
    ["gitcommit"] = commit_buffer,
    ["NeogitCommitMessage"] = commit_buffer,
}

local filenames = as.p_table {
    ["option-window"] = presets.tool_panel,
}

as.ui.decorations = {}

---@alias ui.OptionValue (boolean | string)

---Get the as.ui setting for a particular filetype
function as.ui.decorations.get(opts)
    local ft, bt, fname, setting = opts.ft, opts.bt, opts.fname, opts.setting
    if (not ft and not bt and not fname) or not setting then
        return nil
    end
    return {
        ft = ft and filetypes[ft] and filetypes[ft][setting],
        bt = bt and buftypes[bt] and buftypes[bt][setting],
        fname = fname and filenames[fname] and filenames[fname][setting],
    }
end

---A helper to set the value of the colorcolumn option, to my preferences, this can be used
---in an autocommand to set the `vim.opt_local.colorcolumn` or by a plugin such as `virtcolumn.nvim`
---to set it's virtual column
-- function as.ui.decorations.set_colorcolumn(bufnr, fn)
--     local buf = vim.bo[bufnr]
--     local decor = as.ui.decorations.get {
--         ft = buf.ft,
--         bt = buf.bt,
--         setting = "colorcolumn",
--     }
--     if
--         buf.ft == ""
--         or buf.bt ~= ""
--         or decor.ft == false
--         or decor.bt == false
--     then
--         return
--     end
--     local ccol = decor.ft or decor.bt or ""
--     local virtcolumn = not as.falsy(ccol) and ccol or "+1"
--     if vim.is_callable(fn) then
--         fn(virtcolumn)
--     end
-- end

----------------------------------------------------------------------------------------------------
as.ui.current = { border = as.ui.border.line }

----------------------------------------------------------------------------------------------------
-- Filetypes
----------------------------------------------------------------------------------------------------

---Filetypes with Language Servers
as.lspfiles = {
    "bash",
    "sh",
    "zsh",
    "tex",
    "bib",
    "css",
    "cmake",
    "c",
    "cs",
    "cpp",
    "glsl",
    "objc",
    "opencl",
    "dart",
    "html",
    "javascript",
    "typescript",
    "java",
    "json",
    "jsonc",
    "lua",
    "make",
    "markdown",
    "org",
    "python",
    "rust",
    "toml",
    "yaml",
}
