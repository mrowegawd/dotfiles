---@return boolean|nil
local is_filetype_is_loclist = function()
  if vim.bo.filetype ~= "qf" then
    RUtils.warn "Not in qf filetype"
    return nil
  end

  if RUtils.qf.is_loclist() then
    return true
  end
  return false
end

---@param cmds { qf: string, lf: string }
---@return string|nil
local call_func = function(cmds)
  local is_ok = is_filetype_is_loclist()
  if is_ok == nil then
    return
  end

  if is_ok then
    return cmds.lf
  end

  return cmds.qf
end

local get_limit_qftf = function()
  local win_width = vim.api.nvim_win_get_width(0)
  return math.floor(win_width * 20 / 100)
end

return {
  -- QUICKER (disabled)
  { -- bisa menggunakan range -> %s/, jangan lupa di 'write' setelah delete range
    "stevearc/quicker.nvim",
    enabled = false,
    event = "VeryLazy",
    ft = "qf",
    opts = {
      opts = {
        number = true,
        signcolumn = "yes",
      },
      highlight = {
        -- Use treesitter highlighting
        treesitter = true,
        -- Use LSP semantic token highlighting
        lsp = true,
        -- Load the referenced buffers to apply more accurate highlights (may be slow)
        load_buffers = false,
      },

      borders = {
        vert = "│",

        -- Strong headers (antar file)
        strong_header = "─",
        strong_cross = "┼",
        strong_end = "┤",

        -- Soft headers (dalam file)
        soft_header = "┄", -- dashed light
        soft_cross = "┼",
        soft_end = "┤",
      },
    },
  },
  -- QFBOOKMARK
  {
    -- dir = "~/.local/src/nvim_plugins/qfbookmark",
    "MadKuntilanak/qfbookmark",
    event = "LazyFile",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      save_dir = RUtils.config.path.wiki_path .. "/orgmode/nvim-plugin/qfbookmark",
      picker = "fzf-lua",
      window = {
        theme = { qf = { enabled = true, limit = get_limit_qftf() } },
      },
      keymaps = {
        disable_all = false,
        actions = {
          mark_win_open = "go",
          buffers = "gb",
        },
        open_item = {
          default = {
            keys = { "o", "<CR>" },
            auto_close = false,
          },
        },
        note = {
          toggle_local_note = "<LocalLeader>an",
          toggle_global_note = "<LocalLeader>aN",
        },
        navigation = {
          mark = {
            next = "gn",
            prev = "gp",
          },
        },
        integrations = {
          cmdline_strings = {
            enabled = true,
            commands = {
              -- 🔧 Filter & Update (Quickfix)
              {
                key = "<LocalLeader>qc",
                cmd = function()
                  local str_cmd = call_func { qf = "Cfilter", lf = "Lfilter" }
                  if str_cmd then
                    local cmd = string.format([[:%s / /]], str_cmd)
                    vim.api.nvim_feedkeys(cmd, "n", false)
                  end
                end,
                desc = "Qf: run Cfilter or Lfilter",
                buffer = true,
              },
              {
                key = "<Localleader>qd",
                cmd = function()
                  local str_cmd = call_func { qf = "cdo", lf = "ldo" }
                  if str_cmd then
                    local cmd = string.format([[:%s %%s///gi | update]], str_cmd)
                    vim.api.nvim_feedkeys(cmd, "n", false)
                  end
                end,
                desc = "Qf: run cdo or ldo",
                buffer = true,
              },

              {
                key = "<Localleader>qf",
                cmd = function()
                  local str_cmd = call_func { qf = "cfdo", lf = "lfdo" }
                  if str_cmd then
                    local cmd = string.format([[:%s %%s///gi | update]], str_cmd)
                    vim.api.nvim_feedkeys(cmd, "n", false)
                  end
                end,
                desc = "Qf: run cfdo or lfdo",
                buffer = true,
              },
            },
          },
        },
      },
    },
  },
}
