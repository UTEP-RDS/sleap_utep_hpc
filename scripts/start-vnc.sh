#!/bin/bash

# 1. Clean up old locks from previous runs
rm -rf /tmp/.X11-unix /tmp/.X1-lock /root/.vnc/*.log /root/.vnc/*.pid > /dev/null 2>&1

# 2. Start DBus (Crucial for SLEAP/Qt communication)
mkdir -p /var/run/dbus
dbus-daemon --system --fork || true

# 3. Start VNC server 
# This automatically runs the /root/.vnc/xstartup script we built above
vncserver $DISPLAY -geometry $RESOLUTION -depth 24

echo "----------------------------------------------------------------"
echo "VNC Server is running! Connect to localhost:5901"
echo "If SLEAP fails to open, run 'sleap-gui' in the VNC terminal."
echo "----------------------------------------------------------------"

# 4. Stream the logs to your PowerShell window
tail -f /root/.vnc/*.log