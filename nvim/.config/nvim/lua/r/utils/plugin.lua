local Plugin = require "lazy.core.plugin"
local fmt, cmd = string.format, vim.cmd

local L = vim.log.levels

local Highlight = require "r.settings.highlights"

---@class r.utils.plugin
local M = {}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

---@type table<string, string>
M.deprecated_extras = {
  ["r.plugins.extras.formatting.conform"] = "`conform.nvim` is now the default **LazyVim** formatter.",
  ["r.plugins.extras.linting.nvim-lint"] = "`nvim-lint` is now the default **LazyVim** linter.",
  ["r.plugins.extras.ui.dashboard"] = "`dashboard.nvim` is now the default **LazyVim** starter.",
}

M.deprecated_modules = {
  ["nvim-navic.lib"] = "editor.navic",
  ["nvim-navic"] = "editor.navic",
}

---@type table<string, string>
M.renames = {
  ["windwp/nvim-spectre"] = "nvim-pack/nvim-spectre",
  ["romgrk/nvim-treesitter-context"] = "nvim-treesitter/nvim-treesitter-context",
  ["glepnir/dashboard-nvim"] = "nvimdev/dashboard-nvim",
}

function M.save_core()
  if vim.v.vim_did_enter == 1 then
    return
  end
  M.core_imports = vim.deepcopy(require("lazy.core.config").spec.modules)
end

function M.setup()
  M.fix_imports()
  M.fix_renames()
  M.lazy_file()
  ---@diagnostic disable-next-line: deprecated
  table.insert(package.loaders, function(module)
    if M.deprecated_modules[module] then
      RUtils.warn(
        ("`%s` is no longer included by default in **LazyVim**.\nPlease install the `%s` extra if you still want to use it."):format(
          module,
          M.deprecated_modules[module]
        ),
        { title = "LazyVim" }
      )
      return function() end
    end
  end)
end

function M.extra_idx(name)
  local Config = require "lazy.core.config"
  for i, extra in ipairs(Config.spec.modules) do
    if extra == "r.plugins.extras." .. name then
      return i
    end
  end
end

-- Properly load file based plugins without blocking the UI
function M.lazy_file()
  -- This autocmd will only trigger when a file was loaded from the cmdline.
  -- It will render the file as quickly as possible.
  vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function(event)
      -- Skip if we already entered vim
      if vim.v.vim_did_enter == 1 then
        return
      end

      -- Try to guess the filetype (may change later on during Neovim startup)
      local ft = vim.filetype.match { buf = event.buf }
      if ft then
        -- Add treesitter highlights and fallback to syntax
        local lang = vim.treesitter.language.get_lang(ft)
        if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
          vim.bo[event.buf].syntax = ft
        end

        -- Trigger early redraw
        vim.cmd [[redraw]]
      end
    end,
  })

  -- Add support for the LazyFile event
  local Event = require "lazy.core.handler.event"

  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

function M.fix_imports()
  Plugin.Spec.import = RUtils.inject.args(Plugin.Spec.import, function(_, spec)
    local dep = M.deprecated_extras[spec and spec.import]
    if dep then
      dep = dep .. "\n" .. "Please remove the extra to hide this warning."
      RUtils.warn(dep, { title = "LazyVim", once = true, stacktrace = true, stacklevel = 6 })
      return false
    end
  end)
end

function M.fix_renames()
  Plugin.Spec.add = RUtils.inject.args(Plugin.Spec.add, function(self, plugin)
    if type(plugin) == "table" then
      if M.renames[plugin[1]] then
        RUtils.warn(
          ("Plugin `%s` was renamed to `%s`.\nPlease update your config for `%s`"):format(
            plugin[1],
            M.renames[plugin[1]],
            self.importing or "LazyVim"
          ),
          { title = "LazyVim" }
        )
        plugin[1] = M.renames[plugin[1]]
      end
    end
  end)
end

--  ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--  ╏                           test                           ╏
--  ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--- Opens the given url in the default browser.
---@param url string: The url to open.
function M.open_in_browser(url)
  local open_cmd
  if vim.fn.executable "xdg-open" == 1 then
    open_cmd = "xdg-open"
  elseif vim.fn.executable "explorer" == 1 then
    open_cmd = "explorer"
  elseif vim.fn.executable "open" == 1 then
    open_cmd = "open"
  elseif vim.fn.executable "wslview" == 1 then
    open_cmd = "wslview"
  end

  local ret = vim.fn.jobstart({ open_cmd, url }, { detach = true })
  if ret <= 0 then
    vim.notify(
      string.format("[utils]: Failed to open '%s'\nwith command: '%s' (ret: '%d')", url, open_cmd, ret),
      vim.log.levels.ERROR,
      { title = "[tt.utils]" }
    )
  end
