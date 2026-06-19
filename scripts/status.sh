#!/bin/bash
# ---------------------------------------
# Observability Status Script
# ---------------------------------------

PID_FILE=/home/ubuntu/streaming-demo/logs/ffmpeg.pid

echo "================================="
echo "STREAMING PIPELINE STATUS"
echo "================================="

# ------------------------
# FFmpeg Status
# ------------------------
echo ""
echo "[FFMPEG]"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    echo "Status: RUNNING"
    echo "PID: $PID"
else
    echo "Status: NOT RUNNING"
fi

# ------------------------
# CPU Usage
# ------------------------
echo ""
echo "[CPU]"
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
echo "Usage: $CPU %"

# ------------------------
# Memory Usage
# ------------------------
echo ""
echo "[MEMORY]"
free -m | awk 'NR==2{
    printf "Used: %s MB / %s MB (%.2f%%)\n", $3, $2, $3*100/$2
}'

# ------------------------
# Disk Usage
# ------------------------
echo ""
echo "[DISK]"
df -h / | awk 'NR==2{
    print "Used:", $3, "/", $2, "(", $5 " )"
}'

# ------------------------
# Network Check (basic)
# ------------------------
echo ""
echo "[NETWORK]"
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Internet: OK"
else
    echo "Internet: DOWN"
fi

echo ""
echo "================================="
