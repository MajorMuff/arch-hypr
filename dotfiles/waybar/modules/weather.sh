#!/bin/bash

wb_weather () {
    local lat lon results temperature cloud_cover precipitation is_day icon tooltip
    local conf_private=$HOME/dotfiles/private.json
    local options="temperature_2m,cloud_cover,precipitation,is_day"
    lat=$(jq ".location.latitude" "$conf_private")
    lon=$(jq '.location.longtitude' "$conf_private")
    local url="https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=${options}&timezone=Europe%2FAmsterdam"

    results=$(curl "$url" | jq '.current')
    temperature=$(jq -r ".temperature_2m" <<< "$results")
    cloud_cover=$(jq -r ".cloud_cover" <<< "$results")
    precipitation=$(jq -r ".precipitation" <<< "$results")
    is_day=$(jq -r ".is_day" <<< "$results")

    if (( is_day == 1 )); then
        icon="day_"
    else
        icon="night_"
    fi

    if [[ $(bc <<< "precipitation > 0.15") -eq 1 ]]; then
        icon+='rain'
    elif (( cloud_cover > 40 )); then
        icon+='clouds'
    else
        icon+="clear"
    fi

    printf -v tooltip "Temperature   : %s°C\nCloud cover   : %s%%\nPrecipitation : %.1fmm" \
        "$temperature" \
        "$cloud_cover" \
        "$precipitation"

    jq -nc \
        --arg temp "$temperature°C" \
        --arg icon "$icon" \
        --arg tooltip "$tooltip" \
        '{"text": $temp, "alt": $icon, "tooltip": $tooltip}'
}

wb_weather