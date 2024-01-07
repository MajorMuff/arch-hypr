#!/bin/bash

wb_ram () {
    local raw total used perc

    raw=$(free -t --mega | tail -1)
    total=$(awk '{print $2}' <<< "$raw")
    used=$(awk '{print $3}' <<< "$raw")
    perc=$(bc -l <<< "100/$total*$used")

    (( $(printf "%'.0f" "$perc") > 85 )) && local class="warning"

    printf -v text "%.1f%%" "$perc"
    tooltip=$(
        printf "<span line_height=\"1.4\" color=\"#ffffff\">%-21s %-8s %-6s</span>\n" "PROCESS" "PID" "MEM"
        c="CCCCCC"
        while read -r pid rss command; do 
            printf "<span color=\"#${c}\">%-21s %-8s %-6s</span>\n" "$command" "$pid" "$rss"
            c=$(bc <<< "obase=16;ibase=16;${c}-141414")
        done < <(
            ps --no-headers -A -o pid -o rss -o comm:21 --sort=-rss | head -8 | awk 'NR>0 {$2=int($2/1024)"M";}{ print;}'
        )
    )
    
    jq -nc \
        --arg text "$text" \
        --arg tooltip "${tooltip//,/.}" \
        --arg class "$class" \
        '{ text: $text, tooltip: $tooltip, class: $class }'
}

wb_ram