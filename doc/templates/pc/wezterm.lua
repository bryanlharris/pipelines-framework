local wezterm = require 'wezterm'

return {
  font_size = 13.0,
  default_prog = { "pwsh.exe", "-NoLogo" },
  enable_tab_bar = true,
  default_cursor_style = "SteadyBlock",
  front_end = "WebGpu",
  keys = {
    -- Cycle panes; wraps from last to first. Replaces Quick Select.
    { key = 'Space', mods = 'CTRL|SHIFT',     action = wezterm.action.ActivatePaneDirection 'Next' },
    { key = 'Space', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.ActivatePaneDirection 'Prev' },
  },
}
