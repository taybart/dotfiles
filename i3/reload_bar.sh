#!/usr/bin/env zsh

pkill i3bar && i3-msg -t command 'exec --no-startup-id i3bar --bar_id=bar-0'
