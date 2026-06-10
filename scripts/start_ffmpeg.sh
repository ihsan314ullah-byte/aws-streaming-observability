#!/bin/bash
# ---------------------------------------
# Start FFmpeg SRT caller
# ---------------------------------------

BASE_DIR=/home/ubuntu/streaming-demo
VIDEO="$BASE_DIR/input/tempest_input.mp4"
LOG="$BASE_DIR/logs/ffmpeg.log"
PID_FILE="$BASE_DIR/logs/ffmpeg.pid"
SRT_TARGET="srt://100.25.160.219:5000?mode=caller"

# Prevent duplicate FFmpeg
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null; then
        echo "FFmpeg already running with PID $PID"
        exit 0
    fi
fi

echo "Starting FFmpeg SRT caller..."
nohup ffmpeg -re -stream_loop -1 -i "$VIDEO" -c copy -f mpegts "$SRT_TARGET" > "$LOG" 2>&1 &

# Save PID
echo $! > "$PID_FILE"
echo "FFmpeg started with PID $(cat "$PID_FILE")"
echo "Logs: $LOG"
