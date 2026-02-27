-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("MesloLGS NF")
config.font_size = 14
config.initial_cols = 100
config.initial_rows = 28

config.enable_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true

-- window_decorations =
--   "NONE" - disables titlebar and border (borderless mode),
--   "TITLE" - disable the resizable border and enable only the title bar
--   "RESIZE" - disable the title bar but enable the resizable border
--   "TITLE | RESIZE" - Enable titlebar and border. This is the default.
config.window_decorations = "RESIZE"

config.window_background_opacity = 0.95

config.color_scheme = 'AlienBlood'

-- mouse_bindins: right click paste
-- https://github.com/wez/wezterm/discussions/3541
local act = wezterm.action

config.keys = {
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain =  'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain =  'CurrentPaneDomain' } },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = false } },
}

config.mouse_bindings = {
        {
                event = { Down = { streak = 1, button = "Right" } },
                mods = "NONE",
                action = wezterm.action_callback(function(window, pane)
                        local has_selection = window:get_selection_text_for_pane(pane) ~= ""
                        if has_selection then
                                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                                window:perform_action(act.ClearSelection, pane)
                        else
                                window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
                        end
                end),
        },
}

-- https://github.com/dfaerch/passrelay.wezterm
-- https://github.com/dfaerch/passrelay.wezterm/blob/v1/integrations/1password_desktop.md
local passrelay_settings = {
  get_userlist = {
    format='json',
    command = "~/bin/op item list --tags wezterm --format=json",
    id_path = "id",
    label_path = "title"
  },
  get_password = "~/bin/op item get %user --fields password --reveal",
  hotkey = { mods = 'CTRL', key = 'p' },
}
wezterm.plugin.require("https://github.com/dfaerch/passrelay.wezterm").apply_to_config(config, passrelay_settings)

-- and finally, return the configuration to wezterm
return config
