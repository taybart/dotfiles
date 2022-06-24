local wezterm = require('wezterm')

local colors = {
  bg = '#272727',
  fg = '#ebdbb2',
  white = '#ebdbb2',
  yellow = '#d79920',
  red = '#cc231c',
  blue = '#448488',
  light_blue = '#83a597',
}
-- Powerline dividers
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0) -- The  symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2) -- The  symbol

wezterm.on('update-right-status', function(window)
  local date = wezterm.strftime('%Y/%m/%d %H:%M:%S ')
  -- local utc = wezterm.strftime_utc('%H') -- on nightly
  window:set_right_status(wezterm.format({
    { Background = { Color = colors.bg } },
    { Foreground = { Color = colors.blue } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = colors.blue } },
    { Foreground = { Color = colors.yellow } },
    { Text = ' ' .. date },
  }))
end)

wezterm.on('format-tab-title', function(tab)
  if tab.is_active then
    local style = {
      { Background = { Color = colors.blue } },
      { Foreground = { Color = colors.yellow } },
      { Text = ' ' .. tab.active_pane.title .. ' ' },
      { Background = { Color = colors.bg } },
      { Foreground = { Color = colors.blue } },
      { Text = SOLID_RIGHT_ARROW },
    }
    if tab.tab_index ~= 0 then
      table.insert(style, 1, { Background = { Color = colors.blue } })
      table.insert(style, 2, { Foreground = { Color = colors.bg } })
      table.insert(style, 3, { Text = SOLID_RIGHT_ARROW })
    end
    return style
  end

  return '  ' .. tab.active_pane.title .. '  '
end)

return {
  -- behavior

  -- look
  color_scheme = 'Gruvbox Dark',
  font = wezterm.font('JetBrains Mono'),
  font_size = 18,
  cursor_blink_rate = 0,
  colors = {
    tab_bar = {
      background = colors.bg,
      active_tab = { bg_color = colors.blue, fg_color = colors.yellow, intensity = 'Bold' },
      inactive_tab = { bg_color = colors.bg, fg_color = colors.white },
      inactive_tab_hover = { bg_color = colors.white, fg_color = colors.bg },
    },
  },
  tab_bar_style = {
    new_tab = '',
  },

  -- window
  window_decorations = 'RESIZE',
  -- enable_tab_bar = false,
  use_fancy_tab_bar = false,
  enable_scroll_bar = false,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },

  -- mux
  unix_domains = {
    {
      name = 'unix',
    },
  },

  -- replace tmux
  leader = { key = 'f', mods = 'CTRL' },
  keys = {
    {
      key = '-',
      mods = 'LEADER',
      action = wezterm.action({ SplitVertical = { domain = 'CurrentPaneDomain' } }),
    },
    {
      key = '\\',
      mods = 'LEADER',
      action = wezterm.action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }),
    },
    {
      key = 'h',
      mods = 'LEADER',
      action = wezterm.action({ ActivatePaneDirection = 'Left' }),
    },
    {
      key = 'j',
      mods = 'LEADER',
      action = wezterm.action({ ActivatePaneDirection = 'Down' }),
    },
    {
      key = 'k',
      mods = 'LEADER',
      action = wezterm.action({ ActivatePaneDirection = 'Up' }),
    },
    {
      key = 'l',
      mods = 'LEADER',
      action = wezterm.action({ ActivatePaneDirection = 'Right' }),
    },
    { key = 'n', mods = 'LEADER', action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = 'p', mods = 'LEADER', action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = 'c', mods = 'LEADER', action = wezterm.action({ SpawnTab = 'CurrentPaneDomain' }) },
    {
      key = 'x',
      mods = 'LEADER',
      action = wezterm.action({ CloseCurrentPane = { confirm = true } }),
    },
    { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },
    { key = '[', mods = 'LEADER', action = 'ActivateCopyMode' },
  },
}
