return {
  -- WAYFINDER (disabled)
  {
    "error311/wayfinder.nvim",
    enabled = false,
    keys = {
      {
        "<Leader>cP",
        "<Plug>(WayfinderOpen)",
        desc = "Peek: peek with wayfinder [wayfinder.nvim]",
      },
    },
    opts = {},
  },
  -- OVERLOOK.NVIM
  {
    "MadKuntilanak/overlook.nvim",
    keys = {
      {
        "K",
        function()
          require("overlook.peek").peek_qf()
        end,
        ft = "qf",
        desc = "Peek: peek on qf item [overlook.nvim]",
      },
      {
        "P",
        function()
          require("overlook.peek").peek_qf()
        end,
        ft = "qf",
        desc = "Peek: peek on qf item (alternatif) [overlook.nvim]",
      },
      {
        "P",
        function()
          require("overlook.peek").peek_file_source()
        end,
        ft = "orgagenda",
        desc = "Peek: note file [overlook.nvim]",
      },
      {
        "<Leader>cP",
        function()
          require("overlook.api").peek_definition()
        end,
        desc = "Peek: peek definition [overlook.nvim]",
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

            local lnum, col = 1, 1

            if path:match ":" then
              local parts = vim.split(path, ":")
              path = parts[1]
              lnum = tonumber(parts[2]) or lnum
              col = tonumber(parts[3]) or col
            end

            if path:match "~" then
              path = RUtils.config.path.home .. path:gsub("~", "")
            end

            local bufnr = vim.fn.bufadd(path)
            if not vim.api.nvim_buf_is_loaded(bufnr) then
              vim.fn.bufload(bufnr)
            end

            return {
              target_bufnr = bufnr,
              lnum = lnum,
              col = col,
              title = path,
              win_col = 50,
              win_row = 5,
              win_width = 80,
              win_height = 25,
            }
          end,
        },

        peek_qf = {
          get = function()
            local function win_height()
              return vim.fn.winheight(0)
            end

            local function is_qf_window_at_bottom()
              local editor_last_row = vim.o.lines - vim.o.cmdheight - 1
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local info = vim.fn.getwininfo(win)[1]
                if info.quickfix == 1 or info.loclist == 1 then
                  local pos = vim.api.nvim_win_get_position(win)
                  local height = vim.api.nvim_win_get_height(win)
                  return (pos[1] + height - 1) >= editor_last_row - 1
                end
              end
              return false
            end

            local cursor_lnum = vim.api.nvim_win_get_cursor(0)[1]
            local is_loc = RUtils.qf.is_loclist()
            local qflist = RUtils.qf.get_list_qf(is_loc)
            local item = qflist.items[cursor_lnum]

            local opts = {
              col = item.col or nil,
              lnum = item.lnum or nil,
              win_height = 20,
              win_width = 100,
              win_col = 0,
              win_row = is_qf_window_at_bottom() and -win_height() - 15 or win_height(),
              win_relative = "win",
            }

            if item.bufnr then
              opts.target_bufnr = item.bufnr

              if item.text then
                if #item.text == 0 then
                  local path = require("qfbookmark.utils").nvim_buf_get_name(item.bufnr)
                  opts.title = path and vim.fn.fnamemodify(path, ":~:.") or item.text
                else
                  opts.title = item.text
                end
              end
            end

            return opts
          end,
        },
        peek_file_source = {
          get = function()
            if vim.bo.filetype ~= "orgagenda" then
              return
            end

            local item_headline = require("orgmode.api.agenda").get_headline_at_cursor()
            if not item_headline then
              return
            end

            local opts = { lnum = 0, col = 0 }

            ---@diagnostic disable-next-line: invisible
            local item_section = item_headline._section
            if item_section and item_section.file then
              local path = item_section.file.filename

              if path:match "~" then
                path = RUtils.config.path.home .. path:gsub("~", "")
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
            local win_height = math.floor(vim.o.lines * 0.3)
            local ui = vim.api.nvim_list_uis()[1]

            opts.win_relative = "editor"
            opts.win_row = math.floor((ui.height - win_height) / 2)
            opts.win_col = math.floor((ui.width - win_width) / 2)
            opts.win_width = 80
            opts.win_height = 30

            return opts
          end,
        },
      },
    },

    config = function(_, opts)
      require("overlook").setup(opts)

      local api = require "overlook.api"
      local cmds = {
        { "PeekCloseAll", api.close_all, "peek close all" },
        { "PeekCursor", api.peek_cursor, "peek cursor" },
        { "PeekRestorePopup", api.restore_popup, "restore popup" },
        { "PeekRestoreAllPopup", api.restore_all_popups, "restore all popup" },
      }

      for _, cmd in ipairs(cmds) do
        vim.api.nvim_create_user_command(cmd[1], cmd[2], {
          desc = ("Peek: %s [overlook.nvim]"):format(cmd[3]),
        })
      end
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
    "rachartier/tiny-code-action.nvim",
    -- dir = "~/.local/src/nvim_plugins/tiny-code-action.nvim",
    -- "MadKuntilanak/tiny-code-action.nvim",
    -- branch = "fix/fzflua",
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
    dependencies = { "MadKuntilanak/nui.nvim" },
    cmd = { "PeekWHOCallers", "PeekWHATCallees", "PeekSUBTYPE", "PeekSUPERTYPE" },
    opts = {
      mappings = {
        jump = "<CR>",
        toggle = "<Tab>",
        expand = "<S-Right",
        expand_alt = "<Right>",
        collapse = "<S-Left>",
        collapse_alt = "<Left>",
        show_super_hierarchy = "K",
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

      vim.api.nvim_create_user_command("PeekWHOCallers", function()
        require("meow.yarn").open_tree("call_hierarchy", "callers")
      end, { desc = "LSP: show callers (who calls this function) [meow.yarn]" })

      vim.api.nvim_create_user_command("PeekWHATCallees", function()
        require("meow.yarn").open_tree("call_hierarchy", "callees")
      end, { desc = "LSP: show callees (functions called by this function) [meow.yarn]" })

      vim.api.nvim_create_user_command("PeekSUPERTYPE", function()
        require("meow.yarn").open_tree("type_hierarchy", "supertypes")
      end, { desc = "LSP: show supertypes (parent types) [meow.yarn]" })

      vim.api.nvim_create_user_command("PeekSUBTYPE", function()
        require("meow.yarn").open_tree("type_hierarchy", "subtypes")
      end, { desc = "LSP: show subtypes (derived/child types) [meow.yarn]" })
    end,
  },
}
