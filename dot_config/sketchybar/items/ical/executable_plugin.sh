#!/usr/bin/env bash

# Data from the compiled swift script that reads the calendars
# See https://github.com/zigotica/macos-calendar-events
# This avoids TCC (Transparency, Consent, and Control) permission issues
# sketchybar does not have access to PATH, so you need to pass the full path to binary
# Update list of events, for up to 7 days ahead:
EVENTS_FILE="$HOME/.config/sketchybar/items/ical/events.txt"
~/.config/sketchybar/helpers/zigotica_calendar_events/bin/calendar_events 2 >"$EVENTS_FILE"

# Show tomorrow's event only when it starts within this many hours from now.
TOMORROW_EVENT_WINDOW_HOURS=18

EVENTS=$(cat "$EVENTS_FILE")

today=$(date +%F)
tomorrow=$(date -v+1d +%F)
now_hour=$(date +%H)
now_min=$(date +%M)
now_total_minutes=$((10#$now_hour * 60 + 10#$now_min))

today_event=""
today_all_day_event=""
tomorrow_event=""
tomorrow_event_start_minutes=""
all_day_event=""

# Process each event line
while IFS= read -r line; do
	[ -z "$line" ] && continue

	# Regex to match event lines format from calendar_events: "YYYY-MM-DD HH:MM-HH:MM | Event Title"
	# Group 1: ([0-9]{4}-[0-9]{2}-[0-9]{2}) captures the date (e.g., 2026-04-18)
	# Group 2: ([0-9]{2}:[0-9]{2}) captures the start time (e.g., 00:00)
	# [-–]: Matches either a hyphen or an en-dash separating start and end times
	# Group 3: ([0-9]{2}:[0-9]{2}) captures the end time (e.g., 23:59)
	# [[:space:]]\|[[:space:]]: Matches the " | " separator
	# Group 4: (.+) captures the rest of the line as the event title
	if [[ "$line" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})[[:space:]]([0-9]{2}:[0-9]{2})[-–]([0-9]{2}:[0-9]{2})[[:space:]]\|[[:space:]](.+)$ ]]; then
		event_date="${BASH_REMATCH[1]}"
		start_time="${BASH_REMATCH[2]}"
		end_time="${BASH_REMATCH[3]}"
		title_part="${BASH_REMATCH[4]}"

		# Filter out events which title is exactly "busy" that are used to block slots
		if [ "$title_part" = "busy" ]; then
			continue
		fi

		time_part="${start_time}–${end_time}"

		# Extracts the hour and minute components from the start and end time strings.
		# Assumes times are in "HH:MM" format:
		# - start_hour / end_hour receive everything before the colon
		# - start_min / end_min receive everything after the colon
		# These variables can then be used for comparisons or formatted time handling.
		start_hour=${start_time%%:*}
		start_min=${start_time##*:}
		end_hour=${end_time%%:*}
		end_min=${end_time##*:}

		# Converts start and end times from separate hour/minute strings into "minutes since midnight".
		# `10#` forces base-10 parsing for each numeric part, preventing leading-zero values
		# (e.g., "08", "09") from being treated as octal.
		# Resulting totals are useful for straightforward time math and comparisons.
		start_total_minutes=$((10#$start_hour * 60 + 10#$start_min))
		end_total_minutes=$((10#$end_hour * 60 + 10#$end_min))

		is_all_day=0
		if [ "$start_time" = "00:00" ] && [ "$end_time" = "23:59" ]; then
			is_all_day=1
		fi

		if [ "${#title_part}" -gt 20 ]; then
			title_part="${title_part:0:20}..."
		fi

		# Prefer an all-day event that starts today.
		if [ $is_all_day -eq 1 ] && [ "$event_date" = "$today" ] && [ -z "$today_all_day_event" ]; then
			today_all_day_event="$title_part"
		fi

		# Fallback to the oldest all-day event still happening today.
		if [ $is_all_day -eq 1 ] && [ -z "$all_day_event" ]; then
			all_day_event="$title_part"
		fi

		# Capture first specific-time event for today
		if [ $is_all_day -eq 0 ] && [ "$event_date" = "$today" ] && [ -z "$today_event" ]; then
			today_event="${title_part} (${start_time})"
		fi

		# Capture first specific-time event for tomorrow
		if [ $is_all_day -eq 0 ] && [ "$event_date" = "$tomorrow" ] && [ -z "$tomorrow_event" ]; then
			tomorrow_event="${title_part} (${start_time})"
			tomorrow_event_start_minutes=$start_total_minutes
		fi
	fi
done <<<"$EVENTS"

# Determine next event info
next_event_info=""
if [ -n "$today_event" ]; then
	next_event_info="$today_event"
elif [ -n "$tomorrow_event" ]; then
	minutes_until_tomorrow_event=$((24 * 60 - now_total_minutes + tomorrow_event_start_minutes))
	if ((minutes_until_tomorrow_event <= TOMORROW_EVENT_WINDOW_HOURS * 60)); then
		next_event_info="$tomorrow_event"
	fi
elif [ -n "$today_all_day_event" ]; then
	next_event_info="$today_all_day_event"
elif [ -n "$all_day_event" ]; then
	next_event_info="$all_day_event"
fi

sketchybar -m --set ical label="$next_event_info"

if [ -n "$next_event_info" ]; then
	sketchybar -m --set clock \
		label.y_offset=8 \
		label.font="SF Pro:Semibold:13.0"
else
	sketchybar -m --set clock \
		label.y_offset=-2 \
		label.font="SF Pro:Semibold:15.0"
fi
