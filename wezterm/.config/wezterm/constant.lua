local M = {}

M.config = {
	current_pane = 0,
	ctrl_f_pane_actived = false,
	ctrl_f_pane_id = {},
	set_last_pane = true,
	total_panes = {},
	workspaces = {},
}

function M.update_ctrl_f_panes(tbl_pane)
	if type(tbl_pane) ~= "table" then
		return error("we need a 'tbl_pane' as a table, but you insert as " .. tostring(type(tbl_pane)), nil)
	end

	if type(tbl_pane.pane_id) ~= "number" then
		return error("we need 'pane_id' as a number, but you insert as " .. tostring(type(tbl_pane.pane_id)), nil)
	end

	table.insert(M.config.ctrl_f_pane_id, tbl_pane)
end

function M.set_main_workspaces(opts)
	if #M.config.workspaces == 0 then
		M.config.workspaces = opts
	end
end

function M.get_main_workspaces()
	return M.config.workspaces
end

function M.get_tbl_ctrl_f_panes()
	return M.config.ctrl_f_pane_id
end

return M
