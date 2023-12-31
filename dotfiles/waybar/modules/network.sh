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
    
    printf -v kb_up "%'.0d" "$(bc <<< "$(cat /sys/class/net/enp34s0/statistics/tx_bytes) / 1024")"
    printf -v kb_dn "%'.0d" "$(bc <<< "$(cat /sys/class/net/enp34s0/statistics/rx_bytes) / 1024")"

    printf -v tooltip "Link speed : %s\nLocal IP   : %s\nPublic IP  : %s\n\nSent       : %s\nReceived   : %s" \
        "${link_speed//,/.} MB" \
        "$local_ip" \
        "$public_ip" \
        "${kb_up//,/.} KB" \
        "${kb_dn//,/.} KB"

    jq -nc \
        --arg text "$local_ip" \
        --arg tooltip "$tooltip" \
        --arg class "$class" \
        --arg alt "$icon" \
        '{ text: $text, class: $class, tooltip: $tooltip, alt: $alt }'
}

wb_network
