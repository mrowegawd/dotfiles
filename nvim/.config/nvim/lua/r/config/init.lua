_G.RUtils = require "r.utils"

local fmt = string.format

local M = {}

---@class LazyVimConfig: LazyVimOptions
RUtils.config = M

local home = os.getenv "HOME"
local dropbox_path = fmt("%s/Dropbox", home, "Dropbox")
if RUtils.platform.is_wsl then
  dropbox_path = "/mnt/c/Users/moxli/Dropbox"
end
local snippet_path = dropbox_path .. "/snippets-for-all"

local colorscheme = "habamax"

_G.base = {}

local base_options = {
  g = {
    -- All these options are toggleable with <space + l + u>
    autoformat_enabled = false, -- Enable auto formatting at start.
    cmp_enabled = true, -- Enable completion at start.
    codelens_enabled = true, -- Enable automatic codelens refreshing for lsp that support it.
    inlay_hints_enabled = false, -- Enable always show function parameter names.
    lsp_signature_enabled = false, -- Enable automatically showing lsp help as you write function parameters.
    notifications_enabled = true, -- Enable notifications.
    semantic_tokens_enabled = true, -- Enable lsp semantic tokens at start.
    url_effect_enabled = true, -- Highlight URLs with an underline effect.
    autoformat = true, -- Highlight URLs with an underline effect.
    colorscheme = colorscheme, -- Highlight URLs with an underline effect.
    inlay_hints = true, -- Highlight URLs with an underline effect.
    snacks_jump_scope = false,
    -- lightthemes = { "dawnfox", "rose-pine-dawn", "rose-pine", "base46-seoul256_dark", "base46-zenburn" },
    lightthemes = { "dawnfox", "rose-pine-dawn", "rose-pine", "base46-material-lighter" },
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
  ---@type string|fun()
  colorscheme = colorscheme,
  path = {
    dropbox_path = dropbox_path,
    wiki_path = fmt("%s/neorg", dropbox_path),
    snippet_path = snippet_path,
    home = home,
  },

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
  icons = {
    border = {
      rectangle = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      line = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      rightsideonly = { "", "", "", "", "", "", "", "│" },
    },
    misc = {
      ai = " ",
      dots = "󰇘",
      arrow_right = " ",
      block = "▌ ",

      bookmark = " ",
      org = " ",
      norg = " ",
      markdown = "󰍔 ",

      marks = "📌",
      flags = "🚩",
      cross_sign = "❌",
      checklist = "✅",

      bug = " ", --  'ﴫ'
      calendar = " ",
      caret_right = " ",
      check = " ",
      check_big = " ",
      chevron_right = " ",
      circle = " ",
      clock = " ",
      close = " ",
      boldclose = " ",
      modified = "✘ ",
      largeclose = " ",
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
      todo = " ",
      note = " ",
      -- note = " ",
      package = "  ",
      pencil = " ", -- '',
      plus = " ",
      project = " ",
      folder = " ",
      session = "󰅟 ",
      question = " ",
      robot = "ﮧ ",
      search = " ",
      readonly = "󰌾 ",
      shaded_lock = " ",
      sign_in = " ",
      sign_out = " ",
      smiley = "ﲃ ",
      squirrel = " ",
      tab = "⇥ ",
      table = " ",
      telescope = " ",
      telescope2 = " ",
      telescope3 = " ",
      terminal = " ",
      terminal2 = " ",
      tools = " ",
      up = "⇡ ",
      lsp = " ",

      Neovim = " ",
      Vim = " ",

      tag = " ",
      watch = " ",
      run_program = "省",

      separator_up = "",
      separator_down = "",

      separator_leg_down = "",
      separator_leg_up = "",

      separator_leg_left = "",
      -- "" },

      separator_hed_down = "",
      separator_hed_up = "",
    },

    dap = {
      Stopped = "󰁕 ",
      Breakpoint = " ",
      BreakpointCondition = " ",
      BreakpointRejected = " ",
      LogPoint = ".>",
      Pause = " ",
      Play = " ",
      Step_into = " ",
      Step_over = " ",
      Step_out = " ",
      Step_back = " ",
      Run_last = " ",
      Terminate = " ",
      Debug = " ",
      Trace = "✎ ",
    },
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      -- Question = " ",
      Info = " ",
    },
    documents = {
      file = "",
      files = "",
      folder = "",
      openfolder = "",
      emptyfolder = "",
      emptyopenfolder = "",
      unknown = "",
      symlink = "",
      foldersymlink = "",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
      untrack = " ",
      unmerged = " ",

      add = " ", -- ' ',
      mod = " ",
      remove = " ", -- ' '
      ignore = " ",
      rename = " ",
      diff = " ",
      repo = " ",
      logo = " ",
      branch = " ",
    },
    kinds = {
      Array = " ",
      Boolean = "󰨙 ",
      Class = " ",
      Codeium = "󰘦 ",
      Color = " ",
      Control = " ",
      Collapsed = " ",
      Constant = "󰏿 ",
      Component = "󰅴 ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ", -- " "
      Event = " ",
      Field = " ", -- " "

      -- Method = " ",
      -- Function = " ",
      -- Constructor = " ",
      Method = "󰆧 ", -- taken from "lspkind" plugin
      Function = "󰊕 ",
      Constructor = " ",

      File = " ",
      Folder = " ",
      Interface = " ", -- " "
      Fragment = "󰅴 ",
      Macro = " ",
      Key = " ",
      Keyword = " ",
      Module = " ", -- " "
      StaticMethod = " ",
      Namespace = "󰦮 ",
      Null = " ",
      Number = "󰎠 ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ", -- " "
      Reference = " ",
      Snippet = " ", --"󱄽 "
      String = " ", -- " " "﬌ "
      Struct = " ", -- " " "󰆼 "
      TabNine = "󰏚 ",
      TypeParameter = " ",
      Parameter = " ",
      Unit = " ",
      TypeAlias = " ",
      Text = " ",
      Value = " ",
      Variable = " ", -- "󰀫 ",
      stacked = "﬘ ",
    },
  },
  ---@type table<string, string[]|boolean>?
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
    markdown = false,
    help = false,
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
  version = 8,
  loaded = false,
  path = vim.g.lazyvim_json or vim.fn.stdpath "config" .. "/lazyvim.json",
  data = {
    version = nil, ---@type number?
    install_version = nil, ---@type number?
    news = {}, ---@type table<string, string>
    extras = {}, ---@type string[]
  },
}

