local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

config.adjust_window_size_when_changing_font_size = false

local is_windows = wezterm.target_triple:find("windows") ~= nil

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14
config.audible_bell = "Disabled"

config.visual_bell = {
	fade_in_duration_ms = 75,
	fade_out_duration_ms = 75,
	target = "CursorColor",
}

if is_windows then
	config.window_decorations = "TITLE | RESIZE" -- normale Titelleiste
else
	config.window_decorations = "RESIZE"
end
config.enable_tab_bar = false

-- Scheme
config.color_scheme = "tokyonight"
config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10

-- Allow left Alt key to be used
config.send_composed_key_when_left_alt_is_pressed = true

-- Function to check if Neovim is the active process
local function is_in_nvim(pane)
	local process_name = wezterm.target_triple:find("windows") and pane:get_foreground_process_name():match("[^\\]+$")
		or pane:get_foreground_process_name():match("[^/]+$")
	return process_name == "nvim"
end

-- Keybindings
config.keys = {
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_in_nvim(pane) then
				-- Allow <C-F> to be sent to Neovim (for Copilot)
				win:perform_action(wezterm.action.SendKey({ key = "f", mods = "CTRL" }), pane)
			else
				-- Default WezTerm behavior (you can disable this if needed)
				win:perform_action(wezterm.action.SendKey({ key = "f", mods = "CTRL" }), pane)
			end
		end),
	},
}

return config
