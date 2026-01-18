#!/bin/zsh

# --- Configuration ---
CACHE_DIR="$HOME/.cache/waybar"
CACHE_FILE="$CACHE_DIR/weather.txt"
TTL_SECONDS=900 # Update every 15 minutes
# -------------------

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

# Get current time and cache file time
CURRENT_TIME=$(date +%s)

# Check if cache file exists
if [ -f "$CACHE_FILE" ]; then
  # Get modification time of the cache file (Stat -c %Y format is Linux specific)
  CACHED_TIME=$(stat -c %Y "$CACHE_FILE")
  TIME_DIFF=$((CURRENT_TIME - CACHED_TIME))

  # If cache is fresh (less than TTL), use it
  if [ "$TIME_DIFF" -lt "$TTL_SECONDS" ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

# If we are here, the cache is old or missing. Fetch new data.
# -s for silent, --max-time to prevent hanging.
WEATHER=$(curl -s --max-time 10 'https://wttr.in/?format=%c+%f' 2>/dev/null)

if [ -n "$WEATHER" ]; then
  # If fetch succeeded: Save to cache AND print to screen
  echo "$WEATHER" >"$CACHE_FILE"
  echo "$WEATHER"
else
  # If fetch failed: Read the OLD cache file (if it exists).
  # We do NOT overwrite the file here, so the timestamp remains,
  # ensuring we try to update again on the next interval.
  if [ -f "$CACHE_FILE" ]; then
    cat "$CACHE_FILE"
  else
    # Fallback if no cache exists and offline
    echo "Offline"
  fi
fi
