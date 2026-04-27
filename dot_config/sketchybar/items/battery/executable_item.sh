#!/usr/bin/env bash

sketchybar --add item battery right
sketchybar --set battery \
	update_freq=120 \
	script="$ITEM_DIR/battery/plugin.sh" \
	click_script='open "x-apple.systempreferences:com.apple.Battery-Settings.extension"'
sketchybar --subscribe battery system_woke power_source_change
