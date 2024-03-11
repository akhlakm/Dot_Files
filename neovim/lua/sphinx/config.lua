local config = {}

-- Global configs
config.opts = {
	python_ok = false, -- pip is available
	sphinx_ok = false, -- sphinx command is available
}

--- Store user defined options as globals
---@param opts table
config.set_user_opts = function(opts)
	config.user_opts = opts
end

return config
