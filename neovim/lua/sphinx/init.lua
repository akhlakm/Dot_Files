local config = require("sphinx.config")
local command = require("sphinx.command")

local sphinx = {}

--- Function to setup the plugin
---@param opts table Options to pass to the plugin
sphinx.setup = function(opts)
	opts = opts or {}

	-- Store global options
	if vim.fn.executable("pip") == 1 then
		config.opts.python_ok = true
	end

	if vim.fn.executable("sphinx-build") == 1 then
		config.opts.sphinx_ok = true
	end

	-- Store user options
	config.set_user_opts({
		test = opts.test or nil,
	})

	command.create_command()
end

return sphinx
