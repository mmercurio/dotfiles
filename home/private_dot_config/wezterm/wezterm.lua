-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font_with_fallback { "MesloLGS NF", "JetBrains Mono" }
config.font_size = 14
config.initial_cols = 100
config.initial_rows = 28

-- config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- window_decorations =
--   "NONE" - disables titlebar and border (borderless mode),
--   "TITLE" - disable the resizable border and enable only the title bar
--   "RESIZE" - disable the title bar but enable the resizable border
--   "TITLE | RESIZE" - Enable titlebar and border. This is the default.
config.window_decorations = "RESIZE"

config.color_scheme = "AlienBlood"
-- config.color_scheme = "Atelierdune (dark) (terminal.sexy)"
-- config.color_scheme = "Mono Amber (Gogh)"
-- config.color_scheme = "Mono Yellow (Gogh)"

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make JIRA issues clickable
-- Only matching very specific patterns; not every valid Jira issue key.
-- the first matched regex group is captured in $1.
table.insert(config.hyperlink_rules, {
  regex = [[\b([A-Z]{3,5}-\d{3,5})\b]],
  format = "https://grubhub.atlassian.net/secure/QuickSearch.jspa?searchString=$1",
})

local act = wezterm.action

config.keys = {
  { key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = false }) },
}

-- mouse_bindings: right click paste
-- https://github.com/wez/wezterm/discussions/3541
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

local passrelay = wezterm.plugin.require("https://github.com/dfaerch/passrelay.wezterm")
local passrelay_settings = {
  get_userlist = {
    format='json',
    -- Create new "title_vault" field with vault name added to title
    command = "~/bin/op item list --tags wezterm --format=json | jq 'map(.title_vault = .title + \" (\" + .vault.name + \")\")'",
    id_path = "id",
    label_path = "title_vault"
  },
  get_password = "~/bin/op read 'op://{vault.id}/{id}/password'",
  hotkey = { mods = 'ALT|CTRL', key = 'p' },
}
passrelay.apply_to_config(config,passrelay_settings)

-- and finally, return the configuration to wezterm
return config
