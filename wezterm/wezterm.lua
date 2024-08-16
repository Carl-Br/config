-- Pull in the wezterm API
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

config.color_scheme = 'Gotham (Gogh)'
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

-- allow left alt key be be used 
-- other wise it will be used as a meta key
config.send_composed_key_when_left_alt_is_pressed = true

config.keys = {
  -- Nur remappen, wenn nicht in Vim
  -- da sonst nicht auto completion funktioniert 
  -- sondern in die nächste Zeile gesprungen wird
  {
    key = 'j',
    mods = 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      local current_prog = pane:get_foreground_process_name()

      -- Nur remap, wenn das aktuelle Programm nicht Vim ist
      if not current_prog:match("vim") then
        win:perform_action(wezterm.action.SendKey { key = 'RightArrow' }, pane)
      else
        -- Wenn in Vim, standardmäßiges Verhalten
        win:perform_action(wezterm.action.SendKey { key = 'j', mods = 'CTRL' }, pane)
      end
    end),
  },
}



return config

