sketchybar --add event bluetooth_change "com.apple.bluetooth.status"
sketchybar --add item headphones right \
	--set headphones \
	icon=󰋋 \
	script="$ITEM_DIR/bluetooth_headphone/plugin.sh" \
	--subscribe headphones bluetooth_change
