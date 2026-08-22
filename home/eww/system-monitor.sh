#!/usr/bin/env bash

# 1. CPU Usage Calculation
read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
cpu_active=$((user + nice + system + irq + softirq + steal))
cpu_total=$((cpu_active + idle + iowait))

sleep 0.5

read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
cpu_active_2=$((user + nice + system + irq + softirq + steal))
cpu_total_2=$((cpu_active_2 + idle + iowait))

diff_active=$((cpu_active_2 - cpu_active))
diff_total=$((cpu_total_2 - cpu_total))
cpu_usage=$(( 100 * diff_active / diff_total ))

# 2. RAM Usage Calculation
ram_total=$(free -m | awk '/Mem:/ {print $2}')
ram_used=$(free -m | awk '/Mem:/ {print $3}')
ram_percent=$(( 100 * ram_used / ram_total ))

# 3. GPU Usage Detection (AMD / NVIDIA / Intel)
gpu_usage=0
if command -v nvidia-smi &>/dev/null; then
  gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0)
elif [ -f /sys/class/drm/card0/device/gpu_busy_percent ]; then
  gpu_usage=$(cat /sys/class/drm/card0/device/gpu_busy_percent)
elif [ -f /sys/class/drm/card1/device/gpu_busy_percent ]; then
  gpu_usage=$(cat /sys/class/drm/card1/device/gpu_busy_percent)
fi

# Output as JSON
jq -n \
  --arg cpu "$cpu_usage" \
  --arg ram "$ram_percent" \
  --arg gpu "$gpu_usage" \
  '{cpu: $cpu, ram: $ram, gpu: $gpu}'
