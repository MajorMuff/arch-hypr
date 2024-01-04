#!/bin/bash

wb_cpu () {
    local idle tooltip usage
    
    idle=$(mpstat 2 1 | tail -1 | awk '{print $NF}')
    printf -v usage "%.1f" "$(bc -l <<< "100 - $idle")"
    
    #tooltip=$(ps --no-headers -Ao comm:21, -o pid:6, -o pcpu:6 --sort=-pcpu | head -5)

    tooltip=$(
        printf "<span line_height=\"1.4\" color=\"#ffffff\">%-21s %-8s %-6s</span>\n" "PROCESS" "PID" "CPU"
        while read -r pid cpu command; do 
            printf "%-21s %-8s %-6s\n" "$command" "$pid" "$cpu"
        done < <(
            ps --no-headers -A -o pid -o pcpu -o comm:21 --sort=-pcpu | head -5
        )
    )
    
    (( $(printf "%'.0f" "$usage") > 85 )) && local class="warning"

    jq -nc \
        --arg text "$usage%" \
        --arg tooltip "$tooltip" \
        --arg class "$class" \
        '{ text: $text, tooltip: $tooltip, class: $class }'
}

wb_cpu