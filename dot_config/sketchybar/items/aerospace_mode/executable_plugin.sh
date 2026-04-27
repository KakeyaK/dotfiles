#!/usr/bin/env bash

# Fetch the current mode from AeroSpace
CURRENT_MODE=$(aerospace list-modes --current)

# Show only the first character in uppercase for compact badge display
MODE_LETTER=$(printf "%s" "$CURRENT_MODE" | cut -c1 | tr '[:lower:]' '[:upper:]')
if [ -z "$MODE_LETTER" ]; then
	MODE_LETTER="?"
fi

# Customize the styling based on the active mode
if [ "$CURRENT_MODE" = "main" ]; then
	# Standard styling for the default mode (or you could hide it completely)
	# sketchybar --set $NAME label.drawing=off \
	# 	background.drawing=off
	sketchybar --set $NAME label="$MODE_LETTER" \
		label.drawing=off \
		background.drawing=off
else
	# Highlight styling for alternative modes (e.g., service, resize)
	sketchybar --set $NAME label="$MODE_LETTER" \
		background.color=0x50FFFFFF \
		label.color=0xffFFFFFF \
		label.drawing=on \
		background.drawing=on
fi
