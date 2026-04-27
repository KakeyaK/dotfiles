sketchybar --add event aerospace_mode_change

# Renamed to wm_mode to avoid conflicts with aerospace name in workspace item
sketchybar --add item wm_mode right \
	--set wm_mode \
	width=24 \
	icon.drawing=off \
	label="loading" \
	label.font="SF Pro:Bold:14.0" \
	label.padding_left=6 \
	label.padding_right=6 \
	background.height=24 \
	background.corner_radius=14 \
	padding_right=8 \
	script="$ITEM_DIR/aerospace_mode/plugin.sh" \
	--subscribe wm_mode aerospace_mode_change
