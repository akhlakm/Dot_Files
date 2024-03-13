-- Pull in the wezterm API
local wezterm = require("wezterm")

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local themes = {
	"Material",
	"PaulMillr",
	"SynthWave (Gogh)",
}

local function indexOf(array, value)
	for i, v in ipairs(array) do
		if v == value then
			return i
		end
	end
	return nil
end

wezterm.on("increment-theme", function(window, _)
	local overrides = window:get_config_overrides() or {}
	local config = window:effective_config()

	local index = 1
	if not overrides.color_scheme then
		index = indexOf(themes, config.color_scheme) or #themes
	else
		index = indexOf(themes, overrides.color_scheme) or #themes
	end

	overrides.color_scheme = themes[index + 1] or themes[1]
	window:set_config_overrides(overrides)
end)

wezterm.on("decrement-theme", function(window, _)
	local overrides = window:get_config_overrides() or {}
	local config = window:effective_config()

	local index = 1
	if not overrides.color_scheme then
		index = indexOf(themes, config.color_scheme) or 1
	else
		index = indexOf(themes, overrides.color_scheme) or 1
	end

	overrides.color_scheme = themes[index - 1] or themes[#themes]
	window:set_config_overrides(overrides)
end)

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

	-- Change theme
	{
		key = "]",
		mods = "LEADER",
		action = wezterm.action.EmitEvent("increment-theme"),
	},
	{
		key = "[",
		mods = "LEADER",
		action = wezterm.action.EmitEvent("decrement-theme"),
	},
}

-- and finally, return the configuration to wezterm
return config
