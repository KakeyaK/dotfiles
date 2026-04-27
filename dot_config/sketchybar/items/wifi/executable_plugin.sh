#!/usr/bin/env bash

source "$CONFIG_DIR/icons.sh"

WIFI_LEVEL=$("$CONFIG_DIR/helpers/wifi/bin/wifi" 2>/dev/null | tr -d '[:space:]')

case "$WIFI_LEVEL" in
0)
	ICON="󰤭"
	;;
1)
	ICON="󰤟"
	;;
2)
	ICON="󰤢"
	;;
3)
	ICON="󰤥"
	;;
4)
	ICON="󰤨"
	;;
*)
	ICON="󰤭"
	WIFI_LEVEL=0
	;;
esac

sketchybar --set "$NAME" icon="$ICON"
