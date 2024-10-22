## A custom script for modifying charging thresholds on Linux

### Why?
I find that `TLP` and `cpu-autofreq` are useless for my laptop, so I decide to use GNOME's default daemon power profile as it perfectly work on my machine. When I want to change the performance behaviours of my system, just simply switch between `Performance`, `Balanced`, and `Power Saver`. The CPU's frequency will do their jobs. However, GNOME's power profile doesn't have options to change charging thresholds for a longer-lasting batteries. That is the reson why I make this script for manually managing charging thresholds.

### When?
- For optimising battery life, I set `NORMAL_START_THRESHOLD=50` and `NOMAL_STOP_THRESHOLD=80`. I believe this is the safe charging range, you can set as you wish. It means it will start charging the battery when its level below 50% and stop charging when it reaches 80%.
- If you're about to go out? No problem! With a single command will force it to full charge 100%.

### How?
- Create a script in the following directory by this command:
```sudo vi /usr/local/bin/manage-charge-thresholds.sh```

- Add the following script on that file:

```
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
 ```

- Change permission for this script:
 ```sudo chmod +x /usr/local/bin/manage-charge-thresholds.sh```

- Add aliases:
 ```sudo vi ~/.bashrc```

```
alias charge-full='sudo /usr/local/bin/manage-charge-thresholds.sh full'
alias charge-normal='sudo /usr/local/bin/manage-charge-thresholds.sh normal'
alias charge-status='sudo /usr/local/bin/manage-charge-thresholds.sh status'
```
- Source `.bashrc`:
 ```source ~/.bashrc```

### Usage
- Check current threshold status:
 ```charge-status```
- Active thresholds
```charge-normal```
- Force to full charge (100%):
```charge-full```
