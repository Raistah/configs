get_net() {
  # Check Wi-Fi SSID
  wifi_ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d':' -f2)

  if [ -n "$wifi_ssid" ]; then
    echo "󰤨  $wifi_ssid"
    return
  fi

  # Check Ethernet connection
  eth_state=$(nmcli -t -f TYPE,STATE dev 2>/dev/null | grep '^ethernet:connected')

  if [ -n "$eth_state" ]; then
    echo "󰈀  Ethernet"
    return
  fi

  # Disconnected state
  echo "󰤭  Disconnected"
}

# Output initial state
get_net

# Listen for NetworkManager changes in real-time
nmcli monitor | while read -r _; do
  get_net
done
