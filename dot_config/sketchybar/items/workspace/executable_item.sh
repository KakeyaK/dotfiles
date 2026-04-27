sketchybar --add event aerospace_workspace_change

sketchybar --add item aerospace_controller left \
	--set aerospace_controller \
	script="$ITEM_DIR/workspace/plugin.sh" \
	width=0 \
	--subscribe aerospace_controller aerospace_workspace_change front_app_switched space_windows_change
