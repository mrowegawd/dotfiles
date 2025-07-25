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

            local is_float = vim.api.nvim_win_get_config(0).relative ~= ""
            local is_buftype = vim.tbl_contains({ "help", "prompt", "nofile" }, vim.bo[buf].buftype)
            local is_filetype = vim.tbl_contains({
              "DiffviewFileHistory",
              "DiffviewFiles",
              "Outline",
              "Trouble",
              "dashboard",
              "fugitive",
              "fzf",
              "gitcommit",
              "packer",
              "snacks_dashboard",
              "toggleterm",
              "org",
              "orgagenda",
            }, vim.bo[buf].filetype)

            if vim.bo[buf].buftype == "nofile" then
              local path = vim.fn.expand "%:p"
              if #path > 0 and not is_filetype and not is_buftype and not is_float then
                return false
              end
              return not vim.tbl_contains(
                { "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes" },
                vim.bo[buf].filetype
              )
            end

            return is_filetype or is_float or is_buftype
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
