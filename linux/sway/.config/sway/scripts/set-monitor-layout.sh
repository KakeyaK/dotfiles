#!/bin/bash

# Check connected outputs using swaymsg
outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .name' | sort)

if echo "$outputs" | grep -q 'DP-3' && \
   echo "$outputs" | grep -q 'DP-4' && \
   echo "$outputs" | grep -q 'eDP-1'; then

  swaymsg output eDP-1 scale 2.0 pos 5296 2865
  swaymsg output DP-3 mode 2560x1080@59.978Hz pos 2736 2491 
  swaymsg output DP-4 mode 1920x1080@60Hz pos 2736 1411
fi

