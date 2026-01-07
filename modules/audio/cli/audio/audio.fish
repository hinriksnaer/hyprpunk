# Audio device management commands

function audio --description "Audio device management"
    if contains -- "$argv[1]" --help -h
        printf "Audio device management\n"
        printf "\n"
        printf "Control audio sinks and set default output device.\n"
        return 0
    end
    _show_command_help audio
end

# Check if wpctl is available
function _require_wpctl
    if not command -v wpctl >/dev/null 2>&1
        printf "Error: wpctl not installed (part of wireplumber)\n" >&2
        printf "Run: fedpunk module deploy audio\n" >&2
        return 1
    end
    return 0
end

function devices --description "List audio output devices"
    if contains -- "$argv[1]" --help -h
        printf "List all audio output devices (sinks)\n"
        printf "\n"
        printf "Usage: fedpunk audio devices\n"
        printf "\n"
        printf "The default device is marked with *\n"
        return 0
    end

    _require_wpctl; or return 1

    printf "Audio Output Devices:\n"
    printf "─────────────────────\n"
    # Parse wpctl status output for audio sinks
    wpctl status | awk '/Audio/,/Video/' | awk '/Sinks:/,/Sources:/' | grep '\[vol:' | while read -l line
        set -l is_default "no"
        if string match -q '*\**' "$line"
            set is_default "yes"
        end
        # Remove tree characters and whitespace prefix
        set -l clean_line (echo "$line" | string replace -ra '^[│├└─\s]+' '')
        # Parse: "* 44. Device Name [vol: 0.00]" or "44. Device Name [vol: 0.00]"
        set -l clean_line (echo "$clean_line" | string replace -r '^\*\s*' '')
        # Extract ID (number before first dot)
        set -l id (echo "$clean_line" | string match -r '^(\d+)\.' | tail -1)
        # Extract everything between "ID. " and " [vol:"
        set -l name (echo "$clean_line" | string replace -r '^\d+\.\s*' '' | string replace -r '\s*\[vol:.*' '')
        # Extract volume
        set -l vol (echo "$line" | string match -r '\[vol: ([0-9.]+)' | tail -1)
        if test -z "$vol"
            set vol "0"
        end
        set -l vol_pct (math "round($vol * 100)")

        if test "$is_default" = "yes"
            printf "  * [%s] %s (%d%%)\n" "$id" "$name" "$vol_pct"
        else
            printf "    [%s] %s (%d%%)\n" "$id" "$name" "$vol_pct"
        end
    end
end

function select --description "Select audio output device"
    if contains -- "$argv[1]" --help -h
        printf "Select audio output device for volume control and playback\n"
        printf "\n"
        printf "Usage: fedpunk audio select\n"
        printf "\n"
        printf "This will:\n"
        printf "  - Set the device as default for new audio\n"
        printf "  - Move all currently playing audio to this device\n"
        printf "  - Volume buttons will control this device\n"
        return 0
    end

    _require_wpctl; or return 1

    # Build list of sinks
    set -l sinks
    set -l sink_ids
    set -l raw_lines (wpctl status | awk '/Audio/,/Video/' | awk '/Sinks:/,/Sources:/' | grep '\[vol:')

    for line in $raw_lines
        set -l is_current ""
        if string match -q '*\**' "$line"
            set is_current " (current)"
        end
        set -l clean_line (echo "$line" | string replace -ra '^[│├└─\s]+' '' | string replace -r '^\*\s*' '')
        set -l id (echo "$clean_line" | string match -r '^(\d+)\.' | tail -1)
        set -l name (echo "$clean_line" | string replace -r '^\d+\.\s*' '' | string replace -r '\s*\[vol:.*' '')
        set -a sinks "[$id] $name$is_current"
        set -a sink_ids "$id"
    end

    if test (count $sinks) -eq 0
        printf "No audio devices found\n" >&2
        return 1
    end

    # Use ui-choose for interactive selection (same style as wifi)
    set -l selection (ui-choose --header "Select audio output:" $sinks)
    or return 1

    # Extract ID from selection
    set -l selected_id (echo "$selection" | string match -r '^\[(\d+)\]' | tail -1)

    if test -z "$selected_id"
        printf "Could not parse device ID\n" >&2
        return 1
    end

    # Set as default for new streams
    wpctl set-default $selected_id

    # Get the pactl sink ID that corresponds to the wpctl node ID
    # After setting default, @DEFAULT_SINK@ will point to the right sink
    set -l pactl_sink_id (pactl get-default-sink 2>/dev/null)

    # Move all active playback streams to this sink
    set -l moved 0
    if test -n "$pactl_sink_id"
        for stream_id in (pactl list short sink-inputs 2>/dev/null | awk '{print $1}')
            pactl move-sink-input $stream_id "$pactl_sink_id" 2>/dev/null
            and set moved (math $moved + 1)
        end
    end

    set -l device_name (echo "$selection" | string replace -r '^\[\d+\]\s*' '' | string replace ' (current)' '')
    printf "Audio output: %s\n" "$device_name"
    if test $moved -gt 0
        printf "Moved %d active stream(s)\n" $moved
    end
end

