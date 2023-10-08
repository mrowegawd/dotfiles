return {
  -- ALPHA
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require "alpha"

      -- Get ascii generator:
      -- https://lachlanarthur.github.io/Braille-ASCII-Art/
      local one_punch_man = {
        [[]],
        [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡤⠤⠤⠤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠖⠈⠉⠉⠁⠒⠤⡀⠀⠀ ]],
        [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠾⠿⠶⠀⠀⠀⠀⠀⠈⠑⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠁⠀⠀⠀⠀⠀⠀⠀⠈⢆⠀ ]],
        [[                 ⠀⠀⠀⠀⠀⠀⠀⣰⣯⣍⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄ ]],
        [[                 ⠀⠀⠀⠀⠀⠀⡸⠥⠤⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣ ]],
        [[                 ⠀⠀⠀⠀⠀⢠⣯⠭⠭⠭⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸ ]],
        [[                 ⠀⠀⠀⠀⠀⣼⣛⣛⣛⣒⡀⠀⠀⠤⠤⠤⠤⠤⠀⠀⠤⠤⠤⠄⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⢀⣀⡀⡀⠀⡀⠀⠀⠀⢸ ]],
        [[                 ⠀⠀⠀⠀⠀⢹⡤⠤⠄⠀⠀⠀⡔⠒⠛⠗⢲⠀⢀⠐⠚⠍⢑⡆⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⢰⠁⠀⡐⣧⣎⠀⠀⠀⠀⢸ ]],
        [[                 ⠀⠀⠀⠀⢰⣏⣙⣶⣒⣈⡁⠀⠈⠒⠂⠒⠁⠀⢸⠈⠒⠒⠊⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠁⠀⠀⠈⠒⠊⠀⠃⠀⠑⠀⠀⠀⢸ ]],
        [[                 ⠀⠀⠀⠀⣿⠉⣹⡍⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸ ]],
        [[                 ⠀⠀⠀⠀⠸⣝⣟⣅⡀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇ ]],
        [[                 ⠀⠀⠀⠀⠀⠙⢌⣁⡤⠤⠶⠤⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀ ]],
        [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⢹⣈⣉⣉⣉⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠃⠀ ]],
        [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⡭⠥⠄⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠤⣀⠀⠀⠀⢀⡠⠔⠁⠀⠀ ]],
        [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡶⢭⣁⠀⠀⠀⠀⠀⢀⡤⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠁⠀⠀⠀⠀  ]],
        [[                 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡧⠀⣈⡛⠒⠒⠒⠋⢹⠤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
        [[                 ⠀⠀⠀⠀⠀⠀⠀⢀⡠⢴⠷⡏⠉⠉⠀⠀⠀⠀⠀⢸⣆⠈⢧⡙⡖⢤⠐⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
        [[                 ⠀⠀⠀⢀⣀⣖⣚⣻⣛⣿⣏⢻⣄⡀⠀⠀⠀⠀⠀⢈⡼⢦⡀⢳⣿⣶⣤⡄⠑⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
        [[                 ⠀⠀⣼⣁⣀⣉⣙⣿⣿⣿⣷⢸⡀⠈⠉⠓⣲⡶⣾⡍⠀⠀⣳⢄⣛⣟⣛⣠⣶⣻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
        [[                 ⠀⢠⣟⣿⣿⢷⣶⣮⡭⢽⡒⣿⣗⣤⣀⣀⣻⠙⠁⢇⣴⣾⣿⣿⣷⣿⣾⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
        [[                 ⣰⢻⣧⣍⡹⣽⣿⣧⡗⡤⣠⣥⣿⣿⣿⡾⣧⣘⣣⠼⢹⣿⣿⣿⣿⣿⣿⢻⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
        [[                 ⣯⣽⣿⣿⢚⣻⣿⣷⣿⣫⣟⣻⣿⣿⣿⣷⡇⢸⣿⡄⢸⣿⣿⣿⣿⣿⣿⡿⣟⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
        [[                 ⣾⣶⣿⣾⣯⣥⣿⣿⣟⣿⣯⣿⣿⣿⣿⣿⣿⣇⣸⣿⣃⣸⣿⣿⣿⣿⣿⣷⣿⣿⣿⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[]],
      }

      ---@diagnostic disable-next-line: unused-local
      local batman = {
        [[]],
        [[                     Tb.          Tb.                                ]],
        [[                     :$$b.        $$$b.                              ]],
        [[                     :$$$$b.      :$$$$b.                            ]],
        [[                     :$$$$$$b     :$$$$$$b                           ]],
        [[                      $$$$$$$b     $$$$$$$b                          ]],
        [[                      $$$$$$$$b    :$$$$$$$b                         ]],
        [[                      :$$$$$$$$b---^$$$$$$$$b                        ]],
        [[                      :$$$$$$$$$b        ""^Tb                       ]],
        [[                       $$$$$$$$$$b    __...__`.                      ]],
        [[                       $$$$$$$$$$$b.g$$$$$$$$$pb                     ]],
        [[                       $$$$$$$$$$$$$$$$$$$$$$$$$b                    ]],
        [[                       $$$$$$$$$$$$$$$$$$$$$$$$$$b                   ]],
        [[                       :$$$$$$$$$$$$$$$$$$$$$$$$$$;                  ]],
        [[                       :$$$$$$$$$$$$$^T$$$$$$$$$$P;                  ]],
        [[                       :$$$$$$$$$$$$$b  "^T$$$$P' :                  ]],
        [[                       :$$$$$$$$$$$$$$b._.g$$$$$p.db                 ]],
        [[                       :$$$$$$$$$$$$$$$$$$$$$$$$$$$$;                ]],
        [[                       :$$$$$$$$"""^^T$$$$$$$$$$$$P^;                ]],
        [[                       :$$$$$$$$       ""^^T$$$P^'  ;                ]],
        [[                       :$$$$$$$$    .'       `"     ;                ]],
        [[                       $$$$$$$$;   /                :                ]],
        [[                       $$$$$$$$;           .----,   :                ]],
        [[                       $$$$$$$$;         ,"          ;               ]],
        [[                       $$$$$$$$$p.                   |               ]],
        [[                      :$$$$$$$$$$$$p.                :               ]],
        [[                      :$$$$$$$$$$$$$$$p.            .'               ]],
        [[                      :$$$$$$$$$$$$$$$$$$p...___..-"                 ]],
        [[                      $$$$$$$$$$$$$$$$$$$$$$$$$;                     ]],
        [[   .db.          bug  $$$$$$$$$$$$$$$$$$$$$$$$$$                     ]],
        [[  d$$$$bp.            $$$$$$$$$$$$$$$$$$$$$$$$$$;                    ]],
        [[ d$$$$$$$$$$pp..__..gg$$$$$$$$$$$$$$$$$$$$$$$$$$$                    ]],
        [[d$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$p._            .gp. ]],
        [[$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$p._.ggp._.d$$$$b]],
      }

      local header = {
        type = "text",
        val = one_punch_man,
        opts = {
          position = "center",
          hl = "AlphaHeader",
        },
      }

      -- io.popen 'fd --max-depth 1 . $HOME"/.local/share/nvim/lazy" | head -n -2 | wc -l | tr -d "\n" '
      -- io.popen 'fd -d 2 . $HOME"/.local/share/nvim/site/pack/deps" | head -n -2 | wc -l | tr -d "\n" '
      --
      -- local plugins = ""
      -- if handle ~= nil then
      --     plugins = handle:read "*a"
      --     handle:close()
      -- end

      local thingy = io.popen 'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'

      local date = ""
      if thingy ~= nil then
        date = thingy:read "*a"
        thingy:close()
      end

      local function get_installed_plugins()
        local ok, lazy = pcall(require, "lazy")
        if not ok then
          return 0
        end
        return lazy.stats().count
      end

      local plugin_count = {
        type = "text",
        val = "└─  " .. get_installed_plugins() .. " plugins in total ─┘",
        opts = {
          position = "center",
          hl = "AlphaHeader",
        },
      }

      local heading = {
        type = "text",
        val = "┌─   Today is " .. date .. " ─┐",
        opts = {
          position = "center",
          hl = "AlphaHeader",
        },
      }

      local footer = {
        type = "text",
        val = "-GiTMoX-",
        opts = {
          position = "center",
          hl = "AlphaFooter",
        },
      }

      local function button(sc, txt, keybind)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

        local opts = {
          position = "center",
          text = txt,
          shortcut = sc,
          cursor = 5,
          width = 24,
          align_shortcut = "right",
          hl_shortcut = "AlphaButtons",
          hl = "AlphaButtons",
        }
        if keybind then
          opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
        end

        return {
          type = "button",
          val = txt,
          on_press = function()
            local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
            vim.api.nvim_feedkeys(key, "normal", false)
          end,
          opts = opts,
        }
      end

      local buttons = {
        type = "group",
        val = {
          button("o", "   Recents", "<CMD> FzfLua oldfiles <CR>"),
          button("f", "   Explore", "<CMD> FzfLua files <CR>"),
          button("g", "   Ripgrep", "<CMD> FzfLua live_grep <CR>"),
          button("l", "   Sessions", '<CMD> lua require("persistence").load() <CR>'),
          button("q", "   Quit", "<cmd> qa <CR>"),
        },
        opts = {
          spacing = 1,
        },
      }

      local section = {
        header = header,
        buttons = buttons,
        plugin_count = plugin_count,
        heading = heading,
        footer = footer,
      }

      local options = {
        layout = {
          { type = "padding", val = 1 },
          section.header,
          { type = "padding", val = 1 },
          section.heading,
          section.plugin_count,
          { type = "padding", val = 1 },
          -- section.top_bar,
          section.buttons,
          -- section.bot_bar,
          { type = "padding", val = 1 },
          section.footer,
        },
        opts = {
          margin = 20,
        },
      }

      alpha.setup(options)
    end,
  },
}