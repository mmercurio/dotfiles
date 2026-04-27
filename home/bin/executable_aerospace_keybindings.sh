#!/usr/bin/env bash
#
# Display AeroSpace Key Bindings using using https://swiftdialog.app
# Also requires jq.
#
# In order to call this from within AreoSpace ensure this script,
# swiftdialog, and jq are in AeroSpace's PATH exec-* environment.
# You may need to set it in areaspace.toml like:
#
# [exec.env-vars]
#    PATH = '${HOME}/bin:/opt/homebrew/bin:/usr/local/bin:${PATH}'
#
# More here: https://nikitabobko.github.io/AeroSpace/guide#exec-env-vars

# Which binding modes to include in dialog
binding_modes="main service"

# specify font size
font_size=14.0

# Adjust size of dialog if needed
height=700
width=1000

# Transform AreoSpace JSON key binding output to
# Markdown table with 4 columns (two columns of key bindings)
to_table() {
    jq -r '
        to_entries as $e
        | ($e | length / 2 | ceil) as $half
        | "| Key | Command | Key | Command |",
          "| --- | --- | --- | --- |",
          (range($half) |
            "| " + $e[.].key + " | " + $e[.].value + " | " +
            (if $e[.+$half] then $e[.+$half].key + " | " + $e[.+$half].value else " | " end) + " |"
          )
    '
}

for mode in $binding_modes; do
    table=$(aerospace config --get "mode.${mode}.binding" --json | to_table)
    message+="### ${mode^} Mode\n\n${table}\n\n"
done

dialog --title "AeroSpace Key Bindings" \
    --icon none \
    --alignment center \
    --height $height \
    --width $width \
    --messagefont size=$font_size \
    --message "$message"
