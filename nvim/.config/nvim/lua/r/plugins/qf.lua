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

return {
  -- QUICKER
  { -- bisa menggunakan range -> %s/, jangan lupa di 'write' setelah delete range
    "stevearc/quicker.nvim",
    event = "VeryLazy",
    ft = "qf",
    opts = {
      opts = {
        number = true,
        signcolumn = "yes",
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
    dir = "~/.local/src/nvim_plugins/qfbookmark",
    -- "MadKuntilanak/qfbookmark",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      save_dir = RUtils.config.path.wiki_path .. "/orgmode/nvim-plugin/qfbookmark",
      picker = "fzf-lua",
      -- window = {
      --   note = {
      --     -- open_cmd = "botright vsplit",
      --     -- size_split = 12,
      --     -- size_vsplit = 50,
      --     filetype = "markdown", -- Ex: "orgmode" "norg", "markdown", "text"
      --     file_ext = "md", -- Ex: "org" "norg" "md" "txt"
      --   },
      -- },
      keymaps = {
        disable_all = false,
        open_item = {
          default = { keys = { "o", "<CR>" }, auto_close = false },
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
