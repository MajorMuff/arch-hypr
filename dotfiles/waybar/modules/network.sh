#!/bin/bash

wb_network () {
    local network_info link_speed local_ip public_ip
    icon="connected"

    network_info=$(ip addr show enp34s0)
    printf -v link_speed "%'.0d" "$(head -1 <<< "$network_info" | awk '{ print $NF }')"
    local_ip=$(grep 'inet' <<< "$network_info" | head -1 | awk '{ print $2 }' | cut -d/ -f1)
    public_ip=$(curl -s https://checkip.amazonaws.com/)

    if [ -z "$public_ip" ]; then
        public_ip="No connection!"
        local class="warning"
        icon="error"
    fi
    
    kb_dn=$(bc <<< "$(cat /sys/class/net/enp34s0/statistics/rx_bytes) / 1024")
    if (( kb_dn < 100000 )); then
        dn=$kb_dn
        dn_unit="KB"
    else
        dn=$(bc -l <<< "$kb_dn / 1024" | cut -d. -f1)
        dn_unit="MB"
    fi
    printf -v dn "%'.0d" "$dn"

    kb_up=$(bc <<< "$(cat /sys/class/net/enp34s0/statistics/tx_bytes) / 1024")
    if (( kb_up < 100000 )); then
        up=$kb_up
        up_unit="KB"
    else
        up=$(bc -l <<< "$kb_up / 1024" | cut -d. -f1)
        up_unit="MB"
    fi
    printf -v up "%'.0d" "$up"

    printf -v tooltip "Link speed : %s\nLocal IP   : %s\nPublic IP  : %s\n\nSent       : %s\nReceived   : %s" \
        "${link_speed//,/.} MB" \
        "$local_ip" \
        "$public_ip" \
        "${up//,/.} $up_unit" \
        "${dn//,/.} $dn_unit"

    jq -nc \
        --arg text "$local_ip" \
        --arg tooltip "$tooltip" \
        --arg class "$class" \
        --arg alt "$icon" \
        '{ text: $text, class: $class, tooltip: $tooltip, alt: $alt }'
}

wb_network
