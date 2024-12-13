#!/usr/bin/env fish

set vol $(wpctl get-volume @DEFAULT_SINK@)

if echo $vol | grep -q MUTE
    set message "volume: muted"
    set percent 0
else
    set percent $(echo $vol | awk '{printf("%d\n", 100 * $2)}')
    set message "volume: $percent%"
end

notify-send -h string:x-dunst-stack-tag:volume -h int:value:$percent "$message"
