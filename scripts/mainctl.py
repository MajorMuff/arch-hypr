#!/usr/bin/env python3

import sys, os, time, subprocess, psutil

globalConf = '/home/coen/dotfiles/global.json'
privConf = '/home/coen/dotfiles/private.json'


def notify(title, output):
	subprocess.run('notify-send "' + \
		str(title) + '" "' + \
		str(output) + '"', shell=True)


def usage():
	print("helpfile")
	sys.exit()


def gammastep(args = ''):
	proc_file = '/tmp/gammastep.proc'

	if os.path.exists(proc_file):
		sys.exit()

	open(proc_file, "x")

	toggle_file = '/tmp/gammastep.toggle'

	def done():
		time.sleep(3)
		os.remove(proc_file)
		sys.exit()

	def gammastep_stop():
		if not os.path.exists(toggle_file): done()
		subprocess.run('killall gammastep &', shell=True)
		os.remove(toggle_file)
		if not '-s' in args: notify('Gammastep', 'Gammastep disabled.')
	
	def gammastep_start():
		if os.path.exists(toggle_file): done()
		import json
		location = json.load(open(privConf))['location']
		coords = str(location['latitude']) + ':' + str(location['longtitude'])
		color_temps = json.load(open(globalConf))['gammastep']
		colors = str(color_temps['temp_day']) + ':' + str(color_temps['temp_night'])
		open(toggle_file, "x")
		subprocess.run('gammastep -t ' + colors + ' -l ' + coords + ' &', shell=True)
		if not '-s' in args: notify('Gammastep', 'Gammastep enabled.')

	if 'start' in args:
		gammastep_start()
	elif 'stop' in args:
		gammastep_stop()
	elif 'toggle' in args:
		if os.path.exists(toggle_file):
			gammastep_stop()
		else:
			gammastep_start()
	else:
		usage()

	done()


def swayidle( args = '' ):
	proc_file = '/tmp/swayidle.proc'

	if os.path.exists(proc_file): sys.exit()

	open(proc_file, "x")

	toggle_file = '/tmp/swayidle.toggle'

	def done():
		time.sleep(1)
		os.remove(proc_file)
		return

	def swayidle_stop():
		if os.path.exists(toggle_file): os.remove(toggle_file)
		subprocess.run('killall swayidle', shell=True)
		if not '-s' in args: notify('Swayidle', 'Swayidle disabled.')

	def swayidle_start():
		if os.path.exists(toggle_file): done()
		import json
		config = json.load(open(globalConf))['swayidle']
		subprocess.run('swayidle timeout ' + str(config['timeout']) + \
			' \'' + config['actions']['idle'] + '\' \
			resume \'' + config['actions']['resume'] + '\' &', shell=True)
		open(toggle_file, "x")
		if not '-s' in args: notify('Swayidle', 'Swayidle enabled.')

	if 'start' in args:
		swayidle_start()
	elif 'stop' in args:
		swayidle_stop()
	elif 'toggle' in args:
		if os.path.exists(toggle_file):
			swayidle_stop()
		else:
			swayidle_start()
	else:
		usage()

	done()


def gamemode(args=''):
	proc_file = '/tmp/gamemode.proc'

	if os.path.exists(proc_file):
		sys.exit()

	open(proc_file, "x")

	toggle_file = '/tmp/gamemode.toggle'

	def done():
		time.sleep(2)
		os.remove(proc_file)
		sys.exit()

	def gamemode_start():
		if os.path.exists(toggle_file):	done()
		subprocess.run('launch hyprctl --batch \" \
			keyword decoration:active_opacity 1; \
			keyword decoration:inactive_opacity 1; \
			keyword decoration:fullscreen_opacity 1; \
			keyword decoration:drop_shadow false; \
			keyword decoration:rounding 0; \
			keyword decoration:blur:enabled false; \
			keyword general:gaps_in 0; \
			keyword general:gaps_out 0 \"', shell=True)

		subprocess.run('launch mainctl.py gammastep stop -s', shell=True)
		subprocess.run('launch mainctl.py swayidle stop -s', shell=True)

		open(toggle_file, "x")
		if not '-s' in args: notify('Gamemode', 'Gamemode enabled.')
	
	def gamemode_stop():
		if not os.path.exists(toggle_file): done()
		import json
		def s(p): return str(p).lower()
		d = json.load(open(globalConf))['hyprland']['decoration']
		g = json.load(open(globalConf))['hyprland']['general']
		subprocess.run('launch hyprctl --batch \" \
			keyword decoration:active_opacity ' + s(d['active_opacity']) + '; \
			keyword decoration:inactive_opacity ' + s(d['inactive_opacity']) + '; \
			keyword decoration:fullscreen_opacity ' + s(d['fullscreen_opacity']) + '; \
			keyword decoration:drop_shadow ' + s(d['drop_shadow']) + '; \
			keyword decoration:rounding ' + s(d['rounding']) + '; \
			keyword decoration:blur:enabled ' + s(d['blur']['enabled']) + '; \
			keyword general:gaps_in ' + s(g['gaps_in']) + '; \
			keyword general:gaps_out ' + s(g['gaps_out']) + '\"', shell=True)
		
		subprocess.run('launch mainctl.py swayidle start -s', shell=True)
		os.remove(toggle_file)
		if not '-s' in args: notify('Gamemode', 'Gamemode disabled.')

	if 'start' in args:
		gamemode_start()
	elif 'stop' in args:
		gamemode_stop()
	elif 'toggle' in args:
		if os.path.exists(toggle_file):
			gamemode_stop()
		else:
			gamemode_start()
	else:
		usage()

	done()


def main():
    if len(sys.argv) < 3:
    	usage()
    else:
    	args = str(sys.argv[1:])
    
    if 'swayidle' in args:
    	swayidle(args)
    elif 'gammastep' in args:
    	gammastep(args)
    elif 'gamemode' in args:
    	gamemode(args)


main()