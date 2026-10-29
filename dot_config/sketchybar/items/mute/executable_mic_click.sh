#!/bin/bash

# Press Vorssaint's mic mute shortcut so it stays the single source of truth.
# The shortcut is stored as "<mod>+<mod>:<keycode>", e.g. "option+shift:0" (key code 0 = A).
"$CONFIG_DIR/helpers/keystroke/bin/keystroke" "$(defaults read com.vorssaint.utils micMuteShortcut)"
sleep 0.3
"$(dirname "$0")/plugin.sh"
