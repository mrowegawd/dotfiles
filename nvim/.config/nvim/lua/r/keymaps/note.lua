local fmt, cmd = string.format, vim.cmd
local Util = require "r.utils"
local Config = require "r.config"

local fzf_lua = Util.cmd.reqcall "fzf-lua"

local M = {}

function M.neorg_mappings_ft(bufnr)
  local mappings = {
    ["n"] = {
      ["ri"] = {
        function()
          return Util.maim.insert()
        end,
        "Note: insert image",
      },
      ["ro"] = {
        function()
          local note_ext = "norg"
          if vim.bo[0].filetype == "markdown" then
            note_ext = "md"
          end

          if note_ext == "norg" then
            return
          else
            -- vim.cmd [[ObsidianOpen]]
            local Job = require "plenary.job"
            -- async
            local data = {}
            Job:new({
              command = "obsidian",
              -- args = { "-a" },
              on_stdout = function(_, line)
                table.insert(data, line)
              end,
              on_exit = function()
                print "done"
              end,
            }):start()
          end
        end,
        "Note: run file",
      },
      ["<Localleader>oa"] = {
        function()
          if vim.bo[0].filetype == "neorg" then
            Util.tiling.force_win_close({ "OverseerList", "toggleterm", "termlist", "undotree", "aerial" }, true)
            cmd "Neorg toc right"
            local vim_width = vim.o.columns
            vim_width = math.floor(vim_width / 2 - 10)
            cmd(fmt("vertical resize %s", vim_width))
          else
            vim.cmd [[Outline]]
          end
        end,
        "Note: open toc",
      },
      ["<Localleader>ff"] = {
        function()
          local opts = {
            prompt = "  ",
            cwd = Config.path.wiki_path,
            rg_opts = [[-g "*.md" --column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -e]],
            winopts = {
              title = Util.fzflua.format_title("Note: files", "󰈙"),
            },
          }

          -- if vim.bo[0].filetype == "norg" then
          --   cmd [[Lazy load neorg]]
          --   opts.rg_opts =
          --     [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.norg" ]]
          -- else
          -- end

          return fzf_lua.files(opts)
        end,
        "Note: file",
      },
      ["<Localleader>fg"] = {
        function()
          local opts = {
            prompt = "  ",
            cwd = Config.path.wiki_path,
            winopts = {
              title = Util.fzflua.format_title("Note: grep", ""),
            },
          }

          if vim.bo[0].filetype == "norg" then
            cmd [[Lazy load neorg]]
            opts.rg_opts =
              [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.norg" ]]
          else
            opts.rg_opts =
              [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.md" ]]
          end
          return fzf_lua.live_grep_glob(opts)
        end,
        "Note: grep",
      },

      --   ["<Localleader>fg"] = {
      --     function()
      --       local col, row = Util.fzflua.rectangle_win_pojokan()
      --       Util.fzflua.send_cmds({
      --         grep_string_note = function()
      --           cmd [[Lazy load neorg]]
      --           return fzf_lua.live_grep_glob {
      --             prompt = "  ",
      --             cwd = require("r.config").path.wiki_path,
      --             rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.norg" ]],
      --             winopts = {
      --               title = Util.fzflua.format_title("Note: grep", ""),
      --             },
      --           }
      --         end,
      --         find_norg_files = function()
      --           cmd [[Lazy load neorg]]
      --
      --           return fzf_lua.files {
      --             prompt = "  ",
      --             cwd = require("r.config").path.wiki_path,
      --             rg_glob = true,
      --             file_ignore_patterns = { "%.md$", "%.json$", "%.org$" },
      --             winopts = {
      --               -- fullscreen = true,
      --               title = Util.fzflua.format_title("Note: files", ""),
      --             },
      --           }
      --         end,
      --         find_site_links = function()
      --           -- Karena use grep utk curbuf, agar bisa menggunakan regex
      --           -- pakai `lgrep_curbuf`
      --           fzf_lua.grep_curbuf {
      --             prompt = "  ",
      --             search = [[(\{:\$|\{http)]],
      --             no_esc = true,
      --             fzf_opts = { ["--layout"] = "reverse" },
      --             winopts = {
      --               title = Util.fzflua.format_title("Note: site links", ""),
      --             },
      --           }
      --         end,
      --
      --         find_link_friends = function()
      --           cmd "normal yi}"
      --           local title = vim.fn.getreg '"0'
      --           local title_trim = title:gsub([[^:%$]], [[:\$]])
      --
      --           fzf_lua.grep {
      --             prompt = "  ",
      --             cwd = require("r.config").path.wiki_path,
      --             no_esc = true,
      --             search = title_trim,
      --             fzf_opts = { ["--layout"] = "reverse" },
      --             winopts = {
      --               title = Util.fzflua.format_title("Note: link friends", ""),
      --             },
      --           }
      --         end,
      --         find_title_curbuf = function()
      --           fzf_lua.grep_curbuf {
      --             prompt = "  ",
      --             search = [[^(\*|\*\*|\*\*\*|\*\*\*\*).*$]],
      --             no_esc = true,
      --             fzf_opts = { ["--layout"] = false },
      --             winopts = {
      --               title = Util.fzflua.format_title("Note: title curbuf", ""),
      --             },
      --           }
      --         end,
      --         find_title_global = function()
      --           fzf_lua.grep {
      --             prompt = "  ",
      --             cwd = require("r.config").path.wiki_path,
      --             no_esc = true,
      --             search = [[^(\*|\*\*|\*\*\*|\*\*\*\*).*$]],
      --             fzf_opts = { ["--layout"] = false },
      --
      --             winopts = {
      --               title = Util.fzflua.format_title("Note: title global", ""),
      --             },
      --           }
      --         end,
      --         find_categories_links = function()
      --           local opts = {
      --             prompt = "  ",
      --             winopts = {
      --               title = Util.fzflua.format_title("Note: find by categories", ""),
      --               preview = {
      --                 hidden = "hidden",
      --                 vertical = "up:55%",
      --                 horizontal = "right:60%",
      --                 layout = "vertical",
      --               },
      --             },
      --             actions = {
      --               ["default"] = function(selected, _)
      --                 local selection = selected[1]
      --                 print(selection)
      --               end,
      --             },
      --           }
      --           return fzf_lua.fzf_exec(Util.neorg.find_by_categories(), opts)
      --         end,
      --         find_todo_curbuf = function()
      --           cmd(fmt("TodoQuickFix cwd=%s", fn.expand "%:p"))
      --         end,
      --         find_todo_global = function()
      --           cmd(fmt([[TodoQuickFix cwd=%s]], require("r.config").path.wiki_path))
      --         end,
      --       }, {
      --         winopts = { title = require("r.config").icons.misc.list .. " Neorg", col = col, row = row },
      --       })
      --     end,
      --     "Note: list commands",
      --   },
    },

    ["i"] = {
      ["c<cr>"] = {
        function()
          local note_ext = "norg"
          if vim.bo[0].filetype == "markdown" then
            note_ext = "md"
          end

          if note_ext == "md" then
            local opts = {
              prompt = "  ",
              winopts = {
                -- split = "belowright new | wincmd J | resize 40",
                title = Util.fzflua.format_title("Note: link curbuf", ""),
                preview = {
                  hidden = "hidden",
                  vertical = "up:55%",
                  horizontal = "right:60%",
                  layout = "vertical",
                },
              },
              actions = {
                ["default"] = function(selected, _)
                  local selection = selected[1]
                  -- local str_path = selection:match "%[(.*)%]"

                  vim.api.nvim_put({ selection }, "c", false, true)
                end,
              },
            }

            return fzf_lua.fzf_exec(Util.neorg.find_by_categories(), opts)
          end
        end,
        "Note: insert categories (curbuf)",
      },
      ["l<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              -- split = "belowright new | wincmd J | resize 40",
              title = Util.fzflua.format_title("Note: link curbuf", ""),
              preview = {
                hidden = "hidden",
                vertical = "up:55%",
                horizontal = "right:60%",
                layout = "vertical",
              },
            },
            actions = {
              ["default"] = function(selected, _)
                local selection = selected[1]
                local str_path = selection:match "%[(.*)%]"

                vim.api.nvim_put({
                  "[" .. str_path .. "]",
                }, "c", false, true)
              end,
            },
          }

          return fzf_lua.fzf_exec(Util.neorg.finder_sitelinkable(), opts)
        end,
        "Note: insert link (curbuf)",
      },
      ["t<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              title = Util.fzflua.format_title("Note: title curbuf", ""),
            },
            actions = {
              ["default"] = function(selected, _)
                local selection = selected[1]
                local str_path = string.gsub(selection:match "|.*$", "| ", "")

                -- print(str_path)

                vim.api.nvim_put({
                  "{" .. str_path .. "}",
                }, "c", false, true)
              end,
            },
          }

          return fzf_lua.fzf_exec(Util.neorg.finder_linkable(), opts)
        end,
        "Note: insert title (curbuf)",
      },
      ["T<cr>"] = {
        function()
          local note_ext = "norg"
          if vim.bo[0].filetype == "markdown" then
            note_ext = "md"
          end

          local opts = {
            prompt = "  ",
            winopts = {
              title = Util.fzflua.format_title("Note: title global", ""),
            },
            actions = {
              ["default"] = function(selected, _)
                local selection = selected[1]

                if note_ext == "norg" then
                  local link_path = selection:match "[^%s]+"

                  local title = selection:match "*.+$"
                  local trim_title = string.gsub(title, "*", "")

                  vim.api.nvim_put({
                    "[" .. trim_title .. "]" .. "{:$/" .. link_path .. ":" .. title .. "}",
                  }, "c", false, true)
                else
                  local parts = vim.split(selection, ".md")
                  local path_name = vim.split(parts[1], "/")
                  local path_file = path_name[#path_name]

                  local path_heading = vim.split(parts[2], "#")
                  -- remove space
                  local path_linkheading = string.gsub(path_heading[#path_heading], "^%s", "")

                  vim.api.nvim_put({
                    "[[" .. path_file .. "#" .. path_linkheading .. "]]",
                  }, "c", false, true)
                end
              end,
            },
          }

          if note_ext == "neorg" then
            opts.fzf_opts = {

              ["--preview"] = fzf_lua.shell.preview_action_cmd(function(items)
                local selection = items[1]:match "[^%s]+" .. "." .. note_ext
                selection = os.getenv "HOME" .. "/Dropbox/neorg/" .. selection

                return "cat " .. selection
              end),
            }
          end

          if note_ext == "md" then
            opts.search = [[^#.*]]
            opts.cwd = Config.path.wiki_path
            opts.rg_opts =
              [[--column --hidden --no-heading --ignore-case --smart-case --color=always  --max-columns=4096 -g "*.md" -e ]]
          end

          opts.no_esc = true
          if note_ext == "norg" then
            return fzf_lua.fzf_exec(Util.neorg.finder_linkableGlobal(), opts)
          else
            return fzf_lua.live_grep_glob(opts)
          end
        end,
        "Note: insert title (global)",
      },
    },
  }

  -- local resuffle = {}
  for i, x in pairs(mappings) do
    if i == "i" then
      for g, gg in pairs(x) do
        vim.keymap.set(i, g, gg[1], { desc = gg[2], buffer = bufnr })
      end
    else
      for j, jj in pairs(x) do
        vim.keymap.set(i, j, jj[1], { desc = jj[2], buffer = bufnr })
      end
    end
  end
end

return M
