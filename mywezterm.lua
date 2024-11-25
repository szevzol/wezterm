-- Pull in the wezterm API
local wezterm = require 'wezterm'
local module = {}
local mux = wezterm.mux

function module.apply_to_config(config)
  config.default_prog = { 'nu' }

  config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
  config.font_size = 10.0
  wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end)

  config.debug_key_events = true
  config.keys = {
    {
      key = 'LeftArrow',
      mods = 'CTRL',
      action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
      key = 'RightArrow',
      mods = 'CTRL',
      action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
      key = 'UpArrow',
      mods = 'CTRL',
      action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
      key = 'DownArrow',
      mods = 'CTRL',
      action = wezterm.action.ActivatePaneDirection 'Down',
    },
    {
      key = 'R',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, _, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
    {
      key = "I",
      mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(_, pane)
        local tab = pane:tab()
        local panes = tab:panes_with_info()
        if #panes == 1 then
          pane:split({
            direction = "Right",
            size = 0.5,
          })
        elseif not panes[1].is_zoomed then
          panes[1].pane:activate()
          tab:set_zoomed(true)
        elseif panes[1].is_zoomed then
          tab:set_zoomed(false)
          panes[2].pane:activate()
        end
      end),
    },
  }
  -- This is where you actually apply your config choices

  -- For example, changing the color scheme:
  -- config.color_scheme = 'AdventureTime'

  -- and finally, return the configuration to wezterm
end

return module
