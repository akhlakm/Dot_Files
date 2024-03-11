local command = {}

--- Register the plugin command
command.create_command = function()
	-- Create the sphinx command
	vim.api.nvim_create_user_command("Sphinx", function()
		print("sphinx running fine!")
	end, {})
end

return command
