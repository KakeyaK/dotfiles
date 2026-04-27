sketchybar --add item volume right
sketchybar --set volume \
	script="$ITEM_DIR/volume/plugin.sh" \
	click_script='osascript -e '\''set volume output muted not (output muted of (get volume settings))'\'''
sketchybar --subscribe volume volume_change
