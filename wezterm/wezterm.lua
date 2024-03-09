-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Shell
config.default_prog = { 'bash', '-l' }

-- config.color_scheme = 'AdventureTime'

config.keys = {

  	{	-- Close Tab
    		key = 'DownArrow',
    		mods = 'CMD',
    		action = wezterm.action.CloseCurrentTab { confirm = false },
  	},

  	{	-- New Tab
    		key = 'UpArrow',
    		mods = 'CMD',
    		action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  	},

	-- Tab navigation
	{ key = 'LeftArrow', mods = 'CMD', action = wezterm.action.ActivateTabRelative(-1) },
  	{ key = 'RightArrow', mods = 'CMD', action = wezterm.action.ActivateTabRelative(1) },

}


-- and finally, return the configuration to wezterm
return config

