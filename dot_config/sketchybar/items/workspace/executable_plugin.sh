#!/bin/bash

# =========================================================
# ATOMIC MUTEX LOCK (Prevents Race Conditions)
# =========================================================
LOCK_DIR="/tmp/aerospace_sketchybar.lock"

LOCK_ATTEMPTS=0
while ! mkdir "$LOCK_DIR" 2>/dev/null; do
	sleep 0.05
	LOCK_ATTEMPTS=$((LOCK_ATTEMPTS + 1))
	if [ $LOCK_ATTEMPTS -gt 20 ]; then
		rmdir "$LOCK_DIR" 2>/dev/null
		break
	fi
done
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT

# =========================================================
# STYLING VARIABLES
# =========================================================

INTER_GROUP_SPACER_WIDTH=10
OUTER_SPACER_WIDTH=8

SPACE_LABEL_FONT="SF Pro:Bold:14.0"
SPACE_LABEL_COLOR=0xFFFFFFFF
SPACE_PAD_LEFT=10
SPACE_PAD_RIGHT=8

APP_ICON_SCALE_FOCUSED=0.9
APP_ICON_SCALE_UNFOCUSED=0.7
APP_ICON_PAD_LEFT=2
APP_ICON_PAD_RIGHT=2
WINDOW_BG_FOCUSED=0x00000000
WINDOW_BG_UNFOCUSED=0x00000000
WINDOW_CORNER_RADIUS=6

MARKER_FONT="Hack Nerd Font Mono:Bold:18.0"
MARKER_PAD_LEFT_START=0
MARKER_PAD_RIGHT_START=2
MARKER_PAD_LEFT_END=0
MARKER_PAD_RIGHT_END=0

ANIMATION_EASING="sin"
ANIMATION_DURATION="7"

BRACKET_COLOR_FOCUSED=0x60FFFFFF
BRACKET_COLOR_UNFOCUSED=0x20FFFFFF
BRACKET_CORNER_RADIUS=8
BRACKET_HEIGHT=32
BRACKET_PAD_LEFT=4
BRACKET_PAD_RIGHT=4

# =========================================================
# INSTANT REALITY CHECK
# =========================================================
BAR_DATA=$(sketchybar --query bar 2>/dev/null)
if [ -z "$BAR_DATA" ]; then
	exit 0 # Failsafe: If Sketchybar is overwhelmed/unresponsive, drop the event
fi

# We strictly query only standard aerospace items and the individual workspace brackets
CURRENT_FLAT=$(echo "$BAR_DATA" | grep -Eo '"(aerospace\.[^"]+|bracket\.workspace\.[^"]+)"' | tr -d '"' | tr '\n' ' ')
CURRENT_ITEMS=($CURRENT_FLAT)
CURRENT_STRING=" $CURRENT_FLAT "

add_item_if_new() {
	if [[ ! "$CURRENT_STRING" == *" $1 "* ]]; then
		ARGS+=("--add" "item" "$1" "left")
	fi
}

# =========================================================
# HELPER FUNCTIONS
# =========================================================

render_windows() {
	local windows_list="$1"

	while IFS='|' read -r W_WS WINDOW_ID APP_NAME LAYOUT WINDOW_TITLE; do
		[ -z "$WINDOW_ID" ] && continue
		WINDOW_CLICK_SCRIPT="aerospace workspace \"$W_WS\""

		WINDOW_ITEM="aerospace.window.$W_WS.$WINDOW_ID"
		EXPECTED_ITEMS+=("$WINDOW_ITEM")
		REORDER_ITEMS+=("$WINDOW_ITEM")

		add_item_if_new "$WINDOW_ITEM"

		ARGS+=("--set" "$WINDOW_ITEM"
			display="$MONITOR"
			background.image="app.$APP_NAME"
			background.corner_radius="$WINDOW_CORNER_RADIUS"
			padding_left="$APP_ICON_PAD_LEFT"
			padding_right="$APP_ICON_PAD_RIGHT"
			click_script="$WINDOW_CLICK_SCRIPT"
			icon.drawing=off
			label.drawing=off)

		if [ "$WINDOW_ID" = "$FOCUSED_WINDOW_ID" ]; then
			ARGS+=("--animate" "$ANIMATION_EASING" "$ANIMATION_DURATION" "--set" "$WINDOW_ITEM" background.color="$WINDOW_BG_FOCUSED" background.image.scale="$APP_ICON_SCALE_FOCUSED")
		else
			ARGS+=("--animate" "$ANIMATION_EASING" "$ANIMATION_DURATION" "--set" "$WINDOW_ITEM" background.color="$WINDOW_BG_UNFOCUSED" background.image.scale="$APP_ICON_SCALE_UNFOCUSED")
		fi
	done <<<"$windows_list"
}

