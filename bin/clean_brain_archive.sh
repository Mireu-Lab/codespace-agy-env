#!/usr/bin/env bash
# ==============================================================================
# Brain Directory Cleanup and Archive
# Compresses old session directories in brain/ into .zip archives and removes raw dirs
# ==============================================================================
set -euo pipefail

BRAIN_DIR="${HOME}/.gemini/antigravity-cli/brain"
LOG_FILE="${HOME}/.gemini/antigravity-cli/brain_cleanup.log"

mkdir -p "$(dirname "$LOG_FILE")"

TIMESTAMP=$(date -u '+%Y-%m-%d %H:%M:%S UTC')
echo "[$TIMESTAMP] Starting brain directory cleanup and archive..." >> "$LOG_FILE"

if [ ! -d "$BRAIN_DIR" ]; then
    echo "[$TIMESTAMP] Brain directory $BRAIN_DIR does not exist. Skipping." >> "$LOG_FILE"
    exit 0
fi

cd "$BRAIN_DIR"

shopt -s nullglob
for dir in */; do
    dir="${dir%/}"
    if [ -d "$dir" ]; then
        zip_name="${dir}.zip"
        echo "[$TIMESTAMP] Archiving brain folder: $dir -> $zip_name" >> "$LOG_FILE"
        if zip -r "$zip_name" "$dir" >> "$LOG_FILE" 2>&1; then
            rm -rf "$dir"
            echo "[$TIMESTAMP] Successfully zipped and removed directory: $dir" >> "$LOG_FILE"
        else
            echo "[$TIMESTAMP] ERROR: Failed to zip directory: $dir" >> "$LOG_FILE"
        fi
    fi
done
shopt -u nullglob

echo "[$TIMESTAMP] Brain cleanup completed." >> "$LOG_FILE"
