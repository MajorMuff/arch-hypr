#!/bin/bash

wb_clock() {
    local datetime uptime_raw
    
    datetime="$(date '+%H:%M') <span alpha=\"60%\">$(date '+%Y-%m-%d')</span>"
    uptime_raw=$(uptime | awk '{ print $3 }' | sed 's/,//')

    printf -v uptime "%02d:%02d" \
        "$(cut -d: -f1 <<< "$uptime_raw")" \
        "$(cut -d: -f2 <<< "$uptime_raw")"

    jq -nc \
        --arg datetime "$datetime" \
        --arg uptime "Uptime : $uptime" \
        '{ text: $datetime, tooltip: $uptime }'
}

wb_clock