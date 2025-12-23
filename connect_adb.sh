#!/bin/bash
# Get the Windows host IP
# Try obtaining from ip route (default gateway usually points to Windows host in WSL2)
WINDOWS_IP=$(ip route show | grep default | awk '{print $3}')

if [ -z "$WINDOWS_IP" ]; then
    # Fallback to resolv.conf if ip route fails
    WINDOWS_IP=$(grep nameserver /etc/resolv.conf | cut -d ' ' -f 2)
fi

# Set the ADB server socket environment variable
export ADB_SERVER_SOCKET=tcp:$WINDOWS_IP:5037

echo "Configured ADB to connect to Windows at $WINDOWS_IP:5037"
echo "Testing connection..."
adb devices

echo "
To use this configuration in your current shell, run:
  source ./connect_adb.sh
OR
  . ./connect_adb.sh
"
