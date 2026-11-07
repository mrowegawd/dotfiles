local M = {}
local ns = vim.api.nvim_create_namespace "org_heading_render"

local signs = { "1", "2", "3", "4", "5", "6", "7" }
local icons = { "󰲡", "󰲣", "󰲥", "󰲧", "󰲩", "󰲫" } -- "●", "○", "◆" ..

local hl_groups = {
  "@org.headline.level1",
  "@org.headline.level2",
  "@org.headline.level3",
  "@org.headline.level4",
  "@org.headline.level5",
  "@org.headline.level6",
}
local keyword_hl = { TODO = "OrgTodo", DONE = "OrgDone" }

local function render(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local reveal_row
  if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" and vim.api.nvim_get_current_buf() == buf then
    reveal_row = vim.api.nvim_win_get_cursor(0)[1] - 1
  end

  local in_src, src_start = false, nil
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local row = i - 1
    local lower = line:lower()

    if lower:match "^%s*#%+begin_src" then
      in_src, src_start = true, row
    elseif lower:match "^%s*#%+end_src" and in_src then
      for r = src_start, row do
        vim.api.nvim_buf_set_extmark(buf, ns, r, 0, { line_hl_group = "CodeBlock", priority = 50 })
      end
      in_src = false
    elseif not in_src then
      local stars = line:match "^(%*+)%s"
      if stars then
        local level = #stars
        local hl = hl_groups[math.min(level, #hl_groups)]
        local icon = icons[math.min(level, #icons)]
        local sign = signs[math.min(level, #signs)]
        local kw = line:match "^%*+%s+(%u+)"

        if kw and keyword_hl[kw] then
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            end_row = row,
            end_col = level,
            hl_group = hl,
            sign_text = sign,
            sign_hl_group = hl,
            priority = 100,
          })
        else
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            end_row = row,
            end_col = #line,
            hl_group = hl,
            sign_text = sign,
            sign_hl_group = hl,
            priority = 100,
          })
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

        if row ~= reveal_row then
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            end_row = row,
            end_col = level,
            conceal = "",
            priority = 110,
          })
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
            virt_text = { { icon, hl } },
            virt_text_pos = "inline",
            priority = 110,
          })
        end
      end
    end
  end
end

local function safe_render(buf)
  local ok, err = pcall(render, buf)
  if not ok then
    vim.notify("org-heading render error: " .. tostring(err), vim.log.levels.ERROR)
  end
end

local function setup_window()
  vim.wo.conceallevel = 2
  vim.wo.concealcursor = "nc"
  vim.wo.signcolumn = "yes"
end

local function attach(buf)
  if vim.b[buf].org_heading_attached then
    return
  end
  vim.b[buf].org_heading_attached = true

  vim.api.nvim_create_autocmd(
    { "BufEnter", "TextChanged", "TextChangedI", "InsertEnter", "InsertLeave", "CursorMovedI" },
    {
      buffer = buf,
      callback = function()
        safe_render(buf)
      end,
    }
  )
  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    buffer = buf,
    callback = setup_window,
  })

  setup_window()
  safe_render(buf)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("org_heading_render", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "org",
    callback = function(args)
      attach(args.buf)
    end,
  })

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "org" then
      attach(buf)
    end
  end
end

return M
