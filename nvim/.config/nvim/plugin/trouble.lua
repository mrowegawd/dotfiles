local add_local_or_remote = require("vim-pack").add_local_or_remote

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"
local UtilWindow = lazy "utils.window"
local IconsLSP = lazy("icons").kinds

local function auto_close_qf_win()
  local qf_win = UtilWindow.windows_is_opened "qf"
  if qf_win.found then
    vim.cmd [[cclose]]
  end
end

add_local_or_remote {
  {
    src = "nvim_plugins/trouble.nvim",
    lazy = true,
    opts = function()
      return {
        focus = true,
        auto_refresh = false, -- use `R` to refresh it
        follow = false,
        win = { position = "bottom", relative = "win" },
        -- preview = {
        --   type = "float", -- can use: type = "split", relative = "win", position = "right",
        --   scratch = true,
        --   border = "rounded",
        --   title = " Trouble Preview - [P] to disable it  ",
        --   title_pos = "center",
        --   size = { width = 0.6, height = 0.5 },
        --   wo = {
        --     winhighlight = "Normal:NormalFloat,CursorLine:CursorLineFloat",
        --   },
        -- },

        icons = {
          kinds = {
            Array = IconsLSP.Array,
            Boolean = IconsLSP.Boolean,
            Class = IconsLSP.Classs,
            Constant = IconsLSP.Constant,
            Constructor = IconsLSP.Constructor,
            Enum = IconsLSP.Enum,
            EnumMember = IconsLSP.EnumMember,
            Event = IconsLSP.Event,
            Field = IconsLSP.Field,
            File = IconsLSP.File,
            Function = IconsLSP.Function,
            Interface = IconsLSP.Interface,
            Key = IconsLSP.Interface,
            Method = IconsLSP.Key,
            Module = IconsLSP.Method,
            Namespace = IconsLSP.Namespace,
            Null = IconsLSP.Null,
            Number = IconsLSP.Number,
            Object = IconsLSP.Object,
            Operator = IconsLSP.Operator,
            Package = IconsLSP.Package,
            Property = IconsLSP.Property,
            String = IconsLSP.String,
            Struct = IconsLSP.Struct,
            TypeParameter = IconsLSP.TypeParameter,
            Variable = IconsLSP.Variable,
          },
        },
        keys = {
          ["<Leader>?"] = "help",
          ["<esc>"] = "cancel",

          q = "close",
          ["<Leader>bk"] = "close",

          ["R"] = "refresh",
          ["<Leader>r"] = "toggle_refresh",

          o = "jump",

          ["P"] = "toggle_preview",

          ["<TAB>"] = "fold_toggle",

          ["<C-s>"] = "jump_split_aboveleft_close",
          ["<a-n>"] = "next",
          ["<c-n>"] = "next",
          ["<a-p>"] = "prev",
          ["<c-p>"] = "prev",

          s = false,

          ["<C-x>ub"] = {
            action = function(view)
              view:filter({ buf = 0 }, { toggle = true })
            end,
            desc = "Toggle Current Buffer Filter",
          },
          ["<C-x>ue"] = {
            action = function(view)
              view:filter({ ["not"] = { buf = 0 } }, { id = "not-buf", toggle = true })
            end,
            desc = "Exclude Current Buffer",
          },

          -- gy = {
          --   action = function(view)
          --     local items = view:get()
          --     local __items = items[1].view.renderer._locations
          --
          --     -- local lines = {}
          --     for _, item in ipairs(__items) do
          --       for _, i in pairs(item.node) do
          --         Log.info(vim.inspect(i))
          --       end
          --
          --       -- local item_main = item.view._main
          --       -- lines[#lines + 1] = item_main.filename .. ":" .. item_main.cursor[1] .. ":" .. item_main.cursor[2]
          --     end
          --     -- vim.fn.setreg("+", table.concat(lines, "\n"))
          --     -- vim.notify(("Copied %d items"):format(#lines))
          --   end,
          --   desc = "Yank All Items",
          -- },

          ["<C-x>uF"] = {
            action = function(view)
              local f = view:get_filter "severity"
              local severity = ((f and f.filter.severity or 0) + 1) % 5
              view:filter({ severity = severity }, {
                id = "severity",
                template = "{hl:Title}Filter:{hl} {severity}",
                del = severity == 0,
              })
            end,
            desc = "Toggle Severity Filter",
          },
          ["<C-x>ee"] = {
            action = function(view)
              view:filter({ severity = vim.diagnostic.severity.ERROR }, { id = "severity", toggle = true })
            end,
            desc = "Toggle Error-only Filter",
          },
        },
      }
    end,
  },
}

local load_trouble = function()
  lazy("vim-pack").load_now "trouble.nvim"
end

local function set_keymaps(tbl_keys, prefix)
  for _, cmd in ipairs(tbl_keys) do
    UtilKey.nnoremap(cmd[1], function()
      load_trouble()
      cmd[2]()
    end, { desc = ((prefix or "Exec") .. ": %s [trouble]"):format(cmd[3]) })
  end
end

local keys = {
  --stylua: ignore
  { "<Leader>xr", function() vim.cmd "Trouble resume" end, "resume" },
  --stylua: ignore
  { "<Leader>xT", function() UtilKey.plugin_load_now "todo-comments.nvim" auto_close_qf_win() vim.cmd.TodoTrouble() end, "todo-trouble global" },
  --stylua: ignore
  { "<Leader>xF", function() load_trouble() vim.cmd.Trouble() end, "Bulk: list trouble builtin" },
}

local keys2 = {
  --stylua: ignore
  { "<Leader>xD", function() auto_close_qf_win() vim.cmd [[Trouble diagnostics toggle]] end, "workspace diagnostics (global)" },
  --stylua: ignore
  { "<Leader>xd", function() auto_close_qf_win() vim.cmd [[Trouble diagnostics toggle filter.buf=0]] end, "document diagnostics (local)" },
}

set_keymaps(keys)
set_keymaps(keys2, "Diagnostic")
