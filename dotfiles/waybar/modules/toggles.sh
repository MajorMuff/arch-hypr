#!/bin/bash
#    ___      ___
#   |"  \    /"  | ⊏
#    \   \  //   | ⊓
#    /\   \/.    | ⊐
#   |: \.        | ⊔
#   |.  \    /:  | ⊏
#   |___|\__/|___| ⊓
#

module_toggles(){
    local conf_global toggles icons text current_state tooltip

    conf_global=$HOME/dotfiles/global.json
    toggles=("gamemode" "gammastep")
    icons=("" "")
    text=""

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

module_toggles