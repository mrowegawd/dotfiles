local add_on_file_type = require("vim-pack").add_on_file_type

local ConfigPath = require("config").path

add_on_file_type("markdown", {
  {
    src = "obsidian-nvim/obsidian.nvim",
    opts = function()
      return {
        dir = ConfigPath.wiki_path,
        legacy_commands = false,
        link = { style = "markdown" },
        workspaces = {
          {
            name = "journal",
            date_format = "%d-%m-%Y %A",
            time_format = "%H:%M",
            path = "~/Dropbox/neorg/journal",
          },
          {
            name = "work",
            path = "~/Dropbox/neorg/work",
          },
        },
        picker = {
          name = "fzf-lua",
        },
        daily_notes = {
          folder = "Drafts",
          date_format = "%Y-%B-%d",
        },
        notes_subdir = "journal",
        attachments = {
          img_text_func = function(path)
            local name = vim.fs.basename(tostring(path))
            local encoded_name = require("obsidian.util").urlencode(name)
            return string.format("![%s](%s)", name, encoded_name)
          end,
        },
        note_id_func = function(title)
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          local time = os.date("%Y-%m-%d", os.time() - 86400)
          return tostring(time) .. "_" .. suffix
        end,
        frontmatter = {
          func = function(note)
            local out = {
              id = note.id,
              aliases = note.aliases,
              tags = note.tags,
            }

            local getDate = function(metadata)
              if metadata.create_at then
                return metadata.create_at
              end

              local date = os.date "%Y-%m-%d %H:%M"
              return date
            end

            note.metadata = {
              create_at = getDate(note.metadata),
              last_edited = os.date "%Y-%m-%d %H:%M",
            }
            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
              for k, v in pairs(note.metadata) do
                out[k] = v
              end
            end
            return out
          end,
        },
        ui = { enable = false },
        footer = {
          enabled = false,
          format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
          hl_group = "Comment",
          separator = string.rep("-", 80),
        },
      }
    end,
  },
})
