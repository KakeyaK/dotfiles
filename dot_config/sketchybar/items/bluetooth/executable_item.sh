sketchybar --add event bluetooth_change "com.apple.bluetooth.status"
sketchybar --add item bluetooth right
sketchybar --set bluetooth \
	icon=󰂯 \
	script="$ITEM_DIR/bluetooth/plugin.sh" \
	click_script='open "x-apple.systempreferences:com.apple.Bluetooth"'
sketchybar --subscribe bluetooth bluetooth_change
