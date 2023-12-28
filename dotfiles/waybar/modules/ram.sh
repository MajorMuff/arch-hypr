#!/bin/bash
#    ___      ___
#   |"  \    /"  | ⊏
#    \   \  //   | ⊓
#    /\   \/.    | ⊐
#   |: \.        | ⊔
#   |.  \    /:  | ⊏
#   |___|\__/|___| ⊓
#

module_ram() {
    local procfile available total usage text tooltip

    procfile=/proc/meminfo
    available=$(awk '/MemAvailable/ { print $2 }' "$procfile")
    total=$(awk '/MemTotal/ { print $2 }' "$procfile")
    usage=$(bc -l <<< "100 - (($available/$total)*100)")

    printf -v text "%.1f%%" "$usage"

    printf -v tooltip "Usage : %'.0f MB / %'.0f MB" \
        "$(bc -l <<< "($total - $available)/1024")" \
        "$(bc -l <<< "$total/1024")"
        
    jq -nc \
        --arg text "$text" \
        --arg tooltip "$(sed 's/,/./g' <<< "$tooltip")" \
        '{ text: $text, tooltip: $tooltip }'
} 

module_ram