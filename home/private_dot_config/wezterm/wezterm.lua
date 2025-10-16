-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("MesloLGS NF")
config.font_size = 10

-- config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

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

-- and finally, return the configuration to wezterm
return config
