local ccc_filetypes =
  { "html", "css", "sass", "less", "javascript", "typescript", "javascriptreact", "typescriptreact", "lua" }
return {
  -- NVIM-HIGHLIGHT-COLORS
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPost",
    config = function()
      require("nvim-highlight-colors").setup {
        ---Render style
        ---@usage 'background'|'foreground'|'virtual'
        render = "virtual",

        ---Set virtual symbol (requires render to be set to 'virtual')
        virtual_symbol = "■",

        ---Highlight named colors, e.g. 'green'
        enable_named_colors = true,

        ---Highlight tailwind colors, e.g. 'bg-blue-500'
        enable_tailwind = false,

        ---Set custom colors
        ---Label must be properly escaped with '%' to adhere to `string.gmatch`
        --- :help string.gmatch
        custom_colors = {
          { label = "%-%-theme%-primary%-color", color = "#0f1219" },
          { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
        },
      }
    end,
  },
  -- CCCPICK
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick" },
    ft = ccc_filetypes,
    opts = {},
    -- init = function()
    --   require("quick_action").add("menu", {
    --     name = "Pick color",
    --     condition = function()
    --       local has_ccc, config = pcall(require, "ccc.config")
    --       if not has_ccc then
    --         return false
    --       end
    --       local pickers = config.options.pickers
    --       local cursor = vim.api.nvim_win_get_cursor(0)
    --       local lnum = cursor[1]
    --       local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]
    --       local parse_col = 1
    --       while true do
    --         local start, end_, RGB
    --         for _, picker in ipairs(pickers) do
    --           local s_, e_, rgb = picker:parse_color(line, parse_col)
    --           if s_ and s_ <= cursor[2] + 1 and e_ and e_ >= cursor[2] + 1 then
    --             return true
    --           elseif s_ and (start == nil or s_ < start) then
    --             start = s_
    --             end_ = e_
    --             RGB = rgb
    --           end
    --         end
    --         if RGB == nil then
    --           break
    --         end
    --         parse_col = end_ + 1
    --       end
    --       return false
    --     end,
    --     action = function()
    --       vim.cmd "CccPick"
    --     end,
    --   })
    -- end,
    -- config = function()
    --   local ccc = require "ccc"
    --   ccc.setup {
    --     inputs = {
    --       ccc.input.hsl,
    --       ccc.input.rgb,
    --     },
    --     highlighter = {
    --       auto_enable = true,
    --       filetypes = ccc_filetypes,
    --     },
    --     recognize = {
    --       input = true,
    --       output = true,
    --     },
    --     mappings = {
    --       ["?"] = function()
    --         print "i - Toggle input mode"
    --         print "o - Toggle output mode"
    --         print "a - Toggle alpha slider"
    --         print "g - Toggle palette"
    --         print "w - Go to next color in palette"
    --         print "b - Go to prev color in palette"
    --         print "l/d/, - Increase slider"
    --         print "h/s/m - Decrease slider"
    --         print "1-9 - Set slider value"
    --       end,
    --     },
    --   }
    -- end,
  },
}
