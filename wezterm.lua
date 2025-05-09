-- Pull in the wezterm API
local wezterm = require 'wezterm'

return {                                -- replace username              download file and put it here
  window_background_image = "C:\\Users\\<username>\\AppData\\Local\\nvim\bg.png",
  window_background_opacity = 0.90,
  text_background_opacity = 0.6,
  enable_scroll_bar = false,
  font = wezterm.font("FiraCode Nerd Font"),
  font_size = 12.5,
  color_scheme = "Catppuccin Mocha",
}

