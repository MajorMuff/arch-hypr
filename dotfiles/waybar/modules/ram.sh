#!/bin/bash

wb_ram () {
    local raw total used perc

    raw=$(free -t --mega | tail -1)
    total=$(awk '{print $2}' <<< "$raw")
    used=$(awk '{print $3}' <<< "$raw")
    perc=$(bc -l <<< "100/$total*$used")

    (( $(printf "%'.0f" "$perc") > 85 )) && local class="warning"

    printf -v text "%.1f%%" "$perc"
    printf -v tooltip "Usage : %'.0f MB / %'.0f MB" "$used" "$total"
    
    jq -nc \
        --arg text "$text" \
        --arg tooltip "${tooltip//,/.}" \
        --arg class "$class" \
        '{ text: $text, tooltip: $tooltip, class: $class }'
}

wb_ram