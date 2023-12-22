local fmt = string.format

local Util = require "r.utils"

local M = {}

local home = os.getenv "HOME"
local dropbox_path = fmt("%s/Dropbox", home, "Dropbox")
local snippet_path = dropbox_path .. "/friendly-snippets"

local colorscheme = "catppuccin"

_G.base = {}

local base_options = {
  g = {
    -- All these options are toggleable with <space + l + u>
    autoformat_enabled = false, -- Enable auto formatting at start.
    autopairs_enabled = false, -- Enable autopairs at start.
    cmp_enabled = true, -- Enable completion at start.
    codelens_enabled = true, -- Enable automatic codelens refreshing for lsp that support it.
    diagnostics_mode = 3, -- Set code linting (0=off, 1=only show in status line, 2=virtual text off, 3=all on).
    icons_enabled = true, -- Enable icons in the UI (disable if no nerd font is available).
    inlay_hints_enabled = false, -- Enable always show function parameter names.
    lsp_signature_enabled = false, -- Enable automatically showing lsp help as you write function parameters.
    notifications_enabled = true, -- Enable notifications.
    semantic_tokens_enabled = true, -- Enable lsp semantic tokens at start.
    url_effect_enabled = true, -- Highlight URLs with an underline effect.
    autoformat = true, -- Highlight URLs with an underline effect.
  },
}

for scope, table in pairs(base_options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end

---@class LazyVimOptions
local defaults = {
  lsp_style = "", -- coc, coq, or "" (for default lsp)
  -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
  -- colorscheme = function()
  --   require("tokyonight").load()
  -- end,
  path = {
    dropbox_path = fmt("%s/Dropbox", home, "Dropbox"),
    wiki_path = fmt("%s/neorg", dropbox_path),
    snippet_path = snippet_path,
  },

  colorscheme = colorscheme,

  -- load the default settings
  defaults = {
    autocmds = true, -- lazyvim.config.autocmds
    keymaps = true, -- lazyvim.config.keymaps
    -- lazyvim.config.options can't be configured here since that's loaded before lazyvim setup
    -- if you want to disable loading options, add `package.loaded["lazyvim.config.options"] = true` to the top of your init.lua
  },
  news = {
    -- When enabled, NEWS.md will be shown when changed.
    -- This only contains big new features and breaking changes.
    lazyvim = true,
    -- Same but for Neovim's news.txt
    neovim = false,
  },
  vimgrep_arguments = {
    "rg",
    "--hidden",
    "--follow",
    "--no-ignore-vcs",
    "-g",
    "!{node_modules,.git,__pycache__,.pytest_cache}",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
  },
  -- icons used by other plugins
  -- stylua: ignore
  icons = {
    border = {
      line = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
      rectangle = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    },
    misc = {
      dots = "󰇘",
      arrow_right = " ",
      block = "▌ ",
      bookmark = " ",
      bug = " ", --  'ﴫ'
      calendar = " ",
      caret_right = " ",
      check = " ",
      check_big = " ",
      chevron_right = " ",
      circle = " ",
      clock = " ",
      close = " ",
      code = " ",
      comment = " ",
      dashboard = " ",
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
      robot = "ﮧ ",
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
    dap = {
      -- Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      -- Breakpoint          = " ",
      -- BreakpointCondition = " ",
      -- BreakpointRejected  = { " ", "DiagnosticError" },
      Breakpoint = ' ',
      -- Breakpoint           = " ",  -- " "
      BreakpointCondition  = " ",
      BreakpointRejected   = " ",
      LogPoint            = ".>",
      Stopped              = "󰁕 ",
      Pause                = " ",
      Play                 = " ",
      Step_into            = " ",
      Step_over            = " ",
      Step_out             = " ",
      Step_back            = " ",
      Run_last             = " ",
      Terminate            = " ",
    },
    diagnostics = {
      Error    = " ",
      Warn     = " ",
      Hint     = " ",
      -- Question = " ",
      Info     = " ",
    },
    git = {
      added    = " ",
      modified = " ",
      removed  = " ",

      add      = " ", -- '',
      mod      = " ",
      remove   = " ", -- '',
      ignore   = " ",
      rename   = " ",
      diff     = " ",
      repo     = " ",
      logo     = " ",
      branch   = " ",
    },
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = " ",
      String        = " ",
      Struct        = "󰆼 ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",
      stacked       = " ﬘",
    },
  },
  palette = {
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
    dots = "󰇘",
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
  ---@type table<string, string[]>?
  kind_filter = {
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    -- you can specify a different filter for each filetype
    lua = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      -- "Package", -- remove package since luals uses it for control flow structures
      "Property",
      "Struct",
      "Trait",
    },
  },
}

M.json = {
  version = 2,
  data = {
    version = nil, ---@type string?
    news = {}, ---@type table<string, string>
    extras = {}, ---@type string[]
  },
}

local options

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

  -- autocmds can be loaded lazily when not opening a file
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load "autocmds"
  end

  local group = vim.api.nvim_create_augroup("LazyVim", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load "autocmds"
      end
      require "r.keymaps.general"

      Util.format.setup()
      -- Util.news.setup()

      vim.api.nvim_create_user_command("LazyRoot", function()
        Util.root.info()
      end, { desc = "LazyVim roots for the current buffer" })

      -- vim.api.nvim_create_user_command("LazyExtras", function()
      --   Util.extras.show()
      -- end, { desc = "Manage LazyVim extras" })
    end,
  })

  Util.track "colorscheme"
  Util.try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      Util.error(msg)
      vim.cmd.colorscheme "habamax"
    end,
  })
  Util.track()
end

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if M.kind_filter == false then
    return
  end
  if M.kind_filter[ft] == false then
    return
  end
  ---@diagnostic disable-next-line: return-type-mismatch
  return type(M.kind_filter) == "table" and type(M.kind_filter.default) == "table" and M.kind_filter.default or nil
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      Util.try(function()
        require(mod)
      end, { msg = "Failed loading " .. mod })
    end
  end
  -- always load lazyvim, then user file
  if M.defaults[name] or name == "options" then
    _load("r.config." .. name)
  end
  _load("config." .. name)

  if vim.bo.filetype == "lazy" then
    -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd [[do VimResized]]
  end
  local pattern = "LazyVim" .. name:sub(1, 1):upper() .. name:sub(2)
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true
  local plugin = require("lazy.core.config").spec.plugins.LazyVim
  if plugin then
    vim.opt.rtp:append(plugin.dir)
  end

  package.preload["r.plugins.lsp.format"] = function()
    Util.deprecate([[require("r.plugins.lsp.format")]], [[require("r.utils").format]])
    return Util.format
  end

  -- delay notifications till vim.notify was replaced or after 500ms
  require("r.utils").lazy_notify()

  -- load options here, before lazy init while sourcing plugin modules
  -- this is needed to make sure options will be correctly applied
  -- after installing missing plugins
  M.load "options"

  Util.plugin.setup()

  require "r.config.colors"
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    return options[key]
  end,
})

return M
