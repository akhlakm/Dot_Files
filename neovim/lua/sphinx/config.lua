local config = {}

--- Store user defined options as globals
---@param opts table
config.set_user_opts = function(opts)
	config.user_opts = opts
end

return config
