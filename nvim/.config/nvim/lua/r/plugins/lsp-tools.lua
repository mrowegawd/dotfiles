return {
  -- OVERLOOK.NVIM
  {
    "MadKuntilanak/overlook.nvim",
    branch = "feat/allow-customize-ui-adapter",
    keys = {
      {
        "K",
        function()
          local P = require "overlook.peek"
          P.peek_qf()
        end,
        ft = "qf",
        desc = "Peek: peek on qf item [overlook]",
      },
      {
        "P",
        function()
          local P = require "overlook.peek"
          P.peek_qf()
        end,
        ft = "qf",
        desc = "Peek: peek on qf item (alternatif) [overlook]",
      },
      {
        "P",
        function()
          local P = require "overlook.peek"
          P.peek_file_source()
        end,
        ft = "orgagenda",
        desc = "Peek: note file [overlook]",
      },
      {
        "<Leader>cp",
        function()
          require("overlook.api").peek_definition()
        end,
        desc = "Peek: peek definition [overlook]",
      },
    },
    opts = {
      ui = {
        size_ratio = 0.70,
        min_width = 40,
        min_height = 20,
      },
      adapters = {
        peek_fzflua = {
          get = function(selection)
            local path = RUtils.fzflua.__strip_str(selection[1])
            if not path then
              return
            end

            local lnum = 1
            local col = 1

            if path:match ":" then
              path = vim.split(path, ":")

              local str_path = path[1]
              local _lnum = tonumber(path[2])
              local _col = tonumber(path[3])

              path = str_path

              if _lnum then
                lnum = _lnum
              end

              if _col then
                col = _col
              end
            end

            if path:match "~" then
              path = path:gsub("~", "")
              path = RUtils.config.path.home .. path
            end

            local bufnr = vim.fn.bufadd(path)
            if not vim.api.nvim_buf_is_loaded(bufnr) then
              vim.fn.bufload(bufnr)
            end

            local opts = {
              target_bufnr = bufnr,
              lnum = lnum,
              col = col,
              title = path,

              win_col = 50,
              win_row = 5,

              win_width = 80,
              win_height = 25,
            }

            return opts
          end,
        },
        peek_qf = {
          get = function()
            local lnum = vim.api.nvim_win_get_cursor(0)[1]
            local is_loc = RUtils.qf.is_loclist()
            local qflist = RUtils.qf.get_list_qf(is_loc)
            local item = qflist.items[lnum]

            local opts = {}

            if item.bufnr then
              opts.target_bufnr = item.bufnr

              if item.text then
                if #item.text == 0 then
                  local path = vim.api.nvim_buf_get_name(item.bufnr)
                  opts.title = vim.fn.fnameescape(path)
                else
                  opts.title = item.text
                end
              end
            end

            if item.col then
              opts.col = item.col
            end

            if item.lnum then
              opts.lnum = item.lnum
            end

            opts.win_height = 20
            opts.win_width = 80

            opts.win_col = 1
            opts.win_row = -24

            return opts
          end,
        },
        peek_file_source = {
          get = function()
            if vim.bo.filetype ~= "orgagenda" then
              return
            end

            local item_headline

            local Orgmode = require "orgmode.api.agenda"

            ---@type any
            item_headline = Orgmode.get_headline_at_cursor()

            if not item_headline then
              return
            end

            local opts = {
              lnum = 0,
              col = 0,
            }

            local item_section = item_headline._section

            if item_section and item_section.file then
              local path = item_section.file.filename

              if path:match "~" then
                path = path:gsub("~", "")
                path = RUtils.config.path.home .. path
              end

              local bufnr = vim.fn.bufadd(path)
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                vim.fn.bufload(bufnr)
              end

              opts.target_bufnr = bufnr
              opts.title = path

              opts.lnum = item_headline.position.start_line
              opts.col = item_headline.position.end_col
            end

            local columns = vim.api.nvim_get_option_value("columns", { scope = "global" })
            local win_width = math.ceil(columns / 2)

            local ui = vim.api.nvim_list_uis()[1]
            local col = math.floor((ui.width - win_width) / 2)

            opts.win_row = -10
            opts.win_col = col

            opts.win_width = 80
            opts.win_height = 30

            return opts
          end,
        },
      },
    },
    config = function(_, opts)
      local p = require "overlook"

      p.setup(opts)

      vim.api.nvim_create_user_command("PeekCloseAll", function()
        require("overlook.api").peek_definition()
      end, { desc = "Peek: peek definition [overlook]" })

      vim.api.nvim_create_user_command("PeekRestorePopup", function()
        require("overlook.api").restore_popup()
      end, { desc = "Peek: restore popup [overlook]" })

      vim.api.nvim_create_user_command("PeekRestoreAllPopup", function()
        require("overlook.api").restore_all_popups()
      end, { desc = "Peek: restore all popup [overlook]" })
    end,
  },
  -- INCRENAME
  {
    "smjonas/inc-rename.nvim",
    event = "LazyFile",
    opts = {
      show_message = false,
      preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancel
    },
  },
  -- INCRENAME KEYMAP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "<Leader>cr",
              function()
                local inc_rename = require "inc_rename"
                return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
              end,
              expr = true,
              desc = "Action: rename [inc_rename]",
              has = "rename",
            },
          },
        },
      },
    },
  },
  -- TINY-INLINE-DIAGNOSTIC
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LazyFile",
    config = true,
  },
  -- TINY-CODE-ACTION
  {
    -- "rachartier/tiny-code-action.nvim",
    dir = "~/.local/src/nvim_plugins/tiny-code-action.nvim",
    event = "LspAttach",
    opts = {
      backend = "delta", -- delta, vim
      picker = "fzf-lua",
      backend_opts = {
        delta = { header_lines_to_remove = 4 },
        difftastic = {
          header_lines_to_remove = 1,
          args = {
            "--color=always",
            "--display=inline",
            "--syntax-highlight=on",
          },
        },
        diffsofancy = {
          header_lines_to_remove = 4,
        },
      },
      signs = {
        quickfix = { "", { link = "DiagnosticWarn" } },
        others = { "", { link = "DiagnosticWarn" } },
        refactor = { "", { link = "DiagnosticInfo" } },
        ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
        ["refactor.extract"] = { "", { link = "DiagnosticError" } },
        ["source.organizeImports"] = { "", { link = "DiagnosticWarn" } },
        ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
        ["source"] = { "", { link = "DiagnosticError" } },
        ["rename"] = { "󰑕", { link = "DiagnosticWarn" } },
        ["codeAction"] = { "", { link = "DiagnosticWarn" } },
      },
    },
  },
  -- LOG SYNTAX-HIGHLIGHT
  {
    "fei6409/log-highlight.nvim",
    event = "BufRead *.log",
    opts = {},
  },
  -- TASKWARRIOR SYNTAX
  {
    "framallo/taskwarrior.vim",
    ft = "taskrc",
  },
  -- MEOWYARN
  {
    "retran/meow.yarn.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = { "PeekWHOCallThisFunc", "PeekWHATCallThisFunc", "PeekSUBTYPE", "PeekSUPERTYPE" },
    opts = {
      mappings = {
        jump = "<CR>",
        toggle = "<Tab>",
        expand = "<S-Right",
        expand_alt = "<Right>",
        collapse = "<S-Left>",
        collapse_alt = "<Left>",
        show_super_hierarchy = "H",
        show_sub_hierarchy = "J",
        quit = "q",
      },
      hierarchies = {
        type_hierarchy = {
          icons = {
            class = RUtils.config.icons.kinds.Class,
            struct = RUtils.config.icons.kinds.Struct,
            interface = RUtils.config.icons.kinds.Interface,
            default = "",
          },
        },
        call_hierarchy = {
          icons = {
            method = RUtils.config.icons.kinds.Method,
            func = RUtils.config.icons.kinds.Function,
            variable = RUtils.config.icons.kinds.Variable,
            default = "",
          },
        },
      },
    },
    config = function(_, opts)
      require("meow.yarn").setup(opts)

      vim.api.nvim_create_user_command("PeekWHOCallThisFunc", function()
        require("meow.yarn").open_tree("call_hierarchy", "callers")
      end, { desc = "LSP: who call this func hierarcy [meow.yarn]" })

      vim.api.nvim_create_user_command("PeekWHATCallThisFunc", function()
        require("meow.yarn").open_tree("call_hierarchy", "callees")
      end, { desc = "LSP: what call this func hierarcy [meow.yarn]" })

      vim.api.nvim_create_user_command("PeekSUPERTYPE", function()
        require("meow.yarn").open_tree("type_hierarchy", "supertypes")
      end, { desc = "LSP: check supertype hierarcy [meow.yarn]" })

      vim.api.nvim_create_user_command("PeekSUBTYPE", function()
        require("meow.yarn").open_tree("type_hierarchy", "subtypes")
      end, { desc = "LSP: check subtype hierarcy [meow.yarn]" })
    end,
  },
}