end

function M.EditSnippet()
  local scan = require "plenary.scandir"

  local base_snippets = { "package", "global" }

  local ft, _ = RUtils.buf.get_bo_buft()

  if ft == "" then
    return vim.notify("Belum dibuat??", L.WARN, { title = "No snippets" })
  elseif ft == "typescript" then
    ft = "javascript"
  elseif ft == "sh" then
    ft = "shell"
  end

  local ft_snippet_path = RUtils.config.path.snippet_path .. "/snippets/"

  local snippets = {}
  local is_file = true

  if RUtils.file.is_dir(ft_snippet_path .. ft) then
    if not RUtils.file.exists(ft_snippet_path .. ft) then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end
    -- Untuk akses ke snippet khusus dir harus di tambahkan ext sama `ft` nya
    -- e.g path/ft-nya/<snippet.json>
    ft_snippet_path = ft_snippet_path .. ft .. "/"

    local dirs = scan.scan_dir(ft_snippet_path, { depth = 1, search_pattern = "json" })
    for _, sp in pairs(dirs) do
      local nm = sp:match "[^/]*.json$"
      local sp_e = nm:gsub(".json", "")
      table.insert(snippets, sp_e)
    end

    for _, sp in pairs(base_snippets) do
      table.insert(snippets, sp)
    end
  else
    snippets = { ft }

    if not RUtils.file.exists(ft_snippet_path .. ft .. ".json") then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end
    if not RUtils.file.exists(ft_snippet_path .. ft .. ".json") then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end

    for _, sp in pairs(base_snippets) do
      table.insert(snippets, sp)
    end
  end

  vim.ui.select(snippets, { prompt = "Edit snippet> " }, function(choice)
    if choice == nil then
      return
    end
    if is_file then
      if not RUtils.file.exists(ft_snippet_path .. choice .. ".json") then
        return vim.notify(ft_snippet_path .. choice .. ".json", L.WARN, { title = "Snippet file not exists" })
      end
      cmd(":edit " .. ft_snippet_path .. choice .. ".json")
    end
  end)
end

