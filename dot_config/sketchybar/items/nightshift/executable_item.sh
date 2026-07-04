#!/bin/bash

# Create the SketchyBar item
sketchybar --add item nightshift right \
	--set nightshift \
	update_freq=5 \
	script="$ITEM_DIR/nightshift/plugin.sh" \
	--subscribe nightshift mouse.clicked
