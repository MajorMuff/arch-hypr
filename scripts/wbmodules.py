#!/usr/bin/env python3
#
#    ___      ___
#   |"  \    /"  | ⊏
#    \   \  //   | ⊓
#    /\   \/.    | ⊐
#   |: \.        | ⊔
#   |.  \    /:  | ⊏
#   |___|\__/|___| ⊓
#
#
#   Usage: wbmodules.py [MODULE]
#   Allows starting waybar modules, mostly used for displaying system information.
#
#     --weather    Grabs weather information from open-meteo.com and parses json for display
#                  Tooltip displays detailed information
#
#     --clock      Displays date and time
#
#     --ram        Displays current RAM usage as a percentage
#                  Tooltip displays usage in MB
#
#     --cpu        Displays current CPU usage as a percentage
#
#     --toggles    Displays available toggles and their state
#                  Tooltip displays keybinds
#
#     --network    Displays local ip address
#                  Tooltip displays public ip address



def usage():
    import sys

    print('\nUsage: wbmodules.py [MODULE]')
    print('Allows starting waybar modules, mostly used for displaying system information.\n')
    print('  --weather    Grabs weather information from open-meteo.com and parses json for display')
    print('               Tooltip displays detailed information\n')
    print('  --clock      Displays date and time\n')
    print('  --ram        Displays current RAM usage as a percentage')
    print('               Tooltip displays usage in MB\n')
    print('  --cpu        Displays current CPU usage as a percentage\n')
    print('  --toggles    Displays available toggles and current state')
    print('               Tooltip displays keybinds\n')
    print('  --network    Displays local ip address')
    print('               Tooltip displays public ip address\n')

    sys.exit()



def format_int(val):
    return str('{:,}'.format( int(val) )).replace(',', '.')



def jprint(obj):
    import json
    print(json.dumps(obj) + '\\n')



def title(string):
    return '<span color=\"#eeeeee\">' + string + '</span>'



def module_weather():
    import requests

    latitude = '51.6992'
    longtitude = '5.3042'
    features = 'temperature_2m,cloud_cover,precipitation,is_day'

    url = str('https://api.open-meteo.com/v1/forecast?latitude=' + latitude + '&longitude=' + longtitude + '&current=' + features + '&timezone=auto')
    result = requests.get(url).json()["current"]

    temperature = str(result["temperature_2m"])
    cloud_cover = int(result["cloud_cover"])
    precipitation = float(result["precipitation"])
    is_day = int(result["is_day"])


    if precipitation > 0.5:
        icon = 'rain'
    elif cloud_cover > 60:
        icon = 'clouds'
    else:
        if is_day == 1:
            icon = 'clear'
        else:
            icon = 'clear_night'

    tooltip  = title('Den Bosch\n')
    tooltip += ' Temperature   : ' + temperature + '°C\n'
    tooltip += ' Cloud cover   : ' + str(cloud_cover) + '%\n'
    tooltip += ' Precipitation : ' + str(precipitation) + 'mm'

    output = {
        "text": temperature + '°C',
        "alt": icon,
        "tooltip": tooltip
    }

    jprint(output)



def module_clock():
    from datetime import datetime

    current_datetime =  datetime.now().strftime("%H:%M %Y-%m-%d").split(' ')
    current_time = current_datetime[0]
    current_date = '<span alpha=\"60%\">' + current_datetime[1] + '</span>'

    output = { "text": current_time + ' ' + current_date }

    jprint(output)



def module_ram():
    import psutil

    usage_percentage = str(psutil.virtual_memory().percent) + '%'

    usage_mb = format_int(psutil.virtual_memory().used / 1024 / 1024)
    total_mb = format_int(psutil.virtual_memory().total / 1024 / 1024)

    tooltip  = title('Memory\n')
    tooltip += ' Usage: ' + usage_mb + ' MB / ' + total_mb + ' MB'
    
    output = {
        "text": usage_percentage,
        "tooltip": tooltip
    }

    jprint(output)



def get_processor_name():
    import os, platform, subprocess, re

    if platform.system() == "Windows":
        return platform.processor()
    elif platform.system() == "Darwin":
        os.environ['PATH'] = os.environ['PATH'] + os.pathsep + '/usr/sbin'
        command ="sysctl -n machdep.cpu.brand_string"
        return subprocess.check_output(command).strip()
    elif platform.system() == "Linux":
        command = "cat /proc/cpuinfo"
        all_info = subprocess.check_output(command, shell=True).decode().strip()
        for line in all_info.split("\n"):
            if "model name" in line:
                return re.sub( ".*model name.*:", "", line,1)
    return ""



def module_cpu():
    import psutil

    idle_percentage = psutil.cpu_times_percent(interval=2, percpu=False).idle
    usage_percentage = str(round(100.0 - idle_percentage, 2)) + '%'
    
    cpu = get_processor_name().split(' ')
    cpu_name = ''
    for i in range(1,5):
        if not cpu_name == '':
            cpu_name += ' '

        cpu_name += cpu[i]

    tooltip  = title('CPU\n')
    tooltip += ' Model: ' + cpu_name

    output = {
        "text": usage_percentage,
        "tooltip": tooltip
    }

    jprint(output)



def module_toggles():
    import os

    toggles = [ 'gamemode', 'gammastep' ]
    toggle_icons = [ '', '' ]

    content = ''

    for i in range(len(toggles)):
        if not content == '': content += '    '
        toggle_file = '/tmp/' + toggles[i] + '.toggle'

        if os.path.isfile(toggle_file):
            content += toggle_icons[i]
        else:
            content += '<span alpha=\"50%\">' + toggle_icons[i] + '</span>'

    tooltip  = title('Keybinds\n')
    tooltip += ' Gamemode  : ' + 'Mod+G' + '\n'
    tooltip += ' Gammastep : ' + 'Mod+R'

    output = {
        "text": content,
        "tooltip": tooltip
    }

    jprint(output)



def module_network():
    import requests
    import psutil

    local_ip = psutil.net_if_addrs()['enp34s0'][0].address
    public_ip = requests.get('https://checkip.amazonaws.com').text.strip()
    speed = format_int(psutil.net_if_stats()['enp34s0'].speed)

    tooltip  = title('Network') + ' (enp34s0)\n'
    tooltip += ' Link   : ' + speed + 'Mb\n'
    tooltip += ' Local  : ' + local_ip + '\n'
    tooltip += ' Public : ' + public_ip

    output = {
        "text": local_ip,
        "tooltip": tooltip
    }

    jprint(output)



def main():
    import sys

    if len(sys.argv) < 2: usage()

    option = sys.argv[1]

    match option:
        case "--weather": module_weather()
        case "--clock": module_clock()
        case "--ram": module_ram()
        case "--cpu": module_cpu()
        case "--toggles": module_toggles()
        case "--network": module_network()
        case _: usage()

main()