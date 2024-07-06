-- cwd: ~/.config/yazi/plugins/testdong.yazi/init.lua
local function entry(_, args)
	local child, err = Command("notify-send")
		:args({ "test from yazi" })
		:stdin(Command.INHERIT)
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	-- local child, err = Command(shell_value)
	-- 	:args({ "-c", cmd_args })
	-- 	:cwd(cwd)
	-- 	:stdin(Command.INHERIT)
	-- 	:stdout(Command.PIPED)
	-- 	:stderr(Command.INHERIT)
	-- 	:spawn()
	--
	if not child then
		return fail("Spawn `rfzf` failed with error code %s. Do you have it installed?", err)
	end
	--
	local output, err = child:wait_with_output()
	if not output then
		return fail("No output! %s", err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail("`something went wrong %s", output.status.code)
	end
end

return { entry = entry }