function M.json.load()
  M.json.loaded = true
  local f = io.open(M.json.path, "r")
  if f then
    local data = f:read "*a"
    f:close()
    local ok, json = pcall(vim.json.decode, data, { luanil = { object = true, array = true } })
    if ok then
      M.json.data = vim.tbl_deep_extend("force", M.json.data, json or {})
      if M.json.data.version ~= M.json.version then
        RUtils.json.migrate()
      end
    end
  else
    M.json.data.install_version = M.json.version
  end
end

---@type LazyVimOptions
local options
local lazy_clipboard

---@param opts? LazyVimOptions
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
      M.load "keymaps"
      if lazy_clipboard ~= nil then
        vim.opt.clipboard = lazy_clipboard
      end

      RUtils.format.setup()
      -- RUtils.news.setup()
      RUtils.root.setup()

      vim.api.nvim_create_user_command("LazyExtras", function()
        RUtils.extras.show()
      end, { desc = "Manage LazyVim extras" })

      vim.api.nvim_create_user_command("LazyHealth", function()
        vim.cmd [[Lazy! load all]]
        vim.cmd [[checkhealth]]
      end, { desc = "Load all plugins and run :checkhealth" })

      local health = require "lazy.health"
      vim.list_extend(health.valid, {
        "recommended",
        "desc",
        "vscode",
      })

      if vim.g.lazyvim_check_order == false then
        return
      end

      -- Check lazy.nvim import order
      local imports = require("lazy.core.config").spec.modules
      local function find(pat, last)
        for i = last and #imports or 1, last and 1 or #imports, last and -1 or 1 do
          if imports[i]:find(pat) then
            return i
          end
        end
      end
      local lazyvim_plugins = find "^r%.plugins$"
      local extras = find("^r%.plugins%.extras%.", true) or lazyvim_plugins
      local plugins = find "^plugins$" or math.huge
      if lazyvim_plugins ~= 1 or extras > plugins then
        local msg = {
          "The order of your `lazy.nvim` imports is incorrect:",
          "- `lazyvim.plugins` should be first",
          "- followed by any `lazyvim.plugins.extras`",
          "- and finally your own `plugins`",
          "",
          "If you think you know what you're doing, you can disable this check with:",
          "```lua",
          "vim.g.lazyvim_check_order = false",
          "```",
        }
        vim.notify(table.concat(msg, "\n"), "warn", { title = "RUtils" })
      end
    end,
  })

  RUtils.track "colorscheme"
  RUtils.try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      RUtils.error(msg)
      vim.cmd.colorscheme "habamax"
    end,
  })
  RUtils.track()
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
  if type(M.kind_filter[ft]) == "table" then
    return M.kind_filter[ft]
  end
  ---@diagnostic disable-next-line: return-type-mismatch
  return type(M.kind_filter) == "table" and type(M.kind_filter.default) == "table" and M.kind_filter.default or nil
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      RUtils.try(function()
        require(mod)
      end, { msg = "Failed loading " .. mod })
    end
  end
  local pattern = "RUtils" .. name:sub(1, 1):upper() .. name:sub(2)
  -- always load lazyvim, then user file
  if M.defaults[name] or name == "options" then
    _load("r.config." .. name)
    vim.api.nvim_exec_autocmds("User", { pattern = pattern .. "Defaults", modeline = false })
  end
  _load("config." .. name)
  if vim.bo.filetype == "lazy" then
    -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd [[do VimResized]]
  end
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
M._options = {} ---@type vim.wo|vim.bo

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
    RUtils.deprecate([[require("r.plugins.lsp.format")]], [[RUtils.format]])
    return RUtils.format
  end

  -- delay notifications till vim.notify was replaced or after 500ms
  RUtils.lazy_notify()

  -- load options here, before lazy init while sourcing plugin modules
  -- this is needed to make sure options will be correctly applied
  -- after installing missing plugins
  M.load "options"

  -- save some options to track defaults
  M._options.indentexpr = vim.o.indentexpr
  M._options.foldmethod = vim.o.foldmethod
  M._options.foldexpr = vim.o.foldexpr

  -- defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
  lazy_clipboard = vim.opt.clipboard:get()
  vim.opt.clipboard = ""

  if vim.g.deprecation_warnings == false then
    vim.deprecate = function() end
  end

  RUtils.plugin.setup()
  M.json.load()

  require "r.config.colors"
