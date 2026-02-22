# keep_active_mac

Prevents your Mac from sleeping and simulates mouse activity at a configurable interval. Useful for keeping sessions alive (SSH, meetings, CI dashboards, etc.) when you need to step away.

## How it works

- Runs `caffeinate` in the background to block display and system sleep.
- Every N seconds, moves the mouse cursor one pixel and back using macOS CoreGraphics — enough to register as user activity without visibly moving the pointer.
- Logs a timestamp each time activity is simulated.
- Cleans up `caffeinate` automatically when stopped.

## Requirements

- macOS
- Python 3 (pre-installed on modern macOS)
- No third-party dependencies

## Usage

```bash
# Make executable (first time only)
chmod +x keep_active.sh

# Run with default interval (60 seconds)
./keep_active.sh

# Run with a custom interval (e.g., every 30 seconds)
./keep_active.sh 30
```

Press `Ctrl+C` to stop. The script will kill the background `caffeinate` process and exit cleanly.

## Example output

```
Starting keep-active script (interval: 60s). Press Ctrl+C to stop.
Running — will simulate activity every 60 seconds.
[14:02:01] Activity simulated. Next in 60s...
[14:03:01] Activity simulated. Next in 60s...
^C
Stopping keep-active script...
```
