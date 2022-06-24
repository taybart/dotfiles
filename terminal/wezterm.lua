local wezterm = require('wezterm')

return {
  color_scheme = 'Gruvbox Dark',
  font = wezterm.font('JetBrains Mono'),
  font_size = 18,
  cursor_blink_rate = 0,

  window_decorations = 'RESIZE',
  enable_tab_bar = false,
  enable_scroll_bar = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
}
