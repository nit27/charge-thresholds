#!/bin/bash

# Define normal thresholds
NORMAL_START_THRESHOLD=50
NORMAL_STOP_THRESHOLD=80

if [ "$1" == "full" ]; then
    # Set thresholds to force charge to 100%
    echo 100 > /sys/class/power_supply/BAT0/charge_stop_threshold
    echo 0 > /sys/class/power_supply/BAT0/charge_start_threshold
    echo "Charging set to 100%."

elif [ "$1" == "normal" ]; then
    # Revert to normal thresholds
    echo $NORMAL_START_THRESHOLD > /sys/class/power_supply/BAT0/charge_start_threshold
    echo $NORMAL_STOP_THRESHOLD > /sys/class/power_supply/BAT0/charge_stop_threshold
    echo "Reverted to normal charging thresholds (50% to 80%)."

elif [ "$1" == "status" ]; then
    # Display current charging thresholds and status
    CURRENT_START=$(cat /sys/class/power_supply/BAT0/charge_start_threshold)
    CURRENT_STOP=$(cat /sys/class/power_supply/BAT0/charge_stop_threshold)
    echo "Current Charge Start Threshold: ${CURRENT_START}%"
    echo "Current Charge Stop Threshold: ${CURRENT_STOP}%"
    cat /sys/class/power_supply/BAT0/uevent | grep POWER_SUPPLY_STATUS

else
    echo "Usage: $0 {full|normal|status}"
fi

