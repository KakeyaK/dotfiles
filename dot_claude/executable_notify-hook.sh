#!/bin/bash
# Plays Glass.aiff for audio feedback, and when system audio is muted,
# also displays a macOS notification so a muted user still notices.
# Usage: notify-hook.sh <fallback-message>
# Reads hook JSON from stdin and uses .message when present.

FALLBACK="${1:-Claude is waiting}"
INPUT=$(cat)

/usr/bin/afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &

# Volume 0 counts as muted too: turning the volume all the way down leaves "output muted" false.
VOL=$(osascript -e 'set s to get volume settings' -e '(output muted of s as text) & "," & (output volume of s as text)' 2>/dev/null)
if [ "${VOL%%,*}" = "true" ] || [ "${VOL#*,}" = "0" ]; then
  MSG=$(printf '%s' "$INPUT" | /usr/bin/jq -r '.message // empty' 2>/dev/null)
  [ -z "$MSG" ] && MSG="$FALLBACK"
  osascript -e 'on run argv
display notification (item 1 of argv) with title "Claude Code"
end run' -- "$MSG" >/dev/null 2>&1 &
fi
