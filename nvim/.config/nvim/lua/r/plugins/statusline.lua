return {
  -- MINI.ICONS
  {
    "echasnovski/mini.icons",
    event = "BufReadPost",
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },

    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  -- HEIRLINE
  {
    "rebelot/heirline.nvim",
    event = "LazyFile",
    opts = function()
      local comp = require "r.plugins.colorthemes.heirline.components"
      return {
        statusline = { comp.status_active_left },
        winbar = { comp.status_winbar_active_left },
        opts = {
          disable_winbar_cb = function(args)
            local buf = args.buf
            if not vim.api.nvim_buf_is_valid(buf) then
              return true
            end
            local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[buf].buftype)
            local filetype = vim.tbl_contains({
              "gitcommit",
              "fugitive",
              "Trouble",
              "packer",
              "dashboard",
              "fzf",
              "Outline",
              "snacks_dashboard",
              "toggleterm",
            }, vim.bo[buf].filetype)
            local is_float = vim.api.nvim_win_get_config(0).relative ~= ""
            return buftype or filetype or is_float
          end,
        },
      }
    end,
    config = function(_, opts)
      require("heirline").setup(opts)

      local group = vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = function()
          local bh = vim.bo.bufhidden
          if bh == "wipe" or bh == "delete" then
            vim.bo.buflisted = false
          end
        end,
      })
    end,
  },
}
