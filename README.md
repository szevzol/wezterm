# wezterm

To load custom wezterm config:

1. Clone repo to `~/.config/wezterm`
2. Import custom config in `~/.wezterm.lua`:

   ```lua
    -- Pull in the wezterm API
    local wezterm = require 'wezterm'

    -- This will hold the configuration.
    local config = wezterm.config_builder()
    local mywezterm = require 'mywezterm'

    mywezterm.apply_to_config(config)

    return config

   ```
