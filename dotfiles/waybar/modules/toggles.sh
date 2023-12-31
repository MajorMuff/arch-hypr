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

    printf -v tooltip "Gamemode  : Mod+G\nGammastep : Mod+R"

    jq -nc \
        --arg text "$text" \
        --arg tooltip "$tooltip" \
        '{ text: $text, tooltip: $tooltip }'
}

wb_toggles