local function fail(s, ...)
	ya.notify({ title = "Fzf", content = string.format(s, ...), timeout = 5, level = "error" })
end

local cwd = ya.sync(function()
	return cx.active.current.cwd
end)

return {
	entry = function()
		fail(tostring(cwd()))
	end,
}