function M.change_colors()
  local statusline_fg = Highlight.tint(Highlight.get("WinSeparator", "fg"), 0.7)

  local lazygit_selected_line_bg = Highlight.get("LazygitselectedLineBgColor", "bg")
  local lazygit_inactive_border = Highlight.get("LazygitInactiveBorderColor", "fg")
  local lazygit_active_border = Highlight.get("KeywordNC", "fg")
  local lazygit_border_fg = Highlight.tint(Highlight.get("WinSeparator", "fg"), 0.2)

  local gitadd = Highlight.get("diffAdd", "bg")
  local gitlinenumber_add = Highlight.darken(Highlight.get("GitSignsAdd", "fg"), 0.4, Highlight.get("Normal", "bg"))

  local gitdelete = Highlight.get("diffDelete", "bg")
  local gitlinenumber_delete =
    Highlight.darken(Highlight.get("GitSignsDelete", "fg"), 0.6, Highlight.get("Normal", "bg"))

  local sugest_highlight = Highlight.tint(Highlight.get("StatusLineNC", "fg"), -0.49)

  local yazi_cwd = Highlight.get("Comment", "fg")
  local yazi_hovered = Highlight.get("CursorLine", "bg")
  local yazi_tab_active_fg = Highlight.get("KeywordNC", "fg")
  local yazi_tab_active_bg = Highlight.get("KeywordNC", "bg")
  local yazi_tab_inactive_fg = Highlight.get("TabLine", "fg")
  local yazi_tab_inactive_bg = Highlight.get("TabLine", "bg")
  local yazi_statusline_active_bg = Highlight.get("KeywordBlur", "bg")
  local yazi_statusline_active_fg = Highlight.get("StatusLineNC", "bg")
  local yazi_directory = Highlight.get("Directory", "fg")
  local yazi_filename_fg = Highlight.get("StatusLine", "fg")
  local yazi_which_bg = Highlight.get("Pmenu", "bg")

  local zsh_background_bg = Highlight.get("StatusLineNC", "bg")

  if vim.tbl_contains(vim.g.lightthemes, vim.g.colorscheme) then
    lazygit_selected_line_bg = Highlight.darken(Highlight.get("Keyword", "fg"), 0.8, Highlight.get("Normal", "bg"))
    statusline_fg = Highlight.tint(Highlight.get("WinSeparator", "fg"), -0.1)

    lazygit_active_border = Highlight.tint(Highlight.get("WinSeparator", "fg"), -0.5) -- 29
    lazygit_inactive_border = Highlight.tint(Highlight.get("Keyword", "fg"), 1.5) -- 30
    lazygit_border_fg = Highlight.tint(Highlight.get("FzfLuaBorder", "fg"), 0.1) -- 31

    sugest_highlight = Highlight.darken(Highlight.get("BlinkCmpGhostText", "fg"), 0.8, Highlight.get("Normal", "bg"))
  end

  local master_colors = fmt(
    [[
%s
! -----------------------------

%s
*color16: %s
*color17: %s

%s
*color18: %s
*color19: %s

%s
*color20: %s
*color21: %s

%s
*color22: %s
*color23: %s
*color24: %s

%s
*color25: %s
*color26: %s
*color27: %s

%s
*color28: %s

%s
*color29: %s
*color30: %s
*color31: %s
*color32: %s

%s
*color33: %s
*color34: %s

%s
*color35: %s
*color36: %s

%s
*color37: %s

%s
*color38: %s
*color39: %s
*color40: %s
*color41: %s
*color42: %s
*color43: %s

%s
*color44: %s
*color45: %s
*color46: %s
*color47: %s
*color48: %s

%s
*color49: %s
]],
    fmt "! vim: foldmethod=marker foldlevel=0 ft=xdefaults",

    fmt "! State color: bg, fg",
    Highlight.get("KeywordNC", "bg"), -- 16
    Highlight.get("KeywordNC", "fg"), -- 17

    fmt "! TMUX: border_fg_nc, border_fg",
    Highlight.get("WinSeparator", "fg"), -- 19
    statusline_fg, -- 18

    fmt "! TMUX: tmux_bg, tmux_fg",
    Highlight.get("Normal", "bg"), -- 20
    Highlight.get("Tabline", "fg"), -- 21

    fmt "! FZF-NORMAL: bg, fg, match",
    Highlight.get("FzfLuaNormal", "bg"), -- 22
    Highlight.get("FzfLuaFilePart", "fg"), -- 23
    Highlight.get("CmpItemAbbrMatch", "fg"), --24

    fmt "! FZF-SELECTION: bg, fg, match",
    Highlight.get("FzfLuaSel", "bg"), -- 25
    Highlight.get("FzfLuaSel", "fg"), -- 26
    Highlight.get("CmpItemAbbrMatchFuzzy", "fg"), --27

    fmt "! FZF: border",
    Highlight.get("FzfLuaBorder", "fg"), -- 28

    fmt "! LAZYGIT: active_border_color, inactive_border_color, options_text_color, selected_line_bg_color",
    lazygit_active_border, -- 29
    lazygit_inactive_border, -- 30
    lazygit_border_fg, -- 31
    lazygit_selected_line_bg, -- 32

    fmt "! DELTA: plus-style, plus-emph-style",
    gitadd, -- 33
    gitlinenumber_add, -- 34

    fmt "! DELTA: minus-style, minus-emph-style",
    gitdelete, -- 36
    gitlinenumber_delete, -- 35

    fmt "! zsh-autosuggestions: fg",
    sugest_highlight, -- 37

    fmt "! yazi: cwd, hovered, tab_active_fg, tab_active_bg, tab_inactive_bg, tab_inactive_fg",
    yazi_cwd, -- 38
    yazi_hovered, -- 39
    yazi_tab_active_fg, -- 40
    yazi_tab_active_bg, -- 41
    yazi_tab_inactive_fg, -- 42
    yazi_tab_inactive_bg, -- 43

    fmt "! yazi: statusline_mode_active_bg, statusline_active_bg, directory, which_bg, filename_fg",
    yazi_statusline_active_bg, -- 44
    yazi_statusline_active_fg, -- 45
    yazi_directory, -- 46
    yazi_which_bg, -- 47
    yazi_filename_fg, -- 48

    fmt "! zsh: zsh_background_bg",
    zsh_background_bg -- 49
  )

  local master_color_path = "/tmp/master-colors-themes"

  if RUtils.file.is_file(master_color_path) then
    vim.fn.system(fmt("rm %s", master_color_path))
  end

  local fp = io.open(master_color_path, "a")
  if fp then
    fp:write(master_colors)
    fp:close()
  end
end

function M.infoFoldPreview()
  vim.cmd "options"
end

return M
