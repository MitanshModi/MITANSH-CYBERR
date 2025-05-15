#!/bin/bash

echo "🔍 Keylogger Detection Script - Linux"
echo "===================================="

# 1. Check for suspicious processes
echo "Checking for suspicious processes..."
suspicious_processes=("logkeys" "lkl" "uberkey" "keylogger" "pykeylogger")
for proc in "${suspicious_processes[@]}"; do
    if pgrep -x "$proc" > /dev/null; then
        echo "⚠️  Suspicious process detected: $proc"
    fi
done

# 2. Check who is accessing /dev/input
echo -e "\nScanning /dev/input for unauthorized access..."
lsof /dev/input/* 2>/dev/null | grep -vE "Xorg|X|gdm|gnome-session|lightdm"

# 3. Detect hidden processes
echo -e "\nChecking for hidden processes..."
ps -ef | grep -vE "bash|ps|grep" | while read user pid rest; do
    if [ ! -d /proc/$pid ]; then
        echo "⚠️  Possible hidden process: PID $pid"
    fi
done

# 4. Search home directories
echo -e "\nSearching home directories for keylogger files..."
find /home -type f \( -iname "*keylog*" -o -iname "*logkeys*" \) 2>/dev/null

echo -e "\n✅ Scan complete."
