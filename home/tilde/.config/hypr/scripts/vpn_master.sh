#!/bin/bash

# =======================================================
# VPN MASTER SCRIPT
# Handles reliable VPN switching/disconnection via nmcli.
# =======================================================

ACTION=$1

# --- USER CONFIGURATION: EXACT CONNECTION NAMES ---
PRIMARY_VPN_NAME="USA, Utah" 

declare -A VPN_MAP=(
    [1]="Estonia, Tallinn S4"
    [2]="Finland, Helsinki S5"
    [3]="France, Paris S5"
    [4]="Hungary, Budapest S1"
    [5]="USA, Utah"
)
VPN_DEVICE_NAME="tun0" 
# -----------------------------------------------------------

# --- FUNCTION: DISCONNECT ALL ACTIVE VPNs (UUID is most reliable) ---
disconnect_all() {
    # Get UUIDs of active VPN connections
    ACTIVE_VPN_UUIDS=$(nmcli -t -f UUID,TYPE,STATE con show --active | grep 'vpn:activated' | awk -F: '{print $1}')
    DISCONNECTED=0

    # 1. Iterate through UUIDs and disconnect
    if [ ! -z "$ACTIVE_VPN_UUIDS" ]; then
        for uuid in $ACTIVE_VPN_UUIDS; do
            nmcli con down uuid "$uuid" 2>/dev/null
            DISCONNECTED=1
        done
    fi
    
    # 2. Fallback device disconnect (if nmcli con down failed)
    if [ "$DISCONNECTED" -eq 0 ] || [ $(nmcli -t -f TYPE,STATE con show --active | grep 'vpn:activated' | wc -l) -gt 0 ]; then
        if ip link show $VPN_DEVICE_NAME 2>/dev/null | grep -q "state UP"; then
            nmcli device disconnect "$VPN_DEVICE_NAME" 2>/dev/null
            notify-send "VPN Controller" "VPN forcefully disconnected via interface ($VPN_DEVICE_NAME)."
            return 0
        fi
    fi

    if [ "$DISCONNECTED" -eq 1 ]; then
        notify-send "VPN Controller" "Previous VPN connection disconnected."
    fi
    
    return 0
}


# --- 1. ACTION: 'off' (Win + Shift + V) ---
if [ "$ACTION" == "off" ]; then
    disconnect_all
    notify-send "VPN Status" "All VPN connections disconnected."
    exit 0
fi


# --- 2. ACTION: 'toggle' (Win + V) ---
if [ "$ACTION" == "toggle" ]; then
    STATUS=$(nmcli con show "$PRIMARY_VPN_NAME" | grep "GENERAL.STATE" | awk '{print $2}')
    
    if [ "$STATUS" == "activated" ]; then
        nmcli con down "$PRIMARY_VPN_NAME"
        notify-send "VPN Status" "$PRIMARY_VPN_NAME disconnected."
    else
        disconnect_all
        nmcli con up "$PRIMARY_VPN_NAME"
        notify-send "VPN Status" "Connecting to $PRIMARY_VPN_NAME..."
    fi
    exit 0
fi

# --- 3. ACTION: '1' through '5' (Win + 1-5) ---
if [ "$ACTION" -ge 1 ] && [ "$ACTION" -le 5 ]; then
    SERVER_NAME="${VPN_MAP[$ACTION]}"

    disconnect_all
    
    nmcli con up "$SERVER_NAME"
    notify-send "VPN Status" "Connecting to $SERVER_NAME (Server $ACTION)..."
    exit 0
fi
