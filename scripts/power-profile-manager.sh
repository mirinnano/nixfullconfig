#!/usr/bin/env bash

# Power Profile Manager
# Automatically switches power profiles based on system state

LOG_FILE="/tmp/power-profile-manager.log"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Check if on AC power
is_on_ac() {
    if [ -d /sys/class/power_supply/AC ]; then
        grep -q "1" /sys/class/power_supply/AC/online 2>/dev/null
    elif [ -d /sys/class/power_supply/ADP1 ]; then
        grep -q "1" /sys/class/power_supply/ADP1/online 2>/dev/null
    else
        # Desktop - assume always on AC
        return 0
    fi
}

# Check if gaming (Steam or game processes running)
is_gaming() {
    pgrep -x "steam" >/dev/null || \
    pgrep -f "steam_app_" >/dev/null || \
    pgrep -x "lutris" >/dev/null || \
    pgrep -x "gamescope" >/dev/null
}

# Get current governor
get_governor() {
    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown"
}

# Set power profile via auto-cpufreq
set_profile() {
    local profile=$1
    log "Switching to $profile profile"

    case $profile in
        performance)
            # Force performance mode
            systemctl restart auto-cpufreq.service
            dunstify "Power Profile" "Performance mode activated" -t 2000 -i battery-full
            ;;
        powersave)
            # Force powersave mode
            systemctl restart auto-cpufreq.service
            dunstify "Power Profile" "Powersave mode activated" -t 2000 -i battery-low
            ;;
        balanced)
            # Let auto-cpufreq decide
            systemctl restart auto-cpufreq.service
            dunstify "Power Profile" "Balanced mode activated" -t 2000 -i battery-good
            ;;
    esac
}

# Main logic
main() {
    local current_governor=$(get_governor)
    log "Current governor: $current_governor"

    if is_gaming; then
        log "Gaming detected, ensuring performance mode"
        if [ "$current_governor" != "performance" ]; then
            set_profile performance
        fi
    elif ! is_on_ac; then
        log "On battery power, ensuring powersave mode"
        if [ "$current_governor" != "powersave" ]; then
            set_profile powersave
        fi
    else
        log "On AC power, balanced mode"
        # Let auto-cpufreq handle it normally
    fi
}

# Run once or in daemon mode
if [ "$1" = "--daemon" ]; then
    log "Starting power profile manager daemon"
    while true; do
        main
        sleep 30  # Check every 30 seconds
    done
else
    main
fi
