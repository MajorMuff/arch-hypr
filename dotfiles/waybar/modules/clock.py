#!/usr/bin/env python

import datetime, json

now = datetime.datetime.now()
time = now.strftime("%H:%M:%S")
date = "<span alpha=\"60%\">" + now.strftime("%Y-%m-%d") + "</span>"
text = time + " " + date

with open('/proc/uptime', 'r') as f:
    uptime_sec = int(f.readline().split('.')[0])

uptime = str(datetime.timedelta(seconds=uptime_sec))
tooltip = "Uptime : " + uptime

output = {
    "text": text,
    "tooltip": tooltip
}

print(json.dumps(output))