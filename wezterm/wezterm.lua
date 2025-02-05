local wezterm = require 'wezterm';

-- This will hold the configuration 
local config = wezterm.config_builder();

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14

-- hide top bar 
-- chaning this to None will break yabai
config.window_decorations = "RESIZE"

-- hide tabs
config.enable_tab_bar = false

-- scheme
config.color_scheme = 'tokyonight'
config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10


-- allow left alt key be be used 
-- other wise it will be used as a meta key
config.send_composed_key_when_left_alt_is_pressed = true

return config

