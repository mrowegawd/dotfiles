local fmt, cmd, fn = string.format, vim.cmd, vim.fn

-- TODO: buatkan untuk telescope, selain menggunakan fzflua
local use_fzflua = true
if as.use_search_telescope then
  use_fzflua = false
end

local function format_title(str, icon, icon_hl)
  return {
    { " " },
    { (icon and icon .. " " or ""), icon_hl or "DevIconDefault" },
    { str, "Bold" },
    { " " },
  }
end

local M = {}

function M.neorg_mappings_ft(bufnr)
  local neorg = require "neorg"
  local fzf_lua = require "fzf-lua"

  local mappings = {
    ["n"] = {
      ["<Leader>tq"] = {
        function()
          return cmd(fmt("TODOQuickfixList cwd=%s", fn.expand "%:p"))
        end,
        "Note(todocomment): find todo (curbuf)",
      },
      ["<Leader>tQ"] = {
        function()
          return cmd(fmt([[TODOQuickfixList cwd=%s]], as.wiki_path))
        end,
        "Note(todocomment): find global todo",
      },
      ["<Localleader>fT"] = {
        function()
          require("fzf-lua").live_grep {
            prompt = "  ",
            cwd = as.wiki_path,
            no_esc = true,
            search = [[^(\*|\*\*|\*\*\*|\*\*\*\*).*$]],
            fzf_opts = { ["--layout"] = false },

            winopts = {
              title = format_title("[Neorg] Title Global", " "),
              -- preview = {
              --   vertical = "up:55%",
              --   horizontal = "left:60%",
              --   layout = "vertical",
              -- },
            },
          }
        end,
        "Note(fzflua): title (global)",
      },
      ["<Localleader>ft"] = {
        function()
          require("fzf-lua").lgrep_curbuf {
            prompt = "  ",
            search = [[^(\*|\*\*|\*\*\*|\*\*\*\*).*$]],
            no_esc = true,
            fzf_opts = { ["--layout"] = false },
            winopts = {
              title = format_title("[Neorg] Title Curbuf", " "),
              -- preview = {
              --   vertical = "up:55%",
              --   horizontal = "left:60%",
              --   layout = "vertical",
              -- },
            },
          }
        end,
        "Note(fzflua): title (curbuf)",
      },
      ["<Localleader>fL"] = {
        function()
          cmd "normal yi}"
          local title = vim.fn.getreg '"0'
          local title_trim = title:gsub([[^:%$]], [[:\$]])

          -- vim.notify("find: " .. title_trim)

          require("fzf-lua").live_grep {
            prompt = "  ",
            cwd = as.wiki_path,
            no_esc = true,
            search = title_trim,
            fzf_opts = { ["--layout"] = "reverse" },
            winopts = {
              title = format_title("[Neorg] Link Friend", " "),
              -- preview = {
              --   vertical = "up:55%",
              --   horizontal = "right:60%",
              --   layout = "vertical",
              -- },
            },
          }
        end,
        "Note(fzflua): find link friends",
      },
      ["<Localleader>fl"] = {
        function()
          -- Karena use grep utk curbuf, agar bisa menggunakan regex
          -- pakai `lgrep_curbuf`
          require("fzf-lua").lgrep_curbuf {
            -- prompt = "[Neorg] Linkable❯ ",
            prompt = "  ",
            search = [[(\{:\$|\{http)]],
            no_esc = true,
            fzf_opts = { ["--layout"] = "reverse" },
            winopts = {
              -- split = "belowright new | wincmd J | resize 40",
              title = format_title("[Neorg] Link Curbuf", " "),
              -- preview = {
              --   vertical = "up:55%",
              --   horizontal = "right:60%",
              --   layout = "vertical",
              -- },
            },
          }
        end,
        "Note(fzflua): link curbuf",
      },
    },

    ["i"] = {
      ["l<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              -- split = "belowright new | wincmd J | resize 40",
              title = format_title("[Neorg] Link Curbuf", " "),
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

          return require("fzf-lua").fzf_exec(require("r.utils.neorg_notes").finder_sitelinkable(neorg), opts)
        end,
        "Note(fzflua): insert link (curbuf)",
      },
      ["t<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              -- split = "belowright new | wincmd J | resize 40",
              title = format_title("[Neorg] Title Curbuf", " "),
              -- preview = {
              --   hidden = "hidden",
              --   vertical = "up:55%",
              --   horizontal = "right:60%",
              --   layout = "vertical",
              -- },
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

          return require("fzf-lua").fzf_exec(require("r.utils.neorg_notes").finder_linkable(neorg), opts)
        end,
        "Note(fzflua): insert title (curbuf)",
      },
      ["T<cr>"] = {
        function()
          local opts = {
            prompt = "  ",
            winopts = {
              -- split = "belowright new | wincmd J | resize 40",
              title = format_title("[Neorg] Title Global", " "),
              -- preview = {
              --   vertical = "up:55%",
              --   horizontal = "right:60%",
              --   layout = "vertical",
              -- },
            },
            fzf_opts = {
              ["--preview"] = fzf_lua.shell.preview_action_cmd(function(items)
                local selection = items[1]:match "[^%s]+" .. ".norg"
                selection = os.getenv "HOME" .. "/Dropbox/neorg/" .. selection

                return "cat " .. selection
              end),
            },

            actions = {
              ["default"] = function(selected, _)
                local selection = selected[1]

                local link_path = selection:match "[^%s]+"

                local title = selection:match "*.+$"
                local trim_title = string.gsub(title, "*", "")

                vim.api.nvim_put({
                  "[" .. trim_title .. "]" .. "{:$/" .. link_path .. ":" .. title .. "}",
                }, "c", false, true)
              end,
            },
          }

          return require("fzf-lua").fzf_exec(require("r.utils.neorg_notes").finder_linkableGlobal(neorg), opts)
        end,
        "Note(fzflua): insert title (global)",
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
