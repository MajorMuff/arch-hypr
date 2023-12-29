#!/bin/bash
#    ___      ___
#   |"  \    /"  | ⊏
#    \   \  //   | ⊓
#    /\   \/.    | ⊐
#   |: \.        | ⊔
#   |.  \    /:  | ⊏
#   |___|\__/|___| ⊓
#

module_cpu() {
    local idle usage tooltip

    idle=$(mpstat 2 1 | tail -1 | awk '{print $NF}')
    printf -v usage "%.1f%%" "$(bc -l <<< "100 - $idle")"
    tooltip="CPU Model: $(grep "model name" /proc/cpuinfo | head -1 | awk '{ for(i=4;i<=7;i++) printf "%s ", $i }')"

    jq -nc \
        --arg text "$usage" \
        --arg tooltip "$tooltip" \
        '{ text: $text, tooltip: $tooltip }'
}

module_cpu