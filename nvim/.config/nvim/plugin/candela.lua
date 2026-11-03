local add_on_file_type = require("vim-pack").add_on_file_type

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"
local Log = lazy "utils.log"

local CreateCmd = function()
  return lazy("utils.cmd").create_command
end

add_on_file_type("log", {
  {
    src = "KieranCanter/candela.nvim",
    opts = {
      window = {
        width = 0.5, -- fraction of screen width
        min_height = 5, -- starting/minimum height in buffer lines
        max_height = 30, -- max height in buffer lines
        margin = 16, -- margin between Candela UI and Neovim UI
      },
      engine = {
        command = nil, -- auto-detected: rg > ag > ugrep > ack > grep
        args = {}, -- args passed to regex command
      },
      matching = {
        auto_refresh = false, -- refresh highlights on buffer switch
        case = "system", -- "system" | "sensitive" | "ignore" | "smart"
        hl_eol = false, -- highlight entire line vs matched text only
      },
      lightbox = {
        default_view = "system-vsplit", -- default split for UI keymap
        fold_style = "nvim", -- "nvim" | "fillchar" | "count" | "preview" | "detailed"
        fillchar = "-", -- foldtext fillchar (see "fold" in `:h fillchars`)
        custom_foldtext = nil, -- function used to define foldtext (`:h 'foldtext'`)
      },
      icons = {
        nerd_font = false, -- set true for default nerd font icons
        -- ...,
      },
      palette = {
        use = "replace", -- "replace" | "prepend" | "append"
        cycle = "constant", -- "constant" | "random"
        -- colors = { dark = { ... }, light = { ... } }, -- available colors (hex codes)
        -- swatches = { dark = { ... }, light = { ... } }, -- named color shortcuts
      },
      syntax_highlighting = {
        enabled = true, -- enable built-in log syntax highlighting
        file_types = { ".log", "text" }, -- file types to enabled syntax highlighting for
      },
    },
    on_setup = function()
      UtilKey.noremap({ "n", "x" }, "<C-a>a", function()
        local ok, query = pcall(vim.fn.input, "Candela add: ")
        if not ok or not query or query == "" then
          return
        end
        vim.cmd("Candela add " .. query)
      end, { desc = "Candela: add regex", remap = true }, true)

      -- local function complete_packages(arg_lead)
      --   arg_lead = arg_lead or ""
      --
      --   return vim
      --     .iter(vim.pack.get())
      --     :map(function(pack)
      --       return pack.spec.name
      --     end)
      --     :filter(function(name)
      --       return vim.startswith(name, arg_lead)
      --     end)
      --     :totable()
      -- end

      CreateCmd()("CandelaSendLoclist", function(args)
        -- if #info.fargs ~= 0 then
        --   vim.pack.update(info.fargs, { force = info.bang })
        -- else
        --   vim.pack.update(nil, { force = info.bang })
        -- end
        Log.info(vim.inspect(args))
      end, {
        desc = "Candela send pick item to location list",
        nargs = "*",
        bang = true,
        -- complete = complete_packages,

        complete = function(_, cmdline, cursorpos)
          return lazy("candela").complete("Candela loclist", cmdline, cursorpos)
        end,
      })

      UtilKey.noremap({ "n", "x" }, "<C-a>l", function()
        vim.cmd "CandelaSendLoclist"
      end, {
        desc = "Candela: send result loclist",
        remap = true,
      }, true)
    end,
  },
})
