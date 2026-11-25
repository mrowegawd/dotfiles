local add = require("vim-pack").add
local add_on_event = require("vim-pack").add_on_event
local on_plugin_update = require("vim-pack").on_plugin_update

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"
local UtilKey = lazy "utils.map"

-- Prepending nvim-treesitter's `runtime/` shadows Neovim's bundled queries for
-- every language, not just the ones listed below. Those queries track
-- nvim-treesitter's parser revisions, so any parser Neovim bundles has to be
-- reinstalled from nvim-treesitter or the two drift apart and stuff breaks.
local function install_list()
  local parsers = {
    "bash",
    "c",
    "cpp",
    "fish",
    "gitcommit",
    "go",
    "graphql",
    "html",
    "hyprlang",
    "java",
    "javascript",
    "json",
    "json5",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "rasi",
    "regex",
    "rust",
    "ini",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  }

  local set = {}
  for _, parser in ipairs(parsers) do
    set[parser] = true
  end

  local site = vim.fn.stdpath "data"
  for _, path in ipairs(vim.api.nvim_get_runtime_file("parser/*", true)) do
    -- Skip the parsers nvim-treesitter already installed under `site/`.
    if not vim.startswith(path, site) then
      set[vim.fn.fnamemodify(path, ":t:r")] = true
    end
  end

  return vim.tbl_keys(set)
end

-- Highlight, edit, and navigate code.
add {
  {
    src = "nvim-treesitter/nvim-treesitter",
    on_setup = function()
      -- Main-branch nvim-treesitter ships queries under `runtime/queries/`,
      -- which isn't on rtp by default. Prepend it so highlights/folds/indents
      -- are visible to `vim.treesitter.start`.
      local init = vim.api.nvim_get_runtime_file("lua/nvim-treesitter/init.lua", false)[1]
      if init then
        vim.opt.runtimepath:prepend(vim.fn.fnamemodify(init, ":h:h:h") .. "/runtime")
      end

      local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })
      local ignore_filetypes = {
        "checkhealth",
        "lazy",
        "mason",
        "noice",
        "snacks_dashboard",
        "snacks_notif",
        "snacks_win",
        "fzf",
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        desc = "Enable treesitter highlighting and indentation",
        callback = function(event)
          if vim.tbl_contains(ignore_filetypes, event.match) then
            return
          end

          -- Start highlighting immediately (works if parser exists)
          local ok = pcall(vim.treesitter.start)

          -- Enable treesitter indentation
          if ok then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}

local base_colorscheme = {
  lackluster = {
    kitty = {
      treesittercontext_alter = 0.4,
      -- snacksindentscope_alter = ,
    },
  },
  ["ef-cherie"] = {
    kitty = {
      snacksindentscope_alter = 0.8,
    },
  },
  gruvbox = {
    kitty = {
      snacksindentscope_alter = 0.25,
    },
  },
  ["ef-dream"] = {
    kitty = {
      snacksindentscope_alter = 0.2,
    },
    ["ghostty-cairo"] = {
      snacksindentscope_alter = 0.95,
    },
  },
  imli = {
    kitty = {
      snacksindentscope_alter = 0.15,
    },
  },
  jellybeans = {
    kitty = {
      snacksindentscope_alter = 0.3,
    },
  },
  techbase = {
    kitty = {
      snacksindentscope_alter = 0.3,
    },
    ["ghostty-cairo"] = {
      snacksindentscope_alter = 0.77,
    },
  },
  vscode = {
    kitty = {
      snacksindentscope_alter = 0.2,
    },
  },
  zenburn = {
    kitty = {
      snacksindentscope_alter = 0.1,
    },
    ["ghostty-cairo"] = {
      snacksindentscope_alter = 0.4,
    },
  },
  default = {
    kitty = {
      treesittercontext_alter = 0.15,
      snacksindentscope_alter = 0.35,
    },
    ["ghostty-cairo"] = {
      treesittercontext_alter = 0.1,
      snacksindentscope_alter = 0.9,
    },
  },
}

