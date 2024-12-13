#!/usr/bin/env fish

set curr_brightness $(brightnessctl get)
set max_brightness $(brightnessctl max)
set curr_brightness $(math $curr_brightness x 100 / $max_brightness)

notify-send -h string:x-dunst-stack-tag:brightness -h int:value:$curr_brightness "backlight: $curr_brightness%"
