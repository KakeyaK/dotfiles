#!/usr/bin/env bash
BT_STATE=$(system_profiler SPBluetoothDataType 2>/dev/null | grep "State:" | awk '{print $2}')

if [ "$BT_STATE" = "On" ]; then
	sketchybar --set bluetooth icon="󰂯"
else
	sketchybar --set bluetooth icon="󰂲"
fi
