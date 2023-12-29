#!/bin/bash
#    ___      ___
#   |"  \    /"  | ⊏
#    \   \  //   | ⊓
#    /\   \/.    | ⊐
#   |: \.        | ⊔
#   |.  \    /:  | ⊏
#   |___|\__/|___| ⊓
#

network_info=$(ip addr show enp34s0)
printf -v link_speed "%'.0d" "$(head -1 <<< "$network_info" | awk '{ print $NF }')"
local_ip=$(grep 'inet' <<< $network_info | head -1 | awk '{ print $2 }' | cut -d/ -f1)
public_ip=$(curl -s https://checkip.amazonaws.com/)

printf -v tooltip "Link speed : %s\nLocal IP   : %s\nPublic IP  : %s" \
    "${link_speed//,/.} Mb" \
    "$local_ip" \
    "$public_ip"

jq -nc \
    --arg text "$local_ip" \
    --arg tooltip "$tooltip" \
    '{ text: $text, tooltip: $tooltip }'