end

---@alias LazyVimDefault {name: string, extra: string, enabled?: boolean, origin?: "global" | "default" | "extra" }

local default_extras ---@type table<string, LazyVimDefault>

---@param name string
---@param extras LazyVimDefault[]
function M.register_defaults(name, extras)
  assert(default_extras, "defaults should be loaded by now, this should never happen")
  local valid = vim.tbl_map(function(extra)
    return extra.name
  end, extras) --[[@as string[] ]]

  local origin = "default"
  local ret ---@type LazyVimDefault?
  local use ---@type string?

  local global = vim.g["lazyvim_" .. name]
  if vim.tbl_contains(valid, global) then
    origin = "global" -- was set by the user in their config
    use = global
  else
    if global and global ~= "auto" then
      vim.notify(
        ("Invalid value for `vim.g.lazyvim_%s`: `%s`\nValid options are: %s"):format(
          name,
          global,
          table.concat(valid, ", ")
        ),
        vim.log.levels.ERROR,
        { title = "LazyVim" }
      )
    end
    for _, extra in ipairs(extras) do
      if RUtils.has_extra(extra.extra) then
        use = extra.name -- was imported by the user in their lazy spec or added by LazyExtras
        origin = "extra"
        break
      end
    end
  end

  use = use or valid[1] -- fallback to the first one if nothing was set

  for _, extra in ipairs(extras) do
    local import = "r.plugins.extras." .. extra.extra
    extra = vim.deepcopy(extra)
    extra.enabled = extra.name == use
    extra.import = import
    extra.group = name
    if extra.enabled then
      extra.origin = origin
      ret = extra
    end
    default_extras[import] = extra
  end

  return assert(ret, "One of the extras should be enabled, this should never happen")
end

function M.get_defaults()
  if default_extras then
    return default_extras
  end
  ---@type table<string, LazyVimDefault[]>
  local checks = {
    picker = {
      { name = "snacks", extra = "editor.snacks_picker" },
      { name = "fzf", extra = "editor.fzf" },
      { name = "telescope", extra = "editor.telescope" },
    },
    cmp = {
      { name = "blink.cmp", extra = "coding.blink" },
      { name = "nvim-cmp", extra = "coding.nvim-cmp" },
    },
    explorer = {
      { name = "snacks", extra = "editor.snacks_explorer" },
      { name = "neo-tree", extra = "editor.neo-tree" },
    },
  }

  -- existing installs keep their defaults
  if (RUtils.config.json.data.install_version or 7) < 8 then
    table.insert(checks.picker, 1, table.remove(checks.picker, 2))
    table.insert(checks.explorer, 1, table.remove(checks.explorer, 2))
  end

  default_extras = {}
  for name, check in pairs(checks) do
    local valid = {} ---@type string[]
    for _, extra in ipairs(check) do
      if extra.enabled ~= false then
        valid[#valid + 1] = extra.name
      end
    end
    local origin = "default"
    local use = vim.g["lazyvim_" .. name]
    use = vim.tbl_contains(valid, use or "auto") and use or nil
    origin = use and "global" or origin
    for _, extra in ipairs(use and {} or check) do
      if extra.enabled ~= false and RUtils.has_extra(extra.extra) then
        use = extra.name
        break
      end
    end
    origin = use and "extra" or origin
    use = use or valid[1]
    for _, extra in ipairs(check) do
      local import = "r.plugins.extras." .. extra.extra
      extra = vim.deepcopy(extra)
      extra.enabled = extra.name == use
      if extra.enabled then
        extra.origin = origin
      end
      default_extras[import] = extra
    end
  end
  return default_extras
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    ---@cast options LazyVimConfig
    return options[key]
  end,
})

return M