# =========================================================
# MAIN SCRIPT
# =========================================================

if [ -z "$FOCUSED_WORKSPACE" ]; then
	FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi
FOCUSED_WINDOW_ID=$(aerospace list-windows --focused --format "%{window-id}" 2>/dev/null)

GC_ARGS=() # Separate array for Garbage Collection
ARGS=()
EXPECTED_ITEMS=()
REORDER_ITEMS=()

WORKSPACES_MONITORS=$(aerospace list-workspaces --all --format "%{workspace}|%{monitor-appkit-nsscreen-screens-id}|%{workspace-is-visible}")
ALL_WINDOWS=$(aerospace list-windows --all --format "%{workspace}|%{window-id}|%{app-name}|%{window-parent-container-layout}|%{window-title}")

HAS_PREVIOUS_GROUP=false

while IFS='|' read -r WS MONITOR_ID IS_VISIBLE; do
	[ -z "$WS" ] && continue

	ACCORDION_WINDOWS=""
	FREE_WINDOWS=""
	ACCORDION_COUNT=0
	ACCORDION_TYPE=""
	HAS_WINDOWS=false

	while IFS='|' read -r W_WS W_ID W_APP W_LAYOUT W_TITLE; do
		[ -z "$W_ID" ] && continue
		if [ "$W_WS" = "$WS" ]; then
			HAS_WINDOWS=true
			if [ "$W_LAYOUT" = "v_accordion" ] || [ "$W_LAYOUT" = "h_accordion" ]; then
				ACCORDION_WINDOWS+="$W_WS|$W_ID|$W_APP|$W_LAYOUT|$W_TITLE"$'\n'
				ACCORDION_COUNT=$((ACCORDION_COUNT + 1))
				[ -z "$ACCORDION_TYPE" ] && ACCORDION_TYPE="$W_LAYOUT"
			else
				FREE_WINDOWS+="$W_WS|$W_ID|$W_APP|$W_LAYOUT|$W_TITLE"$'\n'
			fi
		fi
	done <<<"$ALL_WINDOWS"

	if [ "$HAS_WINDOWS" = false ] && [ "$WS" != "$FOCUSED_WORKSPACE" ] && [ "$IS_VISIBLE" != "true" ]; then
		continue
	fi

	MONITOR="$MONITOR_ID"
	WORKSPACE_CLICK_SCRIPT="aerospace workspace \"$WS\""

	if [ "$HAS_PREVIOUS_GROUP" = true ]; then
		INTER_GROUP_SPACER_ITEM="aerospace.spacer.group.$WS"
		EXPECTED_ITEMS+=("$INTER_GROUP_SPACER_ITEM")
		REORDER_ITEMS+=("$INTER_GROUP_SPACER_ITEM")

		add_item_if_new "$INTER_GROUP_SPACER_ITEM"
		ARGS+=("--set" "$INTER_GROUP_SPACER_ITEM" display="$MONITOR" width="$INTER_GROUP_SPACER_WIDTH" click_script="$WORKSPACE_CLICK_SCRIPT" background.drawing=off icon.drawing=off label.drawing=off)
	fi

	SPACE_ITEM="aerospace.space.$WS"
	EXPECTED_ITEMS+=("$SPACE_ITEM")
	REORDER_ITEMS+=("$SPACE_ITEM")

	add_item_if_new "$SPACE_ITEM"
	ARGS+=("--set" "$SPACE_ITEM" display="$MONITOR" label="$WS" label.font="$SPACE_LABEL_FONT" label.color=$SPACE_LABEL_COLOR icon.drawing=off padding_left="$SPACE_PAD_LEFT" padding_right="$SPACE_PAD_RIGHT" click_script="$WORKSPACE_CLICK_SCRIPT")

	if [ "$HAS_WINDOWS" = true ]; then
		GROUP_INDEX=0

		if [ "$ACCORDION_COUNT" -ge 2 ]; then
			if [ "$ACCORDION_TYPE" = "v_accordion" ]; then
				START_MARKER_LABEL="["
				END_MARKER_LABEL="]"
			else
				START_MARKER_LABEL="("
				END_MARKER_LABEL=")"
			fi

			MARKER_START="aerospace.marker.start.$WS.$GROUP_INDEX"
			EXPECTED_ITEMS+=("$MARKER_START")
			REORDER_ITEMS+=("$MARKER_START")

			add_item_if_new "$MARKER_START"
			ARGS+=("--set" "$MARKER_START" display="$MONITOR" label="$START_MARKER_LABEL" label.font="$MARKER_FONT" padding_left="$MARKER_PAD_LEFT_START" padding_right="$MARKER_PAD_RIGHT_START" click_script="$WORKSPACE_CLICK_SCRIPT" icon.drawing=off background.drawing=off)

			render_windows "$ACCORDION_WINDOWS"

			MARKER_END="aerospace.marker.end.$WS.$GROUP_INDEX"
			EXPECTED_ITEMS+=("$MARKER_END")
			REORDER_ITEMS+=("$MARKER_END")

			add_item_if_new "$MARKER_END"
			ARGS+=("--set" "$MARKER_END" display="$MONITOR" label="$END_MARKER_LABEL" label.font="$MARKER_FONT" padding_left="$MARKER_PAD_LEFT_END" padding_right="$MARKER_PAD_RIGHT_END" click_script="$WORKSPACE_CLICK_SCRIPT" icon.drawing=off background.drawing=off)
		fi

		if [ "$ACCORDION_COUNT" -ge 2 ]; then
			WINDOWS_TO_RENDER="$FREE_WINDOWS"
		else
			WINDOWS_TO_RENDER="$ACCORDION_WINDOWS$FREE_WINDOWS"
		fi

		render_windows "$WINDOWS_TO_RENDER"
	fi

	OUTER_BRACKET_SPACER_ITEM="aerospace.spacer.outer.$WS"
	EXPECTED_ITEMS+=("$OUTER_BRACKET_SPACER_ITEM")
	REORDER_ITEMS+=("$OUTER_BRACKET_SPACER_ITEM")

	add_item_if_new "$OUTER_BRACKET_SPACER_ITEM"
	ARGS+=("--set" "$OUTER_BRACKET_SPACER_ITEM" display="$MONITOR" width="$OUTER_SPACER_WIDTH" click_script="$WORKSPACE_CLICK_SCRIPT" background.drawing=off icon.drawing=off label.drawing=off)

	WORKSPACE_BRACKET="bracket.workspace.$WS"
	EXPECTED_ITEMS+=("$WORKSPACE_BRACKET")

	if [[ ! "$CURRENT_STRING" == *" $WORKSPACE_BRACKET "* ]]; then
		ARGS+=("--add" "bracket" "$WORKSPACE_BRACKET"
			"/aerospace\.space\.$WS$/"
			"/aerospace\.marker\..*\.$WS\..*/"
			"/aerospace\.spacer\.outer\.$WS$/"
			"/aerospace\.window\.$WS\..*/")
	fi

	if [ "$WS" = "$FOCUSED_WORKSPACE" ]; then
		WORKSPACE_BG_COLOR=$BRACKET_COLOR_FOCUSED
	else
		WORKSPACE_BG_COLOR=$BRACKET_COLOR_UNFOCUSED
	fi

	ARGS+=("--set" "$WORKSPACE_BRACKET" click_script="$WORKSPACE_CLICK_SCRIPT" background.color=$WORKSPACE_BG_COLOR background.corner_radius=$BRACKET_CORNER_RADIUS background.height=$BRACKET_HEIGHT background.padding_left=$BRACKET_PAD_LEFT background.padding_right=$BRACKET_PAD_RIGHT)

	HAS_PREVIOUS_GROUP=true

