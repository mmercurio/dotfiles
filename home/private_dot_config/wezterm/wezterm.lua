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
-- config.color_scheme = 'Atelierdune (dark) (terminal.sexy)'
-- config.color_scheme = 'Mono Amber (Gogh)'
-- config.color_scheme = 'Mono Yellow (Gogh)'

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

-- https://github.com/dfaerch/passrelay.wezterm
-- https://github.com/dfaerch/passrelay.wezterm/issues/11
--
-- IMPORTANT: 1Password CLI command `op read` MUST be used to read passwords because
-- other methods (`op item get`) are not reliable when the password contains special
-- characters such as quotes or commas.
--
-- `op_accounts` maps "title (vault name)" to "vault_id/item_id".
-- `get_password` calls `op read` which needs the vault id together with the item id.
-- The vault name is appended to the label so entries stay distinguishable (and searchable)
-- when titles repeat across vaults. Note: duplicate titles within the *same* vault will
-- collide making earlier same-titled items unreachable.
local passrelay_settings = (function()
  local op_bin = wezterm.home_dir .. "/bin/op"
  local op_accounts = {}

  local function get_userlist()
    local success, stdout, stderr = wezterm.run_child_process({ op_bin, "item", "list", "--tags", "wezterm", "--format=json" })
    if not success then
      error("op item list failed: " .. tostring(stderr))
    end

    local items = wezterm.json_parse(stdout)
    op_accounts = {}
    local labels = {}
    for _, item in ipairs(items) do
      local label = item.title .. " (" .. item.vault.name .. ")"
      op_accounts[label] = item.vault.id .. "/" .. item.id
      table.insert(labels, label)
    end
    return labels
  end

  local function get_password(user)
    local path = op_accounts[user]
    if not path then
      error("no known 1Password item for " .. tostring(user))
    end

    local success, stdout, stderr = wezterm.run_child_process({ op_bin, "read", "op://" .. path .. "/password" })
    if not success then
      error("op read failed: " .. tostring(stderr))
    end
    return stdout
  end

  return {
    get_userlist = get_userlist,
    get_password = get_password,
    hotkey = { mods = 'ALT|CTRL', key = 'p' },
  }
end)()
wezterm.plugin.require("https://github.com/dfaerch/passrelay.wezterm").apply_to_config(config, passrelay_settings)

-- and finally, return the configuration to wezterm
return config
