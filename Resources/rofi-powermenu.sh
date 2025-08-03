#!/bin/bash

# Function to add options to the DECLARED_OPTIONS array
declare -a DECLARED_OPTIONS
add_option() {
    local label="$1"
    local icon="$2"
    local cmd="$3"
    declare -A option
    option["label"]="$label"
    option["icon"]="$icon"
    option["cmd"]="$cmd"
    DECLARED_OPTIONS+=("$(declare -p option)")
}

# Add options to the DECLARED_OPTIONS array
add_option "Terminal"     "kitty"                "kitty"
add_option "Lock"         "emblem-locked"        "xfce4-session-logout -u"
add_option "Log Out"      "system-log-out"       "xfce4-session-logout -f"
add_option "Restart"      "system-restart"       "xfce4-session-logout -r"
add_option "Shutdown"     "system-shutdown"      "systemctl poweroff"
add_option "Task Manager" "org.xfce.taskmanager" "xfce4-taskmanager"
add_option "Settings"     "systemsettings"       "xfce4-settings-manager"

# Construct the MENU for rofi
MENU=""
for declared_option in "${DECLARED_OPTIONS[@]}"; do
    eval "$declared_option"
    MENU+="${option["label"]}\0icon\x1f${option["icon"]}\n"
done

# Get the selected option from rofi
selected_option=$(echo -en "$MENU" | rofi -dmenu -show-icons -l 7 -p "Power Menu")

# Find the corresponding command based on the label
if [ -n "$selected_option" ]; then
    # Loop through options to find the matching label and execute the corresponding command
    for declared_option in "${DECLARED_OPTIONS[@]}"; do
        eval "$declared_option"
        if [ "${option["label"]}" == "$selected_option" ]; then
            echo "Executing: ${option["cmd"]}"
            eval "${option["cmd"]}"
            break
        fi
    done
fi