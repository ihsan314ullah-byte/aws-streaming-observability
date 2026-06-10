#!/bin/bash
# ---------------------------------------
# Stop FFmpeg SRT caller
# ---------------------------------------

PID_FILE=/home/ubuntu/streaming-demo/logs/ffmpeg.pid

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    echo "Stopping FFmpeg PID $PID"
    kill "$PID"
    # Wait for process to actually stop
    while ps -p "$PID" > /dev/null; do sleep 1; done
    rm "$PID_FILE"
    echo "FFmpeg stopped"
else
    echo "No FFmpeg PID found"
fi