local function resolve_col_scope(colorscheme)
  local col1, col2
  local base = base_colorscheme[colorscheme]
  local base_default = base_colorscheme["default"]
  if not base then
    base = base_default
  end

  local col = base[(vim.env.TERMINAL):lower()]
  local colbase = base_default[(vim.env.TERMINAL):lower()]

  if col and col.treesittercontext_alter then
    col1 = col.treesittercontext_alter
  else
    col1 = colbase.treesittercontext_alter
  end

  if col and col.snacksindentscope_alter then
    col2 = col.snacksindentscope_alter
  else
    col2 = colbase.snacksindentscope_alter
  end

  return col1, col2
end

local treesittercontext_alter, snacksindentscope_alter = resolve_col_scope(vim.g.colorscheme)

add_on_event("UIEnter", {
  {
    src = "nvim-treesitter/nvim-treesitter-context",
    module_name = "treesitter-context",
    opts = function()
      local H = lazy "utils.highlights"

      H.plugin("treesitter-context", {
        theme = {
          ["*"] = {
            {
              TreesitterContext = {
                bg = {
                  from = "StatusLineTheme",
                  attr = "bg",
                  alter = treesittercontext_alter,
                },
              },
            },
            {
              TreesitterContextBottom = {
                fg = { from = "TreesitterContext", attr = "bg" },
                underline = true,
                sp = {
                  from = "TreesitterContext",
                  attr = "bg",
                  alter = 1,
                  transparency = 0.4,
                  color = {
                    from = "TreesitterContext",
                    attr = "bg",
                  },
                },
              },
            },
            {
              TreesitterContextLineNumber = {
                fg = { from = "LineNr", atrr = "fg" },
                bg = { from = "Normal", atrr = "bg" },
              },
            },
            {
              TreesitterContextLineNumberBottom = {
                fg = {
                  from = "TreesitterContext",
                  attr = "bg",
                  alter = 5,
                  transparency = 0.38,
                  color = { from = "TreesitterContext", attr = "bg" },
                },
              },
            },
            {
              SnacksIndentScope = {
                fg = { from = "TreesitterContext", attr = "bg", alter = snacksindentscope_alter },
                bg = "NONE",
              },
            },
          },
        },
      })
      return {
        -- Avoid the sticky context from growing a lot.
        max_lines = 0,
        -- Match the context lines to the source code.
        multiline_threshold = 1,
        -- Disable it when the window is too small.
        min_window_height = 20,

        mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
        line_numbers = false,

        on_attach = function(bufnr)
          -- Check if buffer or window is invalid
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return false
          end

          -- Skip floating windows
          local win_config = vim.api.nvim_win_get_config(0)
          if win_config.relative ~= "" then
            return false
          end

          -- Skip special buffers
          local bt = vim.bo[bufnr].buftype
          if bt == "nofile" or bt == "prompt" then
            return false
          end

          -- Skip certain filetypes
          local ft = vim.bo[bufnr].filetype
          local excluded_fts = { "fugitive", "gitcommit", "TelescopePrompt", "markdown", "octo", "help" }
          if vim.tbl_contains(excluded_fts, ft) then
            return false
          end

          -- Skip diff mode
          if vim.wo.diff then
            return false
          end

          -- Skip when window height is too small
          if vim.fn.winheight(0) < 30 then
            return false
          end

          return true
        end,
      }
    end,
  },
})

UtilKey.nnoremap("<Leader>ut", function()
  local tsc = lazy "treesitter-context"
  tsc.toggle()
  if lazy("utils.inject").get_upvalue(tsc.toggle, "enabled") then
    Log.info "Enabled Treesitter Context"
  else
    Log.warn "Disabled Treesitter Context"
  end
end, { desc = "Toggle: treesitter context" })

UtilKey.nnoremap("<Leader>jc", function()
  if vim.wo.diff then
    return "[c"
  else
    vim.schedule(function()
      lazy("treesitter-context").go_to_context()
    end)

    vim.cmd "normal! zt" -- move the cursor line to the top of the window
    return "<Ignore>"
  end
end, { desc = "Jump: treesitter context and align to top" })

on_plugin_update("nvim-treesitter", function()
  local treesitter = lazy "nvim-treesitter"

  -- Re-install and update parsers.
  treesitter.install(install_list()):wait(300000)
  treesitter.update():wait(300000)
end)
