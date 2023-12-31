#!/bin/bash

wb_cpu () {
    local idle tooltip usage
    
    idle=$(mpstat 2 1 | tail -1 | awk '{print $NF}')
    printf -v usage "%.1f" "$(bc -l <<< "100 - $idle")"
    tooltip="CPU Model : $(grep "model name" /proc/cpuinfo | head -1 | awk '{ for(i=4;i<=7;i++) printf "%s ", $i }')"
    
    (( $(printf "%'.0f" "$usage") > 85 )) && local class="warning"

    jq -nc \
        --arg text "$usage%" \
        --arg tooltip "$tooltip" \
        --arg class "$class" \
        '{ text: $text, tooltip: $tooltip, class: $class }'
}

wb_cpu