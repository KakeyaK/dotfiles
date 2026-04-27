#!/usr/bin/env bash

DEVICES="$(system_profiler SPBluetoothDataType -json -detailLevel basic 2>/dev/null | jq '.SPBluetoothDataType' | jq '.[0]' | jq '.device_connected' | grep 'Headset')"

if [ "$DEVICES" = "" ]; then
	sketchybar --set headphones drawing=off
else
	sketchybar --set headphones drawing=on
fi
