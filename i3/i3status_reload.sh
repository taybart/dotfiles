#!/usr/bin/env zsh

i3-msg -t command 'exec --no-startup-id killall i3bar'
sleep 1
i3-msg -t command 'exec --no-startup-id i3bar --bar_id=bar-0'
# i3-msg -t command 'exec --no-startup-id polybar'
