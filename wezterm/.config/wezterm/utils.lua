-- local wezterm = require("wezterm")

local M = {}
function M.cmd_call(params)
	local handle = io.popen(params)
	if handle == nil then
		return
	end
	local result = handle:read("*a")
	handle:close()
	return result:gsub("\n", "")
end

function M.get_random_entry(tbl)
	if tbl ~= "table" then
		return tbl
	end

	local keys = {}
	for key, _ in ipairs(tbl) do
		table.insert(keys, key)
	end
	local randomKey = keys[math.random(1, #keys)]
	return tbl[randomKey]
end

function M.is_nvim(pane)
	return pane:get_user_vars().IS_NVIM == "true" or pane:get_foreground_process_name():find("n?vim")
end

-- TAKEN FROM: https://wezfurlong.org/wezterm/recipes/passing-data.html#user-vars
-- check file: aliases.basrc

function M.is_tmux(pane)
	local isTmux = pane:get_user_vars().PROG

	if isTmux and isTmux == "tmux" or isTmux == "tm" then
		return true
	end

	return false
end

---Merges two tables
---@param t1 table
---@param ... table[] one or more tables to merge
---@return table t1 modified t1 table
M.tbl_merge = function(t1, ...)
	local tables = { ... }

	for _, t2 in ipairs(tables) do
		for k, v in pairs(t2) do
			if type(v) == "table" then
				if type(t1[k] or false) == "table" then
					M.tbl_merge(t1[k] or {}, t2[k] or {})
				else
					t1[k] = v
				end
			else
				t1[k] = v
			end
		end
	end

	return t1
end

-- https://stackoverflow.com/questions/52922469/remove-specific-entry-from-lua-table
M.removebyKey = function(tab, val)
	for i, v in ipairs(tab) do
		if v.pane_id == val then
			tab[i] = nil
		end
	end
end

function M.tint(color, percent)
	assert(color and percent, "cannot alter a color without specifying a color and percentage")
	local r = tonumber(color:sub(2, 3), 16)
	local g = tonumber(color:sub(4, 5), 16)
	local b = tonumber(color:sub(6), 16)
	if not r or not g or not b then
		return "NONE"
	end
	local blend = function(component)
		component = math.floor(component * (1 + percent))
		return math.min(math.max(component, 0), 255)
	end
	return string.format("#%02x%02x%02x", blend(r), blend(g), blend(b))
end

return M
