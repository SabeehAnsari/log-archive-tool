#!/bin/bash
# log-archive.sh - Compresses a log directory into a timestamped archive

LOG_DIR="$1"
if [ -z "$LOG_DIR" ]; then
    echo "Usage: $0 <log-directory>"
    exit 1
fi
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: directory '$LOG_DIR' does not exist"
    exit 1
fi
echo "Archiving: $LOG_DIR"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
echo "Timestamp: $TIMESTAMP"
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
echo "Archive name: $ARCHIVE_NAME"
ARCHIVE_DIR="archives"
mkdir -p "$ARCHIVE_DIR"
if tar -czf "$ARCHIVE_DIR/$ARCHIVE_NAME" "$LOG_DIR"; then
    echo "Created: $ARCHIVE_DIR/$ARCHIVE_NAME"
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Archived $LOG_DIR to $ARCHIVE_NAME" >> "$ARCHIVE_DIR/archive.log"
else
    echo "Error: failed to create archive"
    exit 1
fi