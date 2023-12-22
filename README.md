## Scripts and dotfiles for my Arch install with Hyprland and Waybar

### dotfiles
Hyprland dots: [here](https://github.com/MajorMuff/arch-hypr/tree/main/dotfiles/hypr)

Waybar dots: [here](https://github.com/MajorMuff/arch-hypr/tree/main/dotfiles/waybar)



### scripts

[mainctl](https://github.com/MajorMuff/arch-hypr/blob/main/scripts/mainctl)

```
Bash script that manages several functions I use in Hyprland. It's a collection of functions that allow me to..:
 - toggle Gammastep, Swayidle, Gamemode
 - switch wallpapers
 - increase, decrease, mute volume
 - make screenshots
```


[wbmodules](https://github.com/MajorMuff/arch-hypr/blob/main/scripts/wbmodules)

Python script used to drive some modules on my waybar waybar. Currently it's used to show..:
 - local weather information using open-meteo (temperature, cloud cover, precipitation)
 - memory usage in percentage and MB
 - CPU usage in percentage
 - ethernet connection information (connection type, local ip, remote ip)



[paclog](https://github.com/MajorMuff/arch-hypr/blob/main/scripts/paclog)

 Bash script that generates a more readable pacman logfile. It can currently..:
  - show the log in descending and ascending order
  - show only installed or removed software
  - color code by whether the log entry was an installation or removal (only shows in terminal)

The rest of my scripts aren't very interesting in terms of functionality, most only perform a single task.