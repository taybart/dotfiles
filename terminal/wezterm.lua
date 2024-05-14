local wezterm = require('wezterm')
-- local action = wezterm.action

local colors = {
  -- status_bg = '#071317',
  status_bg = '#1d2837',
  bg = '#272727',
  fg = '#ebdbb2',
  white = '#ebdbb2',
  yellow = '#fabc2e',
  red = '#cc231c',
  light_red = '#fb4833',
  dark_blue = '#3c7377',
  blue = '#448488',
  light_blue = '#83a597',
}
-- Powerline dividers
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0) -- The  symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2) -- The  symbol

wezterm.on('update-right-status', function(window)
  local date = wezterm.strftime(' %Y/%m/%d %H:%M:%S ')
  local utc = wezterm.strftime_utc('[%H]')

  window:set_right_status(wezterm.format({
    { Background = { Color = colors.status_bg } },
    { Foreground = { Color = colors.dark_blue } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = colors.dark_blue } },
    { Foreground = { Color = colors.yellow } },
    { Text = date },
    { Foreground = { Color = colors.light_red } },
    { Text = utc },
  }))
end)

wezterm.GLOBAL.tab_titles = {}
wezterm.on('format-tab-title', function(tab, _, panes)
  local tab_id = tostring(tab.tab_id)

  if tab.is_active then
    for _, pane in ipairs(panes) do
      local pane_title = pane.title
      if pane_title:sub(1, 1) == '>' then
        local title = pane_title:sub(2)
        local current_titles = wezterm.GLOBAL.tab_titles
        current_titles[tab_id] = title
        wezterm.GLOBAL.tab_titles = current_titles
      end
    end
  end

  local title = wezterm.GLOBAL.tab_titles[tab_id] or tab.active_pane.title

  if tab.is_active then
    local style = {
      { Background = { Color = colors.dark_blue } },
      { Foreground = { Color = colors.status_bg } },
      { Text = SOLID_RIGHT_ARROW },
      { Background = { Color = colors.dark_blue } },
      { Foreground = { Color = colors.yellow } },
      { Text = ' ' .. title .. ' ' },
      { Background = { Color = colors.status_bg } },
      { Foreground = { Color = colors.dark_blue } },
      { Text = SOLID_RIGHT_ARROW },
    }
    -- no arrow on first tab
    if tab.tab_index == 0 then
      style[3] = { Text = ' ' }
    end
    return style
  end

  return '  ' .. title .. '  '
end)

local function scheme_for_appearance(appearance)
  if appearance:find('Dark') then
    return 'GruvboxDark'
  else
    return 'Catppuccin Latte'
  end
end

return {
  -- look
  -- color_scheme = 'GruvboxDark',
  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
  font = wezterm.font('JetBrains Mono'),
  font_size = 18,
  cursor_blink_rate = 0,
  colors = {
    -- background = colors.bg,
    tab_bar = {
      background = colors.status_bg,
      active_tab = { bg_color = colors.blue, fg_color = colors.yellow, intensity = 'Bold' },
      inactive_tab = { bg_color = colors.status_bg, fg_color = colors.white },
      inactive_tab_hover = { bg_color = colors.status_bg, fg_color = colors.white },
    },
  },
  tab_bar_style = {
    new_tab = '',
    new_tab_hover = '',
  },
  -- window
  window_decorations = 'RESIZE',
  use_fancy_tab_bar = false,
  enable_scroll_bar = false,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  -- behavior
  -- mux
  default_gui_startup_args = { 'connect', 'unix' },
  unix_domains = {
    {
      name = 'unix',
    },
  },
  enable_tab_bar = false,
  --[=[
  -- tmux-bindings
  leader = { key = 'b', mods = 'CTRL' },
  keys = {
    { key = ':', mods = 'LEADER', action = 'ShowLauncher' },
    {
      key = '-',
      mods = 'LEADER',
      action = action({ SplitVertical = { domain = 'CurrentPaneDomain' } }),
    },
    {
      key = '\\',
      mods = 'LEADER',
      action = action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }),
    },
    {
      key = 'h',
      mods = 'LEADER',
      action = action({ ActivatePaneDirection = 'Left' }),
    },
    {
      key = 'j',
      mods = 'LEADER',
      action = action({ ActivatePaneDirection = 'Down' }),
    },
    {
      key = 'k',
      mods = 'LEADER',
      action = action({ ActivatePaneDirection = 'Up' }),
    },
    {
      key = 'l',
      mods = 'LEADER',
      action = action({ ActivatePaneDirection = 'Right' }),
    },
    { key = 'H', mods = 'LEADER', action = action({ AdjustPaneSize = { 'Left', 5 } }) },
    { key = 'J', mods = 'LEADER', action = action({ AdjustPaneSize = { 'Down', 5 } }) },
    { key = 'K', mods = 'LEADER', action = action({ AdjustPaneSize = { 'Up', 5 } }) },
    { key = 'L', mods = 'LEADER', action = action({ AdjustPaneSize = { 'Right', 5 } }) },

    { key = 'n', mods = 'LEADER', action = action({ ActivateTabRelative = 1 }) },
    { key = 'p', mods = 'LEADER', action = action({ ActivateTabRelative = -1 }) },
    {
      key = 'c',
      mods = 'LEADER',
      action = action({ SpawnTab = 'CurrentPaneDomain' }),
    },
    {
      key = 'x',
      mods = 'LEADER',
      action = action({ CloseCurrentPane = { confirm = true } }),
    },
    {
      key = 'r',
      mods = 'LEADER',
      action = action.EmitEvent('custom-event'),
    },
    { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },
    { key = '[', mods = 'LEADER', action = 'ActivateCopyMode' },
    { key = '{', mods = 'LEADER', action = action({ RotatePanes = 'Clockwise' }) },
    { key = '}', mods = 'LEADER', action = action({ RotatePanes = 'CounterClockwise' }) },
  },
  --]=]
}
