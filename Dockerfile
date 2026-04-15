# Base SLEAP CUDA image (Ready for HPC later)
FROM eberrigan/sleap-cuda:latest

#########################################
# Install system dependencies
#########################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 xfce4-goodies tightvncserver dbus-x11 xfonts-base autocutsel wget \
    # Qt6 / PySide6 specific requirements
    libxkbcommon-x11-0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 \
    libxcb-render-util0 libxcb-shape0 libxcb-xfixes0 libxcb-xinerama0 libxcb-glx0 \
    libopengl0 libgtk-3-0 x11-xserver-utils libxcb-render0 libxcb-util1 \
    libxrender1 libxcursor1 libxcomposite1 libxi6 libxrandr2 libasound2 libnss3 \
    # CRITICAL: Missing Qt6 plugin loader
    libxcb-cursor0 \
    # Software Rendering (Mesa) for CPU-only Windows execution
    libgl1-mesa-glx libgl1-mesa-dri mesa-utils \
    && rm -rf /var/lib/apt/lists/*

#########################################
# Install SLEAP via UV
#########################################
RUN wget https://astral.sh/uv/install.sh -O install_uv.sh && sh install_uv.sh && rm install_uv.sh
ENV PATH="/root/.local/bin:${PATH}"
RUN uv tool install --python 3.11 "sleap[nn]"

#########################################
# Configure VNC & The "Gray Screen" Fix
#########################################
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# This script is what VNC runs internally to start the desktop
RUN echo "#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
autocutsel -fork\n\
exec startxfce4" > /root/.vnc/xstartup && chmod +x /root/.vnc/xstartup

# Environment variables for GUI stability
ENV DISPLAY=:1
ENV RESOLUTION=1920x1080
ENV QT_XCB_GL_INTEGRATION=none

WORKDIR /app
COPY scripts/start-vnc.sh /app/start-vnc.sh
RUN chmod +x /app/start-vnc.sh

EXPOSE 5901
ENTRYPOINT ["/app/start-vnc.sh"]