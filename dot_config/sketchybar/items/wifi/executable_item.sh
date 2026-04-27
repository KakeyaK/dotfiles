sketchybar --add item wifi right
sketchybar --set wifi \
	update_freq=15 \
	script="$ITEM_DIR/wifi/plugin.sh" \
	click_script='open "x-apple.systempreferences:com.apple.Network-Settings.extension"'
