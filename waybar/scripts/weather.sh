#!/bin/sh

# get weather information
text="$(curl -s "https://wttr.in/$LOC?format=1")"
tooltip="$(curl -s "https://wttr.in/$LOC?0QT" |
  sed 's/\\/\\\\/g' |
  sed ':a;N;$!ba;s/\n/\\n/g' |
  sed 's/"/\\"/g')"

# output for Waybar
if ! echo "$text" | grep -q "Unknown location"; then
  echo "{\"text\": \"$text\", \"tooltip\": \"<tt>$tooltip</tt>\", \"class\": \"weather\"}"
fi