function set-default --description "Set default audio device by ID"
    if contains -- "$argv[1]" --help -h
        printf "Set default audio output device by ID\n"
        printf "\n"
        printf "Usage: fedpunk audio set-default <device-id>\n"
        printf "\n"
        printf "Get device IDs from 'fedpunk audio devices'\n"
        return 0
    end

    set -l device_id $argv[1]
    if test -z "$device_id"
        printf "Error: device ID required\n" >&2
        printf "Usage: fedpunk audio set-default <device-id>\n" >&2
        printf "\nRun 'fedpunk audio devices' to see available devices\n" >&2
        return 1
    end

    _require_wpctl; or return 1

    wpctl set-default $device_id
    if test $status -eq 0
        printf "Default audio output set to device %s\n" "$device_id"
    else
        printf "Failed to set default device\n" >&2
        return 1
    end
end

function info --description "Show current audio status"
    if contains -- "$argv[1]" --help -h
        printf "Show current audio status and default devices\n"
        printf "\n"
        printf "Usage: fedpunk audio info\n"
        return 0
    end

    _require_wpctl; or return 1

    printf "Audio Status\n"
    printf "════════════\n\n"

    # Get default sink info
    set -l default_sink (wpctl status | awk '/Sinks:/,/Sources:/' | grep '\*' | head -1)
    if test -n "$default_sink"
        set -l name (echo "$default_sink" | sed 's/.*[0-9]\+\.\s*//' | sed 's/\s*\[vol:.*//')
        set -l vol (echo "$default_sink" | grep -oP '\[vol: \K[0-9.]+' || echo "0")
        set -l vol_pct (math "round($vol * 100)")
        printf "Default Output: %s (%d%%)\n" "$name" "$vol_pct"
    else
        printf "Default Output: None set\n"
    end

    # Get default source info
    set -l default_source (wpctl status | awk '/Sources:/,/Filters:/' | grep '\*' | head -1)
    if test -n "$default_source"
        set -l name (echo "$default_source" | sed 's/.*[0-9]\+\.\s*//' | sed 's/\s*\[vol:.*//')
        printf "Default Input:  %s\n" "$name"
    end

    printf "\n"

    # Show active streams
    set -l streams (wpctl status | awk '/Streams:/,/^$/' | grep -E '^\s+[0-9]+\.' | head -5)
    if test -n "$streams"
        printf "Active Streams:\n"
        echo "$streams" | while read -l line
            set -l name (echo "$line" | sed 's/.*[0-9]\+\.\s*//')
            printf "  - %s\n" "$name"
        end
    end
end

function volume --description "Get or set volume"
    if contains -- "$argv[1]" --help -h
        printf "Get or set volume for default output\n"
        printf "\n"
        printf "Usage: fedpunk audio volume [level]\n"
        printf "\n"
        printf "Examples:\n"
        printf "  fedpunk audio volume       # Show current volume\n"
        printf "  fedpunk audio volume 50    # Set to 50%%\n"
        printf "  fedpunk audio volume +10   # Increase by 10%%\n"
        printf "  fedpunk audio volume -10   # Decrease by 10%%\n"
        return 0
    end

    _require_wpctl; or return 1

    set -l level $argv[1]

    if test -z "$level"
        # Show current volume
        set -l vol_info (wpctl get-volume @DEFAULT_AUDIO_SINK@)
        set -l vol (echo "$vol_info" | awk '{print $2}')
        set -l vol_pct (math "round($vol * 100)")
        set -l muted (echo "$vol_info" | grep -q "MUTED" && echo " (muted)" || echo "")
        printf "Volume: %d%%%s\n" "$vol_pct" "$muted"
    else
        # Set volume
        if string match -qr '^[+-]' "$level"
            # Relative adjustment
            wpctl set-volume @DEFAULT_AUDIO_SINK@ "$level%"
        else
            # Absolute value (convert to decimal)
            set -l decimal_vol (math "$level / 100")
            wpctl set-volume @DEFAULT_AUDIO_SINK@ $decimal_vol
        end

        # Show new volume
        set -l vol_info (wpctl get-volume @DEFAULT_AUDIO_SINK@)
        set -l vol (echo "$vol_info" | awk '{print $2}')
        set -l vol_pct (math "round($vol * 100)")
        printf "Volume set to: %d%%\n" "$vol_pct"
    end
end

function mute --description "Toggle mute"
    if contains -- "$argv[1]" --help -h
        printf "Toggle mute on default output\n"
        printf "\n"
        printf "Usage: fedpunk audio mute\n"
        return 0
    end

    _require_wpctl; or return 1

    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    set -l vol_info (wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if echo "$vol_info" | grep -q "MUTED"
        printf "Audio muted\n"
    else
        printf "Audio unmuted\n"
    end
end

function gui --description "Open PulseAudio Volume Control"
    if contains -- "$argv[1]" --help -h
        printf "Open pavucontrol GUI for advanced audio control\n"
        printf "\n"
        printf "Usage: fedpunk audio gui\n"
        return 0
    end

    if not command -v pavucontrol >/dev/null 2>&1
        printf "Error: pavucontrol not installed\n" >&2
        printf "Run: fedpunk module deploy audio\n" >&2
        return 1
    end

    pavucontrol &
    disown
    printf "Launched PulseAudio Volume Control\n"
end
