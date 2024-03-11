-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Shell
config.default_prog = { "bash", "-l" }

-- White colors
-- config.color_scheme = "Material"

-- font
config.font = wezterm.font("CaskaydiaCove Nerd Font")

-- Leader key
config.leader = { key = "\\", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {

	{ -- Close Tab
		key = "DownArrow",
		mods = "CMD",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},

	{ -- New Tab
		key = "UpArrow",
		mods = "CMD",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},

	-- Tab navigation
	{ key = "LeftArrow", mods = "CMD", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "RightArrow", mods = "CMD", action = wezterm.action.ActivateTabRelative(1) },

	-- Split panes
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "=",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
}

-- and finally, return the configuration to wezterm
return config
