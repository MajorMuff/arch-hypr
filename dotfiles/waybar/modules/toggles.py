#!/usr/bin/env python

import json

icons = ["", ""]
text = ""

with open('/home/coen/dotfiles/global.json', 'r') as f:
    toggles = json.load(f)['toggles']

i = 0
for t in toggles:
    if i > 0: text += "   "
    if toggles[t] == True:
        text += icons[i]
    else:
        text += "<span alpha=\"50%\">" + icons[i] + "</span>"
    i += 1

tooltip = "Gamemode:  Mod+G\nGammastep: Mod+R"

output = {
    "text": text,
    "tooltip": tooltip
}

print(json.dumps(output))