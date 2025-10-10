-- [plugins] - yazi-rs/git.yazi
-- show git status right after directory
th.git = th.git or {}
th.git.modified_sign = ""
th.git.added_sign = "✚"
th.git.untracked_sign = ""
th.git.ignored_sign = ""
th.git.deleted_sign = "✖"
th.git.updated_sign = ""
require("git"):setup {
  order = 500, -- order to show directory list. if 1500, gitsign go to rightmost
}

-- shorter header cwd
function Header:cwd()
  local max = self._area.w - self._right_width
  if max <= 0 then
    return ""
  end

  local s = tostring(ya.readable_path(tostring(self._current.cwd))):gsub("(%.?)([^/])[^/]+/", "%1%2/") .. self:flags()
  return ui.Span(ui.truncate(s, { max = max, rtl = true })):style(th.mgr.cwd)
end

-- function Header:redraw()
--   local right = self:children_redraw(self.RIGHT)
--   self._right_width = right:width()
--
--   local left = self:children_redraw(self.LEFT)
--
--   return {
--     ui.Line(left):area(self._area),
--     ui.Line(right):area(self._area):align(ui.Align.RIGHT),
--     table.unpack(ui.redraw(Progress:new(self._area, self._right_width))),
--   }
-- end
