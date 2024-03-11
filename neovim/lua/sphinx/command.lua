local config = require("sphinx.config")

local command = {}

--- Register the plugin command
command.create_command = function()
	-- Create the sphinx command
	-- Plugin commands must start with uppercase letters.
	vim.api.nvim_create_user_command("Sphinx", function()
		-- Print information about setup.
		print("PIP:", config.opts.python_ok, "SPHINX:", config.opts.sphinx_ok)
	end, {})
end

return command
