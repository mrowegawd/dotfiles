local M = {}
local ns = vim.api.nvim_create_namespace "org_heading_render"

local signs = { "1", "2", "3", "4", "5", "6", "7" }

local hl_groups = {
  "@org.headline.level1",
  "@org.headline.level2",
  "@org.headline.level3",
  "@org.headline.level4",
  "@org.headline.level5",
  "@org.headline.level6",
}

local keyword_hl = {
  TODO = "OrgTodo",
  DONE = "OrgDone",
  -- NEXT = "OrgTodo",
  -- WAITING = "OrgTodo",
  -- CANCELLED = "OrgDone",
}

function M.render(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local in_src = false
  local src_start

  for i, line in ipairs(lines) do
    local row = i - 1
    local lower = line:lower()

    if lower:match "^%s*#%+begin_src" then
      in_src, src_start = true, row
    elseif lower:match "^%s*#%+end_src" and in_src then
      for r = src_start, row do
        vim.api.nvim_buf_set_extmark(buf, ns, r, 0, {
          line_hl_group = "CodeBlock",
          priority = 50,
        })
      end
      in_src = false
    elseif not in_src then
      local stars = line:match "^(%*+)%s"
      if stars then
        local level = #stars
        local hl = hl_groups[math.min(level, #hl_groups)]

        local _, _, kw = line:find "^%*+%s+(%u+)"
        local has_kw = kw and keyword_hl[kw]

        if has_kw then
          -- Keyword heading, highlight only the sign and stars;
          -- let org.nvim handle the rest of the heading.
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            end_row = row,
            end_col = #stars,
            hl_group = hl,
            sign_text = signs[math.min(level, #signs)],
            sign_hl_group = hl,
            priority = 100,
          })
        else
          -- Regular heading: highlight the entire line.
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            end_row = row + 1,
            end_col = 0,
            hl_group = hl,
            hl_eol = true,
            sign_text = signs[math.min(level, #signs)],
            sign_hl_group = hl,
            priority = 100,
          })

          -- Restore tag highlighting e.g. :config:, :work:urgent:
          local s, _, tag = line:find "%s(:[%w_@#%%:]+:)%s*$"
          if tag and s then
            vim.api.nvim_buf_set_extmark(buf, ns, row, s, {
              end_row = row,
              end_col = s + #tag,
              hl_group = "OrgTags",
              priority = 200,
            })
          end
        end
      end
    end
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "org",
    callback = function(args)
      local buf = args.buf
      M.render(buf)
      vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave", "TextChangedI" }, {
        buffer = buf,
        callback = function()
          M.render(buf)
        end,
      })
    end,
  })
end

return M
