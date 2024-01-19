#!/bin/bash

wb_toggles () {
    local conf_global=$HOME/dotfiles/global.json
    local toggles=("gamemode" "gammastep")
    local icons=("" "")

    for (( i=0; i<${#toggles[@]}; i++ )); do
        [ -n "$text" ] && text+="   "
        current_state=$(jq -r ".toggles.${toggles[i]}" "$conf_global")
        if [ "$current_state" = true ]; then
            text+="${icons[i]}"
        else
            text+="<span alpha=\"50%\">${icons[i]}</span>"
        fi
    done

    printf -v tooltip "Terminal               : $ + Q
Launcher               : $ + Enter

Reload waybar config   : $ + Shift + B
Reload hyprland config : $ + Shift + R

Windows
  Move to workspace    : $ + Shift +  | 0-9
  Move in workspace    : $ + Alt + 
  Resize window        : $ + Ctrl + 
  Split                : $ + J
  Transparency         : $ + O
  Float                : $ + V

Toggles
  Gamemode             : $ + G
  Gammastep            : $ + R
  Second display       : Ctrl + Shift + 2

Wallpaper
  Next                 : $ + ]
  Previous             : $ + [

Screenshot
  Fullscreen           : $ + PrtScr
  Selection            : $ + Shift + S"


    jq -nc \
        --arg text "$text" \
        --arg tooltip "$tooltip" \
        '{ text: $text, tooltip: $tooltip }'
}

wb_toggles