-- Pull in the wezterm API
local wezterm = require("wezterm")

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Shell
config.default_prog = { "bash", "-l" }

-- White colors
config.color_scheme = "Material"

-- font
config.font = wezterm.font("CaskaydiaCove Nerd Font")

-- Leader key
config.leader = { key = "\\", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {

	{ -- Close Tab
		key = "DownArrow",
		mods = is_darwin() and "CMD" or "CTRL",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},

	{ -- New Tab
		key = "UpArrow",
		mods = is_darwin() and "CMD" or "CTRL",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},

	-- Tab navigation
	{
		key = "LeftArrow",
		mods = is_darwin() and "CMD" or "CTRL",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = is_darwin() and "CMD" or "CTRL",
		action = wezterm.action.ActivateTabRelative(1),
	},

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
