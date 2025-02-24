local wezterm = require 'wezterm'

-- This will hold the configuration 
local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14

-- Hide top bar (changing to "None" breaks yabai)
config.window_decorations = "RESIZE"

-- Hide tabs
config.enable_tab_bar = false

-- Scheme
config.color_scheme = 'tokyonight'
config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10

-- Allow left Alt key to be used
config.send_composed_key_when_left_alt_is_pressed = true

-- Function to check if Neovim is the active process
local function is_in_nvim(pane)
    local process_name = wezterm.target_triple:find("windows") and
        pane:get_foreground_process_name():match("[^\\]+$") or
        pane:get_foreground_process_name():match("[^/]+$")
    return process_name == "nvim" or process_name == "nvim.exe"
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
