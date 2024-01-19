#!/bin/bash

wb_disk () {
    read -ra "stats" <<< "$(df --total --block-size=M / | tail -1 | sed 's/M//g' | awk '{print $2, $3, $4, $5}')"
    used_home=$(du --total --block-size=M -s "$HOME" | tail -1 | sed 's/M//g' | awk '{print $1}')
    printf -v used_home "%'.0d" "$used_home"
    
    printf -v total "%'.0d" "${stats[0]}"
    printf -v used "%'.0d" "${stats[1]}"
    printf -v available "%'.0d" "${stats[2]}"
    printf -v perc "%s" "${stats[3]}"

    tooltip=$(
        printf "Used      : %s\nHome      : %s\nAvailable : %s\nTotal     : %s" "${used}M" "${used_home}M" "${available}M" "${total}M"
    )
    
    
    jq -nc \
        --arg text "$perc" \
        --arg tooltip "${tooltip//,/.}" \
        '{ text: $text, tooltip: $tooltip }'
}

wb_disk