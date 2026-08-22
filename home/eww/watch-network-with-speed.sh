#!/usr/bin/env bash

# Function to get active network interface
get_interface() {
  ip route | awk '/default/ {print $5; exit}'
}

# Pure Bash speed formatter (No 'bc' or external utilities required)
format_speed() {
  local bytes=$1
  if [ "$bytes" -ge 1048576 ]; then
    # MB/s calculation with 1 decimal place using integer math
    local mb=$((bytes / 1048576))
    local mb_decimal=$(( (bytes % 1048576) * 10 / 1048576 ))
    echo "${mb}.${mb_decimal} MB/s"
  elif [ "$bytes" -ge 1024 ]; then
    # KB/s calculation
    local kb=$((bytes / 1024))
    echo "${kb} KB/s"
  else
    echo "${bytes} B/s"
  fi
}

get_connection_name() {
  local iface=$1
  if [ -z "$iface" ]; then
    echo "󰤭  Disconnected"
    return
  fi

  # Check Wi-Fi
  local wifi_ssid
  wifi_ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d':' -f2)
  if [ -n "$wifi_ssid" ]; then
    echo "󰤨  $wifi_ssid"
    return
  fi

  # Check Ethernet
  if [[ "$iface" =~ ^e(th|n) ]]; then
    echo "󰈀  Ethernet"
    return
  fi

  echo "󰤨  $iface"
}

# Main loop
while true; do
  IFACE=$(get_interface)
  CONN_NAME=$(get_connection_name "$IFACE")

  if [ -n "$IFACE" ] && [ -d "/sys/class/net/$IFACE" ]; then
    R1=$(cat "/sys/class/net/$IFACE/statistics/rx_bytes")
    T1=$(cat "/sys/class/net/$IFACE/statistics/tx_bytes")

    sleep 1

    R2=$(cat "/sys/class/net/$IFACE/statistics/rx_bytes")
    T2=$(cat "/sys/class/net/$IFACE/statistics/tx_bytes")

    TBPS=$((T2 - T1))
    RBPS=$((R2 - R1))

    DOWN=$(format_speed $RBPS)
    UP=$(format_speed $TBPS)

    echo "$CONN_NAME  │  ↓ $DOWN  ↑ $UP"
  else
    echo "󰤭  Disconnected"
    sleep 2
  fi
done