done <<<"$WORKSPACES_MONITORS"

# =========================================================
# TWO-PHASE GARBAGE COLLECTION
# =========================================================

if [ ${#CURRENT_ITEMS[@]} -gt 0 ]; then
	EXPECTED_STRING=" ${EXPECTED_ITEMS[@]} "

	# PASS 1: Mark dead brackets for removal
	for ITEM in "${CURRENT_ITEMS[@]}"; do
		if [[ ! "$EXPECTED_STRING" == *" $ITEM "* ]]; then
			if [[ "$ITEM" == bracket.* ]]; then
				GC_ARGS+=("--remove" "$ITEM")
			fi
		fi
	done

	# PASS 2: Mark standard items for removal
	for ITEM in "${CURRENT_ITEMS[@]}"; do
		if [[ ! "$EXPECTED_STRING" == *" $ITEM "* ]]; then
			if [[ "$ITEM" != bracket.* ]]; then
				GC_ARGS+=("--remove" "$ITEM")
			fi
		fi
	done
fi

ARGS+=("--reorder" "${REORDER_ITEMS[@]}")

# PHASE 1: Send destructions first to let the memory manager clean up cleanly
if [ ${#GC_ARGS[@]} -gt 0 ]; then
	sketchybar "${GC_ARGS[@]}" >/dev/null 2>&1
fi

# PHASE 2: Send creations and reordering
if [ ${#ARGS[@]} -gt 0 ]; then
	sketchybar "${ARGS[@]}" >/dev/null 2>&1
fi
