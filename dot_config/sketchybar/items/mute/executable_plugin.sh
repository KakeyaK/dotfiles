#!/bin/bash

# Vorssaint owns the mic mute; it records the state in its preferences.
if [[ $(defaults read com.vorssaint.utils micMuteActive 2>/dev/null) == 1 ]]; then
	sketchybar --set mic icon=󰍭
else
	sketchybar --set mic icon=󰍬
fi
