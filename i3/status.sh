#!/usr/bin/env bash

# */5 * * * * curl -s wttr.in/Denver\?format\="%C+%c+%t" > ~/.weather.cache

function update_holder {
  local instance="$1"
  local replacement="$2"
  echo "$json_array" | jq --argjson arg_j "$replacement" "(.[] | (select(.instance==\"$instance\"))) |= \$arg_j" 
}

i3status | (read line; echo "$line"; read line ; echo "$line" ; read line ; echo "$line" ; while true
do
  read line

  json_array="$(echo $line | sed -e 's/^,//')"

  weather=$(cat ~/.weather.cache)

# 
  json="{\"full_text\":\"${weather}\",\"color\":\"#FFFFFF\"}"
  json_array=$(update_holder holder__weather "$json")
  echo ",$json_array"
done)

