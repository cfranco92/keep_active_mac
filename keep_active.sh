#!/bin/bash
# keep_active.sh — Prevents Mac sleep and simulates user activity
# Usage: ./keep_active.sh [interval_seconds]
#   interval_seconds: how often to simulate activity (default: 60)

INTERVAL=${1:-60}

echo "Starting keep-active script (interval: ${INTERVAL}s). Press Ctrl+C to stop."

# Prevent display and system sleep in the background
caffeinate -d -i &
CAFFEINATE_PID=$!

cleanup() {
    echo ""
    echo "Stopping keep-active script..."
    kill "$CAFFEINATE_PID" 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

simulate_activity() {
    python3 - <<'PYEOF'
import ctypes, ctypes.util, time

cg = ctypes.cdll.LoadLibrary(ctypes.util.find_library('CoreGraphics'))

class CGPoint(ctypes.Structure):
    _fields_ = [('x', ctypes.c_double), ('y', ctypes.c_double)]

cg.CGEventCreate.restype = ctypes.c_void_p
cg.CGEventCreate.argtypes = [ctypes.c_void_p]
cg.CGEventGetLocation.restype = CGPoint
cg.CGEventGetLocation.argtypes = [ctypes.c_void_p]
cg.CGEventCreateMouseEvent.restype = ctypes.c_void_p
cg.CGEventCreateMouseEvent.argtypes = [ctypes.c_void_p, ctypes.c_uint32, CGPoint, ctypes.c_uint32]
cg.CGEventPost.restype = None
cg.CGEventPost.argtypes = [ctypes.c_uint32, ctypes.c_void_p]

pos = cg.CGEventGetLocation(cg.CGEventCreate(None))
x, y = pos.x, pos.y

# kCGEventMouseMoved=5, kCGHIDEventTap=0
for cx in (x + 1, x):
    e = cg.CGEventCreateMouseEvent(None, 5, CGPoint(cx, y), 0)
    cg.CGEventPost(0, e)
    time.sleep(0.1)
PYEOF
}

echo "Running — will simulate activity every ${INTERVAL} seconds."

while true; do
    simulate_activity
    echo "[$(date '+%H:%M:%S')] Activity simulated. Next in ${INTERVAL}s..."
    sleep "$INTERVAL"
done
