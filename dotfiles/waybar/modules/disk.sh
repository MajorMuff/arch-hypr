#!/bin/bash

wb_disk () {
    read -ra "stats" <<< "$(df --total --block-size=M / | tail -1 | sed 's/M//g' | awk '{print $2, $3, $4, $5}')"
    
    printf -v total "%'.0d" "${stats[0]}"
    printf -v used "%'.0d" "${stats[1]}"
    printf -v available "%'.0d" "${stats[2]}"
    printf -v perc "%s" "${stats[3]}"

    tooltip=$(
        printf "Used :      %s\nAvailable : %s\nTotal :     %s" "${used}M" "${available}M" "${total}M"
    )
    
    
    jq -nc \
        --arg text "$perc" \
        --arg tooltip "${tooltip//,/.}" \
        '{ text: $text, tooltip: $tooltip }'
}

wb_disk