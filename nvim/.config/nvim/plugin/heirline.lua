local add_on_event = require("vim-pack").add_on_event

local lazy = require("utils.plugin").require_lazy

local UtilAugroup = lazy("utils.map").augroup

add_on_event("ColorScheme", {
  { src = "nvim-tree/nvim-web-devicons", setup = false },
  {
    src = "SmiteshP/nvim-navic",
    opts = function()
      local IconLSP = lazy("icons").kinds

      UtilAugroup("nvim-navic", {
        event = "LspAttach",
        command = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          lazy("nvim-navic").attach(client, args.buf)
        end,
      })

      return {
        lazy_update_context = true,
        highlight = true,
        separator = "  ",
        enc = function(line, col, winnr)
          return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
        end,
        dec = function(c)
          local line = bit.rshift(c, 16)
          local col = bit.band(bit.rshift(c, 6), 1023)
          local winnr = bit.band(c, 63)
          return line, col, winnr
        end,
        icons = {
          File = IconLSP.File,
          Module = IconLSP.Module,
          Namespace = IconLSP.Namespace,
          Package = IconLSP.Package,
          Class = IconLSP.Class,
          Method = IconLSP.Method,
          Property = IconLSP.Property,
          Field = IconLSP.Field,
          Constructor = IconLSP.Constructor,
          Enum = IconLSP.Enum,
          Interface = IconLSP.Interface,
          Function = IconLSP.Function,
          Variable = IconLSP.Variable,
          Constant = IconLSP.Constant,
          String = IconLSP.String,
          Number = IconLSP.number,
          Boolean = IconLSP.Boolean,
          Array = IconLSP.Array,
          Object = IconLSP.Object,
          Key = IconLSP.Key,
          Null = IconLSP.Null,
          EnumMember = IconLSP.EnumNumber,
          Struct = IconLSP.Struct,
          Event = IconLSP.Event,
          Operator = IconLSP.Operator,
          TypeParameter = IconLSP.TypeParameter,
          Component = IconLSP.Component,
          Fragment = "󰅴",

          TypeAlias = IconLSP.TypeAlias,
          Parameter = IconLSP.Parameter,
          StaticMethod = IconLSP.StaticMethod,
          Macro = IconLSP.Macro,
        },
      }
    end,
  },
  {
    src = "rebelot/heirline.nvim",
    opts = function()
      local comp = lazy "statusline.components"
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
            local is_buftype = vim.tbl_contains({ "prompt", "nofile" }, buft)
            local is_buftype_with_no_file = vim.tbl_contains({ "prompt" }, buft)
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
              "octo_panel",

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
    on_setup = function()
      UtilAugroup("heirline", {
        pattern = "*",
        event = "FileType",
        command = function()
          local bh = vim.bo.bufhidden
          if bh == "wipe" or bh == "delete" then
            vim.bo.buflisted = false
          end
        end,
      })
    end,
  },
})

vim.g.navic_silence = true
