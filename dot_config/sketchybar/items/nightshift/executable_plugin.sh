#!/bin/bash

if [ "$SENDER" = "mouse.clicked" ]; then
	nightlight toggle
	sleep 0.5
fi

STATUS=$(nightlight status)

if [[ "$STATUS" == *"on"* ]]; then
	ICON="󰖔"
	ICON_COLOR="0xffffffff"
else
	ICON=""
	ICON_COLOR="0xffffffff"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$ICON_COLOR"
