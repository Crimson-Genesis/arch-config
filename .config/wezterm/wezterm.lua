local wezterm = require 'wezterm'
local config = {}

config.color_scheme_dirs = { '~/.config/wezterm/iTerm2-Color-Schemes/wezterm/' }
config.color_scheme = 'Tomorrow Night Bright (Gogh)'
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.font_size = 10.5
config.window_padding = {
  left = 20,
  right = 0,
  top = 15,
  bottom = 0,
}

config.bold_brightens_ansi_colors = true
config.window_background_opacity = 0.75
config.font = wezterm.font 'JetBrainsMono NF'

return config
