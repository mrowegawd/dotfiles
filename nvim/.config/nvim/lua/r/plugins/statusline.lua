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
    event = "ColorScheme",
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

            local ft = vim.bo[buf].filetype
            local buft = vim.bo[buf].buftype

            local is_float = vim.api.nvim_win_get_config(0).relative ~= ""
            local is_buftype = vim.tbl_contains({ "help", "prompt", "nofile" }, buft)
            local is_buftype_with_no_file = vim.tbl_contains({ "help", "prompt" }, buft)
            local is_filetype = vim.tbl_contains({
              "DiffviewFileHistory",
              "DiffviewFiles",
              "Outline",
              "dashboard",
              "fugitive",
              "fzf",
              "gitcommit",
              "packer",
              "neo-tree",
              "snacks_dashboard",
              "toggleterm",
              "orgagenda",

              "snacks_notif",
            }, ft)

            if buft == "nofile" then
              local path = vim.fn.expand "%:p"
              if #path > 0 and not is_float and not is_buftype_with_no_file and not is_filetype then
                return false
              end

              return not vim.tbl_contains({ "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes" }, ft)
            end

            return is_float or is_buftype or is_filetype
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
