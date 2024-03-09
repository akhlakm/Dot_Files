-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Shell
config.default_prog = { 'bash', '-l' }

-- config.color_scheme = 'AdventureTime'



-- and finally, return the configuration to wezterm
return config

