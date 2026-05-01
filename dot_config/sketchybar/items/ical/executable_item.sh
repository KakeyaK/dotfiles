#!/usr/bin/env bash

sketchybar --add item ical right
sketchybar --set ical \
	update_freq=600 label.font="SF Pro:Regular:12.0" \
	label.color=0xf0ffffff \
	label.y_offset=-7 \
	width=0 \
	script="$ITEM_DIR/ical/plugin.sh" \
	click_script="$ITEM_DIR/ical/plugin.sh"
